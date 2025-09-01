//
//  TripDetailViewController.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//


import UIKit

class TripDetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!

    var trip: Trip!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Trip"
        imageView.image = UIImage(named: "placeholder")
        guard trip != nil else { return }
        titleLabel.text = trip.title
        locationLabel.text = trip.location
        dateLabel.text = trip.displayDate
        typeLabel.text = trip.tripType
        descriptionTextView.text = trip.description ?? "No description provided."
    }
}
