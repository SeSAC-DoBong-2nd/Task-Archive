//
//  AsyncImageWrapper.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/27/25.
//

import SwiftUI

private struct AsyncImageModifier: ViewModifier {
    let url: URL?
    
    func body(content: Content) -> some View {
        if let url = url {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .background(Color.gray.opacity(0.1))
                case .success(let image):
                    image
                        .resizable()
                case .failure:
                    Image(systemName: "photo")
                        .resizable()
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
                .foregroundColor(.gray.opacity(0.5))
                .background(Color.gray.opacity(0.1))
                .cornerRadius(10)
        }
    }
}

extension View {
    
    func asyncImage(url: URL?) -> some View {
        EmptyView()
            .modifier(AsyncImageModifier(url: url))
    }
    
}
