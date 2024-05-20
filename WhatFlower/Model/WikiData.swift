//
//  WikiData.swift
//  WhatFlower
//
//  Created by Mayur Vaity on 20/05/24.
//

import Foundation

//Codable protocol combines both encodable and Decodable together
struct WikiData: Codable {
    let query: Query
    
}

struct Query: Codable {
    let pageids: [String]
//    let pages: Pages
}

//struct Pages: Codable {
//    
//}

