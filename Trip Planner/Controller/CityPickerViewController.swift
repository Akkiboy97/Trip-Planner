//
//  CityPickerViewController.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import UIKit

protocol CityPickerDelegate: AnyObject {
    func didSelectCity(_ city: Country)
}

class CityPickerViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    weak var delegate: CityPickerDelegate?

    private let tableView = UITableView()
    private let searchBar = UISearchBar()
    private var filteredCities: [Country] = buildAllDestinations()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Where"
        view.backgroundColor = .white
        
        searchBar.placeholder = "Please select a city"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false

        tableView.register(CityCell.self, forCellReuseIdentifier: CityCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = 70
        tableView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(searchBar)
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCities.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CityCell.identifier, for: indexPath) as? CityCell else {
            return UITableViewCell()
        }
        cell.configure(with: filteredCities[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let city = filteredCities[indexPath.row]
        delegate?.didSelectCity(city)
        dismiss(animated: true)
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            filteredCities = buildAllDestinations()
        } else {
            filteredCities = buildAllDestinations().filter {
                $0.cityName.lowercased().contains(searchText.lowercased()) ||
                $0.countryName.lowercased().contains(searchText.lowercased())
            }
        }
        tableView.reloadData()
    }
}
