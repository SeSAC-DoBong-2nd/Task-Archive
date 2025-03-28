//
//  FolderTable.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import Foundation

import RealmSwift

final class FolderTable: Object {
    
    @Persisted var id: ObjectId //고유 id
    @Persisted var name: String //카테고리명
    
    @Persisted var detail: List<WishListTable>
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
}
