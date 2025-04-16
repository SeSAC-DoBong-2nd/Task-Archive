//
//  FirstView.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/15/25.
//

import SwiftUI

struct FirstViewData {
    let id = UUID()
    let icon: String
    let title: String
    let subtitle: String
    let noti: String?
    
    init(icon: String, title: String, subtitle: String, noti: String? = nil) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.noti = noti
    }
    
    static var mockData: [Self] {
        [
            FirstViewData(icon: "leaf", title: "오늘의 행운복권", subtitle: "포인트 받기"),
            FirstViewData(icon: "play.circle", title: "라이브 쇼핑", subtitle: "포인트 받기"),
            FirstViewData(icon: "q.circle", title: "청운커즈", subtitle: "추가 혜택 보기"),
            FirstViewData(icon: "heart.circle", title: "이벤트 퀴 마션", subtitle: "열면 받을지 보기"),
            FirstViewData(icon: "paintbrush", title: "두근두근 1등 찍기", subtitle: "포인트 받기", noti: "새로 나온"),
            FirstViewData(icon: "star", title: "임주일 방문 미션", subtitle: "포인트 받기"),
            FirstViewData(icon: "bell", title: "매일 알림", subtitle: "포인트 받기"),
            FirstViewData(icon: "printer", title: "등혹 현금영수증 등록", subtitle: "10원 받기"),
            FirstViewData(icon: "gift", title: "친절충전 이벤트", subtitle: "모아보기")
        ]
    }
}


struct FirstView: View {
    
    private let listDummy = FirstViewData.mockData
    
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: "star")
                            .clipShape(.circle)
                        VStack(alignment: .leading) {
                            Text("[70,000원] 가입 지원금")
                            Text("빗썸 가입하고 미수령 지원금 받기 · AD")
                                .font(.callout)
                                .foregroundStyle(.gray)
                        }
                    }
                    .foregroundStyle(.white)
                    .listRowBackground(Color.navy)
                }
                .listSectionSpacing(10)
                
                Section {
                    ForEach(listDummy, id: \.id) { item in
                        FirstViewCell(listData: item, isBlue: true)
                            .listRowBackground(Color.navy)
                    }
                }
                
            }
            .listStyle(.insetGrouped)
            .scrollContentBackground(.hidden)
            .background(.black)
            .padding(-10)
        }
    }
    
}


struct FirstViewCell: View {
    
    let listData: FirstViewData
    let isBlue: Bool
    
    var body: some View {
        HStack {
            Image(systemName: listData.icon)
                .resizable()
                .frame(width: 30, height: 30, alignment: .leading)
                .foregroundStyle(.white)
                .padding(2)
            
            VStack(alignment: .leading) {
                Text(listData.title)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.bottom, 2)
                Text(listData.subtitle)
                    .font(.callout)
                    .foregroundStyle(.blue)
            }
            
            Spacer()
            
            if let noti = listData.noti {
                Text(noti)
                    .padding(4)
                    .background(.gray)
                    .font(.caption2)
                    .clipShape(.capsule)
                    .padding(.trailing, 10)
            }
        }
    }
    
}



#Preview {
    FirstView()
}
