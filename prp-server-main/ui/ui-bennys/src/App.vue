<template>
    <div id="app">
        <v-app>
            <v-scroll-x-transition>
                <v-card v-if="showUI" style="position: absolute; top: 7px; left: 7px; max-height: 89vh;" elevation="5" width="374" max-width="374">
                    <v-badge v-if="cartItems.length >= 1" style="position: absolute; top: 15px; right: 15px;" :content="cartItems.length" color="red darken-4" overlap><v-btn icon @click="openCart()"><v-icon>mdi-cart</v-icon></v-btn></v-badge>
                    <v-card-title>{{ title }}<v-chip v-if="selectedItem && items[selectedItem].sale" class="mx-1" color="red darken-4" label x-small><v-avatar left><v-icon>mdi-sale</v-icon></v-avatar>Sales</v-chip></v-card-title>
                    <v-card-subtitle style="margin-bottom: -10px;">{{ subtitle }}</v-card-subtitle>
                    <v-card-text style="max-height: 59vh; overflow-y: auto;">
                        <v-scroll-x-reverse-transition>
                        <v-container v-if="selectedItem == null" fluid>
                            <v-row dense>
                                <div style="width: 100%;" class="my-2" v-for="(item, i) in items" :key="i">
                                    <v-hover v-slot="{ hover }">
                                        <v-card class="itemCard" :class="{ 'on-hover': hover }" elevation="5" light @click="selectItem(i)">
                                            <v-card-title><v-icon class="mx-1">{{ item.icon }}</v-icon>{{ item.label }}<v-chip v-if="item.sale" class="mx-1" color="red darken-4" label x-small><v-avatar left><v-icon>mdi-sale</v-icon></v-avatar>Sales</v-chip></v-card-title>
                                            <v-card-subtitle style="margin-bottom: -10px;">{{ item.description }}</v-card-subtitle>
                                        </v-card>
                                    </v-hover>
                                </div>
                            </v-row>
                        </v-container>
                        </v-scroll-x-reverse-transition>
                        <v-scroll-x-transition>
                        <v-container v-if="animatedSelectedItem != null" fluid>
                            <v-row v-if="items[selectedItem].max" dense>
                                <div style="width: 100%;" class="my-2">
                                    <v-hover v-slot="{ hover }">
                                        <v-card class="itemCard" :class="{ 'on-hover': hover }" elevation="5" light @click="addToCart(0)">
                                            <v-fade-transition>
                                            <v-chip v-if="lastClicked == 0" style="position: absolute;" class="mx-1 my-1" color="success darken-4" label x-small><v-avatar left><v-icon>mdi-check</v-icon></v-avatar>Installed</v-chip>
                                            </v-fade-transition>
                                            <v-card-title><v-icon class="mx-1">{{ items[selectedItem].icon }}</v-icon>{{ items[selectedItem].label }} 0</v-card-title>
                                        </v-card>
                                    </v-hover>
                                </div>
                                <div style="width: 100%;" class="my-2" v-for="k in items[selectedItem].max-1" :key="k">
                                    <v-hover v-slot="{ hover }">
                                        <v-card class="itemCard" :class="{ 'on-hover': hover }" elevation="5" light @click="addToCart(k)">
                                            <v-fade-transition>
                                            <v-chip v-if="lastClicked == k" style="position: absolute;" class="mx-1 my-1" color="success darken-4" label x-small><v-avatar left><v-icon>mdi-check</v-icon></v-avatar>Installed</v-chip>
                                            </v-fade-transition>
                                            <v-card-title><v-icon class="mx-1">{{ items[selectedItem].icon }}</v-icon>{{ items[selectedItem].label }} {{ k }}</v-card-title>
                                        </v-card>
                                    </v-hover>
                                </div>
                                <div style="width: 100%;" v-for="k in items[selectedItem].max" :key="k">
                                    <div v-if="items[selectedItem].max == k" class="my-2">
                                        <v-hover v-slot="{ hover }">
                                            <v-card class="itemCard" :class="{ 'on-hover': hover }" elevation="5" @click="addToCart(items[selectedItem].max)">
                                                <v-fade-transition>
                                                <v-chip v-if="lastClicked == k" style="position: absolute;" class="mx-1 my-1" color="success darken-4" label x-small><v-avatar left><v-icon>mdi-check</v-icon></v-avatar>Installed</v-chip>
                                                </v-fade-transition>
                                                <v-card-title><v-icon class="mx-1">{{ items[selectedItem].icon }}</v-icon>Default {{ items[selectedItem].label }}</v-card-title>
                                            </v-card>
                                        </v-hover>
                                    </div>
                                </div>
                            </v-row>
                            <v-row v-if="!items[selectedItem].max" dense>
                                <div style="width: 100%;">
                                    <v-card elevation="5" color="error darken-4">
                                        <v-card-title><v-icon class="mx-1">mdi-alert</v-icon>Couldn't find any mod here.</v-card-title>
                                    </v-card>
                                </div>
                            </v-row>
                        </v-container>
                        </v-scroll-x-transition>
                    </v-card-text>
                    <v-divider class="mx-3"></v-divider>
                    <v-card-actions>
                        <v-scroll-x-transition>
                        <v-btn v-if="animatedSelectedItem != null" style="margin-bottom: -31px;" elevation="5" color="error darken-4" large block @click="back()"><v-icon>mdi-keyboard-backspace</v-icon>‏‏‎Back</v-btn>
                        </v-scroll-x-transition>
                    </v-card-actions>
                    <v-card-actions>
                        <v-scroll-x-reverse-transition>
                        <v-btn v-if="selectedItem == null" style="margin-top: -17px;" elevation="5" color="info darken-4" large block @click="toggleDoors()"><v-icon>mdi-car-door</v-icon>‏‏‎ Toggle Doors</v-btn>
                        </v-scroll-x-reverse-transition>
                    </v-card-actions>
                    <v-card-actions>
                        <v-scroll-x-reverse-transition>
                        <v-btn v-if="selectedItem == null" style="margin-top: -8px;" elevation="5" color="error darken-4" large block @click="close()"><v-icon>mdi-close</v-icon>‏‏‎Close</v-btn>
                        </v-scroll-x-reverse-transition>
                    </v-card-actions>
                </v-card>
            </v-scroll-x-transition>
            <v-scroll-x-reverse-transition>
                <v-card v-if="showUI && cartOpened" elevation="5" style="position: absolute; top: 7px; left: 384px; max-height: 89vh;">
                    <v-card-title><v-icon class="mx-1">mdi-cart</v-icon>Your Cart</v-card-title>
                    <v-card-text style="max-height: 59vh; overflow-y: auto;">
                        <div style="width: 100%;" v-for="(cartItem, i) in cartItems" :key="i">
                            <v-hover v-slot="{ hover }">
                                <v-card class="itemCard my-2" :class="{ 'on-hover': hover }" elevation="5" light @click="removeCartItem()">
                                    <v-card-title><v-icon class="mx-1">{{ cartItem.icon }}</v-icon>{{ cartItem.label }} {{ cartItem.installed}}</v-card-title>
                                    <v-divider class="mx-3"></v-divider>
                                    <v-card-actions>
                                        <v-chip class="mx-1" color="success darken-4" label><v-avatar v-if="items[cartItem.index].sale" left><v-icon>mdi-sale</v-icon></v-avatar>$ {{ cartItem.value }}</v-chip>
                                        <v-btn icon color="error darken-4" @click="removeCartItem()"><v-icon>mdi-close</v-icon></v-btn>
                                    </v-card-actions>
                                </v-card>
                            </v-hover>
                        </div>
                    </v-card-text>
                    <v-divider class="mx-3"></v-divider>
                    <v-card-actions>
                        <v-btn v-if="cartItems.length >= 0" elevation="5" color="success darken-4" large block @click="confirm()"><v-icon>mdi-currency-usd</v-icon>‏‏‎Pay</v-btn>
                    </v-card-actions>
                </v-card>
            </v-scroll-x-reverse-transition>
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
        development: process.env.NODE_ENV === 'development',
        title: "Benny's Customs",
        subtitle: "Customize your vehicle body and performance.",
        //showUI: false,
        showUI: process.env.NODE_ENV === 'development',
        selectedItem: null,
        animatedSelectedItem: null,
        lastClicked: -1,
        cartItems: [],
        cartOpened: false,
        items: [
            { index: 0, label: "Spoiler", description: "Pimp your ride by changing your vehicle body kit.", icon: "mdi-car-sports", multiplier: 0.2, sale: true, max: 7 },
            { label: 'Convertion', description: 'Realize an engine swap or convert your car into something else.', icon: 'mdi-reload', sale: false },
            { label: 'Engine', description: 'Change your vehicle performance by upgrading his engine.', icon: 'mdi-engine', sale: true, max: 4 },
            { label: 'Brakes', description: 'Change your vehicle brake performance by upgrading his brakes.', icon: 'mdi-car-brake-worn-linings', sale: false },
            { label: 'Body', description: 'Pimp your ride by changing your vehicle body kit.', icon: 'mdi-car-side', sale: false },
            { label: 'Turbo', description: 'Put a big boy air intake by slamming turbo on your engine.', icon: 'mdi-car-turbocharger', sale: false },
            { label: 'Wheels', description: 'Change your vehicle wheels.', icon: 'mdi-tire', sale: true }
        ],
    }),
    mounted() {
        this.listener = window.addEventListener('message', e => {
            const item = e.data || e.detail;
            const { event, data } = item;
            if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
            }

            if (item.action == "show") {
                this.showUI = true;
                this.items = item.menuMods;
            } else if (item.action == "hide") {
                this.showUI = false;
            }
        }, false);

        if (Nui.inDev()) {
            this.development = true;
        }

        console.log(`UI Loaded [${Nui.inDev() ? 'Development Mode' : 'Built'}]`);
    },
    methods: {
        selectItem: function(i) {
            this.selectedItem = i;
            setTimeout(() => {
                this.animatedSelectedItem = i;
                this.title = this.items[i].label;
                this.subtitle = this.items[i].description;
            }, 270);
        },
        addToCart: function(k) {
            this.lastClicked = k;
            //console.log(`Added ${this.items[this.selectedItem].label} ${k} to cart`);
            // Check if same item index is already in cart, if so, remove it and push
            if (this.cartItems.findIndex(x => x.index == this.selectedItem) > -1) {
                this.cartItems.splice(this.cartItems.findIndex(x => x.index == this.selectedItem), 1);
            }
            this.cartItems.push({ name: this.items[this.selectedItem].name, label: this.items[this.selectedItem].label, icon: this.items[this.selectedItem].icon, index: this.items[this.selectedItem].index, value: this.items[this.selectedItem].value, isToggle: this.items[this.selectedItem].isToggle, installed: this.lastClicked });
            fetch(`https://ui-bennys/applyMod`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    item: { name: this.items[this.selectedItem].name, label: this.items[this.selectedItem].label, index: this.items[this.selectedItem].index, isToggle: this.items[this.selectedItem].isToggle, installed: this.lastClicked }
                })
            });
        },
        openCart: function() {
            this.cartOpened = !this.cartOpened;
        },
        removeCartItem: function() {
            this.cartItems.splice(this.cartItems.findIndex(x => x.index == this.selectedItem), 1);
            this.lastClicked = -1;
            /*fetch(`https://ui-bennys/removeMod`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    item: { name: this.items[this.selectedItem].name, label: this.items[this.selectedItem].label, index: this.items[this.selectedItem].index, isToggle: this.items[this.selectedItem].isToggle, installed: this.lastClicked }
                })
            });*/
            // Or simply only install mods on confirm
        },
        toggleDoors: function() {
            fetch(`https://ui-bennys/toggleDoors`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify()
            });
        },
        back: function() {
            setTimeout(() => {
                this.selectedItem = null;
                this.title = "Benny's Customs";
                this.subtitle = "Customize your vehicle body and performance.";
            }, 200);
            this.animatedSelectedItem = null;
            this.lastClicked = -1;
        },
        close: function() {
            this.showUI = false;
            fetch(`https://ui-bennys/close`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify()
            });
            //Nui.send('hideUI');
            this.selectedItem = null;
            this.animatedSelectedItem = null;
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

.itemCard {
    transition: opacity .1s ease-in-out;
}

.itemCard:not(.on-hover) {
    opacity: 0.8;
}
</style>