// Activity Manager page 2 - Weight Screen
import React, { useState } from 'react';
import { 
  View, 
  Text, 
  StyleSheet, 
  TouchableOpacity, 
  Dimensions 
} from 'react-native';

// Get the application window's current width
const { width } = Dimensions.get('window');

// Function to calculate responsive width
const responsiveWidth = (percentage) => width * (percentage / 100);

export default function WeightScreen({ navigation }) {
  const [unit, setUnit] = useState('lbs'); // Default unit
  const [weight, setWeight] = useState(140); // Default weight

  // Navigate to the next screen
  const handleNext = () => {
    navigation.navigate('Dashboard');
  };

  return (
    <View style={styles.container}>
      {/* Weight Screen's Header */}
      <Text style={styles.header}>What is your weight?</Text>

      {/* Unit Selector */}
      <View style={styles.unitSelector}>
        <TouchableOpacity 
          style={[styles.unitButton, unit === 'lbs' && styles.unitSelected]} 
          onPress={() => setUnit('lbs')}
        >
          <Text style={[styles.unitText, unit === 'lbs' && styles.unitTextSelected]}>
            lbs
          </Text>
        </TouchableOpacity>
        <TouchableOpacity 
          style={[styles.unitButton, unit === 'kg' && styles.unitSelected]} 
          onPress={() => setUnit('kg')}
        >
          <Text style={[styles.unitText, unit === 'kg' && styles.unitTextSelected]}>
            kg
          </Text>
        </TouchableOpacity>
      </View>

      {/* Weight Display */}
      <View style={styles.weightDisplay}>
        <Text style={styles.weightValue}>{Math.round(weight)}</Text>
        <Text style={styles.weightUnit}>{unit}</Text>
      </View>

      {/* 
        Need to develop the Weight Slider here later. 
        Currently encountered bugs and dependency conflicts 
        that caused a white page error when trying to 
        implement the slider. 
      */}

      {/* Controls which page to go to next */}
      <TouchableOpacity 
        style={styles.nextButton} 
        onPress={handleNext}
      >
        <Text style={styles.nextButtonText}>Let's keep going</Text>
      </TouchableOpacity>
    </View>
  );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        backgroundColor: '#f7f7f7',
        paddingHorizontal: responsiveWidth(5),
        paddingVertical: responsiveWidth(5),
        alignItems: 'center',
    },
    header: {
        fontSize: responsiveWidth(6),
        fontWeight: 'bold',
        color: 'rgb(3,84,46)',
        marginBottom: responsiveWidth(5),
        textAlign: 'center',
    },
    unitSelector: {
        flexDirection: 'row',
        marginBottom: responsiveWidth(5),
    },
    unitButton: {
        paddingHorizontal: responsiveWidth(4),
        paddingVertical: responsiveWidth(2),
        borderRadius: responsiveWidth(2),
        backgroundColor: '#fff',
        marginHorizontal: responsiveWidth(2),
        borderWidth: 1,
        borderColor: '#ccc',
    },
    unitSelected: {
        backgroundColor: 'rgb(3,84,46)',
        borderColor: 'rgb(3,84,46)',
    },
    unitText: {
        fontSize: responsiveWidth(4),
        color: '#333',
    },
    unitTextSelected: {
        color: '#fff',
        fontWeight: 'bold',
    },
    weightDisplay: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: responsiveWidth(5),
    },
    weightValue: {
        fontSize: responsiveWidth(8),
        fontWeight: 'bold',
        color: 'rgb(3,84,46)',
    },
    weightUnit: {
        fontSize: responsiveWidth(4),
        marginLeft: responsiveWidth(1),
        color: '#666',
    },
    nextButton: {
        width: '100%',
        height: responsiveWidth(12),
        backgroundColor: 'rgb(3,84,46)',
        borderRadius: responsiveWidth(6),
        justifyContent: 'center',
        alignItems: 'center',
    },
    nextButtonText: {
        color: '#fff',
        fontSize: responsiveWidth(4.5),
        fontWeight: 'bold',
    },
});
