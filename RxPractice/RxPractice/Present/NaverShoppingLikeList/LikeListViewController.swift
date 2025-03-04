//
//  LikeListViewController.swift
//  RxPractice
//
//  Created by 박신영 on 3/4/25.
//

import UIKit

import Alamofire
import RealmSwift
import RxCocoa
import RxSwift
import Kingfisher
import SnapKit
import Then
import Toast

final class LikeListViewController: BaseViewController {
    
    private let viewModel: LikeListViewModel
    private let disposeBag = DisposeBag()
    private let realm = try! Realm()
    private let listSubject = BehaviorRelay<Results<LikeListTable>>(value: try! Realm().objects(LikeListTable.self))
    private var style = ToastStyle()
    
    private let naverShoppingListView = NaverShoppingListView()
    private let searchBar = UISearchBar()
    
    init(viewModel: LikeListViewModel) {
        self.viewModel = viewModel
        super.init()
    }
    
    override func loadView() {
        view = naverShoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }
    
    override func setStyle() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .done,
                                                           target: nil,
                                                           action: nil)
        
        searchBar.placeholder = "검색할 상품을 입력해주세요"
           navigationItem.titleView = searchBar
        
        naverShoppingListView.filterContainerView.isHidden = true
        naverShoppingListView.shoppingCollectionView.snp.remakeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    //서치바 검색 필터 로직
    private func searchItems(searchText: String) {
        switch searchText.isEmpty {
        case true:
            print("현재 공백", searchText)
            self.listSubject.accept(self.realm.objects(LikeListTable.self))
        case false:
            print("현재 non공백", searchText)
            let filterList = self.realm.objects(LikeListTable.self)
                .filter("productName CONTAINS[c] %@", searchText)
            // CONTAINS[c]: 대소문자 구분 없이
            // %@: searchText 값 그대로? SQL 방식이라 하는데 아직 잘 몰라서 조금 더 찾아봐야함!
            
            self.listSubject.accept(filterList)
        }
    }
    
    private func bind() {
        let input = LikeListViewModel.Input(
            tapNavLeftBtn: navigationItem.leftBarButtonItem?.rx.tap,
            searchBarText: searchBar.rx.text.orEmpty
        )
        let output = viewModel.transform(input: input)
        
        output.tapNavLeftBtnResult?
            .bind(with: self, onNext: { owner, _ in
                self.navigationController?.popViewController(animated: true)
            }).disposed(by: disposeBag)
        
        output.searchBarTextResult
            .drive(with: self) { owner, text in
                owner.searchItems(searchText: text)
            }.disposed(by: disposeBag)
        
        //realm vm으로 분리하다 실패해버렸습니다..
        listSubject
            .bind(to: naverShoppingListView.shoppingCollectionView.rx.items(
                cellIdentifier: ShoppingListCollectionViewCell.cellIdentifier,
                cellType: ShoppingListCollectionViewCell.self)) { [weak self] index, model, cell in
                    cell.configureShppingListCell(model: model)
                }
                .disposed(by: disposeBag)
        
        naverShoppingListView.shoppingCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                owner.deleteItem(at: indexPath)
            }
            .disposed(by: disposeBag)
    }
    
    private func deleteItem(at indexPath: IndexPath) {
        do {
            let currentList = listSubject.value
            let itemToDelete = currentList[indexPath.item]
            let productName = listSubject.value[indexPath.item].productName
            
            try realm.write {
                realm.delete(itemToDelete)
                
                //async로 적용하지 않으면 realm의 list와 collectionview의 동기화가 어긋나더라구요..
                DispatchQueue.main.async {
                    self.listSubject.accept(self.realm.objects(LikeListTable.self))
                    // self.showToast(productName: itemToDelete.productName) //해당코드에서 이미 삭제된 indexitem에 접근해서 오류발생했었음
                    self.showToast(productName: productName)
                }
            }
        } catch {
            showToast(productName: listSubject.value[indexPath.item].productName, onError: true)
        }
    }
    
    private func showToast(productName: String, onError: Bool = false) {
        style.backgroundColor = .lightGray
        style.titleColor = onError ? .red : .white
        style.titleFont = .boldSystemFont(ofSize: 14)
        style.cornerRadius = 10
        
        let message = onError
            ? "\(productName) 상품 제거를 실패하였습니다."
            : "\(productName) 상품이 좋아요 목록에서 제거되었습니다."
        
        view.makeToast(message, duration: 2.0, position: .bottom, style: style)
    }
}



/*
 - rxRealm 사용해서 써보고싶었는데, add package를 계속 실패했습니다..
 */
