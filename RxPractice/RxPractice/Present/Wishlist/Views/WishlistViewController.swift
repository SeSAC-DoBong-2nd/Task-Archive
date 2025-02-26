//
//  WishlistViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/27/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class WishlistViewController: BaseViewController {
    
    
    
    enum Section: CaseIterable {
        case main
    }
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    private var wishlistItems: [WishlistItem] = []
    
    //MARK: - UI Properties
    private lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
    
    private let searchBar = UISearchBar()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, WishlistItem>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bindSearchBar()
        updateSnapshot(with: wishlistItems)
        
        navigationItem.title = "위시리스트"
    }
    
    override func setHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(searchBar)
    }
    
    override func setLayout() {
        searchBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    override func setStyle() {
        view.backgroundColor = .systemBackground
        
        collectionView.do {
            $0.backgroundColor = .systemBackground
            $0.delegate = self
        }
        
        searchBar.do {
            $0.placeholder = "위시리스트 항목 추가"
            $0.searchBarStyle = .minimal
        }
    }
    
    //MARK: - 컬렉션 뷰 레이아웃
    private func createLayout() -> UICollectionViewLayout {
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = true
        configuration.backgroundColor = .systemBackground
        
        return UICollectionViewCompositionalLayout.list(using: configuration)
    }
    
    //MARK: - DataSource 세팅
    private func configureDataSource() {
        let registration = UICollectionView.CellRegistration<UICollectionViewListCell, WishlistItem> { cell, indexPath, item in
            var content = UIListContentConfiguration.subtitleCell()
            content.text = item.name
            content.secondaryText = "\(item.formattedPrice) - 추가일: \(item.formattedDate)"
            content.textProperties.font = .boldSystemFont(ofSize: 16)
            content.textProperties.color = .white
            content.secondaryTextProperties.font = .systemFont(ofSize: 14)
            content.secondaryTextProperties.color = .secondaryLabel
            
            var backgroundConfig = UIBackgroundConfiguration.listCell()
            backgroundConfig.backgroundColor = .black
            backgroundConfig.cornerRadius = 6
            backgroundConfig.strokeColor = .orange
            backgroundConfig.strokeWidth = 1
            
            cell.contentConfiguration = content
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, WishlistItem>(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            return collectionView.dequeueConfiguredReusableCell(using: registration, for: indexPath, item: itemIdentifier)
        }
    }
    
    //MARK: - Data apply
    private func updateSnapshot(with items: [WishlistItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, WishlistItem>()
        snapshot.appendSections(Section.allCases)
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    // MARK: - 서치바 리턴 시 동작
    private func bindSearchBar() {
        searchBar.rx.searchButtonClicked
            .withLatestFrom(searchBar.rx.text.orEmpty)
            .subscribe(onNext: { [weak self] text in
                guard let self = self, !text.isEmpty else { return }
        
                let newItem = WishlistItem(
                    name: text,
                    date: Date(),
                    price: Int.random(in: 10000...100000) * 100 //랜덤 가격
                )
                
                self.wishlistItems.append(newItem)
                self.updateSnapshot(with: self.wishlistItems)
                self.searchBar.text = ""
                self.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 아이템 삭제
    private func removeItem(at indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        
        //고유한 값으로 비교하여 실수 방지
        wishlistItems.removeAll { $0.id == item.id }
        updateSnapshot(with: wishlistItems)
    }
}

//MARK: - cell 클릭 시
extension WishlistViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let itemName = dataSource.itemIdentifier(for: indexPath)?.name
        let doneAction = UIAlertAction(title: "제거", style: .destructive) { [weak self] _ in
            self?.removeItem(at: indexPath)
        }
        
        let alert = UIAlertManager.shared.showAlertWithAction(title: "위시리스트 제거",
                                                              message: "\(itemName ?? "실패") 항목을 위시리스트에서 제거하시겠습니까?",
                                                              cancelFunc: true,
                                                              doneAction: doneAction)
        self.present(alert, animated: true)
    }
    
}
