//
//  NaverShoppingListViewModel.swift
//  DailyTask_week4
//
//  Created by 박신영 on 2/6/25.
//

import Foundation

final class NaverShoppingListViewModel {
    
    var currentFilter = ""
    var total = ""
    var start = 1
    var isEnd = false
    
    let inputFilterBtnTapped: Observable<String?> = Observable(nil)
    let inputCallGetShoppingAPI: Observable<IndexPath> = Observable(IndexPath())
    
    let outputNavTitle: Observable<String> = Observable("title")
    let outputShoppingList: Observable<[Items]> = Observable([])
    lazy var heartSelectedArr = Array(repeating: false, count: outputShoppingList.value.count)
    let outputIsSuccessGetShoppingAPI: Observable<Bool?> = Observable(nil)
    
    init() {
        bindViewModel()
    }
    
    deinit {
        print("NaverShoppingListViewModel",#function)
    }
    
}

private extension NaverShoppingListViewModel {
    
    func bindViewModel() {
        inputFilterBtnTapped.lazyBind { [weak self] btnTitle in
            print("inputFilterBtnTapped.lazyBind")
            self?.filterBtnTapped(btnTitle: btnTitle)
        }
        
        inputCallGetShoppingAPI.lazyBind { [weak self] index in
            self?.isValid(index: index)
        }
    }
    
    func filterBtnTapped(btnTitle: String?) {
        print("filterBtnTapped")
        guard let title = btnTitle?.trimmingCharacters(in: .whitespaces) else {
            print("filterBtnTapped error")
            return
        }
        
        var currentBtnName: String {
            switch title {
            case "정확도":
                "sim"
            case "날짜순":
                "date"
            case "가격높은순":
                "dsc"
            case "가격낮은순":
                "asc"
            default:
                ""
            }
        }
        
        if currentBtnName != currentFilter {
            start = 1
            outputShoppingList.value.removeAll()
            getNaverShoppingAPI(query: outputNavTitle.value, start: self.start, filter: currentBtnName)
        }
         else {
            print("같은 버튼 눌렀지롱~")
        }
    }
    
    func isValid(index: IndexPath) {
        if (outputShoppingList.value.count - 6) == index.item && isEnd == false  {
            start += 1
            getNaverShoppingAPI(query: outputNavTitle.value, start: start, filter: currentFilter)
        }
    }
    
    func getNaverShoppingAPI(query: String, start: Int, filter: String) {
        print("getNaverShoppingAPI")
        let url = "https://openapi.naver.com/v1/search/shop.json"
        let parameters = ["query": query, "display": 100, "start": start, "sort": filter] as [String : Any]
        
        guard let clientID = Bundle.main.naverClientId else {
            print("clientID 키를 로드하지 못했습니다.")
            return
        }
        
        guard let clientSecret = Bundle.main.naverClientSecret else {
            print("clientSecret 키를 로드하지 못했습니다.")
            return
        }
        
        NaverNetworkManager.shared.getNaverShoppingList(url: url,
                                                        parameters: parameters,
                                                        clientID: clientID,
                                                        clientSecret: clientSecret) { response, statusCode  in
            switch statusCode {
            case (200..<299):
                print("200")
                self.currentFilter = filter
                self.total = "\(Int(response.total).formatted()) 개의 검색 결과"
                self.outputShoppingList.value.append(contentsOf: response.items)
                
                if (Int(response.total) - (start * 30)) < 0 {
                    self.isEnd = true
                }
                
                self.outputIsSuccessGetShoppingAPI.value = true
            default:
                print("400")
                self.outputIsSuccessGetShoppingAPI.value = false
            }
            
        }
    }
    
}
