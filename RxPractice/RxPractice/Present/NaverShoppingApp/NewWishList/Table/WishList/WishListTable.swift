//
//  WishListTable.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import Foundation

import RealmSwift

final class WishListTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId //PK
    @Persisted var money: Int //금액
    @Persisted var category: String //카테고리명
    @Persisted(indexed: true) var productName: String //상품명
    @Persisted var isRevenue: Bool //수입지출여부
    @Persisted var regdate: Date //등록일
    @Persisted var memo: String? //메모
    @Persisted var isLike: Bool //좋아요
    
    @Persisted(originProperty: "detail")
    var folder: LinkingObjects<FolderTable>
    
    convenience init(money: Int,
                     category: String,
                     productName: String,
                     isRevenue: Bool,
                     memo: String? = nil)
    {
        self.init() //여기서 id에 realm이 알아서 겹치지 않는 id를 만들어 넣어준다.
        self.money = money
        self.category = category
        self.productName = productName
        self.isRevenue = isRevenue
        self.memo = memo
        self.isLike = false
    }
    
}
