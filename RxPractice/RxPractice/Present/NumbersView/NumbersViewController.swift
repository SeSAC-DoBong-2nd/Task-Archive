//
//  NumbersViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/18/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

//계산기
final class NumbersViewController: UIViewController {
    
    //MARK: - Properties
    private let disposeBag = DisposeBag()
    
    //MARK: - UI Properties
    private let number1 = UITextField()
    private let number2 = UITextField()
    private let number3 = UITextField()
    private let result = UILabel()
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
        bind()
    }
    
    private func setHierarchy() {
        [number1, number2, number3, result].forEach { i in
            view.addSubview(i)
        }
    }
    
    private func setLayout() {
        number1.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            $0.width.equalTo(130)
        }
        
        number2.snp.makeConstraints {
            $0.top.equalTo(number1.snp.bottom).offset(10)
            $0.trailing.width.equalTo(number1)
        }
        
        number3.snp.makeConstraints {
            $0.top.equalTo(number2.snp.bottom).offset(10)
            $0.trailing.width.equalTo(number1)
        }
        
        result.snp.makeConstraints {
            $0.top.equalTo(number3.snp.bottom).offset(10)
            $0.trailing.width.equalTo(number1)
        }
    }
    
    private func setStyle() {
        view.backgroundColor = .brown
        
        [number1, number2, number3].forEach { i in
            i.do {
                $0.backgroundColor = .white
                $0.keyboardType = .numberPad
            }
        }
        
        result.backgroundColor = .white
    }
    
    private func bind() {
        Observable.combineLatest(
            number1.rx.text.orEmpty,
            number2.rx.text.orEmpty,
            number3.rx.text.orEmpty
        ) { (textValue1, textValue2, textValue3) -> Int in
            return (Int(textValue1) ?? 0) + (Int(textValue2) ?? 0) + (Int(textValue3) ?? 0)
        }
        .map { "총합: " + $0.description }
        .bind(to: result.rx.text)
        .disposed(by: disposeBag)
    }
}

/* #질문
 - combineLatest으로 하나 merge로 하나 하나의 값이라도 바뀌면 동작하는건데 메리트가 뭘까?
    - 후행클로저 때문인가?
 - combineLatest는 하나의 값이 바뀐다면 모든 값과 관련된 같은 작업을 할 때 사용하는건가?
 */
