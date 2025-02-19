//
//  BirthdayViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/18/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class BirthdayViewController: UIViewController {
    
    // MARK: - Properties
    private let minimalAge = 17
    private let disposeBag = DisposeBag()
    private var infoLabelText = BehaviorSubject(value: false)
    
    
    // MARK: - UI Properties
    private let birthDayPicker = UIDatePicker()
    private let infoLabel = UILabel()
    
    private let containerStackView = UIStackView()
    private let yearLabel = UILabel()
    private let monthLabel = UILabel()
    private let dayLabel = UILabel()
    
    private let nextButton = PointButton(title: "")
    
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
        bind()
    }
    
    private func setHierarchy() {
        [infoLabel, containerStackView, birthDayPicker, nextButton].forEach {
            view.addSubview($0)
        }
        
        [yearLabel, monthLabel, dayLabel].forEach {
            containerStackView.addArrangedSubview($0)
        }
    }
    
    private func setLayout() {
        infoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(150)
            $0.centerX.equalToSuperview()
        }
        
        containerStackView.snp.makeConstraints {
            $0.top.equalTo(infoLabel.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        birthDayPicker.snp.makeConstraints {
            $0.top.equalTo(containerStackView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
        
        nextButton.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.top.equalTo(birthDayPicker.snp.bottom).offset(30)
            $0.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        yearLabel.snp.makeConstraints { $0.width.equalTo(100) }
        monthLabel.snp.makeConstraints { $0.width.equalTo(100) }
        dayLabel.snp.makeConstraints { $0.width.equalTo(100) }
    }
    
    private func setStyle() {
        view.backgroundColor = .white
        
        birthDayPicker.do {
            $0.datePickerMode = .date
            $0.preferredDatePickerStyle = .wheels
            $0.locale = Locale(identifier: "ko-KR")
            $0.maximumDate = Date() //미래 날짜 불가
        }
        
        infoLabel.do {
            $0.textColor = .black
        }
        
        containerStackView.do {
            $0.axis = .horizontal
            $0.distribution = .equalSpacing
            $0.spacing = 10
        }
            
        yearLabel.do {
            $0.text = "2025년"
            $0.textColor = .black
        }
            
        monthLabel.do {
            $0.text = "2월"
            $0.textColor = .black
        }
        
        dayLabel.do {
            $0.text = "19일"
            $0.textColor = .black
        }
        
        nextButton.do {
            $0.isEnabled = false
            $0.addTarget(self, action: #selector(nextButtonClicked), for: .touchUpInside)
        }
        
        let buttonStateHandler: UIButton.ConfigurationUpdateHandler = { button in
            var config = UIButton.Configuration.plain()
            config.title = "가입하기" //title 설정 있어야 보임
            button.configuration = config
            switch button.state {
            case .disabled:
                button.configuration?.background.backgroundColor = .lightGray.withAlphaComponent(0.8)
                button.configuration?.baseForegroundColor = .white
            case .normal:
                button.configuration?.background.backgroundColor = .black
                button.configuration?.baseForegroundColor = .white
            default:
                print("buttonStateHandler error")
            }
        }
        nextButton.configurationUpdateHandler = buttonStateHandler
    }
    
    private func bind() {
        birthDayPicker.rx.date
            .changed
            .withUnretained(self)
            .filter { owner, date in
                let isValid =
                (owner.returnYearOfInt(date: Date()) - owner.returnYearOfInt(date: date)) >= owner.minimalAge
                //해당 date의 연도를 오늘 날 연도와 비교하여 17이상인지 판단
                
                owner.infoLabelText.onNext(isValid)
                return true
                //아래 map은 필터링 거치지 않은 모든 date가 돌아야 해당 일자를 표시해줄 수 있기 때문에 default 값으로 true를 설정
            }
            .map { owner, date in
                let arr = owner.returnDateOfString(date: date).components(separatedBy: ".")
                return (owner, arr)
            }
            .bind { owner, dateArr in
                print("date: \(dateArr)")
                owner.yearLabel.text = dateArr[0] + "년"
                owner.monthLabel.text = dateArr[1] + "월"
                owner.dayLabel.text = dateArr[2] + "일"
            }
            .disposed(by: disposeBag)
        
        infoLabelText
            .bind(with: self, onNext: { owner, isValid in
                owner.nextButton.isEnabled = isValid
                switch isValid {
                case true:
                    owner.infoLabel.text = "!가입 가능 축하드립니다!"
                case false:
                    owner.infoLabel.text = "만 17세 이상만 가입 가능합니다."
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func returnYearOfInt(date: Date) -> Int {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        
        let yearOfInt = Int(formatter.string(from: date)) ?? 0
        return yearOfInt
    }
    
    private func returnDateOfString(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        
        return formatter.string(from: date)
    }
    
    @objc
    private func nextButtonClicked() {
        print(#function)
        self.navigationController?.pushViewController(SimpleTableViewExampleViewController(), animated: true)
    }
    
}
