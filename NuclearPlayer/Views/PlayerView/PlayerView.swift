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
    @EnvironmentObject var nowPlaying: NowPlayingViewModel

    var body: some View {
        if nowPlaying.isPlayerOpened {
            VStack {
                ToolbarView()
//            if nowPlaying.isPlaylistOpened {
//                PlaylistView()
//            } else {
//            }
                SongTitleView()
                ControlsView()
                    .padding(.bottom, 30.0)
            }.background(
                LinearGradient(
                    colors: [Color("background1"), Color("background2")],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
        }
    }
}

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .environmentObject(NowPlayingViewModel.shared)
    }
}
