//
//  Item.swift
//  OpenLibrarian
//
//  Created by Sean Molenaar on 14/06/2023.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
