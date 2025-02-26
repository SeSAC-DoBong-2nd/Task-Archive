//
//  NaverSearchViewModel.swift
//  DailyTask_week4
//
//  Created by 박신영 on 2/6/25.
//

import Foundation

import RxCocoa
import RxSwift

final class NaverSearchViewModel: ViewModelProtocol {
    
    var currentSearchText = ""
    private let disposeBag = DisposeBag()
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchReturnClicked: ControlEvent<Void> //서치바 리턴버튼 클릭
    }
    
    struct Output {
        let isValidSearchText: Driver<Bool>
    }
    
    func transform(input: Input) -> Output {
        let outputIsValidSearchText = PublishRelay<Bool>()
        
        input.searchText
//            .debounce(.seconds(1), scheduler: MainScheduler.instance)
                    //위는 searchText를 계속 관찰해야하기에 debounce와 같은 시간 제약이 없어야함
            .distinctUntilChanged()
            .subscribe(with: self) { owner, value in
                owner.currentSearchText = value
            }.disposed(by: disposeBag)
        
        input.searchReturnClicked
        //전환과 관련된 친구는 debounce가 나은듯?!
        //즉발 필요할 때?
        //반복적인 필요하면 스로틀
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
//            .distinctUntilChanged() //같은 값도 재검색 할 수 있어야하기에 빼야함.
            .map {
                $0.count >= 2
            }
            .bind(with: self) { owner, value in
                outputIsValidSearchText.accept(value)
            }.disposed(by: disposeBag)
        
        
        
        
        return Output(isValidSearchText: outputIsValidSearchText.asDriver(onErrorDriveWith: .empty()))
    }
    
}
