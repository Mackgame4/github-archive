import { Button, View } from 'react-native';
import { changeLanguage, getLocaleAsync } from './locales';
import { NavigationProp } from './types';
import { getTheme, changeTheme } from './themes';
import { SafeAreaView } from 'react-native-safe-area-context';

function changeLocale() {
    // TODO: replace this with a better way to change locale (select from a list, for example)
    getLocaleAsync().then((locale) => {
        if (locale == 'en') {
            changeLanguage('pt');
        } else {
            changeLanguage('en');
        }
    });
}

function toggleTheme() {
    getTheme().then((theme) => {
        if (theme == 'dark_red') {
            changeTheme('dark_blue');
        } else {
            changeTheme('dark_red');
        }
    });
};

export default function Debug({ navigation }: { navigation: NavigationProp }) {
    return (
        <SafeAreaView>
            <Button title="Change Locale" onPress={changeLocale} />
            <Button title="Change Theme" onPress={toggleTheme} />
            <Button title="Go back" onPress={() => navigation.goBack()} />
        </SafeAreaView>
    );
}