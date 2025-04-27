//
//  TabView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct ContentView: View {
    // 현재 선택된 탭을 추적하는 상태 변수 (기본값: 0 - 첫 번째 탭)
    @State private var selectedTab: Int = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem { Label("투데이", systemImage: ImageLiterals.today) }
                .tag(0)

            ArcadeView()
                .tabItem { Label("게임", systemImage: ImageLiterals.games) }
                .tag(1)

            AppArchiveView()
                .tabItem { Label("앱", systemImage: ImageLiterals.apps) }
                .tag(2) // 세 번째 탭

            ArcadeView()
                .tabItem { Label("Arcade", systemImage: ImageLiterals.arcade) }
                .tag(3) // 네 번째 탭

            SearchView(repo: ITunesRepositoryImpl(networkService: NetworkService()))
                .tabItem { Label("검색", systemImage: ImageLiterals.search) }
                .tag(4) // 다섯 번째 탭
        }
    }
}

struct TodayView: View {
    var body: some View {
        NavigationView {
            Text("투데이 화면")
                .navigationTitle("투데이")
        }
    }
}

struct GamesView: View {
    var body: some View {
        NavigationView {
            Text("게임 화면")
                .navigationTitle("게임")
        }
    }
}


struct ArcadeView: View {
    var body: some View {
        NavigationView {
            Text("Arcade 화면")
                .navigationTitle("Arcade")
        }
    }
}

#Preview {
    ContentView()
}
