//
//  Todo.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import Foundation

struct Todo: Codable, Hashable, Identifiable {
    let userId: Int
    let id: Int
    let title: String
    var completed: Bool
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
