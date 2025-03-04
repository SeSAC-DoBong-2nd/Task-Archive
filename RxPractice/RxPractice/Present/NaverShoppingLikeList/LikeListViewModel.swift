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
    }
    
    struct Output {
        let tapNavLeftBtnResult: Observable<Void>?
    }
    
    func transform(input: Input) -> Output {
        
        
        return Output(
            tapNavLeftBtnResult: input.tapNavLeftBtn?.asObservable())
    }
    
    deinit {
        print("NaverShoppingListViewModel", #function)
    }
}

private extension NaverShoppingListViewModel {
    
    
    
}

