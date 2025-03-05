//
//  NewWishListDetailViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import Foundation

import RealmSwift
import RxCocoa
import RxSwift

final class NewWishListDetailViewModel {
    
    private let disposeBag = DisposeBag()
    private let repository: WishListRepositoryProtocol = WishListRepository()
    private let folderRepository: FolderRepository = FolderRepository()
    var list: List<WishListTable>!
    var id: ObjectId!
    
    struct Input {
        let searchBarText: ControlProperty<String>
        let tapSearchBarReturnBtn: ControlEvent<Void>
    }
    struct Output {
        let tapSearchBarReturnBtnResult: Driver<Void> //업데이트 트리거
    }
    
    func transform(input: Input) -> Output {
        let updateTableViewTrigger = PublishSubject<Void>()
        
        input.tapSearchBarReturnBtn
            .withLatestFrom(input.searchBarText)
            .compactMap { $0 }
            .subscribe(with: self) { owner, text in
                let newItem = WishListTable(
                    money: Int.random(in: 1000...100000),
                    category: ["생활비", "카페", "식비"].randomElement()!,
                    productName: text,
                    isRevenue: false,
                    memo: nil
                )
                let folder = owner.folderRepository.fetchAll().where {
                    $0.id == owner.id
                }.first!
                owner.repository.createItemInFolder(folder: folder, data: newItem)
                updateTableViewTrigger.onNext(())
            }.disposed(by: disposeBag)

        return Output(
            tapSearchBarReturnBtnResult: updateTableViewTrigger.asDriver(onErrorJustReturn: ())
        )
    }
}
