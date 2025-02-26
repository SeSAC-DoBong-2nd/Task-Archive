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
    private let wishlistButton = UIBarButtonItem()
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bind()
    }
    
    override func setStyle() {
        navigationItem.title = "psy의 쇼핑쇼핑"
        
        wishlistButton.do {
            $0.image = UIImage(systemName: "heart.fill")
            $0.style = .plain
        }
        navigationItem.leftBarButtonItem = wishlistButton
    }
}

private extension NaverSearchViewController {
    
    func bind() {
        let input = NaverSearchViewModel.Input(
            searchText: searchView.searchBar.rx.text.orEmpty,
            searchReturnClicked: searchView.searchBar.rx.searchButtonClicked, tapNavLeftBtn: navigationItem.leftBarButtonItem?.rx.tap
        )
        
        let output = viewModel.transform(input: input)
        
        output.isValidSearchText
            .compactMap { $0 }
            .drive(with: self) { owner, value in
                switch value {
                case true:
                    let viewModel = NaverShoppingListViewModel()
                    viewModel.currentSearchText = owner.viewModel.currentSearchText
                    let vc = NaverShoppingListViewController(viewModel: viewModel, navtitle: owner.viewModel.currentSearchText)
                    
                    print("owner.viewModel.currentSearchText: \(owner.viewModel.currentSearchText)")
                    owner.navigationController?.pushViewController(vc, animated: true)
                case false:
                    let alert = UIAlertManager.shared.showAlert(title: "검색 실패", message: "2글자 이상 검색해주세요.")
                    owner.present(alert, animated: true)
                }
            }.disposed(by: disposeBag)
        
        output.tapNavLeftBtnResult?
            .bind(with: self, onNext: { owner, _ in
                let wishlistVC = WishlistViewController()
                owner.navigationController?.pushViewController(wishlistVC, animated: true)
            }).disposed(by: disposeBag)
            
    }
}
