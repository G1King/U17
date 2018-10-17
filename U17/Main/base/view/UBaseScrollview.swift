//
//  UBaseScrollview.swift
//  U17
//
//  Created by Leo on 2018/9/5.
//  Copyright © 2018年 SPIC. All rights reserved.
//
import UIKit
class UBaseScrollview: UIScrollView {
 
    
//
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//
//        DLog(self.contentSize.width)
//        if <#condition#> {
//            <#code#>
//        }
//          let pan = gestureRecognizer as! UIPanGestureRecognizer
//        let velocity: CGPoint = pan.velocity(in: self)
//        let location: CGPoint = pan .location(in: self)
//        if velocity.x > 0 && ((Int(location.x) % Int(SCREEN_WIDTH) < 60)) {
//            return false
//        }
//        return true
//
//    }
//    func panBack(gesturnRecobgizer: UIGestureRecognizer) -> Bool {
//        if gesturnRecobgizer == self.panGestureRecognizer {
//            let pan = gesturnRecobgizer as! UIPanGestureRecognizer
//            let point: CGPoint = pan .translation(in: self)
//            let state = gesturnRecobgizer.state
//            if UIGestureRecognizerState.began == state || UIGestureRecognizerState.possible == state {
//                let location: CGPoint = gesturnRecobgizer.location(in: self)
//                if point.x > 0 && location.x < 150 && self.contentOffset.x <= 0 {
//
//                    return true
//                }
//            }
//        }
//        return false
//    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool{
        // 首先判断otherGestureRecognizer是不是系统pop手势
        if (otherGestureRecognizer.view?.isKind(of: NSClassFromString("UILayoutContainerView")!))! {
            // 再判断系统手势的state是began还是fail，同时判断scrollView的位置是不是正好在最左边
            
            if otherGestureRecognizer.state == .began && self.contentOffset.x == 0 {
                return true
            }
        }
        return false
    }
    
}
