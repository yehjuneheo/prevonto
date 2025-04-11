// Patient Dashboard page for the App
import React from 'react';
import { View, Text, StyleSheet, ScrollView, TouchableOpacity, SafeAreaView } from 'react-native';
import { useHealthData } from '../hooks/useHealthData';
import StepsCard from '../components/Cards/StepsCard';
import CaloriesCard from '../components/Cards/CaloriesCard';
import DistanceCard from '../components/Cards/DistanceCard';
import HeartRateCard from '../components/Cards/HeartRateCard';

export default function DashboardScreen() {
  const { 
    isAuthorized, 
    authorizationStatus,
    stepCount, 
    calories, 
    distance, 
    heartRate, 
    requestAuthorization
  } = useHealthData();

  return (
    <SafeAreaView style={styles.container}>
      {/* Dashboard's Header */}
      <Text style={styles.header}>Dashboard</Text>
      
      {!isAuthorized ? (
        <View style={styles.authContainer}>
          <Text style={styles.authStatus}>
            HealthKit Status: {authorizationStatus}
          </Text>
          <TouchableOpacity 
            style={styles.authButton}
            onPress={requestAuthorization}
          >
            <Text style={styles.authButtonText}>Request HealthKit Access</Text>
          </TouchableOpacity>
        </View>
      ) : (
        <ScrollView 
          style={styles.scrollView}
          contentContainerStyle={styles.cardContainer}
        >
          {/* Patient Vitals Info Cards */}
          <StepsCard count={stepCount} />
          <CaloriesCard count={calories} />
          <DistanceCard distance={distance} />
          <HeartRateCard rate={heartRate} />
        </ScrollView>
      )}
    </SafeAreaView>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  header: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#000',
    padding: 20,
  },
  authContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    padding: 20,
  },
  authStatus: {
    fontSize: '2.6em',
    marginBottom: 24,
    textAlign: 'center',
  },
  authButton: {
    backgroundColor: 'rgb(3, 84, 46)',
    paddingHorizontal: '1.75em',
    paddingVertical: '1em',
    borderRadius: 8,
  },
  authButtonText: {
    color: 'white',
    fontSize: '2em',
    fontWeight: 'bold',
  },
  scrollView: {
    flex: 1,
  },
  cardContainer: {
    alignItems: 'center',
    paddingBottom: 20,
  },
});
