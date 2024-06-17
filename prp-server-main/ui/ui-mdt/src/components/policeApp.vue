<template>
    <div>
        <v-app id="appScreen">
            <div style="display: flex; float: left; height: 31.5vw;">
                <v-navigation-drawer permanent expand-on-hover>
                    <v-list>
                    <v-list-item class="px-2">
                        <v-list-item-avatar>
                        <img :src="`${publicPath}/assets/policeLogo.webp`" />
                        </v-list-item-avatar>
                        <v-list-item-content>
                        <v-list-item-title>{{ loggedUser.name }}</v-list-item-title>
                        </v-list-item-content>
                        <v-list-item-content>
                        <v-list-item-subtitle>#{{ loggedUser.badgenum }}</v-list-item-subtitle>
                        </v-list-item-content>
                    </v-list-item>
                    </v-list>
                    <v-divider class="mx-3"></v-divider>
                    <v-list nav dense>
                    <v-list-item-group v-model="selectedItem" color="info accent-4">
                    <v-list-item link>
                        <v-list-item-icon>
                        <v-icon>mdi-home</v-icon>
                        </v-list-item-icon>
                        <v-list-item-title>Home</v-list-item-title>
                    </v-list-item>
                    <v-list-item link>
                        <v-list-item-icon>
                        <v-icon>mdi-account-multiple</v-icon>
                        </v-list-item-icon>
                        <v-list-item-title>Officers</v-list-item-title>
                    </v-list-item>
                    <v-list-item link>
                        <v-list-item-icon>
                        <v-icon>mdi-shield-search</v-icon>
                        </v-list-item-icon>
                        <v-list-item-title>Criminal Record</v-list-item-title>
                    </v-list-item>
                    <v-list-item link>
                        <v-list-item-icon>
                        <v-icon>mdi-car</v-icon>
                        </v-list-item-icon>
                        <v-list-item-title>Vehicle Registration</v-list-item-title>
                    </v-list-item>
                    </v-list-item-group>
                    </v-list>
                    <v-list style="position: absolute; bottom: 0px; width: 100%;" nav dense>
                    <v-list-item-group v-model="selectedLogout" color="error accent-4">
                    <v-list-item link @click="close()">
                        <v-list-item-icon>
                        <v-icon>mdi-logout-variant</v-icon>
                        </v-list-item-icon>
                        <v-list-item-title>Logout</v-list-item-title>
                    </v-list-item>
                    </v-list-item-group>
                    </v-list>
                </v-navigation-drawer>
                <v-main>
                    <v-scale-transition leave-absolute>
                    <div v-if="!selectedItem || selectedItem == 0">
                        <div style="display: flex; max-width: fit-content; padding: 23px; max-height: 31.5vw; overflow: auto;">
                            <div style="max-width: 33%; margin-right: 17px;">
                                <v-card>
                                    <v-card-title><v-icon left>mdi-chart-box</v-icon>Department Status</v-card-title>
                                    <v-card-text>
                                        <v-expansion-panels multiple>
                                            <v-expansion-panel>
                                                <v-expansion-panel-header><span><v-icon left dense>mdi-bag-personal</v-icon>Inventory</span></v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <p>Space avaliable: 100</p>
                                                    <p>Space used: 100</p>
                                                </v-expansion-panel-content>
                                            </v-expansion-panel>
                                            <v-expansion-panel>
                                                <v-expansion-panel-header><span><v-icon left dense>mdi-pistol</v-icon>Weapon Armory</span></v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <p>Avaliable slot: 100</p>
                                                    <p>Slots used: 100</p>
                                                </v-expansion-panel-content>
                                            </v-expansion-panel>
                                            <v-expansion-panel>
                                                <v-expansion-panel-header><span><v-icon left dense>mdi-police-badge</v-icon>Officers</span></v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <p>Total officers: 100</p>
                                                    <p>In service: 100</p>
                                                </v-expansion-panel-content>
                                            </v-expansion-panel>
                                            <v-expansion-panel>
                                                <v-expansion-panel-header><span><v-icon left dense>mdi-account</v-icon>Total Records</span></v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <p>Total records: 100</p>
                                                    <p>This month: 50</p>
                                                    <p>Last month: 50</p>
                                                </v-expansion-panel-content>
                                            </v-expansion-panel>
                                            <v-expansion-panel>
                                                <v-expansion-panel-header><span><v-icon left dense>mdi-car-emergency</v-icon>Fleet</span></v-expansion-panel-header>
                                                <v-expansion-panel-content>
                                                    <p>Total vehicles: 100</p>
                                                    <p>In use: 100</p>
                                                </v-expansion-panel-content>
                                            </v-expansion-panel>
                                        </v-expansion-panels>
                                    </v-card-text>
                                </v-card>
                            </div>
                            <div>
                                <v-card style="max-width: 100%;">
                                    <v-card-title><v-icon left>mdi-phone-incoming</v-icon>Latest Calls</v-card-title>
                                    <v-card-text>
                                        <v-list nav dense>
                                        <v-list-item v-for="(call, i) in latestCalls" :key="i" three-line>
                                            <v-list-item-content>
                                                <v-list-item-title>
                                                    <v-icon dense>mdi-phone</v-icon>
                                                    <span style="margin-left: 7px;">{{ call.phone }}</span>
                                                </v-list-item-title>
                                                <v-list-item-subtitle>
                                                    <v-icon dense>mdi-map-marker</v-icon>
                                                    <span style="margin-left: 7px;">{{ call.location }}</span>
                                                </v-list-item-subtitle><br>
                                                <v-list-item-subtitle>
                                                    <v-icon dense>mdi-clock</v-icon>
                                                    <span style="margin-left: 7px;">{{ fromNow(call.date) }}</span>
                                                </v-list-item-subtitle>
                                            </v-list-item-content>
                                            <v-list-item-action>
                                                <v-btn color="success accent-4" text>
                                                    <v-icon left>mdi-phone</v-icon>
                                                    Call Back
                                                </v-btn>
                                                <v-btn color="info accent-4" text>
                                                    <v-icon left>mdi-map-marker</v-icon>
                                                    Mark Location
                                                </v-btn>
                                            </v-list-item-action>
                                        </v-list-item>
                                        </v-list>
                                    </v-card-text>
                                </v-card>
                            </div>
                        </div>
                        <v-scale-transition>
                            <v-btn v-if="animationLoaded" style="margin-left: 8px; z-index: 9999;" color="error darken-3" elevation="7" rounded large absolute bottom left><v-icon>mdi-alarm-light</v-icon>‏ Panic Button</v-btn>
                        </v-scale-transition>
                    </div>
                    </v-scale-transition>
                    <v-scale-transition leave-absolute>
                    <div v-if="selectedItem == 1">
                        <div style="padding: 23px; max-height: 31.5vw; overflow: auto;">
                        <v-autocomplete v-model="officerDataFilter" color="info accent-4" hide-details label="Search" prepend-inner-icon="mdi-magnify" append-icon="" filled dense :items="searchOfficers">
                            <template v-slot:append-outer>
                            <v-slide-x-reverse-transition mode="out-in">
                                <v-icon v-if="officerDataFilter" color="error accent-4" @click="officerDataFilter = ''">mdi-close</v-icon>
                            </v-slide-x-reverse-transition>
                            </template>
                        </v-autocomplete><br>
                        <v-data-table :headers="officerHeaders" :items="filteredOfficerData" :page.sync="page" :items-per-page="6" class="elevation-7">
                            <template v-slot:item.mugshot="{ item }">
                                <v-avatar size="37"><img :src="item.mugshot"></v-avatar>
                            </template>
                            <template v-slot:item.badgenum="{ item }">
                                <span>#{{ item.badgenum }}</span>
                            </template>
                            <template v-slot:item.actions="{ item }">
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="success accent-4" @click="sendCallRequest()"><v-icon dense>mdi-phone</v-icon></v-btn></template><span>Call</span></v-tooltip>
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="info accent-4" @click="sendPing()"><v-icon dense>mdi-pin</v-icon></v-btn></template><span>Ping</span></v-tooltip>
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="error accent-4" @click="sendUnitPing()"><v-icon dense>mdi-car-emergency</v-icon></v-btn></template><span>Ping Unit</span></v-tooltip>
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text @click="editRecord(item)"><v-icon dense>mdi-pencil</v-icon></v-btn></template><span>Edit</span></v-tooltip>
                            </template>
                        </v-data-table><br>
                        <v-scale-transition>
                        <v-card v-if="editItem">
                            <v-fade-transition>
                            <div v-if="!changingData">
                                <v-card-title class="text-h5 grey darken-4"><v-avatar style="margin-right: 17px;" size="37"><img :src="editItem.mugshot"></v-avatar>{{ editItem.name }}
                                    <v-spacer></v-spacer><v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="success accent-4" text @click="sendCallRequest()"><v-icon dense>mdi-phone</v-icon></v-btn></template><span>Call</span></v-tooltip>
                                    <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="info accent-4" text @click="sendPing()"><v-icon dense>mdi-pin</v-icon></v-btn></template><span>Ping</span></v-tooltip>
                                    <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="error accent-4" text @click="sendUnitPing()"><v-icon dense>mdi-car-emergency</v-icon></v-btn></template><span>Ping Unit</span></v-tooltip>
                                    <v-btn style="margin-left: 7px;" color="error accent-4" @click="editItem = null"><v-icon>mdi-close</v-icon></v-btn>
                                </v-card-title>
                                <v-card-text style="margin-top: 17px;">
                                    <p>Personal Data:</p>
                                    <div style="display: flex;">
                                        <v-text-field style="margin-right: 17px;" :value="editItem.name" label="Name" filled disabled></v-text-field>
                                        <v-text-field :value="'#'+editItem.badgenum" label="Badge Number" filled :disabled="!isBoss"></v-text-field>
                                    </div>
                                    <v-textarea label="Notes" :value="editItem.notes" hint="Write some notes for this officer" filled :disabled="!isBoss"></v-textarea>
                                    <v-btn color="info accent-4" block @click="changingData = true"><v-icon left>mdi-car</v-icon>Change Unit (#30)</v-btn>
                                </v-card-text>
                            </div>
                            </v-fade-transition>
                            <v-fade-transition>
                            <div v-if="changingData">
                                <v-card-title class="text-h5 grey darken-4"><v-avatar style="margin-right: 17px;" size="37"><img :src="editItem.mugshot"></v-avatar>{{ editItem.name }}
                                    <v-spacer></v-spacer><!--v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="info accent-4" text @click="changeUnit()"><v-icon dense>mdi-car</v-icon>‏ Change Unit</v-btn></template><span>Change Unit</span></v-tooltip-->
                                    <v-btn style="margin-left: 7px;" color="error accent-4" @click="changingData = false"><v-icon>mdi-arrow-left</v-icon></v-btn>
                                </v-card-title>
                                <v-card-text style="margin-top: 17px;">
                                    <v-item-group>
                                    <v-container>
                                    <v-row>
                                        <v-col v-for="vehicle in fleet" :key="vehicle.unitnum" cols="12" md="4">
                                        <v-item v-slot="{ active, toggle }">
                                            <v-card :color="active ? 'info accent-4' : ''" class="elevation-7 d-flex align-center" outlined @click="toggle">
                                                <v-card-title><v-icon v-if="vehicle.model != 'Interceptor'">mdi-car</v-icon><v-icon v-else>mdi-car-sports</v-icon>‏ {{ vehicle.name }}<v-card-text>
                                                    Officer: {{ loggedUser.name }}<br>
                                                    Model: {{ vehicle.model }}
                                                </v-card-text></v-card-title>
                                            </v-card>
                                        </v-item>
                                        </v-col>
                                    </v-row>
                                    </v-container>
                                </v-item-group>
                                    <v-btn color="info accent-4" block><v-icon left>mdi-car</v-icon>Confirm Unit</v-btn>
                                </v-card-text>
                            </div>
                            </v-fade-transition>
                        </v-card>
                        </v-scale-transition>
                        </div>
                    </div>
                    </v-scale-transition>
                    <v-scale-transition leave-absolute>
                    <div v-if="selectedItem == 2">
                        <div style="padding: 23px; max-height: 31.5vw; overflow: auto;">
                        <v-autocomplete v-model="recordDataFilter" color="info accent-4" hide-details label="Search" prepend-inner-icon="mdi-magnify" append-icon="" filled dense :items="searchRecord">
                            <template v-slot:append-outer>
                            <v-slide-x-reverse-transition mode="out-in">
                                <v-icon v-if="recordDataFilter" color="error accent-4" @click="recordDataFilter = ''">mdi-close</v-icon>
                            </v-slide-x-reverse-transition>
                            </template>
                        </v-autocomplete><br>
                        <v-data-table :headers="recordHeaders" :items="filteredRecordData" :page.sync="page" :items-per-page="6" class="elevation-7" hide-default-footer @page-count="pageCount = $event">
                            <template v-slot:item.mugshot="{ item }">
                                <v-avatar size="37"><img :src="item.mugshot"></v-avatar>
                            </template>
                            <template v-slot:item.licenses="{ item }">
                                <span v-for="(license, i) in item.licenses" :key="i"><v-chip style="margin-left: 7px;" :color="license.type != 'G' && license.points >= 100 ? 'info accent-4' : license.type != 'G' && license.points < 100 && license.points > 10 ? 'warning accent-4' : license.type != 'G' && license.points <= 10 ? 'error accent-4' : ''" small>{{ license.type }}</v-chip></span>
                            </template>
                            <template v-slot:item.records="{ item }">
                                <span><span v-if="item.records.length > 0">{{ item.records.length }}</span><span v-else>None</span></span>
                            </template>
                            <template v-slot:item.actions="{ item }">
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="success accent-4" @click="sendCallRequest()"><v-icon dense>mdi-phone</v-icon></v-btn></template><span>Call</span></v-tooltip>
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="info accent-4" @click="newRecord(item)"><v-icon dense>mdi-plus</v-icon></v-btn></template><span>New Record</span></v-tooltip>
                                <v-tooltip v-if="copsInService <= 2" bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="error accent-4" @click="jail()"><v-icon dense>mdi-handcuffs</v-icon></v-btn></template><span>Jail</span></v-tooltip>
                                <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text @click="editRecord(item)"><v-icon dense>mdi-pencil</v-icon></v-btn></template><span>Edit</span></v-tooltip>
                            </template>
                        </v-data-table><br>
                        <v-pagination v-model="page" :length="pageCount"></v-pagination><br>
                        <v-scale-transition>
                        <v-card v-if="editItem">
                            <v-fade-transition>
                            <div v-if="!changingData">
                                <v-card-title class="text-h5 grey darken-4"><v-avatar style="margin-right: 17px;" size="37"><img :src="editItem.mugshot"></v-avatar>{{ editItem.name }}
                                    <v-spacer></v-spacer><v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="success accent-4" text @click="sendCallRequest()"><v-icon dense>mdi-phone</v-icon></v-btn></template><span>Call</span></v-tooltip>
                                    <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="info accent-4" text @click="newRecord()"><v-icon dense>mdi-plus</v-icon></v-btn></template><span>New Record</span></v-tooltip>
                                    <v-tooltip v-if="copsInService <= 2" bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="error accent-4" text @click="jail()"><v-icon dense>mdi-handcuffs</v-icon></v-btn></template><span>Jail</span></v-tooltip>
                                    <v-btn style="margin-left: 7px;" color="error accent-4" @click="editItem = null"><v-icon>mdi-close</v-icon></v-btn>
                                </v-card-title>
                                <v-card-text style="margin-top: 17px;">
                                    <p>Personal Data:</p>
                                    <v-text-field style="margin-right: 17px;" :value="editItem.name" label="Name" filled disabled></v-text-field>
                                    <v-textarea label="Notes" :value="editItem.notes" hint="Write some notes for this record" filled></v-textarea>
                                    <p v-if="editItem.records">Records/Charges:</p>
                                    <div style="display: flex; max-width: fit-content;">
                                        <div v-for="(record, i) in editItem.records" :key="i" style="padding: 7px;">
                                            <v-card color="grey darken-4" elevation="7" shaped>
                                                <v-card-title>{{ record.record }}<v-chip style="margin-left: 7px;" :color="record.level == 1 ? 'info accent-4' : record.level == 2 ? 'warning accent-4' : record.level == 3 ? 'error accent-4' : ''" small>Level {{ record.level }}</v-chip></v-card-title>
                                                <v-card-text>{{ record.description }}</v-card-text>
                                                <v-card-actions>
                                                    <v-btn><v-icon left>mdi-pencil</v-icon>Edit</v-btn>
                                                    <v-btn color="error accent-4" text><v-icon left>mdi-delete</v-icon>Delete</v-btn>
                                                </v-card-actions>
                                            </v-card>
                                        </div>
                                    </div><br>
                                    <v-btn color="info accent-4" block @click="newRecord()"><v-icon left>mdi-plus</v-icon>New Record</v-btn><br>
                                    <p v-if="editItem.licenses">Licenses:</p>
                                    <div style="display: flex; max-width: fit-content;">
                                        <div v-for="(license, i) in editItem.licenses" :key="i" style="padding: 7px;">
                                            <v-card color="grey darken-4" elevation="7" shaped>
                                                <v-card-title><v-icon v-if="license.type != 'G'" left>mdi-car</v-icon><v-icon v-else left>mdi-pistol</v-icon><span v-if="license.type != 'G'">License {{ license.type }}</span><span v-else>Gun License</span><v-chip v-if="license.type != 'G'" style="margin-left: 7px;" :color="license.points >= 100 ? 'info accent-4' : license.points < 100 && license.points > 10 ? 'warning accent-4' : license.points <= 10 ? 'error accent-4' : ''" small label>{{ license.points }} points</v-chip></v-card-title>
                                                <v-card-text v-if="license.type == 'A'">This license grant you the right to use a small vehicle for the purpose of driving a motor vehicle in a non-commercial manner.</v-card-text>
                                                <v-card-text v-if="license.type == 'B'">This license grant you the right to use a larger vehicle for the purpose of driving a motor vehicle in a non-commercial manner.</v-card-text>
                                                <v-card-text v-if="license.type == 'C'">This license grant you the right to use every vehicle for the purpose of driving a motor vehicle in a commercial manner.</v-card-text>
                                                <v-card-text v-if="license.type == 'G'">This license grant you the right to use a small weapon for the purpose of self-defence and commercial matters.</v-card-text>
                                                <v-card-actions>
                                                    <v-btn v-if="license.type != 'G'" color="success accent-4"><v-icon left>mdi-restore</v-icon>Renew</v-btn>
                                                    <v-btn color="error accent-4" text><v-icon left>mdi-close</v-icon>Revoke</v-btn>
                                                </v-card-actions>
                                            </v-card>
                                        </div>
                                    </div>
                                </v-card-text>
                            </div>
                            </v-fade-transition>
                            <v-fade-transition>
                            <div v-if="changingData">
                                <v-card-title class="text-h5 grey darken-4"><v-avatar style="margin-right: 17px;" size="37"><img :src="editItem.mugshot"></v-avatar>{{ editItem.name }} - New Record
                                    <v-spacer></v-spacer><v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" color="info accent-4" text><v-icon dense>mdi-content-save</v-icon>‏ Save</v-btn></template><span>Save</span></v-tooltip>
                                    <v-btn style="margin-left: 7px;" color="error accent-4" @click="changingData = false"><v-icon>mdi-arrow-left</v-icon></v-btn>
                                </v-card-title>
                                <v-card-text style="margin-top: 17px;">
                                    <div style="display: flex;">
                                    <v-date-picker v-model="newRecordData.date" color="info accent-4" readonly></v-date-picker>
                                    <div style="width: 100%; margin-left: 17px;">
                                    <v-text-field :value="newRecordData.record" label="Record" filled></v-text-field>
                                    <v-textarea label="Description" :value="newRecordData.description" hint="Write the record description" filled></v-textarea>
                                    <v-radio-group v-model="radioGroup" style="margin-left: 20%;" row>
                                        <v-radio color="gray darken-4">
                                            <template v-slot:label>
                                                <div><strong>Level 0</strong></div>
                                            </template>
                                        </v-radio>
                                        <v-radio v-for="n in 3" :key="n" :value="n" :color="n == 1 ? 'info accent-4' : n == 2 ? 'warning accent-4' : n == 3 ? 'error accent-4' : ''">
                                            <template v-slot:label>
                                                <div><strong :class="n == 1 ? 'info--text accent-4' : n == 2 ? 'warning--text accent-4' : n == 3 ? 'error--text accent-4' : ''">Level {{ n }}</strong></div>
                                            </template>
                                        </v-radio>
                                    </v-radio-group>
                                    </div>
                                    </div>
                                </v-card-text>
                            </div>
                            </v-fade-transition>
                        </v-card>
                        </v-scale-transition>
                        </div>
                    </div>
                    </v-scale-transition>
                    <v-scale-transition leave-absolute>
                    <div v-if="selectedItem == 3">
                        <div style="padding: 23px; max-height: 31.5vw; overflow: auto;">
                            <v-autocomplete v-model="vehicleDataFilter" color="info accent-4" hide-details label="Search" prepend-inner-icon="mdi-magnify" append-icon="" filled dense :items="searchVehicle">
                            <template v-slot:append-outer>
                            <v-slide-x-reverse-transition mode="out-in">
                                <v-icon v-if="vehicleDataFilter" color="error accent-4" @click="vehicleDataFilter = ''">mdi-close</v-icon>
                            </v-slide-x-reverse-transition>
                            </template>
                        </v-autocomplete><br>
                            <v-data-table :headers="vehicleHeaders" :items="filteredVehicleData" :items-per-page="6" class="elevation-7">
                                <template v-slot:item.image="{ item }">
                                    <v-img max-height="70" width="70" :src="item.image"></v-img>
                                </template>
                                <template v-slot:item.status="{ item }">
                                    <v-chip :color="item.status == 'Stolen' ? 'error accent-4' : 'success accent-4'" outlined>{{ item.status }}</v-chip>
                                </template>
                                <template v-slot:item.actions="{ item }">
                                    <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="success accent-4" @click="sendCallRequest()"><v-icon dense>mdi-phone</v-icon></v-btn></template><span>Call</span></v-tooltip>
                                    <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="info accent-4" @click="changeStatus(item)"><v-icon dense>mdi-car</v-icon></v-btn></template><span>Change Status</span></v-tooltip>
                                    <v-tooltip bottom><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" text color="error accent-4" @click="requestImpound()"><v-icon dense>mdi-tow-truck</v-icon></v-btn></template><span>Impound Request</span></v-tooltip>
                                </template>
                            </v-data-table>
                        </div>
                    </div>
                    </v-scale-transition>
                </v-main>
            </div>
        </v-app>
    </div>
</template>

<script>
import moment from 'moment';

export default {
    name: 'App',
    components: {
    },
    data: () => ({
        // App Hanlded Data
        publicPath: '.',
        selectedItem: 0,
        selectedLogout: 0,
        page: 1,
        pageCount: 0,
        animationLoaded: false,
        editItem: null,
        changingData: false,
        selectedCall: -1,
        newUnit: null,
        radioGroup: 0,
        newRecordData: {
            level: 0,
            date: (new Date(Date.now() - (new Date()).getTimezoneOffset() * 60000)).toISOString().substr(0, 10),
            record: '',
            description: ''
        },
        recordDataFilter: '',
        searchRecord: [],
        recordHeaders: [
            { text: 'Mugshot', value: 'mugshot', sortable: false },
            { text: 'Name', value: 'name' },
            //{ text: 'Notes', value: 'notes', sortable: false },
            { text: 'Licenses', value: 'licenses', sortable: false },
            { text: 'DOB', value: 'dob' },
            { text: 'Records', value: 'records' },
            { text: 'Actions', value: 'actions', sortable: false },
        ],
        officerDataFilter: '',
        searchOfficers: [],
        officerHeaders: [
            { text: 'Mugshot', value: 'mugshot', sortable: false },
            { text: 'Name', value: 'name' },
            { text: 'Badge Number', value: 'badgenum' },
            { text: 'DOB', value: 'dob' },
            { text: 'Actions', value: 'actions', sortable: false },
        ],
        vehicleDataFilter: '',
        searchVehicle: [],
        vehicleHeaders: [
            { text: 'Image', value: 'image', sortable: false },
            { text: 'Model', value: 'model' },
            //{ text: 'Notes', value: 'notes', sortable: false },
            { text: 'Plate', value: 'plate' },
            { text: 'Owner', value: 'owner' },
            { text: 'Status', value: 'status', sortable: false },
            { text: 'Actions', value: 'actions', sortable: false },
        ],
        // Server Handled Data
        isBoss: true,
        copsInService: 2,
        latestCalls: [
            {
                phone: '918-145-534',
                date: '02/19/2022',
                location: 'Los Santos - Rock Avenue'
            },
            {
                phone: '918-145-534',
                date: '01/19/2022',
                location: 'Los Santos - Rock Avenue'
            }
        ],
        loggedUser: {
            name: 'Lil Wayne',
            badgenum: 3000
        },
        fleet: [
            {
                unitnum: 1,
                name: 'Unit 1',
                model: 'Bravo'
            },
            {
                unitnum: 30,
                name: 'Unit 30',
                model: 'Interceptor'
            }
        ],
        recordData: [
            {
                mugshot: 'https://cdn.vuetifyjs.com/images/lists/1.jpg',
                name: 'Lil Clean',
                notes: 'Cleaned the house',
                licenses: [{ type: 'A', points: 120 }, { type: 'B', points: 120 }, { type: 'C', points: 120 }],
                dob: '01/01/2000',
                records: [
                    {
                        level: 0,
                        date: '01/01/2000',
                        record: 'Cleaned the house',
                        description: 'Cleaned the house'
                    },
                    {
                        level: 0,
                        date: '01/01/2000',
                        record: 'Cleaned the car',
                        description: 'Cleaned the car'
                    }
                ]
            },
            {
                mugshot: 'https://cdn.vuetifyjs.com/images/lists/1.jpg',
                name: 'Lil Dirty',
                notes: 'Cleaned the house',
                licenses: [{ type: 'A', points: 0 }, { type: 'G', points: 0 }],
                dob: '01/01/2000',
                records: [
                    {
                        level: 1,
                        date: '01/01/2000',
                        record: 'Cleaned the house',
                        description: 'Cleaned the house'
                    },
                    {
                        level: 2,
                        date: '01/01/2000',
                        record: 'Cleaned the car',
                        description: 'Cleaned the car'
                    },
                    {
                        level: 3,
                        date: '01/01/2000',
                        record: 'Cleaned the neighbors car',
                        description: 'Cleaned the neighbors car'
                    }
                ]
            }
        ],
        officerData: [
            {
                mugshot: 'https://cdn.vuetifyjs.com/images/lists/1.jpg',
                name: 'Lil Clean',
                notes: 'Clean cop',
                badgenum: 3000,
                dob: '01/01/2000'
            }
        ],
        vehicleData: [
            {
                image: 'https://cutewallpaper.org/24/gta-5-car-png/fastest-cars-in-gta-online.png',
                model: 'Entity',
                plate: 'ABC123',
                owner: 'Lil Clean',
                status: 'Normal'
            },
            {
                image: 'https://pbs.twimg.com/media/Dc6JMXuW4AIKziK.png',
                model: 'Autarch',
                plate: 'AAA123',
                owner: 'Lil Clean',
                status: 'Stolen'
            }
        ]
    }),
    mounted() {
        setTimeout(() => {
            this.animationLoaded = true;
        }, 400);
        for (let i = 0; i < this.vehicleData.length; i++) {
            this.searchVehicle.push(this.vehicleData[i].plate);
        }
        for (let i = 0; i < this.recordData.length; i++) {
            this.searchRecord.push(this.recordData[i].name);
        }
        for (let i = 0; i < this.officerData.length; i++) {
            this.searchOfficers.push(this.officerData[i].name);
        }
    },
    computed: {
        filteredVehicleData() {
            if (this.vehicleDataFilter === '') {
                return this.vehicleData;
            }
            return this.vehicleData.filter((vehicle) => {
                return vehicle.plate.toLowerCase().indexOf(this.vehicleDataFilter.toLowerCase()) > -1;
            });
        },
        filteredOfficerData() {
            if (this.officerDataFilter === '') {
                return this.officerData;
            }
            return this.officerData.filter((officer) => {
                return officer.name.toLowerCase().indexOf(this.officerDataFilter.toLowerCase()) > -1;
            });
        },
        filteredRecordData() {
            if (this.recordDataFilter === '') {
                return this.recordData;
            }
            return this.recordData.filter((record) => {
                return record.name.toLowerCase().indexOf(this.recordDataFilter.toLowerCase()) > -1;
            });
        }
    },
    watch: {
        selectedItem() {
            this.officerDataFilter = '';
            this.recordDataFilter = '';
            this.editItem = null;
            if (this.selectedItem === 0 || this.selectedItem === null) {
                setTimeout(() => {
                    this.animationLoaded = true;
                }, 400);
            } else {
                this.animationLoaded = false;
            }
        }
    },
    methods: {
        fromNow(date) {
            console.log(date);
            return moment(date).fromNow();
        },
        close() {
            console.log('logout');
            this.$store.commit('setHomePage', true);
        },
        sendCallRequest() {
            console.log('call request');
        },
        jail() {
            console.log('jail');
        },
        sendPing() {
            console.log('ping');
        },
        sendUnitPing() {
            console.log('unit ping');
        },
        newRecord(record) {
            if (record) {
                this.editItem = record;
            }
            this.changingData = true;
        },
        editRecord(record) {
            console.log(record);
            this.editItem = record;
            this.changingData = false;
        }
    }
}
</script>

<style lang="less" scoped>
@import '@/theme.less';

#appScreen {
    width: 55.6vw !important;
    height: 31.5vw !important;
}

</style>