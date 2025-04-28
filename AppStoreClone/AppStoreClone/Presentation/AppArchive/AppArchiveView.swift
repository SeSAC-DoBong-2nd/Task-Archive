//
//  AppArchiveView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveView: View {
    @StateObject private var vm: AppArchiveViewModel
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    init() {
        _vm = StateObject(wrappedValue: AppArchiveViewModel(downloadManager: AppDownloadManager.shared))
    }
    
    var body: some View {
        ZStack {
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

#Preview {
    AppArchiveView()
}
