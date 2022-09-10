//
//  OptionalExt.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 10.09.2022.
//

import Foundation

// MARK: - Methods (Collection)
public extension Optional where Wrapped: Collection {
    var isNilOrEmpty: Bool {
        guard let collection = self else { return true }
        return collection.isEmpty
    }

    var nonEmpty: Wrapped? {
        guard let collection = self else { return nil }
        guard !collection.isEmpty else { return nil }
        return collection
    }
}

//extension Optional where Wrapped == String {
//    var isEmpty: Bool {
//        return self?.isEmpty ?? true
//    }
//}

public extension Optional {
    var isPresent: Bool {
        return self != nil
    }

    var isEmpty: Bool {
        return self == nil
    }
}
