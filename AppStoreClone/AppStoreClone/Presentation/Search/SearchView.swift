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
    @State private var searchResults: [SearchResultModel] = []
    @State private var hasSearched = false
    // 에러 메시지 표시 상태 (선택 사항)
    @State private var errorMessage: String? = nil
    @State private var path: [Int] = [] // navigation path
    @State private var currentOffset: Int = 0
    @State private var isFetchingMore: Bool = false
    @State private var canLoadMore: Bool = true
    let pageSize = 15
    let repo: ITunesRepository
    
    init(repo: ITunesRepository) {
        self.repo = repo
    }
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                // 검색 결과 리스트 또는 메시지
                List {
                    if !isLoading && hasSearched {
                        if let errorMsg = errorMessage {
                            Text("오류: \(errorMsg)") // 에러 메시지 표시
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 50)
                        } else if searchResults.isEmpty {
                            Text("'\(searchText)'에 대한 검색 결과 없음")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 50)
                        } else {
                            ForEach(searchResults.indices, id: \.self) { idx in
                                let result = searchResults[idx]
                                Button {
                                    path.append(result.trackId)
                                } label: {
                                    SearchResultRowView(appInfo: result)
                                }
                                .onAppear {
                                    if idx >= searchResults.count - 4 {
                                        Task { await loadMore() }
                                    }
                                }
                            }
                        }
                    } else if !isLoading && !hasSearched {
                        Text("검색어를 입력하고 검색 버튼을 누르세요.")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 50)
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
            .onSubmit(of: .search) { // Return 키 탭 시 검색 실행
                // 비동기 작업 시작
                Task {
                    await performSearch()
                }
            }
            .onChange(of: searchText) { newValue in
                // 검색어가 비워지면 결과 초기화
                if newValue.isEmpty && hasSearched { // 검색한 적이 있을 때만 초기화
                    clearSearch()
                }
            }
            .navigationDestination(for: Int.self) { trackId in
                AppDetailView(trackId: trackId, repo: repo)
            }
        }
    }
    
    
    /// 검색 실행
    @MainActor // UI 업데이트를 위해 메인 액터에서 실행
    private func performSearch() async {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchTerm.isEmpty else {
            print("검색어가 비어있습니다.")
            return
        }
        
        print("검색 시작: \(searchTerm)")
        isLoading = true
        hasSearched = true
        errorMessage = nil
        searchResults = []
        currentOffset = 0
        canLoadMore = true
        
        do {
            let results = try await repo.searchApps(query: searchTerm, offset: 0)
            searchResults = results
            currentOffset = results.count
            canLoadMore = results.count == pageSize
        } catch {
            handleSearchError(error.localizedDescription)
        }
        
        isLoading = false
    }
    
    @MainActor
    private func loadMore() async {
        guard !isFetchingMore, canLoadMore, !isLoading else { return }
        isFetchingMore = true
        defer { isFetchingMore = false }
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        do {
            let moreResults = try await repo.searchApps(query: searchTerm, offset: currentOffset)
            if moreResults.isEmpty {
                canLoadMore = false
            } else {
                searchResults.append(contentsOf: moreResults)
                currentOffset += moreResults.count
                canLoadMore = moreResults.count == pageSize
            }
        } catch {
            canLoadMore = false
        }
    }
    
    /// 검색 초기화 함수
    @MainActor
    private func clearSearch() {
        print("검색 초기화")
        hasSearched = false
        searchResults = []
        isLoading = false
        errorMessage = nil
    }
    
    /// 검색 오류 처리 함수
    @MainActor
    private func handleSearchError(_ message: String) {
        print("검색 오류: \(message)")
        isLoading = false
        searchResults = [] // 오류 시 결과 없음
        errorMessage = message // 에러 메시지 설정
    }
    
}
