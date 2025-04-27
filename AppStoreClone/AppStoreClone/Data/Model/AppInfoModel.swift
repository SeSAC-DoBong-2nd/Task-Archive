//
//  AppInfo.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import Foundation

/// 앱 정보를 담는 구조체
struct AppInfoModel: Identifiable {
    let id = UUID() // List에서 사용하기 위한 고유 ID
    let iconName: String // 앱 아이콘 이름
    let name: String
    let date: String?
    var buttonState: ASCDownloadButtonState
}
