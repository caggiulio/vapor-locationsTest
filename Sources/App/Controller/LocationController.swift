//
//  LocationController.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 29/01/2019.
//

import Vapor
import Fluent
import FluentPostgreSQL

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
            //return Location.query(on: request).filter(\.tripID == tripIDReq).sort(\.timestamp).all()
            return request.withPooledConnection(to: .psql) { (conn: PostgreSQLDatabase.Connection) -> EventLoopFuture<[Location]> in
                return conn.raw("""
select  * from "Location" where "tripID" = \(tripIDReq)
""").all(decoding: Location.self)
            }
        } else {
            return request.withPooledConnection(to: .psql) { (conn: PostgreSQLDatabase.Connection) -> EventLoopFuture<[Location]> in
                return conn.raw("""
                    select  * from "Location"
                    """).all(decoding: Location.self)
            //return Location.query(on: request).sort(\.timestamp).all()
            }
        }
    }
    
    func show(_ request: Request)throws -> Future<[Location]> {
        let tripIDReq = Int(request.parameters.values[0].value)
        return Location.query(on: request).filter(\.tripID == tripIDReq!).sort(\.timestamp).all()
    }
    
    func postArray(_ request: Request, _ location: [Location])throws -> Future<[Location]> {
        return location.map { Location(lat: $0.lat, lng: $0.lng, timestamp: $0.timestamp, speed: $0.speed, tripID: ($0.tripID), accuracy: ($0.accuracy ?? -1), verticalAccuracy: ($0.verticalAccuracy ?? -1), interpolationFlag: $0.interpolationFlag ?? false).save(on: request) }
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
