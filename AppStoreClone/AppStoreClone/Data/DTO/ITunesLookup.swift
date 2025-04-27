//
//  ITunesLookup.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

// Lookup API 응답 구조체
struct ITunesLookupResponse: Decodable {
    let resultCount: Int
    let results: [AppDetailResultDTO]
}

struct AppDetailResultDTO: Codable {
    let trackId: Int
    let trackName: String
    let description: String?
    let artworkUrl512: String?
    let sellerName: String?
    let version: String?
    let releaseNotes: String?
    let screenshotUrls: [String]?
    let averageUserRating: Double?
    let userRatingCount: Int?
    let contentAdvisoryRating: String? //연령 제한
    let currentVersionReleaseDate: String?  //현재 버전 출시 날짜 (예: "2025-04-18T16:42:14Z")
    let minimumOsVersion: String? //최소 버전
    let primaryGenreName: String? //주 카테고리 이름
}
