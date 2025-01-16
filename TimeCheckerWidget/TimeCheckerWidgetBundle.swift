//
//  TimeCheckerWidgetBundle.swift
//  TimeCheckerWidget
//
//  Created by matsumotoryota on 2025/01/16.
//

import WidgetKit
import SwiftUI

@main
struct TimeCheckerWidgetBundle: WidgetBundle {
    var body: some Widget {
        TimeCheckerWidget()
        TimeCheckerWidgetControl()
        TimeCheckerWidgetLiveActivity()
    }
}
