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

// Build the full list
func buildAllDestinations(locale: Locale = .current) -> [Country] {
    let codes = allISORegionCodes()
        .compactMap { $0.count == 2 ? $0.uppercased() : nil } // ensure alpha-2
    
    let destinations: [Country] = codes.compactMap { code in
        // Localized country name (falls back to code if not found)
        let name = locale.localizedString(forRegionCode: code) ?? code
        
        // FlagCDN uses lowercase ISO alpha-2
        let flagURL = "https://flagcdn.com/w320/\(code.lowercased()).png"
        
        // Leave cityName empty for now (you can fill capitals/popular cities later)
        return Country(
            cityName: "",
            countryName: name,
            countryCode: code,
            flagURL: flagURL
        )
    }
    // Sort nicely by country name
    return destinations.sorted { $0.countryName.localizedCaseInsensitiveCompare($1.countryName) == .orderedAscending }
}
