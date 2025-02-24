//
//  LotteryViewController.swift
//  RxPractice
//
//  Created by 박신영 on 2/24/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class LotteryViewController: UIViewController {
    
    //MARK: - UI Property
    private let lottoTextField = UITextField()

    private let introduceLabel = UILabel()
    private let dateLabel = UILabel()
    private let underLineView = UIView()
    
    private let resultLabel = UILabel()
    private let bonusLabel = UILabel()
    
    private let ballStackView = UIStackView()
    private let firstWinNumView = UIView()
    private let secondWinNumView = UIView()
    private let thirdWinNumView = UIView()
    private let fourthWinNumView = UIView()
    private let fifthWinNumView = UIView()
    private let sixthWinNumView = UIView()
    private let plusLabelView = UIView()
    private let bonusWinNumView = UIView()
    
    private let lottoPickerView = UIPickerView()
    
    //MARK: - Property
    let stackViewSpacing = 5
    
    var choiceRound = ""
    
    lazy var latestRound = getLatestLottoDate()
    lazy var lottoArr = Array(Array(1...latestRound).reversed())
    
    //(screen width - (ballStackView inset 값 + spacing*7)) / 8
    lazy var ballSize = (UIScreen.main.bounds.width - CGFloat((30 + stackViewSpacing * 7))) / 8
    
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
        
//        setRegister()
//        getLottoAPI(numStr: "\(latestRound)")
    }
    
    func setHierarchy() {
        [lottoTextField,
         introduceLabel,
         dateLabel,
         underLineView,
         resultLabel,
         ballStackView,
         bonusLabel].forEach { i in
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
            $0.centerX.equalTo(bonusWinNumView.snp.centerX).offset(2)
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
            $0.font = .systemFont(ofSize: 8)
            $0.textAlignment = .right
        }
    }

}

private extension LotteryViewController {
    
//    func setRegister() {
//        lottoPickerView.delegate = self
//        lottoPickerView.dataSource = self
//    }
//    
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
//    
//    func getLottoAPI(numStr: String) {
//        let url = "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(numStr)"
//        AF.request(url, method: .get).responseDecodable(of: LotteryModel.self) { response in
//            switch response.result {
//            case .success(let result):
//                self.setLotteryUI(round: result.drwNo,
//                                  date: result.drwNoDate,
//                                  no1: result.drwtNo1,
//                                  no2: result.drwtNo2,
//                                  no3: result.drwtNo3,
//                                  no4: result.drwtNo4,
//                                  no5: result.drwtNo5,
//                                  no6: result.drwtNo6,
//                                  noBonus: result.bnusNo)
//            case .failure(let error):
//                print(error)
//                let alert = UIAlertUtil.showAlert(title: "조회 실패", message: "다시 시도하여 주세요.")
//                self.present(alert, animated: true)
//            }
//        }
//    }

    func setLotteryUI(round: Int,
                      date: String,
                      no1: Int,
                      no2: Int,
                      no3: Int,
                      no4: Int,
                      no5: Int,
                      no6: Int,
                      noBonus: Int)
    {
        lottoTextField.text = String(round)
        setResultLabelHilightColor(str: "\(round)회 당첨결과")
        dateLabel.text = "\(date) 추첨"
        
        let selectedLottoArr = [no1, no2, no3, no4, no5, no6, 0, noBonus]
        lottoBallUI(selectedLottoArr: selectedLottoArr)
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
    
    func getLatestLottoDate() -> Int {
        //로또 시작 날짜 (2002년 12월 7일)
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let startDate = dateFormatter.date(from: "2002-12-07") else {
            print("getLatestLottoDate Error")
            return 0
        }
        
        let now = Date()
        
        //시작부터 현재 날짜까지의 주차 계산
        guard let weeks = calendar.dateComponents([.weekOfYear], from: startDate, to: now).weekOfYear else {
            print("getLatestLottoDate Error")
            return 0
        }
        
        //최신 회차와 해당 날짜 계산
        //1주차부터 시작이니 +1
        let latestRound = weeks + 1
        return latestRound
    }
    
}

extension LotteryViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print(#function)
        let lottoStr = String(lottoArr[row])
        choiceRound = lottoStr
//        getLottoAPI(numStr: lottoStr)
        view.endEditing(true)
    }
    
}

extension LotteryViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return lottoArr.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(lottoArr[row])
    }
    
}

