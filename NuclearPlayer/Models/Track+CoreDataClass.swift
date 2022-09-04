//
//  Track+CoreDataClass.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 31.08.2022.
//
//

import Foundation
import CoreData

@objc(Track)
public class Track: NSManagedObject {
    static func create(url: URL, context: NSManagedObjectContext) -> Track {
        let track = Track(context: context)

        track.url = url.path
        track.title = TrackInfo.parseTitle(url: url)

        let bookmarkData = try? url.bookmarkData()
        track.bookmarkData = bookmarkData

        return track
    }

    static func add(url: URL, context: NSManagedObjectContext) -> Track {
        let track = Track.create(url: url, context: context)

        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return track
    }
}
