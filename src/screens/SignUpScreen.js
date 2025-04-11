// Sign up Screen for Prevonto App
import React, { useState } from 'react';
import { 
    View, 
    Text, 
    StyleSheet, 
    TextInput, 
    TouchableOpacity, 
    Image,
    ScrollView,
    Dimensions
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';

// Get the application window's current width
const { width } = Dimensions.get('window');

// Function to calculate responsive width based on screen size
const responsiveWidth = (percentage) => {
    return width * (percentage / 100);
};

// Array of random quotes to display
const quotes = [
    "Prevention is better than cure.",
    "Health is wealth.",
    "Take care of your body. It's the only place you have to live.",
    "Your health is an investment, not an expense."
];

export default function SignUpScreen({ navigation }) {
    const [fullName, setFullName] = useState('');
    const [email, setEmail] = useState('');
    const [password, setPassword] = useState('');
    const [isTermsAccepted, setIsTermsAccepted] = useState(false);

    // Get a random quote from the array
    const randomQuote = quotes[Math.floor(Math.random() * quotes.length)];

    const handleSignUp = () => {
    // Basic validation
    if (!fullName || !email || !password) {
        alert('Please fill in all fields');
        return;
    }

    if (!isTermsAccepted) {
        alert('Please accept the terms of use');
        return;
    }

    // Here you would typically handle the sign-up logic
    // For now, we'll just navigate to a success screen or dashboard
    navigation.navigate('SelectGender');
    };

    return (
        <ScrollView contentContainerStyle={styles.scrollContainer}>
            <View style={styles.container}>
                <Text style={styles.header}>Let's get Started</Text>
                <Text style={styles.quote}>{randomQuote}</Text>
                
                <View style={styles.inputContainer}>
                    <Text style={styles.inputLabel}>Full Name</Text>
                    <TextInput
                    style={styles.input}
                    value={fullName}
                    onChangeText={setFullName}
                    placeholder="Enter your full name"
                    />
                </View>
                
                <View style={styles.inputContainer}>
                    <Text style={styles.inputLabel}>Email</Text>
                    <TextInput
                    style={styles.input}
                    value={email}
                    onChangeText={setEmail}
                    placeholder="Enter your email"
                    keyboardType="email-address"
                    autoCapitalize="none"
                    />
                </View>
                
                <View style={styles.inputContainer}>
                    <Text style={styles.inputLabel}>Password</Text>
                    <TextInput
                    style={styles.input}
                    value={password}
                    onChangeText={setPassword}
                    placeholder="Create a password"
                    secureTextEntry
                    />
                </View>
                
                <View style={styles.termsContainer}>
                    <TouchableOpacity 
                    style={styles.checkbox}
                    onPress={() => setIsTermsAccepted(!isTermsAccepted)}
                    >
                    {isTermsAccepted && <Text style={styles.checkmark}>✓</Text>}
                    </TouchableOpacity>
                    <Text style={styles.termsText}>
                    By continuing you accept our{' '}
                    <Text style={styles.termsLink}>Privacy Policy</Text> and{' '}
                    <Text style={styles.termsLink}>Terms of Use</Text>
                    </Text>
                </View>
                
                <TouchableOpacity 
                    style={styles.joinButton}
                    onPress={handleSignUp}
                >
                    <Text style={styles.joinButtonText}>Join</Text>
                </TouchableOpacity>
                
                <View style={styles.socialContainer}>
                    <TouchableOpacity style={styles.socialButton}>
                        <Icon name="google" size={35} color="#DB4437" />
                    </TouchableOpacity>
                    <TouchableOpacity style={styles.socialButton}>
                        <Icon name="facebook" size={35} color="#4267B2" />
                    </TouchableOpacity>
                </View>
            </View>
        </ScrollView>
    );
}

const styles = StyleSheet.create({
    scrollContainer: {
        flexGrow: 1,
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: '#f7f7f7',
    },
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#fff',
        paddingVertical: responsiveWidth(3),
        paddingHorizontal: responsiveWidth(3),
        width: responsiveWidth(70),
        borderRadius: responsiveWidth(2),
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: responsiveWidth(1.5),
        elevation: 4,
        marginVertical: responsiveWidth(6),
    },
    header: {
        fontSize: responsiveWidth(5),
        fontWeight: 'bold',
        color: 'rgb(3, 84, 46)',
        marginBottom: responsiveWidth(2),
        textAlign: 'center',
    },
    quote: {
        fontSize: responsiveWidth(3),
        color: '#666',
        marginBottom: responsiveWidth(7),
        textAlign: 'center',
        fontStyle: 'italic',
    },
    inputContainer: {
        width: '100%',
        marginBottom: responsiveWidth(5.5),
    },
    inputLabel: {
        fontSize: responsiveWidth(3),
        color: '#666',
        marginBottom: responsiveWidth(0.5),
    },
    input: {
        width: '100%',
        height: responsiveWidth(8),
        borderBottomWidth: 1,
        borderBottomColor: '#ccc',
        paddingHorizontal: responsiveWidth(2),
        fontSize: responsiveWidth(3),
    },
    termsContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: responsiveWidth(2),
        width: '100%',
        marginBottom: responsiveWidth(5),
    },
    checkbox: {
        width: responsiveWidth(3.5),
        height: responsiveWidth(3.5),
        borderWidth: 1,
        borderColor: 'rgb(3, 84, 46)',
        justifyContent: 'center',
        alignItems: 'center',
        marginRight: responsiveWidth(2.5),
    },
    checkmark: {
        color: 'rgb(3, 84, 46)',
        fontWeight: 'bold',
    },
    termsText: {
        fontSize: responsiveWidth(2.8),
        color: '#666',
        flex: 1,
    },
    termsLink: {
        color: 'rgb(3, 84, 46)',
        textDecorationLine: 'underline',
    },
    joinButton: {
        width: '100%',
        height: responsiveWidth(12),
        backgroundColor: 'rgb(3, 84, 46)',
        borderRadius: responsiveWidth(4),
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: responsiveWidth(4),
    },
    joinButtonText: {
        color: 'white',
        fontSize: responsiveWidth(4.5),
        fontWeight: 'bold',
    },
    socialContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        width: '100%',
        marginTop: 10,
    },
    socialButton: {
        width: responsiveWidth(10),
        height: responsiveWidth(10),
        borderWidth: 1,
        borderColor: '#ccc',
        borderRadius: 25,
        justifyContent: 'center',
        alignItems: 'center',
        marginHorizontal: responsiveWidth(3.5),
    },
    socialIcon: {
        color: '#666',
    },
});
