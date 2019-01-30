//
//  TripController.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 30/01/2019.
//

import Foundation
import Vapor
import Fluent

final class TripController: RouteCollection {
    func boot(router: Router) throws {
        let trips = router.grouped("trips")
        
        trips.post(Trip.self, use: create)
        trips.get(use: index)
        trips.patch(TripContent.self, at: Trip.parameter, use: update)
    }
    
    func create(_ request: Request, _ trip: Trip)throws -> Future<Trip> {
        return trip.save(on: request)
    }
    
    func index(_ request: Request)throws -> Future<[Trip]> {
        return Trip.query(on: request).all()
    }
    
    func update(_ request: Request, _ body: TripContent)throws -> Future<Trip> {
        let trip = try request.parameters.next(Trip.self)
        return trip.map(to: Trip.self, { trip in
            trip.startTimestamp = body.startTimestamp ?? trip.startTimestamp
            trip.endTimestamp = body.endTimestamp ?? trip.endTimestamp
            return trip
        }).update(on: request)
    }
}

struct TripContent: Content {
    var startTimestamp: String?
    var endTimestamp: String?
}
