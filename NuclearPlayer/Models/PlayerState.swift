    //
    //  PlayerState.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 16.09.2022.
    //

import Foundation
import RealmSwift

class PlayerState: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var position: Double
    @Persisted var track: Track?
    @Persisted var tracks: List<Track>
    @Persisted var loop: Int = 0 // off; 1 = one track; 2 = all
}

extension PlayerState {
    static func getState(realm: Realm) -> PlayerState {
        if let state = realm.objects(PlayerState.self).first {
            return state
        }

        var newState = PlayerState()
        do {
            try realm.write {
                realm.add(newState)
                newState = realm.objects(PlayerState.self).last!
            }
            return newState
        } catch {
            print("Error in transaction: \(error.localizedDescription)")
            return newState
        }
    }

    static func update(ctrl: RealmController, position: Double? = nil, trackId: ObjectId? = nil, tracks: List<Track>? = nil) {
        guard let state = ctrl.realm.objects(PlayerState.self).first else { return }
        let allTracks = ctrl.realm.objects(Track.self)

        ctrl.update {
            if position.isPresent {
                state.position = position!
            }
            if trackId.isPresent {
                state.track = ctrl.realm.object(ofType: Track.self, forPrimaryKey: trackId)
            }
            if tracks.isNotEmpty {
                state.tracks.removeAll()
                // TODO shity code that IDK how to avoid
                tracks?.forEach({ track in
                    if let trackToAdd = allTracks.first(where: { $0.id == track.id }) {
                        state.tracks.append(trackToAdd)
                    }
                })
            }
        }
    }
}
