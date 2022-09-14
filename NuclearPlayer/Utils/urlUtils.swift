//
//  urlUtils.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 04.09.2022.
//

import Foundation

struct URLUtils {
    static func restoreURLFromData(bookmarkData: Data) -> URL {
            // Restore security scoped bookmark
        var bookmarkDataIsStale = false
        let URL = try? URL(resolvingBookmarkData: bookmarkData, bookmarkDataIsStale: &bookmarkDataIsStale)
        print("Please put \(String(describing: URL?.lastPathComponent)) on")
        return URL!
    }

    static func withAcess(to url: URL, body: (_ url: URL) -> Void) {
        let isStartAccess = url.startAccessingSecurityScopedResource()
        body(url)
        if isStartAccess {
            url.stopAccessingSecurityScopedResource()
        }
    }

    static func withAcess(to urldata: Data, body: (_ url: URL) -> Void) {
        let url = restoreURLFromData(bookmarkData: urldata)

        let isStartAccess = url.startAccessingSecurityScopedResource()
        body(url)
        if isStartAccess {
            url.stopAccessingSecurityScopedResource()
        }
    }
}
