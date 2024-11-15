<template>
    <div id="app">
        <v-app>
            <v-card v-if="development" width="300">
                <v-card-text>
                <v-card-subtitle>Debug</v-card-subtitle>
                <v-btn @click="initDialog(debugDialog)">initDialog</v-btn>
                </v-card-text>
            </v-card>
            <div class="dialogContainer">
                <v-slide-y-reverse-transition>
                <div v-if="dialog.length > 0">
                    <div class="dialog" v-for="(dialog, i) in dialog" :key="i">
                        <v-slide-y-reverse-transition>
                        <div v-if="dialog.talked">
                            <v-card>
                                <v-card-text>{{ dialog.text }}</v-card-text>
                            </v-card>
                            <div style="position: absolute; right: 12px; background-color: red; width: 94%;">
                                <span :class="isOdd(i) ? 'characternameleft' : 'characternameright'">{{ dialog.character }}</span>
                                <v-avatar :class="isOdd(i) ? 'mugshotright' : 'mugshotleft'" v-for="(character, i) in characters" :key="i" size="43">
                                    <img v-if="dialog.character == character.name" :src="character.mugshot">
                                </v-avatar>
                            </div>
                        </div>
                        </v-slide-y-reverse-transition>
                    </div>
                </div>
                </v-slide-y-reverse-transition>
            </div>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';

export default {
    name: 'App',
    components: {
    },
    data: () => ({
        // Debug
        //development: process.env.NODE_ENV === 'development',
        development: true,
        debugDialog: [
            {
                text: "Ho no! Josh is in trouble at the docks. Go help him before he gets hurt!",
                character: "Dave",
                talked: false
            },
            {
                text: "Okay im going!",
                character: "Amy",
                talked: false
            },
            {
                text: "Cool!",
                character: "Dave",
                talked: false
            },
            {
                text: "Thanks!",
                character: "Amy",
                talked: false
            }
        ],
        // App
        synthesis: window.speechSynthesis,
        voiceList: [],
        speech: new window.SpeechSynthesisUtterance(),
        characters: [
            { name: "Dave", mugshot: "https://i.imgur.com/v7lLIoN.png", voice: 1 },
            { name: "Amy", mugshot: "https://i.imgur.com/HOGGBgk.png", voice: 2 }
        ],
        dialog: [],
        isLastDialogOver: true
    }),
    mounted() {
        let voices = this.synthesis.getVoices();
        for (let i = 0; i < this.synthesis.getVoices().length; i++) {
            this.voiceList.push(voices[i].name)
        }
        this.synthesis.onvoiceschanged = () => {
            for (let i = 0; i < voices.length; i++) {
                this.voiceList.push(voices[i].name)
            }
        }
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            if (item.action == 'startDialog') {
                let dialog = [];
                for (let i = 0; i < item.dialog.length; i++) {
                    dialog.push({
                        text: item.dialog[i].text,
                        character: item.dialog[i].character,
                        talked: false
                    })
                }
                this.initDialog(dialog);
            } else if (item.action == 'pauseDialog') {
                this.pauseDialog();
            } else if (item.action == 'resumeDialog') {
                this.resumeDialog();
            } else if (item.action == 'stopDialog') {
                this.stopDialog();
            } else if (item.action == 'getVoiceList') {
                this.getVoiceList();
            }
        }, false);

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    methods: {
        isOdd(value) {
            return value % 2 === 0;
        },
        getCharacterData(character) {
            return this.characters.find(c => c.name === character);
        },
        getVoiceList() {
            fetch(`https://ui-ttsdialogs/getVoiceList`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    voiceList: this.voiceList
                })
            });
            return this.voiceList;
        },
        pauseDialog() {
            this.synthesis.pause();
        },
        resumeDialog() {
            this.synthesis.resume();
        },
        stopDialog() {
            this.synthesis.cancel();
        },
        registerCharacter(character) {
            this.characters.push(character);
        },
        async speak(text, character, index) {
            let characterData = this.getCharacterData(character);
            if (text.length > 0 && characterData.voice) {
                this.speech.text = text;
                this.speech.voice = this.synthesis.getVoices()[characterData.voice];
                this.synthesis.speak(this.speech);
                this.isLastDialogOver = false;
                this.speech.onstart = () => {
                    if (this.development) { console.log(`Speech Started [${index}]`) }
                    fetch(`https://ui-ttsdialogs/speechStarted`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: JSON.stringify({
                            dialog: index,
                            character: character,
                            text: text
                        })
                    });
                };
                await this.waitForSpeechEnd(index);
            }
        },
        async waitForSpeechEnd(index) {
            return new Promise((resolve) => {
                this.speech.onend = () => {
                    resolve();
                    if (this.development) { console.log(`Speech Ended [${index}]`); }
                    fetch(`https://ui-ttsdialogs/speechEnded`, {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json; charset=UTF-8',
                        },
                        body: JSON.stringify({
                            dialog: index
                        })
                    });
                    if (this.dialog.length-1 == index) {
                        fetch(`https://ui-ttsdialogs/dialogEnded`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json; charset=UTF-8',
                            },
                            body: JSON.stringify({
                                dialog: this.dialog
                            })
                        });
                        this.dialog.forEach(dialog => {
                            dialog.talked = false;
                        });
                        this.dialog.reverse();
                        this.dialog = [];
                        this.isLastDialogOver = true;
                        if (this.development) { console.log('Dialog ended'); }
                    }
                }
            });
        },
        async initDialog(dialog) {
            fetch(`https://ui-ttsdialogs/dialogStarted`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    dialog: dialog
                })
            });
            if (dialog.length > 0 && this.isLastDialogOver) {
                this.dialog = dialog.reverse();
                for (let i = 0; i < this.dialog.length; i++) {
                    let dialogItem = this.dialog[this.dialog.length-i-1];
                    dialogItem.talked = true;
                    await this.speak(dialogItem.text, dialogItem.character, i);
                }
            } else {
                if (this.development) { console.log('Dialog already in progress'); }
                return;
            }
        }
    }
}
</script>

<style lang="less">
@import '@/theme.less';

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

::-webkit-scrollbar {
    display: none;
}

.v-application {
    background: transparent !important;
}

//Buttons
.v-btn__content {
    pointer-events: none;
}

// MultiSelector
.v-list-item__content {
    pointer-events: none;
}

.v-select__slot {
    pointer-events: none;
}

// Check box
.v-input--selection-controls__input {
    pointer-events: none;
}

.dialogContainer {
    position: absolute;
    bottom: 40px;
    right: 12px;
    max-width: 400px;
    max-height: 700px;
    z-index: 9999;

    .dialog {
        margin-top: 40px;
        color: black;
        font-weight: 500;
    }

    .characternameleft {
        position: absolute;
        left: 50px;
        top: -1px;
    }
    
    .characternameright {
        position: absolute;
        right: 50px;
        top: -1px;
    }

    .mugshotleft {
        position: absolute;
        left: 0px;
        top: -12px;
    }
    
    .mugshotright {
        position: absolute;
        right: 0px;
        top: -12px;
    }
}
</style>