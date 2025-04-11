import React, { useState, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Animated, Dimensions } from 'react-native';
import OnboardingPage from '../components/OnboardingPage';

const { width } = Dimensions.get('window');

export default function OnboardingScreen({ navigation }) {
  const [currentPage, setCurrentPage] = useState(0);
  const fadeAnim = useRef(new Animated.Value(1)).current; // For fade-out effect
  const slideAnim = useRef(new Animated.Value(0)).current; // For slide effect

  const onboardingData = [
    { title: 'Understand Yourself' },
    { title: 'Track your metrics' },
    { title: 'Connect with your doctors' },
  ];

  const handleNext = () => {
    if (currentPage < onboardingData.length - 1) {
      // Animate current page out
      Animated.parallel([
        Animated.timing(fadeAnim, {
          toValue: 0,
          duration: 300,
          useNativeDriver: true,
        }),
        Animated.timing(slideAnim, {
          toValue: -width,
          duration: 300,
          useNativeDriver: true,
        }),
      ]).start(() => {
        // Move to the next page
        setCurrentPage(currentPage + 1);

        // Reset animations for the next page
        fadeAnim.setValue(1);
        slideAnim.setValue(0);
      });
    } else {
      navigation.navigate('Dashboard');
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.skipButton}
        onPress={() => navigation.navigate('Dashboard')}
      >
        <Text style={styles.skipText}>Skip intro</Text>
      </TouchableOpacity>

      <Animated.View
        style={[
          styles.pageContainer,
          {
            opacity: fadeAnim,
            transform: [{ translateX: slideAnim }],
          },
        ]}
      >
        <OnboardingPage
          title={onboardingData[currentPage].title}
          onNext={handleNext}
        />
      </Animated.View>

      <View style={styles.pagination}>
        {onboardingData.map((_, index) => (
          <View
            key={index}
            style={[
              styles.paginationDot,
              index === currentPage ? styles.paginationDotActive : {},
            ]}
          />
        ))}
      </View>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    backgroundColor: '#fff',
  },
  skipButton: {
    alignSelf: 'flex-end',
    backgroundColor: 'rgba(0,0,0,0.1)',
    paddingHorizontal: 16,
    paddingVertical: 8,
    borderRadius: 8,
    margin: 20,
  },
  skipText: {
    fontSize: 16,
    fontWeight: '500',
    color: 'rgb(3,84,46)',
  },
  pageContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    width: '100%',
  },
  pagination: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 40,
  },
  paginationDot: {
    width: '6em',
    height: 16,
    borderRadius: 10,
    backgroundColor: 'rgba(0,0,0,0.3)',
    marginHorizontal: 8,
  },
  paginationDotActive: {
    backgroundColor: 'rgb(3,84,46)',
  },
});
