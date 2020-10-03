//
//  NoteView.swift
//  Notes
//
//  Created by Guillaume Bellut on 07/10/2020.
//

import SwiftUI

struct NoteView: View {

    @EnvironmentObject private var viewModel: NotesViewModel
    @ObservedObject var note: Note
    @State private var isDrawing: Bool = false
    @State private var isEditing: Bool = false

    var body: some View {
        ZStack {
            TextEditor(text: $note.content)
                .padding()
                .padding(.top, 0)
                .onTapGesture(count: /*@START_MENU_TOKEN@*/1/*@END_MENU_TOKEN@*/, perform: {
                    self.isEditing = true
                })
                .onChange(of: note.content) { _ in
                    self.viewModel.edit(note: note)
                }
            if isDrawing {
                DrawingView(drawing: $note.drawing, editedNote: note)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if isDrawing {
                    Button {
                        didTapUndoButton()
                    } label: {
                        Image(systemName: "arrow.uturn.backward.circle")
                    }
                    .disabled(!note.drawing.canUndo)
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if isDrawing {
                    Button {
                        didTapRedoButton()
                    } label: {
                        Image(systemName: "arrow.uturn.forward.circle")
                    }
                    .disabled(!note.drawing.canRedo)
                } else {
                    EmptyView()
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if !isDrawing {
                    Button {
                        didTapPencilButton()
                    } label: {
                        Image(systemName: "pencil.tip.crop.circle")
                    }
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                if isDrawing || isEditing {
                    Button {
                        didTapDoneButton()
                    } label: {
                        Text("Done")
                            .font(Font.body.bold())
                    }
                } else {
                    EmptyView()
                }
            }
        }
        .onAppear() {
            self.viewModel.startEditing(note: note)
        }
        .onDisappear() {
            self.viewModel.finishEditing(note: note)
        }
    }

    private func didTapUndoButton() {
        note.objectWillChange.send()
        note.drawing.undo()
    }

    private func didTapRedoButton() {
        note.objectWillChange.send()
        note.drawing.redo()
    }

    private func didTapPencilButton() {
        startDrawing()
    }

    private func didTapDoneButton() {
        if isDrawing {
            finishDrawing()
        } else if isEditing {
            finishEditing()
        }
    }

    private func startDrawing() {
        isDrawing = true
    }

    private func finishDrawing() {
        isDrawing = false
    }

    private func finishEditing() {
        isEditing = false
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct DrawingView: View {

    @EnvironmentObject private var viewModel: NotesViewModel
    @Binding var drawing: Drawing
    let editedNote: Note
    @State private var isDragging = false

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Path { path in
                    for line in drawing.visibleLines {
                        self.add(line: line, to: &path)
                    }
                }
                .stroke(Color.primary, lineWidth: 4.0)
            }

            Color(.black)
                .opacity(0.001)
                .gesture(
                    DragGesture(minimumDistance: 0)
                        .onChanged { value in
                            if !isDragging {
                                isDragging = true
                                self.drawing.startNewLine()
                            }

                            self.drawing.append(point: value.location)
                            self.editedNote.objectWillChange.send()
                        }
                        .onEnded { value in
                            self.isDragging = false
                            self.viewModel.edit(drawing: drawing)
                        }
                )
        }
    }

    private func add(line: Line, to path: inout Path) {
        let points = line.points

        guard points.count > 1 else {
            return
        }

        for i in 0 ..< points.count - 1 {
            let current = points[i]
            let next = points[i + 1]
            path.move(to: current)
            path.addLine(to: next)
        }
    }
}

struct NoteView_Previews: PreviewProvider {
    static var previews: some View {
        let note = Note(content: "Title\nLorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
        NoteView(note: note)
    }
}
