//
//  SearchCell.swift
//  NotionPracticeProj7
//
//  Created by Valerie Don on 9/26/21.
//

import UIKit

final class SearchCell: UICollectionViewCell {

    lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var subtitleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.textColor = .gray
        label.textAlignment = .left
        label.text = "Subtitle"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    var model: NotionObject? {
        didSet {
            guard let object = model else {
                titleLabel.text = nil
                subtitleLabel.text = nil
                return
            }
            update(with: object)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .white
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        //temporary solution is constraints, but is not optimal for collections
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 2),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8)
        ])
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        //do it by frame based layout and not constraint
    }

    // MARK: - Update

    func update(with object: NotionObject) {
        switch object {
        case .page(let pageObject):
            titleLabel.text = pageObject.title
            subtitleLabel.text = "page"
        default:
            titleLabel.text = "Unknown"
            subtitleLabel.text = nil
        }
    }
}
