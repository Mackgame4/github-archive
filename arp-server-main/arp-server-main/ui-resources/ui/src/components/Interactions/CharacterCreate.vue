<template>
    <v-dialog v-model="show" persistent max-width="600px">
        <v-card dark>
            <v-card-title class="justify-center">
                <span class="headline">Creating New Character</span>
            </v-card-title>
            <v-card-text>
                <v-container style="height: 25vh;" v-if="loading">
                <v-row class="fill-height" align-content="center" justify="center">
                    <spinny-loader :completed="loadingActive" :successState="loadingState" style="width: 20vh; height: 20vh;" />
                </v-row>
                </v-container>
                <v-container v-else>
                    <v-row>
                        <v-col cols="12" sm="6" md="6">
                            <v-text-field
                                label="First Name"
                                v-model="newCharacter.firstname"
                                color="red accent-4"
                                :error="firstNameError"
                                :error-messages="firstNameError ? 'Invalid Firstname': ''"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="6">
                            <v-text-field
                                label="Last Name"
                                v-model="newCharacter.lastname"
                                color="red accent-4"
                                :error="lastNameError"
                                :error-messages="lastNameError ? 'Invalid Lastname': ''"
                            ></v-text-field>
                        </v-col>
                        <v-col cols="12" sm="6" md="6">
                            <v-menu
                                ref="menu"
                                v-model="menu"
                                :close-on-content-click="false"
                                transition="scale-transition"
                                offset-y
                                min-width="290px"
                            >
                            <template v-slot:activator="{ on, attrs }">
                                <v-text-field
                                    v-model="newCharacter.dob"
                                    label="Date of Birth"
                                    prepend-icon="mdi-calendar"
                                    color="red accent-4"
                                    readonly
                                    v-bind="attrs"
                                    v-on="on"
                                ></v-text-field>
                            </template>
                                <v-date-picker
                                    ref="picker"
                                    v-model="newCharacter.dob"
                                    max="2002-12-12"
                                    color="red darken-4"
                                    min="1910-01-01"
                                ></v-date-picker>
                            </v-menu>
                        </v-col>
                        <v-col cols="12" sm="6">
                            <v-select
                                :items="[ { label: 'Male', value: true }, { label: 'Female', value: false }]"
                                label="Gender"
                                v-model="newCharacter.gender"
                                item-text="label"
                                item-value="value"
                                color="red accent-4"
                                item-color="red accent-4"
                            ></v-select>
                        </v-col>
                    </v-row>
                </v-container>
            </v-card-text>
            <v-card-actions v-if="!loading" class="justify-center">
                <v-btn color="red accent-4" text @click="cancelCreate">
                    Cancel
                </v-btn>
                <v-btn color="light-blue darken-4" text @click="beginCreate">
                    Complete
                </v-btn>
            </v-card-actions>
        </v-card>
    </v-dialog>
</template>

<script>
import Nui from '../../utils/Nui';
import SpinnyLoader from '../Loader';
export default {
    name: 'InteractionCharacter',
    components: {
        SpinnyLoader,
    },
    data: () => ({
        show: false,
        newCharacter: {
            firstname: '',
            lastname: '',
            dob: '1995-01-01',
            gender: true,
        },

        firstNameError: false,
        lastNameError: false,

        menu: false,

        loading: false,
        loadingActive: false,
        loadingState: true,
    }),
    mounted() {
        this.$root.$on('characterCreateToggle', (data) => {
            if (data) {
                this.firstNameError = false;
                this.lastNameError = false;

                this.newCharacter = {
                    firstname: '',
                    lastname: '',
                    dob: '1995-01-01',
                    gender: true,
                },
                this.menu = false;
                this.loading = false;
                this.show = true;
            } else {
                this.show = false;
            }
        })

        //this.$root.$emit('characterCreateToggle', true)
        //Nui.addEmulatedResponse('createNewCharacter', { success: true })
    },
    methods: {
        async cancelCreate() {
            await Nui.send('createNewCharacter', false);
            this.show = false;
        },
        startLoading() {
            this.loadingActive = false;
            this.loading = true;
        },
        async finishLoading(state) {
            this.loadingState = state;
            this.loadingActive = true;
            await Nui.doDelay(1000);
            this.loading = false;
        },
        async beginCreate() {
            const { firstname, lastname, gender, dob } = this.newCharacter;
            const parsedDOB = Date.parse(dob);

            this.lastNameError = false;
            this.firstNameError = false;

            const validFirst = (!/[^a-zA-Z]/.test(firstname));
            const validLast = (!/[^a-zA-Z]/.test(lastname));

            if (!validLast || lastname.length < 2) {
                this.lastNameError = true;
            }

            if (!validFirst || firstname.length < 1) {
                this.firstNameError = true;
            }

            if (this.lastNameError || this.firstNameError) {
                return;
            }

            this.startLoading();

            await Nui.doDelay(600);

            const createdCharacter = await Nui.send('createNewCharacter', {
                firstname,
                lastname,
                gender,
                dob: parsedDOB / 1000, // converting it to unix time format
            });

            const success = createdCharacter && createdCharacter.success;

            this.finishLoading(success);
            await Nui.doDelay(800);

            if (success) {
                this.show = false;
            }
        }
    },
    watch: {
        'newCharacter.firstname': function (newVal) {
            if (newVal.length >= 1) {
                this.newCharacter.firstname = newVal.charAt(0).toUpperCase() + newVal.slice(1);
                if (this.firstNameError) {
                    this.firstNameError = false;
                }
            }
        },
        'newCharacter.lastname': function (newVal) {
            if (newVal.length >= 1) {
                this.newCharacter.lastname = newVal.charAt(0).toUpperCase() + newVal.slice(1);
                if (this.lastNameError) {
                    this.lastNameError = false;
                }
            }
        },
    }
}
</script>