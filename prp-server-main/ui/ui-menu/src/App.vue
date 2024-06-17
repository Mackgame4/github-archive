<template>
    <div id="app">
        <Keypress v-if="keyboardControl" key-event="keyup" :key-code="38" @success="ArrowUp" />
        <Keypress v-if="keyboardControl" key-event="keyup" :key-code="40" @success="ArrowDown" />
        <Keypress v-if="keyboardControl" key-event="keyup" :key-code="37" @success="ArrowLeft" />
        <Keypress v-if="keyboardControl" key-event="keyup" :key-code="39" @success="ArrowRight" />
        <Keypress v-if="keyboardControl" key-event="keyup" :key-code="13" @success="Enter" />
        <Keypress v-if="keyboardControl" key-event="keyup" :key-code="8" @success="Back" />
        <v-app>
            <v-scroll-x-reverse-transition>
                <div class="menu" v-if="showMenu">
                    <v-card class="menuCard" width="325" elevation="5">
                        <v-card-title style="display: table; margin: 0 auto;">{{ menuTitle }}</v-card-title>
                        <v-card-subtitle>{{ menuSubtitle }}</v-card-subtitle>
                        <v-list class="list" nav dense>
                            <v-list-item-group v-on:click.ctrl="onClick" v-model="selectedItem" color="white">
                                <v-list-item v-for="(item, i) in items" :key="i" :ripple="item.type == 'slider' ? false : true" @click="menuAction(item.action, item.type, item.value)">
                                    <!--v-list-item-icon v-if="item.icon != '' && item.icon != 'none'">
                                        <v-icon v-text="item.icon"></v-icon>
                                    </v-list-item-icon-->
                                    <v-col>
                                        <v-list-item-content>
                                            <v-list-item-title v-text="item.text" v-bind:style="[item.type == 'switch' ? { 'margin-left': 50 + 'px'} : { 'margin-left': 0 + 'px'}]"></v-list-item-title>
                                        </v-list-item-content>
                                        <v-slider v-if="item.type == 'slider'" v-model="item.value" class="align-center" :max="item.sliderMax" :min="item.sliderMin" hide-details color="red darken-4">
                                            <template v-slot:append>
                                            <v-text-field v-model="item.value" class="mt-0 pt-0" hide-details single-line type="number" style="width: 60px" color="red darken-4"></v-text-field>
                                            </template>
                                        </v-slider>
                                    </v-col>
                                    <v-switch v-if="item.type == 'switch'" v-model="item.value" inset dense color="red darken-4"></v-switch>
                                </v-list-item>
                            </v-list-item-group>
                        </v-list>
                        <v-card-actions style="max-width: 167px;">
                            <v-btn v-for="(button, i) in actionButtons" :key="i" :color="button.color" elevation="5" x-large block @click="menuAction(button.action, button.type, button.value)"><v-icon>mdi-{{button.icon}}</v-icon>‏‏‎ ‎{{button.text}}</v-btn>
                        </v-card-actions>
                    </v-card>
                </div>
            </v-scroll-x-reverse-transition>
            <v-scale-transition>
                <div class="menuDialog" v-if="showMenuDialog">
                    <v-card class="menuCard" width="525" elevation="5">
                        <v-card-title style="display: table; margin: 0 auto;">Dialog Title</v-card-title>
                        <v-card-subtitle>Dialog Subtitle</v-card-subtitle>
                        <div class="dialogContent">
                            <v-text-field label="Amount" outlined dense color="white"></v-text-field>
                        </div>
                        <v-card-actions style="max-width: 267px;">
                            <v-btn v-for="(button, i) in actionButtons" :key="i" :color="button.color" elevation="5" large block><v-icon>mdi-{{button.icon}}</v-icon>‏‏‎ ‎{{button.text}}</v-btn>
                        </v-card-actions>
                    </v-card>
                </div>
            </v-scale-transition>
            <v-scale-transition>
                <div class="menuListDialog" v-if="showMenuList">
                    <v-card class="menuCard" width="525" elevation="5">
                        <v-card-title style="display: table; margin: 0 auto;">Dialog List Title</v-card-title>
                        <v-card-subtitle>Dialog List Subtitle</v-card-subtitle>
                        <div class="dialogListContent">
                            <v-data-table v-model="selected" :headers="headers" :items="dataTable" :page.sync="page" :items-per-page="8" :single-select="false" item-key="name" show-select hide-default-footer @page-count="pageCount = $event"></v-data-table>
                            <v-pagination style="margin-top: 8px;" v-model="page" :length="pageCount" color="black"></v-pagination>
                        </div>
                        <v-card-actions>
                            <v-btn color="error darken-4" elevation="5" large block><v-icon>mdi-cancel</v-icon>‏‏‎ ‎Close</v-btn>
                        </v-card-actions>
                    </v-card>
                </div>
            </v-scale-transition>
        </v-app>
    </div>
</template>

<script>
import Keypress from 'vue-keypress';

export default {
    name: 'App',
    components: {
        Keypress,
    },
    data: () => ({
        selectedItem: -1,
        keyboardControl: false,
        showMenu: false,
        showMenuDialog: false,
        showMenuList: false,
        menuTitle: 'Menu Title',
        menuSubtitle: 'Menu Subtitle',
        page: 1,
        pageCount: 0,
        selected: [],
        headers: [
            {
                text: 'Vehicle Name',
                align: 'start',
                sortable: false,
                value: 'name',
            },
            { text: 'VIN', value: 'vin' },
            { text: 'Speed', value: 'speed' },
            { text: 'Value', value: 'value' }
        ],
        dataTable: [
            {
                name: 'T20',
                vin: 1595684,
                speed: 226.0,
                value: 10000000
            },
            {
                name: 'Elegy',
                vin: 1595684,
                speed: 226.0,
                value: 10000000
            },
            {
                name: 'Sultan RS',
                vin: 1595684,
                speed: 226.0,
                value: 10000000
            },
            {
                name: 'GTR',
                vin: 1595684,
                speed: 226.0,
                value: 10000000
            }
        ],
        actionButtons: [
            {
                color: "error darken-4",
                icon: "cancel",
                text: "Cancel",
                action: "close"
            },
            {
                color: "success darken-4",
                icon: "check",
                text: "Confirm",
                action: "confirm"
            }
        ],
        items: [
            { text: 'Menu Item', icon: 'mdi-folder', type: 'default', action: "printData"},
            { text: 'Slider Menu Item', icon: 'none', type: 'slider', value: 0, sliderMin: 0, sliderMax: 100, action: "printData" },
            { text: 'Switch Menu Item', icon: 'none', type: 'switch', value: false, action: "printData" }
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

            if(item.action == "show"){
                if(item.type == "menu"){
                    this.showMenu = true;
                    this.actionButtons = item.buttons;
                    this.menuTitle = item.title;
                    this.menuSubtitle = item.subtitle;
                    this.items = item.data;
                } else if(item.type == "dialog"){
                    this.showMenuDialog = true;
                } else if(item.type == "list"){
                    this.showMenuList = true;
                }
            } else if (item.action == "hide") {
                if(item.type == "menu"){
                    this.selectedItem = -1;
                    this.showMenu = false;
                } else if(item.type == "dialog"){
                    this.showMenuDialog = false;
                } else if(item.type == "list"){
                    this.showMenuList = false;
                }
            }
        }, false);
    },
    /*created () {
        this.items.forEach((val) => {
            this.$watch(() => val, this.handleChange, {deep: true});
        });
    },*/
    methods: {
        ArrowUp() {
            this.scrollToElement()
            if (this.selectedItem > -1) {
                this.selectedItem = this.selectedItem-1;
            }
        },
        ArrowDown() {
            this.scrollToElement()
            if (this.selectedItem < this.items.length) {
                this.selectedItem = this.selectedItem+1;
            }
        },
        ArrowLeft() {
            this.scrollToElement()
            if (this.selectedItem > -1 && this.items[this.selectedItem].type == 'slider') {
                this.items[this.selectedItem].value = this.items[this.selectedItem].value-1;
            }
        },
        ArrowRight() {
            this.scrollToElement()
            if (this.selectedItem > -1 && this.items[this.selectedItem].type == 'slider') {
                this.items[this.selectedItem].value = this.items[this.selectedItem].value+1;
            }
        },
        Enter() {
            if (this.selectedItem > -1 && this.items[this.selectedItem].type == 'switch') {
                this.items[this.selectedItem].value = !this.items[this.selectedItem].value;
            }
        },
        Back() {
            this.selectedItem = -1;
            this.showMenu = false;
        },
        scrollToElement() {
            const el = this.$el.getElementsByClassName('v-list-item')[this.selectedItem];

            if (el) {
                el.scrollIntoView({behavior: 'smooth'});
            }
        },
        /*handleChange(newVal) {
            console.log(newVal);
        },*/
        menuAction(action, type, value) {
            fetch(`https://ui-menu/handleMenuAction`, {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                    action: action,
                    type: type,
                    value: value
                })
            }).then(resp => resp.json()).then(resp => console.log(resp));
        }
    }
}
</script>

<style lang="less">
@import '@/theme.less';
@import url('https://fonts.googleapis.com/css2?family=Poppins:wght@700&display=swap');

* {
    font-family: 'Poppins', sans-serif;
}

body, html, #app {
    width: 100vw;
    height: 100vh;
    overflow: hidden;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
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

.v-list-item--active::before { opacity: 0 !important }

.v-list-item--active::after { opacity: 0 !important }

/* width */
::-webkit-scrollbar {
    width: 7px;
}

/* Track */
::-webkit-scrollbar-track {
    background: none;
}

/* Handle */
::-webkit-scrollbar-thumb {
    background-color: rgba(0, 0, 0, 0.35);
    border-radius: 27px;
}

/* Handle on hover */
::-webkit-scrollbar-thumb:hover {
    background-color: rgba(0, 0, 0, 1.0);
}

.menu {
    position: absolute;
    top: 8%;
    right: 17px;
}

.menuDialog {
    position: absolute;
    top: 50%;
    left: 50%;
    margin: -100px 0 0 -235px;
}

.menuListDialog {
    position: absolute;
    top: 50%;
    left: 50%;
    margin: -250px 0 0 -235px;
}

.menuCard {
    background-color: rgba(30, 30, 30, 0.95) !important;
    text-align: center;
}

.list {
    background: none !important;
    max-height: 410px;
    overflow: auto;
}

.dialogContent {
    margin: 3px 8px -15px 8px;
}

.dialogListContent {
    margin: -10px 8px 0px 8px;
}
</style>
