//
//  ReadingLogType.swift
//  OpenBook
//
//  Created by Sean Molenaar on 24/07/2023.
//

import Foundation

enum ReadingLogType: String, CaseIterable, Identifiable, CustomStringConvertible {
    case wanted
    case reading
    case read

    var id: String { self.rawValue }
    var description: String { self.rawValue }
}
