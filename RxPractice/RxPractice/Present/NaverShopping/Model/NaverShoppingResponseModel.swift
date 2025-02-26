//
//  NaverShoppingResponseModel.swift
//  DailyTask_week4
//
//  Created by 박신영 on 1/15/25.
//

import Foundation

struct NaverShoppingResponseModel: Decodable {
    let total: Int
    let items: [Items]
}

struct Items: Decodable {
    let image: String
    let mallName: String
    let title: String
    let lprice: String
}

