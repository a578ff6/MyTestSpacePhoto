//
//  PhotoInfo.swift
//  MyTestSpacePhoto
//
//  Created by 曹家瑋 on 2023/10/31.
//

import Foundation

// 解析API回傳的資料。
struct PhotoInfo: Codable {
    var title: String
    var description: String
    var url: URL
    var copyright: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case description = "explanation"
        case url
        case copyright
    }
}

