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
extension RealmController {
    static let tracks: [Track] = {
        var tracks: [Track] = []
        for i in 0..<10 {
            let newItem = Track()
            newItem.url = "/local/file-\(i).mp3"
            newItem.title = "Title \(i)"
//            newItem.artist = "Artist \(i)"
            newItem.isPreview = true

            tracks.append(newItem)
        }
        return tracks
    }()

    static var previewRealm: RealmController {
        let identifier = "previewRealm"
        let ctrl = RealmController(inMemoryIdentifier: identifier)

        do {
            let tracks = ctrl.realm.objects(Track.self)
            let playlists = ctrl.realm.objects(Playlist.self)

            if tracks.count > 0 && playlists.count > 0 {
                return ctrl
            } else {
                try ctrl.realm.write {
                    for i in 0..<10 {
                        let newItem = Track()
                        newItem.url = "/local/file-\(i).mp3"
                        newItem.title = "Title \(i)"
                        newItem.artist = "Artist \(i)"
                        newItem.isPreview = true
                        ctrl.realm.add(newItem)
                    }
                }

                try ctrl.realm.write {
                    let tracks = ctrl.realm.objects(Track.self)
                    for i in 0..<5 {

                        let newItem = Playlist()
                        newItem.title = "Playlist \(i)"
                        newItem.tracks = List<Track>()
                        for _ in 1...3 {
                            newItem.tracks.append(tracks[Int.random(in: 0..<tracks.count)])
                        }
                        ctrl.realm.add(newItem)
                    }
                }

                return ctrl
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
}
#endif
