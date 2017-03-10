//: Playground - noun: a place where people can play

import UIKit
import PlaygroundSupport


var str = "Hello, playground"
PlaygroundPage.current.needsIndefiniteExecution = true
let controller = ExampleController()
let navController = UINavigationController(rootViewController: controller)
PlaygroundPage.current.liveView = navController
