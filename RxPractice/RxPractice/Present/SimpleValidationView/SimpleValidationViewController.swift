//
//  SimpleValidationViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/18/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class SimpleValidationViewController : UIViewController {
    
    //MARK: - Properties
    private let minimalUsernameLength = 5
    private let minimalPasswordLength = 5
    private let disposeBag = DisposeBag()

    //MARK: - UI Properties
    private let usernameOutlet = UITextField()
    private let usernameValidOutlet = UILabel()
    
    private let passwordOutlet = UITextField()
    private let passwordValidOutlet = UILabel()
    
    private let doSomethingOutlet = UIButton()

    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setHierarchy()
        setLayout()
        setStyle()
        bind()
    }
    
    private func setHierarchy() {
        [usernameOutlet, usernameValidOutlet, passwordOutlet, passwordValidOutlet, doSomethingOutlet].forEach { i in
            view.addSubview(i)
        }
    }
    
    private func setLayout() {
        usernameOutlet.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        usernameValidOutlet.snp.makeConstraints {
            $0.top.equalTo(usernameOutlet.snp.bottom).offset(10)
            $0.horizontalEdges.width.equalTo(usernameOutlet)
        }
        
        passwordOutlet.snp.makeConstraints {
            $0.top.equalTo(usernameValidOutlet.snp.bottom).offset(10)
            $0.trailing.width.equalTo(usernameOutlet)
        }
        
        passwordValidOutlet.snp.makeConstraints {
            $0.top.equalTo(passwordOutlet.snp.bottom).offset(10)
            $0.trailing.width.equalTo(usernameOutlet)
        }
        
        doSomethingOutlet.snp.makeConstraints {
            $0.top.equalTo(passwordValidOutlet.snp.bottom).offset(10)
            $0.trailing.width.equalTo(usernameOutlet)
            $0.height.equalTo(100)
        }
    }
    
    private func setStyle() {
        view.backgroundColor = .brown
        
        [usernameOutlet, passwordOutlet].forEach { i in
            i.do {
                $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                $0.backgroundColor = .white
            }
        }
        
        [usernameValidOutlet, passwordValidOutlet].forEach { i in
            i.do {
                $0.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
                $0.backgroundColor = .lightGray
                $0.textColor = .red
            }
        }
        
        doSomethingOutlet.do {
            $0.layer.cornerRadius = 10
        }
        
        //doSomethingOutlet 버튼의 비활성화와 활성화 상태 분기처리
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            var config = UIButton.Configuration.plain()
            config.title = "done"
            button.configuration = config
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = .lightGray.withAlphaComponent(0.6)
                button.configuration?.baseForegroundColor = .black
            case .normal:
                button.configuration?.background.backgroundColor = .green.withAlphaComponent(0.6)
                button.configuration?.baseForegroundColor = .white
            default:
                print("buttonStateHandler error")
            }
        }
        doSomethingOutlet.configurationUpdateHandler = buttonStateHandler
    }
    
    private func bind() {
        usernameValidOutlet.text = "Username has to be at least \(minimalUsernameLength) characters"
        passwordValidOutlet.text = "Password has to be at least \(minimalPasswordLength) characters"

        let usernameValid = usernameOutlet.rx.text.orEmpty
            .withUnretained(self)
            .map({ owner, value in
                value.count >= owner.minimalUsernameLength
            })
            .share(replay: 1)
            //share 활용하여 가장 최근 값을 유지하고, 이미 계산된 값을 저장한 이후 구독자에게 저장된 값 제공
            //추후 새로운 구독자가 생겨도 이미 계산하여 저장된 값 활용하기에 과호출 방지

        let passwordValid = passwordOutlet.rx.text.orEmpty
            .withUnretained(self)
            .map({ owner, value in
                value.count >= owner.minimalPasswordLength
            })
            .share(replay: 1)

        let everythingValid = Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
            .share(replay: 1)

        
        //아래 값들이 bind인 이유:
            //단 발성으로 끝내는 것이 아니고, 값의 변화에 따라 ui에 계속 변화를 가져다 줘야함.
            //즉, infinite 이기에 bind로 next만 꿀밤 줌
        
        usernameValid
            .bind(to: passwordOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        usernameValid
            .bind(to: usernameValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        passwordValid
            .bind(to: passwordValidOutlet.rx.isHidden)
            .disposed(by: disposeBag)

        everythingValid
            .bind(to: doSomethingOutlet.rx.isEnabled)
            .disposed(by: disposeBag)

        doSomethingOutlet.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.showAlert()
            })
            .disposed(by: disposeBag)
    }
    
    private func showAlert() {
        let defaultAction = UIAlertAction(title: "Ok",
                                          style: .default,
                                          handler: nil)
        let alert = UIAlertManager.showAlertWithAction(title: "RxExample", message: "This is wonderful", doneAction: defaultAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
}
