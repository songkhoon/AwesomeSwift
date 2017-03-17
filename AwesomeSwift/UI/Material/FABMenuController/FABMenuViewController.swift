import UIKit

public class FABMenuViewController:UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        let controller = FABAppMenuController(rootViewController: FABRootViewController())
        addChildViewController(controller)
        view.addSubview(controller.view)
        controller.didMove(toParentViewController: self)
        
    }
}

