//
//  TrackView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 04.09.2022.
//

import SwiftUI

struct TrackView: View {
    var track: Track
    var selected: Bool = false

    var body: some View {
        HStack {
            if selected {
                Image(systemName: "checkmark.circle")
                    .foregroundColor(.accentColor)
                    .padding(.leading, 8.0)
            }
            Image(systemName: "music.note")
                .padding()
            VStack(alignment: .leading) {
                Text(track.title)
                if !track.artist.isEmpty {
                    Text(track.artist)
                }
            }
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            alignment: .leading
        )
    }
}

struct TrackView_Previews: PreviewProvider {
    static var track: Track = {
        let track = Track()
        track.title = "Test title"
        track.artist = "Test Artist"
        return track
    }()

    static var previews: some View {
        TrackView(track: TrackView_Previews.track)
            .previewLayout(.sizeThatFits)

        TrackView(track: TrackView_Previews.track, selected: true)
            .previewLayout(.sizeThatFits)
    }
}
