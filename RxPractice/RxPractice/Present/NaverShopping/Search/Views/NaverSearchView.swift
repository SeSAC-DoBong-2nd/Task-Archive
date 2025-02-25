//
//  NaverSearchView.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/16/25.
//

import UIKit

final class NaverSearchView: BaseView {
    
    let searchBar = UISearchBar()
    let imageView = UIImageView()

    override func setHierarchy() {
        self.addSubviews(searchBar, imageView)
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        imageView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(170)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(320)
            $0.height.equalTo(300)
        }
    }
    
    override func setStyle() {
        searchBar.do {
            $0.placeholder = "브랜드, 상품, 프로필, 태그 등"
        }
        
        imageView.do {
            $0.image = UIImage(resource: .shoppingHome)
        }
    }

}
