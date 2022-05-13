//
//  JsonFailure.swift
//  PSDirectSender
//
//  Created by Macintosh on 02.05.2022.
//

import Foundation

struct SendFailure: Codable {
    let status, error: String
}
