//
//  AppDetailView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppDetailModel {
    let trackId: Int
    let trackName: String
    let description: String
    let artworkUrl512: URL
    let version: String
    let releaseNotes: String?
    let screenshotUrls: [URL]
    let averageUserRating: Double?
    let userRatingCount: Int?
    let currentVersionDate: String?
    let metaData: [MetadataItem]
}

class AppDetailViewModel: ObservableObject {
    @Published var appDetail: AppDetailModel?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let repo: ITunesRepository
    
    init(repo: ITunesRepository) {
        self.repo = repo
    }
    
    @MainActor
    func fetchAppDetail(trackId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let detail = try await repo.lookup(trackId: trackId)
            self.appDetail = detail
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}

struct AppDetailView: View {
    let trackId: Int
    let repo: ITunesRepository
    @StateObject private var viewModel: AppDetailViewModel
    
    init(trackId: Int, repo: ITunesRepository) {
        self.trackId = trackId
        self.repo = repo
        _viewModel = StateObject(wrappedValue: AppDetailViewModel(repo: repo))
    }
    
    var body: some View {
        Group {
            if viewModel.isLoading {
                ProgressView("로딩 중...")
            } else if let error = viewModel.errorMessage {
                Text("오류: \(error)").foregroundColor(.red)
            } else if let detailData = viewModel.appDetail {
                AppDetailContentView(detailData: detailData)
            } else {
                Text("데이터 없음")
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAppDetail(trackId: trackId)
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
                    updateDate: detailData.currentVersionDate ?? "", // 필요시 추가
                    releaseNotes: detailData.releaseNotes ?? ""
                )
                
                Divider().padding(.horizontal)
                
                //MARK: 4. 미리보기
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
