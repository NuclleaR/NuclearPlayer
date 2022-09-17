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
    @Published private(set) var tracks: List<Track>

    @Published private(set) var trackInfo: TrackInfo?
    @Published private(set) var isPlaying: Bool = false

    @Published private(set) var isPlaylistOpened: Bool = false

    @Published var isPlayerOpened = false
    @Published var position: Double = 0

    private var cancellable = Set<AnyCancellable>()
    private var playStatusId: UInt?
    private var queueId: UInt?
    private var elapsedId: UInt?

    private let player = SAPlayer.shared
    private var realmCtrl: RealmController

    var isEditing: Bool = false

    private init(realmCtrl: RealmController) {
        self.realmCtrl = realmCtrl
        let playerState = PlayerState.getState(realm: realmCtrl.realm)
        position = playerState.position
        tracks = playerState.tracks
        track = playerState.track

        // TODO Move this logic to do in background
        $track
            .dropFirst(1)
            .handleEvents(receiveOutput: { track in
                PlayerState.update(ctrl: realmCtrl, position: 0, trackId: track?.id)
            })
            .compactMap({ $0?.bookmarkData })
            .map({ URLUtils.restoreURLFromData(bookmarkData: $0) })
            .map { url in
                return TrackInfo(url: url)
            }.assign(to: \.trackInfo, on: self)
            .store(in: &cancellable)

        $tracks
            .dropFirst(1)
            .sink { tracks in
            if tracks.count == 0 {
                self.player.reset()
            } else {
                self.initQueeue(with: tracks)
            }
            // side effect write to DB
            PlayerState.update(ctrl: realmCtrl, position: 0, tracks: tracks)
        }.store(in: &cancellable)

        subscribeToAudioQueue()
        subscribeToElapsedTime()
        subscribeToPlayingStatus()
        if playerState.tracks.count > 0 {
            restoreQueeue()
        }
#if DEBUG
        SAPlayer.shared.DEBUG_MODE = true
#endif
    }

    func handleControls(_ action: PlayerAction) {
        switch action {
        case .Play:
            player.play()
        case .Pause:
            player.pause()
        case .Next:
            if player.audioQueued.count > 0 {
                player.next()
                track = getTrackFromPlaylist(with: player.playedQueue.last?.url)
            }
        case .Prev:
            if position > 1.5 {
                player.seekTo(seconds: 0)
                return
            }
            if player.playedQueue.count > 1 {
                player.prev()
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
        if player.audioQueued.count > 0 {
            player.next()
            track = getTrackFromPlaylist(with: player.playedQueue.last?.url)
        }
    }

    func togglePlaylist() {
        isPlaylistOpened.toggle()
    }

    func togglePlayer() {
        isPlayerOpened.toggle()
    }

    func seekToPosition() {
        player.seekTo(seconds: position)
    }

    func setPlayQueue(with playlist: Playlist) {
        tracks = playlist.tracks
        player.play()
    }

    private func initQueeue(with tracks: List<Track>) {
        // Reset player queue
        player.reset()
        // and start new
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

        track = tracks.first
    }

    private func restoreQueeue() {
        print("Restore queue")
        // Reset player queue
        player.reset()
        // and start new
        if let data = track?.bookmarkData {
            URLUtils.withAcess(to: data) { url in
                let mediaInfo = getSALockScreenInfo(url: url)
                player.startSavedAudio(withSavedUrl: url, mediaInfo: mediaInfo)
            }
        }

        var mutch = false

        tracks.forEach { (track) in
            guard let urlData = track.bookmarkData else { return }

            URLUtils.withAcess(to: urlData) { url in
                let mediaInfo = getSALockScreenInfo(url: url)
                if self.track.isPresent && !mutch {
                    player.addSavedToPlayedQueue(withSavedUrl: url, mediaInfo: mediaInfo)
                    if self.track?.id == track.id {
                        mutch = true
                    }
                } else {
                    player.queueSavedAudio(withSavedUrl: url, mediaInfo: mediaInfo)
                }
            }
        }
        player.seekTo(seconds: position)
    }

    private func subscribeToPlayingStatus() {
        playStatusId = SAPlayer.Updates.PlayingStatus.subscribe { [weak self] playingStatus in
            guard let self = self else { return }

            switch playingStatus {
            case .playing:
                self.isPlaying = true
            case .paused:
                self.isPlaying = false
                PlayerState.update(ctrl: self.realmCtrl, position: self.position)
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
            self.track = self.tracks.first(where: { $0.url == forthcomingPlaybackUrl.lastPathComponent })
        }
    }

    private func subscribeToElapsedTime() {
        elapsedId = SAPlayer.Updates.ElapsedTime.subscribe { (position) in
            if !self.isEditing {
                self.position = position
            }
        }
    }

    private func getTrackFromPlaylist(with url: URL?) -> Track? {
        guard let filename = url?.lastPathComponent else { return nil }
        return tracks.first(where: { $0.url == filename })
    }
    static let shared = NowPlayingViewModel(realmCtrl: RealmController.instance)
}
