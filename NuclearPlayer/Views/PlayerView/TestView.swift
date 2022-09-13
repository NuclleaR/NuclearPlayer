//
//  TestView.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 11.09.2022.
//

import SwiftUI

struct FullScreenCoverPresentedOnDismiss: View {
    @State private var isPresenting = false
    var body: some View {
        Button("Present Full-Screen Cover") {
            isPresenting.toggle()
        }
        .fullScreenCover(isPresented: $isPresenting,
                         onDismiss: didDismiss) {
            VStack {
                Text("A full-screen modal view.")
                    .font(.title)
                Text("Tap to Dismiss")
            }
            .onTapGesture {
                isPresenting.toggle()
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity,
                   maxHeight: .infinity)
            .background(Color.blue)
            .ignoresSafeArea(edges: .all)
        }
    }

    func didDismiss() {
            // Handle the dismissing action.
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        FullScreenCoverPresentedOnDismiss()
    }
}
