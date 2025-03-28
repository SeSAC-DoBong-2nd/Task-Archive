//
//  LikeListTable.swift
//  RxPractice
//
//  Created by 박신영 on 3/4/25.
//

import Foundation

import RealmSwift

class LikeListTable: Object {
    @Persisted(primaryKey: true) var id: ObjectId //PK
    @Persisted(indexed: true) var productName: String //상품명
    @Persisted var imageUrl: String //이미지 썸네일 주소
    @Persisted var mallName: String //쇼핑몰 이름
    @Persisted var price: Int //가격
    @Persisted var isLike: Bool //좋아요
    
    convenience init(productName: String, imageUrl: String, mallName: String, price: Int, isLike: Bool) {
        self.init()
        
        self.productName = productName
        self.imageUrl = imageUrl
        self.mallName = mallName
        self.price = price
        self.isLike = isLike
    }
}

