//
//  AppDownloadManager.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import SwiftUI
import Combine

/// 앱 다운로드 타이머 관리를 위한 클래스
final class AppDownloadManager: ObservableObject {
    static let shared = AppDownloadManager() // 싱글톤으로 구현
    
    @Published var appDownloadStates: [String: AppDownloadInfo] = [:]
    @Published var userInstalledApps: Set<String> = [] // 사용자가 설치한 앱 ID 목록
    
    private var timers: [String: Timer] = [:]
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // 앱 설치 상태 복원
        loadAppStates()
        
        // 네트워크 상태 구독
        NetworkMonitor.shared.$isConnected
            .sink { [weak self] isConnected in
                self?.handleNetworkChange(isConnected: isConnected)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 앱 다운로드 상태 관리
    
    func startDownload(appID: String, appName: String, appIconURL: URL?) {
        let isReinstall = userInstalledApps.contains(appID) == false &&
                         (appDownloadStates[appID]?.buttonState == .reDownload)
        
        // 기존에 .resume 상태로 남아있는 경우, remainingTime을 유지
        if let existingInfo = appDownloadStates[appID], existingInfo.buttonState == .resume {
            var updatedInfo = existingInfo
            updatedInfo.buttonState = .downloading
            appDownloadStates[appID] = updatedInfo
        } else {
            var downloadInfo = isReinstall ? appDownloadStates[appID] :
            AppDownloadInfo(appID: appID, appName: appName, appIconURL: appIconURL, buttonState: .downloading,
                              progress: 0, remainingTime: 30)
            
            downloadInfo?.buttonState = .downloading
            appDownloadStates[appID] = downloadInfo
        }
        
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
        
        guard appDownloadStates[appID] != nil else { return }
        
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
            // 진행 상황이 바뀔 때마다 상태 저장
            saveAppStates()
        }
    }
    
    private func completeDownload(appID: String) {
        cancelTimer(for: appID)
        
        // 상태 업데이트
        appDownloadStates[appID]?.buttonState = .open
        appDownloadStates[appID]?.progress = 1.0
        appDownloadStates[appID]?.remainingTime = 0
        appDownloadStates[appID]?.downloadedDate = Date() // 다운로드 완료 시각 저장
        
        // 설치된 앱 목록에 추가
        userInstalledApps.insert(appID)
        
        // 변경 알림
        objectWillChange.send()
        
        // 상태 저장
        saveAppStates()
    }
    
    // MARK: - 백그라운드 처리
    
    public func enterBackground() {
        // 모든 현재 상태와 타이머 정보 저장
        saveAppStates()
    }
    
    public func enterForeground() {
        // 상태 복원
        loadAppStates()
        // 백그라운드에서 지난 시간 계산하여 진행 상태 업데이트
        updateStatesAfterBackground()
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
        
        // 앱이 강제 종료된 경우(즉, 마지막 업데이트 시간이 오래 전이면) 다운로드 중이던 앱을 재개 상태로 전환
        let lastUpdateTime = UserDefaults.standard.object(forKey: "lastUpdateTime") as? Date
        let currentTime = Date()
        if let lastUpdateTime = lastUpdateTime, currentTime.timeIntervalSince(lastUpdateTime) > 10 { // 10초 이상 차이 나면 강제종료로 간주
            for (appID, info) in appDownloadStates where info.buttonState == .downloading {
                if info.remainingTime > 0 {
                    var updated = info
                    updated.buttonState = .resume
                    appDownloadStates[appID] = updated
                } else {
                    completeDownload(appID: appID)
                }
            }
        }
    }
    
    private func handleNetworkChange(isConnected: Bool) {
        if isConnected {
            // 네트워크 복구: 일시정지된 다운로드 재개
            for (appID, info) in appDownloadStates where info.buttonState == .resume {
                resumeDownload(appID: appID)
            }
        } else {
            // 네트워크 단절: 다운로드 중인 모든 앱 일시정지
            for (appID, info) in appDownloadStates where info.buttonState == .downloading {
                pauseDownload(appID: appID)
            }
        }
    }
    
}
