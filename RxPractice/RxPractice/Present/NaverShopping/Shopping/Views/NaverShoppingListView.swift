//
//  NaverShoppingListView.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/16/25.
//

import UIKit

enum FilterButton: String, CaseIterable {
    case sim = "  정확도  "
    case date = "  날짜순  "
    case dsc = "  가격높은순  "
    case asc = "  가격낮은순  "
}

final class NaverShoppingListView: BaseView {
    
    private let collectionViewInset = 10
    private let buttonStrArr = FilterButton.allCases
    lazy var buttonArr = [accuracyButton, byDateButton, priceHigherButton, priceLowestButton]
    
    let indicatorView = UIActivityIndicatorView(style: .large)
    let resultCntLabel = UILabel()
    private let filterContainerView = UIView()
    let accuracyButton = UIButton()
    private let byDateButton = UIButton()
    private let priceHigherButton = UIButton()
    private let priceLowestButton = UIButton()
    lazy var shoppingCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    
    override func setHierarchy() {
        self.addSubviews(resultCntLabel,
                         filterContainerView,
                         shoppingCollectionView,
                         indicatorView)
        
        filterContainerView.addSubviews(accuracyButton,
                                        byDateButton,
                                        priceHigherButton,
                                        priceLowestButton)
    }
    
    override func setLayout() {
        indicatorView.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        resultCntLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide)
            $0.leading.equalToSuperview().offset(10)
        }
        
        filterContainerView.snp.makeConstraints {
            $0.top.equalTo(resultCntLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(7)
            $0.height.equalTo(35)
        }
        
        shoppingCollectionView.snp.makeConstraints {
            $0.top.equalTo(filterContainerView.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview().inset(collectionViewInset)
            $0.bottom.equalToSuperview()
        }
        
        accuracyButton.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
        }
        
        byDateButton.snp.makeConstraints {
            $0.leading.equalTo(accuracyButton.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview()
        }
        
        priceHigherButton.snp.makeConstraints {
            $0.leading.equalTo(byDateButton.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview()
        }
        
        priceLowestButton.snp.makeConstraints {
            $0.leading.equalTo(priceHigherButton.snp.trailing).offset(10)
            $0.verticalEdges.equalToSuperview()
        }
    }
    
    override func setStyle() {
        indicatorView.do {
            $0.color = .lightGray
        }
        
        resultCntLabel.setLabelUI("",
                                  font: .boldSystemFont(ofSize: 16),
                                  textColor: .systemGreen)
        
        shoppingCollectionView.do {
            let itemSpacing: CGFloat = 10
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumInteritemSpacing = itemSpacing
            layout.minimumLineSpacing = 14
            let widthAbleSize = (UIScreen.main.bounds.width - itemSpacing - CGFloat(collectionViewInset * 2))
            layout.itemSize = CGSize(width: widthAbleSize/2, height: widthAbleSize/2 + 80)
            $0.collectionViewLayout = layout
            $0.backgroundColor = .clear
            $0.register(ShoppingListCollectionViewCell.self,
                        forCellWithReuseIdentifier: ShoppingListCollectionViewCell.cellIdentifier)
        }
        
        for i in 0..<buttonArr.count {
            buttonArr[i].do {
                $0.setTitle(buttonStrArr[i].rawValue, for: .normal)
                $0.layer.borderWidth = 1
                $0.layer.borderColor = UIColor.white.cgColor
                $0.layer.cornerRadius = 10
            }
        }
    }
    
}
