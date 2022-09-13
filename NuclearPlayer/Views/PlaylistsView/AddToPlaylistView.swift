//
//  AddToPlaylist.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 10.09.2022.
//

import SwiftUI

struct AddToPlaylistView: View {
    @EnvironmentObject var tracksViewModel: TracksViewModel

    @State private var searchText = ""
    @State private var selection = Set<Track>()

    var onSave: ParamClosure<Set<Track>>
    var onCancel: EmptyClosure

    init (_ onSave: @escaping ParamClosure<Set<Track>>, _ onCancel: @escaping EmptyClosure) {
        self.onSave = onSave
        self.onCancel = onCancel
    }

    private var searchResults: [Track] {
        if searchText.isEmpty {
            return Array(tracksViewModel.tracks)
        } else {
            return tracksViewModel.tracks.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        NavigationView {
            List(searchResults) { track in
                let isSelected = selection.contains(track)

                TrackView(track: track, selected: isSelected)
                    .contentShape(Rectangle())
                    .onTapGesture {
                        if isSelected {
                            selection.remove(track)
                        } else {
                            selection.insert(track)
                        }
                    }
            }
            .listStyle(.plain)
            .navigationTitle("Add tracks")
            .searchable(text: $searchText)
            .toolbar(content: {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }.foregroundColor(.red)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        onSave(selection)
                    }.font(.body.weight(.bold))
                }
            })
            .navigationBarTitleDisplayMode(.inline)
        }.navigationViewStyle(.stack)
    }
}

struct AddToPlaylist_Previews: PreviewProvider {
    static var previews: some View {
        AddToPlaylistView({ selection in
            print("Selection", selection)
        }, {
            print("Cancel")
        })
            .environmentObject(TracksViewModel(realmCtrl: RealmController.previewRealm))
    }
}
