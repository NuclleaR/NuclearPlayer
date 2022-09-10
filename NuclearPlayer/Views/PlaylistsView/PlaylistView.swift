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
    @EnvironmentObject var viewModel: PlaylistsViewModel
    @StateRealmObject var playlist: Playlist

    @State var showingPopover = false

    var body: some View {
        VStack {
            HStack {
                Button(action: startPlay) {
                    Image(systemName: "play.circle.fill")
                        .font(.system(size: 48))
                }.tint(.green)
                Button(action: shufflePlay) {
                    Label("Shuffle", systemImage: "shuffle")
                }
                .buttonStyle(.borderedProminent)
                .clipShape(Capsule())
                .tint(.green)
                Spacer()
            }.padding()
            List(playlist.tracks.freeze()) { item in
                TrackView(track: item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: .destructive) {
                            withAnimation {
                                viewModel.removeTrackFromPlaylist(id: playlist.id, trackId: item.id)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
            }
            .listStyle(.plain)
        }
        .navigationTitle(playlist.title)
        .toolbar(content: {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: togglePopover, label: {
                    Image(systemName: "plus.circle.fill")
                })
            }
        })
        .popover(isPresented: $showingPopover) {
            AddToPlaylistView(handleSave, togglePopover)
        }
    }

    private func handleSave(_ selected: Set<Track>) {
        viewModel.addTracksToPlaylist(id: playlist.id, tracks: selected)
        showingPopover = false
    }

    private func togglePopover() {
        showingPopover.toggle()
    }

    private func startPlay() {

    }

    private func shufflePlay() {

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
