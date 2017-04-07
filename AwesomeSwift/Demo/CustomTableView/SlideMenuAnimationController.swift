//
//  SlideMenuAnimationController.swift
//  MyLearnOfSwift
//
//  Created by jeff on 03/02/2017.
//  Copyright © 2017 jeff. All rights reserved.
//

import UIKit

class SlideMenuAnimationController: NSObject, UIViewControllerAnimatedTransitioning {
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let snapshot = fromVC.view.snapshotView(afterScreenUpdates: false)
            else {
                return
        }
        
        let containerView = transitionContext.containerView
        containerView.addSubview(snapshot)
        containerView.addSubview(toVC.view)
        
        fromVC.view.isHidden = true
        toVC.view.translatesAutoresizingMaskIntoConstraints = false
        toVC.view.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.5).isActive = true
        toVC.view.heightAnchor.constraint(equalTo: containerView.heightAnchor, multiplier: 1).isActive = true
        toVC.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0).isActive = true
        let toLeading = toVC.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0)
        toLeading.isActive = true
        toVC.view.frame.origin.x = -toVC.view.frame.width / 2
        
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, animations: {
            toVC.view.frame.origin.x = 0
            snapshot.frame = CGRect(x: snapshot.frame.origin.x + snapshot.frame.width / 2, y: snapshot.frame.origin.y, width: snapshot.frame.width, height: snapshot.frame.height)
        }) { (_) in
            print("completed")
        }
        
    }
}
