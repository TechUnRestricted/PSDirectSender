//
//  JsonSend.swift
//  PSDirectSender
//
//  Created by Macintosh on 23.04.2022.
//

import Foundation

struct PackageSenderData: Codable {
    let type: String
    let packages: [String]
}
