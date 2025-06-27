// This is the Steps and Activity Page!
import SwiftUI
import Charts

struct StepsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stepData: [StepReading] = []
    
    // New changes: Added state for graph feature
    @State private var selectedTimeFrame: TimeFrame = .day
    @State private var selectedDataPoint: ChartDataPoint?
    @State private var allHourlyStepData: [HourlyStepData] = []
    
    // Color schemes for the Steps and Activity page
    let primaryGreen = Color(red: 0.01, green: 0.33, blue: 0.18)
    let secondaryGreen = Color(red: 0.39, green: 0.59, blue: 0.38)
    let tertiaryGreen = Color(red: 0.23, green: 0.51, blue: 0.36)
    
    // Define current and target values for accurate progress calculation
    let caloriesCurrent: Double = 4790
    let caloriesTarget: Double = 8000
    let exerciseCurrent: Double = 50
    let exerciseTarget: Double = 30
    let standCurrent: Double = 3
    let standTarget: Double = 12
    
    // Progress calculations
    var caloriesProgress: Double {
        min(caloriesCurrent / caloriesTarget, 1.0)
    }
    
    var exerciseProgress: Double {
        min(exerciseCurrent / exerciseTarget, 1.0)
    }
    
    var standProgress: Double {
        min(standCurrent / standTarget, 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 32) {
                        // Title section
                        titleSection
                        
                        // Activity rings and statistics
                        activityRingsSection
                        
                        // Chart section
                        chartSection
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            loadSampleStepData()
            generateSampleHourlyData()
        }
    }
    
    // MARK: - View Components
    
    // Shows Steps & Activity page and subheadline
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Steps & Activity")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(primaryGreen)
                    
                    Text("Your Steps & Activities is monitored through your watch which is in sync with the app.")
                        .font(.subheadline)
                        .foregroundColor(Color(red: 0.25, green: 0.33, blue: 0.44))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
            }
            .padding(.horizontal, 24)
        }
    }
    
    // Shows 3 Activity Rings and the Statistics
    private var activityRingsSection: some View {
        HStack(alignment: .center, spacing: 0) {
            // Activity Rings
            ZStack {
                // Outer ring - Calories
                Circle()
                    .stroke(primaryGreen.opacity(0.15), lineWidth: 12)
                    .frame(width: 160, height: 160)
                Circle()
                    .trim(from: 0, to: caloriesProgress)
                    .stroke(primaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 160, height: 160)
                    .rotationEffect(.degrees(-90))
                
                // Middle ring - Exercise
                Circle()
                    .stroke(tertiaryGreen.opacity(0.15), lineWidth: 12)
                    .frame(width: 120, height: 120)
                Circle()
                    .trim(from: 0, to: exerciseProgress)
                    .stroke(tertiaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(-90))
                
                // Inner ring - Stand
                Circle()
                    .stroke(secondaryGreen.opacity(0.15), lineWidth: 12)
                    .frame(width: 80, height: 80)
                Circle()
                    .trim(from: 0, to: standProgress)
                    .stroke(secondaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                    .frame(width: 80, height: 80)
                    .rotationEffect(.degrees(-90))
            }
            .alignmentGuide(.leading) { d in d[.leading] - 80 }
            .padding(.leading, 30)
            
            Spacer()
            
            // Statistics
            VStack(alignment: .leading, spacing: 24) {
                statisticBlock(
                    title: "Move",
                    value: "\(Int(caloriesCurrent))/\(Int(caloriesTarget))",
                    subtitle: "Calories Burned",
                    color: primaryGreen
                )
                
                statisticBlock(
                    title: "Exercise",
                    value: "\(Int(exerciseCurrent))/\(Int(exerciseTarget))",
                    subtitle: "Minutes Moving",
                    color: tertiaryGreen
                )
                
                statisticBlock(
                    title: "Stand",
                    value: "\(Int(standCurrent))/\(Int(standTarget))",
                    subtitle: "Hours Standing",
                    color: secondaryGreen
                )
            }
            .frame(maxWidth: 160)
            .padding(.trailing, 18)
        }
    }
    
    private var chartSection: some View {
        VStack(spacing: 16) {
            // Time frame buttons
            timeFrameButtons
            
            // Chart display
            chartDisplay
        }
    }
    
    // Shows the Time Frame Buttons, labeled "Day", "Week", "Month", and "Year"
    private var timeFrameButtons: some View {
        HStack {
            ForEach(TimeFrame.allCases, id: \.self) { timeFrame in
                Button(action: {
                    selectedTimeFrame = timeFrame
                    selectedDataPoint = nil
                }) {
                    Text(timeFrame.rawValue)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundColor(selectedTimeFrame == timeFrame ? .white : Color(red: 0.5, green: 0.5, blue: 0.5))
                        .frame(maxWidth: .infinity)
                        .frame(height: 34)
                        .background(selectedTimeFrame == timeFrame ? tertiaryGreen : Color.white)
                        .cornerRadius(10)
                        .shadow(color: .gray.opacity(0.3), radius: 3, x: 0, y: 2)
                }
                
                if timeFrame != TimeFrame.allCases.last {
                    Spacer()
                }
            }
        }
        .padding(.horizontal, 24)
    }

    // Shows the chart
    private var chartDisplay: some View {
        VStack(spacing: 12) {
            ZStack {
                // Simplified chart with sample data
                Chart(getChartData()) { dataPoint in
                    BarMark(
                        x: .value("Period", dataPoint.label),
                        y: .value("Steps", dataPoint.steps)
                    )
                    .foregroundStyle(primaryGreen)
                    .cornerRadius(2)
                }
                .chartYScale(domain: 0...getMaxYValue())
                .chartXAxis {
                    AxisMarks { _ in
                        AxisValueLabel()
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .chartYAxis {
                    AxisMarks(position: .leading) { _ in
                        AxisGridLine()
                            .foregroundStyle(Color.gray.opacity(0.3))
                        AxisValueLabel()
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
                .frame(height: 200)
                
                if let selectedPoint = selectedDataPoint {
                    VStack {
                        Text("\(selectedPoint.steps) steps")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.white)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(tertiaryGreen)
                            .cornerRadius(6)
                        Spacer()
                    }
                    .padding(.top, 20)
                }
            }
            .onTapGesture { location in
                handleChartTap(at: location)
            }
            
            // Sun and moon icons for day mode
            if selectedTimeFrame == .day {
                HStack {
                    Image(systemName: "sun.max.fill")
                        .foregroundColor(.orange)
                        .font(.title2)
                    Spacer()
                    Image(systemName: "moon.fill")
                        .foregroundColor(.blue)
                        .font(.title2)
                }
                .padding(.horizontal, 20)
            }
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 24)
    }
    
    // MARK: - Helper Methods
    
    private func statisticBlock(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundColor(.gray)
            
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 1)
                .frame(maxWidth: .infinity)
            
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(color)
                .lineLimit(1)
                .minimumScaleFactor(0.6)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
                .lineLimit(1)
        }
    }
    
    private func getChartData() -> [ChartDataPoint] {
        switch selectedTimeFrame {
        case .day:
            return getDayData()
        case .week:
            return getWeekData()
        case .month:
            return getMonthData()
        case .year:
            return getYearData()
        }
    }
    
    private func getDayData() -> [ChartDataPoint] {
        // Sample steps data for every hour of the current day!
        return [
            ChartDataPoint(id: UUID(), label: "12am", steps: 45, date: Date()),
            ChartDataPoint(id: UUID(), label: "2am", steps: 12, date: Date()),
            ChartDataPoint(id: UUID(), label: "4am", steps: 8, date: Date()),
            ChartDataPoint(id: UUID(), label: "6am", steps: 234, date: Date()),
            ChartDataPoint(id: UUID(), label: "8am", steps: 567, date: Date()),
            ChartDataPoint(id: UUID(), label: "10am", steps: 432, date: Date()),
            ChartDataPoint(id: UUID(), label: "12pm", steps: 678, date: Date()),
            ChartDataPoint(id: UUID(), label: "2pm", steps: 543, date: Date()),
            ChartDataPoint(id: UUID(), label: "4pm", steps: 789, date: Date()),
            ChartDataPoint(id: UUID(), label: "6pm", steps: 921, date: Date()),
            ChartDataPoint(id: UUID(), label: "8pm", steps: 654, date: Date()),
            ChartDataPoint(id: UUID(), label: "10pm", steps: 321, date: Date())
        ]
    }
    
    private func getWeekData() -> [ChartDataPoint] {
        // Sample steps data for every day of the current week!
        return [
            ChartDataPoint(id: UUID(), label: "Sun", steps: 5432, date: Date()),
            ChartDataPoint(id: UUID(), label: "Mon", steps: 7834, date: Date()),
            ChartDataPoint(id: UUID(), label: "Tue", steps: 6542, date: Date()),
            ChartDataPoint(id: UUID(), label: "Wed", steps: 8765, date: Date()),
            ChartDataPoint(id: UUID(), label: "Thu", steps: 5432, date: Date()),
            ChartDataPoint(id: UUID(), label: "Fri", steps: 9876, date: Date()),
            ChartDataPoint(id: UUID(), label: "Sat", steps: 4321, date: Date())
        ]
    }
    
    private func getMonthData() -> [ChartDataPoint] {
        // Sample steps data for every week of the current month!
        return [
            ChartDataPoint(id: UUID(), label: "W1", steps: 45321, date: Date()),
            ChartDataPoint(id: UUID(), label: "W2", steps: 52145, date: Date()),
            ChartDataPoint(id: UUID(), label: "W3", steps: 48967, date: Date()),
            ChartDataPoint(id: UUID(), label: "W4", steps: 51234, date: Date())
        ]
    }
    
    private func getYearData() -> [ChartDataPoint] {
        // Sample steps data for every month of the current year!
        return [
            ChartDataPoint(id: UUID(), label: "Jan", steps: 198765, date: Date()),
            ChartDataPoint(id: UUID(), label: "Feb", steps: 176543, date: Date()),
            ChartDataPoint(id: UUID(), label: "Mar", steps: 203456, date: Date()),
            ChartDataPoint(id: UUID(), label: "Apr", steps: 187654, date: Date()),
            ChartDataPoint(id: UUID(), label: "May", steps: 214567, date: Date()),
            ChartDataPoint(id: UUID(), label: "Jun", steps: 195432, date: Date()),
            ChartDataPoint(id: UUID(), label: "Jul", steps: 189876, date: Date()),
            ChartDataPoint(id: UUID(), label: "Aug", steps: 0, date: Date()),
            ChartDataPoint(id: UUID(), label: "Sep", steps: 0, date: Date()),
            ChartDataPoint(id: UUID(), label: "Oct", steps: 0, date: Date()),
            ChartDataPoint(id: UUID(), label: "Nov", steps: 0, date: Date()),
            ChartDataPoint(id: UUID(), label: "Dec", steps: 0, date: Date())
        ]
    }
    
    private func getMaxYValue() -> Int {
        let maxSteps = getChartData().map { $0.steps }.max() ?? 0
        
        if maxSteps <= 1000 {
            return ((maxSteps / 100) + 1) * 100
        } else if maxSteps <= 5000 {
            return ((maxSteps / 500) + 1) * 500
        } else if maxSteps <= 10000 {
            return ((maxSteps / 1000) + 1) * 1000
        } else {
            return ((maxSteps / 10000) + 1) * 10000
        }
    }
    
    private func handleChartTap(at location: CGPoint) {
        let data = getChartData()
        let screenWidth = UIScreen.main.bounds.width - 48
        let tapIndex = Int(location.x / screenWidth * CGFloat(data.count))
        
        if tapIndex >= 0 && tapIndex < data.count {
            selectedDataPoint = data[tapIndex]
        }
    }
    
    // Generation of steps data to display for the bar graph!
    private func generateSampleHourlyData() {
        allHourlyStepData = []
        // You can expand this later with real data processing!
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

// MARK: - Data Structures

enum TimeFrame: String, CaseIterable {
    case day = "Day"
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct HourlyStepData: Identifiable {
    let id = UUID()
    let date: Date
    let steps: Int
}

struct ChartDataPoint: Identifiable {
    let id: UUID
    let label: String
    let steps: Int
    let date: Date
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
