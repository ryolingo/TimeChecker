//
//  TimeCheckerWidget.swift
//  TimeCheckerWidget
//
//  Created by matsumotoryota on 2025/01/15.
//

import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        // デモ用の到着時間（15分後）
        let busTime = Date().addingTimeInterval(15 * 60)
        return SimpleEntry(date: Date(), configuration: ConfigurationAppIntent(), busArrivalTime: busTime)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let busTime = Date().addingTimeInterval(15 * 60)
        return SimpleEntry(date: Date(), configuration: configuration, busArrivalTime: busTime)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let busTime = currentDate.addingTimeInterval(15 * 60) // デモ用：15分後
        
        // 1分ごとに更新
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, configuration: configuration, busArrivalTime: busTime)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationAppIntent
    // バスの到着時間を追加
    let busArrivalTime: Date
}

struct TimeCheckerWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            // 残り時間計算
            let remainingMinutes = Int(entry.busArrivalTime.timeIntervalSince(entry.date) / 60)
            let progress = Double(max(0, remainingMinutes)) / 30.0 // 最大30分を基準とする
            
            ZStack {
                // 背景の円（グレー）
                Circle()
                    .stroke(Color.gray.opacity(0.3), lineWidth: 8)
                
                // プログレス円
                Circle()
                    .trim(from: 0, to: CGFloat(min(1, progress)))
                    .stroke(
                        remainingMinutes <= 10 ? Color.red :
                            (remainingMinutes <= 20 ? Color.yellow : Color.green),
                        lineWidth: 8
                    )
                    .rotationEffect(.degrees(-90))
                
                // 残り時間テキスト
                VStack {
                    if remainingMinutes > 0 {
                        Text("\(remainingMinutes)")
                            .font(.system(size: 24, weight: .bold))
                        Text("分")
                            .font(.system(size: 12))
                    } else {
                        Text("到着")
                            .font(.system(size: 20, weight: .bold))
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(8)
        }
    }
}

struct TimeCheckerWidget: Widget {
    let kind: String = "TimeCheckerWidget"

    var body: some WidgetConfiguration {
        //ユーザーがカスタマイズで切るウィジェットを作成
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TimeCheckerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall]) // 小さいサイズのWidgetのみサポート
        .configurationDisplayName("バス時刻チェッカー")
        .description("次のバスの到着時刻がわかります！")
    }
}

#Preview(as: .systemSmall) {
    TimeCheckerWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        configuration: .smiley,
        busArrivalTime: Date().addingTimeInterval(15 * 60)
    )
}

extension ConfigurationAppIntent {
    fileprivate static var smiley: ConfigurationAppIntent {
        let intent = ConfigurationAppIntent()
        return intent
    }
}
#Preview{
    TimeCheckerWidgetEntryView(entry: SimpleEntry(
        date: .now,
        configuration: .smiley,
        busArrivalTime: Date().addingTimeInterval(15 * 60)
    ))
}
