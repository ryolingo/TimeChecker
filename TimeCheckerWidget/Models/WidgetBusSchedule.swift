import Foundation

struct WidgetBusSchedule {
    // バスの到着時刻（文字列形式）
    static let departureTimes = [
        "08:14", "08:26", "08:42", "08:54", "09:10", "09:22", "09:38", "09:50",
        "10:06", "10:18", "10:34", "10:46", "11:02", "11:14", "11:30", "11:42",
        "11:58", "12:10", "12:26", "12:38", "12:54", "13:06", "13:22", "13:34",
        "13:50", "14:02", "14:18", "14:30", "14:46", "14:58", "15:14", "15:26",
        "15:42", "15:54", "16:10", "16:22", "16:38", "16:50", "17:06", "17:18",
        "17:34", "17:46", "18:02", "18:14", "18:30", "18:42", "18:58", "19:10",
        "19:26", "19:38"
    ]
    
    /// 時刻を `Date` 型に変換
    static func convertToDate(timeStr: String, referenceDate: Date = Date()) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = .current
        guard let timeOnlyDate = formatter.date(from: timeStr) else { return nil }
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: referenceDate)
        return calendar.date(bySettingHour: calendar.component(.hour, from: timeOnlyDate),
                             minute: calendar.component(.minute, from: timeOnlyDate),
                             second: 0,
                             of: calendar.date(from: components)!)
    }
    
    /// 現在時刻以降のバス時刻を取得
    static func getUpcomingBusTimes(from currentTime: Date, withinHours: Double = 1.0) -> [Date] {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .hour, value: Int(withinHours), to: currentTime)!

        return departureTimes.compactMap { timeStr -> Date? in
            guard let busTime = convertToDate(timeStr: timeStr, referenceDate: currentTime) else { return nil }
            if busTime >= currentTime && busTime <= endTime {
                return busTime
            }
            return nil
        }
    }
}
