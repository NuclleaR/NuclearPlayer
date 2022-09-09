//
//  Player.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI
import SwiftAudioPlayer

// TODO add functionality to start track from start when played a few sec
struct PlayerView: View {
    @StateObject var nowPlaying = NowPlayingViewModel.shared

    init() {
        #if DEBUG
        SAPlayer.shared.DEBUG_MODE = true
        #endif
    }

    var body: some View {
        VStack {
            ToolbarView()
//            if nowPlaying.isPlaylistOpened {
//                PlaylistView()
//            } else {
//            }
            SongTitleView()
            ControlsView()
        }.background(
            LinearGradient(
                colors: [Color("background1"), Color("background2")],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            PlayerView()
        }
    }
}
