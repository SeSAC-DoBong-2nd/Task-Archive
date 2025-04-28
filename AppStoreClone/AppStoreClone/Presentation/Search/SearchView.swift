//
//  SearchView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

struct SearchView: View {
    @StateObject private var vm: SearchViewModel

    init(repo: ITunesRepository) {
        _vm = StateObject(wrappedValue: SearchViewModel(repo: repo))
    }

    var body: some View {
        NavigationStack(path: $vm.path) {
            ZStack {
                List {
                    if !vm.isLoading && vm.hasSearched {
                        if let errorMsg = vm.errorMessage {
                            Text("오류: \(errorMsg)")
                                .foregroundColor(.red)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 50)
                        } else if vm.searchResults.isEmpty {
                            Text("'\(vm.searchText)'에 대한 검색 결과 없음")
                                .foregroundColor(.gray)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 50)
                        } else {
                            ForEach(vm.searchResults.indices, id: \.self) { idx in
                                let result = vm.searchResults[idx]
                                Button {
                                    vm.path.append(result.trackId)
                                } label: {
                                    SearchResultRowView(appInfo: result)
                                }
                                .onAppear {
                                    if idx >= vm.searchResults.count - 4 {
                                        Task { await vm.loadMore() }
                                    }
                                }
                            }
                        }
                    } else if !vm.isLoading && !vm.hasSearched {
                        Text("검색어를 입력하고 검색 버튼을 누르세요.")
                            .foregroundColor(.gray)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(.top, 50)
                    }
                }
                .listStyle(.plain)
                .navigationTitle("검색")
                .refreshable {
                    guard !vm.refreshBlocked else { return }
                    vm.refreshBlocked = true
                    await vm.performSearch()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        vm.refreshBlocked = false
                    }
                }

                if vm.isLoading {
                    ProgressView()
                        .scaleEffect(1.5)
                        .progressViewStyle(.circular)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            }
            .searchable(text: $vm.searchText, prompt: "게임, 앱, 스토리 등")
            .onSubmit(of: .search) {
                Task { await vm.performSearch() }
            }
            .onChange(of: vm.searchText) { newValue in
                if newValue.isEmpty && vm.hasSearched {
                    vm.clearSearch()
                }
            }
            .navigationDestination(for: Int.self) { trackId in
                AppDetailView(trackId: trackId, repo: vm.repo)
            }
        }
    }
}
