//
//  Sources.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import Foundation
import Combine
import SwiftAudioPlayer
import CoreData
import RealmSwift

// Class that observe nodels and sync data
class LibrarySync {
    var notificationToken: NotificationToken?

    private let tracksViewModel: TracksViewModel
    private let playlistsViewModel: PlaylistsViewModel

    init(tracksViewModel: TracksViewModel, playlistsViewModel: PlaylistsViewModel) {
        self.tracksViewModel = tracksViewModel
        self.playlistsViewModel = playlistsViewModel
    }

    deinit {
        print("deinit LibrarySync")
        notificationToken = nil
    }
}

// MARK: - sync library data
extension LibrarySync {
    func subscribeToLibraryUpdates() {
        notificationToken = tracksViewModel.tracks.observe { [weak self] (changes: RealmCollectionChange) in
            switch changes {
            case .initial: break
            case .update(_, let deletions, _, _):
                if deletions.count > 0 {
                    self?.playlistsViewModel.fetchPlaylists()
                }
            case .error(let error):
                // An error occurred while opening the Realm file on the background worker thread
                fatalError("\(error)")
            }
        }
    }
}
