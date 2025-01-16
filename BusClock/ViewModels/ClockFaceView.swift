import Foundation
import Combine
import SwiftUI

class ClockViewModel: ObservableObject {
    @Published var currentTime = Date()
    @Published var upcomingBusTimes: [Date] = []
    private var timer: Timer?
    
    init() {
        startTimer()
        updateUpcomingBuses()
    }
    
    deinit {
        timer?.invalidate()
    }
    
    private func startTimer() {
        // 1分ごとに更新
        timer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.currentTime = Date()
            self?.updateUpcomingBuses()
        }
    }
    
    func updateUpcomingBuses() {
        upcomingBusTimes = BusSchedule.getUpcomingBusTimes(from: currentTime)
    }
    
    func getMarkerStyle(for minute: Int) -> (length: CGFloat, color: Color) {
        let upcomingBusMinutes = upcomingBusTimes.map { BusSchedule.getMinutes(from: $0) }
        
        if upcomingBusMinutes.contains(minute) {
            return (CGFloat(20), Color.red)
        }
        
        let length = minute % 5 == 0 ? CGFloat(15) : CGFloat(10)
        return (length, Color.gray)
    }
    
    func formattedTime(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter.string(from: date)
    }
} 
