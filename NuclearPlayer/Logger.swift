//
//  Logger.swift
//  NuclearPlayer
//
//  Created by Sergey Koreniuk on 04.09.2022.
//

import Foundation
import OSLog

struct AppLogger {
    static let shared = AppLogger()
    private var logger: Logger

    private init() {
        logger = Logger(subsystem: "com.app.nuclearplayer", category: "UI")
    }

    func info(_ message: String) {
        logger.info("[INFO] \(message)")
    }

    func error(_ message: String) {
        logger.info("[ERROR] \(message)")
    }
}
