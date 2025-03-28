//
//  NaverShoppingListViewModel.swift
//  DailyTask_week4
//
//  Created by 박신영 on 2/6/25.
//

import Foundation

import RxCocoa
import RxSwift

final class NaverShoppingListViewModel: ViewModelProtocol {
    
    var currentSearchText = ""
    private var currentFilter = ""
//    var total = ""
    var start = 1
    private var isEnd = false
    
    private let disposeBag = DisposeBag()
    
    struct Input {
        let tapNavLeftBtn: ControlEvent<Void>?
        let filterBtnTapped: Observable<String>
//        let loadMoreData: Observable<IndexPath>
        let loadMoreData: ControlEvent<[IndexPath]>
    }
    
    struct Output {
        let tapNavLeftBtn: Driver<Void>?
        let shoppingList: Driver<[Items]>
        let isSuccessGetShoppingAPI: Driver<Bool?>
        let totalCount: Driver<String>
    }
    
    //BehaviorRelay 사용하여 값을 저장하고 Observable로 방출
    private let shoppingListRelay = BehaviorRelay<[Items]>(value: [])
    private let isSuccessRelay = BehaviorRelay<Bool?>(value: nil)
    private let totalCountRelay = BehaviorRelay<String>(value: "")
    
    var heartSelectedArr: [Bool] = []
    
    func transform(input: Input) -> Output {
        //navLeftBtn 탭 처리
        let tapNavLeftBtn = input.tapNavLeftBtn?.asDriver()
        
        //필터 버튼 탭 처리
        input.filterBtnTapped
            .subscribe(onNext: { [weak self] btnTitle in
                self?.filterBtnTapped(btnTitle: btnTitle)
            })
            .disposed(by: disposeBag)
        
        //추가 데이터 로드 처리
        input.loadMoreData
            .throttle(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .compactMap { $0.last }
            .bind(with: self) { owner, indexPath in
                owner.isValid(index: indexPath)
            }.disposed(by: disposeBag)
        
        return Output(
            tapNavLeftBtn: tapNavLeftBtn,
            shoppingList: shoppingListRelay.asDriver(),
            isSuccessGetShoppingAPI: isSuccessRelay.asDriver(),
            totalCount: totalCountRelay.asDriver()
        )
    }
    
    deinit {
        print("NaverShoppingListViewModel", #function)
    }
}

private extension NaverShoppingListViewModel {
    
    func filterBtnTapped(btnTitle: String) {
        print("filterBtnTapped")
        let title = btnTitle.trimmingCharacters(in: .whitespaces)
        
        let currentBtnName: String = {
            switch title {
            case "정확도":
                return "sim"
            case "날짜순":
                return "date"
            case "가격높은순":
                return "dsc"
            case "가격낮은순":
                return "asc"
            default:
                return ""
            }
        }()
        
        if currentBtnName != currentFilter {
            self.start = 1
            shoppingListRelay.accept([])
            getNaverShoppingAPI(query: currentSearchText, start: self.start, filter: currentBtnName)
        } else {
            print("같은 버튼 눌렀지롱~")
        }
    }
    
    func isValid(index: IndexPath) {
        if (shoppingListRelay.value.count - 6) == index.item && isEnd == false {
            start += 1
            getNaverShoppingAPI(query: currentSearchText, start: start, filter: currentFilter)
        }
    }
    
    func getNaverShoppingAPI(query: String, start: Int, filter: String) {
        print("getNaverShoppingAPI")
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let parameters = ["query": query, "display": 100, "start": start, "sort": filter] as [String : Any]
        
        NaverNetworkManager.shared.getNaverShoppingList(url: url, parameters: parameters)
            .asDriver(onErrorDriveWith: .empty())
            .drive(with: self) { owner, result in
                switch result {
                    
                case .success(let model):
                    print("지금이니!!!: \(model)")
                    
                    var updatedList = owner.shoppingListRelay.value
                    updatedList.append(contentsOf: model.items)
                    owner.shoppingListRelay.accept(updatedList)
                    
                    if (Int(model.total) - (start * 30)) < 0 {
                        owner.isEnd = true
                    }
                    owner.heartSelectedArr = Array(repeating: false, count: updatedList.count)
                    owner.isSuccessRelay.accept(true)
                case .failure(let error):
                    print("failure!!!: \(error.localizedDescription)")
                    owner.isSuccessRelay.accept(false)
                }
            }.disposed(by: disposeBag)
    }
    
}
