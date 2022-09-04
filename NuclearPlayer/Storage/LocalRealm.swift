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

    init(inMemory: Bool = false) {
        // TODO add inMemory for SwiftUI preview
        do {
            // Delete the realm if a migration would be required, instead of migrating it.
            // While it's useful during development, do not leave this set to `true` in a production app!
            let configuration = Realm.Configuration(
                schemaVersion: 0,
                deleteRealmIfMigrationNeeded: true
            )
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
}
