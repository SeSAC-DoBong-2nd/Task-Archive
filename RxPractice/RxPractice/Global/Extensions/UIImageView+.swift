//
//  UIImageView+.swift
//  RxPractice
//
//  Created by 박신영 on 2/25/25.
//

import UIKit

import Kingfisher

extension UIImageView {
    
    func setImageKfDownSampling(with urlString: String, cornerRadius: Int) {
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
        self.kf.indicatorType = .activity
        self.kf.setImage(
            with: URL(string: urlString),
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ]
        )
        self.clipsToBounds = true
        self.contentMode = .scaleAspectFill
        self.layer.cornerRadius = CGFloat(cornerRadius)
    }
    
}
