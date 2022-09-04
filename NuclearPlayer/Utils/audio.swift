//
//  audio.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 31.08.2022.
//

import UIKit
import AVFoundation
import SwiftAudioPlayer
import ID3TagEditor

struct TrackInfo {
    private static let id3TagEditor = ID3TagEditor()

    var title: String
    var artist: String
    var album: String?
    var genre: String?
    var artwork: UIImage?
    let duration: CMTime
    var year: Date?

    init(title: String, artist: String = "", album: String? = nil, genre: String? = nil, artwork: UIImage? = nil, year: Date?, duration: CMTime) {
        self.title = title
        self.artist = artist
        self.album = album
        self.genre = genre
        self.artwork = artwork
        self.year = year
        self.duration = duration
    }

    init(url: URL) {
        var res: ID3Tag?
        do {
            res = try TrackInfo.id3TagEditor.read(from: url.path)
        } catch {
            AppLogger.shared.error("Can't parse ID3 tag")
        }

        let playerItem = AVPlayerItem(url: url)
        let metadataList = playerItem.asset.metadata
        self.duration = playerItem.duration
        self.title = url.lastPathComponent
        self.artist = ""

        print(url.lastPathComponent, metadataList)
        print(url.lastPathComponent, res)

        for item in metadataList {
            switch item.identifier {
            case .commonIdentifierTitle?:
                if item.stringValue != nil {
                    self.title = item.stringValue!
                }
            case .commonIdentifierType?:
                self.genre = item.stringValue
            case .commonIdentifierAlbumName?:
                self.album = item.stringValue
            case .commonIdentifierArtist?:
                if item.stringValue != nil {
                    self.artist = item.stringValue!
                }
            case .id3MetadataYear?:
                self.year = item.dateValue
            case .commonIdentifierArtwork?:
                if let data = item.dataValue, let image = UIImage(data: data) {
                    // info.artwork = MPMediaItemArtwork(boundsSize: image.size) { _ in image }
                    self.artwork = image
                }
            case .none: break
            default: break
            }
        }
    }

    static func parseTitle(url: URL) -> String {
        let playerItem = AVPlayerItem(url: url)
        let metadataList = playerItem.asset.metadata

        guard let metadataItem = metadataList
            .first(where: { $0.commonKey == .commonKeyTitle }) else { return url.lastPathComponent }

        return metadataItem.stringValue ?? url.lastPathComponent
    }
}

func getSALockScreenInfo(url: URL) -> SALockScreenInfo {
    let trackInfo = TrackInfo(url: url)

    return SALockScreenInfo(
        title: trackInfo.title,
        artist: trackInfo.artist,
        albumTitle: trackInfo.album,
        artwork: trackInfo.artwork,
        releaseDate: trackInfo.year != nil ? UTC(trackInfo.year!.timeIntervalSince1970) : UTC.init())
}
