//
//  Track+CoreDataProperties.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 04.09.2022.
//
//

import Foundation
import CoreData


extension Track {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Track> {
        return NSFetchRequest<Track>(entityName: "Track")
    }

    @NSManaged public var title: String?
    @NSManaged public var url: String?
    @NSManaged public var bookmarkData: Data?
    @NSManaged public var playlists: NSSet?

}

// MARK: Generated accessors for playlists
extension Track {

    @objc(addPlaylistsObject:)
    @NSManaged public func addToPlaylists(_ value: Playlist)

    @objc(removePlaylistsObject:)
    @NSManaged public func removeFromPlaylists(_ value: Playlist)

    @objc(addPlaylists:)
    @NSManaged public func addToPlaylists(_ values: NSSet)

    @objc(removePlaylists:)
    @NSManaged public func removeFromPlaylists(_ values: NSSet)

}

extension Track : Identifiable {

}
