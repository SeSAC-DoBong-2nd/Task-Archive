//
//  AppArchiveViewModel.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import SwiftUI
import Combine

final class AppArchiveViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var installedApps: [AppDownloadInfo] = []
    @Published var filteredApps: [AppDownloadInfo] = []

    private var cancellables = Set<AnyCancellable>()
    private let downloadManager: AppDownloadManager

    init(downloadManager: AppDownloadManager) {
        self.downloadManager = downloadManager

        // 설치된 앱 목록 구독
        downloadManager.$userInstalledApps
            .combineLatest(downloadManager.$appDownloadStates)
            .map { installed, states in
                installed.compactMap { states[$0] }
            }
            .assign(to: &$installedApps)

        // 검색어 또는 설치앱 변경 시 필터링
        Publishers.CombineLatest($searchText, $installedApps)
            .map { text, apps in
                guard !text.isEmpty else { return apps }
                return apps.filter { $0.appName.localizedCaseInsensitiveContains(text) }
            }
            .assign(to: &$filteredApps)
    }

    func setReDownload(appID: String) {
        downloadManager.setReDownloadState(appID: appID)
    }

    func determineSeparatorEdges(for index: Int, total: Int) -> VerticalEdge.Set {
        if index == 0 && total == 1 { return .all }
        else if index == 0 { return .top }
        else if index == total - 1 { return .bottom }
        else { return [] }
    }
}
