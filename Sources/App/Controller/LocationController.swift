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
        //locations.get(User.parameter, use: show)
        //locations.patch(UserContent.self, at: User.parameter, use: update)
        //locations.delete(User.parameter, use: delete)
    }
    
    func create(_ request: Request, _ location: Location)throws -> Future<Location> {
        return location.save(on: request)
    }
    
    func index(_ request: Request)throws -> Future<[Location]> {
        return Location.query(on: request).all()
    }
    
    /*func show(_ request: Request)throws -> Future<Location> {
        return try request.parameters.next(User.self)
    }
    
    func update(_ request: Request, _ body: UserContent)throws -> Future<Location> {
        let user = try request.parameters.next(User.self)
        return user.map(to: User.self, { user in
            user.username = body.username ?? user.username
            user.firstname = body.firstname ?? user.firstname
            user.lastname = body.lastname ?? user.lastname
            user.email = body.email ?? user.email
            user.password = body.password ?? user.password
            return user
        }).update(on: request)
    }
    
    func delete(_ request: Request)throws -> Future<HTTPStatus> {
        return try request.parameters.next(Location.self).delete(on: request).transform(to: .noContent)
    }*/
}

struct LocationContent: Content {
    var lat: String?
    var lng: String?
    var speed: String?
    var timestamp: String?
    var tripID: String?
}
