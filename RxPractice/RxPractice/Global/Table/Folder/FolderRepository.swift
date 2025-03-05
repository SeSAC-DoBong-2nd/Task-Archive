//
//  FolderRepository.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import Foundation

import RealmSwift

//create는 사용하지 않기에 주석처리
protocol FolderRepositoryProtocol {
    func createItem(name: String)
    func fetchAll() -> Results<FolderTable>
}

final class FolderRepository: FolderRepositoryProtocol {
    
    private let realm = try! Realm()
    
    func createItem(name: String) {
        do {
            try realm.write {
                let folder = FolderTable(name: name)
                realm.add(folder)
            }
        } catch {
            
        }
    }
    
    func fetchAll() -> Results<FolderTable> {
        print("@@@")
        dump(realm.objects(FolderTable.self))
        return realm.objects(FolderTable.self)
    }
    
}
