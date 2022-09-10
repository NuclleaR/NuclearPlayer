    //
    //  Controls.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 30.08.2022.
    //

import SwiftUI
import SwiftAudioPlayer

enum PlayerAction {
    case Play
    case Pause
    case Next
    case Prev
    case Repeat
    case Shuffle
}

struct ControlsView: View {
    @StateObject var viewModel = NowPlayingViewModel.shared

    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: { handleClick(.Prev) }) {
                    Image(systemName: "backward.end.alt.fill")
                        .font(.system(size: 32))
                }
                Spacer()
                Button(action: {
                    if viewModel.isPlaying {
                        handleClick(.Pause)
                    } else {
                        handleClick(.Play)
                    }
                }) {
                    Image(systemName: viewModel.isPlaying ? "pause.circle.fill" : "play.circle.fill")
                        .font(.system(size: 64))
                }
                Spacer()
                Button(action: { handleClick(.Next) }) {
                    Image(systemName: "forward.end.alt.fill")
                        .font(.system(size: 32))
                }
                Spacer()
            }
            VStack {
                Slider(value: $viewModel.position, in: 0...172)
                HStack{
                    Text(SAPlayer.prettifyTimestamp(viewModel.position))
                        .foregroundColor(.white)
                    Spacer()
                    //Text(SAPlayer.prettifyTimestamp(viewModel.trackInfo?.duration.value) ?? "00:00")
                    Text("00:00")
                        .foregroundColor(.white)
                }
            }.padding()
            HStack {
                Spacer()
                Button(action: { handleClick(.Repeat) }) {
                    Image(systemName: "repeat")
                }
                Spacer()
                Button(action: {
                    viewModel.togglePlaylist()
                }) {
                    VStack{
                        Image(systemName: viewModel.isPlaylistOpened ? "chevron.compact.down" : "chevron.compact.up")
                        Text(viewModel.isPlaylistOpened ? "Close playlist" : "Open playlist")
                    }
                }
                Spacer()
                Button(action: { handleClick(.Shuffle) }) {
                    Image(systemName: "shuffle")
                }
                Spacer()
            }.padding(.bottom)
        }.accentColor(.green)
    }

    func handleClick(_ action: PlayerAction) {
        print(action)
        viewModel.handleControls(action)
    }
}

struct Controls_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
