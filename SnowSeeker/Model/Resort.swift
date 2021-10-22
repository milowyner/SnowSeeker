//
//  Resort.swift
//  SnowSeeker
//
//  Created by Milo Wyner on 10/16/21.
//

import Foundation

struct Resort: Codable, Identifiable {
    let id: String
    let name: String
    let country: String
    let description: String
    let imageCredit: String
    let price: Int
    let size: Int
    let snowDepth: Int
    let elevation: Int
    let runs: Int
    let facilities: [String]
    
    var facilityTypes: [Facility] {
        facilities.map(Facility.init)
    }
    
    var priceString: String {
        String(repeating: "$", count: price)
    }
    
    var sizeString: String {
        switch size {
        case 1:
            return "Small"
        case 2:
            return "Average"
        default:
            return "Large"
        }
    }
    
    static let allResorts: [Resort] = Bundle.main.decode("resorts.json")
    static let example = allResorts[0]
    
    struct Filter {
        let types = [
            "Country": ["Austria", "Canada", "France", "Italy", "United States"],
            "Price": ["$", "$$", "$$$"],
            "Size": ["Small", "Average", "Large"]
        ]
        
        var selected: [String: String?] = ["Country": nil, "Price": nil, "Size": nil]
    }
}
