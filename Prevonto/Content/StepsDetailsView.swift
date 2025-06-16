// This is the Steps and Activity Page!
import SwiftUI
import Charts

struct StepsDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var stepData: [StepReading] = []
    
    // Color schemes for the Steps and Activity page
    let primaryGreen = Color(red: 0.01, green: 0.33, blue: 0.18)
    let secondaryGreen = Color(red: 0.39, green: 0.59, blue: 0.38)
    let tertiaryGreen =  Color(red: 0.23, green: 0.51, blue: 0.36)
    
    // Define current and target values for accurate progress calculation
    let caloriesCurrent: Double = 47900
    let caloriesTarget: Double = 80000
    let exerciseCurrent: Double = 50
    let exerciseTarget: Double = 30
    let standCurrent: Double = 3
    let standTarget: Double = 12
    
    // Progress for # of Calories Burned calculation
    var caloriesProgress: Double {
        min(caloriesCurrent / caloriesTarget, 1.0)
    }
    
    // Progress for # of Minutes Exercised calculation
    var exerciseProgress: Double {
        min(exerciseCurrent / exerciseTarget, 1.0)
    }
    
    // Progress for # of Hours Exercised calculation
    var standProgress: Double {
        min(standCurrent / standTarget, 1.0)
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                ScrollView {
                    VStack(spacing: 32) {
                        // Steps & Activity page title and description
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
                        
                        // Contains the 3 Activity Rings and the Statistics Display
                        HStack(alignment: .center, spacing: 0) {
                            // Displays 3 Activity Rings
                            ZStack {
                                // Outer ring is for # of Calories Burned progress
                                Circle()
                                    .stroke(primaryGreen.opacity(0.15), lineWidth: 12)
                                    .frame(width: 160, height: 160)
                                
                                Circle()
                                    .trim(from: 0, to: caloriesProgress) // 59.875% fill (479/800)
                                    .stroke(primaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .frame(width: 160, height: 160)
                                    .rotationEffect(.degrees(-90))
                                
                                // Middle ring is for # of Minutes Exercised progress
                                Circle()
                                    .stroke(tertiaryGreen.opacity(0.15), lineWidth: 12)
                                    .frame(width: 120, height: 120)
                                
                                Circle()
                                    .trim(from: 0, to: exerciseProgress) // 100% fill (50/30 exceeds goal)
                                    .stroke(tertiaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .frame(width: 120, height: 120)
                                    .rotationEffect(.degrees(-90))
                                
                                // Inner ring is for # of Hours Standing progress
                                Circle()
                                    .stroke(secondaryGreen.opacity(0.15), lineWidth: 12)
                                    .frame(width: 80, height: 80)

                                Circle()
                                    .trim(from: 0, to: standProgress)
                                    .stroke(secondaryGreen, style: StrokeStyle(lineWidth: 12, lineCap: .round))
                                    .frame(width: 80, height: 80)
                                    .rotationEffect(.degrees(-90))
                            }
                            // Controls positioning of the 3 Activity rings
                            .alignmentGuide(.leading) { d in
                                d[.leading] - 80
                            }
                            .padding(.leading, 30)
                            
                            Spacer()
                            
                            // Statistics display
                            VStack(alignment: .leading, spacing: 24) {
                                // Move - Calories Burned Progress Statistic
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Move")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
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
                                        .minimumScaleFactor(0.6)
                                    
                                    Text("Calories Burned")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                
                                // Exercise - Minutes Exercising Progress Statistic
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Exercise")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
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
                                        .minimumScaleFactor(0.6)
                                    
                                    Text("Minutes Moving")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                                
                                // Stand - Hours Standing Progress Statistic
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Stand")
                                        .font(.subheadline)
                                        .fontWeight(.semibold)
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
                                        .minimumScaleFactor(0.6)
                                    
                                    Text("Hours Standing")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                        .lineLimit(1)
                                }
                            }
                            .frame(maxWidth: 160)
                            .padding(.trailing, 18)
                        }
                        
                        Spacer(minLength: 100)
                    }
                    .padding(.top, 16)
                }
            }
        }
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
