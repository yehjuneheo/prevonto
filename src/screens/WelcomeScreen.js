import React from 'react';
import { View, Text, StyleSheet, TouchableOpacity } from 'react-native';

export default function WelcomeScreen({ navigation }) {
  return (
    <View style={styles.container}>
      {/* Prevonto App Title & Message */}
      <View style={styles.content}>
        <Text style={styles.title}>Prevonto</Text>
        <Text style={styles.subtitle}>Let's Take Control...</Text>
      </View>
      
      {/* Let's Go Button */}
      <TouchableOpacity 
        style={styles.button}
        onPress={() => navigation.navigate('Onboarding')}
      >
        <View style={styles.buttonContent}>
          <Text style={styles.buttonText}>Let's Go</Text>
          <Text style={styles.buttonIcon}>→</Text>
        </View>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    justifyContent: 'space-between',
    alignItems: 'center',
    backgroundColor: '#fff',
    padding: 24,
  },
  content: {
    flex: 1,
    justifyContent: 'center',
    alignItems: 'center',
  },
  title: {
    fontSize: '4em',
    fontWeight: 'bold',
    color: 'rgb(3, 84, 46)',
  },
  subtitle: {
    fontSize: '2.3em',
    color: 'rgb(64, 84, 112)',
    marginTop: 8,
    marginBottom: 64,
  },
  button: {
    backgroundColor: 'rgb(3, 84, 46)',
    borderRadius: 15,
    width: '30em',
    paddingVertical: 25,
    paddingHorizontal: 50,
    marginBottom: '5%',
  },
  buttonContent: {
    flexDirection: 'row',
    justifyContent: 'center',
    alignItems: 'center',
  },
  buttonText: {
    color: 'white',
    fontSize: '1.7em',
    fontWeight: 'bold',
  },
  buttonIcon: {
    color: 'white',
    fontSize: 16,
    marginLeft: 8,
  },
});
