import { StyleSheet, View, Keyboard  } from 'react-native';
import { useState } from 'react';
import Animated from 'react-native-reanimated';
import { Button, SizableText, Input, Form, Spinner, XStack, YStack, Label, H4 } from 'tamagui';
import { DatabaseBackup, ArrowLeft } from '@tamagui/lucide-icons'
import { CheckboxWithLabel } from '../components/checkbox';

import { NavigationProp } from '../types';
import { t } from '../locales';
import { windowHeight } from '../utils';

export default function Home({ navigation }: { navigation: NavigationProp }) {
    const [status, setStatus] = useState<'off' | 'submitting' | 'submitted'>('off');

    const handleSubmit = () => {
        Keyboard.dismiss();
        setStatus('submitting'); // Close the keyboard

        // Simulate some asynchronous action (e.g., API request)
        const timer = setTimeout(() => {
            setStatus('off');
        }, 2000);

        return () => {
            clearTimeout(timer);
        };
    };

    return (
        <View style={styles.container}>
            <Animated.Image style={styles.image} source={require('../../assets/logo/logo.png')} sharedTransitionTag='logo' />
            <Form
                alignItems="center"
                width="100%"
                gap="$2"
                onSubmit={handleSubmit}
                padding="$6"
                paddingTop="$0"
                >
                <YStack width='100%'>
                    <H4>{t('write_your_account')}</H4>
                    <Label htmlFor="recover_email">Email</Label>
                    <Input id="recover_email" placeholder={t('enter_email')} style={{ backgroundColor: 'transparent' }} />
                    <Form.Trigger asChild disabled={status !== 'off'} marginTop={20}>
                        <Button icon={status === 'submitting' ? () => <Spinner color="$color" /> : DatabaseBackup} theme='active'>{t('recover_password')}</Button>
                    </Form.Trigger>
                </YStack>
            </Form>
            <Button
            icon={ArrowLeft}
            chromeless
            style={{ position: 'absolute', bottom: -(windowHeight/10), alignItems: 'center' }}
            onPress={() => navigation.goBack()} theme='active' >{t('go_back')}</Button>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        justifyContent: 'space-evenly',
        alignItems: 'center',
    },
    image: {
        width: 300,
        resizeMode: 'contain',
        justifyContent: 'center',
        alignSelf: 'center',
    }
});