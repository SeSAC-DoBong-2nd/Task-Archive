//
//  LotteryViewModel.swift
//  RxPractice
//
//  Created by 박신영 on 2/24/25.
//

import Foundation

import RxCocoa
import RxSwift

final class LotteryViewModel: ViewModelProtocol {
    
    private let disposeBag = DisposeBag()
    private lazy var lottoArr = Array(Array(1...getLatestLottoDate()).reversed())
    
    struct Input {
        let changePickerNum: Observable<String> //picker 동작 시
        let observableBtnTapped: ControlEvent<Void> //옵저버블 버튼 탭
        let singleBtnTapped: ControlEvent<Void> //싱글 버튼 탭
    }
    struct Output {
        let textFieldText: Driver<String> //textField.text UI 세팅
        let lottoPickerList: BehaviorRelay<[Int]> //PickerView cell UI 세팅
        let lottoBallList: Observable<LotteryModel> //lotto API 통신이후 UI 세팅
    }
    
    func transform(input: Input) -> Output {
        let list = BehaviorRelay(value: [0])
        list.accept(lottoArr)
        let currentTextFieldText = PublishSubject<String>()
        let recentestLotto = Observable.just(lottoArr.first ?? 0)
            // print("recentestLotto: \(lottoArr.first ?? 0)") 잘 되는거 확인
        let lottoBallList = PublishSubject<LotteryModel>()
        
        recentestLotto
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { String($0) }
            .flatMap { value in
                LotteryNetworkManager.shared.callLotteryAPI(round: value)
            }
            .subscribe(with: self) { owner, model in
                lottoBallList.onNext(model)
            } onError: { owner, error in
                print("onError \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }.disposed(by: disposeBag)
        
        input.changePickerNum
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .bind(with: self) { owner, text in
                currentTextFieldText.onNext(text)
            }.disposed(by: disposeBag)
        
        input.observableBtnTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.changePickerNum)
            .distinctUntilChanged()
            .flatMap { value in
                LotteryNetworkManager.shared.callLotteryAPI(round: value)
            }
            .subscribe(with: self) { owner, model in
                lottoBallList.onNext(model)
            } onError: { owner, error in
                print("onError \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }.disposed(by: disposeBag)
        
        input.singleBtnTapped
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.changePickerNum)
            .distinctUntilChanged()
            .flatMap { value in
                LotteryNetworkManager.shared.callLotteryAPIWithSingle(round: value)
            }
            .subscribe(with: self) { owner, model in
                lottoBallList.onNext(model)
            } onError: { owner, error in
                print("onError \(error)")
            } onCompleted: { owner in
                print("onCompleted")
            } onDisposed: { owner in
                print("onDisposed")
            }.disposed(by: disposeBag)
        
        return Output(
            textFieldText: currentTextFieldText.asDriver(onErrorJustReturn: ""),
            lottoPickerList: list,
            lottoBallList: lottoBallList
        )
    }
    
}

private extension LotteryViewModel {
    
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
