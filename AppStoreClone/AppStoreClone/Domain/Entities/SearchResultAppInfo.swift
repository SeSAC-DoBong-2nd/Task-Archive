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
    let iconName: String       // 아이콘 에셋 이름
    let name: String           // 앱 이름
    let subtitle: String       // 부제 (예: "소셜 네트워킹, 생산성")
    let developer: String      // 개발사
    let category: String       // 카테고리
    let requiredOS: String     // 예: "iOS 16.0"
    let screenshots: [String]  // 스크린샷 이미지 이름 배열
    var buttonState: ASCDownloadButtonState // 버튼 상태
}
