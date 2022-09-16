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

    var body: some View {
        VStack {
            ToolbarView()
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

struct Player_Previews: PreviewProvider {
    static var previews: some View {
        PlayerView()
            .environmentObject(NowPlayingViewModel.shared)
    }
}
