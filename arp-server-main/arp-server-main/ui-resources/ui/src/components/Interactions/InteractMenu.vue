<template>
    <div class="container">
        <v-menu
            v-model="showPrimary"
            rounded
            fixed
            transition="scale-transition"
            :close-on-content-click="false"
            v-bind:position-x="getX"
            v-bind:position-y="getY"
            v-bind:min-width="getWidth"
            v-bind:max-width="getWidth"
            v-bind:max-height="getMaxHeight"
        >
            <v-list>
                <v-list-item-group>
                    <v-list-item disabled :ripple="false" color="red darken-4">
                        <v-list-item-icon><v-icon v-text="title.icon"></v-icon></v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title v-text="title.title"></v-list-item-title>
                            <v-list-item-action-text v-if="title.text" v-html="title.text"></v-list-item-action-text>
                        </v-list-item-content>
                    </v-list-item>
                </v-list-item-group>

                <v-list-item-group>
                    <!-- eslint-disable vue/no-use-v-if-with-v-for !-->
                    <v-list-item v-for="(item, id) in primaryItems" v-if="item" inactive v-bind:key="id" @click="primaryClick(id, $event)" v-bind:disabled="primaryIsDisabled(id)">
                        <v-list-item-icon v-if="item.icon">
                            <v-icon v-text="item.icon"></v-icon>
                        </v-list-item-icon>
                        <v-list-item-content>
                            <v-list-item-title v-text="item.title"></v-list-item-title>
                            <v-list-item-action-text v-if="item.text" v-html="item.text"></v-list-item-action-text>
                        </v-list-item-content>
                    </v-list-item>
                    <!-- eslint-enable vue/no-use-v-if-with-v-for !-->
                </v-list-item-group>
            </v-list>
        </v-menu>

        <v-menu
            v-model="showSecondary"
            rounded
            fixed
            transition="scale-transition"
            :close-on-content-click="false"
            :close-on-click="false"
            v-bind:position-x="getSubX"
            v-bind:position-y="secondaryY"
            v-bind:min-width="getWidth"
            v-bind:max-width="getWidth"
            v-bind:max-height="getMaxHeight"
        >
        <v-list>
            <v-list-item-group>
                <v-list-item v-for="(item, id) in secondaryItems" v-bind:key="id" inactive @click="secondaryClick(id, $event)" v-bind:disabled="secondaryIsDisabled(id)">
                    <v-list-item-icon v-if="item.icon">
                        <v-icon v-text="item.icon"></v-icon>
                    </v-list-item-icon>
                    <v-list-item-content>
                        <v-list-item-title v-text="item.title"></v-list-item-title>
                        <v-list-item-action-text v-if="item.text" v-html="item.text"></v-list-item-action-text>
                    </v-list-item-content>
                </v-list-item>
            </v-list-item-group>
        </v-list>
        </v-menu>
    </div>
</template>

<script>

import Nui from '../../utils/Nui';


export default {
    name: 'InteractMenu',
    components: {
        
    },
    props: {

    },
    data() {
        return {
            open: false,
            showPrimary: false,
            title: {},
            primaryItems: [],
            showSecondary: false,
            secondaryMenu: 0,
            secondaryItems: [],
            secondaryY: 100,
        };
    },
    computed: {
        getX() {
            return (window.innerWidth / 10) * 6;
        },
        getY() {
            return window.innerHeight / 10;
        },
        getWidth() {
            return window.innerWidth / 6;
        },
        getMaxHeight() {
            return (window.innerHeight / 10) * 8; 
        },
        getSubX() {
            return (window.innerWidth / 10) * 6 + this.getWidth;
        },
    },
    methods: {
        async primaryClick(identifier, e) {
            if (this.primaryIsDisabled(identifier)) return;
            if (this.showSecondary) {
                if (identifier === this.secondaryMenu) { // Close the secondary Menu
                    this.showSecondary = false;
                }
            } else {
                const buttonItem = this.primaryItems[identifier];
                if (buttonItem.secondary) {
                    this.secondaryMenu = identifier;
                    this.secondaryY = e.y - e.target.clientHeight;
                    this.secondaryItems = buttonItem.secondary;
                    this.showSecondary = true;
                } else {
                    const success = await Nui.send('interactionClick', {
                        id: buttonItem.id,
                        secondary: false
                    })
                    if (success) {
                        await Nui.doDelay(400);
                        this.clearSecondary();
                        await Nui.doDelay(100);
                        this.showPrimary = false;
                        this.open = false;
                    }
                }
            }
        },
        async secondaryClick(identifier) {
            if (this.secondaryIsDisabled(identifier)) return;
            const pId = this.primaryItems[this.secondaryMenu].id;
            const sId = this.secondaryItems[identifier].id;
            const success = await Nui.send('interactionClick', {
                id: pId,
                secondary: sId
            })
            if (success) {
                await Nui.doDelay(400);
                this.clearSecondary();
                await Nui.doDelay(100);
                this.showPrimary = false;
                this.open = false;
            }
        },
        primaryIsDisabled(identifier) {
            if (this.showSecondary && this.secondaryMenu !== identifier) {
                return true;
            } else if (this.primaryItems[identifier] && this.primaryItems[identifier].disabled) {
                return true;
            }
            return false;
        },
        secondaryIsDisabled(identifier) {
            if (this.secondaryItems[identifier] && this.secondaryItems[identifier].disabled) {
                return true;
            }
            return false;
        },
        clearSecondary() {
            this.showSecondary = false;
            this.secondaryMenu = 0;
        },
    },
    mounted() {
        
        this.$root.$on('interactionMenuCreate', (data) => {
            this.open = true;
            this.primaryItems = data.menuItems;
            this.title = data.menuTitle;
            this.showPrimary = true;
        });

        // setTimeout(() => {
        //     this.$root.$emit('interactionMenuCreate', {
        //         menuTitle: {
        //             icon: 'mdi-bio',
        //             title: 'Garage T',
        //             text: 'Viewing your vehicles.'
        //         }, 
        //         menuItems: [
        //             { id: '1', title: 'text', text: 'some <b>more</b> text', icon: 'mdi-aws'},
        //             { id: '2', title: 'text', text: 'some more text', icon: 'mdi-aws', secondary: [
        //                 { id: '2', title: 'text', text: 'some <b>more</b> text', icon: 'mdi-aws'}
        //             ]},
        //             { id: '3', title: 'text', text: 'some more text', icon: 'mdi-aws'},
        //         ]
        //     }
        //     )
        // }, 1000);
    },
    watch: {
        'showPrimary': function (newVal) {
            if (!newVal && this.open) { // must have closed, probably clicked off it
                Nui.send('interactionClick', {
                    id: false,
                    secondary: false
                });
                this.clearSecondary();
                this.open = false;
            }
        }
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.container {
    pointer-events: none;
}

</style>
