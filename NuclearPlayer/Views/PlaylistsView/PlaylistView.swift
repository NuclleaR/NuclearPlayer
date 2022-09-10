//
//  PlaylistView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI
import CoreData
import SwiftAudioPlayer

struct PlaylistView: View {
    @EnvironmentObject var viewModel: LocalLibraryViewModel
    var playlist: Playlist

    var body: some View {
        List {
            ForEach(playlist.tracks, id: \.id) { item in
                TrackView(track: item)
//                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
//                        Button(role: ButtonRole.destructive) {
//                            withAnimation {
//                                viewModel.removeFromLibrary(track: item)
//                            }
//                        } label: {
//                            Image(systemName: "trash")
//                        }
//                    }
//                    .onDisappear {
//                        viewModel.removeFromStorage(item)
//                    }
            }
        }.listStyle(.plain)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(
            playlist: RealmController.getPlaylist()
        )
            .environmentObject(LocalLibraryViewModel.preview)
            .previewLayout(.sizeThatFits)
    }
}
