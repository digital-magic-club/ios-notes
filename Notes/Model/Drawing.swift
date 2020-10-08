//
//  Drawing.swift
//  Voila
//
//  Created by Guillaume Bellut on 11/05/2020.
//  Copyright © 2020 Tulleb's Corp. All rights reserved.
//

import SwiftUI

class Drawing: ObservableObject {

    @Published private var lines = [Line]()
    @Published var currentIndex = 0

    public var visibleLines: [Line] {
        Array(lines.prefix(currentIndex))
    }

    var canUndo: Bool {
        currentIndex > 0
    }

    var canRedo: Bool {
        currentIndex < lines.count
    }

    func undo() {
        currentIndex = max(0, currentIndex - 1)
    }

    func redo() {
        currentIndex = min(currentIndex + 1, lines.count)
    }

    func startNewLine() {
        lines = visibleLines
        lines.append(Line())
        currentIndex += 1
    }

    func append(point: CGPoint) {
        visibleLines.last?.points.append(point)
    }
}

class Line: ObservableObject {

    var points = [CGPoint]()
}
