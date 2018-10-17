//
//  UCollectListViewController.swift
//  U17
//
//  Created by Leo on 2018/9/27.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UCollectListViewController: UBaseViewController {
 let v = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        v.frame = CGRect(x: 20, y: 20, width: 100, height: 100);
        view.addSubview(v)
        let i =  rxswiftDemo(addImage: UIImage(named: "normal_placeholder_v")!, mskImage: UIImage(named: "yaofan")!)
        v.image = i;
    }
    func rxswiftDemo(addImage add: UIImage, mskImage: UIImage) -> UIImage{
        UIGraphicsBeginImageContextWithOptions(add.size, false, 0.0)
        add.draw(in: CGRect(x: 0, y: 0, width: add.size.width, height: add.size.height))
        mskImage.draw(in: CGRect(x: 0, y: 0, width: add.size.width, height: add.size.height/2))
//        mskImage.draw(in: CGRect(x: 0, y: add.size.height/2, width: add.size.width, height: add.size.height/2))
        let getimage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return getimage
    
    }
    func swapTwoValues<T>( a: inout T, b: inout T)  {
        let t = a
        a = b
        b = t
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.navigationController?.pushViewController(UIScrollViewController(), animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
