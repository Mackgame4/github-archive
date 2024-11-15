import Vue from 'vue'
import Vuex from 'vuex'

Vue.use(Vuex)

export default new Vuex.Store({
    state: {
        homePage: true,
        background: 'https://i.pinimg.com/originals/4c/70/29/4c7029568cdcd9befcf90f9401afc0ba.jpg'
    },
    mutations: {
        setHomePage(state, payload) {
            state.homePage = payload
        },
        changeBackground(state, payload) {
            if (payload && payload.match(/\.(jpg|gif|png)$/) != null) {
                state.background = payload
            }
        }
    },
    getters: {
    }
})