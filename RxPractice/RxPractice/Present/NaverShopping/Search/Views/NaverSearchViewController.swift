//
//  NaverSearchViewController.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import UIKit

import SnapKit
import Then

final class NaverSearchViewController: BaseViewController {
    
    private let viewModel = NaverSearchViewModel()
    
    private let searchView = NaverSearchView()
    
    override func loadView() {
        self.view = searchView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchView.imageView.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        searchView.imageView.isHidden = true
    }
    
    override func setStyle() {
        view.backgroundColor = .black
    }

}

private extension NaverSearchViewController {
    
    func setDelegate() {
        searchView.searchBar.delegate = self
    }
    
    func bindViewModel() {
        viewModel.outputNavtitle.bind { [weak self] title in
            guard let self else {return}
            self.navigationItem.title = title
        }
        
        viewModel.outputIsValidSearchText.lazyBind { [weak self] value in
            guard let self else {return}
            switch value {
            case true:
                let vcViewModel = NaverShoppingListViewModel()
                vcViewModel.outputNavTitle.value = self.viewModel.inputSearchText.value ?? "실패"
                let vc = NaverShoppingListViewController(viewModel: vcViewModel)
                self.navigationController?.pushViewController(vc, animated: true)
            case false:
                let alert = UIAlertUtil.showAlert(title: "조회 실패", message: "2글자 이상 입력해주세요.")
                self.present(alert, animated: true)
            }
        }
    }
    
}

extension NaverSearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        viewModel.inputSearchText.value = searchBar.text
        view.endEditing(true)
    }
    
}
