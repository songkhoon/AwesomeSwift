import UIKit
import CalendarView

public class CalendarViewController: UIViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        navigationItem.title = "CalendarView"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))
        
        setupLayout()
    }
    
    private func setupLayout() {
        let calendar = CalendarView()
        view.addSubview(calendar)
        calendar.translatesAutoresizingMaskIntoConstraints = false
        calendar.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
        calendar.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        calendar.widthAnchor.constraint(equalToConstant: 300).isActive = true
        calendar.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }

}
