//
//  TripController.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 30/01/2019.
//

import Foundation
import Vapor
import Fluent
import Pagination

final class TripController: RouteCollection {
    func boot(router: Router) throws {
        let trips = router.grouped("trips")
        
        trips.post(Trip.self, use: create)
        trips.get(use: index)
        trips.get("deviceId", Trip.parameter, use: getList)
        trips.get("deviceId", use: getListWithoutDeviceId)
        trips.patch(TripContent.self, at: Trip.parameter, use: update)
    }
    
    func create(_ request: Request, _ trip: Trip)throws -> Future<Trip> {
        return trip.save(on: request)
    }
    
    func index(_ request: Request)throws -> Future<[TripCustomContent]> {
        
        var queryTrips = try Trip.query(on: request).paginate(for: request, [(\Trip.startTimestamp).querySort()])
        
        if let deviceIdReq = try? request.query.get(String.self, at: "deviceId") {
            queryTrips = try Trip.query(on: request).filter(\.deviceId == deviceIdReq).paginate(for: request, [(\Trip.startTimestamp).querySort()])
        }
        
        return queryTrips.flatMap { trips -> Future<[TripCustomContent]> in
            let tripIds = trips.data.map({ ($0.id!) })
            //let tripIds = trips.map({ ($0.id!) })
            
            return Location.query(on: request).filter(\.tripID ~~ tripIds).all().map { locations in
                return trips.data.map { trip in
                    let locationCount = locations.filter({ $0.tripID == (trip.id!) }).count
                    return TripCustomContent.init(startTimestamp: trip.startTimestamp, endTimestamp: trip.endTimestamp, deviceId: trip.deviceId, locationCount: locationCount, tripId: trip.id!)
                }
            }
        }
    }
    
    func update(_ request: Request, _ body: TripContent)throws -> Future<Trip> {
        let trip = try request.parameters.next(Trip.self)
        return trip.map(to: Trip.self, { trip in
            trip.startTimestamp = body.startTimestamp ?? trip.startTimestamp
            trip.endTimestamp = body.endTimestamp ?? trip.endTimestamp
            trip.deviceId = body.deviceId ?? trip.deviceId
            return trip
        }).update(on: request)
    }
    
    func getList(_ request: Request) throws -> Future<[TripCustomContent]> {
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
    }
    
    /*func getList0(_ request: Request)throws -> Future<[TripCustomContent]> {
        let deviceIdReq = request.parameters.values[0].value
        var tripsR = [TripCustomContent]()
        let val = Trip.query(on: request).filter(\.deviceId == deviceIdReq).all()
        return val.flatMap { model in
            var count = 0
            for t in model {
                
                let tripIdString = String(t.id!)
                
                var c = Location.query(on: request).filter(\.tripID == tripIdString).count().map{ (result) -> (Int) in
                    return result
                }
                
                let tripCustomContent = TripCustomContent.init(startTimestamp: t.startTimestamp, endTimestamp: t.endTimestamp, deviceId: t.deviceId, locationCount: Location.query(on: request).filter(\.tripID == tripIdString).count())
                tripsR.append(tripCustomContent)
                //tripsR = model
            }
            return Future.map(on: request) {return tripsR }
        }
    }*/
    
    /*func getList(_ request: Request)throws -> Future<[Trip]> {
        
        let deviceIdReq = request.parameters.values[0].value
        let queryTrips = Trip.query(on: request).filter(\.deviceId == deviceIdReq).all()
        return queryTrips
    }*/
    
    func getListWithoutDeviceId(_ request: Request)throws -> Future<[TripCustomContent]> {
        let queryTrips = Trip.query(on: request).sort(\.startTimestamp, ._descending).all()
        
        return queryTrips.flatMap { trips -> Future<[TripCustomContent]> in
            let tripIds = trips.map({ ($0.id!) })
            
            return Location.query(on: request).filter(\.tripID ~~ tripIds).all().map { locations in
                return trips.map { trip in
                    let locationCount = locations.filter({ $0.tripID == (trip.id!) }).count
                    return TripCustomContent.init(startTimestamp: trip.startTimestamp, endTimestamp: trip.endTimestamp, deviceId: trip.deviceId, locationCount: locationCount, tripId: trip.id!)
                }
            }
        }
    }
}

struct TripContent: Content {
    var startTimestamp: String?
    var endTimestamp: String?
    var deviceId: String?
}

struct TripCustomContent: Content {
    var startTimestamp: String?
    var endTimestamp: String?
    var deviceId: String
    var locationCount: Int
    var tripId: Int
}
