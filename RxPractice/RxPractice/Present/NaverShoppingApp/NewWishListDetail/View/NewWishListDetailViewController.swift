//
//  NewWishListDetailViewController.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SnapKit

final class NewWishListDetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel: NewWishListDetailViewModel
    
    let repository: WishListRepositoryProtocol = WishListRepository()
    

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    
    init(viewModel: NewWishListDetailViewModel, navTitle: String) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = navTitle
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        bind()
    }
    
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(searchBar)
        view.addSubview(tableView)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 130
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
        
        searchBar.placeholder = "위시리스트 항목 추가"
        searchBar.searchBarStyle = .minimal
    }
    
    private func updateTableView() {
        tableView.reloadData()
    }
    
    private func bind() {
        let input = NewWishListDetailViewModel.Input(
            searchBarText: searchBar.rx.text.orEmpty,
            tapSearchBarReturnBtn: searchBar.rx.searchButtonClicked
        )
        let output = viewModel.transform(input: input)
        
        output.tapSearchBarReturnBtnResult
            .drive(with: self, onNext: { owner, _ in
                owner.updateTableView()
                owner.resetUI()
            }).disposed(by: disposeBag)
    }
    
    private func resetUI() {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
}

extension NewWishListDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as! ListTableViewCell
        
        let item = viewModel.list[indexPath.row]
        cell.titleLabel.text = item.productName
        cell.subTitleLabel.text = "\(item.category) - \(item.money.formatted())원"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.list[indexPath.row]
        let doneAction = UIAlertAction(title: "제거", style: .default) { [weak self] _ in
            self?.removeItem(item: item)
        }
        
        let alert = UIAlertManager.shared.showAlertWithAction(
            title: "위시리스트 제거",
            message: "\(item.productName) 항목을 위시리스트에서 제거하시겠습니까?",
            cancelFunc: true,
            doneAction: doneAction
        )
        self.present(alert, animated: true)
    }
    
    private func removeItem(item: WishListTable) {
        repository.deleteItem(data: item)
        updateTableView()
    }
}
