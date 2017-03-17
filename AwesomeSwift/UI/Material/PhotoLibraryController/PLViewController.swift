import UIKit

open class PLViewController:UIViewController {
    open override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        
        let controller = PLAppToolbarController(rootViewController: PhotoLibraryViewController())
        
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        controller.view.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor).isActive = true
        controller.view.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        
    }
}

