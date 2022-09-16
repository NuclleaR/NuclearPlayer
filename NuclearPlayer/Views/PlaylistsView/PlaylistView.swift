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
    @EnvironmentObject var nowPlaying: NowPlayingViewModel
    @StateRealmObject var playlist: Playlist

    @State var showingPopover = false

    var body: some View {
        VStack {
            if playlist.tracks.count > 0 {
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
            } else {
                VStack(spacing: 30.0) {
                    Image(systemName: "rectangle.stack.badge.plus")
                        .font(.system(size: 64))
                    Text("Playlist is empty. Please add tracks")
                }.opacity(0.3)
            }
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
        nowPlaying.setPlayQueue(with: playlist)
    }

    private func shufflePlay() {

    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(
            playlist: RealmController.getPlaylist()
        )
        .environmentObject(PlaylistsViewModel(realmCtrl: RealmController.previewRealm))
        .previewLayout(.sizeThatFits)
    }
}
