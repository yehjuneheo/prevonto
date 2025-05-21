import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity, Dimensions, Platform } from 'react-native';

const { width, height } = Dimensions.get('window');

const getResponsiveFontSize = () => {
  if (Platform.OS === 'web') {
    if (width > 1200) return '4.5em';
    if (width > 800) return '4.2em';
    return '4em';
  }
  return width < 360 ? 20 : 24;
};

export default function OnboardingPage({ title, onNext }) {
  return (
    <View style={styles.container}>
      <Text style={[styles.title, { fontSize: getResponsiveFontSize() }]}>{title}</Text>
      <TouchableOpacity style={styles.button} onPress={onNext}>
        <Text style={styles.buttonText}>{'\u2192'}</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
    paddingHorizontal: width * 0.1,
  },
  title: {
    fontWeight: 'bold',
    color: 'rgb(3, 84, 46)',
    textAlign: 'center',
    marginBottom: height * 0.1,
  },
  button: {
    width: '9em',
    height: '9em',
    borderRadius: 40,
    backgroundColor: 'rgb(3, 84, 46)',
    justifyContent: 'center',
    alignItems: 'center',
    marginTop: height * 0.05,
    ...Platform.select({
      ios: {
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 4 },
        shadowOpacity: 0.25,
        shadowRadius: 4,
      },
      android: {
        elevation: 5,
      },
    }),
  },
  buttonText: {
    color: '#fff',
    fontSize: '6em',
    fontWeight: 'bold',
    justifyContent: 'center',
  },
});
