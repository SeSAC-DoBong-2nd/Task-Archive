//
//  AppDetailViewModel.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import SwiftUI
import Combine

final class AppDetailViewModel: ObservableObject {
    @Published var appDetail: AppDetailModel? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    private let repo: ITunesRepository
    private var cancellables = Set<AnyCancellable>()

    init(repo: ITunesRepository) {
        self.repo = repo
    }

    @MainActor
    func fetchAppDetail(trackId: Int) async {
        isLoading = true
        errorMessage = nil
        do {
            let detail = try await repo.lookup(trackId: trackId)
            self.appDetail = detail
        } catch {
            self.errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
