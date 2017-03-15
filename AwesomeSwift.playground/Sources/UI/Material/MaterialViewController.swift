import UIKit

public class MaterialViewController:UIViewController {
    var menuButton = [UIButton:AnyClass]()
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        automaticallyAdjustsScrollViewInsets = false
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        
        setupLayout()
    }
    
    private func setupLayout() {
        
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = CGSize(width: 200, height: 50)
        layout.scrollDirection = .vertical
        let collectionController = MenuCollectionViewController(collectionViewLayout: layout)
        addChildViewController(collectionController)
        view.addSubview(collectionController.view)
        collectionController.didMove(toParentViewController: self)
        
        collectionController.view.translatesAutoresizingMaskIntoConstraints = false
        collectionController.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        collectionController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        collectionController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        collectionController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        menuButton = [
            createButton("Bar"):BarViewController.self,
            createButton("Button"):ButtonViewController.self,
            createButton("Bottom Navigation"):BottomNavigationViewController.self,
            createButton("Card View"):CardViewController.self,
            createButton("Card Table View"):CardTableViewController.self,
            createButton("Collection View"):MaterialCollectionViewController.self,
            createButton("Floating Action Button"):FABMenuViewController.self,
            createButton("Grid"):GridViewController.self,
            createButton("Image Card"):ImageCardViewController.self,
            createButton("Layer"):LayerViewController.self,
            createButton("Navigation Controller"):MaterialNavigationController.self,
            createButton("Navigation Drawer"):NavigationDrawerViewController.self,
            createButton("Page Tab Bar"):PageTabBarViewController.self,
            createButton("Photo Collection"):PCViewController.self
        ]
        for item in menuButton {
            item.key.addTarget(self, action: #selector(handleMenuButton(_:)), for: .touchUpInside)
        }

        collectionController.buttons = Array(menuButton.keys)

    }
    
    func handleMenuButton(_ sender:UIButton) {
        if let controller = menuButton[sender] as? UIViewController.Type {
            let rootViewController = controller.init()
            rootViewController.title = sender.currentTitle
            rootViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(self.handleBack))
            let navController = UINavigationController(rootViewController: rootViewController)
            present(navController, animated: true, completion: {
            })
        }
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
}

