//
//  Chore.swift
//  HomeTracker
//
//  Created on 5/8/25.
//

import Foundation

struct Chore: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var title: String
    var isCompleted: Bool = false
    var createdDate: Date = Date()
    
    static func ==(lhs: Chore, rhs: Chore) -> Bool {
        lhs.id == rhs.id
    }
}
