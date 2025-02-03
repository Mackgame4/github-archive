import { ImageBackground, StyleSheet, View } from 'react-native';
import Animated from 'react-native-reanimated';
import { LogIn } from '@tamagui/lucide-icons';
import { XStack, Text, SizableText, Button, YStack, Card } from 'tamagui';

import { NavigationProp } from '../types';
import { debugMode, windowWidth, windowHeight } from '../utils';

import { t } from '../locales';

export default function Home({ navigation }: { navigation: NavigationProp }) {
    return (
        <View style={styles.container}>
            <ImageBackground style={styles.bg_image} source={require('../../assets/screens/homesceen-bg.png')}>
                <Animated.Image style={styles.image} source={require('../../assets/logo/logo.png')} sharedTransitionTag='logo' />
                { debugMode && <Button size="$2"
                style={{ position: 'absolute', top: 30, right: 10 }}
                onPress={() => navigation.navigate('DebugModal')}>Debug</Button> }
                <View style={styles.card_container}>
                    <Card size="$10" width="95%" scale={1} borderBottomEndRadius={0} borderBottomStartRadius={0}>
                        <YStack padding={20} space={10} paddingBottom={0} alignContent='center' justifyContent='center' alignItems='center'>
                            <SizableText size="$9" fontWeight="bold" textAlign='center'>{t('homescreen_titlephrase')}</SizableText>
                            <SizableText size="$3" textAlign='center'>{t('homescreen_subtitlephrase')}</SizableText>
                            <Button width="100%" height={windowHeight/18} borderRadius={50} theme="active" marginVertical={8}>
                                <SizableText size="$7" fontWeight="bold">{t('get_started')}</SizableText>
                            </Button>
                        </YStack>
                        <XStack padding={8} space={10} marginBottom={10} alignContent='center' justifyContent='center' alignItems='center'>
                            <Text>{t('already_have_an_account')}</Text>
                            <Button size="$2" icon={<LogIn />} width={windowWidth/3} onPress={() => navigation.navigate('Login')}>
                                <SizableText size="$3">{t('signIn')}</SizableText>
                            </Button>
                        </XStack>
                    </Card>
                </View>
            </ImageBackground>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        flex: 1,
        flexDirection: 'column',
        width: '100%',
        height: '100%'
    },
    card_container: {
        width: '100%',
        position: 'absolute',
        bottom: 0,
        alignItems: 'center'
    },
    image: {
        flex: 1,
        width: '100%',
        resizeMode: 'contain',
        justifyContent: 'center'
    },
    bg_image: {
        flex: 1,
        resizeMode: 'cover',
        justifyContent: 'center'
    },
});