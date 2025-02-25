//
//  NaverNetworkManager.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/16/25.
//

import UIKit

import Alamofire

enum NetworkResult<T> {
    case success(T)
}

class NaverNetworkManager {
    
    static let shared = NaverNetworkManager()
    
    private init() {}
    
    func getNaverShoppingList(url: String,
                              parameters: [String: Any],
                              clientID: String,
                              clientSecret: String,
                              complition: @escaping (NaverShoppingResponseModel, Int) -> ()) {
        AF.request(url,method: .get,parameters: parameters,headers: [
                    HTTPHeader(name: "X-Naver-Client-Id", value: clientID),
                    HTTPHeader(name: "X-Naver-Client-Secret",value: clientSecret)
                   ]).responseDecodable(of: NaverShoppingResponseModel.self)
        { response in
            guard let statusCode = response.response?.statusCode else {
                return
            }
            switch response.result {
            case .success(let result):
                print("success")
                complition(result, statusCode)
            case .failure(let error):
                print("🔥",error)
            }
        }
    }
    
}
