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
    public static let shared: LocalLibraryViewModel = LocalLibraryViewModel()

    private let realm: Realm

    // MARK: - data fields
    @Published private(set) var tracks: [Track] = []
//    @Published private(set) var playlists: [Playlist] = []

    private init(realm: Realm = RealmController.shared) {
        // TODO add error if no realm
        self.realm = realm

        fetchTracks()
        initDataFromStore()
        // TODO fetch playlists
    }
}

// MARK: - fetch library data
extension LocalLibraryViewModel {
    fileprivate func fetchTracks() {
        let fileManager = FileManager.default

        guard let tracksResult = Track.queryObjects() else { return }

        self.tracks = tracksResult.filter({ track in
            guard let bookmarkData = track.bookmarkData else {
                    // Delete track from storage if url not valid
                    // context.delete(track)
                return false
            }
            let url = URLUtils.restoreURLFromData(bookmarkData: bookmarkData)
            let isExists = fileManager.fileExists(atPath: url.path)

            if !isExists {
                    // Delete track from storage if not exists anymore
                    // context.delete(track)
            }
            return isExists
        })
    }

//    fileprivate func fetchPlaylists() {
//        do {
//            self.playlists = try context.fetch(Playlist.fetchRequest())
//        } catch {
//            let nsError = error as NSError
//            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//        }
//    }
}

// MARK: - Manage queue
extension LocalLibraryViewModel {
    func addToQueue(_ url: URL) {
        saveData(url)
    }

    func addToQueue(_ string: String) {
        guard let url = URL(string: string) else {
            print("Can't create url for", string)
            return
        }
        saveData(url)
    }

    func addToQueue(fileURLWithPath path: String) {
        let url = URL(fileURLWithPath: path)
        saveData(url)
    }

    private func addSavedToQueue(url: URL) {
        if tracks.count < 2 {
            SAPlayer.shared.startSavedAudioWithPrevQueue(withSavedUrl: url, mediaInfo: getSALockScreenInfo(url: url))
        } else {
            SAPlayer.shared.queueSavedAudio(withSavedUrl: url, mediaInfo: getSALockScreenInfo(url: url))
            print("queue: \(SAPlayer.shared.audioQueued)")
        }
    }
}

// MARK: - Persist data
extension LocalLibraryViewModel {
    private func saveData(_ url: URL) {
        let isStartAccess = url.startAccessingSecurityScopedResource()

        let isSaved = Track.add(url: url)
        if isSaved {
            // TODO do we need fetch?
            self.fetchTracks()
            addSavedToQueue(url: url)
        }
        if isStartAccess {
            url.stopAccessingSecurityScopedResource()
        }
    }

    private func initDataFromStore() {
        self.tracks.enumerated().forEach { (index, track) in
            guard let urlData = track.bookmarkData else { return }
            let url = URLUtils.restoreURLFromData(bookmarkData: urlData)

            let isStartAccess = url.startAccessingSecurityScopedResource()

            let mediaInfo = getSALockScreenInfo(url: url)
            if index == 0 {
                SAPlayer.shared.startSavedAudioWithPrevQueue(withSavedUrl: url, mediaInfo: mediaInfo)
            } else {
                SAPlayer.shared.queueSavedAudio(withSavedUrl: url, mediaInfo: mediaInfo)
            }
            if isStartAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }
    }
}

// MARK: - debug data
extension LocalLibraryViewModel {
#if DEBUG
//    public static let preview: LocalLibraryViewModel = LocalLibraryViewModel(realm: PersistenceController.preview.container.viewContext)
#endif
}