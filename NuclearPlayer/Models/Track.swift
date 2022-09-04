//
//  Track.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 04.09.2022.
//

import Foundation
import RealmSwift

class Track: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var title: String = ""
    @Persisted var artist: String = ""
    @Persisted var album: String = ""
    @Persisted var duration: Int = 0

    @Persisted var bookmarkData: Data?
    @Persisted var url: String = ""
}

extension Track {
    static func create(url: URL) -> Track {
        let track = Track()
        let ti = TrackInfo(url: url)

        track.url = url.path
        track.title = ti.title
        track.artist = ti.artist
        track.duration = Int(ti.duration.value)

        if (ti.album != nil) {
            track.album = ti.album!
        }

        let bookmarkData = try? url.bookmarkData()
        track.bookmarkData = bookmarkData

        return track
    }

    static func add(url: URL) -> Bool {
        // make sure that files in storage are uniq
        // try go get object
        let obj = RealmController.shared.objects(Track.self).where { track in
            track.url == url.path
        }.first

        if obj != nil {
            return false
        }

        let track = Track.create(url: url)
        RealmController.instance.save(object: track)

        return true
    }

    static func queryObjects() -> Results<Track>? {
        return RealmController.shared.objects(Track.self)
    }
}
