//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


var str = "Hello, playground"
PlaygroundPage.current.needsIndefiniteExecution = true
let controller = LandingViewController()
controller.view.frame.size = CGSize(width: 375, height: 667)
let navController = UINavigationController(rootViewController: controller)
PlaygroundPage.current.liveView = navController
