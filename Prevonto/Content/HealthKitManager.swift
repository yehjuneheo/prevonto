import HealthKit

class HealthKitManager {
    let healthStore = HKHealthStore()
    
    // Request authorization for step count, calories burned, distance, and heart rate.
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard let stepCountType = HKObjectType.quantityType(forIdentifier: .stepCount),
              let calorieType = HKObjectType.quantityType(forIdentifier: .activeEnergyBurned),
              let distanceType = HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning),
              let heartRateType = HKObjectType.quantityType(forIdentifier: .heartRate)
        else {
            completion(false, nil)
            return
        }
        
        let readTypes: Set<HKObjectType> = [stepCountType, calorieType, distanceType, heartRateType]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { success, error in
            DispatchQueue.main.async {
                completion(success, error)
            }
        }
    }
    
    // Fetch today's step count
    func fetchTodayStepCount(completion: @escaping (Double?, Error?) -> Void) {
        guard let stepCountType = HKQuantityType.quantityType(forIdentifier: .stepCount) else {
            completion(nil, nil)
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepCountType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let steps = result?.sumQuantity()?.doubleValue(for: HKUnit.count())
            DispatchQueue.main.async { completion(steps, nil) }
        }
        
        healthStore.execute(query)
    }
    
    // Fetch today's calories burned
    func fetchTodayCalories(completion: @escaping (Double?, Error?) -> Void) {
        guard let calorieType = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else {
            completion(nil, nil)
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: calorieType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            // Calories are returned in kilocalories
            let calories = result?.sumQuantity()?.doubleValue(for: HKUnit.kilocalorie())
            DispatchQueue.main.async { completion(calories, nil) }
        }
        
        healthStore.execute(query)
    }
    
    // Fetch today's walking/running distance
    func fetchTodayDistance(completion: @escaping (Double?, Error?) -> Void) {
        guard let distanceType = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else {
            completion(nil, nil)
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, error in
            if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            // Distance is typically returned in meters; convert to kilometers
            let distanceMeters = result?.sumQuantity()?.doubleValue(for: HKUnit.meter())
            let distanceKilometers = distanceMeters.map { $0 / 1000.0 }
            DispatchQueue.main.async { completion(distanceKilometers, nil) }
        }
        
        healthStore.execute(query)
    }
    
    // Fetch today's average heart rate (in beats per minute)
    func fetchTodayHeartRate(completion: @escaping (Double?, Error?) -> Void) {
        guard let heartRateType = HKQuantityType.quantityType(forIdentifier: .heartRate) else {
            completion(nil, nil)
            return
        }
        
        let calendar = Calendar.current
        let now = Date()
        let startOfDay = calendar.startOfDay(for: now)
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        // Use .discreteAverage to compute the average heart rate for the day
        let query = HKStatisticsQuery(quantityType: heartRateType,
                                      quantitySamplePredicate: predicate,
                                      options: .discreteAverage) { _, result, error in
            if let error = error {
                DispatchQueue.main.async { completion(nil, error) }
                return
            }
            
            let avgHeartRate = result?.averageQuantity()?.doubleValue(for: HKUnit.count().unitDivided(by: HKUnit.minute()))
            DispatchQueue.main.async { completion(avgHeartRate, nil) }
        }
        
        healthStore.execute(query)
    }
}
