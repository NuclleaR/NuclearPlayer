//
//  AddPlaylistVew.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 08.09.2022.
//

import SwiftUI

typealias OnSave = (_ title: String) -> Void

struct AddPlaylistVew: View {
    @State var showingPopover: Bool = false
    @State var title: String = ""

    var onSave: OnSave

    init (_ onSave: @escaping OnSave) {
        self.onSave = onSave
    }

    var body: some View {
        Button(action: {
            showingPopover.toggle()
        }, label: {
            Image(systemName: "plus.circle.fill")
        })
        .popover(isPresented: $showingPopover) {
            NavigationView {
                Form {
                    TextField("Title", text: $title)
                }
                .navigationTitle("Add playlist")
                .navigationBarItems(
                    leading: Button("Cancel") {
                        showingPopover.toggle()
                    }.foregroundColor(.red),
                    trailing: Button("Save") {
                        if !title.isEmpty {
                            onSave(title)
                            showingPopover.toggle()
                            title = ""
                        }
                    }.font(.body.weight(.bold)))
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

struct AddPlaylistVew_Previews: PreviewProvider {
    static var previews: some View {
        AddPlaylistVew { title in }
    }
}
