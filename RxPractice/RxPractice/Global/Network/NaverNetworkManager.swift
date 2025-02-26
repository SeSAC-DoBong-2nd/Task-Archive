//
//  NaverNetworkManager.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/16/25.
//

import UIKit

import Alamofire
import RxCocoa
import RxSwift

final class NaverNetworkManager {
    
    static let shared = NaverNetworkManager()
    
    private init() {}
    
    func getNaverShoppingList(url: String,
                              parameters: [String: Any]) -> Observable<Result<NaverShoppingResponseModel, APIError>> {
        
        return Observable<Result<NaverShoppingResponseModel, APIError>>.create { value in
            
            guard let clientID = Bundle.main.naverClientId else {
                print("clientID 키를 로드하지 못했습니다.")
                value.onNext(.failure(.authError))
                return Disposables.create {
                    print("url 에러로 끝")
                }
            }
            
            guard let clientSecret = Bundle.main.naverClientSecret else {
                print("clientSecret 키를 로드하지 못했습니다.")
                value.onNext(.failure(.authError))
                return Disposables.create {
                    print("url 에러로 끝")
                }
            }
            
            AF.request(url,method: .get,parameters: parameters,headers: [
                HTTPHeader(name: "X-Naver-Client-Id", value: clientID),
                HTTPHeader(name: "X-Naver-Client-Secret",value: clientSecret)
            ]).responseDecodable(of: NaverShoppingResponseModel.self)
                
            { response in
//                print("response: \(response)")
                guard (response.response?.statusCode) != nil else {
                    value.onNext(.failure(.statusCodeError))
                    return
                }
                switch response.result {
                case .success(let result):
                    print("success")
//                    print(result)
                    value.onNext(.success(result))
                    value.onCompleted()
                case .failure(_):
                    value.onNext(.failure(.responseError))
                }
            }
            return Disposables.create()
        }
    }
    
}
