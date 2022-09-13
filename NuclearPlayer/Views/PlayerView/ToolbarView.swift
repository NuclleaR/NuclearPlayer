    //
    //  Toolbar.swift
    //  NuclearPlayer
    //
    //  Created by Sergey Koreniuk on 31.08.2022.
    //

import SwiftUI

struct ToolbarView: View {
    @EnvironmentObject var viewModel: NowPlayingViewModel

    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                withAnimation {
                    viewModel.togglePlayer()
                }
            }, label: {
                Image(systemName: "chevron.down")
                    .padding()
            })

                //            Menu {
                //                Button(action: { }, label: {
                //                    Text("Import media")
                //                    Image(systemName: "square.and.arrow.down")
                //                })
                //                Text("Menu Item 1")
                //                Text("Menu Item 2")
                //            } label: {
                //                Image(systemName: "ellipsis")
                //                    .padding()
                //            }
        }
        .accentColor(.green)
    }
}

struct Toolbar_Previews: PreviewProvider {
    static var previews: some View {
        ToolbarView()
            .environmentObject(NowPlayingViewModel.shared)
            .previewLayout(.sizeThatFits)
    }
}
