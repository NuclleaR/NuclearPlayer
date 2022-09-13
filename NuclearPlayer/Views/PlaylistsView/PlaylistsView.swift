    //
    //  PlaylistsView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 04.09.2022.
    //

import SwiftUI

struct PlaylistsView: View {
    @EnvironmentObject var viewModel: PlaylistsViewModel
    @State fileprivate var showingDeleteAlert = false
    @State fileprivate var objectToDelete: Playlist?

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.playlists.freeze()) { playlist in
                    PlaylistItem(playlist.freeze())
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

    @ViewBuilder
    private func PlaylistItem(_ playlist: Playlist) -> some View {
        NavigationLink {
            PlaylistView(playlist: playlist)
        } label: {
            HStack {
                Text(playlist.title)
                Spacer()
                Text(String(playlist.tracks.count))
            }
        }
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

// MARK: - Handlers
extension PlaylistsView {
    fileprivate func addToLibrary(title: String) {
        viewModel.createPlaylist(with: title)
    }

    fileprivate func handleRemove() {
        guard let playlist = objectToDelete else { return }
        withAnimation {
            viewModel.removePlaylist(id: playlist.id)
            objectToDelete = nil
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
            .environmentObject(PlaylistsViewModel(realmCtrl: RealmController.previewRealm))
            .previewLayout(.fixed(width: 390.0, height: 500.0))
    }
}
