//
//  TripListViewController.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

protocol TripListViewControllerDelegate: AnyObject {
    func tripListViewController(didAddTrip trip: Trip)
}

import UIKit

class TripListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private var api: APIClient = APIClient(baseURL: Config.BASE_URL)
    private var trips: [Trip] = []
    
    var tripListViewControllerDelegate: TripListViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Your Trips"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "New",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapNew))
        
        self.tripListViewControllerDelegate = self

        tableView.register(TripTableViewCell.self, forCellReuseIdentifier: TripTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        fetch()
    }

    func fetch() {
        showLoading(true)
        api.fetchTrips { [weak self] result in
            DispatchQueue.main.async {
                self?.showLoading(false)
                switch result {
                case .success(let trips):
                    self?.trips = trips
                    self?.tableView.reloadData()
                case .failure:
                    self?.showAlert(title: "Error", message: "Failed to fetch trips")
                }
            }
        }
    }

    @objc func didTapNew() {
        let vc = CreateTripViewController(apiClient: api)
        vc.onCreateSuccess = { [weak self] created in
            self?.trips.insert(created, at: 0)
            self?.tableView.reloadData()
        }
//        let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.pushViewController(vc, animated: true)
//        present(nav, animated: true)
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

    func showAlert(title: String, message: String) {
        let a = UIAlertController(title: title, message: message, preferredStyle: .alert)
        a.addAction(UIAlertAction(title: "OK", style: .default))
        present(a, animated: true)
    }
}

extension TripListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        return trips.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TripTableViewCell.identifier)
                as? TripTableViewCell else {
            return UITableViewCell()
        }
        cell.tripTableViewCellDelegate = self
        cell.configure(with: trips[indexPath.row], index: indexPath.row)
        return cell
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let trip = trips[indexPath.row]
        // show trip detail (xib)
//        let detailVC = TripDetailViewController(nibName: "TripDetailsView", bundle: nil)
        let detailVC = TripViewController(trip: trip)
//        detailVC.trip = trip
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TripListViewController: TripTableViewCellDelegate {
    func didTapOnViewAllButton(index: Int) {
        let trip = trips[index]
        let detailVC = TripViewController(trip: trip)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension TripListViewController: TripListViewControllerDelegate {
    func tripListViewController(didAddTrip trip: Trip) {
        self.trips.insert(trip, at: 0)
        self.tableView.reloadData()
    }
}
