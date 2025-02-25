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
        self.addSubview(searchBar)
        self.addSubview(imageView)
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
            $0.width.equalTo(200)
            $0.height.equalTo(200)
        }
    }
    
    override func setStyle() {
        searchBar.do {
            $0.placeholder = "브랜드, 상품, 프로필, 태그 등"
            $0.barTintColor = .lightGray.withAlphaComponent(0.4) //서치바 메인 색
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        imageView.do {
            $0.image = UIImage(systemName: "cart")
            $0.tintColor = .lightGray
        }
    }

}
