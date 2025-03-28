//
//  WishlistViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 2/27/25.
//

import Foundation

import RxCocoa
import RxSwift

final class WishlistViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    var wishlistItems: [WishlistItem] = []
    
    struct Input {
        let searchBarText: ControlProperty<String> //서치 text
        let tapSearchBarReturnBtn: ControlEvent<Void> //서치 리턴 탭
    }
    struct Output {
        let tapSearchBarReturnBtnResult: Driver<[WishlistItem]>
    }
    
    func transform(input: Input) -> Output {
        let opTapSearchBarReturnBtnResult = PublishSubject<[WishlistItem]>()
        
        input.tapSearchBarReturnBtn
            .withLatestFrom(input.searchBarText)
            .compactMap { $0 }
            .subscribe(with: self, onNext: { owner, text in
                let newItem = WishlistItem(name: text,
                                           date: Date(),
                                           price: Int.random(in: 10000...100000) * 100) //랜덤 가격
                
                owner.wishlistItems.append(newItem)
                opTapSearchBarReturnBtnResult.onNext(owner.wishlistItems)
            }).disposed(by: disposeBag)
        
        return Output(tapSearchBarReturnBtnResult: opTapSearchBarReturnBtnResult.asDriver(onErrorJustReturn: []))
    }
    
}
