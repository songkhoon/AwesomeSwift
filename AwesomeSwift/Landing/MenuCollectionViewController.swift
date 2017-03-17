import UIKit

public class MenuCollectionViewController: UICollectionViewController {
    
    let cellId = "cellId"
    var buttons = [UIButton]()
    var menus:[UIButton:AnyClass]?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.backgroundColor = .white
        collectionView?.contentInset = UIEdgeInsetsMake(20, 0, 20, 0)
        collectionView?.register(LandingCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    public override func didMove(toParentViewController parent: UIViewController?) {
        super.didMove(toParentViewController: parent)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return buttons.count
    }
    
    public override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! LandingCell
        let button = buttons[indexPath.row]
        cell.addSubview(button)
        return cell
    }
}

