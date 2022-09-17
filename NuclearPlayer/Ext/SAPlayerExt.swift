//
//  SAPlayerExt.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 02.09.2022.
//

import Foundation
import SwiftAudioPlayer

extension SAPlayer {
    private static var _playedQueue = [SAAudioQueueItem]()

    var playedQueue: [SAAudioQueueItem] {
        get {
            return SAPlayer._playedQueue
        }
        set(newValue) {
            SAPlayer._playedQueue = newValue
        }
    }

    func next() {
        // Check if we have something in queue
        guard audioQueued.count > 0 else { return }
        // Getting next audio
        let nextAudioURL = audioQueued.removeFirst()
        // Start access to resource
        var isStartAccess = false
        // Clear player state
        clear()
        // Setting new media info for lockscreen
        mediaInfo = nextAudioURL.mediaInfo
        // add played audio to played queue to have eability to play prev audio
        playedQueue.append(nextAudioURL)
        // Init player with new source
        switch nextAudioURL.loc {
        case .remote:
            startRemoteAudio(withRemoteUrl: nextAudioURL.url, bitrate: nextAudioURL.bitrate, mediaInfo: nextAudioURL.mediaInfo)
            break
        case .saved:
            isStartAccess = nextAudioURL.url.startAccessingSecurityScopedResource()
            startSavedAudio(withSavedUrl: nextAudioURL.url, mediaInfo: nextAudioURL.mediaInfo)
            break
        }
        // stop access to resource
        if isStartAccess {
            nextAudioURL.url.stopAccessingSecurityScopedResource()
        }
        // Start playback
        play()
    }

    func prev() {
        // Check if we have something in queue
        guard playedQueue.count > 1 else { return }
        // Getting previous audio
        let nextAudioURL = playedQueue.removeLast()
        // Clear player state
        clear()
        // append to next queue
        audioQueued.insert(nextAudioURL, at: 0)
        //setup new source
        let currentAudioURL = playedQueue.last! // Have to be at least one element
        // Start access to resource
        var isStartAccess = false
        // Setting new media info for lockscreen
        mediaInfo = currentAudioURL.mediaInfo
        // Init player with new source
        switch currentAudioURL.loc {
        case .remote:
            startRemoteAudio(withRemoteUrl: currentAudioURL.url, bitrate: currentAudioURL.bitrate, mediaInfo: currentAudioURL.mediaInfo)
            break
        case .saved:
            isStartAccess = currentAudioURL.url.startAccessingSecurityScopedResource()
            startSavedAudio(withSavedUrl: currentAudioURL.url, mediaInfo: currentAudioURL.mediaInfo)
            break
        }
        // stop access to resource
        if isStartAccess {
            currentAudioURL.url.stopAccessingSecurityScopedResource()
        }
        // Start playback
        play()
    }

    func reset() {
        clear()
        audioQueued.removeAll()
        playedQueue.removeAll()
    }

    func addSavedToPlayedQueue(withSavedUrl url: URL, mediaInfo: SALockScreenInfo?) {
        playedQueue.append(SAAudioQueueItem(loc: .saved, url: url, mediaInfo: mediaInfo))
    }

    // Init player with prev queue
    public func startSavedAudioWithPrevQueue(withSavedUrl url: URL, mediaInfo: SALockScreenInfo? = nil) {
        // Get access to file before init player
        // TODO remove access after stop playing
        startSavedAudio(withSavedUrl: url, mediaInfo: mediaInfo)
        addSavedToPlayedQueue(withSavedUrl: url, mediaInfo: mediaInfo)
    }
}
