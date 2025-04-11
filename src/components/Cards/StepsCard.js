import React from 'react';
import { View, Text, StyleSheet } from 'react-native';
import { LinearGradient } from 'expo-linear-gradient';

export default function StepsCard({ count }) {
  return (
    <LinearGradient
      colors={['#176B87', '#04364A']}
      style={styles.card}
      start={{ x: 0, y: 0 }}
      end={{ x: 1, y: 1 }}
    >
      <Text style={styles.title}>Today's Steps</Text>
      <Text style={styles.value}>{count.toLocaleString()}</Text>
    </LinearGradient>
  );
}

const styles = StyleSheet.create({
  card: {
    width: '90%',
    padding: 20,
    marginVertical: 10,
    borderRadius: 20,
    alignItems: 'center',
  },
  title: {
    fontSize: 18,
    color: 'white',
    fontWeight: '600',
    marginBottom: 10,
  },
  value: {
    fontSize: 48,
    color: 'white',
    fontWeight: 'bold',
  },
});
