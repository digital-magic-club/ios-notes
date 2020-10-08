//
//  NotesApp.swift
//  Notes
//
//  Created by Guillaume Bellut on 03/10/2020.
//

import SwiftUI

@main
struct NotesApp: App {
    var body: some Scene {
        WindowGroup {
            let notes = (1...50).map { Note(content: "Note \($0)\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", lastEdition: Date(timeIntervalSinceNow: TimeInterval(-60000 * $0))) }
            let viewModel = NotesViewModel(notes: notes)
            NotesView().environmentObject(viewModel)
        }
    }
}
