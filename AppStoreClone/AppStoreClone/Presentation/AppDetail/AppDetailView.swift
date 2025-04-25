//
//  AppDetailView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppDetailModel: Identifiable {
    let id = UUID()
    let appInfo: AppInfo // 기본 정보
    let metadata: [MetadataItem] // 메타데이터 리스트
    let version: String
    let updateDate: String // 예: "3일 전"
    var releaseNotes: String
    let screenshots: [String] // 스크린샷 이미지 이름 배열
}

struct AppDetailView: View {
    
    @State private var detailData = DummyLiterals.appDetailData
    /// 스크린샷 뷰어 표시 상태
    @State private var showingScreenshotViewer = false
    /// 선택된 스크린샷 인덱스
    @State private var selectedScreenshotIndex = 0

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //MARK: 1. 앱 헤더
                AppHeaderView(appInfo: detailData.appInfo)

                Divider().padding(.horizontal)

                //MARK: 2. 메타데이터
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(detailData.metadata) { item in
                            MetadataView(item: item)
                            // 마지막 항목 뒤에는 Divider 숨김
                            if item.id != detailData.metadata.last?.id {
                                Divider().frame(height: 40).padding(.horizontal, 5)
                            }
                        }
                    }
                    .padding(.horizontal)
                }

                Divider().padding(.horizontal)

                //MARK: 3. 새로운 소식
                WhatsNewView(
                    version: detailData.version,
                    updateDate: detailData.updateDate,
                    releaseNotes: detailData.releaseNotes
                )

                Divider().padding(.horizontal)

                //MARK: 4. 미리보기
                VStack(alignment: .leading) {
                    Text("미리 보기")
                        .font(.title2).bold()
                        .padding(.horizontal)

                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(detailData.screenshots.indices, id: \.self) { index in
                                ScreenshotPreviewImage(imageName: detailData.screenshots[index]) {
                                    // 탭하면 인덱스 설정 및 시트 표시 상태 변경
                                    self.selectedScreenshotIndex = index
                                    self.showingScreenshotViewer = true
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .padding(.top)
        }
        .sheet(isPresented: $showingScreenshotViewer) {
            ScreenshotView(
                appInfo: detailData.appInfo,
                screenshots: detailData.screenshots,
                selectedIndex: $selectedScreenshotIndex
            )
        }
    }
    
}

#Preview {
    NavigationView {
        AppDetailView()
    }
}
