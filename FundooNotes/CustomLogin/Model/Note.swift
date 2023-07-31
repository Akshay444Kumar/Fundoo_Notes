//
//  Note.swift
//  CustomLogin
//
//  Created by YE002 on 10/07/23.
//

import Foundation

struct Note: Codable {
            
    var uId: String?
    var title: String?
    var description: String?
    var isDeleted: Bool = false
    var hasReminder: Bool = false
}
