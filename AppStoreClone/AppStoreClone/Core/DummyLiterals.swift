//
//  DummyLiterals.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import Foundation



// 검색 결과 더미 데이터
struct DummySearchResultData {
    
}

struct DummyLiterals {
    
    static let searchResultData: [SearchResultAppInfo] = [
        SearchResultAppInfo(
            iconName: "message.fill", // 카카오톡 아이콘 대체
            name: "카카오톡",
            subtitle: "소셜 네트워킹, 생산ㅁㄴ엄ㄴ오마노라ㅗㅁㄴㄹ마노러ㅏㅗㅁ나ㅓ로ㅓㅁㄴ롸몬러마노란머ㅗ라ㅓ몬라ㅓㅗ만러ㅗ마러ㅗ마ㅓ롬나ㅓ롬너ㅏ롬나ㅓㅗ성",
            developer: "Kakao Corp.",
            category: "Social Networking",
            requiredOS: "iOS 16.0",
            screenshots: [ImageLiterals.screenshot1, ImageLiterals.screenshot2, ImageLiterals.screenshot3],
            buttonState: .open
        ),
        SearchResultAppInfo(
            iconName: "map.fill", // 네이버 지도 아이콘 대체
            name: "네이버 지도, 내비게이션",
            subtitle: "내비게이션, 여행",
            developer: "NAVER Corp.",
            category: "Navigation",
            requiredOS: "iOS 16.0",
            screenshots: [ImageLiterals.screenshot4, ImageLiterals.screenshot5, ImageLiterals.screenshot6],
            buttonState: .get // '재개' 대신 '받기' 사용 예시
        ),
        SearchResultAppInfo(
            iconName: "music.note.tv.fill", // 유튜브 뮤직 아이콘 대체
            name: "YouTube Music",
            subtitle: "음악, 엔터테인먼트",
            developer: "Google",
            category: "Music",
            requiredOS: "iOS 16.0",
            screenshots: [ImageLiterals.screenshot1, ImageLiterals.screenshot3, ImageLiterals.screenshot5],
            buttonState: .update
        ),
        SearchResultAppInfo(
            iconName: "globe", // 구글 크롬 아이콘 대체
            name: "Google Chrome",
            subtitle: "유틸리티, 생산성",
            developer: "Google",
            category: "Utilities",
            requiredOS: "iOS 14.0",
            screenshots: [ImageLiterals.screenshot2, ImageLiterals.screenshot4, ImageLiterals.screenshot6],
            buttonState: .open
        ),
        SearchResultAppInfo(
            iconName: "car.fill", // 카카오내비 아이콘 대체
            name: "카카오내비 - 주차, 발렛, 전기차충전,ㅇㄴㅁ암남ㄴㅇㅁㄴㅇ",
            subtitle: "내비게이션",
            developer: "Kakao Mobility Corp.",
            category: "Navigation",
            requiredOS: "iOS 17.1",
            screenshots: [ImageLiterals.screenshot1, ImageLiterals.screenshot4],
            buttonState: .get
        ),
         SearchResultAppInfo(
             iconName: "m.circle.fill", // 카카오지하철 아이콘 대체
             name: "카카오지하철",
             subtitle: "내비게이션, 라이프스타일",
             developer: "Kakao Mobility Corp.",
             category: "Navigation",
             requiredOS: "iOS 15.0",
             screenshots: [ImageLiterals.screenshot2, ImageLiterals.screenshot5],
             buttonState: .update // '진행 중' 대신 '업데이트' 사용 예시
         )
    ]
    
    static let appDetailData: AppDetailModel = AppDetailModel(
        appInfo: AppInfo(iconName: "doc.on.doc.fill", name: "마지막 페이지", date: nil, buttonState: .open), // "L.P." 아이콘 대체
        metadata: [
            MetadataItem(title: "15.6+", subtitle: "버전", description: nil),
            MetadataItem(title: "4+", subtitle: "연령", description: "만 4세 이상"),
            MetadataItem(title: "도서", subtitle: "카테고리", description: nil),
            MetadataItem(title: "jeongan", subtitle: "개발자", description: nil)
        ],
        version: "1.0.1",
        updateDate: "3일 전",
        releaseNotes: """
        - UI 개선으로 앱 사용성이 향상되었습니다.
        - 검색 기능이 확장되었습니다.
        - 키워드 추천 및 스캔 기능의 접근성과 반응 속도를 높였습니다.
        - 주요 화면의 기능 안정성과 시각 표현을 개선하였습니다.
        - 추가적인 버그 수정 및 성능 개선이 있었습니다.
        - 사용자 피드백을 반영하여 일부 인터페이스를 조정했습니다.
        """,
        screenshots: [ImageLiterals.screenshot1, ImageLiterals.screenshot2, ImageLiterals.screenshot3, ImageLiterals.screenshot4, ImageLiterals.screenshot5, ImageLiterals.screenshot6]
    )
    
    static let appArchiveData: [AppInfo] = [
        AppInfo(iconName: "figure.barbell", name: "바리바리 BariBari", date: "2025. 4. 9.", buttonState: .open),
        AppInfo(iconName: "leaf.fill", name: "Stepic - 나만의 산책 이야기", date: "2025. 4. 8.", buttonState: .update),
        AppInfo(iconName: "cat.fill", name: "먹캣 Mucket", date: "2025. 4. 7.", buttonState: .get),
        AppInfo(iconName: "waveform.path.ecg", name: "트리워크 TriWalk - 나만의 산책", date: "2025. 4. 7.", buttonState: .open),
        AppInfo(iconName: "parkingsign.circle.fill", name: "Park Radar - 주정차 걱정 없애는 도움 지도", date: "2025. 4. 7.", buttonState: .get),
        AppInfo(iconName: "music.note", name: "Animori", date: "2025. 4. 7.", buttonState: .open),
        AppInfo(iconName: "mappin.and.ellipse", name: "서울스팟 SeoulSpot", date: "2025. 4. 7.", buttonState: .update)
    ]
    
}


