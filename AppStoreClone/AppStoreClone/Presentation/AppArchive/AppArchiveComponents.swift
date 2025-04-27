//
//  AppArchiveComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct AppArchiveRowView: View {
    
    let model: AppInfoModel

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
                Text(model.date ?? "")
                    .font(.caption)
                    .foregroundColor(.gray)
            }

            Spacer() // 버튼을 오른쪽으로 밀기

            // 상태별 버튼
            ASCDownloadButton(state: model.buttonState)
        }
        .padding(.vertical, 8) // 행 상하 여백
    }
    
}



#Preview {
    AppArchiveRowView(model: DummyLiterals.appArchiveData[0])
        .padding()
}
