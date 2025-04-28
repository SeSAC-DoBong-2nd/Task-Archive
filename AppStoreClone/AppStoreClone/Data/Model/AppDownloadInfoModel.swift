//
//  AppDownloadInfoModel.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import Foundation

// 앱 다운로드 정보를 저장할 구조체
struct AppDownloadInfo: Codable, Identifiable {
    let appID: String
    let appName: String
    let appIconURL: URL?
    var buttonState: ASCDownloadButtonState
    var progress: Double
    var remainingTime: TimeInterval
    var downloadedDate: Date? // 다운로드 완료 날짜
    
    var id: String { appID }
    
    // Codable 준수를 위한 구현
    enum CodingKeys: String, CodingKey {
        case appID, appName, appIconURL, buttonState, progress, remainingTime, downloadedDate
    }
    
    init(appID: String, appName: String, appIconURL: URL?, buttonState: ASCDownloadButtonState, progress: Double, remainingTime: TimeInterval, downloadedDate: Date? = nil) {
        self.appID = appID
        self.appName = appName
        self.appIconURL = appIconURL
        self.buttonState = buttonState
        self.progress = progress
        self.remainingTime = remainingTime
        self.downloadedDate = downloadedDate
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
        downloadedDate = try container.decodeIfPresent(Date.self, forKey: .downloadedDate)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appID, forKey: .appID)
        try container.encode(appName, forKey: .appName)
        try container.encode(appIconURL, forKey: .appIconURL)
        try container.encode(buttonState.toRawValue(), forKey: .buttonState)
        try container.encode(progress, forKey: .progress)
        try container.encode(remainingTime, forKey: .remainingTime)
        try container.encodeIfPresent(downloadedDate, forKey: .downloadedDate)
    }
}
