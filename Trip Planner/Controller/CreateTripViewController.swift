//
//  CreateTripViewController.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

class CreateTripViewController: UIViewController {
    private let api: APIClient
    var onCreateSuccess: ((Trip) -> Void)?
    
    var trip: Trip?
    
    var tripListViewControllerDelegate: TripListViewControllerDelegate?
    
    init(apiClient: APIClient) {
        self.api = apiClient
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    // MARK: - UI
    private let bgImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "bg_image"))
        iv.contentMode = .scaleAspectFill
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.text = "Plan Your Dream Trip in Minutes"
        l.font = .systemFont(ofSize: 20, weight: .semibold)
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let subtitleLabel: UILabel = {
        let l = UILabel()
        l.text = "Build, personalize, and optimize your itineraries with our trip planner. Perfect for getaways, remote workcations, and any spontaneous escapade."
        l.font = .systemFont(ofSize: 14)
        l.textColor = .darkGray
        l.numberOfLines = 0
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let cardView: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.layer.cornerRadius = 12
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowOpacity = 0.1
        v.layer.shadowOffset = CGSize(width: 0, height: 2)
        v.layer.shadowRadius = 4
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let locationField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Select City"
        tf.font = .systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let startDateField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Start Date"
        tf.font = .systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let endDateField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "End Date"
        tf.font = .systemFont(ofSize: 14)
        tf.borderStyle = .roundedRect
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    private let createButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Create a Trip", for: .normal)
        b.backgroundColor = UIColor.systemBlue
        b.tintColor = .white
        b.layer.cornerRadius = 8
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupLayout()
        
        createButton.addTarget(self, action: #selector(didTapCreate), for: .touchUpInside)
        locationField.addTarget(self, action: #selector(openCityPicker), for: .editingDidBegin)
        
        startDateField.addTarget(self, action: #selector(openDateRangePicker), for: .editingDidBegin)
        endDateField.addTarget(self, action: #selector(openDateRangePicker), for: .editingDidBegin)
        valideButton()
    }
    
    private func valideButton() {
        createButton.isEnabled = !locationField.text!.isEmpty && !startDateField.text!.isEmpty && !endDateField.text!.isEmpty
    }
    
    private func setupLayout() {
        view.addSubview(bgImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(cardView)
        
        cardView.addSubview(locationField)
        cardView.addSubview(startDateField)
        cardView.addSubview(endDateField)
        cardView.addSubview(createButton)
        
        NSLayoutConstraint.activate([
            bgImageView.topAnchor.constraint(equalTo: view.topAnchor),
            bgImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            bgImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            bgImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            cardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -32),
            cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            locationField.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 16),
            locationField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            locationField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            locationField.heightAnchor.constraint(equalToConstant: 44),
            
            startDateField.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: 12),
            startDateField.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            startDateField.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.45),
            startDateField.heightAnchor.constraint(equalToConstant: 44),
            
            endDateField.topAnchor.constraint(equalTo: locationField.bottomAnchor, constant: 12),
            endDateField.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            endDateField.widthAnchor.constraint(equalTo: cardView.widthAnchor, multiplier: 0.45),
            endDateField.heightAnchor.constraint(equalToConstant: 44),
            
            createButton.topAnchor.constraint(equalTo: startDateField.bottomAnchor, constant: 16),
            createButton.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 16),
            createButton.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: -16),
            createButton.heightAnchor.constraint(equalToConstant: 50),
            createButton.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -16)
        ])
    }
    
    func showLoading(_ show: Bool) {
        if show {
            let av = UIActivityIndicatorView(style: .large)
            av.startAnimating()
            av.tag = 999
            av.center = view.center
            view.addSubview(av)
        } else {
            view.viewWithTag(999)?.removeFromSuperview()
        }
    }
    
    func create(_ trip: Trip, completion: @escaping (Bool) -> Void) {
        showLoading(true)
        api.createTrip(trip) { [weak self] result,msg  in
            DispatchQueue.main.async {
                self?.showLoading(false)
                switch result {
                case .success(let trips):
                    completion(true)
                    let popup = PopupViewController(
                        message: msg,
                        systemImageName: "checkmark.circle.fill"
                    )
                    self?.present(popup, animated: true)
                case .failure:
                    completion(false)
                    let popup = PopupViewController(
                        message: msg,
                        systemImageName: "xmark.octagon.fill"
                    )
                    self?.present(popup, animated: true)
                }
            }
        }
    }
    
    @objc private func openDateRangePicker() {
        view.endEditing(true)
        let picker = DateRangePickerViewController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func openCityPicker() {
        locationField.resignFirstResponder()
        let picker = CityPickerViewController()
        picker.delegate = self
        present(picker, animated: true)
    }
    
    @objc private func didTapCreate() {
        let trip = Trip()
        trip.location = locationField.text ?? ""
        trip.startDate = (startDateField.text ?? "")
//        trip.endDate = (endDateField.text ?? "")
        trip.title = self.trip?.title ?? ""
        trip.description = self.trip?.description ?? ""
        trip.tripType = self.trip?.tripType ?? ""
        self.trip = trip
        
        print(self.trip?.startDate ?? "")
        print(self.trip?.location ?? "")
        let detailsVC = TripDetailsFormController()
        detailsVC.delegate = self
        detailsVC.trip = self.trip
        detailsVC.modalPresentationStyle = .popover
        present(detailsVC, animated: true)
    }
}

extension CreateTripViewController: CityPickerDelegate {
    func didSelectCity(_ city: Country) {
        locationField.text = city.countryName
        valideButton()
    }
}

extension CreateTripViewController: DateRangePickerDelegate, TripDetailsDelegate {
    func didSelectDateRange(start: Date, end: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        
        startDateField.text = formatter.string(from: start)
        endDateField.text = formatter.string(from: max(start, end))
        valideButton()
    }
    
    func didEnterTripDetails(name: String, style: String, description: String) {
        let trip = Trip()
        trip.title = name
        trip.description = description
        trip.tripType = style
        trip.location = locationField.text ?? ""
        trip.startDate = startDateField.text ?? ""
//        trip.endDate = endDateField.text ?? ""
        self.trip = trip
        self.create(trip) { isSuccess in
            if(isSuccess) {
                self.tripListViewControllerDelegate?.tripListViewController(trip: self.trip ?? trip)
                self.navigationController?.popViewController(animated: true)
            }
        }
        
    }
}
