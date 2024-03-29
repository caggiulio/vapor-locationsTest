//
//  TripController.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 30/01/2019.
//

import Foundation
import Vapor
import Fluent
import FluentPostgreSQL

final class TripController: RouteCollection {
    func boot(router: Router) throws {
        let trips = router.grouped("trips")
        
        trips.post(Trip.self, use: create)
        trips.get(use: index)
        trips.patch(TripContent.self, at: Trip.parameter, use: update)
    }
    
    func create(_ request: Request, _ trip: Trip)throws -> Future<Trip> {
        if trip.deviceModel == nil {
            trip.deviceModel = ""
        }

        return trip.save(on: request)
    }
    
    func index(_ request: Request)throws -> Future<[TripCustomContent]> {
        /*var rawQueryString = ""
        var whereClause = ""
        if let deviceIdReq = try? request.query.get(String.self, at: "deviceId") {
            whereClause = """
            WHERE
            "Trip"."deviceId" ilike '\(deviceIdReq)'
            """
        }
            rawQueryString = """
            SELECT
            "Trip".id AS "tripId",
            "startTimestamp",
            "endTimestamp",
            "deviceModel",
            "deviceId",
            count("tripID") AS "locationCount"
            FROM
            "Trip"
            LEFT JOIN "Location" AS P ON "Trip".id = "tripID"
            \(whereClause)
            GROUP BY
            "Trip".id
            """
    
        let customTrips = request.withPooledConnection(to: .psql) { (conn: PostgreSQLDatabase.Connection) -> EventLoopFuture<[TripCustomContent]> in
            return conn.raw(rawQueryString).all(decoding: TripCustomContent.self)
        }
        return customTrips*/
        
        let customTrips = request.withPooledConnection(to: .psql) { (conn: PostgreSQLDatabase.Connection) -> EventLoopFuture<[TripCustomContent]> in
            var res = conn.select()
                .column(.column(\Trip.id), as: "tripId")
                .column(\Trip.startTimestamp)
                .column(\Trip.endTimestamp)
                .column(\Trip.deviceModel)
                .column(\Trip.deviceId)
                .column(.count(\Location.tripID), as: "locationCount")
                .from(Trip.self)
                .join(\Trip.id, to: \Location.tripID)
            
            if let deviceIdReq = try? request.query.get(String.self, at: "deviceId") {
                res = res.where(\Trip.deviceId, .equal, deviceIdReq)
            }
            
            res = res.groupBy(.column(.keyPath(\Trip.id)))
            
            return res.all(decoding: TripCustomContent.self)
        }

        return customTrips
    }
    
    func update(_ request: Request, _ body: TripContent)throws -> Future<Trip> {
        let trip = try request.parameters.next(Trip.self)
        return trip.map(to: Trip.self, { trip in
            trip.startTimestamp = body.startTimestamp ?? trip.startTimestamp
            trip.endTimestamp = body.endTimestamp ?? trip.endTimestamp
            trip.deviceId = body.deviceId ?? trip.deviceId
            trip.deviceModel = body.deviceModel ?? trip.deviceModel
            return trip
        }).update(on: request)
    }
    
    /*func getList(_ request: Request) throws -> Future<[TripCustomContent]> {
        let deviceIdReq = request.parameters.values[0].value
        let queryTrips = Trip.query(on: request).filter(\.deviceId == deviceIdReq).sort(\.startTimestamp, ._descending).all()
        
        return queryTrips.flatMap { trips -> Future<[TripCustomContent]> in
            let tripIds = trips.map({ ($0.id!) })
        
            return Location.query(on: request).filter(\.tripID ~~ tripIds).all().map { locations in
                return trips.map { trip in
                    let locationCount = locations.filter({ $0.tripID == (trip.id!) }).count
                    return TripCustomContent.init(startTimestamp: trip.startTimestamp, endTimestamp: trip.endTimestamp, deviceId: trip.deviceId, locationCount: locationCount, tripId: trip.id!)
                }
            }
        }
    }*/
}

struct TripContent: Content {
    var startTimestamp: String?
    var endTimestamp: String?
    var deviceId: String?
    var deviceModel: String?
}

struct TripCustomContent: Content {
    var startTimestamp: String?
    var endTimestamp: String?
    var deviceId: String
    var locationCount: Int
    var tripId: Int
    var deviceModel: String?
}
