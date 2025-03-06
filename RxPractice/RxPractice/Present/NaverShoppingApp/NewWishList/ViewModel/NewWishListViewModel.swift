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
    
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    
    private var firstRun: Results<FirstRunTable>!
    private let firstRunRepository: FirstRunRepositoryProtocol = FirstRunRepository()
    private let repository: FolderRepositoryProtocol = FolderRepository()
    
    private let folderListSubject = BehaviorRelay<Results<FolderTable>>(value: try! Realm().objects(FolderTable.self))
    
    init() {
        setFirstRun()
    }
    
    struct Input {
        let tableViewCellTap: ControlEvent<FolderTable>
    }
    
    struct Output {
        let folderListSubjectResult: BehaviorRelay<Results<FolderTable>>
        let tableViewCellTapResult: ControlEvent<FolderTable>
    }
    
    func transform(input: Input) -> Output {
        return Output(
            folderListSubjectResult: folderListSubject,
            tableViewCellTapResult: input.tableViewCellTap
        )
    }
    
    private func setFirstRun() {
        firstRunRepository.createItem()
        firstRun = firstRunRepository.fetchAll()
        makeFolderItem(isFirstRun: firstRun.first?.isFirstRun)
    }
    
    private func makeFolderItem(isFirstRun: Bool?) {
        guard let isFirstRun else {return}
        if isFirstRun {
            print(#function)
            repository.createItem(name: "개인")
            repository.createItem(name: "가족")
            repository.createItem(name: "새싹")
            firstRunRepository.updateItem(data: firstRun.first!)
        }
    }
    
}
