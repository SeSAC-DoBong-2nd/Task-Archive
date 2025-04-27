//
//  iTunesRepository.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

protocol ITunesRepository {
    func searchApps(query: String) async throws -> [SearchResultAppInfo]
}

final class ITunesRepositoryImpl: ITunesRepository {
    
    private let networkService: NetworkServiceProvider
    
    init(networkService: NetworkServiceProvider) {
        self.networkService = networkService
    }
    
    func searchApps(query: String) async throws -> [SearchResultAppInfo] {
        let response = try await networkService.callRequest(api: iTunesRouter.search(term: query), type: ITunesSearchResponse.self)
        
        return AppInfoMapper.mapToSearchResultAppInfos(response)
    }
    
}

final class AppInfoMapper {
    
    static func mapToSearchResultAppInfos(_ response: ITunesSearchResponse) -> [SearchResultAppInfo] {
        return response.results.map { dto in
            let buttonState = ASCDownloadButtonState.get
            let screenshotURLs: [URL]? = dto.screenshotUrls.compactMap { URL(string: $0) }
            let iconURL: URL? = URL(string: dto.artworkUrl100)
            
            return SearchResultAppInfo(
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
