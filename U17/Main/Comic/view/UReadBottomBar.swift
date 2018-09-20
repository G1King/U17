//
//  UReadBottomBar.swift
//  U17
//
//  Created by Leo on 2018/9/11.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit

class UReadBottomBar: UIView {
    lazy var menuSlider: UISlider = {
        let slider = UISlider()
        slider.thumbTintColor = UIColor.theme
        slider.minimumTrackTintColor = UIColor.theme
        slider.isContinuous = false; //滑块停止后 才触发 valuechange 事件
        return slider
    }()
    lazy var deviceButton: UIButton = {
        let dn = UIButton(type: .system)
        dn.setImage(UIImage(named: "readerMenu_changeScreen_horizontal")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return dn
    }()
    lazy var lightButton: UIButton = {
        let ln = UIButton(type: .system)
        ln.setImage(UIImage(named: "readerMenu_luminance")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return ln
    }()
    lazy var chapterButton: UIButton = {
        let cn = UIButton(type: .system)
        cn.setImage(UIImage(named: "readerMenu_catalog")?.withRenderingMode(.alwaysOriginal), for: .normal)
        return cn
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        configUI()
    }
    required init?(coder aDecoder: NSCoder) {
       fatalError("init(coder:) has not been implemented")
    }
    func configUI() {
        addSubview(menuSlider)
        menuSlider.snp.makeConstraints{
            $0.left.right.top.equalToSuperview().inset(UIEdgeInsetsMake(10, 40, 10, 40))
            $0.height.equalTo(30)
        }
        addSubview(deviceButton)
        addSubview(lightButton)
        addSubview(chapterButton)
        let button = [deviceButton,lightButton,chapterButton]
        button.snp.distributeViewsAlong(axisType: .horizontal, fixedItemLength: 60, leadSpacing: 40, tailSpacing: 40)
        button.snp.makeConstraints{
            $0.top.equalTo(menuSlider.snp.bottom).offset(10)
            $0.bottom.equalToSuperview()
        }
    }

}
