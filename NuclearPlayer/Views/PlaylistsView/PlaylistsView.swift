    //
    //  PlaylistsView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 04.09.2022.
    //

import SwiftUI

struct PlaylistsView: View {
    @EnvironmentObject var viewModel: LocalLibraryViewModel

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.playlists, id: \.self) { playlist in
                    NavigationLink(
                        destination:
                            PlaylistView(playlist: playlist)
                            .navigationTitle(playlist.title),
                        label: {
                            HStack {
                                Text(playlist.title)
                                Spacer()
                                Text(String(playlist.tracks.count))
                            }
                        })
                        // .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .navigationTitle("Playlists")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    AddPlaylistVew(self.addToLibrary)
                }
            })
        }.navigationViewStyle(.stack)
    }

    private func addToLibrary(title: String) {
        viewModel.addToLibrary(title: title)
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
            .environmentObject(LocalLibraryViewModel.preview)
            .previewLayout(.fixed(width: 390.0, height: 500.0))
    }
}
