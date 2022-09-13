    //
    //  LibraryView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 09.09.2022.
    //

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var viewModel: TracksViewModel
    @State private var showingDeleteAlert = false
    @State private var objectToDelete: Track?

    var body: some View {
        NavigationView {
            Group {
                if viewModel.tracks.count > 0 {
                    List(viewModel.tracks.freeze()) { track in
                        TrackView(track: track)
                            .swipeActions {
                                Button(role: .destructive) {
                                    objectToDelete = track
                                    showingDeleteAlert.toggle()
                                } label: {
                                    Image(systemName: "trash")
                                }
                            }
                    }.listStyle(.plain)
                } else {
                    VStack(spacing: 30.0) {
                        Image(systemName: "square.and.arrow.down.on.square")
                            .font(.system(size: 64))
                        Text("Library is empty. Please import media")
                    }.opacity(0.3)
                }
            }
            .navigationTitle("Library")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.isImporting = true
                    } label: {
                        Image(systemName: "square.and.arrow.down")
                    }
                }
            })
        }
        .navigationViewStyle(.stack)
        .confirmationDialog(
            Text("Delete \(objectToDelete?.title ?? "...")?"),
            isPresented: $showingDeleteAlert,
            titleVisibility: .visible
        ) {
            Button("Delete", role: .destructive, action: handleRemove)
        }
    }

    private func handleRemove() {
        guard let track = objectToDelete else { return }
        withAnimation {
            viewModel.removeFromLibrary(id: track.id)
            objectToDelete = nil
        }
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(TracksViewModel(realmCtrl: RealmController.previewRealm))
    }
}
