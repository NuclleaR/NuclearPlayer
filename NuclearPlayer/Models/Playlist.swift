//
//  Playlist.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 08.09.2022.
//

import Foundation
import RealmSwift

class Playlist: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var tracks: List<Track>
}

extension Playlist: Identifiable {
    static func add(_ title: String, ctrl: RealmController = RealmController.instance) -> (Bool, Playlist?) {
        // make sure that playlist name uniq
        // try go get object
        let obj = RealmController.shared.objects(Playlist.self).filter(NSPredicate(format: "title == %@", title)).first

        if obj != nil {
            return (false, nil)
        }
        let playlist = Playlist()
        playlist.title = title

        ctrl.save(object: playlist)

        return (true, playlist)
    }

    static func queryObjects(realm: Realm) -> Results<Playlist> {
        return realm.objects(Playlist.self)
    }
}
