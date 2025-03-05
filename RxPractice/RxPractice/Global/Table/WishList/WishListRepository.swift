//
//  WishListRepository.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import Foundation

import RealmSwift

protocol WishListRepositoryProtocol {
    func getFileURL()
    func fetchAll() -> Results<WishListTable>
    func createItem()
    func deleteItem(data: WishListTable)
    func updateItem(data: WishListTable)
    func createItemInFolder(folder: FolderTable, data: WishListTable)
}

// Realm CRUD
final class WishListRepository: WishListRepositoryProtocol {
    //TMI... get, fetch, request 각 키워드는 어떨 때 쓸까? 궁금하면 찾아보기
   
    //realm에 접근
    private let realm = try! Realm() //default.realm
    
    func getFileURL() {
        print(realm.configuration.fileURL)
    }
    
    func fetchAll() -> Results<WishListTable> {
        return realm.objects(WishListTable.self)
//            .where {$0.productName.contains("sesac", options: .caseInsensitive)}
            .sorted(byKeyPath: "money", ascending: false)
    }
    
    func createItem() { //FolderTable 테이블과 상관없이 JackTable에 레코드 바로 추가
        //Create
        do {
            try realm.write {
                let data = WishListTable(
                    money: Int.random(in: 1000...100000),
                    category: ["생활비", "카페", "식비"].randomElement()!,
                    productName: ["린스", "커피", "과자", "칼국수"].randomElement()!,
                    isRevenue: false,
                    memo: nil
                )
                
                realm.add(data)
                print("realm 저장 성공한 경우")
            }
        } catch {
            print("realm 저장이 실패한 경우")
        }
    }
    
    func createItemInFolder(folder: FolderTable, data: WishListTable) {
        //Create In FolderTable
        do {
            try realm.write {
                folder.detail.append(data)
                print("realm 저장 성공한 경우")
            }
        } catch {
            print("realm 저장이 실패한 경우")
        }
    }
    
    //삭제
    func deleteItem(data: WishListTable) {
        do {
            //Realm의 CRUD와 같은 작업들은 write 트랜젝션이 보장돼야 하기에 그 안에 위치해야한다.
            try realm.write {
                
                //삭제
                realm.delete(data)
                print("realm 데이터 삭제 성공")
            }
        } catch {
            print("realm 데이터 삭제 실패")
        }
    }
    
    //수정
    func updateItem(data: WishListTable) {
        do {
            try realm.write {
                realm.create(WishListTable.self, value: ["id": data.id, "money": 1000000000, "productName": "케케몬"], update: .modified)
            }
        } catch {
            print("realm 데이터 삭제 실패")
        }
    }
    
}
