/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Material

class PCRootViewController: UIViewController {
    fileprivate var collectionView: UICollectionView!
    
    fileprivate let photos = [
        "photo1.jpg",
        "photo2.jpg",
        "photo3.jpg",
        "photo4.jpg",
        "photo5.jpg",
        "photo6.jpg",
        "photo7.jpg",
        "photo8.jpg",
    ]
    
    fileprivate var images = [UIImage]()
    
    fileprivate var fabButton: FABButton!
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        isMotionEnabled = true
        view.backgroundColor = .white
        
        preparePhotos()
        prepareCollectionView()
        prepareFABButton()
        prepareNavigationBar()
    }
}

extension PCRootViewController {
    fileprivate func preparePhotos() {
        photos.forEach { [unowned self] in
            guard let image = UIImage(named: $0) else {
                return
            }
            self.images.append(image)
        }
    }
    
    fileprivate func prepareCollectionView() {
        let columns: CGFloat = .phone == Device.userInterfaceIdiom ? 4 : 11
        let w: CGFloat = (view.bounds.width - columns - 1) / columns
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: w, height: w)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PhotoCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCollectionViewCell")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layout(collectionView).edges()
        collectionView.reloadData()
    }
    
    fileprivate func prepareFABButton() {
        fabButton = FABButton(image: Icon.cm.photoCamera, tintColor: .white)
        fabButton.pulseColor = .white
        fabButton.backgroundColor = Color.blue.base
        fabButton.motionIdentifier = "options"
        view.layout(fabButton).width(64).height(64).bottom(24).right(24)
    }
    
    fileprivate func prepareNavigationBar() {
        navigationItem.title = "Olo Alaia"
        navigationItem.detail = "Surf & Brew"
    }
}

extension PCRootViewController {
    @objc
    func motion(motion: Motion, willTransition fromView: UIView, toView: UIView) {
        fabButton.imageView?.motion(.fade(0), .duration(0.03))
    }
    
    @objc
    func motion(motion: Motion, didTransition fromView: UIView, toView: UIView) {
        fabButton.imageView?.motion(.fade(1), .duration(0.03))
    }
    
    @objc
    func motionDelayTransitionByTimeInterval(motion: Motion) -> TimeInterval {
        return 0.03
    }
}

extension PCRootViewController: UICollectionViewDataSource {
    @objc
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        cell.imageView.image = images[indexPath.item]
        cell.imageView.contentMode = .scaleToFill
        cell.imageView.motionIdentifier = photos[indexPath.item]
        return cell
    }
}

extension PCRootViewController: UICollectionViewDelegate {
    @objc
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = PCPhotoViewController(image: images[indexPath.item])
        vc.imageView.motionIdentifier = photos[indexPath.item]
        navigationController?.pushViewController(vc, animated: true)
    }
}
