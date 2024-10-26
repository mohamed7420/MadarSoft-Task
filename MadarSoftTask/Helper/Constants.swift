//
//  Constants.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import Foundation

struct Constants {
    static let title = "Madar Soft Todo List"
    
    static var apiURL: String {
        guard let url = Bundle.main.object(forInfoDictionaryKey: "API_URL") as? String else {
            print("API URL not found in configuration.")
            return ""
        }
        return url.replacingOccurrences(of: "\\/", with: "/")
    }
}
