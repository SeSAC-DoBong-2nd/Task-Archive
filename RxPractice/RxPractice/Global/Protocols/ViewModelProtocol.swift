//
//  ViewModelProtocol.swift
//  RxPractice
//
//  Created by 박신영 on 2/24/25.
//

import Foundation

protocol ViewModelProtocol {
    
    associatedtype Input
    associatedtype Output
    
    func transform(input: Input) -> Output
    
}
