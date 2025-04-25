//
//  AppArchiveModel.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

// 버튼 상태를 나타내는 열거형
enum AppButtonState {
    case open
    case update
    case get
}

// 앱 정보를 담는 구조체
struct AppArchiveModel: Identifiable {
    let id = UUID() // List에서 사용하기 위한 고유 ID
    let iconName: String // 앱 아이콘 이름 (에셋 카탈로그나 시스템 이미지 이름)
    let name: String
    let date: String
    var buttonState: AppButtonState // 버튼의 현재 상태
}

// 더미 데이터 생성
struct DummyAppData {
    static let apps: [AppArchiveModel] = [
        AppArchiveModel(iconName: "figure.barbell", name: "바리바리 BariBari", date: "2025. 4. 9.", buttonState: .open),
        AppArchiveModel(iconName: "leaf.fill", name: "Stepic - 나만의 산책 이야기", date: "2025. 4. 8.", buttonState: .update),
        AppArchiveModel(iconName: "cat.fill", name: "먹캣 Mucket", date: "2025. 4. 7.", buttonState: .get),
        AppArchiveModel(iconName: "waveform.path.ecg", name: "트리워크 TriWalk - 나만의 산책", date: "2025. 4. 7.", buttonState: .open),
        AppArchiveModel(iconName: "parkingsign.circle.fill", name: "Park Radar - 주정차 걱정 없애는 도움 지도", date: "2025. 4. 7.", buttonState: .get),
        AppArchiveModel(iconName: "music.note", name: "Animori", date: "2025. 4. 7.", buttonState: .open),
        AppArchiveModel(iconName: "mappin.and.ellipse", name: "서울스팟 SeoulSpot", date: "2025. 4. 7.", buttonState: .update)
    ]
}
