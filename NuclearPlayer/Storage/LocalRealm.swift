//
//  LocalRealm.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 04.09.2022.
//

import Foundation
import RealmSwift

class RealmController {
    static let shared = RealmController().realm
    static let instance = RealmController()

    private(set) var realm: Realm

    init(inMemoryIdentifier: String? = nil) {
        // TODO add inMemory for SwiftUI preview
        do {
            // Delete the realm if a migration would be required, instead of migrating it.
            // While it's useful during development, do not leave this set to `true` in a production app!
            var configuration = Realm.Configuration(
                schemaVersion: 0,
                deleteRealmIfMigrationNeeded: true
            )
            if inMemoryIdentifier != nil {
                configuration.inMemoryIdentifier = inMemoryIdentifier
            }
            self.realm = try Realm(configuration: configuration)
        } catch {
            fatalError("Error opening realm: \(error.localizedDescription)")
        }
        #if DEBUG
        print("REALM URL", realm.configuration.fileURL as Any)
        #endif
    }

    func save(object: Object) {
        // TODO Prepare to handle exceptions.
        do {
            // Open a thread-safe transaction.
            try realm.write {
                realm.add(object)
            }
        } catch let error as NSError {
            // Failed to write to realm.
            // ... Handle error ...
            print(error)
        }
    }

    func remove(object: Object) {
        // TODO Prepare to handle exceptions.
        do {
            // Open a thread-safe transaction.
            try realm.write {
                realm.delete(object)
            }
        } catch let error as NSError {
            // Failed to write to realm.
            // ... Handle error ...
            print(error)
        }
    }

    func removeUncommited(object: Object) {
        realm.beginWrite()
        realm.delete(object)
    }
}

#if DEBUG
fileprivate func getTracks() -> [Track] {
    var tracks = [Track]()
    for i in 0..<10 {
        let newItem = Track()
        newItem.url = "/local/file-\(i).mp3"
        newItem.title = "Title \(i)"
        newItem.artist = "Artist \(i)"

        tracks.append(newItem)
    }
    return tracks
}

fileprivate func getPlaylistsWithTracks() -> ([Playlist], [Track]) {
    let tracks = getTracks()

    var playlists =  [Playlist]()

    for i in 1...5 {
        let playlist = Playlist()
        playlist.title = "Playlist \(i)"
        playlist.tracks = List<Track>()
        for _ in 1...Int.random(in: 1...6) {
            playlist.tracks.append(tracks[Int.random(in: 0..<tracks.count - 1)])
        }

        playlists.append(playlist)
    }

    return (playlists, tracks)
}

extension RealmController {
    static var previewRealm: RealmController = {
        let identifier = "previewRealm"
        let ctrl = RealmController(inMemoryIdentifier: identifier)

        let (playlists, tracks) = getPlaylistsWithTracks()

        do {
            try ctrl.realm.write {
                tracks.forEach { track in
                    ctrl.realm.add(track)
                }
            }
            try ctrl.realm.write {
                playlists.forEach { playlist in
                    ctrl.realm.add(playlist)
                }
            }

            return ctrl
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }()

    static func getPlaylist() -> Playlist {
        return previewRealm.realm.objects(Playlist.self).first ?? Playlist()
    }

    static func getTrack() -> Track {
        return previewRealm.realm.objects(Track.self).first!
    }
}
#endif
