//
//  AppDetailComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI


//MARK: - 앱 헤더

struct AppHeaderView: View {
    let appInfo: AppInfoModel

    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: appInfo.iconName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(12)

            VStack(alignment: .leading, spacing: 4) {
                Text(appInfo.name) // 이름
                    .font(.title2).bold()
                Text("Placeholder Developer")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }

            Spacer()

            ASCDownloadButton(state: appInfo.buttonState)
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
    let description: String? // 예: "만 4세 이상"
}

struct MetadataView: View {
    let item: MetadataItem

    var body: some View {
        VStack(spacing: 2) {
            Text(item.subtitle)
                .font(.caption)
                .foregroundColor(.gray)
            Text(item.title)
                .font(.headline) // 필요시 .title3 등으로 조절
                .lineLimit(1)
            if let description = item.description {
                Text(description)
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 80) // 각 항목 너비 고정 (조절 가능)
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
        VStack(alignment: .leading, spacing: 8) {
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
    let imageName: String
    let action: () -> Void // 탭 액션 규정

    var body: some View {
        Image(imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 200, height: 400)
            .clipped()
            .cornerRadius(18)
            .onTapGesture(perform: action) // 탭 제스처
    }
}


//MARK: - 스크린샷 상세보기

struct ScreenshotView: View {

    let appInfo: AppInfoModel
    let screenshots: [String]
    @Binding var selectedIndex: Int
    @Environment(\.dismiss) var dismiss

    var body: some View {
        NavigationView {
            TabView(selection: $selectedIndex) {
                ForEach(screenshots.indices, id: \.self) { index in
                    Image(screenshots[index])
                        .resizable()
                        .scaledToFit()
                        .tag(index)
                        .clipped()
                        .cornerRadius(18)
                        .padding(.all, 40)
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
                        ASCDownloadButton(state: appInfo.buttonState)
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
}


