import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ClockViewModel()
    
    var body: some View {
        VStack {
            ClockFaceView(viewModel: viewModel)
            
            Spacer()
            
            // 次のバスの時刻を表示
            if let nextBus = viewModel.upcomingBusTimes.first {
                Text("次のバス: \(viewModel.formattedTime(from: nextBus))")
                    .font(.headline)
                    .padding()
            }
            
            Text("次のバス時刻")
                .font(.caption)
            ForEach(viewModel.upcomingBusTimes, id: \.self) { time in
                Text(viewModel.formattedTime(from: time))
                    .font(.caption)
            }
        }
    }
}
#Preview{
    ContentView()
}
