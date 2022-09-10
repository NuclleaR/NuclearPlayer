//
//  ContentView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: TracksViewModel

    var body: some View {
        TabView {
            LibraryView()
                .tabItem {
                    Label("Library", systemImage: "list.bullet")
                }.tag(1)
            PlaylistsView()
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }.tag(2)
        }
        .fileImporter(
            isPresented: $viewModel.isImporting,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: true,
            onCompletion: viewModel.importFiles
        )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
