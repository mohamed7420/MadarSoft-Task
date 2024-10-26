//
//  UIView+Extension.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 23/10/2024.
//

import Foundation
import UIKit

extension UIView {
    static func loadFromXib() -> Self {
        func instantiateView<T: UIView>() -> T {
            UINib(nibName: "\(Self.self)", bundle: nil).instantiate(withOwner: nil, options: nil).first as! T
        }
        return instantiateView()
    }
}
