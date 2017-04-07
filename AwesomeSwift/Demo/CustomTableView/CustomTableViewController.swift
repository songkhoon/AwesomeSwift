//
//  ViewController.swift
//  CustomTableView
//
//  Created by jeff on 19/01/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class CustomTableViewController: UIViewController {
    
    fileprivate let cellName = String(describing: CustomTableCell.self)
    private var isAnimated: Bool = false
    fileprivate let slideMenuAnimation = SlideMenuAnimationController()
    
    let tableDataController = TableDataController()
    
    private let navBar: UINavigationBar = {
        let view = UINavigationBar()
        view.backgroundColor = UIColor.white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let tableView: UITableView = {
        let view = UITableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var menuBarButton:UIBarButtonItem = {
        let view = UIBarButtonItem(title: "menu", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleMenu))
        return view
    }()
    
    lazy var addBarButton:UIBarButtonItem = {
        let view = UIBarButtonItem(title: "Add", style: UIBarButtonItemStyle.plain, target: self, action: #selector(handleAddItem))
        return view
    }()
    
    lazy var editBarButton:UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.edit, target: self, action: #selector(CustomTableViewController.handleEditTable))
        return view
    }()
    
    lazy var cancalBarButton:UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.cancel, target: self, action: #selector(CustomTableViewController.handleCancelEdit))
        return view
    }()
    
    lazy var saveBarButton:UIBarButtonItem = {
        let view = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.save, target: self, action: #selector(CustomTableViewController.handleSaveEdit))
        return view
    }()
    
    let deleteAllButton: UIButton = {
        let view = UIButton(type: UIButtonType.system)
        view.setTitle("Delete All", for: UIControlState.normal)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK:- UIViewController
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupNavigationController()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("viewDidAppear")
        if !isAnimated {
            isAnimated = true
            animateTable()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    // MARK:- Setup
    private func setupNavigationController() {
        navigationItem.rightBarButtonItems = [editBarButton, addBarButton]
    }
    
    private func setupNavBar() {
        self.view.addSubview(navBar)
        navBar.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        navBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        navBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        navBar.heightAnchor.constraint(equalToConstant: 54).isActive = true
        navBar.pushItem(UINavigationItem(title: "Custom Table View"), animated: false)
        navBar.topItem?.rightBarButtonItems = [editBarButton, addBarButton]
    }
    
    private func setupTableView() {
        deleteAllButton.addTarget(self, action: #selector(handleDeleteAll), for: UIControlEvents.touchUpInside)
        self.view.addSubview(deleteAllButton)
        deleteAllButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        deleteAllButton.bottomAnchor.constraint(equalTo: self.bottomLayoutGuide.topAnchor, constant: -10).isActive = true
        deleteAllButton.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.5).isActive = true
        deleteAllButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        tableView.register(CustomTableCell.self, forCellReuseIdentifier: cellName)
        tableView.separatorStyle = .none
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: self.topLayoutGuide.bottomAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: deleteAllButton.topAnchor, constant: -20).isActive = true
    }
    
    private func animateTable() {
        self.tableView.reloadData()
        let cells = self.tableView.visibleCells
        let tableHeight = self.tableView.bounds.size.height
        
        var delay:Double = 0
        for i in cells {
            i.transform = CGAffineTransform(translationX: 0, y: tableHeight)
            UIView.animate(withDuration: 0.5, delay: 0.05 * delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
                i.transform = CGAffineTransform(translationX: 0, y: 0)
            }, completion: {
                if $0 {
                    print("complete")
                }
            })
            delay += 1
        }
    }
    
    // MARK:- Handlers
    func handleMenu() {
        let slideMenu = SlideMenuController()
        slideMenu.transitioningDelegate = self
        self.present(slideMenu, animated: true) { 
            
        }
    }
    
    func handleAddItem() {
        let alert = UIAlertController(title: "New Name", message: "Add a new name", preferredStyle: UIAlertControllerStyle.alert)
        let saveAction = UIAlertAction(title: "Save", style: UIAlertActionStyle.default) { (action) in
            guard let textfield = alert.textFields?.first, let nameToSave = textfield.text else {
                return
            }
            self.tableDataController.addTableData(nameToSave)
            self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default)
        
        alert.addTextField()
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }
    
    func handleEditTable() {
        tableView.reloadData()
        tableView.isEditing = true
        navigationItem.rightBarButtonItems = [cancalBarButton, saveBarButton]
    }
    
    func handleCancelEdit() {
        tableView.isEditing = false
        navigationItem.rightBarButtonItems = [editBarButton, addBarButton]
        tableView.reloadData()
    }
    
    func handleSaveEdit() {
        tableView.isEditing = false
        navigationItem.rightBarButtonItems = [editBarButton, addBarButton]
        
        var items = [TableItem]()
        var i:Int32 = 0
        for cell in tableView.visibleCells {
            if let item = (cell as! CustomTableCell).tableItem {
                item.order = i
                items.append(item)
                i += 1
            }
        }
        tableDataController.userTable?.items = NSSet(array: items)
        tableDataController.saveContext()
        
        tableView.reloadData()
    }
    
    func handleDeleteAll() {
        tableDataController.deleteTableItem()        
        tableView.reloadData()
    }
    
    override func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return slideMenuAnimation
    }
    
    override func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
    }
    
}

extension CustomTableViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableDataController.userTableItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellName) as! CustomTableCell
        cell.tableItem = tableDataController.userTableItem[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            print("delete")
            tableDataController.deleteItem(item: tableDataController.userTableItem[indexPath.row])
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return UITableViewCellEditingStyle.delete
    }
    
    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    func colorForIndex(_ index: Int) -> UIColor {
        let itemCount = tableDataController.userTableItem.count - 1
        let color = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: color, blue: 0.0, alpha: 1.0)
    }
}
