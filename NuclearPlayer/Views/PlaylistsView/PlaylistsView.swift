    //
    //  PlaylistsView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 04.09.2022.
    //

import SwiftUI

struct PlaylistsView: View {
    @EnvironmentObject var viewModel: LocalLibraryViewModel
    @State private var showingDeleteAlert = false
    @State private var objectToDelete: Playlist?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.playlists) { playlist in
                    NavigationLink(
                        destination:
                            PlaylistView(playlist: playlist),
                        label: {
                            HStack {
                                Text(playlist.title)
                                Spacer()
                                Text(String(playlist.tracks.count))
                            }
                        }
                    )
                    .swipeActions {
                        Button(role: .destructive) {
                            objectToDelete = playlist
                            showingDeleteAlert = true
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Playlists")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddPlaylistVew(self.addToLibrary)
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

    private func addToLibrary(title: String) {
        viewModel.addToLibrary(title: title)
    }

    private func handleRemove() {
        guard let playlist = objectToDelete else { return }
        withAnimation {
            viewModel.removeFromLibrary(playlist: playlist)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            viewModel.removeFromStorage(playlist)
            objectToDelete = nil
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
            .environmentObject(LocalLibraryViewModel.preview)
            .previewLayout(.fixed(width: 390.0, height: 500.0))
    }
}
