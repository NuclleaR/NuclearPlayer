//
//  ContentView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TracksViewModel
    @StateObject var nowPlayingViewModel = NowPlayingViewModel.shared

    var playerHeight = 60.asCGFloat

    var body: some View {
        TabView {
            LibraryView()
//                .padding(.bottom, playerHeight)
                .tabItem {
                    Label("Library", systemImage: "list.bullet")
                }.tag(1)
            PlaylistsView()
//                .padding(.bottom, playerHeight)
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }.tag(2)
        }
        .overlay(alignment: .bottom, content: {
            MiniPlayer()
        })
        .overlay(content: {
            if nowPlayingViewModel.isPlayerOpened {
                PlayerView()
            }
        })
        .fileImporter(
            isPresented: $viewModel.isImporting,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: true,
            onCompletion: viewModel.importFiles
        )
        .environmentObject(nowPlayingViewModel)
    }

    @ViewBuilder
    private func MiniPlayer() -> some View {
        MiniPlayerView(
            track: nowPlayingViewModel.track,
            height: playerHeight,
            isPlaying: nowPlayingViewModel.isPlaying,
            onPlay: nowPlayingViewModel.togglePlayPause,
            onNext: nowPlayingViewModel.playNext,
            onOpenPlayer: {
                withAnimation {
                    nowPlayingViewModel.togglePlayer()
                }
            }
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(TracksViewModel(realmCtrl: RealmController.previewRealm))
            .environmentObject(PlaylistsViewModel(realmCtrl: RealmController.previewRealm))
    }
}
