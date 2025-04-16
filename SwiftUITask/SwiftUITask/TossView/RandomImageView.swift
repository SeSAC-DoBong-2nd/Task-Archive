//
//  RandomImageView.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/16/25.
//

import SwiftUI

struct RandomImageView: View {
    
    let sectionTitles = ["첫번째 섹션", "두번째 섹션", "세번째 섹션", "네번째 섹션"]

    var body: some View {
        NavigationView {
            List {
                ForEach(sectionTitles, id: \.self) { title in
                    Section {
                        ImageRowView()
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    } header: {
                        HeaderView(title: title)
                    }
                }
            }
            .listStyle(.plain)
            .listSectionSeparator(.hidden)
            .navigationTitle("My Random Image")
            .navigationBarTitleDisplayMode(.large)
        }
    }
    
}

struct ImageRowView: View {
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(1...10, id: \.self) { _ in
                    ImageCell(id: (1...200).randomElement()!)
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 5)
        }
    }
    
}


struct HeaderView: View {
    
    let title: String

    var body: some View {
        Text(title)
            .font(.title3)
            .fontWeight(.bold)
            .foregroundColor(.primary)
            .padding(.bottom, 5)
    }
    
}

struct ImageCell: View {
    
    let id: Int
    var url: URL {
        URL(string: "https://picsum.photos/id/\(id)/100/140")!
    }

    var body: some View {
        AsyncImage(url: url) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            case .failure:
                Image(systemName: "photo.fill")
                    .foregroundColor(.secondary)
            @unknown default:
                EmptyView()
            }
        }
        .frame(width: 100, height: 140)
        .background(Color.secondary.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
}

#Preview {
    RandomImageView()
}
