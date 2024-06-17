import Vue from 'vue'
import Vuex from 'vuex'

import Nui from './utils/Nui';

Vue.use(Vuex)

export default new Vuex.Store({
    strict: Nui.inDev(),
    state: {
        character: {
            FirstName: 'Clean',
            LastName: 'Boy',
            CID: '190458',
            JobName: 'Job Name',
            DOB: '01/01/1990',
            addonData: [] // Used to store data thats not from the core (ex: home, garage, vehicles, banking, etc)
        },
        phoneData: {
            mobileNumber: '650-555-1234',
            wallpaper: 'https://wallpapercave.com/wp/wp6278764.jpg',
            case: 'https://i.imgur.com/qrjUi3W.png',
            mainColor: "white",
            contacts: [
                {
                    name: "Mack",
                    number: "5466456546"
                },
                {
                    name: "Disc",
                    number: "5466456546"
                },
                {
                    name: "Your Mom",
                    number: "5466456546"
                }
            ]
        },
        accountsData: [ // Server InGame Account Data (used for social media, UI identification/profile, etc)
            {
                username: 'Mack',
                avatar: 'https://cdn.vuetifyjs.com/images/john.jpg'
            },
            {
                username: 'Disc',
                avatar: 'https://static-cdn.jtvnw.net/jtv_user_pictures/8fb0894b-9ecc-4e77-9fdc-ccf044b18967-profile_image-300x300.png'
            },
            {
                username: 'Your Mom',
                avatar: 'https://www.meme-arsenal.com/memes/c1627bba05935781cab8d1dad4c87ace.jpg'
            }
        ],
    },
    mutations: {
        hex: function(state, val) {
            state.phoneData.mainColor = val;
        },
        bgHex: function(state, val) {
            state.phoneData.wallpaper = `https://singlecolorimage.com/get/${val}/527x937`;
        },
        customBg: function(state, val) {
            state.phoneData.wallpaper = val;
        },
        reset(state) {
            state.phoneData.mainColor = "white";
        },
        changeBg(state, val) {
            state.phoneData.wallpaper = val;
        },
        changeCase(state, val) {
            state.phoneData.case = val;
        }
    },
    getters: {
    }
})