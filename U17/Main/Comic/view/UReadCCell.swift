//
//  UReadCCell.swift
//  U17
//
//  Created by Leo on 2018/9/11.
//  Copyright © 2018年 SPIC. All rights reserved.
//

import UIKit
import Kingfisher
extension UIImageView: Placeholder {}
class UReadCCell: UBaseCollectionViewCell {
     lazy var imageView: UIImageView = {
        let im = UIImageView()
        im.contentMode = .scaleAspectFit
        return im
    }()
    lazy var placeholder: UIImageView = {
        let pr = UIImageView(image: UIImage(named: "yaofan"))
        pr.contentMode = .center
        return pr
    }()
    override func configUI() {
       contentView.addSubview(imageView)
        imageView.snp.makeConstraints{
            $0.edges.equalToSuperview()
        }
    }
    var model: ImageModel? {
        didSet{
            guard let item = model else { return  }
            imageView.image = nil
            imageView.kf.setImage(urlString: item.location, placeholder: placeholder)
        }
    }
}
