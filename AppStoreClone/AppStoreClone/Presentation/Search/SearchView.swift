//
//  SearchView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct SearchView: View {
    
    @State private var searchText = ""
    @State private var isLoading = false
    @State private var searchResults: [SearchResultAppInfo] = []
    // 검색이 실제로 수행되었는지 추적 (초기 화면과 검색 결과 없을 때 구분)
    @State private var hasSearched = false
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    // 검색 결과가 있고 로딩 중이 아닐 때만 표시
                    if !isLoading && hasSearched {
                        if searchResults.isEmpty {
                            // 검색 결과가 없을 때 메시지 표시
                            HStack(alignment: .center) {
                                Text("'\(searchText)'에 대한 검색 결과 없음")
                                    .foregroundColor(.gray)
                                    .frame(alignment: .center)
                            }
                            .padding(.top, 50)
                        } else {
                            ForEach(searchResults) { result in
                                SearchResultRowView(appInfo: result)
                            }
                        }
                    }
                }
                .listStyle(.plain)
                .navigationTitle("검색")
                
                // 로딩 인디케이터
                if isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .searchable(text: $searchText, prompt: "게임, 앱, 스토리 등")
            //TODO: 추후 실시간 검색으로 바꾸기
            .onSubmit(of: .search) { // Return키 탭
                performSearch()
            }
            .onChange(of: searchText) { newValue in
                // 검색어가 비워지면 결과 초기화
                if newValue.isEmpty {
                    clearSearch()
                }
            }
        }
    }
    
    /// 검색 수행 함수
    private func performSearch() {
        // 빈 텍스트 방지
        guard !searchText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        hasSearched = true // 검색 수행 플래그 설정
        isLoading = true
        searchResults = [] // 이전 결과 초기화
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            //TODO: api 통신 작성
            searchResults = DummyLiterals.searchResultData.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.subtitle.localizedCaseInsensitiveContains(searchText)
            }
            isLoading = false
        }
    }
    
    /// 검색 초기화 함수
    private func clearSearch() {
        hasSearched = false
        searchResults = []
        isLoading = false
    }
    
}

#Preview {
    SearchView()
}
