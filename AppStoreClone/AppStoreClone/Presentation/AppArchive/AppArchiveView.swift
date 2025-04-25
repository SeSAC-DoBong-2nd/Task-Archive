//
//  AppArchiveView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveView: View {

    @State private var appData = DummyLiterals.dummyAppArchiveData
    @State private var searchText = "" // 검색 텍스트 상태

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                List {
                    ForEach(Array(appData.enumerated()), id: \.element.id) { index, app in
                        AppArchiveRowView(model: app)
                            .listRowSeparator(.hidden, edges: determineSeparatorEdges(for: index, total: appData.count))
                    }
                }
                .listStyle(.plain)
                .navigationTitle("앱")
                .navigationBarTitleDisplayMode(.large)
                .searchable(text: $searchText, prompt: "게임, 앱, 스토리 등")
            }
        }
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
