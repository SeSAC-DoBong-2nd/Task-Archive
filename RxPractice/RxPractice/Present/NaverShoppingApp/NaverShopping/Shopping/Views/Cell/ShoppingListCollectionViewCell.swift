//
//  ShoppingListCollectionViewCell.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import UIKit

import RxSwift

final class ShoppingListCollectionViewCell: BaseCollectionViewCell {
    
    var disposeBag = DisposeBag()
    private let imageView = UIImageView()
    private let mallNameLabel = UILabel()
    private let productLabel = UILabel()
    private let priceLabel = UILabel()
    let heartButton = UIButton()
    
    override func prepareForReuse() {
        heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
        imageView.image = nil
        disposeBag = DisposeBag()
    }
    
    override func setHierarchy() {
        [imageView,
         mallNameLabel,
         productLabel,
         priceLabel].forEach { i in
            contentView.addSubview(i)
        }
        
        imageView.addSubview(heartButton)
    }
    
    override func setLayout() {
        imageView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(self.snp.width)
        }
        
        mallNameLabel.snp.makeConstraints {
            $0.top.equalTo(imageView.snp.bottom).offset(4)
            $0.leading.equalTo(imageView.snp.leading).offset(10)
        }
        
        productLabel.snp.makeConstraints {
            $0.top.equalTo(mallNameLabel.snp.bottom).offset(4)
            $0.leading.equalTo(mallNameLabel.snp.leading)
            $0.trailing.equalToSuperview().offset(-20)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(productLabel.snp.bottom).offset(4)
            $0.leading.equalTo(mallNameLabel.snp.leading)
        }
        
        heartButton.snp.makeConstraints {
            $0.trailing.bottom.equalToSuperview().inset(15)
            $0.size.equalTo(40)
        }
    }
    
    override func setStyle() {
        imageView.isUserInteractionEnabled = true
        
        heartButton.do {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 20
            $0.setImage(UIImage(systemName: "heart"), for: .normal)
            $0.tintColor = .black
            $0.contentMode = .scaleAspectFill
        }
    }
    
    func configureShppingListCell(imageUrl: String,
                                  shoppingMallName: String,
                                  productName: String,
                                  price: Int,
                                  isHeartBtnSelected: Bool)
    {
        imageView.setImageKfDownSampling(with: imageUrl, cornerRadius: 20)
        
        mallNameLabel.do {
            $0.text = shoppingMallName
            $0.font = .systemFont(ofSize: 12, weight: .light)
            $0.textColor = .lightGray
        }
        
        productLabel.do {
            $0.text = productName
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.textColor = .white
            $0.numberOfLines = 2
        }
        
        priceLabel.do {
            $0.text = DateFormatterManager.shard.setDecimalNumber(num: price)
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .white
        }
        
        isHeartBtnSelected
        ? heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        : heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    func configureShppingListCell(model: LikeListTable)
    {
        imageView.setImageKfDownSampling(with: model.imageUrl, cornerRadius: 20)
        
        mallNameLabel.do {
            $0.text = model.mallName
            $0.font = .systemFont(ofSize: 12, weight: .light)
            $0.textColor = .lightGray
        }
        
        productLabel.do {
            $0.text = model.productName
            $0.font = .systemFont(ofSize: 13, weight: .regular)
            $0.textColor = .white
            $0.numberOfLines = 2
        }
        
        priceLabel.do {
            $0.text = DateFormatterManager.shard.setDecimalNumber(num: model.price)
            $0.font = .systemFont(ofSize: 16, weight: .medium)
            $0.textColor = .white
        }
        
        model.isLike
        ? heartButton.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        : heartButton.setImage(UIImage(systemName: "heart"), for: .normal)
    }
    
    
}
