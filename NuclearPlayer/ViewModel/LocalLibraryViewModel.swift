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
    @Published var isImporting = false

    private init(realmCtrl: RealmController) {
        self.realmCtrl = realmCtrl

        fetchTracks()
        fetchPlaylists()
    }
}

// MARK: - fetch library data
extension LocalLibraryViewModel {
    fileprivate func fetchTracks() {
        let tracksResult = Track.queryObjects(realm: realmCtrl.realm)
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
        let tracksResult = Playlist.queryObjects(realm: realmCtrl.realm)
        self.playlists = Array(tracksResult)
    }
}

// MARK: - Manage Library, Persist the data
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

        let (isSaved, track) = Track.add(url: url, ctrl: realmCtrl)
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

    func removePlaylistFromLibrary(indexSet: IndexSet) {
        let removed = self.playlists.removeObjects(at: indexSet)
        // remove after animation
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            removed.forEach { object in
//                self.realmCtrl.remove(object: object)
//            }
//        }
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

    func removeFromLibrary(playlist: Playlist) {
        playlists.removeAll(where: { $0.id == playlist.id })
        // TODO Check if playlist now playing
    }

    func removeFromStorage(_ obj: Object) {
        // Remove item from realm
        realmCtrl.remove(object: obj)
    }

    func addToPlaylist(_ playlist: Playlist, track: Track) {
        realmCtrl.update {
            playlist.tracks.append(track)
        }
    }

    func addToPlaylist(_ playlist: Playlist, tracks: Set<Track>) {
        realmCtrl.update {
            playlist.tracks = List<Track>()
            playlist.tracks.append(objectsIn: tracks)
        }
//        let toUpdate = playlists.first { $0.id == playlist.id }!
//        toUpdate.tracks = playlist.tracks
    }

    func removeFromPlaylist(_ playlist: Playlist, at indexSet: IndexSet) {
        realmCtrl.update {
            playlist.tracks.remove(atOffsets: indexSet)
        }
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

// MARK: - Init player
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

extension Array where Element: Object {
    mutating func removeObjects(at indexSet: IndexSet) -> [Object] {
        return indexSet.reduce(into: [Object]()) { partialResult, index in
            let element = self.remove(at: index)
            partialResult.append(element)
        }
    }
}
