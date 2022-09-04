//
//  Toolbar.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 31.08.2022.
//

import SwiftUI

struct ToolbarView: View {
    @State private var isImporting: Bool = false

    var body: some View {
        HStack {
            Spacer()
            Menu {
                Button(action: { isImporting = true }, label: {
                    Text("Import media")
                    Image(systemName: "square.and.arrow.down")
                })
                Text("Menu Item 1")
                Text("Menu Item 2")
            } label: {
                Image(systemName: "ellipsis")
                    .padding()
            }
        }
        .accentColor(.green)
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: [.audio],
            allowsMultipleSelection: false,
            onCompletion: handleFile
        )
    }

    private func handleFile(result: Result<[URL], Error>) {
        print(result)
        isImporting = false
        do {
            guard let selectedFile: URL = try result.get().first else { return }
            LocalLibraryViewModel.shared.addToQueue(selectedFile)
        } catch {
                // Handle failure.
            print("Unable to read file contents")
            print(error.localizedDescription)
        }
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
            .previewLayout(.sizeThatFits)
    }
}
