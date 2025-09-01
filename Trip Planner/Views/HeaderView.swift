//
//  HeaderView.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

final class HeaderView: UIView {

    private let heroImageView = UIImageView()
    private let datesLabel = UILabel()
    private let titleLabel = UILabel()
    private let locationLabel = UILabel()
    private let collabButton = UIButton(type: .system)
    private let shareButton = UIButton(type: .system)

    var onCollab: (() -> Void)?
    var onShare: (() -> Void)?

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("Not used") }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false

        heroImageView.translatesAutoresizingMaskIntoConstraints = false
        heroImageView.contentMode = .scaleAspectFill
        heroImageView.clipsToBounds = true
        heroImageView.backgroundColor = UIColor(red: 0.93, green: 0.98, blue: 0.99, alpha: 1)

        datesLabel.font = .systemFont(ofSize: 12)
        datesLabel.textColor = .darkGray
        datesLabel.translatesAutoresizingMaskIntoConstraints = false

        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        locationLabel.font = .systemFont(ofSize: 13)
        locationLabel.textColor = .darkGray
        locationLabel.translatesAutoresizingMaskIntoConstraints = false

        collabButton.translatesAutoresizingMaskIntoConstraints = false
        collabButton.setTitle("Trip Collaboration", for: .normal)
        collabButton.layer.cornerRadius = 8
        collabButton.layer.borderWidth = 1
        collabButton.layer.borderColor = UIColor.systemBlue.cgColor
        collabButton.addTarget(self, action: #selector(collabTapped), for: .touchUpInside)

        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.setTitle("Share Trip", for: .normal)
        shareButton.layer.cornerRadius = 8
        shareButton.layer.borderWidth = 1
        shareButton.layer.borderColor = UIColor.systemBlue.cgColor
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)

        addSubview(heroImageView)
        addSubview(datesLabel)
        addSubview(titleLabel)
        addSubview(locationLabel)
        addSubview(collabButton)
        addSubview(shareButton)

        NSLayoutConstraint.activate([
            heroImageView.topAnchor.constraint(equalTo: topAnchor),
            heroImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            heroImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            heroImageView.heightAnchor.constraint(equalToConstant: 160),

            datesLabel.topAnchor.constraint(equalTo: heroImageView.bottomAnchor, constant: 8),
            datesLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            datesLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            titleLabel.topAnchor.constraint(equalTo: datesLabel.bottomAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: datesLabel.leadingAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            locationLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            locationLabel.leadingAnchor.constraint(equalTo: datesLabel.leadingAnchor),
            locationLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16),

            collabButton.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 12),
            collabButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            collabButton.heightAnchor.constraint(equalToConstant: 38),
            collabButton.widthAnchor.constraint(equalToConstant: 150),

            shareButton.topAnchor.constraint(equalTo: collabButton.topAnchor),
            shareButton.leadingAnchor.constraint(equalTo: collabButton.trailingAnchor, constant: 12),
            shareButton.heightAnchor.constraint(equalTo: collabButton.heightAnchor),
            shareButton.widthAnchor.constraint(equalToConstant: 110),

            shareButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }

    func configure(with trip: Trip) {
        datesLabel.text = "\(trip.startDate ?? "")  →  \(trip.endDate ?? "")"
        titleLabel.text = trip.title
        locationLabel.text = trip.location
        if let url = trip.image {
            ImageLoader.shared.load(url) { [weak self] img in
                self?.heroImageView.image = img
            }
        }
    }

    @objc private func collabTapped() { onCollab?() }
    @objc private func shareTapped() { onShare?() }
}
