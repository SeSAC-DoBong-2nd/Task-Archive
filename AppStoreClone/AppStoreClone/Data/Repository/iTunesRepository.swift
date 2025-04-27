//
//  iTunesRepository.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

protocol ITunesRepository {
    func searchApps(query: String) async throws -> [SearchResultModel]
    func lookup(trackId: Int) async throws -> AppDetailModel?
}

final class ITunesRepositoryImpl: ITunesRepository {
    
    private let networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider) {
        self.networkService = networkService
    }
    
    func searchApps(query: String) async throws -> [SearchResultModel] {
        let response = try await networkService.callRequest(api: iTunesRouter.search(term: query), type: ITunesSearchResponse.self)
        
        return AppInfoMapper.mapToSearchResultAppInfos(response)
    }
    
    func lookup(trackId: Int) async throws -> AppDetailModel? {
        let response = try await networkService.callRequest(api: iTunesRouter.lookup(trackId: trackId), type: ITunesLookupResponse.self)
        guard let dto = response.results.first else { return nil }
        return AppDetailMapper.mapToAppDetailModel(dto)
    }
    
}

final class AppInfoMapper {
    
    static func mapToSearchResultAppInfos(_ response: ITunesSearchResponse) -> [SearchResultModel] {
        return response.results.map { dto in
            let buttonState = ASCDownloadButtonState.get
            let screenshotURLs: [URL]? = dto.screenshotUrls.compactMap { URL(string: $0) }
            let iconURL: URL? = URL(string: dto.artworkUrl100)
            
            return SearchResultModel(
                trackId: dto.trackId,
                iconName: iconURL,
                name: dto.trackName,
                subtitle: dto.primaryGenreName,
                developer: dto.artistName,
                category: dto.primaryGenreName,
                requiredOS: "iOS \(dto.minimumOsVersion)",
                screenshotURLs: screenshotURLs,
                buttonState: buttonState
            )
        }
    }
    
}

final class AppDetailMapper {
    
    static func mapToAppDetailModel(_ dto: AppDetailResultDTO) -> AppDetailModel {
        return AppDetailModel(
            trackName: dto.trackName,
            description: dto.description ?? "",
            artworkUrl512: URL(string: dto.artworkUrl512 ?? "") ?? URL(string: "")!,
            version: dto.version ?? "",
            releaseNotes: dto.releaseNotes,
            screenshotUrls: (dto.screenshotUrls ?? []).compactMap { URL(string: $0) },
            averageUserRating: dto.averageUserRating,
            userRatingCount: dto.userRatingCount,
            currentVersionDate: dateFormatter(dateString: dto.currentVersionReleaseDate ?? ""),
            metaData: [
                MetadataItem(title: dto.minimumOsVersion ?? "" + "+", subtitle: "버전"),
                MetadataItem(title: dto.contentAdvisoryRating ?? "" + "+", subtitle: "연령"),
                MetadataItem(title: dto.primaryGenreName ?? "", subtitle: "카테고리"),
                MetadataItem(title: dto.sellerName ?? "", subtitle: "개발자")
            ]
        )
    }
    
    private static func dateFormatter(dateString: String) -> String {
        // ISO8601 포맷의 날짜를 파싱
        let formatter = ISO8601DateFormatter()
        guard let date = formatter.date(from: dateString) else {
            return "알 수 없는 날짜"
        }
        
        // 한국 시간대 설정 (KST, UTC+9)
        let kstTimeZone = TimeZone(identifier: "Asia/Seoul")!
        let calendar = Calendar.current
        var kstComponents = calendar.dateComponents(in: kstTimeZone, from: date)
        
        // 입력된 날짜를 KST로 변환
        guard let kstDate = calendar.date(from: kstComponents) else {
            return "알 수 없는 날짜"
        }
        
        // 현재 한국 시간 기준 날짜
        let now = Date()
        let nowKstComponents = calendar.dateComponents(in: kstTimeZone, from: now)
        guard let nowKstDate = calendar.date(from: nowKstComponents) else {
            return "알 수 없는 날짜"
        }
        
        // 날짜 차이 계산
        let components = calendar.dateComponents([.day], from: kstDate, to: nowKstDate)
        guard let dayDifference = components.day else {
            return "알 수 없는 날짜"
        }
        
        // 상대 날짜 포맷
        switch dayDifference {
        case 0:
            return "오늘"
        case 1:
            return "어제"
        case 2...6:
            return "\(dayDifference)일 전"
        default:
            // 7일 이상 차이나면 "YYYY년 MM월 dd일" 포맷으로 반환
            let outputFormatter = DateFormatter()
            outputFormatter.locale = Locale(identifier: "ko_KR")
            outputFormatter.timeZone = kstTimeZone
            outputFormatter.dateFormat = "yyyy년 MM월 dd일"
            return outputFormatter.string(from: date)
        }
    }
    
}
