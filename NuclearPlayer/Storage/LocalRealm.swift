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

    #if DEBUG
    static var previewRealm: Realm {
        let identifier = "previewRealm"
        let ctrl = RealmController(inMemoryIdentifier: identifier)

        do {
            let realmObjects = ctrl.realm.objects(Track.self)
            if realmObjects.count == 1 {
                return ctrl.realm
            } else {
                try ctrl.realm.write {
                    for i in 0..<10 {
                        let newItem = Track()
                        newItem.url = "/local/file-\(i).mp3"
                        newItem.title = "Title \(i)"
                        newItem.isPreview = true
                        ctrl.realm.add(newItem)
                    }
                }
                return ctrl.realm
            }
        } catch let error {
            fatalError("Can't bootstrap item data: \(error.localizedDescription)")
        }
    }
    #endif
}
