//
//  AppDetailComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI


//MARK: - 앱 헤더

struct AppHeaderView: View {
    let trackId: Int
    let iconURL: URL
    let appName: String
    var buttonState: ASCDownloadButtonState
    @EnvironmentObject private var downloadManager: AppDownloadManager

    var body: some View {
        HStack(spacing: 15) {
            asyncImage(url: iconURL)
                .scaledToFit()
                .frame(width: 120, height: 120)
                .background(Color.gray.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                )

            VStack(alignment: .leading, spacing: 4) {
                Text(appName) // 이름
                    .font(.title2).bold()
                Spacer()

                ASCDownloadButton(
                    appID: String(trackId),
                    appName: appName,
                    appIconURL: iconURL,
                    initialState: buttonState
                )
            }

            
        }
        .padding(.horizontal)
    }
}


//MARK: - 메타데이터

/// 메타데이터 항목 구조체
struct MetadataItem: Identifiable {
    let id = UUID()
    let title: String // 예: "15.6+"
    let subtitle: String // 예: "버전"
}

struct MetadataView: View {
    let data: MetadataItem

    var body: some View {
        VStack(spacing: 4) {
            Text(data.subtitle)
                .font(.caption)
                .foregroundColor(.gray)
            Spacer()
            Text(data.title)
                .font((data.subtitle == "버전" || data.subtitle == "연령") ? .title3 : .caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
        .frame(width: 100)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 5)
    }
}


//MARK: - 새로운 소식

struct WhatsNewView: View {
    let version: String
    let updateDate: String
    let releaseNotes: String
    /// 더보기 상태
    @State private var isExpanded: Bool = false

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("새로운 소식")
                    .font(.title2).bold()
                Spacer()
                Button("버전 기록") {
                    print("버전 기록 클릭")
                }
                    .font(.callout)
            }

            HStack {
                Text("버전 \(version)")
                Spacer()
                Text(updateDate)
            }
            .font(.caption)
            .foregroundColor(.gray)

            // 줄 제한 및 더보기 버튼
            Text(releaseNotes)
                .font(.callout)
                .lineLimit(isExpanded ? nil : 3) // 3줄 제한 또는 전체 보기

            // "더 보기" 버튼은 텍스트가 3줄을 초과할 때만 표시 (개선 필요 시 GeometryReader 등 사용)
            if !isExpanded && needsMoreButton(text: releaseNotes) {
                HStack {
                    Spacer() // 버튼 오른쪽 정렬
                    Button("더 보기") {
                        withAnimation { // 부드러운 확장/축소
                            isExpanded.toggle()
                        }
                    }
                    .font(.callout)
                }
            }
        }
        .padding(.horizontal)
    }

    // 3줄 초과 여부 판단
    private func needsMoreButton(text: String) -> Bool {
        text.split(whereSeparator: \.isNewline).count > 3
    }
}


//MARK: -  미리보기

struct ScreenshotPreviewImage: View {
    let imageName: URL?
    let action: () -> Void // 탭 액션 규정

    var body: some View {
        asyncImage(url: imageName)
            .scaledToFill()
            .frame(width: 200, height: 400)
            .clipShape(RoundedRectangle(cornerRadius: 18))
            .overlay(
                RoundedRectangle(cornerRadius: 18)
                    .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
            )
            .onTapGesture(perform: action) // 탭 제스처
    }
}


//MARK: - 스크린샷 상세보기

struct ScreenshotView: View {

    let trackId: Int
    let iconURL: URL
    let appName: String
    var buttonState: ASCDownloadButtonState
    @EnvironmentObject private var downloadManager: AppDownloadManager
    
    let screenshots: [URL]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                ForEach(screenshots, id: \.self) { url in
                    asyncImage(url: url)
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 18))
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                        )
                        .padding(.all, 20)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("완료") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        print("App Action Button Tapped!")
                    } label: {
                        ASCDownloadButton(
                            appID: String(trackId),
                            appName: appName,
                            appIconURL: iconURL,
                            initialState: buttonState
                        )
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}


