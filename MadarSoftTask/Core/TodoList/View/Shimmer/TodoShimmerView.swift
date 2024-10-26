//
//  TodoShimmerView.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import Foundation
import UIKit

class TodoShimmerView: UIView {
    lazy var shimmeringView: FBShimmeringView = {
        let view = FBShimmeringView(frame: self.bounds)
        view.isShimmering = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        addSubview(shimmeringView)
        shimmeringView.contentView = subviews.first
        NSLayoutConstraint.activate([
            shimmeringView.topAnchor.constraint(equalTo: topAnchor),
            shimmeringView.leadingAnchor.constraint(equalTo: leadingAnchor),
            shimmeringView.trailingAnchor.constraint(equalTo: trailingAnchor),
            shimmeringView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
