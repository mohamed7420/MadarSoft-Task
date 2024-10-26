//
//  TodoCVCell.swift
//  MadarSoftTask
//
//  Created by Mohamed Osama on 24/10/2024.
//

import UIKit

class TodoCVCell: UICollectionViewCell {
    @IBOutlet weak var checkMarkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priorityView: UIView!
    @IBOutlet weak var containerStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateViews()
        setupPriorityView()
    }

    private func setupPriorityView() {
        guard let randomColor: UIColor = [.orange, .red, .green, .yellow].randomElement() else { return }
        priorityView.backgroundColor = randomColor
        priorityView.layer.cornerRadius = priorityView.frame.height / 2
        priorityView.clipsToBounds = true
    }
    
    private func updateViews() {
        guard let randomColor: UIColor = [.systemBlue, .systemCyan, .systemMint, .systemPink, .systemTeal].randomElement() else { return }

        contentView.layer.cornerRadius = 12
        contentView.clipsToBounds = true
        containerStackView.backgroundColor = randomColor
    }
    
    public func configureCell(_ viewModel: TodoCVCellViewModel) {
        let checkMarkImage = viewModel.isCompleted ? "checkmark.circle.fill" : "checkmark.circle"
        checkMarkImageView.image = UIImage(systemName: checkMarkImage)
        checkMarkImageView.tintColor = viewModel.isCompleted ? .systemGreen : .systemBackground
        
        titleLabel.text = viewModel.title
    }
}
