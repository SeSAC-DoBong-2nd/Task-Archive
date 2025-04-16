//
//  SecondView.swift
//  SwiftUITask
//
//  Created by 박신영 on 4/16/25.
//

import SwiftUI

struct SecondView: View {
    
    let backgroundColor = Color(red: 18/255, green: 18/255, blue: 18/255)
    let componentBackgroundColor = Color(red: 44/255, green: 44/255, blue: 46/255)
    let secondaryComponentBackground = Color(red: 28/255, green: 28/255, blue: 30/255)
    let primaryTextColor = Color.white
    let secondaryTextColor = Color.gray
    let accentRed = Color.red
    let accentBlue = Color.blue
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    TopMenuButtons(backgroundColor: componentBackgroundColor, textColor: primaryTextColor)
                    
                    MarketIndices(
                        backgroundColor: backgroundColor,
                        textColor: primaryTextColor,
                        secondaryTextColor: secondaryTextColor,
                        accentRed: accentRed,
                        accentBlue: accentBlue
                    )
                    
                    FeatureCards(
                        backgroundColor: secondaryComponentBackground,
                        textColor: primaryTextColor
                    )
                    
                    ActionList(
                        backgroundColor: componentBackgroundColor,
                        textColor: primaryTextColor,
                        iconColor: secondaryTextColor
                    )
                    
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.top)
            }
            .background(backgroundColor.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
        }
    }
    
}


struct TopMenuButtons: View {
    
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 10) {
            TopMenuButton(iconName: "creditcard.fill", text: "국내주식", backgroundColor: backgroundColor, textColor: textColor)
            TopMenuButton(iconName: "dollarsign.circle.fill", text: "해외주식", backgroundColor: backgroundColor, textColor: textColor)
            TopMenuButton(iconName: "chart.bar.doc.horizontal.fill", text: "채권", backgroundColor: backgroundColor, textColor: textColor)
            TopMenuButton(iconName: "arrow.up.arrow.down.circle.fill", text: "ETF", backgroundColor: backgroundColor, textColor: textColor)
        }
    }
    
}


struct TopMenuButton: View {
    
    let iconName: String
    let text: String
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: iconName)
                .font(.title3)
                .foregroundColor(textColor.opacity(0.8))
            Text(text)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(textColor)
        }
        .frame(maxWidth: .infinity)
        .frame(height: 80)
        .background(backgroundColor)
        .cornerRadius(15)
    }
    
}


struct MarketIndices: View {
    
    let backgroundColor: Color
    let textColor: Color
    let secondaryTextColor: Color
    let accentRed: Color
    let accentBlue: Color
    
    var body: some View {
        ScrollView(.horizontal) {
            HStack {
                MarketIndexView(
                    name: "코스피",
                    value: "2,432.72",
                    change: "-0.5%",
                    changeColor: accentRed,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor
                )
                Divider().background(Color.gray).frame(height: 40)
                MarketIndexView(
                    name: "코스닥",
                    value: "695.59",
                    change: "+2.0%",
                    changeColor: accentBlue,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor
                )
                Divider().background(Color.gray).frame(height: 40)
                MarketIndexView(
                    name: "나스닥",
                    value: "16,724.46",
                    change: "+2.0%",
                    changeColor: accentBlue,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor
                )
                Divider().background(Color.gray).frame(height: 40)
                MarketIndexView(
                    name: "나스닥",
                    value: "16,724.46",
                    change: "+2.0%",
                    changeColor: accentBlue,
                    textColor: textColor,
                    secondaryTextColor: secondaryTextColor
                )
            }
            .padding(.vertical, 5)
        }
    }
    
}


struct MarketIndexView: View {
    
    let name: String
    let value: String
    let change: String
    let changeColor: Color
    let textColor: Color
    let secondaryTextColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.caption)
                .foregroundColor(secondaryTextColor)
            Text(value)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(textColor)
            Text(change)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(changeColor)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 5)
    }
    
}


struct FeatureCards: View {
    
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            FeatureCard(
                title: "숨은 환급액\n찾기",
                iconName: "dollarsign.circle",
                backgroundColor: backgroundColor,
                textColor: textColor
            )
            FeatureCard(
                title: "혜택 받는\n신용카드",
                iconName: "creditcard",
                backgroundColor: backgroundColor,
                textColor: textColor
            )
        }
    }
    
}


struct FeatureCard: View {
    
    let title: String
    let iconName: String
    let backgroundColor: Color
    let textColor: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(textColor)
                    .lineSpacing(4)
                Spacer()
            }
            Spacer()
            Image(systemName: iconName)
                .font(.largeTitle)
                .foregroundColor(textColor.opacity(0.7))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 120)
        .background(backgroundColor)
        .cornerRadius(15)
    }
    
}


struct ActionList: View {
    
    let backgroundColor: Color
    let textColor: Color
    let iconColor: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            ListItemView(iconName: "doc.plaintext", text: "내 현금영수증", iconColor: iconColor, textColor: textColor)
            Divider().background(Color.gray.opacity(0.3)).padding(.leading, 45)
            ListItemView(iconName: "person.crop.circle.badge.questionmark", text: "내 보험료 점검하기", iconColor: iconColor, textColor: textColor)
            Divider().background(Color.gray.opacity(0.3)).padding(.leading, 45)
            ListItemView(iconName: "star", text: "더 낸 연말정산 돌려받기", iconColor: iconColor, textColor: textColor)
        }
        .padding(.vertical, 10)
        .background(backgroundColor)
        .cornerRadius(15)
    }
    
}


struct ListItemView: View {
    
    let iconName: String
    let text: String
    let iconColor: Color
    let textColor: Color
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: iconName)
                .font(.headline)
                .foregroundColor(iconColor)
                .frame(width: 25, alignment: .center)
            
            Text(text)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(textColor)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.gray)
        }
        .padding(.horizontal)
        .padding(.vertical, 15)
    }
    
}


#Preview {
    SecondView()
}
