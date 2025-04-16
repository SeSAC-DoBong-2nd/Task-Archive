//
//  CoinView.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/16/25.
//

import SwiftUI

struct CoinView: View {

    @State private var money: [Market] = []
    @State private var searchText = ""
    @State private var isLoading = false

    var body: some View {

        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    horizontalScrollView()

                    if isLoading {
                        ProgressView()
                            .padding(.top, 50)
                    } else if money.isEmpty && !searchText.isEmpty {
                        Text("'\(searchText)'에 대한 검색 결과가 없습니다.")
                            .foregroundStyle(.gray)
                            .padding(.top, 50)
                    } else {
                        gridView()
                    }

                    Spacer()
                }
                .padding(.top)
            }
            .navigationTitle("My Crypto")
            .refreshable {
                await fetchAllCoins()
            }
            .searchable(text: $searchText, prompt: "코인 이름 또는 심볼 검색")
            .onSubmit(of: .search) {
                if !searchText.isEmpty {
                    Task {
                        await searchCoins(query: searchText)
                    }
                } else {
                    Task {
                        await fetchAllCoins()
                    }
                }
            }
        }
        .task {
            await fetchAllCoins()
        }
    }

    /// 전체 코인 로드
    private func fetchAllCoins() async {
        isLoading = true // 로딩 시작
        do {
            let market = try await CoinNetwork.shared.fetchAllMarket()
            self.money = market
        } catch APIError.invalidResponse {
            money = []
            print("Error: 유효하지 않은 응답")
        } catch {
            money = []
            print("Error fetching all coins: \(error)")
        }
        isLoading = false
    }

    /// 검색어로 코인 로드
    private func searchCoins(query: String) async {
        guard !query.isEmpty else {
             await fetchAllCoins()
             return
        }

        isLoading = true
        do {
            let market = try await CoinNetwork.shared.searchMarket(query: query)
            self.money = market
        } catch APIError.invalidResponse {
            money = []
            print("Error: 유효하지 않은 검색 응답")
        } catch {
            money = []
            print("Error searching coins with query '\(query)': \(error)")
        }
        isLoading = false
    }

    private func horizontalScrollView() -> some View {
        ScrollView(.horizontal) {
            HStack {
                ForEach(0..<5) { item in
                    bannerView()
                        .containerRelativeFrame(.horizontal)
                }
            }
            .scrollTargetLayout()
        }
        .scrollTargetBehavior(.viewAligned)
    }

    func gridView() -> some View {
        let columns: [GridItem] = [
            GridItem(.flexible(), spacing: 15),
            GridItem(.flexible(), spacing: 15)
        ]

        return LazyVGrid(columns: columns, spacing: 15) {
            ForEach($money, id: \.id) { item in
                NavigationLink {
                    Text("\(item.wrappedValue.koreanName) 상세 페이지")
                } label: {
                    CoinRowView(data: item)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 15)
    }


    func bannerView() -> some View {
        ZStack{
            Rectangle()
                .fill(Color.indigo.opacity(0.8))
                .overlay(alignment: .leading) {
                    Circle()
                        .fill(Color.indigo)
                        .scaleEffect(2, anchor: .topLeading)
                        .offset(x: -70, y: -70)
                }
                .clipShape(RoundedRectangle(cornerRadius: 20, style: .circular))

            VStack(alignment: .leading, spacing: 10) {
                Spacer()
                Text("나의 자산 현황")
                    .font(.callout)
                Text("1,234,567 원")
                    .font(.title)
                    .bold()
            }
            .padding(20)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, alignment: .leading)

        }
         .padding(.horizontal, 10)
        .frame(height: 150)
    }
}


struct CoinRowView: View {

    @Binding var data: Market

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                VStack(alignment: .leading) {
                    Text(data.koreanName)
                        .font(.caption)
                    Text(data.englishName)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text(data.market)
                        .font(.caption2)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                    
                    Spacer()
                    
                    Button {
                        data.like.toggle()
                    } label: {
                        Image(systemName: data.like ? "star.fill" : "star")
                            .foregroundStyle(data.like ? Color.yellow : Color.gray)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, minHeight: 70)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .contentShape(Rectangle())
        .shadow(color: .gray.opacity(0.2), radius: 3, x: 0, y: 2)
    }
}


struct CoinDetailView: View {
    
    @Binding var data: Market
    
    var body: some View {
        CoinRowView(data: $data)
    }
}


#Preview {
    CoinView()
}
