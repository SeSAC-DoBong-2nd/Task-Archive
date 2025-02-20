//
//  DetailViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/19/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

final class DetailViewController: UIViewController {
    
    private let disposeBag = DisposeBag()
    
    let buttonTitle: String
    lazy var nextButton = PointButton(title: buttonTitle)
    
    init(buttonTitle: String) {
        self.buttonTitle = buttonTitle
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .lightGray
        navigationItem.title = "Detail"
        view.addSubview(nextButton)
        
        nextButton.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(130)
            $0.height.equalTo(50)
        }
        
        //아래와 같이 작성했다 하더라도, tap 자체는 Observable<Int> 타입으로 만들어졌으나, 구독하는 횟수만큼 그 스트림이 각각 만들어진다.
            //그래서 tap 버튼이 눌려도 각 다른 값이 출력되는 것.
        //해결법: => share() 를 사용하여 제일 최신 값을 저장해두고 이후 구독하는 옵저버들에 그 최신 값을 뿌려준다.
        
        let tap = nextButton.rx.tap
            .map {Int.random(in: 1...100)}
            .share(replay: 1)
        
        tap
            .bind(with: self) { owner, value in
                print("1번 - \(value)")
            }
            .disposed(by: disposeBag)
        
        tap
            .bind(with: self) { owner, value in
                print("2번 - \(value)")
            }
            .disposed(by: disposeBag)
        
        tap
            .bind(with: self) { owner, value in
                print("3번 - \(value)")
            }
            .disposed(by: disposeBag)
    }
    
}

