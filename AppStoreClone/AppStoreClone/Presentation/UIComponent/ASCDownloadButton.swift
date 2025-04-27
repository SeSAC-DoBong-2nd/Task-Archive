//
//  ASCDownloadButton.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

/// 다운로드 버튼 상태를 나타내는 열거형
enum ASCDownloadButtonState {
    case open
    case update
    case get
    
    var buttonText: String {
        switch self {
        case .open: return "열기"
        case .update: return "업데이트"
        case .get: return "받기"
        }
    }
    
    var buttonBackgroundColor: Color {
        switch self {
        case .get: return Color.blue
        default: return Color(uiColor: .systemGray5)
        }
    }
    
    var buttonForegroundColor: Color {
        switch self {
        case .get: return Color.white
        default: return Color.blue
        }
    }
    
}

/// 상태 분기처리 다운로드 버튼
struct ASCDownloadButton: View {
    
    let state: ASCDownloadButtonState

    var body: some View {
        Button(action: {
            print("\(state) 버튼 탭됨")
        }) {
            Text(state.buttonText)
                .font(.system(size: 14, weight: .bold))
                .padding(.horizontal, 18)
                .padding(.vertical, 7)
                .frame(minWidth: 60) // 최소 너비
                .background(state.buttonBackgroundColor)
                .foregroundColor(state.buttonForegroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .stroke(Color(uiColor: .systemGray6), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
    
}
