// Sign up Screen for Prevonto App
import React, { useState, useEffect } from 'react';
import { 
    View, 
    Text, 
    StyleSheet, 
    TextInput, 
    TouchableOpacity,
    Dimensions,
    KeyboardAvoidingView,
    Platform
} from 'react-native';
import Icon from 'react-native-vector-icons/FontAwesome';
import { SafeAreaView } from 'react-native-safe-area-context';

// Get the application window's current width and height
const { width, height } = Dimensions.get('window');

// Function to calculate responsive width based on screen size
const responsiveWidth = (percentage) => {
    return width * (percentage / 100)
}

const responsiveHeight = (percentage) => {
    return height * (percentage / 100);
}

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
    const [currentQuote, setCurrentQuote] = useState(quotes[0]); // Default quote 

    // Update with a different random quote every 8 seconds
    useEffect(() => {
        const intervalId = setInterval(() => {
            const randomIndex = Math.floor(Math.random() * quotes.length);
            setCurrentQuote(quotes[randomIndex]);
        }, 8000);

        // Cleanup interval on component unmount
        return () => clearInterval(intervalId);
    }, []);

    {/* Authentication Check and controls which page to go to next */}
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

        // This is where we'll implement the sign-up logic
        // For now, we'll just navigate to a success screen or dashboard
        navigation.navigate('SelectGender');
    };

    return (
        <SafeAreaView style={styles.safeArea}>
            <KeyboardAvoidingView
                behavior={Platform.OS === "ios" ? "padding" : "height"}
                style={styles.keyboardAvoidingView}
            >
                <View style={styles.container}>
                    {/* Header */}
                    <Text style={styles.header}>Let's get Started</Text>
                    <Text style={styles.quote}>{currentQuote}</Text>

                    {/* Input Fields */}
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

                    {/* Terms and Conditions */}
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
                            <Text style={styles.termsLink}>Terms of Use</Text>.
                        </Text>
                    </View>

                    {/* Join Button */}
                    <TouchableOpacity 
                        style={styles.joinButton}
                        onPress={handleSignUp}
                    >
                        <Text style={styles.joinButtonText}>Join</Text>
                    </TouchableOpacity>

                    {/* Social Media Buttons */}
                    <View style={styles.socialContainer}>
                        <TouchableOpacity style={styles.socialButton}>
                            <Icon name="google" size={responsiveWidth(6)} color="#DB4437" />
                        </TouchableOpacity>
                        <TouchableOpacity style={styles.socialButton}>
                            <Icon name="facebook" size={responsiveWidth(6)} color="#4267B2" />
                        </TouchableOpacity>
                    </View>
                </View>
            </KeyboardAvoidingView>
        </SafeAreaView>
    );
}

const styles = StyleSheet.create({
    safeArea: {
        flex: 1,
        backgroundColor: '#f7f7f7',
    },
    keyboardAvoidingView: {
        flex: 1,
        justifyContent: 'center',
        alignItems: 'center',
    },
    container: {
        flex: 1,
        alignItems: 'center',
        backgroundColor: '#fff',
        width: responsiveWidth(80),
        height: responsiveHeight(20),
        paddingVertical: responsiveHeight(2.5),
        paddingHorizontal: responsiveWidth(5),
        borderRadius: responsiveWidth(2),
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 2 },
        shadowOpacity: 0.1,
        shadowRadius: responsiveWidth(1.5),
        elevation: 4,
        marginVertical: '5%',
    },
    header: {
        fontSize: '5em',
        fontWeight: 'bold',
        color: 'rgb(3, 84, 46)',
        marginBottom: responsiveHeight(2),
        textAlign: 'center',
    },
    quote: {
        fontSize: '2.5em',
        color: '#666',
        marginBottom: responsiveHeight(8),
        textAlign: 'center',
        fontStyle: 'italic',
    },
    inputContainer: {
        width: '100%',
        marginBottom: responsiveHeight(2),
    },
    inputLabel: {
        fontSize: '2.5em',
        color: '#666',
        marginBottom: responsiveHeight(0.5),
    },
    input: {
        width: '100%',
        height: responsiveHeight(6),
        borderBottomWidth: 1,
        borderBottomColor: '#ccc',
        paddingHorizontal: responsiveWidth(2),
        fontSize: '2em',
    },
    termsContainer: {
        flexDirection: 'row',
        alignItems: 'center',
        marginVertical: responsiveWidth(3),
    },
    checkbox: {
        width: responsiveWidth(3),
        height: responsiveWidth(3),
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
        fontSize: '2em',
        color: '#666',
        flex: 1,
    },
    termsLink: {
        color: 'rgb(3, 84, 46)',
        textDecorationLine: 'underline',
    },
    joinButton: {
        width: '100%',
        height: responsiveHeight(7),
        backgroundColor: 'rgb(3, 84, 46)',
        borderRadius: responsiveWidth(4),
        justifyContent: 'center',
        alignItems: 'center',
        marginBottom: responsiveWidth(4),
    },
    joinButtonText: {
        color: 'white',
        fontSize: '3.5em',
        fontWeight: 'bold',
    },
    socialContainer: {
        flexDirection: 'row',
        justifyContent: 'center',
        width: '100%',
        marginTop: 10,
    },
    socialButton: {
        width: '8em',
        height: '8em',
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