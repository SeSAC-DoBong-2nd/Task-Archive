//
//  AppArchiveComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveRowView: View {
    let model: AppArchiveModel

    var body: some View {
        HStack(spacing: 15) {
            // 앱 아이콘
            Image(systemName: model.iconName) // SF Symbol 사용 예시, 실제 앱 아이콘 에셋 이름 사용 가능
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .background(Color.gray.opacity(0.2)) // 아이콘 배경 예시
                .cornerRadius(12)

            // 앱 이름 및 날짜
            VStack(alignment: .leading, spacing: 4) {
                Text(model.name)
                    .font(.headline)
                Text(model.date)
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer() // 버튼을 오른쪽으로 밀기

            // 상태별 버튼
            AppArchiveActionButton(state: model.buttonState)
        }
        .padding(.vertical, 8) // 행 상하 여백
    }
}

// 상태에 따라 모양이 변하는 버튼 뷰
struct AppArchiveActionButton: View {
    let state: AppButtonState

    var body: some View {
        Button(action: {
            // 버튼 탭 시 동작 (필요시 구현)
            print("\(state) 버튼 탭됨")
        }) {
            Text(buttonText)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 18)
                .padding(.vertical, 7)
                .frame(minWidth: 60) // 최소 너비
                .background(buttonBackgroundColor)
                .foregroundColor(buttonForegroundColor)
                .cornerRadius(15)
        }
        .buttonStyle(.plain) // 버튼 기본 스타일 제거하여 커스텀 스타일 적용
    }

    // 상태별 버튼 텍스트
    private var buttonText: String {
        switch state {
        case .open: return "열기"
        case .update: return "업데이트"
        case .get: return "받기"
        }
    }

    // 상태별 버튼 배경색
    private var buttonBackgroundColor: Color {
        switch state {
        case .get: return Color.blue // '받기'는 파란색 배경
        default: return Color(UIColor.systemGray5) // 나머지는 회색 배경
        }
    }

    // 상태별 버튼 글자색
    private var buttonForegroundColor: Color {
        switch state {
        case .get: return Color.white // '받기'는 흰색 글자
        default: return Color.blue // 나머지는 파란색 글자
        }
    }
}

#Preview {
    AppArchiveRowView(model: DummyAppData.apps[0])
        .padding()
}

#Preview {
     AppArchiveActionButton(state: .update)
}
