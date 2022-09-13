//
//  NamespaceEnv.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 13.09.2022.
//

import SwiftUI

struct NamespaceEnvKey: EnvironmentKey {
    typealias Value = Namespace.ID?

    static var defaultValue: Value = nil
}

extension EnvironmentValues {
    var sharedNamespace: Namespace.ID? {
        get { self[NamespaceEnvKey.self] }
        set { self[NamespaceEnvKey.self] = newValue }
    }
}

extension View {
    func sharedNamespace(_ value: Namespace.ID) -> some View {
        environment(\.sharedNamespace, value)
    }
}
