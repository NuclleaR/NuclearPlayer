//
//  NowPlaying.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 01.09.2022.
//

import Foundation
import Combine
import SwiftAudioPlayer

// TODO Subscribe for audio player play time change
// TODO create default queue playlist containing now playing song
// TODO subscribe to SAPlayer.shared.prettyDuration
class NowPlayingViewModel: ObservableObject {
    @Published private(set) var track: Track?
//    @Published private(set) var playlist: Playlist?
    @Published private(set) var trackInfo: TrackInfo?
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var isPlaylistOpened: Bool = false
    @Published private(set) var playedQueue: [URL] = []
    // TODO make private setter
    @Published var position: Double = 0

    private var cancellable = Set<AnyCancellable>()
    private var playStatusId: UInt?
    private var queueId: UInt?
    private var elapsedId: UInt?

    private init() {
        // TODO Move this logic to do in background
        $track.compactMap({ $0?.bookmarkData })
            .map({ URLUtils.restoreURLFromData(bookmarkData: $0) })
            .map { url in
                return TrackInfo(url: url)
            }.assign(to: \.trackInfo, on: self)
            .store(in: &cancellable)

        subscribeToAudioQueue()
        subscribeToElapsedTime()
        subscribeToPlayingStatus()
    }

    func handleControls(_ action: PlayerAction) {
        switch action {
        case .Play:
            SAPlayer.shared.play()
        case .Pause:
            SAPlayer.shared.pause()
        case .Next:
            SAPlayer.shared.next()
        case .Prev:
            SAPlayer.shared.prev()
        case .Repeat: break

        case .Shuffle: break

        }
    }

    func togglePlaylist() {
        isPlaylistOpened = !isPlaylistOpened
    }

    private func subscribeToPlayingStatus() {
        playStatusId = SAPlayer.Updates.PlayingStatus.subscribe { [weak self] playingStatus in
            guard let self = self else { return }

            switch playingStatus {
            case .playing:
                self.isPlaying = true
            case .paused:
                self.isPlaying = false
            case .buffering:
                break
            case .ended:
                self.isPlaying = false
            }
        }
    }

    private func subscribeToAudioQueue() {
        queueId = SAPlayer.Updates.AudioQueue.subscribe { [weak self] forthcomingPlaybackUrl in
            guard let self = self else { return }
            // TODO Check if file exists before play
            // If no - remove from library and notify user
            // TODO Need get access to file before init player
            print(forthcomingPlaybackUrl)
        }
    }

    private func subscribeToElapsedTime() {
        elapsedId = SAPlayer.Updates.ElapsedTime.subscribe { [weak self] (position) in
            guard let self = self else { return }

//            guard self.duration != 0 else { return }

            self.position = position
        }
    }

    static let shared = NowPlayingViewModel()
}
