//
//  NotesViewModel.swift
//  Notes
//
//  Created by Guillaume Bellut on 07/10/2020.
//

import SwiftUI

protocol NotesDelegate: class {
    func didEdit(note: Note)
    func didEdit(drawing: Drawing)
    func didStartEditing(note: Note)
    func didFinishEditing(note: Note)
    func didExit()
}

class NotesViewModel: ObservableObject {

    @Published public private(set) var notes: [Note]
    public weak var delegate: NotesDelegate?

    var notesCountDescription: String {
        NSLocalizedString("[count] Notes", comment: "Do not replace [count]").replacingOccurrences(of: "[count]", with: "\(notes.count)")
    }

    public init(notes: [Note]) {
        self.notes = notes
    }

    func append(note: Note) {
        notes.append(note)
        sort()
    }

    func sort() {
        notes.sort(by: { $0.lastEdition > $1.lastEdition })
    }

    func edit(note: Note) {
        sort()
        delegate?.didEdit(note: note)
    }

    func edit(drawing: Drawing) {
        sort()
        delegate?.didEdit(drawing: drawing)
    }

    func startEditing(note: Note) {
        delegate?.didStartEditing(note: note)
    }

    func finishEditing(note: Note) {
        delegate?.didFinishEditing(note: note)
    }

    func exit() {
        delegate?.didExit()
    }
}
