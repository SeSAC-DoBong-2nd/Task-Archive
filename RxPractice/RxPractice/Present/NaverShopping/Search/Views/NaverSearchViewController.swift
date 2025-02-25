//
//  NaverSearchViewController.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class NaverSearchViewController: BaseViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = NaverSearchViewModel()
    
    private let searchView = NaverSearchView()
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "psy의 쇼핑쇼핑"
        bind()
    }

}

private extension NaverSearchViewController {
    
    func bind() {
        let input = NaverSearchViewModel.Input(
            searchText: searchView.searchBar.rx.text.orEmpty,
            searchReturnClicked: searchView.searchBar.rx.searchButtonClicked
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidSearchText
            .compactMap { $0 }
            .drive(with: self) { owner, value in
                switch value {
                case true:
                    let viewModel = NaverShoppingListViewModel()
                    let vc = NaverShoppingListViewController(viewModel: viewModel, navtitle: owner.viewModel.currentSearchText)
                    
                    print("owner.viewModel.currentSearchText: \(owner.viewModel.currentSearchText)")
                    owner.navigationController?.pushViewController(vc, animated: true)
                case false:
                    let alert = UIAlertManager.showAlert(title: "검색 실패", message: "2글자 이상 검색해주세요.")
                    owner.present(alert, animated: true)
                }
            }.disposed(by: disposeBag)
    }
    
}
