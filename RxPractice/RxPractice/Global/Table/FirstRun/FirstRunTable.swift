//
//  FirstRunTable.swift
//  RxPractice
//
//  Created by 박신영 on 3/6/25.
//

import Foundation

import RealmSwift

//첫실행 여부 판단해서 Folder에 item 생성하는 로직 분기처리하려고 만들었는데 일이 너무 커져버렸습니다..
//그냥 UserDefaults 쓸 걸..
final class FirstRunTable: Object {
    
    @Persisted(primaryKey: true) var id: ObjectId //고유 id
    @Persisted var isFirstRun: Bool = true
    
    convenience init(isFirstRun: Bool) {
        self.init()
        self.isFirstRun = isFirstRun
    }
    
}
