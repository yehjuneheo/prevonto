// This is the Steps and Activity Page!
import SwiftUI
import Charts

struct StepsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stepData: [StepReading] = []
    
    // Updated color scheme using secondary green and monochromatic variants
    let primaryGreen = Color(red: 0.01, green: 0.33, blue: 0.18)     // Outermost ring - Move/Calories
    let secondaryGreen = Color(red: 0.39, green: 0.59, blue: 0.38)   // Middle ring - Exercise/Minutes
    let tertiaryGreen =  Color(red: 0.23, green: 0.51, blue: 0.36)      // Innermost ring - Stand/Hours
    
    // Define current and target values for accurate progress calculation
    let caloriesCurrent: Double = 479
    let caloriesTarget: Double = 800
    let exerciseCurrent: Double = 50
    let exerciseTarget: Double = 30
    let standCurrent: Double = 3
    let standTarget: Double = 12
    
    // Accurate progress calculations that match statistical data
    var caloriesProgress: Double {
        min(caloriesCurrent / caloriesTarget, 1.0) // 479/800 = 59.875% (incomplete ring)
    }
    
    var exerciseProgress: Double {
        min(exerciseCurrent / exerciseTarget, 1.0) // 50/30 = 166.67% → 100% (complete ring - goal exceeded)
    }
    
    var standProgress: Double {
        min(standCurrent / standTarget, 1.0) // 3/12 = 25% (incomplete ring)
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
                    VStack(spacing: 32) {
                        // Title and description - left aligned
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
                        
                        // New Changes: Fixed alignment and solid colors for rings
                        HStack(alignment: .center, spacing: 0) {
                            // New Changes: Activity Rings with perfect alignment and solid colors
                            ZStack {
                                // Outer ring - Move (Primary Green) - Calories: 59.875% progress
                                Circle()
                                    .stroke(primaryGreen.opacity(0.15), lineWidth: 16)
                                    .frame(width: 160, height: 160)
                                
                                Circle()
                                    .trim(from: 0, to: caloriesProgress) // 59.875% fill (479/800)
                                    // New Changes: Use solid color instead of gradient to eliminate color variations
                                    .stroke(primaryGreen, style: StrokeStyle(lineWidth: 16, lineCap: .round))
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-90))
                                
                                // Middle ring - Exercise (Secondary Green) - Minutes: 100% progress (goal exceeded)
                                Circle()
                                    .stroke(tertiaryGreen.opacity(0.15), lineWidth: 12)
                                    .frame(width: 120, height: 120)
                                
                                Circle()
                                    .trim(from: 0, to: exerciseProgress) // 100% fill (50/30 exceeds goal)
                                    // New Changes: Use solid color instead of gradient
                                    .stroke(tertiaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                
                                // Inner ring - Stand (Stand Green) - Hours: 25% progress
                                Circle()
                                    .stroke(secondaryGreen.opacity(0.15), lineWidth: 8)
                                    .frame(width: 80, height: 80)

                                Circle()
                                    .trim(from: 0, to: standProgress)
                                    .stroke(secondaryGreen, style: StrokeStyle(lineWidth: 8, lineCap: .round))
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                            }
                            // New Changes: Precise alignment - align leftmost edge of rings with text
                            .alignmentGuide(.leading) { d in
                                d[.leading] - 80
                            }
                            .padding(.leading, 30) // Match title padding
                            
                            Spacer()
                            
                            // Statistics display without circle dots
                            VStack(alignment: .leading, spacing: 24) {
                                // Move - Calories Burned
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Move")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("\(Int(caloriesCurrent))/\(Int(caloriesTarget))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(primaryGreen)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Text("Calories Burned")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                
                                // Exercise - Minutes Moving
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Exercise")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("\(Int(exerciseCurrent))/\(Int(exerciseTarget))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(tertiaryGreen)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Text("Minutes Moving")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                
                                // Stand - Hours Standing
                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Stand")
                                        .font(.subheadline)
                                        .fontWeight(.medium)
                                        .foregroundColor(.gray)
                                    
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.3))
                                        .frame(height: 1)
                                        .frame(maxWidth: .infinity)
                                    
                                    Text("\(Int(standCurrent))/\(Int(standTarget))")
                                        .font(.title2)
                                        .fontWeight(.bold)
                                        .foregroundColor(secondaryGreen)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.8)
                                    
                                    Text("Hours Standing")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }
                            .frame(maxWidth: 150)
                            .padding(.trailing, 24)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 20)
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
