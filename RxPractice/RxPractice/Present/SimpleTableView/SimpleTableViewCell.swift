//
//  SimpleTableViewCell.swift
//  RxPractice
//
//  Created by 박신영 on 2/18/25.
//

import UIKit

final class SimpleTableViewCell: UITableViewCell {

    static var cellIdentifier: String {
        return String(describing: SimpleTableViewCell.self)
    }
    
    private let label = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setHierarchy()
        setLayout()
        setStyle()
    }
    
    func setHierarchy() {
        contentView.addSubview(label)
    }
    
    func setLayout() {
        label.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    func setStyle() {
        self.selectionStyle = .none
    }
    
    func configureCell(text: String) {
        label.text = text
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
