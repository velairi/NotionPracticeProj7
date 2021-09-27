//
//  PageObject.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import Foundation

struct PageObject: IsNotionObject {

    enum PropertiesKeys: String, CodingKey {
        case title
    }

    enum TitleKeys: String, CodingKey {
        case title
    }

    let object: NotionObjectType
    let id: String
    let createdTime: String
    let lastEditedTime: String
    let title: String

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: NotionObjectKeys.self)
        id = try container.decode(String.self, forKey: .id)
        object = try container.decode(NotionObjectType.self, forKey: .object)
        createdTime = try container.decode(String.self, forKey: .createdTime)
        lastEditedTime = try container.decode(String.self, forKey: .lastEditedTime)

        let propertiesContainer = try container.nestedContainer(keyedBy: PropertiesKeys.self, forKey: .properties)
        let titleContainer = try propertiesContainer.nestedContainer(keyedBy: TitleKeys.self, forKey: .title)
        let titles = try titleContainer.decodeIfPresent([TitleObject].self, forKey: .title)
        title = titles?.first?.plainText ?? ""
    }
}
