//
//  CoinNetwork.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/16/25.
//

import Foundation
/// 싱글톤: class 기반 vs sturct 기반
///     -> 왜 struct로는 안 만들까?
///     : 구동되는 앱 내에서 단 하나의 객체만 존재하도록 해당 패턴을 사용하는 것인데,
///       값 타입의 구조체를 사용하게 되면 shared로 객체를 생성한다 하더라도 구조체 내의 생성된 객체를 참조하는 것이 아닌 복사를 하기에 위 디자인 패턴의 의의와 맞지않는다.

enum APIError: Error {
    case invalidResponse
}

struct Market: Hashable, Codable, Identifiable {
    let id = UUID()
    let market, koreanName, englishName: String
    var like = false

    enum CodingKeys: String, CodingKey {
        case market
        case koreanName = "korean_name"
        case englishName = "english_name"
    }
}

typealias Markets = [Market]

final class CoinNetwork {
    
    static let shared = CoinNetwork()
    
    private init() {}
    
    func fetchAllMarket() async throws -> Markets {
        let url = URL(string: "https://api.upbit.com/v1/market/all")!
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw APIError.invalidResponse
        }
        
        let decodedData = try JSONDecoder().decode(Markets.self, from: data)
        return decodedData
    }
    
    func searchMarket(query: String) async throws -> [Market] {
        print("네트워크: '\(query)' 검색 요청 시작")
        // 실제 네트워크 요청 구현... (API가 검색을 지원해야 함)
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5초 딜레이 시뮬레이션
        
        // API가 검색 지원 안 할 경우, 클라이언트 필터링 또는 전체 반환 후 필터링 필요
        // 여기서는 더미 검색 로직을 시뮬레이션합니다.
        let allMarkets = try await fetchAllMarket() // 실제로는 검색 API 호출
        let filteredData = allMarkets.filter {
            $0.koreanName.localizedCaseInsensitiveContains(query) ||
            $0.englishName.localizedCaseInsensitiveContains(query) ||
            $0.market.localizedCaseInsensitiveContains(query)
        }
        print("네트워크: '\(query)' 검색 요청 완료, 결과 \(filteredData.count)개")
        return filteredData
    }
    
}

