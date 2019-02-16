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
        locations.get("trips", Location.parameter, use: show)
        //locations.patch(UserContent.self, at: User.parameter, use: update)
        //locations.delete(User.parameter, use: delete)
    }
    
    func create(_ request: Request, _ location: Location)throws -> Future<Location> {
        return location.save(on: request)
    }
    
    func index(_ request: Request)throws -> Future<[Location]> {
        if let tripIDReq = try? request.query.get(Int.self, at: "tripID") {
            return Location.query(on: request).filter(\.tripID == tripIDReq).all()
        } else {
            return Location.query(on: request).all()
        }
    }
    
    func show(_ request: Request)throws -> Future<[Location]> {
        let tripIDReq = Int(request.parameters.values[0].value)
        return Location.query(on: request).filter(\.tripID == tripIDReq!).all()
    }
    
    func postArray(_ request: Request, _ location: [Location])throws -> Future<[Location]> {
        return location.map { Location(lat: $0.lat, lng: $0.lng, timestamp: $0.timestamp, speed: $0.speed, tripID: ($0.tripID ?? -1), accuracy: ($0.accuracy ?? -1), verticalAccuracy: ($0.verticalAccuracy ?? -1), interpolationFlag: $0.interpolationFlag ?? false).save(on: request) }
            .flatten(on: request)
        /*return try request.content.decode([Location].self).map { locRequest in
            return .ok
        }*/
    }
}

struct LocationContent: Content {
    var lat: String?
    var lng: String?
    var timestamp: String?
    var speed: String?
    var tripID: Int
    var accuracy: Float?
    var verticalAccuracy: Float?
    var interpolationFlag: Bool?
}
