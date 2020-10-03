//
//  Note.swift
//  Notes
//
//  Created by Guillaume Bellut on 03/10/2020.
//

import SwiftUI

class Note: Hashable, Identifiable, ObservableObject {

    public var id = UUID()

    @Published public var content = "" {
        didSet {
            self.lastEdition = Date()
        }
    }
    @Published public var drawing = Drawing() {
        didSet {
            self.lastEdition = Date()
        }
    }
    @Published public private(set) var lastEdition = Date()

    private var lines: [String] {
        content.split(separator: "\n").map { String($0) }
    }

    public var title: String {
        return lines.first ?? NSLocalizedString("New Note", comment: "Title of an empty note")
    }

    public var subtitle: String {
        let prefix: String
        if let dayDifference = Calendar.current.dateComponents([.day], from: lastEdition, to: Date()).day {
            if dayDifference == 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .none
                dateFormatter.timeStyle = .short

                prefix = "\(dateFormatter.string(from: lastEdition))  "
            } else if dayDifference < 7 {
                let weekday = Calendar.current.component(.weekday, from: lastEdition)
                prefix = "\(DateFormatter().weekdaySymbols[weekday - 1])  "
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateStyle = .short
                dateFormatter.timeStyle = .none

                prefix = "\(dateFormatter.string(from: lastEdition))  "
            }
        } else {
            prefix = ""
        }

        if lines.count > 1 {
            return "\(prefix)\(lines[1])"
        } else {
            return "\(prefix)\(NSLocalizedString("No additional text", comment: "Subtitle of a note having only one line"))"
        }
    }

    public init(content: String = "", lastEdition: Date = Date()) {
        self.content = content
        self.lastEdition = lastEdition
    }

    public func replace(content: String) {
        self.content = content
        self.lastEdition = Date()
    }

    // MASK: - Hashable
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    // MASK: - Equatable
    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.id == rhs.id
    }
}
