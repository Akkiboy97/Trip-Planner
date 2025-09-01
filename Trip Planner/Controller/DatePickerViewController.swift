//
//  DatePickerViewController.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

protocol DateRangePickerDelegate: AnyObject {
    func didSelectDateRange(start: Date, end: Date)
}

class DateRangePickerViewController: UIViewController {
    weak var delegate: DateRangePickerDelegate?

    private let startPicker = UIDatePicker()
    private let endPicker = UIDatePicker()
    private let chooseButton = UIButton(type: .system)
    private let cancelButton = UIButton(type: .system)

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Select Dates"

        startPicker.datePickerMode = .date
        startPicker.minimumDate = Date()

        endPicker.datePickerMode = .date
        endPicker.minimumDate = startPicker.date

        startPicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)

        chooseButton.setTitle("Choose Date", for: .normal)
        chooseButton.backgroundColor = .systemBlue
        chooseButton.tintColor = .white
        chooseButton.layer.cornerRadius = 8
        chooseButton.addTarget(self, action: #selector(didTapChoose), for: .touchUpInside)

        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.backgroundColor = .systemGray
        cancelButton.tintColor = .white
        cancelButton.layer.cornerRadius = 8
        cancelButton.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)

        let stack = UIStackView(arrangedSubviews: [startPicker, endPicker, chooseButton, cancelButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            chooseButton.heightAnchor.constraint(equalToConstant: 50),
            cancelButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func startDateChanged() {
        endPicker.minimumDate = startPicker.date
        if endPicker.date < startPicker.date {
            endPicker.date = startPicker.date
        }
    }

    @objc private func didTapChoose() {
        delegate?.didSelectDateRange(start: startPicker.date, end: endPicker.date)
        dismiss(animated: true)
    }

    @objc private func didTapCancel() {
        dismiss(animated: true)
    }
}
