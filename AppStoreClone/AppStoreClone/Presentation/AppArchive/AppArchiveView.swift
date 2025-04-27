//
//  AppArchiveView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveView: View {
    @EnvironmentObject private var downloadManager: AppDownloadManager
    @State private var searchText = "" // 검색 텍스트 상태

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(installedApps, id: \.appID) { app in
                        AppArchiveRowView(model: app)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    downloadManager.setReDownloadState(appID: app.appID)
                                } label: {
                                    Text("삭제")
                                }
                            }
                            .listRowSeparator(.hidden, edges: determineSeparatorEdges(for: installedApps.firstIndex(where: { $0.appID == app.appID }) ?? 0, total: installedApps.count))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("앱")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, prompt: "게임, 앱, 스토리 등")
            }
        }
    }

    // 설치된 앱만 추출
    private var installedApps: [AppDownloadInfo] {
        downloadManager.userInstalledApps.compactMap { downloadManager.appDownloadStates[$0] }
    }

    // 구분선을 숨길 엣지 결정 함수
    private func determineSeparatorEdges(for index: Int, total: Int) -> VerticalEdge.Set {
        if index == 0 && total == 1 { // 항목이 1개
            return .all
        } else if index == 0 { // 첫 번째 항목
            return .top
        } else if index == total - 1 { // 마지막 항목
            return .bottom
        } else {
            return []
        }
    }
}

#Preview {
    AppArchiveView()
}
