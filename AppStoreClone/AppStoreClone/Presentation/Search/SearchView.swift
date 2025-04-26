//
//  SearchView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/25/25.
//

import SwiftUI

// iTunes API 전체 응답 구조체
struct ITunesSearchResponse: Codable {
    let resultCount: Int
    let results: [AppResultDTO] // 앱 결과 배열
}

// API에서 받는 앱 정보 구조체 (DTO)
struct AppResultDTO: Codable {
    let trackId: Int             // 앱 고유 ID
    let trackName: String        // 앱 이름
    let bundleId: String         // 번들 ID
    let artworkUrl100: String    // 100x100 아이콘 URL
    let primaryGenreName: String // 주 카테고리
    let artistName: String       // 개발사 이름
    let minimumOsVersion: String // 최소 지원 OS 버전
    let screenshotUrls: [String] // 스크린샷 URL 배열
    let version: String          // 현재 버전
    let description: String?     // 앱 설명 (필요시 사용)
    let releaseNotes: String?    // 릴리즈 노트 (필요시 사용)
    // 필요한 다른 필드가 있다면 추가...
}


struct SearchView: View {

    @State private var searchText = ""
    @State private var isLoading = false
    @State private var searchResults: [SearchResultAppInfo] = []
    @State private var hasSearched = false
    // 에러 메시지 표시 상태 (선택 사항)
    @State private var errorMessage: String? = nil

    var body: some View {
        NavigationView {
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
                            ForEach(searchResults) { result in
                                SearchResultRowView(appInfo: result)
                                    // .listRowSeparator(.hidden) // 행 구분선 숨기기
                            }
                        }
                    } else if !isLoading && !hasSearched {
                        Text("검색어를 입력하고 검색 버튼을 누르세요.") // 초기 안내
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
                        // .background(.ultraThinMaterial) // 반투명 배경 효과
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
            // 네비게이션 바 숨김 처리 (만약 필요하다면)
            // .navigationBarHidden(true)
        }
        // .navigationViewStyle(.stack)
    }

    // --- 검색 관련 함수들 ---

    /// API를 호출하여 앱을 검색하는 비동기 함수
    @MainActor // UI 업데이트를 위해 메인 액터에서 실행
    private func performSearch() async {
        let searchTerm = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !searchTerm.isEmpty else {
            print("검색어가 비어있습니다.")
            return
        }

        print("검색 시작: \(searchTerm)")
        isLoading = true
        hasSearched = true // 검색 시도 플래그
        errorMessage = nil // 이전 에러 메시지 초기화
        searchResults = [] // 이전 결과 초기화

        // 1. URL 생성
        guard var urlComponents = URLComponents(string: "https://itunes.apple.com/search") else {
            handleSearchError("잘못된 API URL")
            return
        }
        urlComponents.queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "country", value: "kr"), // 한국 스토어
            URLQueryItem(name: "media", value: "software"), // 앱 검색
            URLQueryItem(name: "entity", value: "software"), // 결과 타입을 앱으로 제한
            URLQueryItem(name: "limit", value: "15") // 결과 개수 제한
        ]

        guard let url = urlComponents.url else {
            handleSearchError("URL 생성 실패")
            return
        }

        // 2. API 호출 및 데이터 처리
        do {
            let (data, response) = try await URLSession.shared.data(from: url)

            // HTTP 응답 확인
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse) // 서버 응답 오류 처리
            }

            // 3. JSON 디코딩
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(ITunesSearchResponse.self, from: data)

            // 4. DTO -> UI 모델 매핑
            searchResults = mapDTOsToUIModels(dtos: searchResponse.results)
            print("검색 완료: \(searchResults.count)개 결과")

        } catch {
            print("검색 중 오류 발생: \(error)")
            handleSearchError(error.localizedDescription) // 사용자에게 보여줄 에러 메시지 처리
        }

        // 5. 로딩 상태 종료 (성공/실패 모두)
        isLoading = false
    }

    /// DTO 배열을 UI 모델 배열로 변환하는 함수
    private func mapDTOsToUIModels(dtos: [AppResultDTO]) -> [SearchResultAppInfo] {
            return dtos.map { dto in
                let buttonState = ASCDownloadButtonState.get // 임시 상태
                let icon = mapCategoryToIcon(category: dto.primaryGenreName) // 임시 아이콘

                // --- 스크린샷 URL 변환 ---
                let screenshotURLs: [URL]? = dto.screenshotUrls.compactMap { URL(string: $0) }
                let iconURL: URL? = URL(string: dto.artworkUrl100)
                // --- ---
                return SearchResultAppInfo(
                    iconName: iconURL,
                    name: dto.trackName,
                    subtitle: dto.primaryGenreName,
                    developer: dto.artistName,
                    category: dto.primaryGenreName,
                    requiredOS: "iOS \(dto.minimumOsVersion)",
                    // 변환된 URL 배열 전달
                    screenshotURLs: screenshotURLs,
                    buttonState: buttonState
                )
            }
        }

    /// 카테고리에 따라 임시 아이콘 반환 (예시)
    private func mapCategoryToIcon(category: String) -> String {
        switch category.lowercased() {
        case "social networking": return "message.fill"
        case "navigation": return "map.fill"
        case "music": return "music.note.tv.fill"
        case "utilities": return "globe"
        case "games": return "gamecontroller.fill"
        default: return "square.stack.3d.up.fill" // 기본 앱 아이콘
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

#Preview {
    SearchView()
}
