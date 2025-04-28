//
//  SearchComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct SearchResultRowView: View {
    
    let appInfo: SearchResultModel
    @EnvironmentObject private var downloadManager: AppDownloadManager
    
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: 상단 정보 (아이콘, 이름, 부제, 버튼)
            HStack(alignment: .top) {
                asyncImage(url: appInfo.iconName)
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                    )
                
                VStack(alignment: .leading, spacing: 2) {
                    Text(appInfo.name) // 이름
                        .font(.headline)
                        .lineLimit(1)
                        .truncationMode(.tail)
                    Text(appInfo.subtitle) // 부제
                        .font(.caption)
                        .lineLimit(2)
                        .foregroundColor(.gray)
                }
                
                Spacer()
                
                // 새로운 다운로드 버튼으로 교체
                // 앱 ID를 고유 식별자로 사용
                ASCDownloadButton(
                    appID: String(appInfo.trackId),
                    appName: appInfo.name,
                    appIconURL: appInfo.iconName,
                    initialState: appInfo.buttonState
                )
                .padding(.top, 5)
            }
            
            HStack {
                Text(appInfo.requiredOS) // 지원 OS
                    .font(.caption2)
                    .foregroundColor(.gray)
                    .padding(.top, 1)
                
                Spacer()
                
                Image(systemName: "person.crop.square") // 개발자 아이콘
                    .font(.caption)
                    .foregroundColor(.gray)
                Text(appInfo.developer)
                    .font(.caption)
                    .foregroundColor(.gray)
                
                Spacer()
                
                Text(appInfo.category)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)
            
            //MARK: 스크린샷 스크롤 파트
            let realButtonState = downloadManager.appDownloadStates[String(appInfo.trackId)]?.buttonState ?? appInfo.buttonState
            if realButtonState != .open, let urls = appInfo.screenshotURLs, !urls.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack() {
                        ForEach(urls, id: \.absoluteString) { url in
                            asyncImage(url: url)
                                .scaledToFill()
                                .frame(width: 120, height: 210)
                                .clipShape(RoundedRectangle(cornerRadius: 18))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 18)
                                        .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                                )
                        }
                    }
                }
            }
        }
        .padding(.vertical, 10)
    }
    
}
