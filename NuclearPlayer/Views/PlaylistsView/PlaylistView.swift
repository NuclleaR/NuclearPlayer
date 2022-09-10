    //
    //  PlaylistView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 30.08.2022.
    //

import SwiftUI
import CoreData
import SwiftAudioPlayer
import RealmSwift

struct PlaylistView: View {
    @EnvironmentObject var viewModel: LocalLibraryViewModel
    @StateRealmObject var playlist: Playlist

    @State var showingPopover = false

    var body: some View {
        List {
            ForEach(playlist.tracks, id: \.id) { item in
                TrackView(track: item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.removeFromLibrary(track: item)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    //                    .onDisappear {
                    //                        viewModel.removeFromStorage(item)
                    //                    }
            }
        }
        .listStyle(.plain)
        .navigationTitle(playlist.title)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingPopover.toggle()
                }, label: {
                    Image(systemName: "plus.circle.fill")
                })
            }
        })
        .popover(isPresented: $showingPopover) {
            AddToPlaylistView({ selected in
                viewModel.addToPlaylist(playlist, tracks: selected)
                showingPopover = false
            }, {
                showingPopover = false
            })
        }
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
