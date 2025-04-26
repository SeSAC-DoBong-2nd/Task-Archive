//
//  SearchComponents.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct SearchResultRowView: View {
    
    let appInfo: SearchResultAppInfo
    
    var body: some View {
        VStack(alignment: .leading) {
            //MARK: 상단 정보 (아이콘, 이름, 부제, 버튼)
            HStack(alignment: .top) {
                Image(systemName: appInfo.iconName) // 앱 아이콘
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                
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
                
                ASCDownloadButton(state: appInfo.buttonState) // 상태 버튼
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
            if let urls = appInfo.screenshotURLs, !urls.isEmpty { // URL 배열이 유효한지 확인
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(urls, id: \.absoluteString) { url in // URL 자체를 ID로 사용
                            // --- AsyncImage 사용 ---
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .empty: // 아직 로드 시작 전
                                    ProgressView() // 로딩 인디케이터 표시
                                        .frame(width: 120, height: 210)
                                        .background(Color.gray.opacity(0.1)) // 플레이스홀더 배경
                                case .success(let image): // 로드 성공
                                    image
                                        .resizable()
                                        .scaledToFill() // 이미지 표시
                                case .failure: // 로드 실패
                                    Image(systemName: "photo") // 에러 아이콘 표시
                                        .resizable()
                                        .scaledToFit()
                                        .foregroundColor(.gray)
                                        .padding(40) // 아이콘 크기 조절용 패딩
                                        .background(Color.gray.opacity(0.1)) // 플레이스홀더 배경
                                @unknown default:
                                    EmptyView() // 미래의 상태 대비
                                }
                            }
                            .frame(width: 120, height: 210) // AsyncImage 자체의 프레임 설정
                            .clipped()
                            .cornerRadius(10)
                            // --- ---
                        }
                    }
                }
            } else {
                // 스크린샷 URL이 없는 경우 (선택 사항)
                Text("스크린샷 없음")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
        }
        .padding(.vertical, 10)
    }
    
}


//#Preview {
//    SearchResultRowView(appInfo: DummyLiterals.searchResultData[0])
//        .padding()
//}
