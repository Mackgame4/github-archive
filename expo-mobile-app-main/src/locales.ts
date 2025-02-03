"use strict";
import { getLocales, getCalendars } from 'expo-localization';
import * as Updates from "expo-updates";
import { I18n } from 'i18n-js';
import AsyncStorage from '@react-native-async-storage/async-storage';

const locales = getLocales();
const calendars = getCalendars();

export const getLocale = locales[0].languageCode || 'en'; // later update to languageTag to more especific locales
export const getDecimalSeparator = locales[0].decimalSeparator || '.';
export const isRTL = locales[0].textDirection == 'ltr' ? false : true || false;
export const getCurrency = locales[0].currencySymbol || '$';
export const getFormat = calendars[0].uses24hourClock || false;
export const getTimeZone = calendars[0].timeZone || 'America/Los_Angeles';

export const localesList = [
    { label: 'English', value: 'en' },
    { label: 'Português', value: 'pt' }
];

const translations = {
    en: {
        get_started: 'Get Started',
        already_have_an_account: 'Already have an account?',
        login: 'Login',
        logout: 'Logout',
        signIn: 'Sign In',
        signUp: 'Sign Up',
        forgot_password: 'Forgot Password?',
        submit: 'Submit',
        enter_email: 'Enter your email',
        enter_password: 'Enter your password',
        remember_me: 'Remember me',
        go_back: 'Go Back',
        recover_password: 'Recover Password',
        // Custom text
        login_into_your_account: 'Login into your account',
        write_your_account: 'Write your account',
        homescreen_titlephrase: 'Increase your target, be healthier, be better!',
        homescreen_subtitlephrase: 'Time to improve yourself to have a healthy lifestyle by exercising and eating well.',
    },
    pt: {
        get_started: 'Começar',
        already_have_an_account: 'Já tem uma conta?',
        login: 'Entrar',
        logout: 'Sair',
        signIn: 'Entrar',
        signUp: 'Registrar',
        forgot_password: 'Esqueceu a senha?',
        submit: 'Entrar', // submit: 'Enviar',
        enter_email: 'Digite seu email',
        enter_password: 'Digite sua senha',
        remember_me: 'Lembre-me',
        go_back: 'Voltar',
        recover_password: 'Recuperar Senha',
        // Custom text
        login_into_your_account: 'Entre na sua conta',
        write_your_account: 'Digite sua conta',
        homescreen_titlephrase: 'Aumente sua meta, seja mais saudável, seja melhor!',
        homescreen_subtitlephrase: 'Hora de se melhorar para ter um estilo de vida saudável, fazendo exercícios e comendo bem.',
    }
};
const i18n = new I18n(translations);
i18n.enableFallback = true; // When a value is missing from a language it'll fall back to another language with the key present.

// Set the locale once at the beginning of your app.
async function getLocaleAsync() {
    const locale = await AsyncStorage.getItem('locale');
    if (locale) {
        i18n.locale = locale;
    } else {
        i18n.locale = getLocale;
    }
    return i18n.locale;
}

async function changeLanguage(language: string) {
    await AsyncStorage.setItem('locale', language);
    i18n.locale = language;
    await Updates.reloadAsync();
}

function t(key: string, options?: any) {
    return i18n.t(key, options);
}

export { changeLanguage, getLocaleAsync, t };