//
//  NewWishListViewController.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import UIKit

import RealmSwift
import RxCocoa
import RxSwift
import SnapKit

final class NewWishListViewController: UIViewController {

    private let disposeBag = DisposeBag()
    private let viewModel = NewWishListViewModel()
    private let tableView = UITableView()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function)
        fetchTableViewData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        configureHierarchy()
        configureView()
        configureConstraints()
        bind()
    }
    
    private func bind() {
        let input = NewWishListViewModel.Input(tableViewCellTap: tableView.rx.modelSelected(FolderTable.self))
        let output = viewModel.transform(input: input)
        
        output.folderListSubjectResult
            .bind(to: tableView.rx.items(cellIdentifier: ListTableViewCell.id, cellType: ListTableViewCell.self)) { row, element, cell in
                cell.fetchUI(witeFolderModel: element)
            }.disposed(by: disposeBag)
        
        output.tableViewCellTapResult
            .bind(with: self) { owner, item in
                let data = item
                let vm = NewWishListDetailViewModel()
                vm.id = data.id
                vm.list = data.detail
                let vc = NewWishListDetailViewController(viewModel: vm, navTitle: data.name)
                
                owner.navigationController?.pushViewController(vc, animated: true)
            }.disposed(by: disposeBag)
    }
    
    private func fetchTableViewData() {
        self.tableView.reloadData()
    }
    
    private func configureHierarchy() {
        view.addSubview(tableView)
    }
    
    private func configureView() {
        navigationItem.title = "New Wish List"
        view.backgroundColor = .white
        tableView.rowHeight = 130
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}
