//
//  TracksViewModel.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 10.09.2022.
//

import Foundation
import RealmSwift

class TracksViewModel: ObservableObject {
    // MARK: - data fields
    private var realmCtrl: RealmController

    @Published private(set) var tracks: Results<Track>
    @Published var isImporting = false

    init(realmCtrl: RealmController) {
        self.realmCtrl = realmCtrl
        self.tracks = Track.queryObjects(realm: realmCtrl.realm)
    }
}

// MARK: - manage data
extension TracksViewModel {
    func fetchTracks() {
        self.tracks = Track.queryObjects(realm: realmCtrl.realm)
    }

    func importFiles(result: Result<[URL], Error>) {
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
        // make sure that files in storage are uniq
        // try go get object
        let result = RealmController.shared.objects(Track.self).filter(NSPredicate(format: "url == %@", url.lastPathComponent))

        if !result.isEmpty { return }

        var track: Track?

        track = Track.create(url: url)

        realmCtrl.write {
            realmCtrl.realm.add(track!)
            fetchTracks()
        }
    }

    func removeFromLibrary(id: ObjectId) {
        let trackToDelete = realmCtrl.realm.objects(Track.self).filter(NSPredicate(format: "id == %@", id))
        guard !trackToDelete.isEmpty else { return }

        realmCtrl.write {
            realmCtrl.realm.delete(trackToDelete)
            fetchTracks()
        }
    }
}
