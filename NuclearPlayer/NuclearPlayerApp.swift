//
//  NuclearPlayerApp.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI

// TODO move core data logic too class
// TODO Create view model to handle import from different places
// TODO search for core data listener to refresh library after import
// TODO Check if file exists before play
// TODO fix #available(iOS 16.0, *) when move to iOS 16

@main
struct NuclearPlayerApp: App {
    var playlists: PlaylistsViewModel
    var tracks: TracksViewModel
    let library: LibrarySync

    init() {
        playlists = PlaylistsViewModel(realmCtrl: RealmController.instance)
        tracks = TracksViewModel(realmCtrl: RealmController.instance)
        library = LibrarySync(tracksViewModel: tracks, playlistsViewModel: playlists)
        library.subscribeToLibraryUpdates()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(playlists)
                .environmentObject(tracks)
                .environment(\.realm, RealmController.shared)
//                .onAppear {
//                    UITabBar.appearance().isTranslucent = true
//                }
        }

    }
}
