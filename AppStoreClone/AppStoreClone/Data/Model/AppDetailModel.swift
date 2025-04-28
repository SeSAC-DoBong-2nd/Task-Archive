//
//  AppDetailModel.swift
//  AppStoreClone
//
//  Created by 박신영 on 4/28/25.
//

import Foundation

struct AppDetailModel {
    let trackId: Int
    let trackName: String
    let description: String
    let artworkUrl512: URL
    let version: String
    let releaseNotes: String?
    let screenshotUrls: [URL]
    let averageUserRating: Double?
    let userRatingCount: Int?
    let currentVersionDate: String?
    let metaData: [MetadataItem]
}
