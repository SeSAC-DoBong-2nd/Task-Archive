//
//  NaverShoppingListViewController.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift
import Kingfisher
import SnapKit
import Then

final class NaverShoppingListViewController: BaseViewController {
    
    private let viewModel: NaverShoppingListViewModel
    private let disposeBag = DisposeBag()
    private let filterButtonTappedSubject = PublishSubject<String>()
    private let loadMoreDataSubject = PublishSubject<IndexPath>()
    
    init(viewModel: NaverShoppingListViewModel, navtitle: String) {
        self.viewModel = viewModel
        
        super.init()
        self.navigationItem.title = navtitle
        self.viewModel.currentSearchText = navtitle
    }
    
    deinit {
        print("NaverShoppingListViewController", #function)
    }
    
    private let naverShoppingListView = NaverShoppingListView()
    
    override func loadView() {
        view = naverShoppingListView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setDelegate()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        naverShoppingListView.indicatorView.startAnimating()
        naverShoppingListView.accuracyButton.sendActions(for: .touchUpInside)
    }
    
    override func setStyle() {
        view.backgroundColor = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left"),
                                                           style: .done,
                                                           target: nil,
                                                           action: nil)
    }
    
    private func bind() {
        let input = NaverShoppingListViewModel.Input(
            tapNavLeftBtn: navigationItem.leftBarButtonItem?.rx.tap,
            filterBtnTapped: filterButtonTappedSubject.asObservable(),
            loadMoreData: naverShoppingListView.shoppingCollectionView.rx.prefetchItems
        )
        
        let output = viewModel.transform(input: input)
        
        //navLeftBtn 탭 처리
        output.tapNavLeftBtn?
            .drive(with: self, onNext: { owner, _ in
                owner.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)
        
        //CollectionView에 데이터 바인딩
        output.shoppingList
            .drive(naverShoppingListView.shoppingCollectionView.rx.items(
                cellIdentifier: ShoppingListCollectionViewCell.cellIdentifier,
                cellType: ShoppingListCollectionViewCell.self)) { [weak self] index, item, cell in
                    guard let self = self else { return }
                    
                    //heartSelectedArr 배열 크기 관리 (좋아요 담당 배열)
                    if self.viewModel.heartSelectedArr.count <= index {
                        self.viewModel.heartSelectedArr.append(false)
                    }
                    
                    //셀 구성
                    cell.configureShppingListCell(
                        imageUrl: item.image,
                        shoppingMallName: item.mallName,
                        productName: item.title
                            .replacingOccurrences(of: "<[^>]+>|&quot;",
                                                  with: "",
                                                  options: .regularExpression,
                                                  range: nil),
                        price: Int(item.lprice) ?? 0,
                        isHeartBtnSelected: self.viewModel.heartSelectedArr[index]
                    )
                    
                    //하트 버튼 태그 및 액션 설정
                    cell.heartButton.tag = index
                    cell.heartButton.rx.tap
                        .subscribe(onNext: { [weak self] in
                            guard let self = self else { return }
                            self.viewModel.heartSelectedArr[index].toggle()
                            
                            let heartImage = self.viewModel.heartSelectedArr[index]
                            ? UIImage(systemName: "heart.fill")
                            : UIImage(systemName: "heart")
                            cell.heartButton.setImage(heartImage, for: .normal)
                        })
                        .disposed(by: cell.disposeBag)
                            //셀이 재사용 시 dispose 필요하기에 셀의 disposeBag에서 관리
                }
                .disposed(by: disposeBag)
        
        //셀 선택 처리
        naverShoppingListView.shoppingCollectionView.rx.itemSelected
            .subscribe(with: self) { owner, indexPath in
                // 셀 선택 시 작업 추후 추가
                print("Selected item at \(indexPath)")
            }.disposed(by: disposeBag)
        
        //스크롤 시 최상단 이동 여부
        output.shoppingList
            .drive(with: self, onNext: { owner, items in
                if !items.isEmpty && owner.viewModel.start == 1 {
                    owner.naverShoppingListView.shoppingCollectionView.scrollsToTop = true
                    // 실제로 스크롤을 맨 위로 이동
                    owner.naverShoppingListView.shoppingCollectionView.scrollToItem(
                        at: IndexPath(item: 0, section: 0),
                        at: .top,
                        animated: true
                    )
                }
            })
            .disposed(by: disposeBag)
        
        //API 호출 결과 처리
        output.isSuccessGetShoppingAPI
            .drive(with: self, onNext: { owner, isSuccess in
                guard let isSuccess = isSuccess else { return }
                
                switch isSuccess {
                case true:
                    owner.naverShoppingListView.indicatorView.stopAnimating()
                case false:
                    let alert = UIAlertManager.showAlert(title: "요청 실패", message: "Error")
                    owner.present(alert, animated: true)
                    print("에러 발생")
                }
            })
            .disposed(by: disposeBag)
        
        //검색 결과 수 업데이트
        output.totalCount
            .drive(naverShoppingListView.resultCntLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

private extension NaverShoppingListViewController {
    
    func setDelegate() {
        //버튼 바인딩
        for (_, button) in naverShoppingListView.buttonArr.enumerated() {
            button.rx.tap
                .subscribe(onNext: { [weak self] in
                    guard let self = self else { return }
                    self.setSelectedButtonUI(button)
                    if let title = button.titleLabel?.text {
                        self.filterButtonTappedSubject.onNext(title)
                    }
                })
                .disposed(by: disposeBag)
        }
    }
    
    func setSelectedButtonUI(_ sender: UIButton) {
        for button in naverShoppingListView.buttonArr {
            if button == sender {
                button.do {
                    $0.backgroundColor = .white
                    $0.setTitleColor(.black, for: .normal)
                }
            } else {
                button.do {
                    $0.backgroundColor = .black
                    $0.setTitleColor(.white, for: .normal)
                }
            }
        }
    }
    
}
