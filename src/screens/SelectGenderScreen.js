// Activity Manager Page 1 - Select Gender
import React, { useState } from 'react';
import { 
    View, 
    Text, 
    StyleSheet, 
    TouchableOpacity, 
    Dimensions 
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';

// Get the application window's current width
const { width } = Dimensions.get('window');

// Function to calculate responsive width
const responsiveWidth = (percentage) => width * (percentage / 100);

export default function SelectGenderScreen({ navigation }) {
    const [selectedOption, setSelectedOption] = useState(null);

    const genderOptions = [
        { label: 'Female', value: 'female', icon: 'plus' },
        { label: 'Male', value: 'male', icon: 'male' },
        { label: 'Other', value: 'other', icon: 'user' },
        { label: 'Prefer not to say', value: 'prefer_not_to_say', icon: 'user-secret' },
    ];

    const handleOptionPress = (value) => {
        setSelectedOption(value === selectedOption ? null : value);
    };

    {/* Control which page to go next */}
    const handleNext = () => {
        if (selectedOption) {
            navigation.navigate('Weight');
        }
    };

    return (
        <View style={styles.container}>
            {/* Select Gender's Header */}
            <Text style={styles.header}>Select Gender</Text>

            {/* Select Gender Buttons */}
            {genderOptions.map((option) => (
                <TouchableOpacity
                    key={option.value}
                    style={[
                    styles.optionContainer,
                    selectedOption === option.value && styles.optionSelected,
                    ]}
                    onPress={() => handleOptionPress(option.value)}
                >
                    <View style={styles.optionIcon}>
                    <Icon name={option.icon} size={35} color={selectedOption === option.value ? '#fff' : '#666'} />
                    </View>
                    <Text style={[
                    styles.optionLabel,
                    selectedOption === option.value && styles.optionLabelSelected,
                    ]}>
                    {option.label}
                    </Text>
                    <View style={[
                    styles.checkbox,
                    selectedOption === option.value && styles.checkboxSelected,
                    ]}>
                    {selectedOption === option.value && <Text style={styles.checkmark}>✓</Text>}
                    </View>
                </TouchableOpacity>
            ))}

            {/* Let's keep going button */}
            <TouchableOpacity
                style={[
                    styles.nextButton,
                    !selectedOption && styles.nextButtonDisabled,
                ]}
                onPress={handleNext}
                disabled={!selectedOption}
            >
                <Text style={[
                    styles.nextButtonText,
                    !selectedOption && styles.nextButtonTextDisabled,
                ]}>
                    Let's keep going
                </Text>
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
        fontSize: responsiveWidth(7),
        fontWeight: 'bold',
        color: 'rgb(3,84,46)',
        marginBottom: responsiveWidth(7),
    },
    optionContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        justifyContent: 'space-between',
        backgroundColor: '#fff',
        borderRadius: responsiveWidth(2),
        paddingHorizontal: responsiveWidth(4),
        paddingVertical: responsiveWidth(3),
        marginBottom: responsiveWidth(5),
        width: responsiveWidth(80),
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: responsiveWidth(1.5),
        elevation: 2,
    },
    optionSelected: {
      backgroundColor: 'rgb(3,84,46)',
      borderColor:'#blue',
    },
    optionIcon: {
        marginRight: responsiveWidth(3),
    },
    optionLabel: {
        fontSize: responsiveWidth(4),
        color: '#333',
    },
    optionLabelSelected: {
        color: '#fff',
    },
    checkbox: {
        width: responsiveWidth(5),
        height: responsiveWidth(5),
        borderWidth: 1,
        borderColor: '#ccc',
        borderRadius: responsiveWidth(1),
        justifyContent: 'center',
        alignItems: 'center',
    },
    checkboxSelected: {
        backgroundColor: '#fff',
    },
    checkmark: {
        color: 'rgb(3, 84, 46)',
        fontWeight: 'bold',
    },
    nextButton: {
        width: responsiveWidth(80),
        height: responsiveWidth(12),
        borderRadius: responsiveWidth(6), 
        backgroundColor: 'rgb(3,84,46)', 
        justifyContent: 'center',
        alignItems: 'center',
        elevation: 2, 
    },
    nextButtonDisabled: {
        backgroundColor: '#ccc',
    },
    nextButtonText: {
        fontSize: responsiveWidth(4),
        fontWeight: 'bold',
        color: '#fff',
    },
    nextButtonTextDisabled: {
        color: '#999', 
    },
});