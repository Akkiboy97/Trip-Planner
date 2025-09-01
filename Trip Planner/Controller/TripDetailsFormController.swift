//
//  TripDetailsDelegate.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//


import UIKit

protocol TripDetailsDelegate: AnyObject {
    func didEnterTripDetails(name: String, style: String, description: String)
}

class TripDetailsFormController: UIViewController {
    weak var delegate: TripDetailsDelegate?
    
    var trip: Trip?
    
    private let tripNameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter the trip name"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let travelStyleField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select your travel style"
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let descriptionView: UITextView = {
        let tv = UITextView()
        tv.layer.borderColor = UIColor.lightGray.cgColor
        tv.layer.borderWidth = 1
        tv.layer.cornerRadius = 6
        tv.font = .systemFont(ofSize: 14)
        tv.text = "Tell us more about the trip"
        tv.textColor = .lightGray
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    
    private let nextButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Next", for: .normal)
        b.backgroundColor = .systemBlue
        b.tintColor = .white
        b.layer.cornerRadius = 8
        b.isEnabled = false
        b.alpha = 0.5
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    private let styles = ["Solo", "Couple", "Family", "Group"]
    private var stylePicker = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupLayout()
        updateFields()
        setupPicker()
        
        nextButton.addTarget(self, action: #selector(didTapNext), for: .touchUpInside)
        tripNameField.addTarget(self, action: #selector(textChanged), for: .editingChanged)
        descriptionView.delegate = self
    }
    
    private func updateFields() {
        if let trip = self.trip {
            tripNameField.text = trip.title
            descriptionView.text = trip.description
            travelStyleField.text = trip.tripType
        } else {
            print(trip?.startDate ?? "")
            print(trip?.location ?? "")
        }
    }
    
    private func setupLayout() {
        view.addSubview(tripNameField)
        view.addSubview(travelStyleField)
        view.addSubview(descriptionView)
        view.addSubview(nextButton)
        
        NSLayoutConstraint.activate([
            tripNameField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            tripNameField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            tripNameField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            tripNameField.heightAnchor.constraint(equalToConstant: 44),
            
            travelStyleField.topAnchor.constraint(equalTo: tripNameField.bottomAnchor, constant: 16),
            travelStyleField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            travelStyleField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            travelStyleField.heightAnchor.constraint(equalToConstant: 44),
            
            descriptionView.topAnchor.constraint(equalTo: travelStyleField.bottomAnchor, constant: 16),
            descriptionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionView.heightAnchor.constraint(equalToConstant: 120),
            
            nextButton.topAnchor.constraint(equalTo: descriptionView.bottomAnchor, constant: 20),
            nextButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nextButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            nextButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func setupPicker() {
        stylePicker.delegate = self
        stylePicker.dataSource = self
        travelStyleField.inputView = stylePicker
    }
    
    @objc private func textChanged() {
        validateForm()
    }
    
    private func validateForm() {
        let valid = !(tripNameField.text?.isEmpty ?? true) &&
                    !(travelStyleField.text?.isEmpty ?? true) &&
                    !(descriptionView.text.isEmpty || descriptionView.text == "Tell us more about the trip")
        nextButton.isEnabled = valid
        nextButton.alpha = valid ? 1.0 : 0.5
    }
    
    @objc private func didTapNext() {
        delegate?.didEnterTripDetails(
            name: tripNameField.text ?? "",
            style: travelStyleField.text ?? "",
            description: descriptionView.text ?? ""
        )
        dismiss(animated: true)
    }
}

extension TripDetailsFormController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { styles.count }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { styles[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        travelStyleField.text = styles[row]
        validateForm()
    }
}

extension TripDetailsFormController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == "Tell us more about the trip" {
            textView.text = ""
            textView.textColor = .black
        }
        
    }
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        validateForm()
        return true
    }
    
    func textViewDidChange(_ textView: UITextView) {
        validateForm()
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Tell us more about the trip"
            textView.textColor = .lightGray
        }
        validateForm()
    }
}
