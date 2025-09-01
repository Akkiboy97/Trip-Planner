//
//  ItemCell.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

final class ItemCell: UITableViewCell {
    static let reuse = "ItemCell"

    private let cardView = UIView()
    private let thumb = UIImageView()
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let priceLabel = UILabel()
    private let removeButton = UIButton(type: .system)

    private var removeAction: (() -> Void)?

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        setup()
    }

    required init?(coder: NSCoder) { fatalError("Not used") }

    private func setup() {
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.cornerRadius = 10
        cardView.backgroundColor = UIColor(white: 0.98, alpha: 1)
        contentView.addSubview(cardView)

        thumb.translatesAutoresizingMaskIntoConstraints = false
        thumb.contentMode = .scaleAspectFill
        thumb.clipsToBounds = true
        thumb.layer.cornerRadius = 8

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)

        subtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .darkGray
        subtitleLabel.numberOfLines = 2

        priceLabel.translatesAutoresizingMaskIntoConstraints = false
        priceLabel.font = .systemFont(ofSize: 14)

        removeButton.translatesAutoresizingMaskIntoConstraints = false
        removeButton.setTitle("Remove", for: .normal)
        removeButton.setTitleColor(.systemRed, for: .normal)
        removeButton.addTarget(self, action: #selector(removeTapped), for: .touchUpInside)

        cardView.addSubview(thumb)
        cardView.addSubview(titleLabel)
        cardView.addSubview(subtitleLabel)
        cardView.addSubview(priceLabel)
        cardView.addSubview(removeButton)

        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cardView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),

            thumb.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            thumb.centerYAnchor.constraint(equalTo: cardView.centerYAnchor),
            thumb.widthAnchor.constraint(equalToConstant: 84),
            thumb.heightAnchor.constraint(equalToConstant: 84),

            titleLabel.topAnchor.constraint(equalTo: thumb.topAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: thumb.trailingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: removeButton.leadingAnchor, constant: -8),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            subtitleLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            subtitleLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),

            priceLabel.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 8),
            priceLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),

            removeButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -12),
            removeButton.centerYAnchor.constraint(equalTo: cardView.centerYAnchor)
        ])
    }

    func configure(with item: TripElement, onRemove: @escaping () -> Void) {
        titleLabel.text = item.title
        subtitleLabel.text = item.subtitle
        priceLabel.text = item.price
        removeAction = onRemove

        let placeholder: UIImage?
        switch item.type {
        case .flight: placeholder = UIImage(systemName: "airplane")
        case .hotel: placeholder = UIImage(systemName: "building.2")
        case .activity: placeholder = UIImage(systemName: "figure.walk")
        }

        thumb.image = placeholder
        if let url = item.imageURL {
            ImageLoader.shared.load(url) { [weak self] img in
                if let img = img { self?.thumb.image = img }
            }
        }
    }

    @objc private func removeTapped() { removeAction?() }
}
