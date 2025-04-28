//
//  SearchViewModel.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import SwiftUI
import Combine

final class SearchViewModel: ObservableObject {
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var searchResults: [SearchResultModel] = []
    @Published var hasSearched: Bool = false
    @Published var errorMessage: String? = nil
    @Published var path: [Int] = []
    @Published var currentOffset: Int = 0
    @Published var isFetchingMore: Bool = false
    @Published var canLoadMore: Bool = true
    @Published var refreshBlocked: Bool = false

    let pageSize = 15
    let repo: ITunesRepository
    private var cancellables = Set<AnyCancellable>()

    init(repo: ITunesRepository) {
        self.repo = repo
    }

    ///검색 API 호출
    @MainActor
    func performSearch() async {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchTerm.isEmpty else { return }
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

    ///페이지네이션
    @MainActor
    func loadMore() async {
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

    ///검색어 초기화
    @MainActor
    func clearSearch() {
        hasSearched = false
        searchResults = []
        isLoading = false
        errorMessage = nil
    }

    ///검색 결과 에러 반환
    @MainActor
    func handleSearchError(_ message: String) {
        isLoading = false
        searchResults = []
        errorMessage = message
    }
}
