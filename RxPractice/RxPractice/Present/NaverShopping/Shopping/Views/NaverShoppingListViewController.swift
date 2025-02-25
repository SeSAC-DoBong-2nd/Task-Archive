//
//  NaverShoppingListViewController.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import UIKit

import Alamofire
import Kingfisher
import SnapKit
import Then

final class NaverShoppingListViewController: BaseViewController {

    private let viewModel: NaverShoppingListViewModel
    
    init(viewModel: NaverShoppingListViewModel) {
        self.viewModel = viewModel
        
        super.init()
    }
    
    deinit {
        print("NaverShoppingListViewController",#function)
    }
    
    private let naverShoppingListView = NaverShoppingListView()
    
    override func loadView() {
        view = naverShoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bindViewModel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        naverShoppingListView.indicatorView.startAnimating()
        filterBtnTapped(naverShoppingListView.accuracyButton)
    }
    
    override func setStyle() {
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .black
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(navLeftBtnTapped))
    }
    
}

private extension NaverShoppingListViewController {
    
    func bindViewModel() {
        viewModel.outputNavTitle.bind { [weak self] title in
            guard let self else {return}
            self.navigationItem.title = title
        }
        
        viewModel.outputShoppingList.lazyBind { [weak self] _ in
            guard let self else {return}
            self.naverShoppingListView.shoppingCollectionView.reloadData()
            self.viewModel.heartSelectedArr = Array(repeating: false, count: viewModel.outputShoppingList.value.count)
        }
        
        viewModel.outputIsSuccessGetShoppingAPI.lazyBind { [weak self] isSuccess in
            guard let self, let isSuccess else {return}
            
            switch isSuccess {
            case true:
                self.naverShoppingListView.resultCntLabel.text = viewModel.total
                
                if viewModel.start == 1 {
                    self.naverShoppingListView.shoppingCollectionView.scrollsToTop = true
                }
                self.naverShoppingListView.indicatorView.stopAnimating()
            case false:
                let alert = UIAlertUtil.showAlert(title: "요청 실패", message: "Error")
                self.present(alert, animated: true)
                print("에러 발생")
            }
        }
        
    }
    
    func setDelegate() {
        naverShoppingListView.shoppingCollectionView.delegate = self
        naverShoppingListView.shoppingCollectionView.dataSource = self
        naverShoppingListView.shoppingCollectionView.prefetchDataSource = self
        
        naverShoppingListView.buttonArr.forEach { i in
            i.addTarget(self, action: #selector(filterBtnTapped), for: .touchUpInside)
        }
    }
    
    func setSelectedButtonUI(_ sender: UIButton) {
        for i in naverShoppingListView.buttonArr {
            if i == sender {
                i.do {
                    $0.backgroundColor = .white
                    $0.setTitleColor(.black, for: .normal)
                }
            } else {
                i.do {
                    $0.backgroundColor = .black
                    $0.setTitleColor(.white, for: .normal)
                }
            }
        }
    }
    
    @objc
    func filterBtnTapped(_ sender: UIButton) {
        print(#function)
        viewModel.inputFilterBtnTapped.value = sender.titleLabel?.text
        setSelectedButtonUI(sender)
    }
    
    @objc
    func heartButtonTapped(_ sender: UIButton) {
        viewModel.heartSelectedArr[sender.tag].toggle()
        switch viewModel.heartSelectedArr[sender.tag] {
        case true:
            sender.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        case false:
            sender.setImage(UIImage(systemName: "heart"), for: .normal)
        }
    }
    
    @objc
    func navLeftBtnTapped() {
        print(#function)
        navigationController?.popViewController(animated: true)
    }
    
}

extension NaverShoppingListViewController: UICollectionViewDataSourcePrefetching {
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        print(#function, indexPaths)
        for i in indexPaths {
            viewModel.inputCallGetShoppingAPI.value = i
        }
        
    }
    
}

extension NaverShoppingListViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function, viewModel.outputShoppingList.value[indexPath.item])
    }
    
}

extension NaverShoppingListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.outputShoppingList.value.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShoppingListCollectionViewCell.cellIdentifier, for: indexPath) as? ShoppingListCollectionViewCell else { return UICollectionViewCell() }
        
        let index = viewModel.outputShoppingList.value[indexPath.item]
        cell.heartButton.tag = indexPath.item
        cell.heartButton.addTarget(self, action: #selector(heartButtonTapped), for: .touchUpInside)
        
        cell.configureShppingListCell(
            imageUrl: index.image,
            shoppingMallName: index.mallName,
            productName: index.title
                .replacingOccurrences(of: "<[^>]+>|&quot;",
                                      with: "",
                                      options: .regularExpression,
                                      range: nil),
            price: Int(index.lprice) ?? 0,
            isHeartBtnSelected: viewModel.heartSelectedArr[indexPath.row]
        )
        
        return cell
    }
    
}
