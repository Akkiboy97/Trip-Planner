//
//  TripViewController.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//


import UIKit

final class TripViewController: UIViewController {
    
    private var tableView = UITableView(frame: .zero, style: .plain)
    private var viewModel: TripViewModel!
    
    private var header: HeaderView!
    private var activitiesCard: SectionCardView!
    private var hotelsCard: SectionCardView!
    private var flightsCard: SectionCardView!
    
    var onDataChanged: (() -> Void)?
    
    private(set) var trip: Trip
    private var elements: [TripItemType: [TripElement]] = [:]
    
    init(trip: Trip) {
        self.trip = trip
        super.init(nibName: nil, bundle: nil)
        TripItemType.allCases.forEach { elements[$0] = [] }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addItem(_ item: TripElement) {
        elements[item.type, default: []].append(item)
        self.tableView.reloadData()
        onDataChanged?()
    }
    
    func removeItem(_ item: TripElement) {
        guard var list = elements[item.type] else { return }
        list.removeAll { $0.id == item.id }
        elements[item.type ?? TripItemType.activity] = list
        onDataChanged?()
    }
    
    func items(for type: TripItemType) -> [TripElement] {
        return elements[type] ?? []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Plan a Trip"
        configureViewModel()
        configureTable()
        buildHeader()
        bind()
    }
    
    private func configureViewModel() {
        viewModel = TripViewModel(trip: self.trip ?? Trip())
    }
    
    private func bind() {
        viewModel.onDataChanged = { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    private func configureTable() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(ItemCell.self, forCellReuseIdentifier: ItemCell.reuse)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.estimatedRowHeight = 140
        tableView.rowHeight = UITableView.automaticDimension
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func buildHeader() {
        header = HeaderView()
        header.configure(with: viewModel.trip)
        header.onCollab = { [weak self] in self?.showMessage("Trip Collaboration tapped") }
        header.onShare = { [weak self] in self?.showMessage("Share Trip tapped") }
        
        activitiesCard = SectionCardView()
        activitiesCard.configure(title: "Activities",
                                 description: "Build, personalize, and optimize your itineraries with our trip planner.",
                                 buttonTitle: "Add Activities",
                                 style: .dark) { [weak self] in self?.presentAdd(for: .activity) }
        
        hotelsCard = SectionCardView()
        hotelsCard.configure(title: "Hotels",
                             description: "Build, personalize, and optimize your itineraries with our trip planner.",
                             buttonTitle: "Add Hotels",
                             style: .light) { [weak self] in self?.presentAdd(for: .hotel) }
        
        flightsCard = SectionCardView()
        flightsCard.configure(title: "Flights",
                              description: "Build, personalize, and optimize your itineraries with our trip planner.",
                              buttonTitle: "Add Flights",
                              style: .blue) { [weak self] in self?.presentAdd(for: .flight) }
        
        let headerStack = UIStackView(arrangedSubviews: [header, activitiesCard, hotelsCard, flightsCard, makeItineraryHeader()])
        headerStack.axis = .vertical
        headerStack.spacing = 12
        headerStack.layoutMargins = UIEdgeInsets(top: 8, left: 16, bottom: 12, right: 16)
        headerStack.isLayoutMarginsRelativeArrangement = true
        
        let container = UIView()
        container.addSubview(headerStack)
        headerStack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: container.topAnchor),
            headerStack.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            headerStack.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            headerStack.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])
        
        // Size appropriately
        let width = view.bounds.width
        container.frame = CGRect(x: 0, y: 0, width: width, height: 1)
        container.setNeedsLayout()
        container.layoutIfNeeded()
        let h = container.systemLayoutSizeFitting(CGSize(width: width, height: UIView.layoutFittingCompressedSize.height)).height
        container.frame.size.height = h
        
        tableView.tableHeaderView = container
    }
    
    private func makeItineraryHeader() -> UIView {
        let title = UILabel()
        title.font = .boldSystemFont(ofSize: 16)
        title.text = "Trip itineraries"
        
        let subtitle = UILabel()
        subtitle.font = .systemFont(ofSize: 12)
        subtitle.textColor = .darkGray
        subtitle.text = "Your trip itineraries are placed here"
        
        let s = UIStackView(arrangedSubviews: [title, subtitle])
        s.axis = .vertical; s.spacing = 4
        return s
    }
    
    private func showMessage(_ text: String) {
        let a = UIAlertController(title: nil, message: text, preferredStyle: .alert)
        present(a, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) { a.dismiss(animated: true) }
    }
    
    // MARK: - Add flow (quick alert-based form)
    private func presentAdd(for type: TripItemType) {
        let alert = UIAlertController(title: "Add \(type.singular)", message: "Enter a title and optional subtitle & price", preferredStyle: .alert)
        alert.addTextField { $0.placeholder = "Title" }
        alert.addTextField { $0.placeholder = "Subtitle (optional)" }
        alert.addTextField { $0.placeholder = "Price (optional)"; $0.keyboardType = .decimalPad }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            let title = alert.textFields?[0].text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? ""
            guard !title.isEmpty else { return }
            let subtitle = alert.textFields?[1].text
            let price = alert.textFields?[2].text
            let sampleURL: URL? = {
                switch type {
                case .flight: return URL(string: "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb")
                case .hotel: return URL(string: "https://images.unsplash.com/photo-1560347876-aeef00ee58a1")
                case .activity: return URL(string: "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee")
                }
            }()
            
            let item = TripElement(type: type, title: title, subtitle: subtitle, imageURL: sampleURL?.absoluteString, price: price?.isEmpty == true ? nil : price)
            self.addItem(item)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                self.scrollToFirstItem(of: type)
            }
        }))
        
        present(alert, animated: true)
    }
    
    private func scrollToFirstItem(of type: TripItemType) {
        let section = type.rawValue
        tableView.scrollToRow(at: IndexPath(row: 0, section: Int(section) ?? 0), at: .top, animated: true)
    }
}

// MARK: Table datasource + delegate
extension TripViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int { TripItemType.allCases.count }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        TripItemType(rawValue: section)?.title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let type = TripItemType(rawValue: section)!
        let items = self.items(for: type)
        // show 1 empty cell row if none (matches your first mock)
        return max(1, items.count)
    }
    
    func emptyCell(for type: TripItemType) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "empty-\(type.rawValue)")
        cell.selectionStyle = .none
        cell.textLabel?.text = "No request yet"
        cell.textLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        cell.detailTextLabel?.text = "Add \(type.singular)"
        cell.detailTextLabel?.textColor = .systemBlue
        cell.imageView?.image = {
            switch type {
            case .flight: return UIImage(systemName: "airplane")
            case .hotel: return UIImage(systemName: "building.2")
            case .activity: return UIImage(systemName: "figure.walk")
            }
        }()
        return cell
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let type = TripItemType(rawValue: indexPath.section)!
        
        let items = items(for: type)
        if items.isEmpty {
            return emptyCell(for: type)
        }
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ItemCell.reuse, for: indexPath) as? ItemCell else {
            return UITableViewCell()
        }
        
        let item = items[indexPath.row]
        cell.configure(with: item) { [weak self] in
            self?.viewModel.removeItem(type: item.type, id: UUID())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let type = TripItemType(rawValue: indexPath.section)!
        
        let items = items(for: type)
        if items.isEmpty {
            return 50
        }
        return 100
    }
}
