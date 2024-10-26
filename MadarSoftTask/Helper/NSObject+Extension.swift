//
//  NSObject+Extension.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 25/10/2024.
//

import Foundation

public extension NSObject {
    var className: String {
        String(describing: type(of: self))
    }
    
    class var className: String {
        String(describing: self)
    }
}
