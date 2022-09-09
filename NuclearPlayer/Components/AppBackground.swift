//
//  AppBackground.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 09.09.2022.
//

import SwiftUI

func getAppBackground() -> LinearGradient {
    return LinearGradient(
        colors: [Color("background1"), Color("background2")],
        startPoint: .top,
        endPoint: .bottom
    )
}
