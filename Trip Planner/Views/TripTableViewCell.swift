//
//  SectionCardView.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

protocol TripTableViewCellDelegate: AnyObject {
    func didTapOnViewAllButton(index: Int)
}


import UIKit

class TripTableViewCell: UITableViewCell {
    static let identifier = "TripTableViewCell"
    
    var tripTableViewCellDelegate: TripTableViewCellDelegate?
    
    private let tripImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let locationLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.textColor = .white
        l.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        l.layer.cornerRadius = 6
        l.layer.masksToBounds = true
        l.textAlignment = .center
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16, weight: .semibold)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let dateLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let daysLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 13, weight: .medium)
        l.textColor = .secondaryLabel
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    private let viewButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("View", for: .normal)
        b.setTitleColor(.white, for: .normal)
        b.backgroundColor = UIColor.systemBlue
        b.layer.cornerRadius = 6
        b.translatesAutoresizingMaskIntoConstraints = false
        return b
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 0.5
        contentView.layer.borderColor = UIColor.systemGray5.cgColor
        contentView.clipsToBounds = true
        
        contentView.addSubview(tripImageView)
        contentView.addSubview(locationLabel)
        contentView.addSubview(titleLabel)
        contentView.addSubview(dateLabel)
        contentView.addSubview(daysLabel)
        contentView.addSubview(viewButton)
        
        viewButton.addTarget(self, action: #selector(didTapViewButton(_:)), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            tripImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            tripImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            tripImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            tripImageView.heightAnchor.constraint(equalToConstant: 180),
            
            locationLabel.topAnchor.constraint(equalTo: tripImageView.topAnchor, constant: 12),
            locationLabel.trailingAnchor.constraint(equalTo: tripImageView.trailingAnchor, constant: -12),
            locationLabel.heightAnchor.constraint(equalToConstant: 24),
            locationLabel.widthAnchor.constraint(greaterThanOrEqualToConstant: 60),
            
            titleLabel.topAnchor.constraint(equalTo: tripImageView.bottomAnchor, constant: 8),
            titleLabel.leadingAnchor.constraint(equalTo: tripImageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: tripImageView.trailingAnchor),
            
            dateLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 4),
            dateLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            
            daysLabel.centerYAnchor.constraint(equalTo: dateLabel.centerYAnchor),
            daysLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            
            viewButton.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 12),
            viewButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            viewButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            viewButton.heightAnchor.constraint(equalToConstant: 40),
            viewButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
        ])
    }
    
    required init?(coder: NSCoder) { fatalError("init(coder:) not implemented") }
    
    func configure(with trip: Trip, index int: Int) {
        titleLabel.text = trip.title
        locationLabel.text = trip.location
        dateLabel.text = trip.displayDate
        daysLabel.text = "5 Days"
        viewButton.tag = int
        
        if let urlString = trip.image, let url = URL(string: urlString) {
            loadImage(from: url)
        } else {
            tripImageView.image = UIImage(systemName: "photo")
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else { return }
            let image = UIImage(data: data)
            DispatchQueue.main.async {
                self.tripImageView.image = image
            }
        }.resume()
    }
    
    @objc private func didTapViewButton(_ sender: UIButton) {
        self.tripTableViewCellDelegate?.didTapOnViewAllButton(index: sender.tag)
    }
}
