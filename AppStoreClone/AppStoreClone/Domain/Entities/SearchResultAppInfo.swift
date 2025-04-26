//
//  SearchResultAppInfo.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import Foundation

/// 검색 결과 앱 정보 구조체
struct SearchResultAppInfo: Identifiable {
    let id = UUID()
    let iconName: URL? // 임시 아이콘 이름 또는 iconURL: URL? 추가 고려
    let name: String
    let subtitle: String
    let developer: String
    let category: String
    let requiredOS: String
    // screenshots 타입을 [URL]? 로 변경
    let screenshotURLs: [URL]? // URL 배열 (옵셔널 처리)
    var buttonState: ASCDownloadButtonState
}
