//
//  AppDetailView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppDetailView: View {
    let trackId: Int
    let repo: ITunesRepository
    @StateObject private var vm: AppDetailViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor

    init(trackId: Int, repo: ITunesRepository) {
        self.trackId = trackId
        self.repo = repo
        _vm = StateObject(wrappedValue: AppDetailViewModel(repo: repo))
    }

    var body: some View {
        ZStack {
            Group {
                if vm.isLoading {
                    ProgressView("로딩 중...")
                } else if let error = vm.errorMessage {
                    Text("오류: \(error)").foregroundColor(.red)
                } else if let detailData = vm.appDetail {
                    AppDetailContentView(detailData: detailData)
                } else {
                    Text("데이터 없음")
                }
            }
            .onAppear {
                Task {
                    await vm.fetchAppDetail(trackId: trackId)
                }
            }
            if !networkMonitor.isConnected {
                Color.black.opacity(0.5).ignoresSafeArea()
                VStack {
                    Spacer()
                    Text("네트워크 연결이 끊겼습니다. 확인 바랍니다.")
                        .foregroundColor(.white)
                        .font(.headline)
                        .padding()
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(12)
                    Spacer()
                }
            }
        }
    }
}

// 실제 상세 UI는 별도 뷰로 분리
struct AppDetailContentView: View {
    let detailData: AppDetailModel
    @State private var showingScreenshotViewer = false
    @State private var selectedScreenshotIndex = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                //MARK: 1. 앱 헤더
                AppHeaderView(
                    trackId: detailData.trackId,
                    iconURL: detailData.artworkUrl512,
                    appName: detailData.trackName,
                    buttonState: .get
                )
                
                Divider().padding(.horizontal)
                
                //MARK: 2. 메타데이터
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 0) {
                        ForEach(detailData.metaData) { item in
                            MetadataView(data: item)
                            // 마지막 항목 뒤에는 Divider 숨김
                            if item.id != detailData.metaData.last?.id {
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
                    updateDate: detailData.currentVersionDate ?? "",
                    releaseNotes: detailData.releaseNotes ?? ""
                )
                
                Divider().padding(.horizontal)
                
                //MARK: 4. 미리보기
                if detailData.screenshotUrls.isEmpty {
                    EmptyView()
                } else {
                    VStack(alignment: .leading) {
                        Text("미리 보기")
                            .font(.title2).bold()
                            .padding(.horizontal)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(detailData.screenshotUrls.indices, id: \.self) { index in
                                    ScreenshotPreviewImage(imageName: detailData.screenshotUrls[index]) {
                                        self.selectedScreenshotIndex = index
                                        self.showingScreenshotViewer = true
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                }
            }
            .padding(.top)
        }
        .sheet(isPresented: $showingScreenshotViewer) {
            ScreenshotView(
                trackId: detailData.trackId,
                iconURL: detailData.artworkUrl512,
                appName: detailData.trackName,
                buttonState: .get,
                screenshots: detailData.screenshotUrls,
                selectedIndex: $selectedScreenshotIndex
            )
        }
    }
}

