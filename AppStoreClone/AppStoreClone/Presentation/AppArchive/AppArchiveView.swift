//
//  AppArchiveView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveView: View {
    @StateObject private var vm: AppArchiveViewModel

    init() {
        _vm = StateObject(wrappedValue: AppArchiveViewModel(downloadManager: AppDownloadManager.shared))
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                List {
                    ForEach(vm.filteredApps, id: \.appID) { app in
                        AppArchiveRowView(model: app)
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    vm.setReDownload(appID: app.appID)
                                } label: {
                                    Text("삭제")
                                }
                            }
                            .listRowSeparator(.hidden, edges: vm.determineSeparatorEdges(for: vm.filteredApps.firstIndex(where: { $0.appID == app.appID }) ?? 0, total: vm.filteredApps.count))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("앱")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $vm.searchText, prompt: "게임, 앱, 스토리 등")
            }
        }
    }
}

#Preview {
    AppArchiveView()
}
