//
//  HomeworkViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 2/19/25.
//

import Foundation

import RxCocoa
import RxSwift

final class HomeworkViewModel {
    
    struct Input {
        let tableViewCellTap: ControlEvent<IndexPath>
        let searchBarReturnTap: ControlEvent<Void>
        let searchBarText:  ControlProperty<String>
    }
    
    struct Output {
        let tableDatasource: BehaviorRelay<[Person]>
        let collectionDatasource: BehaviorRelay<[String]>
        let tableViewCellTap: ControlEvent<IndexPath>
        let searchBarReturnTap: ControlEvent<Void>
        let searchBarText:  ControlProperty<String>
    }
    
    func transform(input: Input) -> Output {
        return Output(tableDatasource: BehaviorRelay(value: Person.dummy), collectionDatasource: BehaviorRelay(value: [String]()), tableViewCellTap: input.tableViewCellTap, searchBarReturnTap: input.searchBarReturnTap, searchBarText: input.searchBarText)
    }
    
}
