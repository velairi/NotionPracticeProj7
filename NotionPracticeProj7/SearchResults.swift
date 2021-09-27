//
//  SearchResults.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import Foundation

struct SearchResults: Decodable {
    let object: NotionObjectType
    let results: [NotionObject]
}
