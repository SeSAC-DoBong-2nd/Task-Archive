//
//  LotteryNetworkManager.swift
//  RxPractice
//
//  Created by 박신영 on 2/24/25.
//

import Foundation

import RxCocoa
import RxSwift

enum APIError: Error {
    case urlError
    case responseError
    case statusCodeError
    case decodingError
}

final class LotteryNetworkManager {
    
    static let shared = LotteryNetworkManager()
    
    private init() {}
    
    func callLotteryAPI(round: String) -> Observable<LotteryModel> {
        return Observable<LotteryModel>.create { value in
            print("round: \(round)")
            guard
                let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)")
            else {
                value.onError(APIError.urlError)
                return Disposables.create { //클로저 있는 형태는 dispose 됐을 때 신호받으려고 씀
                    print("url 에러로 끝")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    value.onError(APIError.responseError)
                } else {
                    guard
                        let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                    else {
                        value.onError(APIError.statusCodeError)
                        return
                    }
                    if let data = data {
                        if let jsonString = String(data: data, encoding: .utf8) {
                            print("📌 API 응답 JSON: \(jsonString)") //새벽에 갑자기 로또api 점검해서 급하게 찍어봤습니다..
                        }
                        do {
                            let result = try JSONDecoder().decode(LotteryModel.self, from: data)
                            value.onNext(result)
                            value.onCompleted()
                        } catch {
                            //디코딩 에러
                            print("❌ 디코딩 실패: \(error)")
                            value.onError(APIError.decodingError)
                        }
                    } else {
                        //data 없는 에러
                        value.onError(APIError.responseError)
                    }
                }
            }.resume()
            
            return Disposables.create {
                print("끝")
            }
        }
    }
    
    func callLotteryAPIWithSingle(round: String) -> Single<LotteryModel> {
        return Single<LotteryModel>.create { value in
            print("round: \(round)")
            guard
                let url = URL(string: "https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=\(round)")
            else {
                value(.failure(APIError.urlError))
                return Disposables.create {
                    print("url 에러로 끝")
                }
            }
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                if error != nil {
                    value(.failure(APIError.responseError))
                } else {
                    guard
                        let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode)
                    else {
                        value(.failure(APIError.statusCodeError))
                        return
                    }
                    if let data = data {
                        do {
                            let result = try JSONDecoder().decode(LotteryModel.self, from: data)
                            value(.success(result))
                        } catch {
                            print("❌ 디코딩 실패: \(error)")
                            value(.failure(APIError.decodingError))
                        }
                    } else {
                        //data 없는 에러
                        value(.failure(APIError.responseError))
                    }
                }
            }.resume()
            
            return Disposables.create {
                print("끝")
            }
        }
    }
    
}
