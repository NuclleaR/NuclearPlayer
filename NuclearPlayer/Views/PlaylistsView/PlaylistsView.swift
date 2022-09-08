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
                ForEach(viewModel.playlists, id: \.id) { playlist in
                    NavigationLink(destination: Text("View"), label: {
                        HStack {
                            Text(playlist.title)
                            Spacer()
                            Text(String(playlist.tracks.count))
                        }
                    })
                }
            }
            .listStyle(.plain)
            .navigationTitle("Playlists")
            .navigationBarItems(trailing:AddPlaylistVew({ title in
                viewModel.addToLibrary(title: title)
            }))
        }
    }
}

struct PlaylistsView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistsView()
            .environmentObject(LocalLibraryViewModel.preview)
            .previewLayout(.sizeThatFits)
    }
}
