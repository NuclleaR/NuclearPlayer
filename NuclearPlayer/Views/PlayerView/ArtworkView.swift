//
//  ArtworkView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 01.09.2022.
//

import SwiftUI

struct ArtworkView: View {
    var image: UIImage?

    var body: some View {
        ZStack {
            if image != nil {
                Image(uiImage: image!)
                    .resizable()
            } else {
                Image(systemName: "music.quarternote.3")
                    .resizable()
                    .padding(30)
                    .foregroundColor(.black)
            }
        }
        .frame(minWidth: 140, maxWidth: .infinity, minHeight: 140, maxHeight: .infinity, alignment: .center)
        .aspectRatio(1, contentMode: .fit)
        .background(.green)
//        .overlay {
//            Rectangle()
//                .stroke(.black, lineWidth: 3)
//        }
        .padding(50)
    }
}

struct ArtworkView_Previews: PreviewProvider {
    @Namespace private static var test

    static var previews: some View {
        ArtworkView()
            .previewLayout(.sizeThatFits)
    }
}
