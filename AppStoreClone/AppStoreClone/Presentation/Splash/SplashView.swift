//
//  SplashView.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import SwiftUI

struct SplashView: View {
    
    var body: some View {
        ZStack {
            Color(uiColor: .systemGray6)
                .ignoresSafeArea()
            Text("박신영_AppStoreClone")
                .frame(width: 200)
        }
    }
    
}
