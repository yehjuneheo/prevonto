import React, { useState, useRef } from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Animated, Dimensions } from 'react-native';
import OnboardingPage from '../components/OnboardingPage';

const { width } = Dimensions.get('window');

export default function OnboardingScreen({ navigation }) {
  const [currentPage, setCurrentPage] = useState(0);
  const fadeAnim = useRef(new Animated.Value(1)).current;
  const slideAnim = useRef(new Animated.Value(0)).current;

  const onboardingData = [
    { title: 'Understand Yourself' },
    { title: 'Track your metrics' },
    { title: 'Connect with your doctors' },
  ];

  {/* Handle Page Transitions and controls which page to go next */}
  const handleNext = () => {
    if (currentPage < onboardingData.length - 1) {
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
        setCurrentPage(prev => prev + 1);
        fadeAnim.setValue(1);
        slideAnim.setValue(0);
      });
    } else {
      navigation.navigate('SignUp');
    }
  };

  return (
    <View style={styles.container}>
      <TouchableOpacity
        style={styles.skipButton}
        onPress={() => navigation.navigate('SignUp')}
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
              index === currentPage && styles.paginationDotActive,
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
    padding: 20,
  },
  skipButton: {
    alignSelf: 'flex-end',
    backgroundColor: '#fff',
    borderColor: 'rgb(3,84,46)',
    borderWidth: 2,
    paddingHorizontal: '2em',
    paddingVertical: '0.75em',
    borderRadius: 30,
    marginTop: '1em',
    marginRight: '1em',
    marginBottom: 20,
  },
  skipText: {
    fontSize: '1.5em',
    fontWeight: '500',
    color: 'rgb(3,84,46)',
  },
  pageContainer: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  pagination: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
    marginBottom: 40,
  },
  paginationDot: {
    width: 60,
    height: 16,
    borderRadius: 8,
    backgroundColor: 'rgba(0,0,0,0.2)',
    marginHorizontal: 8,
  },
  paginationDotActive: {
    backgroundColor: 'rgb(3,84,46)',
  },
});