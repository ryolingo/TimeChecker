import WidgetKit
import SwiftUI

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        let currentDate = Date()
        let busTimes = WidgetBusSchedule.getUpcomingBusTimes(from: currentDate)
        return SimpleEntry(date: currentDate, busTimes: busTimes)
    }
    
    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        let currentDate = Date()
        let busTimes = WidgetBusSchedule.getUpcomingBusTimes(from: currentDate)
        return SimpleEntry(date: currentDate, busTimes: busTimes)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []
        let currentDate = Date()
        let busTimes = WidgetBusSchedule.getUpcomingBusTimes(from: currentDate)
        
        for minuteOffset in 0..<60 {
            let entryDate = Calendar.current.date(byAdding: .minute, value: minuteOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, busTimes: busTimes)
            entries.append(entry)
        }
        
        return Timeline(entries: entries, policy: .atEnd)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let busTimes: [Date]
}

struct TimeCheckerWidgetEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var widgetFamily
    
    var body: some View {
        switch widgetFamily {
        case .systemSmall:
            // 小さいボックス（次のバス1つ）
            if let nextBus = entry.busTimes.first {
                ProgressViewForBus(busTime: nextBus, currentTime: entry.date)
            }
            
        case .systemMedium:
            // 長方形ボックス（次のバス2つを横並び）
            HStack {
                ForEach(entry.busTimes.prefix(2), id: \.self) { busTime in
                    ProgressViewForBus(busTime: busTime, currentTime: entry.date)
                }
            }
            
        default:
            Text("Unsupported Widget Size")
        }
    }
}

struct ProgressViewForBus: View {
    let busTime: Date
    let currentTime: Date
    
    var body: some View {
        let remainingMinutes = Int(busTime.timeIntervalSince(currentTime) / 60)
        let progress = Double(max(0, remainingMinutes)) / 30.0 // 最大30分を基準
        
        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.3), lineWidth: 8)
            Spacer()
            Circle()
                .trim(from: 0, to: CGFloat(min(1, progress)))
                .stroke(
                    remainingMinutes <= 10 ? Color.red :
                        (remainingMinutes <= 20 ? Color.yellow : Color.green),
                    lineWidth: 8
                )
                .rotationEffect(.degrees(-90))
            
            VStack {
                if remainingMinutes > 0 {
                    Text("\(remainingMinutes)")
                        .font(.system(size: 24, weight: .bold))
                    Text("minutes")
                        .font(.system(size: 12))
                } else {
                    Text("到着")
                        .font(.system(size: 20, weight: .bold))
                }
            }
        }
        .frame(width: 100, height: 100)
    }
}

struct TimeCheckerWidget: Widget {
    let kind: String = "TimeCheckerWidget"
    
    var body: some WidgetConfiguration {
        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
            TimeCheckerWidgetEntryView(entry: entry)
                .containerBackground(.fill.tertiary, for: .widget)
        }
        .supportedFamilies([.systemSmall, .systemMedium]) // 小さいサイズと長方形サイズをサポート
        .configurationDisplayName("バス時刻チェッカー")
        .description("次のバスの到着時刻がわかります！")
    }
}

// プレビュー
#Preview(as: .systemSmall) {
    TimeCheckerWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        busTimes: WidgetBusSchedule.getUpcomingBusTimes(from: Date())
    )
}

#Preview(as: .systemMedium) {
    TimeCheckerWidget()
} timeline: {
    SimpleEntry(
        date: .now,
        busTimes: WidgetBusSchedule.getUpcomingBusTimes(from: Date())
    )
}
