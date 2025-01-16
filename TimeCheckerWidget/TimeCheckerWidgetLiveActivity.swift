//
//  TimeCheckerWidgetLiveActivity.swift
//  TimeCheckerWidget
//
//  Created by matsumotoryota on 2025/01/16.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimeCheckerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct TimeCheckerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimeCheckerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimeCheckerWidgetAttributes {
    fileprivate static var preview: TimeCheckerWidgetAttributes {
        TimeCheckerWidgetAttributes(name: "World")
    }
}

extension TimeCheckerWidgetAttributes.ContentState {
    fileprivate static var smiley: TimeCheckerWidgetAttributes.ContentState {
        TimeCheckerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: TimeCheckerWidgetAttributes.ContentState {
         TimeCheckerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: TimeCheckerWidgetAttributes.preview) {
   TimeCheckerWidgetLiveActivity()
} contentStates: {
    TimeCheckerWidgetAttributes.ContentState.smiley
    TimeCheckerWidgetAttributes.ContentState.starEyes
}
