// This is the Steps and Activity Page!
import SwiftUI
import Charts

struct StepsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTimeFrame: TimeFrame = .day
    @State private var stepData: [StepReading] = []
    
    enum TimeFrame: String, CaseIterable {
        case day = "Day"
        case week = "Week"
        case month = "Month"
        case year = "Year"
    }
    
    var todaySteps: Int {
        let today = Calendar.current.startOfDay(for: Date())
        return stepData.filter { Calendar.current.isDate($0.date, inSameDayAs: today) }.first?.steps ?? 5432
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header with close button
                HStack {
                    Spacer()
                    Button(action: { dismiss() }) {
                        Image(systemName: "xmark")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                }
                .padding()
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Title and description
                        VStack(spacing: 8) {
                            Text("Steps & Activity")
                                .font(.largeTitle)
                                .fontWeight(.bold)
                                .foregroundColor(.black)
                            
                            Text("Your Steps & Activities is monitored through your watch which is in sync with the app.")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        
                        // Activity Rings
                        VStack(spacing: 16) {
                            Text("Activity Rings")
                                .font(.headline)
                                .foregroundColor(.black)
                            
                            ZStack {
                                // Outer ring - Move
                                Circle()
                                    .stroke(Color.red.opacity(0.3), lineWidth: 12)
                                    .frame(width: 160, height: 160)
                                
                                Circle()
                                    .trim(from: 0, to: 0.75) // 75% progress
                                    .stroke(Color.red, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-90))
                                
                                // Middle ring - Exercise
                                Circle()
                                    .stroke(Color.green.opacity(0.3), lineWidth: 10)
                                    .frame(width: 130, height: 130)
                                
                                Circle()
                                    .trim(from: 0, to: 0.6) // 60% progress
                                    .stroke(Color.green, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                                    .frame(width: 130, height: 130)
                                    .rotationEffect(.degrees(-90))
                                
                                // Inner ring - Stand
                                Circle()
                                    .stroke(Color.blue.opacity(0.3), lineWidth: 8)
                                    .frame(width: 100, height: 100)
                                
                                Circle()
                                    .trim(from: 0, to: 0.25) // 25% progress
                                    .stroke(Color.blue, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 100, height: 100)
                                    .rotationEffect(.degrees(-90))
                                
                                // Center text
                                VStack(spacing: 2) {
                                    Text("Move")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("479/800")
                                        .font(.headline)
                                        .foregroundColor(.red)
                                    Text("CAL")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("Exercise")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("50/30")
                                        .font(.headline)
                                        .foregroundColor(.green)
                                    Text("MIN")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    Text("Stand")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("3/12")
                                        .font(.headline)
                                        .foregroundColor(.blue)
                                    Text("HRS")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .font(.caption)
                            }
                        }
                        
                        // Time Frame Selector
                        HStack(spacing: 0) {
                            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                                Button(action: { selectedTimeFrame = timeFrame }) {
                                    Text(timeFrame.rawValue)
                                        .font(.system(size: 16, weight: .medium))
                                        .foregroundColor(selectedTimeFrame == timeFrame ? .white : .black)
                                        .frame(maxWidth: .infinity)
                                        .frame(height: 36)
                                        .background(selectedTimeFrame == timeFrame ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.clear)
                                }
                            }
                        }
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(8)
                        .padding(.horizontal)
                        
                        // Steps Tracker
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Steps Tracker")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            // Steps display
                            HStack {
                                Spacer()
                                VStack {
                                    Text("\(todaySteps)")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                                    Text("steps")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                Spacer()
                            }
                            
                            // Chart
                            Chart {
                                ForEach(stepData) { reading in
                                    BarMark(
                                        x: .value("Time", reading.date),
                                        y: .value("Steps", reading.steps)
                                    )
                                    .foregroundStyle(reading.steps > 8000 ? Color(red: 0.01, green: 0.33, blue: 0.18) : Color.gray.opacity(0.6))
                                }
                            }
                            .frame(height: 150)
                            .padding(.horizontal)
                        }
                        
                        // Trends & Insights
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text("Trends & Insights")
                                    .font(.headline)
                                    .foregroundColor(.black)
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            HStack(spacing: 20) {
                                VStack {
                                    Image(systemName: "figure.walk")
                                        .font(.title2)
                                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                                    Text("52")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color(red: 0.01, green: 0.33, blue: 0.18))
                                    Text("MIN/DAY")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("Compared to yesterday, your exercising duration has increased! Way to stay active!")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                                
                                VStack {
                                    Image(systemName: "heart")
                                        .font(.title2)
                                        .foregroundColor(.purple)
                                    Text("12")
                                        .font(.title)
                                        .fontWeight(.bold)
                                        .foregroundColor(.purple)
                                    Text("HR/D")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    Text("Supporting")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        Spacer(minLength: 50)
                    }
                }
            }
        }
        .navigationBarHidden(true)
        .onAppear { loadSampleStepData() }
    }
    
    private func loadSampleStepData() {
        let calendar = Calendar.current
        stepData = [
            StepReading(date: calendar.date(byAdding: .day, value: -6, to: Date())!, steps: 7200),
            StepReading(date: calendar.date(byAdding: .day, value: -5, to: Date())!, steps: 8900),
            StepReading(date: calendar.date(byAdding: .day, value: -4, to: Date())!, steps: 6500),
            StepReading(date: calendar.date(byAdding: .day, value: -3, to: Date())!, steps: 9200),
            StepReading(date: calendar.date(byAdding: .day, value: -2, to: Date())!, steps: 7800),
            StepReading(date: calendar.date(byAdding: .day, value: -1, to: Date())!, steps: 8500),
            StepReading(date: Date(), steps: 5432)
        ]
    }
}

struct StepReading: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

// Developers can see a preview of the Steps & Activity page.
struct StepsDetailView_Previews: PreviewProvider {
    static var previews: some View {
        StepsDetailView()
    }
}
