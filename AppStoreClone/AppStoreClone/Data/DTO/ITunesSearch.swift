//
//  ITunesSearch.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

// iTunes API 전체 응답 구조체
struct ITunesSearchResponse: Decodable {
    let resultCount: Int
    let results: [AppResultDTO] // 앱 결과 배열
}

// API에서 받는 앱 정보 구조체 (DTO)
struct AppResultDTO: Codable {
    let trackId: Int             // 앱 고유 ID
    let trackName: String        // 앱 이름
    let bundleId: String         // 번들 ID
    let artworkUrl100: String    // 100x100 아이콘 URL
    let primaryGenreName: String // 주 카테고리
    let artistName: String       // 개발사 이름
    let minimumOsVersion: String // 최소 지원 OS 버전
    let screenshotUrls: [String] // 스크린샷 URL 배열
    let version: String          // 현재 버전
    let description: String?     // 앱 설명 (필요시 사용)
    let releaseNotes: String?    // 릴리즈 노트 (필요시 사용)
}
