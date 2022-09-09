//
//  ImportMedia.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 09.09.2022.
//

import SwiftUI

struct ImportMedia: View {
    @State private var isImporting = false
    var handleFiles: (_ result: Result<[URL], Error>) -> Void
    var allowsMultipleSelection = false

    var body: some View {
        Button {
            isImporting = true
        } label: {
            Image(systemName: "square.and.arrow.down")
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: allowsMultipleSelection,
            onCompletion: handleFiles
        )
    }
}

struct ImportMedia_Previews: PreviewProvider {
    static var previews: some View {
        ImportMedia { result in }
    }
}
