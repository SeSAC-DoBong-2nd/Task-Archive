//
//  LotteryViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/24/25.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

final class LotteryViewController: UIViewController {
    
    init(viewModel: LotteryViewModel) {
        self.viewModel = viewModel
        
        super.init(nibName: nil, bundle: nil)
    }
    
    
    //MARK: - Property
    let stackViewSpacing = 5
    
    //(screen width - (ballStackView inset 값 + spacing*7)) / 8
    lazy var ballSize = (self.view.bounds.width - CGFloat((30 + stackViewSpacing * 7))) / 8
    private let viewModel: LotteryViewModel
    private let disposeBag = DisposeBag()
    
    
    //MARK: - UI Property
    private let lottoTextField = UITextField()
    private lazy var lottoPickerView = UIPickerView()
    private let introduceLabel = UILabel()
    private let dateLabel = UILabel()
    private let underLineView = UIView()
    private let resultLabel = UILabel()
    private let ballStackView = UIStackView()
    private let firstWinNumView = UIView()
    private let secondWinNumView = UIView()
    private let thirdWinNumView = UIView()
    private let fourthWinNumView = UIView()
    private let fifthWinNumView = UIView()
    private let sixthWinNumView = UIView()
    private let plusLabelView = UIView()
    private let bonusWinNumView = UIView()
    private let bonusLabel = UILabel()
    private let observableBtn = UIButton()
    private let singleBtn = UIButton()
    
    lazy var stackViewList = [
        firstWinNumView,
        secondWinNumView,
        thirdWinNumView,
        fourthWinNumView,
        fifthWinNumView,
        sixthWinNumView,
        plusLabelView,
        bonusWinNumView
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setHierarchy()
        setLayout()
        setStyle()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - UI
private extension LotteryViewController {
    
    func setHierarchy() {
        [lottoTextField,
         introduceLabel,
         dateLabel,
         underLineView,
         resultLabel,
         ballStackView,
         bonusLabel,
         observableBtn,
         singleBtn].forEach { i in
            view.addSubview(i)
        }
        
        stackViewList.forEach { i in
            ballStackView.addArrangedSubview(i)
        }
    }
    
    func setLayout() {
        lottoTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(30)
            $0.height.equalTo(40)
        }
        
        underLineView.snp.makeConstraints {
            $0.top.equalTo(lottoTextField.snp.bottom).offset(50)
            $0.horizontalEdges.equalToSuperview().inset(25)
            $0.height.equalTo(0.5)
        }
        
        introduceLabel.snp.makeConstraints {
            $0.bottom.equalTo(underLineView.snp.top).offset(-10)
            $0.leading.equalTo(underLineView.snp.leading)
        }
        
        dateLabel.snp.makeConstraints {
            $0.bottom.equalTo(introduceLabel.snp.bottom)
            $0.trailing.equalTo(underLineView.snp.trailing)
        }
        
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(underLineView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        ballStackView.snp.makeConstraints {
            $0.top.equalTo(resultLabel.snp.bottom).offset(20)
            $0.horizontalEdges.equalToSuperview().inset(15)
        }
        
        stackViewList.forEach { i in
            i.snp.makeConstraints {
                $0.centerY.equalToSuperview()
                $0.size.equalTo(ballSize)
            }
        }
        
        bonusLabel.snp.makeConstraints {
            $0.top.equalTo(bonusWinNumView.snp.bottom).offset(5)
            $0.centerX.equalTo(bonusWinNumView.snp.centerX)
        }
        
        observableBtn.snp.makeConstraints {
            $0.top.equalTo(bonusLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().inset(30)
            //            $0.size.equalTo(60)
        }
        
        singleBtn.snp.makeConstraints {
            $0.top.equalTo(bonusLabel.snp.bottom).offset(20)
            $0.trailing.equalToSuperview().inset(30)
            //            $0.size.equalTo(60)
        }
    }
    
    func setStyle() {
        view.backgroundColor = .white
        
        lottoTextField.do {
            $0.layer.cornerRadius = 10
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.borderWidth = 0.5
            $0.textAlignment = .center
            $0.textColor = .black
            $0.font = .systemFont(ofSize: 14, weight: .black)
            $0.tintColor = .clear //커서 색상 clear
            $0.inputView = lottoPickerView
        }
        
        underLineView.backgroundColor = .lightGray
        
        introduceLabel.do {
            $0.text = "당첨번호 안내"
            $0.font = .systemFont(ofSize: 14, weight: .black)
        }
        
        dateLabel.do {
            $0.text = "2888-88-88 추첨"
            $0.font = .systemFont(ofSize: 12, weight: .regular)
            $0.textColor = .lightGray
        }
        
        resultLabel.do {
            $0.text = "888회 당첨결과"
            $0.font = .systemFont(ofSize: 22, weight: .black)
        }
        
        ballStackView.do {
            $0.axis = .horizontal
            $0.spacing = CGFloat(stackViewSpacing)
            $0.alignment = .center
            $0.distribution = .fillEqually
        }
        
        stackViewList.forEach { i in
            if i != plusLabelView {
                i.do {
                    $0.backgroundColor = .lightGray
                    $0.layer.cornerRadius = ballSize/2
                }
            }
        }
        
        bonusLabel.do {
            $0.text = "보너스"
            $0.font = .systemFont(ofSize: 12)
            $0.textAlignment = .center
        }
        
        observableBtn.do {
            $0.setTitle("옵저버블버튼", for: .normal)
            $0.setTitleColor(UIColor.red, for: .normal)
            $0.layer.borderWidth = 1
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        }
        
        singleBtn.do {
            $0.setTitle("싱글버튼", for: .normal)
            $0.setTitleColor(UIColor.blue, for: .normal)
            $0.layer.borderWidth = 1
            $0.titleLabel?.font = .systemFont(ofSize: 14, weight: .regular)
        }
    }
    
    func setLotteryUI(with model: LotteryModel) {
        let round = model.drwNo
        lottoTextField.text = String(round)
        lottoTextField.sendActions(for: .editingChanged) //이처럼 강제로 rx 이벤트를 줘도되나?
        setResultLabelHilightColor(str: "\(round)회 당첨결과")
        
        dateLabel.text = "\(model.drwNoDate) 추첨"
        lottoBallUI(selectedLottoArr: [model.drwtNo1, model.drwtNo2, model.drwtNo3, model.drwtNo4, model.drwtNo5, model.drwtNo6, 0, model.bnusNo])
    }
    
    func setResultLabelHilightColor(str: String) {
        let attributedText = NSMutableAttributedString(
            string: str,
            attributes: [.font : UIFont.systemFont(ofSize: 22, weight: .black),]
        )
        
        let hilightLength = str.split(separator: " ")[0].count
        
        attributedText.addAttributes(
            [.foregroundColor : UIColor.systemYellow],
            range: NSRange(location: 0,length: hilightLength)
        )
        
        resultLabel.attributedText = attributedText
    }
    
    ///lottoBall UI 담당 함수
    func lottoBallUI(selectedLottoArr: [Int]) {
        for i in 0..<stackViewList.count {
            stackViewList[i].subviews.forEach { $0.removeFromSuperview() }
            
            let numLabel = UILabel()
            let text = (i == 6) ? "+" : String(selectedLottoArr[i])
            let textColor = (i == 6) ? UIColor(.black) : UIColor(.white)
            
            numLabel.do {
                $0.text = text
                $0.font = .systemFont(ofSize: 16, weight: .bold)
                $0.textColor = textColor
                $0.textAlignment = .center
            }
            
            stackViewList[i].addSubview(numLabel)
            
            numLabel.snp.makeConstraints {
                $0.center.equalToSuperview()
            }
            
            switch selectedLottoArr[i] {
            case (1...10):
                stackViewList[i].backgroundColor = .systemYellow
            case (11...20):
                stackViewList[i].backgroundColor = .systemBlue
            case (21...30):
                stackViewList[i].backgroundColor = .systemRed
            case (31...40):
                stackViewList[i].backgroundColor = .systemGray
            case (41...45):
                stackViewList[i].backgroundColor = .systemGreen
            default:
                print("")
            }
        }
    }
    
}


//MARK: - Bind
private extension LotteryViewController {
    
    func bind() {
        let input = LotteryViewModel.Input(
            lottoTextFieldText: lottoTextField.rx.text.orEmpty,
            changePickerNum: lottoPickerView.rx.modelSelected(Int.self)
                .compactMap {"\($0.first ?? 0)"},
            observableBtnTapped: observableBtn.rx.tap,
            singleBtnTapped: singleBtn.rx.tap
        )
        
        let output = viewModel.transform(input: input)

        output.textFieldText
            .drive(with: self, onNext: { owner, text in
                owner.lottoTextField.text = text
                owner.lottoTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)
        
        //PickerView 각 Title 설정
        output.lottoPickerList
            .observe(on: MainScheduler.instance)
            .bind(to: lottoPickerView.rx.itemTitles) { (_, item) -> String in
                return "\(item)"
            }
            .disposed(by: disposeBag)
        
        //lotto API 통신 이후 UI 세팅
        output.lottoBallList
            .observe(on: MainScheduler.instance)
            .bind(with: self, onNext: { owner, model in
                owner.setLotteryUI(with: model)
            })
            .disposed(by: disposeBag)
    }
    
}
