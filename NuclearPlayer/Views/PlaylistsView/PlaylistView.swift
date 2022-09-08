//
//  PlaylistView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI
import CoreData
import SwiftAudioPlayer

struct PlaylistView: View {
    @StateObject private var viewModel: LocalLibraryViewModel

    init(viewModel: LocalLibraryViewModel = LocalLibraryViewModel.shared) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        List {
            ForEach(viewModel.tracks, id: \.id) { (item: Track) in
                TrackView(track: item)
                    .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                        Button(role: ButtonRole.destructive) {
                            withAnimation {
                                viewModel.removeFromLibrary(track: item)
                            }
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .onDisappear {
                        viewModel.removeFromStorage(track: item)
                    }
            }
        }.listStyle(.plain)
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(
            viewModel: LocalLibraryViewModel.preview
        )
            .previewLayout(.sizeThatFits)
    }
}
