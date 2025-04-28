//
//  AppStoreCloneApp.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

@main
struct AppStoreCloneApp: App {
    @State private var isShowingSplash = true
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ContentView()
                    .environmentObject(NetworkMonitor.shared)
                    .environmentObject(AppDownloadManager.shared)
                if isShowingSplash {
                    SplashView()
                        .transition(.opacity)
                        .animation(.easeOut(duration: 0.5), value: isShowingSplash)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    withAnimation {
                        isShowingSplash = false
                    }
                }
            }
        }
        .onChange(of: scenePhase) { newPhase in
            switch newPhase {
            case .background:
                AppDownloadManager.shared.enterBackground()
            case .active:
                AppDownloadManager.shared.enterForeground()
            default:
                break
            }
        }
    }
}
