//
//  PlanTripViewModel.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import Foundation

final class TripViewModel {
    // Trip metadata
    private(set) var trip: Trip

    // Data arrays
    private(set) var flights: [TripElement] = []
    private(set) var hotels: [TripElement] = []
    private(set) var activities: [TripElement] = []

    // Callbacks for view binding
    var onDataChanged: (() -> Void)?

    init(trip: Trip) {
        self.trip = trip
    }

    // MARK: - Add demo items
    func addFlight(title: String, subtitle: String?, price: String?, imageURL: String?) {
        let item = TripElement(type: .flight, title: title, subtitle: subtitle, imageURL: imageURL, price: price)
        flights.append(item)
        onDataChanged?()
    }

    func addHotel(title: String, subtitle: String?, price: String?, imageURL: String?) {
        let item = TripElement(type: .hotel, title: title, subtitle: subtitle, imageURL: imageURL, price: price)
        hotels.append(item)
        onDataChanged?()
    }

    func addActivity(title: String, subtitle: String?, price: String?, imageURL: String?) {
        let item = TripElement(type: .activity, title: title, subtitle: subtitle, imageURL: imageURL, price: price)
        activities.append(item)
        onDataChanged?()
    }

    // Remove
    func removeItem(type: TripItemType, id: UUID) {
        switch type {
        case .flight:
            flights.removeAll { $0.id == id }
        case .hotel:
            hotels.removeAll { $0.id == id }
        case .activity:
            activities.removeAll { $0.id == id }
        }
        onDataChanged?()
    }
}
