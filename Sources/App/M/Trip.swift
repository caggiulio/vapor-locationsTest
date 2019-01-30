//
//  Trip.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 30/01/2019.
//

import Foundation
import FluentPostgreSQL
import Foundation
import Vapor

final class Trip: Content, Parameter {
    var id: Int?
    
    var startTimestamp: String?
    var endTimestamp: String?
    
    init(startTimestamp: String, endTimestamp: String) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
    }
}

extension Trip: PostgreSQLModel {}
extension Trip: Migration {}
