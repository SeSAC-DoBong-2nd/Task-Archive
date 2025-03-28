//
//  WishlistItem.swift
//  RxPractice
//
//  Created by 박신영 on 2/27/25.
//

import Foundation

//MARK: - WishlistItem Model
struct WishlistItem: Hashable, Identifiable { //vc와 vm에서 모두 사용되기에 다른 파일로 분리
    let id = UUID() //Identifiable 채택함으로써 id 변수 사용 강제화
    let name: String
    let date: Date
    let price: Int
    
    //상품 추가 일자
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    //상품 가격
    var formattedPrice: String {
        return "\(price.formatted())원"
    }
}
