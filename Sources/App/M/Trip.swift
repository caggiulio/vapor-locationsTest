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
    
    var startTimestamp: String
    var endTimestamp: String?
    var deviceId: String
    var deviceModel: String?
    
    init(startTimestamp: String, endTimestamp: String, deviceId: String, deviceModel: String) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.deviceId = deviceId
        self.deviceModel = deviceModel
    }
}

extension Trip: PostgreSQLModel {}
extension Trip: Migration{}
