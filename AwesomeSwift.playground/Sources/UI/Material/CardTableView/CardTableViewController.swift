import UIKit
import Graph

public class CardTableViewController:UIViewController {
    public override func viewDidLoad() {
        SampleData.createSampleData()
        
        let graph = Graph()
        let search = Search<Entity>(graph: graph).for(types: "Category")
        
        var viewControllers = [PostsViewController]()
        
        for category in search.sync() {
            if let name = category["name"] as? String {
                viewControllers.append(PostsViewController(category: name))
            }
        }
        
        let pageTabBarController = AppPageTabBarController(viewControllers: viewControllers)
        let toolbarController = AppToolbarController(rootViewController: pageTabBarController)
        let menuController = AppFABMenuController(rootViewController: toolbarController)
        
        addChildViewController(menuController)
        view.addSubview(menuController.view)
        menuController.view.translatesAutoresizingMaskIntoConstraints = false
        menuController.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        menuController.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        menuController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}

