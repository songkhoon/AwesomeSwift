import UIKit

public class SubmenuViewController:UIViewController {
    
    var subMenus:[String:UIViewController]?
    var classMenus:[UIButton:UIViewController] = [:]
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        setupLayout()
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 200, height: 50)
        let menuCollection = MenuCollectionViewController(collectionViewLayout: layout)
        addChildViewController(menuCollection)
        view.addSubview(menuCollection.view)
        menuCollection.view.translatesAutoresizingMaskIntoConstraints = false
        menuCollection.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        menuCollection.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        menuCollection.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuCollection.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        menuCollection.didMove(toParentViewController: self)
        
        classMenus = [:]
        var buttons = [UIButton]()
        if let subMenus = subMenus {
            for item in subMenus {
                let button = createButton(item.key)
                buttons.append(button)
                classMenus[button] = item.value
                button.addTarget(self, action: #selector(handleSubmenu(_:)), for: .touchUpInside)
            }
        }
        menuCollection.buttons = buttons
        
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSubmenu(_ sender:UIButton) {
        if let controller = classMenus[sender] {
            let navController = UINavigationController(rootViewController: controller)
            controller.title = sender.currentTitle
            controller.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(handleBack))
            present(navController, animated: true, completion: nil)
        }
        
    }

}

