//
//  AppStoreCloneApp.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

@main
struct AppStoreCloneApp: App {
    @Environment(\.scenePhase) private var scenePhase
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppDownloadManager.shared)
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
