//
//  ASCDownloadButton.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

// ASCDownloadButtonState의 확장 - 상태를 5가지로 확장
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
}

// 앱 다운로드 타이머 관리를 위한 클래스
class AppDownloadManager: ObservableObject {
    static let shared = AppDownloadManager() // 싱글톤으로 구현
    
    @Published var appDownloadStates: [String: AppDownloadInfo] = [:]
    @Published var userInstalledApps: Set<String> = [] // 사용자가 설치한 앱 ID 목록
    
    private var timers: [String: Timer] = [:]
    private var backgroundTaskID: UIBackgroundTaskIdentifier = .invalid
    
    private init() {
        // 백그라운드 노티피케이션 등록
        NotificationCenter.default.addObserver(self, selector: #selector(appDidEnterBackground),
                                              name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                              name: UIApplication.willEnterForegroundNotification, object: nil)
        
        // 앱 설치 상태 복원
        loadAppStates()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - 앱 다운로드 상태 관리
    
    func startDownload(appID: String, appName: String, appIconURL: URL?) {
        let isReinstall = userInstalledApps.contains(appID) == false &&
                         (appDownloadStates[appID]?.buttonState == .reDownload)
        
        var downloadInfo = isReinstall ? appDownloadStates[appID] :
        AppDownloadInfo(appID: appID, appName: appName, appIconURL: appIconURL, buttonState: .downloading,
                          progress: 0, remainingTime: 30)
                          
        downloadInfo?.buttonState = .downloading
        appDownloadStates[appID] = downloadInfo
        
        // 타이머 시작 또는 재개
        startOrResumeTimer(for: appID)
        
        // 상태 저장
        saveAppStates()
    }
    
    func togglePauseResume(appID: String) {
        guard let info = appDownloadStates[appID] else { return }
        
        if info.buttonState == .downloading {
            // 다운로드 중 -> 재개(일시정지)
            pauseDownload(appID: appID)
        } else if info.buttonState == .resume {
            // 재개 -> 다운로드 중(재개)
            resumeDownload(appID: appID)
        }
        
        // 상태 저장
        saveAppStates()
    }
    
    func uninstallApp(appID: String) {
        userInstalledApps.remove(appID)
        
        if let info = appDownloadStates[appID] {
            // 열기 상태였던 앱을 다시받기 상태로 변경
            if info.buttonState == .open {
                appDownloadStates[appID]?.buttonState = .reDownload
                appDownloadStates[appID]?.progress = 0
                appDownloadStates[appID]?.remainingTime = 30
            }
        }
        
        // 상태 저장
        saveAppStates()
    }
    
    func setReDownloadState(appID: String) {
        appDownloadStates[appID]?.buttonState = .reDownload
        appDownloadStates[appID]?.progress = 0
        appDownloadStates[appID]?.remainingTime = 30
        userInstalledApps.remove(appID)
        saveAppStates()
    }
    
    // MARK: - 내부 상태 관리 메서드
    
    private func pauseDownload(appID: String) {
        cancelTimer(for: appID)
        appDownloadStates[appID]?.buttonState = .resume
    }
    
    private func resumeDownload(appID: String) {
        appDownloadStates[appID]?.buttonState = .downloading
        startOrResumeTimer(for: appID)
    }
    
    private func startOrResumeTimer(for appID: String) {
        // 기존 타이머가 있으면 취소
        cancelTimer(for: appID)
        
        guard let info = appDownloadStates[appID] else { return }
        
        // 타이머 생성 (0.1초 간격으로 업데이트)
        let timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            self?.updateDownloadProgress(for: appID)
        }
        timers[appID] = timer
    }
    
    private func cancelTimer(for appID: String) {
        timers[appID]?.invalidate()
        timers[appID] = nil
    }
    
    private func updateDownloadProgress(for appID: String) {
        guard var info = appDownloadStates[appID], info.buttonState == .downloading else { return }
        
        // 0.1초마다 남은 시간 감소
        let decrementAmount = 0.1
        let newRemainingTime = info.remainingTime - decrementAmount
        
        if newRemainingTime <= 0 {
            // 다운로드 완료
            completeDownload(appID: appID)
        } else {
            // 진행 상황 업데이트
            let progress = 1.0 - (newRemainingTime / 30.0)
            
            info.remainingTime = newRemainingTime
            info.progress = progress
            appDownloadStates[appID] = info
            
            // 상태 변경 알림
            objectWillChange.send()
        }
    }
    
    private func completeDownload(appID: String) {
        cancelTimer(for: appID)
        
        // 상태 업데이트
        appDownloadStates[appID]?.buttonState = .open
        appDownloadStates[appID]?.progress = 1.0
        appDownloadStates[appID]?.remainingTime = 0
        
        // 설치된 앱 목록에 추가
        userInstalledApps.insert(appID)
        
        // 변경 알림
        objectWillChange.send()
        
        // 상태 저장
        saveAppStates()
    }
    
    // MARK: - 백그라운드 처리
    
    @objc private func appDidEnterBackground() {
        // iOS에 백그라운드 작업 요청
        backgroundTaskID = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
        
        // 모든 현재 상태와 타이머 정보 저장
        saveAppStates()
    }
    
    @objc private func appWillEnterForeground() {
        // 백그라운드 작업이 더 이상 필요 없음
        endBackgroundTask()
        
        // 상태 복원
        loadAppStates()
        
        // 백그라운드에서 지난 시간 계산하여 진행 상태 업데이트
        updateStatesAfterBackground()
    }
    
    private func endBackgroundTask() {
        if backgroundTaskID != .invalid {
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
            backgroundTaskID = .invalid
        }
    }
    
    private func updateStatesAfterBackground() {
        let lastUpdateTime = UserDefaults.standard.object(forKey: "lastUpdateTime") as? Date ?? Date()
        let currentTime = Date()
        let elapsedTime = currentTime.timeIntervalSince(lastUpdateTime)
        
        // 각 앱의 상태 업데이트
        for (appID, info) in appDownloadStates {
            if info.buttonState == .downloading {
                let newRemainingTime = max(0, info.remainingTime - elapsedTime)
                
                if newRemainingTime <= 0 {
                    // 백그라운드에서 다운로드 완료됨
                    completeDownload(appID: appID)
                } else {
                    // 진행 중인 상태 업데이트
                    appDownloadStates[appID]?.remainingTime = newRemainingTime
                    appDownloadStates[appID]?.progress = 1.0 - (newRemainingTime / 30.0)
                    
                    // 다운로드 계속
                    startOrResumeTimer(for: appID)
                }
            }
        }
        
        // 현재 시간을 마지막 업데이트 시간으로 저장
        UserDefaults.standard.set(currentTime, forKey: "lastUpdateTime")
    }
    
    // MARK: - 상태 저장 및 로드
    
    private func saveAppStates() {
        // 저장 시간 기록
        UserDefaults.standard.set(Date(), forKey: "lastUpdateTime")
        
        // 앱 상태 저장
        if let encoded = try? JSONEncoder().encode(Array(appDownloadStates.values)) {
            UserDefaults.standard.set(encoded, forKey: "appDownloadStates")
        }
        
        // 설치된 앱 목록 저장
        UserDefaults.standard.set(Array(userInstalledApps), forKey: "userInstalledApps")
    }
    
    private func loadAppStates() {
        // 앱 상태 로드
        if let data = UserDefaults.standard.data(forKey: "appDownloadStates"),
           let decodedInfos = try? JSONDecoder().decode([AppDownloadInfo].self, from: data) {
            
            var statesDict = [String: AppDownloadInfo]()
            for info in decodedInfos {
                statesDict[info.appID] = info
            }
            appDownloadStates = statesDict
        }
        
        // 설치된 앱 목록 로드
        if let installedApps = UserDefaults.standard.array(forKey: "userInstalledApps") as? [String] {
            userInstalledApps = Set(installedApps)
        }
        
        // 앱이 강제 종료되었던 경우 다운로드 중이던 앱은 재개 상태로 전환
        for (appID, info) in appDownloadStates where info.buttonState == .downloading {
            appDownloadStates[appID]?.buttonState = .resume
        }
    }
}

// 앱 다운로드 정보를 저장할 구조체
struct AppDownloadInfo: Codable, Identifiable {
    let appID: String
    let appName: String
    let appIconURL: URL?
    var buttonState: ASCDownloadButtonState
    var progress: Double
    var remainingTime: TimeInterval
    
    var id: String { appID }
    
    // Codable 준수를 위한 구현
    enum CodingKeys: String, CodingKey {
        case appID, appName, appIconURL, buttonState, progress, remainingTime
    }
    
    init(appID: String, appName: String, appIconURL: URL?, buttonState: ASCDownloadButtonState, progress: Double, remainingTime: TimeInterval) {
        self.appID = appID
        self.appName = appName
        self.appIconURL = appIconURL
        self.buttonState = buttonState
        self.progress = progress
        self.remainingTime = remainingTime
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        appID = try container.decode(String.self, forKey: .appID)
        appName = try container.decode(String.self, forKey: .appName)
        appIconURL = try container.decode(URL?.self, forKey: .appIconURL)
        let stateRawValue = try container.decode(Int.self, forKey: .buttonState)
        buttonState = ASCDownloadButtonState.fromRawValue(stateRawValue)
        progress = try container.decode(Double.self, forKey: .progress)
        remainingTime = try container.decode(TimeInterval.self, forKey: .remainingTime)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appID, forKey: .appID)
        try container.encode(appName, forKey: .appName)
        try container.encode(appIconURL, forKey: .appIconURL)
        try container.encode(buttonState.toRawValue(), forKey: .buttonState)
        try container.encode(progress, forKey: .progress)
        try container.encode(remainingTime, forKey: .remainingTime)
    }
}

// ASCDownloadButtonState Codable 지원 확장
extension ASCDownloadButtonState {
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
                        .frame(minWidth: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                        )
                    Text(buttonState.buttonText)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(buttonState.buttonForegroundColor)
                        .padding(.horizontal, 18)
                        .padding(.vertical, 7)
                case .downloading:
                    CircularProgressView(progress: downloadProgress)
                        .frame(width: 24, height: 24)
                case .resume:
                    RoundedRectangle(cornerRadius: 15)
                        .fill(buttonState.buttonBackgroundColor)
                        .frame(minWidth: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 15)
                                .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                        )
                    HStack(spacing: 4) {
                        Image(systemName: "icloud.and.arrow.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(buttonState.buttonForegroundColor)
                        Text("재개")
                            .font(.system(size: 8, weight: .bold))
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
}

// 원형 프로그레스 뷰 (다운로드 중 상태 표시용)
struct CircularProgressView: View {
    let progress: Double
    
    var body: some View {
        ZStack {
            // 배경 원
//            Circle()
//                .stroke(Color(uiColor: .systemGray5), lineWidth: 2)
            
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
