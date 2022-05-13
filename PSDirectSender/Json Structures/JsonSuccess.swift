//
//  JsonSuccess.swift
//  PSDirectSender
//
//  Created by Macintosh on 02.05.2022.
//

import Foundation

struct SendSuccess: Codable {
    let status: String
    let taskID: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case status
        case taskID = "task_id"
        case title
    }
}
