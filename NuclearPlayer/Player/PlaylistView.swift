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
            ForEach(viewModel.tracks) { (item: Track) in
                Text(item.title!)
            }
        }
    }
}

struct PlaylistView_Previews: PreviewProvider {
    static var previews: some View {
        PlaylistView(viewModel: LocalLibraryViewModel.preview)
            .previewLayout(.sizeThatFits)

    }
}
