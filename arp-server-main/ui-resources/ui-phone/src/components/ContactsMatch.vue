<template>
    <div class="contacts">
        <v-divider></v-divider>
        <v-list subheader flat class="list">
            <v-list-item link @click="onSelect(contact)" v-for="(contact, idx) in contactsSorted" v-bind:key="idx">
                <v-list-item-avatar>
                    <v-avatar color="grey"><v-icon dark>mdi-account</v-icon></v-avatar>
                </v-list-item-avatar>
                <v-list-item-content>
                    <v-list-item-title>{{ contact.name }}</v-list-item-title>
                    <v-list-item-subtitle>{{ contact.number }}</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
            <v-list-item v-if="contactsSorted.length <= 0">
                <v-list-item-avatar>
                    <v-avatar color="grey"><v-icon dark>mdi-account</v-icon></v-avatar>
                </v-list-item-avatar>
                <v-list-item-content>
                    <v-list-item-title>No found contacts</v-list-item-title>
                    <v-list-item-subtitle>No contacts with that specified number</v-list-item-subtitle>
                </v-list-item-content>
            </v-list-item>
        </v-list>
        <v-divider></v-divider>
    </div>
</template>

<script>
//import Nui from '../../utils/Nui';

export default {
    name: 'ContactsMatch',
    components: {

    },
    data: () => ({

    }),
    props: {
        searchType: {
            required: true,
            type: String,
        },
        searchQuery: {
            required: true,
            type: String,
        }
    },
    methods: {
        onSelect(contact) {
            this.$emit('select', contact.number, contact.name);
        }
    },
    computed: {
        contactsSorted() {
            return this.$store.getters.getAllContacts({ type: this.searchType, query: this.searchQuery });
        }
    },
    created() {
        console.log('ggg')
    },
    mounted() {

    },
};

</script>

<style scoped lang="less">
@import '@/arp-theme.less';

.contacts {
    width: 100%;
    height: 100%;
    .list {
        height: 100%;
        overflow-y: scroll;
        &::-webkit-scrollbar {
            width: 7.5px;
        }
        &::-webkit-scrollbar-track {
            background: transparent; 
        }
        &::-webkit-scrollbar-thumb {
            background: @darker; 
        }

    }
}

</style>
