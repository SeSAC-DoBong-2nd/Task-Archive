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
    
    init() {
        print("ContentView Init")
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            TodayView()
                .tabItem { Label("투데이", systemImage: ImageLiterals.today) }
                .tag(0)

            GamesView()
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
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack {
            NavigationView {
                Text("투데이 화면")
                    .navigationTitle("투데이")
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

struct GamesView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack {
            NavigationView {
                Text("게임 화면")
                    .navigationTitle("게임")
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


struct ArcadeView: View {
    @EnvironmentObject private var networkMonitor: NetworkMonitor
    
    var body: some View {
        ZStack {
            NavigationView {
                Text("Arcade 화면")
                    .navigationTitle("Arcade")
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
    ContentView()
}
