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
 
 답변:
 - 첫번째 질문은 combineLatest와 merge의 차이를 조금 더 알아보자. 각 오퍼레이터들은 분명하게 각각 생겨난 이유가 존재한다.
 - 두번째 질문은 combineLatest는 무조건 한번은 발생해야 이후 하나라도 바뀌었을 때 다 동작이된다.
    즉, 위 textfield.text.orEmpty는 텍스트필드 특성상 무조건 발생하는거라 이후 이 친구들을 핸들링할 때에 combineLatest를 사용한다고 봐도 무방하다.
 */
