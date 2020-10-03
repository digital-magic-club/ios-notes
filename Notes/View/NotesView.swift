//
//  NotesView.swift
//  Notes
//
//  Created by Guillaume Bellut on 03/10/2020.
//

import SwiftUI

struct NotesView: View {

    @EnvironmentObject var viewModel: NotesViewModel
    @State private var searchText = ""
    @State private var shouldPushNewNoteView = false

    var body: some View {
        NavigationView {
            ZStack {
                NavigationLink(
                    destination: NoteView(note: self.viewModel.notes.first ?? Note()),
                    isActive: $shouldPushNewNoteView
                ) {
                    Text("")
                }
                .hidden()

                List {
                    Section(header:
                                SearchBar(text: $searchText, placeholder: "Search")
                                .padding(.leading, -30)
                                .padding(.trailing, -20)
                    ) {
                        ForEach(self.viewModel.notes.filter {
                            self.searchText.isEmpty ? true : $0.content.lowercased().contains(self.searchText.lowercased())
                        }, id: \.self) { note in
                            NoteRow(note: note)
                        }
                    }
                    .padding(EdgeInsets(top: 4,
                                        leading: 12,
                                        bottom: 4,
                                        trailing: 0))
                }
                .listStyle(InsetGroupedListStyle())
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .navigation) {
                    Button {
                        self.viewModel.exit()
                    } label: {
                        Label {
                            Text("Back")
                        } icon: {
                            Image(systemName: "chevron.backward")
                        }
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    VStack {
                        Spacer()
                        Text(viewModel.notesCountDescription)
                            .font(.caption)
                        Spacer()
                    }
                }
                ToolbarItem(placement: .bottomBar) {
                    Spacer()
                }
                ToolbarItem(placement: .bottomBar) {
                    Button {
                        self.viewModel.append(note: Note())
                        self.shouldPushNewNoteView = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                    }
                }
            }
//            .background(NavigationController { navigationController in
//                navigationController.navigationBar.barTintColor = UITraitCollection.current.userInterfaceStyle == .dark ? .black : .white
//                navigationController.navigationBar.shadowImage = UIImage()
//            })
        }
    }
}

struct NoteRow: View {
    
    @ObservedObject var note: Note

    var body: some View {
        ZStack(alignment: .leading) {
            NavigationLink(
                destination: NoteView(note: note)
            ) {
                EmptyView()
            }
            VStack(alignment: .leading) {
                Text(note.title)
                    .font(.headline)
                    .lineLimit(1)
                Text(note.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .lineLimit(1)
                    .padding(.top, 1)
            }
        }
    }
}

struct NotesView_Previews: PreviewProvider {
    static var previews: some View {
        let notes = (1...20).map { Note(content: "Note \($0)\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.", lastEdition: Date(timeIntervalSinceNow: TimeInterval(-60000 * $0))) }
        let viewModel = NotesViewModel(notes: notes)
        NotesView().environmentObject(viewModel)
    }
}
