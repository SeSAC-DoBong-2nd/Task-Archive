//
//  FirstRunRepository.swift
//  RxPractice
//
//  Created by 박신영 on 3/6/25.
//

import Foundation

import RealmSwift

protocol FirstRunRepositoryProtocol {
    func createItem()
    func fetchAll() -> Results<FirstRunTable>
    func updateItem(data: FirstRunTable)
}

final class FirstRunRepository: FirstRunRepositoryProtocol {
    func createItem() {
        do {
            try realm.write {
                realm.add(FirstRunTable())
            }
        } catch {
            
        }
    }
    private let realm = try! Realm()
    
    func fetchAll() -> Results<FirstRunTable> {
        return realm.objects(FirstRunTable.self)
    }
    
    func updateItem(data: FirstRunTable) {
        do {
            let realm = try Realm()
            try realm.write {
                realm.create(FirstRunTable.self, value: ["id": data.id, "isFirstRun": false], update: .modified)
            }
        } catch {
            print("Realm write error: \(error)")
        }
    }
    
}

