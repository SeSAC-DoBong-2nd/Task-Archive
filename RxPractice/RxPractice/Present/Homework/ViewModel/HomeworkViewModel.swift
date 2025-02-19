//
//  HomeworkViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 2/19/25.
//

import Foundation

final class HomeworkViewModel {
    
    var tableViewDatasource = Person.dummy
    var collectionViewDatasource = [String]()
    
    struct Input {
        
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        
        return Output()
    }
    
}
