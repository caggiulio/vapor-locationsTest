//
//  AddTripDeviceModel.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 27/02/2019.
//

import Foundation
import FluentPostgreSQL

struct AddTripDeviceModel: PostgreSQLMigration {
    static func prepare(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Trip.self, on: conn) { builder in
            let defaultValueConstraint = PostgreSQLColumnConstraint.default(.literal(""))
            builder.field(for: \.deviceModel, type: .text, defaultValueConstraint)
        }
    }
    
    static func revert(on conn: PostgreSQLConnection) -> EventLoopFuture<Void> {
        return PostgreSQLDatabase.update(Trip.self, on: conn) { builder in
            
        }
    }
}
