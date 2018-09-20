//
//  UNavigationController.swift
//  U17
//
//  Created by Leo on 2018/7/17.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        guard let interactionGes = interactivePopGestureRecognizer else { return  }
        guard let targetView = interactionGes.view else { return  }
        guard let internalTargets = interactionGes.value(forKey: "targets")as? [NSObject] else { return  }
         guard let internalTarget = internalTargets.first?.value(forKey: "target") else { return }
         let action = Selector(("handleNavigationTransition:"))
        let fullScreenGesture = UIPanGestureRecognizer(target: internalTarget, action: action)
        fullScreenGesture.delegate = self as? UIGestureRecognizerDelegate;
        targetView.addGestureRecognizer(fullScreenGesture)
        interactionGes.isEnabled = false;
        
    }
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if viewControllers.count > 0 {
            viewController.hidesBottomBarWhenPushed = true
            
        }
        super.pushViewController(viewController, animated: animated)
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension UNavigationController: UIGestureRecognizerDelegate{
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let isLeftToRigt = UIApplication.shared.userInterfaceLayoutDirection == .leftToRight
        guard let ges = gestureRecognizer as? UIPanGestureRecognizer else { return true }
        if ges.translation(in: gestureRecognizer.view).x * (isLeftToRigt ? 1 : -1) <= 0  || value(forKey: "_isTransitioning") as! Bool || disablePopGesture{
            return false
        }
        return viewControllers.count != 1;
    }
}
extension UNavigationController{
    override open var preferredStatusBarStyle: UIStatusBarStyle{
        guard let topVC = topViewController else { return .lightContent }
        return topVC.preferredStatusBarStyle
    }
}
enum UINavigationBarStyle {
    case theme
    case clear
    case white
}
extension UINavigationController{
    private struct AssociateKeys{
        static var disablePopGesture: Void?
    }
    var disablePopGesture: Bool {
        get{
            return objc_getAssociatedObject(self, &AssociateKeys.disablePopGesture)as? Bool ?? false;
        }
        set{
            objc_setAssociatedObject(self, &AssociateKeys.disablePopGesture, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
    func barStyle(_ style: UINavigationBarStyle) {
        switch style {
        case .theme:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(named: "nav_bg"), for: .default)
            navigationBar.shadowImage = UIImage()
        case .clear:
            navigationBar.barStyle = .black
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        case .white:
            navigationBar.barStyle = .default
            navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
            navigationBar.shadowImage = nil
        }
        
    }
    
}

