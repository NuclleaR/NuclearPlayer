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

class LocalLibraryViewModel: ObservableObject {
    public static let shared: LocalLibraryViewModel = LocalLibraryViewModel(realmCtrl: RealmController.instance)

    private let realmCtrl: RealmController
    private let player = SAPlayer.shared

    // MARK: - data fields
    @Published private(set) var tracks: [Track] = []
    @Published private(set) var playlists: [Playlist] = []

    private init(realmCtrl: RealmController) {
        self.realmCtrl = realmCtrl

        fetchTracks()
        fetchPlaylists()

        // Initialize player
        initDataFromStore()
    }
}

// MARK: - fetch library data
extension LocalLibraryViewModel {
    fileprivate func fetchTracks() {
        guard let tracksResult = Track.queryObjects(realm: realmCtrl.realm) else { return }
        self.tracks = Array(tracksResult)
    }

    // Mutate tracks collection
    private func filterTracks() {
        let fileManager = FileManager.default

        self.tracks = self.tracks
            .filter({ track in
                guard let bookmarkData = track.bookmarkData else {
                    return false
                }
                let url = URLUtils.restoreURLFromData(bookmarkData: bookmarkData)
                let isExists = fileManager.fileExists(atPath: url.path)

                return isExists
            })
    }

    fileprivate func fetchPlaylists() {
        guard let tracksResult = Playlist.queryObjects(realm: realmCtrl.realm) else { return }
        self.playlists = Array(tracksResult)
    }
}

// MARK: - Manage Library
extension LocalLibraryViewModel {
    func handleFiles(result: Result<[URL], Error>) {
        do {
            let files = try result.get()
            files.forEach { url in
                addToLibrary(url: url)
            }
        } catch {
            // Handle failure.
            print("Unable to read file contents")
            print(error.localizedDescription)
        }
    }

    func addToLibrary(url: URL) {
        let isStartAccess = url.startAccessingSecurityScopedResource()

        let (isSaved, track) = Track.add(url: url)
        if isSaved {
            self.tracks.append(track!)
            addSavedToQueue(url: url)
        }

        if isStartAccess {
            url.stopAccessingSecurityScopedResource()
        }
    }

    func addToLibrary(title: String) {
        let (isSaved, playlist) = Playlist.add(title)

        if isSaved {
            self.playlists.append(playlist!)
        }
    }

    func removeFromLibrary(track: Track) {
        // Clear tracks
        tracks.removeAll(where: { $0.id == track.id })

        // Clear now playing queue
        if player.playedQueue.last?.url.path == track.url {
            player.playedQueue.removeLast()
            player.clear()
            player.next()
        } else {
            player.playedQueue = player.playedQueue.filter({ $0.url.path != track.url })
            player.audioQueued = player.audioQueued.filter({ $0.url.path != track.url })
        }
    }

    func removeFromStorage(track: Track) {
        // Remove item from realm
        realmCtrl.remove(object: track)
    }

    private func addSavedToQueue(url: URL) {
        if tracks.count < 2 {
            player.startSavedAudioWithPrevQueue(withSavedUrl: url, mediaInfo: getSALockScreenInfo(url: url))
        } else {
            player.queueSavedAudio(withSavedUrl: url, mediaInfo: getSALockScreenInfo(url: url))
            print("queue: \(player.audioQueued)")
        }
    }
}

// MARK: - Persist data
extension LocalLibraryViewModel {
    private func initDataFromStore() {
        self.tracks.enumerated().forEach { (index, track) in
            guard let urlData = track.bookmarkData else { return }
            let url = URLUtils.restoreURLFromData(bookmarkData: urlData)

            let isStartAccess = url.startAccessingSecurityScopedResource()

            let mediaInfo = getSALockScreenInfo(url: url)
            if index == 0 {
                player.startSavedAudioWithPrevQueue(withSavedUrl: url, mediaInfo: mediaInfo)
            } else {
                player.queueSavedAudio(withSavedUrl: url, mediaInfo: mediaInfo)
            }
            if isStartAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
}

#if DEBUG
// MARK: - debug data
extension LocalLibraryViewModel {
    public static let preview: LocalLibraryViewModel = LocalLibraryViewModel(realmCtrl: RealmController.previewRealm)
}
#endif
