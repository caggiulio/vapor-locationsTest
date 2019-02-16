//
//  AddTripDeviceId.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 15/02/2019.
//

import Foundation
import FluentPostgreSQL

struct AddTripDeviceId: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Trip.self, on: conn) { builder in
            let defaultValueConstraint = PostgreSQLColumnConstraint.default(.literal(0))
            builder.field(for: \.deviceId, type: .text, defaultValueConstraint)
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Trip.self, on: conn) { builder in
            
        }
    }
}
