//
//  Search.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import Foundation

/// 검색 결과 앱 정보 구조체
struct SearchResultModel: Identifiable {
    let id = UUID()
    let iconName: URL?
    let name: String
    let subtitle: String
    let developer: String
    let category: String
    let requiredOS: String
    let screenshotURLs: [URL]?
    var buttonState: ASCDownloadButtonState
}
