//
//  ContentView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 30.08.2022.
//

import SwiftUI

struct ContentView: View {
//    var body: some View {
//        PlayerView()
//    }
    var body: some View {
        TabView {
            PlayerView()
                .tabItem {
                    Label("Player", systemImage: "playpause.fill")
                }.tag(1)
            Text("Tab Content 2")
                .tabItem {
                    Label("Playlists", systemImage: "music.note.list")
                }.tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
