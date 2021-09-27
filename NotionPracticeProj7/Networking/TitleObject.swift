//
//  TitleObject.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import Foundation

struct TitleObject: Decodable {

    enum RootKeys: String, CodingKey {
        case plainText = "plain_text"
    }

    let plainText: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        plainText = try container.decode(String.self, forKey: .plainText)
    }
}
