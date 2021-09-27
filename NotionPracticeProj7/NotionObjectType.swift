//
//  NotionObjectType.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import Foundation

enum NotionObjectKeys: String, CodingKey {
    case object
    case id
    case createdTime = "created_time"
    case lastEditedTime = "last_edited_time"
    case properties
}

protocol IsNotionObject: Decodable {
    var object: NotionObjectType { get }
    var id: String { get }
    var createdTime: String { get }
    var lastEditedTime: String { get }
}

enum NotionObjectType: String, Codable {
    case list
    case database
    case user
    case page
    case block
    case unknown
}

enum NotionObject: Decodable {
    case page(PageObject)
    case unknown

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NotionObjectKeys.self)
        let object = try container.decode(NotionObjectType.self, forKey: .object)

        switch object {
        case .page:
            let pageObject = try PageObject(from: decoder)
            self = .page(pageObject)
        default:
            self = .unknown
        }
    }
}
