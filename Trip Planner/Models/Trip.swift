//
//  Trip.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//


import Foundation

enum TripItemType: Int, CaseIterable, Codable {
    case flight, hotel, activity
    
    var title: String {
        switch self {
        case .flight: return "Flights"
        case .hotel: return "Hotels"
        case .activity: return "Activities"
        }
    }
    
    var singular: String {
            switch self {
            case .flight: return "Flight"
            case .hotel: return "Hotel"
            case .activity: return "Activity"
            }
        }
}

struct TripElement: Codable, Identifiable, Equatable {
    var id: UUID
    var type: TripItemType
    var title: String
    var subtitle: String?
    var imageURL: String?
    var price: String?

    init(id: UUID = UUID(),
         type: TripItemType,
         title: String,
         subtitle: String? = nil,
         imageURL: String? = nil,
         price: String? = nil) {
        self.id = id
        self.type = type
        self.title = title
        self.subtitle = subtitle
        self.imageURL = imageURL
        self.price = price
    }
}

class Trip: Codable {
    var id: String?
    var title: String?
    var location: String?
    var startDate: String?
    var endDate: String?
    var tripType: String?
    var description: String?
    var image: String?
    var headerImageURL: URL?
    
    var elements: [TripElement] = []
    
    var displayDate: String {
        if let start = startDate, let end = endDate, !start.isEmpty {
            return "\(start)  →  \(end)"
        }
        return startDate ?? ""
    }
    
    init(id: String? = nil, title: String? = nil) {
        self.id = id
        self.title = title
    }
    
    enum CodingKeys: String, CodingKey {
        case id, title, location, startDate, tripType, image
        case description = "description"
    }
}
