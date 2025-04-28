//
//  ASCDownloadButton.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

// ASCDownloadButtonState - 상태를 5가지로 규정
enum ASCDownloadButtonState {
    case get             // 받기
    case downloading     // 다운로드 중
    case resume          // 재개
    case open            // 열기
    case reDownload      // 다시받기
    
    var buttonText: String {
        switch self {
        case .get: return "받기"
        case .downloading: return ""
        case .resume: return "재개"
        case .open: return "열기"
        case .reDownload: return "다시받기"
        }
    }
    
    var buttonBackgroundColor: Color {
        switch self {
        case .get, .reDownload: return Color.blue
        case .downloading: return Color(uiColor: .systemGray5)
        default: return Color(uiColor: .systemGray5)
        }
    }
    
    var buttonForegroundColor: Color {
        switch self {
        case .get, .reDownload: return Color.white
        default: return Color.blue
        }
    }
    
    // Codable 지원을 위한 rawValue 변환
    func toRawValue() -> Int {
        switch self {
        case .get: return 0
        case .downloading: return 1
        case .resume: return 2
        case .open: return 3
        case .reDownload: return 4
        }
    }
    
    static func fromRawValue(_ value: Int) -> ASCDownloadButtonState {
        switch value {
        case 0: return .get
        case 1: return .downloading
        case 2: return .resume
        case 3: return .open
        case 4: return .reDownload
        default: return .get
        }
    }
}

// 개선된 다운로드 버튼 뷰
struct ASCDownloadButton: View {
    @EnvironmentObject private var downloadManager: AppDownloadManager
    
    let appID: String
    let appName: String
    let appIconURL: URL?
    var initialState: ASCDownloadButtonState
    
    @State private var localProgress: Double = 0
    
    private var downloadInfo: AppDownloadInfo? {
        downloadManager.appDownloadStates[appID]
    }
    
    private var buttonState: ASCDownloadButtonState {
        downloadInfo?.buttonState ?? initialState
    }
    
    private var downloadProgress: Double {
        downloadInfo?.progress ?? 0
    }
    
    var body: some View {
        Button(action: {
            handleButtonTap()
        }) {
            ZStack {
                switch buttonState {
                case .get, .open:
                    RoundedRectangle(cornerRadius: 15)
                        .fill(buttonState.buttonBackgroundColor)
                        .frame(minWidth: 65)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                        )
                    Text(buttonState.buttonText)
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(buttonState.buttonForegroundColor)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 7)
                case .downloading:
                    circularProgressView(progress: downloadProgress)
                        .frame(width: 26, height: 26)
                case .resume:
                    RoundedRectangle(cornerRadius: 15)
                        .fill(buttonState.buttonBackgroundColor)
                        .frame(minWidth: 65)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                        )
                    HStack(spacing: 4) {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(buttonState.buttonForegroundColor)
                        Text("재개")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(buttonState.buttonForegroundColor)
                    }
                    .padding(.horizontal, 12)
                    .padding(.vertical, 7)
                case .reDownload:
                    Image(systemName: "icloud.and.arrow.down")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(width: 60, height: 32)
        .onAppear {
            // 앱이 처음 보여질 때, 아직 상태가 없다면 초기 상태로 설정
            if downloadManager.appDownloadStates[appID] == nil {
                let isInstalled = downloadManager.userInstalledApps.contains(appID)
                let initialState: ASCDownloadButtonState = isInstalled ? .open : self.initialState
                downloadManager.appDownloadStates[appID] = AppDownloadInfo(
                    appID: appID,
                    appName: appName,
                    appIconURL: appIconURL,
                    buttonState: initialState,
                    progress: isInstalled ? 1.0 : 0.0,
                    remainingTime: isInstalled ? 0 : 30
                )
            }
        }
    }
    
    private func handleButtonTap() {
        switch buttonState {
        case .get, .reDownload:
            // 받기 또는 다시받기 버튼을 누르면 다운로드 시작
            downloadManager.startDownload(appID: appID, appName: appName, appIconURL: appIconURL)
            
        case .downloading, .resume:
            // 다운로드중 또는 재개 버튼을 누르면 일시정지/재개 토글
            downloadManager.togglePauseResume(appID: appID)
            
        case .open:
            // 열기 버튼을 누르면 앱 실행 (실제로는 앱 실행 기능 구현 필요)
            print("앱 실행: \(appName)")
        }
    }
    
    private func circularProgressView(progress: Double) -> some View {
        return ZStack {
            // 배경 원
            Circle()
                .stroke(Color(uiColor: .systemGray5), lineWidth: 1)
            
            // 진행 원
            Circle()
                .trim(from: 0, to: CGFloat(progress))
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 2, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.linear, value: progress)
            
            // 중앙 정지 아이콘
            Image(systemName: "pause.fill")
                .font(.system(size: 5))
                .foregroundColor(.blue)
        }
    }
}
