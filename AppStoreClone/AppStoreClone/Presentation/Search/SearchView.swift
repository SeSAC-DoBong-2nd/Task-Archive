//
//  SearchView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct SearchResultRowView: View {
    let appInfo: SearchResultAppInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 15) { // 전체 행 VStack
            // 상단 정보 (아이콘, 이름, 부제, 버튼)
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: appInfo.iconName) // 아이콘
                    .resizable()
                    .scaledToFit()
                    .frame(width: 55, height: 55)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)

                VStack(alignment: .leading, spacing: 2) {
                    Text(appInfo.name) // 이름
                        .font(.headline)
                    Text(appInfo.subtitle) // 부제
                        .font(.caption)
                        .foregroundColor(.gray)

                    
                }

                Spacer() // 버튼 오른쪽으로 밀기

                ASCDownloadButton(state: appInfo.buttonState) // 상태 버튼
                    .padding(.top, 5) // 버튼 상단 여백
            }
            
            HStack {
                Text(appInfo.requiredOS) // 지원 OS
                     .font(.caption2)
                     .foregroundColor(.gray)
                     .padding(.top, 1)
                
                Spacer()
                
                Image(systemName: "person.crop.square") // 개발자 아이콘 예시
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

            // 스크린샷 스크롤 뷰
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 8) {
                    ForEach(appInfo.screenshots, id: \.self) { screenshotName in
                        Image(screenshotName) // 에셋 이름으로 이미지 로드
                            .resizable()
                            .scaledToFill() // 꽉 채우기
                            .frame(width: 120, height: 210) // 스크린샷 크기 (조절 가능)
                            .clipped()
                            .cornerRadius(10)
                    }
                }
                // .padding(.leading) // 필요시 왼쪽 시작 여백
            }
        }
        .padding(.vertical, 10) // 행 전체 상하 여백
    }
}


#Preview {
    SearchResultRowView(appInfo: DummyLiterals.searchResultData[0])
        .padding()
}

import SwiftUI

struct SearchView: View {
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var searchResults: [SearchResultAppInfo] = []
    // 검색이 실제로 수행되었는지 추적 (초기 화면과 검색 결과 없을 때 구분)
    @State private var hasSearched = false

    var body: some View {
        NavigationView {
            ZStack { // 로딩 인디케이터를 위에 띄우기 위해 ZStack 사용
                // 검색 결과 리스트
                List {
                    // 검색 결과가 있고 로딩 중이 아닐 때만 표시
                    if !isLoading && hasSearched {
                        if searchResults.isEmpty {
                            // 검색 결과가 없을 때 메시지 표시
                            Text("'\(searchText)'에 대한 검색 결과 없음")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 50)
                        } else {
                            ForEach(searchResults) { result in
                                SearchResultRowView(appInfo: result)
                            }
                            // 행 구분선 숨기기 (선택 사항)
                            // .listRowSeparator(.hidden)
                        }
                    } else if !isLoading && !hasSearched {
                         // 초기 화면 (아직 검색 안 함) - 필요시 구현
                         Text("최근 검색어 또는 추천 앱 표시")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 50)
                    }
                }
                .listStyle(.plain)
                // .navigationTitle("검색") // 네비게이션 타이틀 필요 시

                // 로딩 인디케이터
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5) // 인디케이터 크기 조절
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        // .background(Color.black.opacity(0.1)) // 반투명 배경 (선택 사항)
                }
            }
            // searchable 수정자를 NavigationView 내부 컨텐츠에 적용
            .searchable(text: $searchText, prompt: "게임, 앱, 스토리 등")
            .onSubmit(of: .search) { // 검색 실행 (Return 키)
                performSearch()
            }
            .onChange(of: searchText) { newValue in // 텍스트 변경 감지
                // 검색어가 비워지면 결과 초기화
                if newValue.isEmpty {
                    clearSearch()
                }
                // 실시간 검색을 원하면 여기서 performSearch() 호출 (디바운스 고려)
            }
        }
        // .navigationViewStyle(.stack) // iPad 등에서 기본 스타일 유지
    }

    // 검색 수행 함수
    private func performSearch() {
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return // 빈 텍스트는 검색 안 함
        }
        hasSearched = true // 검색 수행 플래그 설정
        isLoading = true
        searchResults = [] // 이전 결과 초기화

        // API 호출 대신 더미 데이터 로딩 및 딜레이 시뮬레이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // 1.5초 딜레이
            // 검색어와 관련된 더미 결과 필터링 (실제로는 API 결과 사용)
            searchResults = DummyLiterals.searchResultData.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
            isLoading = false
        }
    }

    // 검색 초기화 함수
    private func clearSearch() {
        hasSearched = false
        searchResults = []
        // isLoading = false // 로딩 중에 지울 수도 있으므로 주석 처리하거나 로직 추가
    }
}

#Preview {
    SearchView()
}
