    //
    //  LibraryView.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 09.09.2022.
    //

import SwiftUI

struct LibraryView: View {
    @EnvironmentObject var library: LocalLibraryViewModel

    var body: some View {
        NavigationView {
            Group {
                if library.tracks.count > 0 {
                    List {
                        ForEach(library.tracks, id: \.id) { track in
                            TrackView(track: track)
                        }
                    }.listStyle(.plain)
                } else {
                    VStack(spacing: 30.0) {
                        Image(systemName: "square.and.arrow.down.on.square")
                            .font(.system(size: 64))
                        Text("Library is empty. Please import media")
                    }.opacity(0.3)
                }
            }
            .navigationTitle("Library")
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarTrailing) {
                    ImportMedia(handleFiles: library.handleFiles, allowsMultipleSelection: true)
                }
            })
        }.navigationViewStyle(.stack)
    }
}

struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView()
            .environmentObject(LocalLibraryViewModel.preview)
    }
}
