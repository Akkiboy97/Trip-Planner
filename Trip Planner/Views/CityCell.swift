//
//  CountryPicker.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

class CityCell: UITableViewCell {
    static let identifier = "CityCell"

    private let pinIcon: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "mappin.and.ellipse"))
        iv.tintColor = .systemGray
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()

    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    private let flagImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        titleLabel.font = .boldSystemFont(ofSize: 16)
        subtitleLabel.font = .systemFont(ofSize: 14)
        subtitleLabel.textColor = .darkGray

        flagImageView.translatesAutoresizingMaskIntoConstraints = false
        flagImageView.contentMode = .scaleAspectFit
        flagImageView.clipsToBounds = true
        flagImageView.layer.cornerRadius = 4

        let textStack = UIStackView(arrangedSubviews: [titleLabel, subtitleLabel])
        textStack.axis = .vertical
        textStack.spacing = 2
        textStack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(pinIcon)
        contentView.addSubview(textStack)
        contentView.addSubview(flagImageView)

        NSLayoutConstraint.activate([
            pinIcon.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            pinIcon.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            pinIcon.widthAnchor.constraint(equalToConstant: 20),
            pinIcon.heightAnchor.constraint(equalToConstant: 20),

            textStack.leadingAnchor.constraint(equalTo: pinIcon.trailingAnchor, constant: 8),
            textStack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            textStack.trailingAnchor.constraint(lessThanOrEqualTo: flagImageView.leadingAnchor, constant: -8),

            flagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            flagImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            flagImageView.widthAnchor.constraint(equalToConstant: 40),
            flagImageView.heightAnchor.constraint(equalToConstant: 28)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with city: Country) {
        titleLabel.text = "\(city.cityName), \(city.countryName)"
        subtitleLabel.text = city.cityName

        if let url = URL(string: city.flagURL) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.flagImageView.image = image
                    }
                }
            }.resume()
        } else {
            flagImageView.image = nil
        }
    }
}
