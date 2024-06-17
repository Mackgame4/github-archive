import {
    View,
    Text,
    Image,
    StyleSheet,
} from '@react-pdf/renderer';

import { colorVars, getLocale } from '../Utils';
import { Config } from '../Config';

const styles = StyleSheet.create({
    title: {
        fontSize: 45,
        textAlign: 'left',
        fontFamily: 'CaviarDreams-Bold',
        fontWeight: 'bold',
    },
    badge: {
        backgroundColor: colorVars.textColor,
        color: colorVars.textForegroundColor,
        padding: 5,
        borderRadius: 5,
        fontSize: 10,
        fontFamily: 'JetBrainsMono-Regular',
        margin: 3,
    },
    header: {
        width: '100%',
        height: 210,
        flexDirection: 'row',
        justifyContent: 'center',
        alignItems: 'center',
        paddingHorizontal: 10,
    },
    leftContainer: {
        width: '55%',
        justifyContent: 'flex-start',
        alignItems: 'flex-start',
    },
    rightContainer: {
        width: '45%',
        justifyContent: 'flex-end',
        alignItems: 'flex-end',
    },
    avatarContainer: {
        width: 160,
        height: 160,
        borderRadius: '50%',
        overflow: 'hidden',
        justifyContent: 'center',
        alignItems: 'center',
        backgroundColor: colorVars.primaryColor,
    },
    avatarImage: {
        width: 158,
        height: 158,
        borderRadius: '50%',
    },
});

const DocHeader = () => (
    <View style={styles.header}>
        <View style={styles.leftContainer}>
            <Text style={[styles.title, { fontFamily: 'CaviarDreams-Regular', color: colorVars.textColor}]}>{Config.firstName}</Text>
            <Text style={[styles.title, { color: colorVars.primaryColor}]}>{Config.lastName}</Text>
            <View style={{ flexDirection: 'row' }}>
                {getLocale().badges.map((badge, index) => (
                    <Text key={index} style={styles.badge}>{badge}</Text>
                ))}
            </View>
        </View>
        <View style={styles.rightContainer}>
            <View style={styles.avatarContainer}>
                <Image style={styles.avatarImage} src={Config.imageURL} />
            </View>
        </View>
    </View>
);

export default DocHeader;