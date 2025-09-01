//
//  country.swift
//  Trip Planner
//
//  Created by Akshay on 31/08/25.
//

import Foundation

class Country {
    
    static var sharedPreferances = Country()
    
    var cityName: String = ""
    var countryName: String = ""
    var countryCode: String = ""
    var flagURL: String = ""
    
    init(cityName: String = "", countryName: String = "", countryCode: String = "",
         flagURL: String = "") {
        self.cityName = cityName
        self.countryName = countryName
        self.countryCode = countryCode
        self.flagURL = flagURL
    }
    
}


private func allISORegionCodes() -> [String] {
    return Locale.Region.isoRegions.map { $0.identifier.uppercased() }
}

func buildAllDestinations(locale: Locale = .current) -> [Country] {
    let codes = allISORegionCodes()
        .compactMap { $0.count == 2 ? $0.uppercased() : nil } // ensure alpha-2
    
    let destinations: [Country] = codes.compactMap { code in
        let name = locale.localizedString(forRegionCode: code) ?? code
        
        let flagURL = "https://flagcdn.com/w320/\(code.lowercased()).png"
        
        return Country(
            cityName: "",
            countryName: name,
            countryCode: code,
            flagURL: flagURL
        )
    }
    return destinations.sorted { $0.countryName.localizedCaseInsensitiveCompare($1.countryName) == .orderedAscending }
}
