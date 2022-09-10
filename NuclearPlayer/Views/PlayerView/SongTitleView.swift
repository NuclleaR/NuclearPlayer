//
//  SongTitle.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 01.09.2022.
//

import SwiftUI

// TODO fill artwork with image
struct SongTitleView: View {
    @State var trackInfo = NowPlayingViewModel.shared.trackInfo

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            ArtworkView()
            Spacer()
            if let ti = trackInfo {
                Text(ti.title)
                    .font(.title)
                    .lineLimit(1)
                HStack(spacing: 0.0) {
                    if !ti.artist.isEmpty {
                        Text(ti.artist)
                        Text(",").padding(.trailing, 5.0)
                    }
                    if let album = ti.album, !album.isEmpty {
                        Text(album).padding(.trailing, 8.0)
                    }
                    if let year = ti.year {
                        Text(trackFormatter.string(from: year)).fontWeight(.semibold)
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
            .preferredColorScheme(.dark)
            .previewLayout(.sizeThatFits)
    }
}
