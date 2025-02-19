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
    
    let tableViewDatasource = Person.dummy
    var collectionViewDatasource = [String]()
    
    struct Input {
//        let tableViewTap: ControlEvent<IndexPath>
    }
    
    struct Output {
        let tableDatasource: BehaviorRelay<[Person]>
        let collectionDatasource: BehaviorRelay<[String]>
//        let tableViewTap: BehaviorRelay<Void>
    }
    
    func transform(input: Input) -> Output {
        
        
        return Output(tableDatasource: BehaviorRelay(value: Person.dummy), collectionDatasource: BehaviorRelay(value: [String]()))
    }
    
}
