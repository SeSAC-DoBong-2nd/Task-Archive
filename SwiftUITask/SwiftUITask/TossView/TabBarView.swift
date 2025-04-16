//
//  TabBarView.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/16/25.
//

import SwiftUI

struct TabBarView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = .black
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    var body: some View {
        TabView {
            Tab("홈", systemImage: "house.fill") {
                SecondView()
            }
            Tab("혜택", systemImage: "diamond.fill") {
                FirstView()
            }
        }
        .background(.black)
        .tint(.white)
    }
    
}


#Preview {
    TabBarView()
}
