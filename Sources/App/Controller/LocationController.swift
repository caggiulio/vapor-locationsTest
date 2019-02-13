//
//  LocationController.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 29/01/2019.
//

import Vapor
import Fluent

final class LocationController: RouteCollection {
    func boot(router: Router) throws {
        let locations = router.grouped("locations")
        
        locations.post(Location.self, use: create)
        locations.get(use: index)
        locations.post([Location].self, use: postArray)
        //locations.get(User.parameter, use: show)
        //locations.patch(UserContent.self, at: User.parameter, use: update)
        //locations.delete(User.parameter, use: delete)
    }
    
    func create(_ request: Request, _ location: Location)throws -> Future<Location> {
        location.timestamp = location.timestamp.stringToDate(timestamp: location.timestamp)
        return location.save(on: request)
    }
    
    func index(_ request: Request)throws -> Future<[Location]> {
        return Location.query(on: request).all()
    }
    
    func postArray(_ request: Request, _ location: [Location])throws -> Future<[Location]> {
        return location.map { Location(lat: $0.lat, lng: $0.lng, timestamp: $0.timestamp, speed: $0.speed, tripID: $0.tripID!).save(on: request) }
            .flatten(on: request)
    }
}

struct LocationContent: Content {
    var lat: String?
    var lng: String?
    var speed: String?
    var timestamp: String?
    var tripID: String?
}
