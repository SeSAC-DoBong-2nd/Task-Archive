//
//  SpendingHistoryView.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/16/25.
//

import SwiftUI

struct Money: Hashable, Identifiable {
    enum Category: String {
        case study = "자기계발"
        case food = "식비"
        case house = "정기지출"
        case hobby = "취미"
        case deposit = "저축"
    }
    
    let id = UUID()
    let amount: Int
    var product: String
    let category: Category
    
    var amountFormat: String {
        return String(amount.formatted()) + "원"
    }
    
    static var mockData: [Self] {
        [
            Money(amount: 21700, product: "스타벅스", category: .food),
            Money(amount: 500000, product: "청년절망적금", category: .deposit),
            Money(amount: 9000, product: "감탄계숯불치킨", category: .food),
            Money(amount: 27000, product: "클린코드", category: .study),
            Money(amount: 150000, product: "스키장", category: .hobby),
            Money(amount: 600000, product: "월세", category: .house),
            Money(amount: 68400, product: "통신비", category: .house),
            Money(amount: 7000, product: "창동짬뽕", category: .food),
            Money(amount: 6500, product: "서브웨이", category: .food),
            Money(amount: 47000, product: "도담솥밥", category: .food),
            Money(amount: 8800, product: "파리바게트", category: .food),
            Money(amount: 100000, product: "주택청약", category: .house),
            Money(amount: 13900, product: "청담동샤브", category: .hobby),
            Money(amount: 1500, product: "스타벅스", category: .food),
            Money(amount: 7800, product: "스타벅스", category: .food),
        ]
    }
}

struct SpendingHistoryView: View {
    
    @State private var dummy = Money.mockData

    var body: some View {
        List {
            ForEach(dummy) { item in
                NavigationLink {
                    HistoryDetailView(item: item)
                } label: {
                    HistoryItemView(item: item)
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("SpendingHistory")
        .navigationBarTitleDisplayMode(.large)
    }
    
}


struct HistoryDetailView: View {
    
    let item: Money

    var body: some View {
        ZStack {
            VStack(spacing: 15) {
                Image(systemName: "star")
                    .font(.system(size: 40, weight: .light))
                    .foregroundStyle(.blue)
                    .padding(.bottom, 10)

                Text(item.product)
                    .font(.title3)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)

                Text(item.category.rawValue)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .padding(.bottom, 10)
                
                 Divider()
                     .frame(width: 100)

                Text(item.amountFormat)
                    .font(.title)
                    .fontWeight(.semibold)
            }
            .padding(30)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 25))
            .frame(maxWidth: 280)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
}


struct HistoryItemView: View {
    
    let item: Money

    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.product)
                    .font(.headline)
                Text(item.category.rawValue)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(item.amountFormat)
                .font(.subheadline)
                .fontWeight(.medium)
        }
        .padding(.vertical, 4)
    }
    
}



#Preview {
    NavigationView {
        SpendingHistoryView()
    }
}
