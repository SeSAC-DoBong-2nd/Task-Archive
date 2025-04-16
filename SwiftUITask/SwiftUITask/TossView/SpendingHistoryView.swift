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
        VStack {
            List {
                ForEach(dummy, id: \.id) { item in
                    NavigationLink {
                        WalletItemDetailView(item: item)
                            .padding(.horizontal, 40)
                            .padding(.vertical, 200)
                    } label: {
                        WalletItem(item: item)
                    }
                }
            }
        }
        .navigationTitle("Sean's Wallet")
        .navigationBarTitleDisplayMode(.large)
    }
}

struct WalletItemDetailView: View {
    let item: Money
    var body: some View {
        VStack(alignment: .trailing) {
            HStack(alignment: .bottom) {
                Text(item.product)
                    .font(.title)
                    .bold()
                Spacer()
                Text("\(item.category)")
                    .foregroundStyle(.gray)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal)
            
            Divider()
                .background(Color(uiColor: .label))
                .frame(maxWidth: .infinity)
                .padding(.vertical, -10)
            
            Spacer()
            Text(item.amountFormat)
                .foregroundStyle(Color(uiColor: .label))
                .padding()
            
        }
        .frame(maxHeight: .infinity)
        .padding()
        .overlay {
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color(uiColor: .label), lineWidth: 2)
        }
    }
}

struct WalletItem: View {
    let item: Money
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(item.product)
                    .font(.headline)
                Text("\(item.category)")
                    .font(.callout)
                    .foregroundStyle(.gray)
            }
            Spacer()
            Text(item.amountFormat)
        }
        .listRowSeparator(.hidden)
    }
    
    init(item: Money) {
        self.item = item
    }
}

#Preview {
    NavigationView {
        SpendingHistoryView()
    }
}
