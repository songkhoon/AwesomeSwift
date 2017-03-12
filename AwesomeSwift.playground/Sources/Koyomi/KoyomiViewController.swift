import UIKit
import Koyomi

public class KoyomiViewController:UIViewController {
    
    let koyomiCellId = String(describing: KoyomiCell.self)
    let koyomi = Koyomi(frame: CGRect.zero, sectionSpace: 1.5, cellSpace: 0.5, inset: .zero, weekCellHeight: 25)
    lazy var koyomiButtons:[UIButton] = [
        self.createButton("monotone", UIColor.Color.lightGray, false, KoyomiStyle.monotone),
        self.createButton("standard", UIColor.Color.darkGray, false, KoyomiStyle.standard),
        self.createButton("red", UIColor.Color.red, false, KoyomiStyle.red),
        self.createButton("orange", UIColor.Color.orange, false, KoyomiStyle.orange),
        self.createButton("yellow", UIColor.Color.yellow, false, KoyomiStyle.yellow),
        self.createButton("tealBlue", UIColor.Color.tealBlue, true, KoyomiStyle.tealBlue),
        self.createButton("blue", UIColor.Color.blue, false, KoyomiStyle.blue),
        self.createButton("purple", UIColor.Color.purple, false, KoyomiStyle.purple),
        self.createButton("green", UIColor.Color.green, false, KoyomiStyle.green),
        self.createButton("pink", UIColor.Color.pink, false, KoyomiStyle.pink),
        self.createButton("deepBlack", UIColor.Color.darkBlack, true, KoyomiStyle.deepBlack),
        self.createButton("deepRed", UIColor.Color.red, true, KoyomiStyle.deepRed),
        self.createButton("deepOrange", UIColor.Color.orange, true, KoyomiStyle.deepOrange),
        self.createButton("deepYellow", UIColor.Color.yellow, true, KoyomiStyle.deepYellow),
        self.createButton("deepTealBlue", UIColor.Color.tealBlue, true, KoyomiStyle.deepTealBlue),
        self.createButton("deepBlue", UIColor.Color.blue, true, KoyomiStyle.deepBlue),
        self.createButton("deepPurple", UIColor.Color.purple, true, KoyomiStyle.deepPurple),
        self.createButton("deepGreen", UIColor.Color.green, true, KoyomiStyle.deepGreen),
        self.createButton("deepPink", UIColor.Color.pink, true, KoyomiStyle.deepPink),
        ]
    
    let buttonCollectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(width: 100, height: 30)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        let view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.backgroundColor = .orange
        view.contentInset = UIEdgeInsetsMake(10, 10, 10, 10)
        return view
    }()
    
    let segmentControl:UISegmentedControl = {
        let view = UISegmentedControl()
        view.isMomentary = true
        view.insertSegment(withTitle: "Previous", at: 0, animated: false)
        view.insertSegment(withTitle: "Current", at: 1, animated: false)
        view.insertSegment(withTitle: "Next", at: 2, animated: false)
        return view
    }()
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        automaticallyAdjustsScrollViewInsets = false
        view.backgroundColor = .white
        navigationItem.title = "Koyomi"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .done, target: self, action: #selector(handleBack))

        setupLayout()
        
    }
    
    private func setupLayout() {
        segmentControl.addTarget(self, action: #selector(handleSegment(_:)), for: .valueChanged)
        view.addSubview(segmentControl)
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        segmentControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        segmentControl.widthAnchor.constraint(equalToConstant: 300).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        koyomi.layer.borderWidth = 1.0
        koyomi.layer.borderColor = UIColor.lightGray.cgColor
        koyomi.circularViewDiameter = 0.2
        koyomi.calendarDelegate = self
        koyomi.inset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        koyomi.weeks = ("Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat")
        koyomi.style = .standard
        koyomi.dayPosition = .center
        koyomi.selectionMode = .sequence(style: .semicircleEdge)
        koyomi.selectedStyleColor = UIColor(red: 203/255, green: 119/255, blue: 223/255, alpha: 1)
        koyomi
            .setDayFont(size: 14)
            .setWeekFont(size: 10)
        
        view.addSubview(koyomi)
        
        koyomi.translatesAutoresizingMaskIntoConstraints = false
        koyomi.topAnchor.constraint(equalTo: segmentControl.bottomAnchor, constant: 20).isActive = true
        koyomi.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        koyomi.widthAnchor.constraint(equalToConstant: 300).isActive = true
        koyomi.heightAnchor.constraint(equalToConstant: 300).isActive = true
        
        buttonCollectionView.register(KoyomiCell.self, forCellWithReuseIdentifier: koyomiCellId)
        buttonCollectionView.dataSource = self
        view.addSubview(buttonCollectionView)
        buttonCollectionView.translatesAutoresizingMaskIntoConstraints = false
        buttonCollectionView.topAnchor.constraint(equalTo: koyomi.bottomAnchor, constant: 20).isActive = true
        buttonCollectionView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: -10).isActive = true
        buttonCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
        buttonCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10).isActive = true
    }
    
    func createButton(_ title:String, _ color:UIColor, _ isDeepColor:Bool = false, _ style:KoyomiStyle? = nil) -> UIButton {
        let view = MyButton()
        view.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
        view.setTitle(title, for: .normal)
        view.backgroundColor = .white
        view.layer.cornerRadius = 10.0
        if isDeepColor {
            view.deepColor = color
        } else {
            view.color = color
        }
        
        if let style = style {
            view.style = style
            view.addTarget(self, action: #selector(handleKoyomi(_:)), for: .touchUpInside)
        }
        return view
    }
    
    func handleBack() {
        dismiss(animated: true, completion: nil)
    }
    
    func handleSegment(_ sender:UISegmentedControl) {
        let month: MonthType = {
            switch sender.selectedSegmentIndex {
            case 0: return MonthType.previous
            case 1: return MonthType.current
            case 2: return MonthType.next
            default: return MonthType.current
            }
        }()
        koyomi.display(in: month)
    }
    
    func handleKoyomi(_ sender:MyButton) {
        if let style = sender.style {
            configureStyle(style)
        }
    }
    
    
    // Utility
    func configureStyle(_ style: KoyomiStyle) {
        koyomi.style = style
        koyomi.reloadData()
    }
}

extension KoyomiViewController: UICollectionViewDataSource {
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return koyomiButtons.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: koyomiCellId, for: indexPath) as! KoyomiCell
        let button = koyomiButtons[indexPath.row]
        button.frame.size = cell.frame.size
        cell.cellButton = button
        return cell
    }
}

extension KoyomiViewController: KoyomiDelegate {
    
}

public class KoyomiCell:UICollectionViewCell {
    var cellButton:UIButton? {
        didSet {
            contentView.addSubview(cellButton!)
        }
    }
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func prepareForReuse() {
        if let button = cellButton {
            button.removeFromSuperview()
        }
    }
}
