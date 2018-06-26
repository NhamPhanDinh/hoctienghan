//
//  Phrase.swift
//  korealearning
//
//  Created by Hien Nguyen on 6/24/18.
//  Copyright © 2018 Hien Nguyen. All rights reserved.
//

import Foundation

class Phrase: Codable {
    var _id: Int = 0
    var category_id: Int = 0
    var english: String = ""
    var pinyin: String = ""
    var korean: String = ""
    var favorite: Int?
    var voice: String = ""
    var status: Int = 0
    var vietnamese: String = ""
    var chinese: String = ""

    var title: String {
        return english
    }
}
