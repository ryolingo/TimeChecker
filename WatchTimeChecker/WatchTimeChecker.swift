//
//  WatchTimeChecker.swift
//  WatchTimeChecker
//
//  Created by matsumotoryota on 2025/01/16.
//

import AppIntents

struct WatchTimeChecker: AppIntent {
    static var title: LocalizedStringResource { "WatchTimeChecker" }
    
    func perform() async throws -> some IntentResult {
        return .result()
    }
}
