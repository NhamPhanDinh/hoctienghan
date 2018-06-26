//
//  Category.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/24/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import Foundation

class Category: Codable {
    var _id: Int = 0
    var english: String = ""
    var vietnamese: String = ""
    var chinese: String = ""
    var title: String {
        return english
    }

    var icon: String {
        return Category.iconList[_id] ?? ""
    }

    fileprivate static let iconList: [Int: String] = [
        0: "favorite",
        1: "greeting",
        2: "general",
        3: "number",
        4: "time",
        5: "directions",
        6: "transportation",
        7: "accommodation",
        8: "eat",
        9: "shopping",
        10: "color",
        11: "town",
        12: "country",
        13: "tourist",
        14: "family",
        15: "dating",
        16: "emergency",
        17: "feelingsick",
        18: "language",
        19: "rating",
        20: "email_icon",
        21: "store",
        22: "about"
    ]
}
