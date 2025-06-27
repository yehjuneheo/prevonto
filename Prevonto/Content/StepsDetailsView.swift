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
    
    // Fixed: Static chart data that doesn't regenerate UUIDs
    @State private var dayChartData: [ChartDataPoint] = []
    @State private var weekChartData: [ChartDataPoint] = []
    @State private var monthChartData: [ChartDataPoint] = []
    @State private var yearChartData: [ChartDataPoint] = []
    
    // Color schemes for the Steps and Activity page
    let primaryGreen = Color(red: 0.01, green: 0.33, blue: 0.18)
    let secondaryGreen = Color(red: 0.39, green: 0.59, blue: 0.38)
    let tertiaryGreen = Color(red: 0.23, green: 0.51, blue: 0.36)
    
    // New changes: Added bar colors
    let defaultBarColor = Color(red: 0.682, green: 0.698, blue: 0.788) // #AEB2C9
    
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
                        
                        // Chart section with time frame buttons and heading
                        chartControlsSection
                        
                        // New: Separate chart display container
                        chartDisplayContainer
                        
                        Spacer(minLength: 50)
                    }
                    .padding(.top, 16)
                }
            }
        }
        .onAppear {
            loadSampleStepData()
            generateSampleHourlyData()
            initializeChartData() // Fixed: Initialize static chart data
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
    
    // New: Separate chart controls (buttons and heading)
    private var chartControlsSection: some View {
        VStack(spacing: 16) {
            // Time frame buttons
            timeFrameButtons
            
            // Steps Tracker heading with proper alignment
            stepsTrackerHeading
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

    // Steps Tracker heading with left alignment and primaryGreen color
    private var stepsTrackerHeading: some View {
        HStack {
            Text("Steps Tracker")
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(primaryGreen)
            Spacer()
        }
        .padding(.horizontal, 24)
    }

    // New: Chart display container with proper structure
    private var chartDisplayContainer: some View {
        VStack(spacing: 0) {
            // Message box area (top margin)
            ZStack {
                if let selectedPoint = selectedDataPoint {
                    GeometryReader { geometry in
                        let data = getChartData()
                        if let selectedIndex = data.firstIndex(where: { $0.id == selectedPoint.id }) {
                            let chartAreaWidth = geometry.size.width - 32 // Account for chartSection padding
                            let barWidth = chartAreaWidth / CGFloat(data.count)
                            let xPosition = 16 + (CGFloat(selectedIndex) + 0.5) * barWidth
                            
                            // Message box with triangle pointer
                            VStack(spacing: 0) {
                                Text("\(selectedPoint.steps)")
                                    .font(.title2)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                Text("steps")
                                    .font(.caption)
                                    .foregroundColor(.white)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(tertiaryGreen)
                            .cornerRadius(8)
                            .overlay(
                                // Triangle pointer
                                Triangle()
                                    .fill(tertiaryGreen)
                                    .frame(width: 10, height: 6)
                                    .offset(y: 8),
                                alignment: .bottom
                            )
                            .position(
                                x: min(max(xPosition, 50), geometry.size.width - 50),
                                y: 30
                            )
                        }
                    }
                } else {
                    Color.clear
                }
            }
            .frame(height: 60)
            
            // Chart section container (transparent background)
            chartSectionContainer
        }
        .background(Color.white) // chartDisplay container white background
        .cornerRadius(12)
        .shadow(color: .gray.opacity(0.2), radius: 4, x: 0, y: 2)
        .padding(.horizontal, 24)
    }
    
    // New: Chart section with transparent background
    private var chartSectionContainer: some View {
        VStack(spacing: 12) {
            ZStack {
                // Interactive chart with proper bar colors
                Chart(getChartData()) { dataPoint in
                    BarMark(
                        x: .value("Period", dataPoint.label),
                        y: .value("Steps", dataPoint.steps)
                    )
                    .foregroundStyle(selectedDataPoint?.id == dataPoint.id ? tertiaryGreen : defaultBarColor)
                    .cornerRadius(2)
                }
                .chartYScale(domain: 0...getMaxYValue())
                .chartXAxis {
                    if selectedTimeFrame == .day {
                        // Simplified Day Mode axis
                        AxisMarks { _ in
                            AxisValueLabel("")
                        }
                    } else {
                        // Standard axis for other modes
                        AxisMarks { _ in
                            AxisValueLabel()
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }
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
                
                // Vertical dashed line connecting to selected bar
                if let selectedPoint = selectedDataPoint {
                    GeometryReader { geometry in
                        let data = getChartData()
                        if let selectedIndex = data.firstIndex(where: { $0.id == selectedPoint.id }) {
                            let chartWidth = geometry.size.width
                            let barWidth = chartWidth / CGFloat(data.count)
                            let xPosition = (CGFloat(selectedIndex) + 0.5) * barWidth
                            
                            Path { path in
                                path.move(to: CGPoint(x: xPosition, y: -60))
                                path.addLine(to: CGPoint(x: xPosition, y: geometry.size.height))
                            }
                            .stroke(style: StrokeStyle(lineWidth: 2, dash: [4, 4]))
                            .foregroundColor(tertiaryGreen)
                        }
                    }
                }
            }
            .onTapGesture { location in
                handleChartTap(at: location)
            }
            
            // Day Mode labels positioned below chart
            if selectedTimeFrame == .day {
                VStack(spacing: 8) {
                    // Custom positioned labels for 6 AM, 12 PM, 6 PM
                    HStack {
                        ForEach(0..<12, id: \.self) { index in
                            if index == 3 {
                                Text("6 AM")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            } else if index == 6 {
                                Text("12 PM")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            } else if index == 9 {
                                Text("6 PM")
                                    .font(.caption)
                                    .foregroundStyle(.gray)
                            } else {
                                Text("")
                                    .font(.caption)
                            }
                            
                            if index < 11 {
                                Spacer()
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    
                    // Sun and moon icons
                    HStack {
                        Image(systemName: "sun.max")
                            .foregroundColor(.gray)
                            .font(.title2)
                        
                        Spacer()
                        
                        Image(systemName: "moon")
                            .foregroundColor(.gray)
                            .font(.title2)
                    }
                    .padding(.horizontal, 16)
                }
            }
        }
        .padding(16)
        .background(Color.clear) // Transparent background for chartSection
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
    
    // Fixed: Use static chart data
    private func getChartData() -> [ChartDataPoint] {
        switch selectedTimeFrame {
        case .day:
            return dayChartData
        case .week:
            return weekChartData
        case .month:
            return monthChartData
        case .year:
            return yearChartData
        }
    }
    
    // Fixed: Initialize static chart data once
    private func initializeChartData() {
        dayChartData = [
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
        
        weekChartData = [
            ChartDataPoint(id: UUID(), label: "Sun", steps: 5432, date: Date()),
            ChartDataPoint(id: UUID(), label: "Mon", steps: 7834, date: Date()),
            ChartDataPoint(id: UUID(), label: "Tue", steps: 6542, date: Date()),
            ChartDataPoint(id: UUID(), label: "Wed", steps: 8765, date: Date()),
            ChartDataPoint(id: UUID(), label: "Thu", steps: 5432, date: Date()),
            ChartDataPoint(id: UUID(), label: "Fri", steps: 9876, date: Date()),
            ChartDataPoint(id: UUID(), label: "Sat", steps: 4321, date: Date())
        ]
        
        monthChartData = [
            ChartDataPoint(id: UUID(), label: "W1", steps: 45321, date: Date()),
            ChartDataPoint(id: UUID(), label: "W2", steps: 52145, date: Date()),
            ChartDataPoint(id: UUID(), label: "W3", steps: 48967, date: Date()),
            ChartDataPoint(id: UUID(), label: "W4", steps: 51234, date: Date())
        ]
        
        yearChartData = [
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
    
    // Fixed: Simplified tap handling
    private func handleChartTap(at location: CGPoint) {
        let data = getChartData()
        let chartAreaWidth = UIScreen.main.bounds.width - 112 // Total padding (24+24+16+16+32)
        let barWidth = chartAreaWidth / CGFloat(data.count)
        let tapIndex = Int(location.x / barWidth)
        
        print("Tap location: \(location.x), Bar width: \(barWidth), Tap index: \(tapIndex), Data count: \(data.count)")
        
        if tapIndex >= 0 && tapIndex < data.count {
            let tappedDataPoint = data[tapIndex]
            
            withAnimation(.easeInOut(duration: 0.3)) {
                if selectedDataPoint?.id == tappedDataPoint.id {
                    selectedDataPoint = nil
                    print("Deselected bar at index: \(tapIndex)")
                } else {
                    selectedDataPoint = tappedDataPoint
                    print("Selected bar at index: \(tapIndex), steps: \(tappedDataPoint.steps)")
                }
            }
        }
    }
    
    private func generateSampleHourlyData() {
        allHourlyStepData = []
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

// Triangle shape for message box pointer
struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.midX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        path.closeSubpath()
        return path
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

