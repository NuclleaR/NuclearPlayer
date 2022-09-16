    //
    //  NowPlaying.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 01.09.2022.
    //

import Foundation
import Combine
import SwiftAudioPlayer
import RealmSwift

    // TODO Subscribe for audio player play time change
    // TODO create default queue playlist containing now playing song
    // TODO subscribe to SAPlayer.shared.prettyDuration
class NowPlayingViewModel: ObservableObject {

    @Published private(set) var track: Track?
    @Published private(set) var playlist: Playlist?

    @Published private(set) var trackInfo: TrackInfo?
    @Published private(set) var isPlaying: Bool = false
    @Published private(set) var playedQueue: [URL] = []

    @Published private(set) var isPlaylistOpened: Bool = false

    @Published var isPlayerOpened = false
    @Published var position: Double = 0

    private var cancellable = Set<AnyCancellable>()
    private var playStatusId: UInt?
    private var queueId: UInt?
    private var elapsedId: UInt?

    private let player = SAPlayer.shared

    private init() {
#if DEBUG
        SAPlayer.shared.DEBUG_MODE = true
#endif

            // TODO Move this logic to do in background
        $track.compactMap({ $0?.bookmarkData })
            .map({ URLUtils.restoreURLFromData(bookmarkData: $0) })
            .map { url in
                return TrackInfo(url: url)
            }.assign(to: \.trackInfo, on: self)
            .store(in: &cancellable)

        $playlist.map { playlist in
            return playlist?.tracks
        }.sink { tracks in
            if tracks.isNilOrEmpty {
                self.player.clear()
            } else {
                self.initQueeue(with: tracks!)
            }
        }.store(in: &cancellable)

        $position.sink { val in
            print("Position", val)
//            player.seekTo(seconds: val)
        }.store(in: &cancellable)

        subscribeToAudioQueue()
        subscribeToElapsedTime()
        subscribeToPlayingStatus()
    }

    func handleControls(_ action: PlayerAction) {
        switch action {
        case .Play:
            player.play()
        case .Pause:
            player.pause()
        case .Next:
            player.next()
            if player.audioQueued.count > 0 {
                track = getTrackFromPlaylist(with: player.playedQueue.last?.url)
            }
        case .Prev:
            if position > 1.5 {
                player.seekTo(seconds: 0)
                return
            }
            player.prev()
            if playedQueue.count > 1 {
                track = getTrackFromPlaylist(with: player.playedQueue.last?.url)
            }
        case .Repeat: break

        case .Shuffle: break

        }
    }

    func togglePlayPause() {
        player.togglePlayAndPause()
    }

    func playNext() {
        player.next()
        if player.audioQueued.count > 0 {
            track = getTrackFromPlaylist(with: player.playedQueue.last?.url)
        }
    }

    func togglePlaylist() {
        isPlaylistOpened.toggle()
    }

    func togglePlayer() {
        isPlayerOpened.toggle()
    }

    func seekTo(_ position: Double) {
        player.seekTo(seconds: position)
    }

    func setPlayQueue(with playlist: Playlist) {
        self.playlist = playlist
        self.track = playlist.tracks.first
    }

    private func initQueeue(with tracks: List<Track>) {
        tracks.enumerated().forEach { (index, track) in
            guard let urlData = track.bookmarkData else { return }

            URLUtils.withAcess(to: urlData) { url in
                let mediaInfo = getSALockScreenInfo(url: url)
                if index == 0 {
                    player.startSavedAudioWithPrevQueue(withSavedUrl: url, mediaInfo: mediaInfo)
                } else {
                    player.queueSavedAudio(withSavedUrl: url, mediaInfo: mediaInfo)
                }
            }
        }

        player.play()
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
            // TODO Check if file exists before play
            // If no - remove from library and notify user

            guard let self = self else { return }
            self.track = self.playlist?.tracks.first(where: { $0.url == forthcomingPlaybackUrl.lastPathComponent })
        }
    }

    private func subscribeToElapsedTime() {
        elapsedId = SAPlayer.Updates.ElapsedTime.subscribe { [weak self] (position) in
            self?.position = position
        }
    }

    private func getTrackFromPlaylist(with url: URL?) -> Track? {
        guard let filename = url?.lastPathComponent else { return nil }
        print(filename)
        return playlist?.tracks.first(where: { $0.url == filename })
    }
    static let shared = NowPlayingViewModel()
}
