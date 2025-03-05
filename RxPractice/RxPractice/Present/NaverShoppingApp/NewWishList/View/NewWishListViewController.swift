//
//  NewWishListViewController.swift
//  RxPractice
//
//  Created by 박신영 on 3/5/25.
//

import UIKit

import RealmSwift
import SnapKit

final class NewWishListViewController: UIViewController {

    private let tableView = UITableView()
    private var list: Results<FolderTable>!
    private var firstRun: Results<FirstRunTable>!
    private let firstRunRepository: FirstRunRepositoryProtocol = FirstRunRepository()
    private let repository: FolderRepositoryProtocol = FolderRepository()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function)
        configureHierarchy()
        configureView()
        configureConstraints()
        list = repository.fetchAll()
        firstRunRepository.createItem()
        firstRun = firstRunRepository.fetchAll()
        makeFolderItem(isFirstRun: firstRun.first?.isFirstRun)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print(#function)
        fetchTableViewData()
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
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ListTableViewCell.self, forCellReuseIdentifier: ListTableViewCell.id)
    }
    
    private func configureConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

}

extension NewWishListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.id, for: indexPath) as! ListTableViewCell
        
        let data = list[indexPath.row]
        
        
        cell.titleLabel.text = data.name
        cell.subTitleLabel.text = "\(data.detail.count)개"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = list[indexPath.row]
        let vm = NewWishListDetailViewModel()
        vm.id = data.id
        vm.list = data.detail
        let vc = NewWishListDetailViewController(viewModel: vm, navTitle: data.name)
        
        navigationController?.pushViewController(vc, animated: true)
        
        fetchTableViewData()
    }
      
    
}


