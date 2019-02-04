//
//  Extension.swift
//  App
//
//  Created by Nunzio Giulio Caggegi - Skylabs on 04/02/2019.
//

import Foundation

public extension String {
    
    public func stringToDate(timestamp: String) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval.init(timestamp)!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
