//
//  PlaylistsViewModel.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 10.09.2022.
//

import Foundation
import RealmSwift

class PlaylistsViewModel: ObservableObject {
    // MARK: - data fields
    private var realmCtrl: RealmController

    @Published private(set) var playlists: Results<Playlist>

    init(realmCtrl: RealmController) {
        self.realmCtrl = realmCtrl
        self.playlists = Playlist.queryObjects(realm: realmCtrl.realm)
    }
}

// MARK: - manage data
extension PlaylistsViewModel {
    func fetchPlaylists() {
        playlists = Playlist.queryObjects(realm: realmCtrl.realm)
    }

    func createPlaylist(with title: String) {
        let playlist = Playlist()
        playlist.title = title

        realmCtrl.write {
            realmCtrl.realm.add(playlist)
            fetchPlaylists()
        }
    }

    func updatePlaylist<Tracks: Collection>(id: ObjectId, title: String? = nil, tracks: Tracks? = nil) where Tracks.Element == Track {
        let playlistToUpdate = realmCtrl.realm.objects(Playlist.self).filter(NSPredicate(format: "id == %@", id))
        guard let playlist = playlistToUpdate.first else { return }

        realmCtrl.write {
            if title.isPresent {
                playlist.title = title!
            }
            if tracks.isNotEmpty {
                playlist.tracks = List<Track>()
                playlist.tracks.append(objectsIn: tracks!)
            }
            fetchPlaylists()
        }
    }

    func clearPlaylist(id: ObjectId) {
        let playlistToUpdate = realmCtrl.realm.objects(Playlist.self).filter(NSPredicate(format: "id == %@", id))
        guard let playlist = playlistToUpdate.first else { return }

        realmCtrl.write {
            playlist.tracks.removeAll()
            fetchPlaylists()
        }
    }

    func removePlaylist(id: ObjectId) {
        let playlistToDelete = realmCtrl.realm.objects(Playlist.self).filter(NSPredicate(format: "id == %@", id))
        guard !playlistToDelete.isEmpty else { return }

        realmCtrl.write {
            realmCtrl.realm.delete(playlistToDelete)
            fetchPlaylists()
        }
    }

    func addTracksToPlaylist<Tracks: Collection>(id: ObjectId, tracks: Tracks) where Tracks.Element == Track {
        let playlistToUpdate = realmCtrl.realm.objects(Playlist.self).filter(NSPredicate(format: "id == %@", id))
        guard let playlist = playlistToUpdate.first else { return }

        realmCtrl.write {
            tracks.forEach { track in
                if playlist.tracks.contains(where: { $0.id == track.id }) { return }
                playlist.tracks.append(track)
            }
            fetchPlaylists()
        }
    }

    func removeTrackFromPlaylist(id: ObjectId, trackId: ObjectId) {
        let playlistToUpdate = realmCtrl.realm.objects(Playlist.self).filter(NSPredicate(format: "id == %@", id))
        guard let playlist = playlistToUpdate.first else { return }

        if let index = playlist.tracks.firstIndex(where: { $0.id == trackId }) {
            realmCtrl.write {
                playlist.tracks.remove(at: index)
                fetchPlaylists()
            }
        }
    }
}
