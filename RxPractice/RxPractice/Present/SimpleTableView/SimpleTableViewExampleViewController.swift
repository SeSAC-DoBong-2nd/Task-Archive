//
//  SimpleTableViewExampleViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/18/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class SimpleTableViewExampleViewController : UIViewController, UITableViewDelegate {
    
    //MARK: - Properties
    private let items = Observable.just( (0..<20).map { "\($0)" } )
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Properties
    private let tableView = UITableView(frame: .zero, style: .plain)

    override func viewDidLoad() {
        super.viewDidLoad()

        setupView()
        bind()
    }
    
    private func setupView() {
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(view.safeAreaLayoutGuide)
        }
        
        tableView.do {
            $0.rowHeight = 80
            $0.register(SimpleTableViewCell.self, forCellReuseIdentifier: SimpleTableViewCell.cellIdentifier)
        }
    }
    
    private func bind() {
        //items의 값을 바로 tableview items에 때려 넣는다.
        //bind로 한 이유는 현재 items이 정의돼있고, 에러가 발생할 일이 없기 때문
        items
            .bind(to: tableView.rx.items(cellIdentifier: SimpleTableViewCell.cellIdentifier, cellType: SimpleTableViewCell.self)) { (row, element, cell) in
                cell.configureCell(text: "\(element) @ row \(row)")
                cell.accessoryType = .detailButton
            }
            .disposed(by: disposeBag)

        //modelSelected: 테이블 뷰의 datasource에 접근하는 느낌
        //선택 시 해당 indexPath에 담긴 model 원소 값에 접근
//        tableView.rx
//            .modelSelected(String.self)
//            .subscribe(onNext:  { value in
//                let alert = UIAlertManager.showAlert(title: "start alert", message: "Tapped `\(value)`")
//                self.present(alert, animated: true)
//            })
//            .disposed(by: disposeBag)
//
//        //itemAccessoryButtonTapped: 애플이 만든 테이블 뷰 속 악세사리 버튼 터치 시 발생 이벤트
//        //indexPath 값을 다루기에 해당 각 cell에 역할 할당 가능
//        tableView.rx
//            .itemAccessoryButtonTapped
//            .subscribe(onNext: { indexPath in
//                let alert = UIAlertManager.showAlert(title: "start alert", message: "Tapped Detail @ \(indexPath.section),\(indexPath.row)")
//                self.present(alert, animated: true)
//            })
//            .disposed(by: disposeBag)
        
        
        //위 둘을 합쳐 아래와 같이 구상해도 될 줄 알았으나, 통상적으로 사용자는 악세사리 뷰와 해당 cell을 동시에 누르지 않기에 동시에 이벤트가 발생해야 방출하는 zip과는 어울리지 못 했음
        //subscribe의 이유는 finite 이벤트이기 때문
//        Observable.zip(
//            tableView.rx.modelSelected(String.self),
//            tableView.rx.itemAccessoryButtonTapped
//        )
//        .subscribe(with: self) { owner, value in
//            let alert = UIAlertManager.showAlert(title: "start alert", message: "Tapped `\(value.0)`\nTapped Detail @ \(value.1.section),\(value.1.row)")
//            owner.present(alert, animated: true)
//        }
//        .disposed(by: disposeBag)
        
        
        //위 상황의 해결! 'merge'
        //merge는 둘 중 하나의 이벤트라도 발생하면 안에 결합된 이벤트가 개별적으로 움직일 수 있다.
        //zip과 merge를 각각 &&와 ||로 이해해버렸다!
        Observable.merge(
            tableView.rx.modelSelected(String.self)
                .map { value in "Tapped `\(value)`" },
            
            tableView.rx.itemAccessoryButtonTapped
                .map { indexPath in "Tapped Detail @ \(indexPath.section),\(indexPath.row)" }
        )
        .subscribe(with: self) { owner, message in
            let alert = UIAlertManager.showAlert(title: "Merged Event", message: message)
            owner.present(alert, animated: true)
        }
        .disposed(by: disposeBag)
    }

}


/*
 질문
 - tableView.rx.modelSelected(String.self),tableView.rx.itemAccessoryButtonTapped 와 같이 한번만 설정해주는 친구들일 때 subscribe인 것을 이해하였으나, 만약 어떠한 조건으로 인하여 상태가 변한 뒤 눌렀을 때 이벤트가 달라져야한다면 기존 것을 구독해제하고 새로 추가하는게 좋을지? 아니면 bind로 다루는게 좋을지
 */

