//
//  Macro.swift
//  U17
//
//  Created by Leo on 2018/7/17.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
import SnapKit
import MJRefresh

let APP_VERSION = Bundle.main.infoDictionary!["CFBundleShortVersionString"]! 
#if DEBUG
let BASE_URL = "http://app.u17.com/v3/appV3_3/ios/phone";
#else
#endif
//首页存储标志
extension String {
    static let sexTypeKey = "sexTypeKey"
    static let searchHistoryKey = "searchHistoryKey"
}
extension NSNotification.Name {
    static let USexTypeDidChangeNotificationName = NSNotification.Name("USexTypeDidChange")
}

//打印
func DLog<T>(_ message: T, file: String = #file, function: String = #function, lineNumber: Int = #line) {
    #if DEBUG
    let fileName = (file as NSString).lastPathComponent
    print("[\(fileName):funciton:\(function):line:\(lineNumber)]- \(message)")
    #endif
}

//顶层VC
var topVC : UIViewController?{
    var resultVC: UIViewController?
    resultVC = _topVC(UIApplication.shared.keyWindow?.rootViewController)
    while resultVC?.presentedViewController != nil {
        resultVC = _topVC(resultVC?.presentedViewController)
    }
    return resultVC

}
private func _topVC(_ vc: UIViewController?) -> UIViewController? {
    //is 若一个类属于另一个类的子类，则会返回true，否则返回false。
    if vc is  UINavigationController {
        return _topVC((vc as? UINavigationController)?.topViewController)
    }else if vc is UITabBarController {
        return _topVC((vc as? UITabBarController)?.selectedViewController)
    }else {
        return vc;
    }
    
}
//布局适配
extension ConstraintView {
    var usnp: ConstraintBasicAttributesDSL {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.snp
        }else{
            return self.snp;
        }
        
    }
}
//图片
extension Kingfisher where Base: ImageView{
    @discardableResult
    public func setImage(urlString: String?, placeholder: Placeholder? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
//        return setImage(with: URL(string: urlString ?? ""), placeholder: Placeholder, options:[.transition(.fade(0.5)) ])
        return setImage(with: URL(string: urlString ?? ""), placeholder: placeholder, options:[.transition(.fade(0.5))])
    }
}
//按钮
extension Kingfisher where Base: UIButton {
   @discardableResult
    public func setImage(urlString: String?, for state: UIControl.State, placeholder: UIImage? = UIImage(named: "normal_placeholder_h")) -> RetrieveImageTask {
    return setImage(with: URL(string: urlString ?? ""), for: state, placeholder: placeholder,  options:[.transition(.fade(0.5))])
    }
}
//屏幕宽度 高度
let SCREEN_WIDTH = UIScreen.main.bounds.size.width
let SCREEN_HEIGHT = UIScreen.main.bounds.size.height

//颜色相关
extension UIColor {
    class var background: UIColor {
        return UIColor(r:242 , g: 242, b:242)
    }
    class var theme: UIColor {
        return UIColor(r: 29, g: 221, b: 43)
    }

}
//时间
 func getTimeInterval(time: Int) -> String {
    let comicDate = Date().timeIntervalSince(Date(timeIntervalSince1970: TimeInterval(time)))
    var tagString = ""
    if comicDate < 60 {
        tagString = "\(Int(comicDate))秒前"
    } else if comicDate < 3600 {
        tagString = "\(Int(comicDate / 60))分前"
    } else if comicDate < 86400 {
        tagString = "\(Int(comicDate / 3600))小时前"
    } else if comicDate < 31536000{
        tagString = "\(Int(comicDate / 86400))天前"
    } else {
        tagString = "\(Int(comicDate / 31536000))年前"
    }
    return tagString;
}
extension UICollectionView {
    
    func reloadData(animation: Bool = true) {
        if animation {
            reloadData()
        } else {
            UIView .performWithoutAnimation {
                reloadData()
            }
        }
    }
}

//MARK: swizzledMethod
extension NSObject {
    
    static func swizzleMethod(_ cls: AnyClass, originalSelector: Selector, swizzleSelector: Selector){
        
        let originMethod = class_getInstanceMethod(cls, originalSelector)!
        let swizzMethod  = class_getInstanceMethod(cls, swizzleSelector)!
        let didAddMethod = class_addMethod(cls, originalSelector, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod))
        if didAddMethod {
            class_replaceMethod(cls, swizzleSelector, method_getImplementation(originMethod), method_getTypeEncoding(originMethod))
        }else {
             method_exchangeImplementations(originMethod, swizzMethod)
        }
    }
}
//extension UIApplication{
//    
//}
