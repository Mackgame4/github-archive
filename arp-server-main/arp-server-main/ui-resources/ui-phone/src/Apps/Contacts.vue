<template>
    <div class="app">
        <div class="header simpleAppHeader">
            <v-subheader>Contacts</v-subheader>
            <v-spacer></v-spacer>
            <div class="headerButton">
                <v-btn class="innerButton" icon small @click="addContact()">
                    <v-icon size="18">mdi-plus</v-icon>
                </v-btn>
            </div>
        </div>
        <div class="contactSearch">
            <v-text-field append-icon="mdi-account-search-outline" v-model="searchQuery" label="Search" color="red darken-4" hint="Search by name or number"></v-text-field>
        </div>
        <div class="contactList">
            <v-list subheader flat class="list">
                <v-list-item link @click="addContact()">
                    <v-list-item-avatar>
                        <v-avatar color="red darken-4"><v-icon dark>mdi-plus</v-icon></v-avatar>
                    </v-list-item-avatar>
                    <v-list-item-content>
                        <v-list-item-title>Add New Contact</v-list-item-title>
                    </v-list-item-content>
                </v-list-item>

                <v-list-item v-if="contactsSorted.length <= 0">
                    <v-list-item-avatar>
                        <v-avatar color="grey"><v-icon dark>mdi-account</v-icon></v-avatar>
                    </v-list-item-avatar>
                    <v-list-item-content>
                        <v-list-item-title>No found contacts</v-list-item-title>
                        <v-list-item-subtitle>No contacts for that search</v-list-item-subtitle>
                    </v-list-item-content>
                </v-list-item>

                <v-list-item v-for="(contact, idx) in contactsSorted" v-bind:key="idx">
                    <v-list-item-avatar>
                        <v-avatar color="grey"><v-icon dark>mdi-account</v-icon></v-avatar>
                    </v-list-item-avatar>
                    <v-list-item-content>
                        <v-list-item-title>{{ contact.name }}</v-list-item-title>
                        <v-list-item-subtitle>{{ contact.number }}</v-list-item-subtitle>
                    </v-list-item-content>

                    <v-list-item-action>
                        <v-btn icon>
                            <v-icon color="green">mdi-phone</v-icon>
                        </v-btn>
                    </v-list-item-action>
                    <v-list-item-action>
                        <v-btn icon>
                            <v-icon color="blue lighten-2">mdi-message</v-icon>
                        </v-btn>
                    </v-list-item-action>
                    <v-list-item-action>
                        <v-btn icon @click="editContact(contact)">
                            <v-icon color="grey lighten-2">mdi-square-edit-outline</v-icon>
                        </v-btn>
                    </v-list-item-action>
                </v-list-item>
            </v-list>
        </div>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';

//import { ContactsMatch } from '../utilComponents';

export default {
    name: 'Contacts',
    components: {
        //ContactsMatch
    },
    data: () => ({
        searchQuery: '',

    }),
    props: {
        initData: {
            required: true,
        }
    },
    methods: {
        goBack() {
            if (this.initData && this.initData.fromPhone) {
                this.$root.$emit('openApp', { app: 'phone' });
            }
        },
        addContact() {
            this.$root.$emit('dialogs:show', 'ContactEdit', {
                type: true,
            });
        },
        editContact({ name, number }) {
            this.$root.$emit('dialogs:show', 'ContactEdit', {
                type: false,
                name,
                number
            });
        }
    },
    computed: {
        contactsSorted() {
            return this.$store.getters.getAllContacts({ type: 'both', query: this.searchQuery });
        }
    },
    created() {
        
    },
    mounted() {
        this.$root.$on('goBack', this.goBack);
    },
    beforeDestroy() {
        this.$root.$off('goBack', this.goBack);
    }
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';
//@import url('https://fonts.googleapis.com/css2?family=Montserrat:wght@300&display=swap');

.app {
    width: 100%;
    height: 100%;
    display: flex;
    flex-direction: column;
    .header {
        height: 6%;
    }

    .contactList {
        height: 84%;
    }

    .contactSearch {
        height: 10%;
        padding: 0 5%;
    }
}

</style>
