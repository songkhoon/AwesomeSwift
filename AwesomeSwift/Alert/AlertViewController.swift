import UIKit

public class AlertViewController:UIViewController {
    let showAlertButton:UIButton = {
        let view = UIButton()
        view.setTitle("Show Alert", for: UIControlState.normal)
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        let stackView = UIStackView()
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 10
        
        view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 1, constant: 0).isActive = true
        stackView.heightAnchor.constraint(lessThanOrEqualTo: view.heightAnchor, multiplier: 1, constant: 0).isActive = true
        
        let alertButton = createButton("Show Alert")
        alertButton.addTarget(self, action: #selector(showAlertHandler), for: .touchUpInside)
        stackView.addArrangedSubview(alertButton)
        
        let actionSheetButton = createButton("Action Sheet")
        actionSheetButton.addTarget(self, action: #selector(showActionSheetHandler), for: .touchUpInside)
        stackView.addArrangedSubview(actionSheetButton)
    }
    
    func showAlertHandler() {
        let default1Action = UIAlertAction(title: "Default1", style: UIAlertActionStyle.default) { (action) in
            print(action)
        }
        
        let default2Action = UIAlertAction(title: "Default2", style: UIAlertActionStyle.default) { (action) in
            print(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            print(action)
        }
        let destructiveAction = UIAlertAction(title: "Destructive", style: UIAlertActionStyle.destructive) { (action) in
            print(action)
        }
        
        let alertController =  UIAlertController(title: "Alert Controller Title", message: "Alert Controller Message", preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(default1Action)
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
        alertController.addAction(default2Action)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showActionSheetHandler() {
        let default1Action = UIAlertAction(title: "Default1", style: UIAlertActionStyle.default) { (action) in
            print(action)
        }
        let default2Action = UIAlertAction(title: "Default2", style: UIAlertActionStyle.default) { (action) in
            print(action)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel) { (action) in
            print(action)
        }
        let destructiveAction = UIAlertAction(title: "Destructive", style: UIAlertActionStyle.destructive) { (action) in
            print(action)
        }
        
        let alertController =  UIAlertController(title: "Alert Controller Title", message: "Alert Controller Message", preferredStyle: UIAlertControllerStyle.actionSheet)
        alertController.addAction(default1Action)
        alertController.addAction(cancelAction)
        alertController.addAction(destructiveAction)
        alertController.addAction(default2Action)
        present(alertController, animated: true, completion: nil)
    }
    
}

