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
import Pagination

final class Trip: Content, Parameter {
    var id: Int?
    
    var startTimestamp: String
    var endTimestamp: String?
    var deviceId: String
    
    init(startTimestamp: String, endTimestamp: String, deviceId: String) {
        self.startTimestamp = startTimestamp
        self.endTimestamp = endTimestamp
        self.deviceId = deviceId
    }
}

extension Trip: PostgreSQLModel {}
extension Trip: Migration{}
extension Trip: Paginatable {
    public static var defaultPageSize: Int {
        return 5
    }
    
    public static var defaultPageSorts: [Trip.Database.QuerySort] {
        return [
            Trip.createdAtKey?.querySort(Trip.Database.querySortDirectionDescending) ?? Trip.idKey.querySort(Trip.Database.querySortDirectionDescending)
        ]
    }
}
