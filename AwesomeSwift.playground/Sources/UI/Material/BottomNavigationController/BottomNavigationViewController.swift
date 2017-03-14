import UIKit

public class BottomNavigationViewController:UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = AppBottomNavigationController(viewControllers: [PhotoViewController(), VideoViewController(), AudioViewController(), RemindersViewController(), SearchViewController()])
        addChildViewController(controller)
        view.addSubview(controller.view)
        
    }
}
