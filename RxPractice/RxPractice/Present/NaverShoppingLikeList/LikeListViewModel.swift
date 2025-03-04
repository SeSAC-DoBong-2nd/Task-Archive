//
//  LikeListViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 3/4/25.
//

import Foundation

import RxCocoa
import RxSwift

final class LikeListViewModel: ViewModelProtocol {
    
    private var currentFilter = ""
    private let disposeBag = DisposeBag()
    
    struct Input {
        let tapNavLeftBtn: ControlEvent<Void>?
        let searchBarText: ControlProperty<String>
    }
    
    struct Output {
        let tapNavLeftBtnResult: Observable<Void>?
        let searchBarTextResult: Driver<String>
    }
    
    func transform(input: Input) -> Output {
        let searchBarTextResult = PublishRelay<String>()
        input.searchBarText
            .debounce(.milliseconds(300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                searchBarTextResult.accept(text)
            })
            .disposed(by: disposeBag)

        
        return Output(
            tapNavLeftBtnResult: input.tapNavLeftBtn?.asObservable(),
            searchBarTextResult: searchBarTextResult.asDriver(
                onErrorDriveWith: .empty()
            )
        )
    }
    
    deinit {
        print("NaverShoppingListViewModel", #function)
    }
}

private extension NaverShoppingListViewModel {
    
    
    
}

