//
//  audio.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 31.08.2022.
//

import UIKit
import AVFoundation
import SwiftAudioPlayer

struct TrackInfo {
    var title: String
    var artist: String
    var album: String?
    var genre: String?
    var artwork: UIImage?
    let duration: Float64
    var year: String?

    init(title: String, artist: String = "", album: String? = nil, genre: String? = nil, artwork: UIImage? = nil, year: String?, duration: Float64) {
        self.title = title
        self.artist = artist
        self.album = album
        self.genre = genre
        self.artwork = artwork
        self.year = year
        self.duration = duration
    }

    init(url: URL) {
        let asset = AVURLAsset(url: url)

        let metadataList = asset.metadata
        self.duration = CMTimeGetSeconds(asset.duration)
        self.title = url.lastPathComponent
        self.artist = ""

        print(url.lastPathComponent, metadataList.count)

        for item in metadataList {
            switch item.identifier {
            case .id3MetadataTitleDescription?:
                if item.stringValue != nil {
                    self.title = item.stringValue!
                }
            case .id3MetadataLeadPerformer?, .id3MetadataBand?, .id3MetadataConductor?, .id3MetadataModifiedBy?:
                if item.stringValue != nil {
                    self.artist = item.stringValue!
                }
            case .id3MetadataContentType?:
                if item.stringValue != nil {
                    self.genre = item.stringValue
                }
            case .id3MetadataAlbumTitle?:
                // id3MetadataOriginalAlbumTitle
                if item.stringValue != nil {
                    self.album = item.stringValue
                }
            case .id3MetadataYear?:
                if item.stringValue != nil {
                    self.year = item.stringValue
                }
            case .id3MetadataAttachedPicture?:
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
        releaseDate: 0)
}
