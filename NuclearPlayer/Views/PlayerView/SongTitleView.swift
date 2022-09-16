//
//  SongTitle.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 01.09.2022.
//

import SwiftUI

// TODO fill artwork with image
struct SongTitleView: View {
    @EnvironmentObject var viewModel: NowPlayingViewModel

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            ArtworkView()
            Spacer()
            if let track = viewModel.track {
                Text(track.title)
                    .font(.title)
                    .lineLimit(1)
                HStack(spacing: 0.0) {
                    if !track.artist.isEmpty {
                        Text(track.artist)
                    }
                    if let album = track.album, !album.isEmpty {
                        Text(",").padding(.trailing, 5.0)
                        Text(album).padding(.trailing, 8.0)
                    }
                }
            }
        }.frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        )
        .foregroundColor(.white)
        .padding()
    }
}

private let trackFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY"
    return formatter
}()

struct SongTitle_Previews: PreviewProvider {
    static var previews: some View {
        SongTitleView()
            .environmentObject(NowPlayingViewModel.shared)
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
