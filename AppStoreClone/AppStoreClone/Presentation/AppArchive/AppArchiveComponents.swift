//
//  AppArchiveComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveRowView: View {
    
    let model: AppDownloadInfo
    @EnvironmentObject private var downloadManager: AppDownloadManager

    // 날짜 포맷터 (한국 기준)
    private var formattedDate: String {
        guard let date = model.downloadedDate else { return "" }
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy. MM. dd."
        return formatter.string(from: date)
    }

    var body: some View {
        HStack(spacing: 15) {
            // 앱 아이콘
            asyncImage(url: model.appIconURL)
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                )

            // 앱 이름 및 날짜
            VStack(alignment: .leading, spacing: 4) {
                Text(model.appName)
                    .font(.headline)
                Text(formattedDate)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer() // 버튼을 오른쪽으로 밀기

            // 상태별 버튼
            ASCDownloadButton(
                appID: model.appID,
                appName: model.appName,
                appIconURL: model.appIconURL,
                initialState: model.buttonState
            )
        }
        .padding(.vertical, 8) // 행 상하 여백
    }
    
}
