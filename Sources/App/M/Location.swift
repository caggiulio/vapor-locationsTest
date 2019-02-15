//
//  Location.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 29/01/2019.
//

import Foundation
import FluentPostgreSQL
import Foundation
import Vapor

final class Location: Content, Parameter {
    var id: Int?
    
    var lat: String
    var lng: String
    var timestamp: String
    var speed: String 
    var tripID: String?
    
    init(lat: String, lng: String, timestamp: String, speed: String, tripID: String) {
        self.lat = lat
        self.lng = lng
        self.timestamp = timestamp
        self.speed = speed
        self.tripID = tripID
    }
}

extension Location: PostgreSQLModel {}
extension Location: Migration {}
