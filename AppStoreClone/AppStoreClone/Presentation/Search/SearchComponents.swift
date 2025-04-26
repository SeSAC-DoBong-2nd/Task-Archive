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
                asyncImage(url: appInfo.iconName)
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
            if let urls = appInfo.screenshotURLs, !urls.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(urls, id: \.absoluteString) { url in
                            asyncImage(url: url)
                                .scaledToFill()
                                .frame(width: 120, height: 210)
                        }
                    }
                }
            } else {
                Text("스크린샷 없음")
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.leading)
            }
        }
        .padding(.vertical, 10)
    }
    
    
    @ViewBuilder
    func asyncImage(url: URL?) -> some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: 120, height: 210)
                        .background(Color.gray.opacity(0.1))
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
                        .scaledToFit()
                        .foregroundColor(.gray)
                        .padding(40)
                        .background(Color.gray.opacity(0.1))
                @unknown default:
                    EmptyView()
                }
            }
            .clipped()
            .cornerRadius(10)
        } else {
            Image(systemName: "photo.fill")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray.opacity(0.5))
                .frame(width: 120, height: 210)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
    
}


//#Preview {
//    SearchResultRowView(appInfo: DummyLiterals.searchResultData[0])
//        .padding()
//}
