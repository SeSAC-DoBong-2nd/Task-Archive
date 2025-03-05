//
//  NewWishListViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 3/6/25.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class NewWishListViewModel: ViewModelProtocol {
    
    private let realm = try! Realm()
    private let folderListSubject = BehaviorRelay<Results<FolderTable>>(value: try! Realm().objects(FolderTable.self))
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return Output()
    }
    
}
