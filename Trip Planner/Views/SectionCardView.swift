//
//  SectionCardView.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

final class SectionCardView: UIView {

    private let container = UIView()
    private let titleLabel = UILabel()
    private let descLabel = UILabel()
    private let addButton = UIButton(type: .system)

    private var onAdd: (() -> Void)?

    enum Style { case dark, light, blue }

    init() {
        super.init(frame: .zero)
        setup()
    }

    required init?(coder: NSCoder) { fatalError("Not used") }

    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        container.translatesAutoresizingMaskIntoConstraints = false
        container.layer.cornerRadius = 8
        container.clipsToBounds = true

        titleLabel.font = .systemFont(ofSize: 16, weight: .semibold)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false

        descLabel.font = .systemFont(ofSize: 13)
        descLabel.numberOfLines = 2
        descLabel.translatesAutoresizingMaskIntoConstraints = false

        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.layer.cornerRadius = 8
        addButton.layer.masksToBounds = true
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)

        addSubview(container)
        container.addSubview(titleLabel)
        container.addSubview(descLabel)
        container.addSubview(addButton)

        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: topAnchor),
            container.leadingAnchor.constraint(equalTo: leadingAnchor),
            container.trailingAnchor.constraint(equalTo: trailingAnchor),
            container.bottomAnchor.constraint(equalTo: bottomAnchor),

            titleLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),

            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),

            addButton.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 12),
            addButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            addButton.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -12),
            addButton.heightAnchor.constraint(equalToConstant: 40),
            addButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 120)
        ])

    }

    func configure(title: String, description: String, buttonTitle: String, style: Style, onAdd: @escaping () -> Void) {
        titleLabel.text = title
        descLabel.text = description
        addButton.setTitle(buttonTitle, for: .normal)
        self.onAdd = onAdd

        switch style {
        case .dark:
            container.backgroundColor = UIColor(red: 0.04, green: 0.07, blue: 0.3, alpha: 1)
            titleLabel.textColor = .white
            descLabel.textColor = UIColor(white: 1, alpha: 0.85)
            addButton.backgroundColor = UIColor(red: 0.07, green: 0.38, blue: 0.98, alpha: 1)
            addButton.setTitleColor(.white, for: .normal)
        case .light:
            container.backgroundColor = UIColor(red: 0.95, green: 0.97, blue: 1, alpha: 1)
            titleLabel.textColor = UIColor(red: 0.05, green: 0.1, blue: 0.38, alpha: 1)
            descLabel.textColor = .darkGray
            addButton.backgroundColor = UIColor(red: 0.07, green: 0.38, blue: 0.98, alpha: 1)
            addButton.setTitleColor(.white, for: .normal)
        case .blue:
            container.backgroundColor = UIColor(red: 0.08, green: 0.47, blue: 1.0, alpha: 1)
            titleLabel.textColor = .white
            descLabel.textColor = UIColor(white: 1, alpha: 0.95)
            addButton.backgroundColor = .white
            addButton.setTitleColor(UIColor(red: 0.08, green: 0.47, blue: 1.0, alpha: 1), for: .normal)
        }
    }

    @objc private func addTapped() { onAdd?() }
}
