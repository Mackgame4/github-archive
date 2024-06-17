<template>
  <v-app id="app">
    <v-fade-transition>
    <div v-if="!loggedIn" class="loginCard">
      <v-card-title>Login</v-card-title>
      <v-card-text>
        <v-avatar v-if="Username" style="position: absolute; top: 13px; right: 13px;" class="elevation-2" color="info darken-2" size="42"><span v-if="!avatar">{{ Username.charAt(0) }}</span><img v-if="avatar" :src="avatar"></v-avatar>
        <v-text-field v-model="Username" label="Username" placeholder="Nome Apelido" filled dense></v-text-field>
        <v-text-field v-model="Password" label="Password" placeholder="Password" filled dense></v-text-field>
        <v-btn elevation="2" block large color="info darken-2" :loading="loading" :disabled="loading" @click="login(), loader = 'loading'">Log In</v-btn>
        <v-row>
            <img style="position: absolute; bottom: 10px; left: 10px;" src="https://i.imgur.com/6OpnjA6.png" width="80px"><span style="position: absolute; bottom: 25px; left: 90px; font-family: 'Outfit', sans-serif;">App - All Rights Reserved. <br> ©Copyright Empresa 2021</span>
        </v-row>
      </v-card-text>
    </div>
    </v-fade-transition>
    <v-fade-transition>
    <div v-if="loggedIn">
    <v-navigation-drawer v-model="drawer" app>
      <v-list-item>
        <v-list-item-content>
          <v-list-item-title class="text-h6">{{ user }}</v-list-item-title>
          <v-list-item-subtitle>Painel de controle</v-list-item-subtitle>
        </v-list-item-content>
      </v-list-item>
      <v-avatar style="position: absolute; top: 13px; right: 13px;" class="elevation-2" color="info darken-2" size="42"><span v-if="!avatar">{{ user.charAt(0) }}</span><img v-if="avatar" :src="avatar"></v-avatar>
      <v-divider class="mx-3"></v-divider>
      <v-list dense nav>
        <v-list-item-group v-model="drawerOption" color="info darken-2">
          <v-list-item v-for="item, i in drawerOptions" :key="i" @click="drawer = !drawer, drawerClick(i)">
            <v-list-item-icon>
              <v-icon>{{ item.icon }}</v-icon>
            </v-list-item-icon>
            <v-list-item-content>
              <v-list-item-title>{{ item.title }}</v-list-item-title>
            </v-list-item-content>
          </v-list-item>
        </v-list-item-group>
      </v-list>
      <v-btn class="mx-2" elevation="2" absolute bottom width="93.5%" color="error accent-2" @click="logout()">Logout</v-btn>
    </v-navigation-drawer>
    <v-app-bar app>
      <v-app-bar-nav-icon @click="drawer = !drawer"></v-app-bar-nav-icon>
      <v-toolbar-title>{{ title }}</v-toolbar-title>
      <v-badge v-if="notificationList.length != 0" style="position: absolute; right: 26px; z-index: 9999;" color="error" :content="notificationList.length"></v-badge>
      <v-btn absolute right icon @click="notifications = !notifications"><v-icon>mdi-bell</v-icon></v-btn>
      <!--v-tooltip left><template v-slot:activator="{ on, attrs }"><v-btn v-bind="attrs" v-on="on" absolute right icon @click="notifications = !notifications"><v-icon>mdi-bell</v-icon></v-btn></template><span>Notifications</span></v-tooltip-->
    </v-app-bar>
    <v-scroll-x-reverse-transition>
    <v-card v-if="notifications && notificationList.length != 0" class="notifications mx-3" elevation="2">
      <v-hover v-for="notification, i in notificationList" :key="i" v-slot="{ hover }"><v-alert :type="notification.type" :dismissible="hover ? true : false" @input="onclose(i)" text dense>{{ notification.text }}</v-alert></v-hover>
    </v-card>
    </v-scroll-x-reverse-transition>
    <v-main v-if="drawerOption == 0">
      <!-- Debug -->
      <!--v-card elevation="2" class="my-3 mx-3" max-width="fit-content">
        <v-card-title>Todo List</v-card-title>
        <v-card-text>
          <v-checkbox :id="checkbox.text" v-for="checkbox, i in todoList" :key="i" v-model="checkbox.checked" :label="checkbox.text" color="info darken-2" @click="localStorageSave(checkbox.text, checkbox.checked)"></v-checkbox>
        </v-card-text>
      </v-card-->
      <v-card elevation="2" class="my-3 mx-3" max-width="100%">
        <v-card-title>Meu Progresso</v-card-title>
        <v-card-text>
          <v-sparkline v-if="sparkline.length >= 1 && sparkline.length < 8" :labels="sparklineLabels" :value="sparkline" :smooth="10 || false" :padding="8" :line-width="3" stroke-linecap="round" :fill="false" type="trend" :auto-line-width="false" auto-draw></v-sparkline>
          <v-sparkline v-if="sparkline.length >= 8" :value="sparkline" :smooth="10 || false" :padding="8" :line-width="3" stroke-linecap="round" :fill="false" type="trend" :auto-line-width="false" auto-draw></v-sparkline>
          <v-simple-table>
          <template v-if="DBConnected" v-slot:default>
            <thead>
              <tr>
                <th class="text-left">Atributo</th>
                <th class="text-left">Progresso</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td>TotalCtt</td>
                <td>{{ userRows[UID].TotalCtt }}</td>
              </tr>
              <tr>
                <td>TotalCv</td>
                <td>{{ userRows[UID].TotalCv }}</td>
              </tr>
              <tr>
                <td>TotalAp</td>
                <td>{{ userRows[UID].TotalAp }}</td>
              </tr>
              <tr>
                <td>TotalOp</td>
                <td>{{ userRows[UID].TotalOp }}</td>
              </tr>
              <tr>
                <td>TotalRes_NC</td>
                <td>{{ userRows[UID].TotalRes_NC }}</td>
              </tr>
              <tr>
                <td>TotalRes_Mig</td>
                <td>{{ userRows[UID].TotalRes_Mig }}</td>
              </tr>
              <tr>
                <td>Total_Res</td>
                <td>{{ userRows[UID].Total_Res }}</td>
              </tr>
              <tr>
                <td>Score</td>
                <td>{{ userRows[UID].Score }}</td>
              </tr>
            </tbody>
          </template>
        </v-simple-table>
        </v-card-text>
      </v-card>
      <v-alert type="error" class="mx-3 my-3" text>Esta página encontra-se de momento em desenvolvimento.</v-alert>
    </v-main>
    <v-main v-if="drawerOption == 1">
      <v-card elevation="2" class="my-3 mx-3" max-width="100%">
        <v-card-title>Relatório Diário</v-card-title>
        <v-card-subtitle>{{ today }}</v-card-subtitle>
        <v-chip class="ma-2" color="info darken-4" label text-color="white"><v-icon left>mdi-calendar</v-icon>Objetivo Mês: {{ userRows[UID].Objetivo }}NC</v-chip>
        <v-chip v-if="(parseInt(userRows[UID].Objetivo)-(parseInt(cachedRES_NC)+parseInt(cachedRES_MIG))) >= 0" style="position: absolute; right: 0;" class="ma-2" color="error darken-4" label text-color="white"><v-icon left>mdi-label</v-icon>Faltam: {{ parseInt(userRows[UID].Objetivo)-(parseInt(cachedRES_NC)+parseInt(cachedRES_MIG)) }}NC</v-chip>
        <v-chip v-if="(parseInt(userRows[UID].Objetivo)-(parseInt(cachedRES_NC)+parseInt(cachedRES_MIG))) < 0" style="position: absolute; right: 0;" class="ma-2" color="orange" label text-color="white"><v-icon left>mdi-star</v-icon>Feitos: +{{ (parseInt(cachedRES_NC)+parseInt(cachedRES_MIG))-parseInt(userRows[UID].Objetivo) }}NC</v-chip>
        <v-card-text>
          <span>Cel</span>
          <v-otp-input v-model="Cel" length="5"></v-otp-input>
          <v-divider class="mx-3"></v-divider>
          <br>
          <v-text-field v-model="Ctt" type="number" max="999" label="Ctt" placeholder="0" filled dense></v-text-field>
          <v-text-field v-model="CV" type="number" label="CV" max="999" placeholder="0" filled dense></v-text-field>
          <v-text-field v-model="AP" type="number" label="AP" max="999" placeholder="0" filled dense></v-text-field>
          <v-text-field v-model="OP" type="number" label="OP" max="999" placeholder="0" filled dense></v-text-field>
          <v-text-field v-model="RES_NC" type="number" label="RES_NC" max="99" placeholder="0" filled dense></v-text-field>
          <v-text-field v-model="RES_MIG" type="number" label="RES_MIG" max="99" placeholder="0" filled dense></v-text-field>
          <v-btn elevation="2" block large color="info darken-2" :loading="loading" :disabled="loading" @click="submitRel(), loader = 'loading'">Submeter</v-btn>
        </v-card-text>
      </v-card>
    </v-main>
    <v-main v-if="drawerOption == drawerOptions.length-1">
      <v-card elevation="2" class="my-3 mx-3" max-width="100%">
        <v-card-title>Painel Administrativo</v-card-title>
        <v-card-subtitle>{{ today }}</v-card-subtitle>
        <v-card-text>
          <v-data-iterator :items="userRows" item-key="GC" :single-expand="true" hide-default-footer>
            <template v-slot:default="{ items, isExpanded, expand }">
              <v-row>
                <v-col v-for="item, i in items" :key="i" cols="12" sm="6" md="4" lg="3">
                  <v-card>
                    <v-card-title>{{ item.GC }}</v-card-title><v-avatar style="position: absolute; top: 13px; right: 13px;" class="elevation-2" color="info darken-2" size="42"><span v-if="!item.Foto">{{ item.GC.charAt(0) }}</span><img v-if="item.Foto" :src="item.Foto"></v-avatar>
                    <v-switch :input-value="isExpanded(item)" :label="isExpanded(item) ? 'Expandido' : 'Fechado'" class="pl-4 mt-0" @change="(v) => expand(item, v)"></v-switch>
                    <v-divider></v-divider>
                    <v-list v-if="isExpanded(item)" dense>
                      <v-list-item>
                        <!--v-list-item-content>GEV:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.GEV }}</v-list-item-content-->
                        <v-text-field v-model="item.GEV" class="align-end" label="GEV" filled dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <!--v-list-item-content>GE:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.GE }}</v-list-item-content-->
                        <v-text-field v-model="item.GE" class="align-end" label="GE" filled dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <!--v-list-item-content>GC:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.GC }}</v-list-item-content-->
                        <v-text-field v-model="item.GC" class="align-end" label="GC" filled dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <!--v-list-item-content>Foto:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.Foto }}</v-list-item-content-->
                        <v-text-field v-model="item.Foto" class="align-end" label="Foto" filled dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <!--v-list-item-content>Password:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.Password }}</v-list-item-content-->
                        <v-text-field :append-icon="showPassword ? 'mdi-eye' : 'mdi-eye-off'" :type="showPassword ? 'text' : 'password'" v-model="item.Password" class="align-end" label="Password" filled dense @click:append="showPassword = !showPassword"></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <!--v-list-item-content>Objetivo:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.Objetivo }}</v-list-item-content-->
                        <v-text-field v-model="item.Objetivo" class="align-end" label="Objetivo" filled dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>TotalCtt:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.TotalCtt }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>TotalCV:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.TotalCv }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>TotalAP:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.TotalAp }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>TotalOP:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.TotalOp }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>TotalRes_NC:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.TotalRes_NC }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>TotalRes_Mig:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.TotalRes_Mig }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>Total_Res:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.Total_Res }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <v-list-item-content>Score:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.Score }}</v-list-item-content>
                      </v-list-item>
                      <v-list-item>
                        <!--v-list-item-content>AppData:</v-list-item-content>
                        <v-list-item-content class="align-end">{{ item.AppData }}</v-list-item-content-->
                        <v-text-field v-model="item.AppData" class="align-end" label="AppData" filled dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <v-subheader>Send Notification (ex: success, error, info, warn)</v-subheader>
                      </v-list-item>
                      <v-list-item>
                        <v-text-field v-model="sendNotificationType" class="align-end" label="Notification Type" outlined dense></v-text-field>
                        <v-text-field v-model="sendNotificationText" class="align-end" label="Notification Text" append-icon="mdi-send" @click:append="sendNotification(i, sendNotificationType, sendNotificationText)" outlined dense></v-text-field>
                      </v-list-item>
                      <v-list-item>
                        <v-btn elevation="2" block color="info darken-2" :loading="loading" :disabled="loading" @click="updateUser(i, item.GEV, item.GE, item.GC, item.Foto, item.Password, item.Objetivo, item.AppData), loader = 'loading'"><v-icon left>mdi-content-save</v-icon>Salvar</v-btn>
                      </v-list-item>
                    </v-list>
                  </v-card>
                </v-col>
              </v-row>
            </template>
          </v-data-iterator>
        </v-card-text>
      </v-card>
    </v-main>
    </div>
    </v-fade-transition>
  </v-app>
</template>

<script>
import moment from 'moment';
const { GoogleSpreadsheet } = require('google-spreadsheet');
const creds = require('@/client_secret.json');

export default {
  name: 'App',
  components: {
  },
  data: () => ({
    development: false,
    DBConnected: false,
    sparklineLabels: [],
    sparkline: [],
    showPassword: false,
    sendNotificationType: 'info',
    sendNotificationText: '',
    // Login Page
    Username: '',
    Password: '',
    UID: null,
    loggedIn: false,
    // Dashboard
    drawer: false,
    user: 'Username',
    avatar: null,
    title: 'Dashboard',
    today: moment().locale("pt").format('LL'),
    userSheet: null,
    sheet: null,
    userRows: [],
    userData: [],
    rows: [],
    Cel: '',
    Ctt: null,
    CV: null,
    AP: null,
    OP: null,
    RES_NC: null,
    RES_MIG: null,
    cachedCtt: 0,
    cachedCV: 0,
    cachedAP: 0,
    cachedOP: 0,
    cachedRES_NC: 0,
    cachedRES_MIG: 0,
    cachedTotal_Res: 0,
    cachedScore: 0,
    loader: null,
    loading: false,
    notifications: false,
    notificationList: [
      /*{ text: 'Im an Alert Usage Example', type: 'success' },
      { text: 'Im an Alert Usage Example', type: 'info' },
      { text: 'Im an Alert Usage Example', type: 'warning' },
      { text: 'Im an Alert Usage Example', type: 'error' },*/
    ],
    todoList: [
      { text: 'Dashboard', checked: false },
      { text: 'Relatório', checked: false },
      { text: 'Relatório DB', checked: false },
      { text: 'Resumo semanal (gráfico, etc)', checked: false },
      { text: 'Resumo DB', checked: false },
      { text: 'Status empresa', checked: false },
      { text: 'Status DB', checked: false },
      { text: 'Sobre', checked: false },
      { text: 'Profile', checked: false },
      { text: 'Notifications', checked: false },
      { text: 'Admin Panel?', checked: false },
    ],
    drawerOption: 0,
    drawerOptions: [
      { title: 'Dashboard', icon: 'mdi-view-dashboard' },
      { title: 'Relatório', icon: 'mdi-clipboard-check-multiple' },
      /*{ title: 'Resumo Semanal', icon: 'mdi-chart-pie' },
      { title: 'Status Empresa', icon: 'mdi-chart-bar' },
      { title: 'Sobre', icon: 'mdi-help-box' },*/
    ],
  }),
  mounted() {
    this.user = localStorage.getItem('user');
    this.avatar = localStorage.getItem('avatar');
    if (this.user == undefined || this.user == 'undefined' || this.user == null || this.user == '' || this.user == 'null') {
      this.accessSpreadSheet(1);
    }
    this.title = this.drawerOptions[this.drawerOption].title;
    // Debug
    for (let i = 0; i < this.todoList.length; i++) {
      var checked = JSON.parse(localStorage.getItem(this.todoList[i].text));
      if (checked != null) {
        this.todoList[i].checked = checked;
      }
    }
    console.log(`UI Loaded [${this.development ? 'Development Mode' : 'Built'}]`);
  },
  watch: {
    rows() {
        var lastData = null;
        for (let i = 0; i < this.rows.length; i++) {
          if (this.rows[i].Sem != null && this.rows[i].GC == this.user) {
            if (lastData == this.rows[i].Sem) {
              console.log('Duplicate Data');
            } else {
              lastData = this.rows[i].Sem;
              this.sparkline.push(parseInt(this.rows[i].Total_Res));
              this.sparklineLabels.push(this.rows[i].Sem);
            }
          }
        }
    },
    DBConnected() {
      if (this.DBConnected) {
        for (let i = 0; i < this.rows.length; i++) {
          if (this.rows[i].GC == this.Username || this.rows[i].GC == this.user) {
            this.UID = i;
            this.userData = JSON.parse(this.userRows[i].AppData);
            this.notificationList = this.userData.notifications;
            if (this.userData.isAdmin) {
              this.drawerOptions.push({ title: 'Painel Administrativo', icon: 'mdi-account-key' });
            }
            this.cachedCtt = this.rows[this.UID].TotalCtt;
            this.cachedCV = this.rows[this.UID].TotalCv;
            this.cachedAP = this.rows[this.UID].TotalAp;
            this.cachedOP = this.rows[this.UID].TotalOp;
            this.cachedRES_NC = this.rows[this.UID].TotalRes_NC;
            this.cachedRES_MIG = this.rows[this.UID].TotalRes_Mig;
            this.cachedTotal_Res = this.rows[this.UID].Total_Res;
            this.cachedScore = this.rows[this.UID].Score;
            console.log(`User Found: ${this.rows[i].GC}`, this.UID);
            break;
          }
        }
      }
    },
    loader() {
      if (this.Cel || this.Ctt || this.CV || this.AP || this.OP || this.RES_NC || this.RES_MIG) {
        const l = this.loader
        this[l] = !this[l]
        setTimeout(() => (this[l] = false), 1700)
        this.loader = null
      }
    },
    user() {
      if (this.user == undefined || this.user == 'undefined' || this.user == null || this.user == '' || this.user == 'null') {
        this.loggedIn = false;
      } else {
        this.accessSpreadSheet(1);
        this.accessSpreadSheet(0);
        this.loggedIn = true;
        /*this.cachedCtt = this.userRows[this.UID].TotalCtt;
        this.cachedCV = this.userRows[this.UID].TotalCv;
        this.cachedAP = this.userRows[this.UID].TotalAp;
        this.cachedOP = this.userRows[this.UID].TotalOp;
        this.cachedRES_NC = this.userRows[this.UID].TotalRes_NC;
        this.cachedRES_MIG = this.userRows[this.UID].TotalRes_Mig;
        this.cachedTotal_Res = this.userRows[this.UID].Total_Res;
        this.cachedScore = this.userRows[this.UID].Score;*/
      }
    },
    Username() {
      if (this.Username != undefined || this.Username != 'undefined' || this.Username != null || this.Username != '' || this.Username != 'null') {
        for (let i = 0; i < this.rows.length; i++) {
          if (this.rows[i].GC == this.Username) {
            this.avatar = this.rows[i].Foto;
            break;
          } else if (this.rows[i].GC != this.Username) {
            this.avatar = null;
          }
        }
      }
    }
  },
  methods: {
    sendNotification(id, type, text) {
      var notification = '{ "type":"' + type + '", "text":"' + text + '"}';
      if (text != null && text != '' && text != 'null' && text != 'undefined') {
        if (id == this.UID) {
          this.userData.notifications.push(notification);
          var textUserData = '{ "isAdmin":"' + this.userData.isAdmin + '", "notifications":[' + this.userData.notifications + ']}';
        } else {
          // TODO: Get this id user data then add notification
        }
        //console.log(this.sendNotificationText, notification, textUserData, this.userData);
        this.updateSheetData(1, id, {AppData: textUserData});
      }
    },
    updateUser(id, GEV, GE, GC, Foto, Password, Objetivo, AppData) {
      this.updateSheetData(1, id, {GEV: GEV, GE: GE, GC: GC, Foto: Foto, Password: Password, Objetivo: Objetivo, AppData: AppData});
    },
    login() {
      if (this.Username && this.Password) {
        for (let i = 0; i < this.rows.length; i++) {
          if (this.rows[i].GC == this.Username && this.rows[i].Password == this.Password) {
            this.user = this.rows[i].GC;
            this.avatar = this.rows[i].Foto;
            this.UID = i;
            localStorage.setItem('user', this.user);
            localStorage.setItem('avatar', this.avatar);
            this.loggedIn = true;
            break;
          }
        }
      }
    },
    logout() {
      this.user = null;
      this.avatar = null;
      localStorage.removeItem('user');
      localStorage.removeItem('avatar');
      this.loggedIn = false;
    },
    async submitRel() {
      //console.log(this.Cel, this.Ctt, this.CV, this.AP, this.OP, this.RES_NC, this.RES_MIG);
      if (this.Cel || this.Ctt || this.CV || this.AP || this.OP || this.RES_NC || this.RES_MIG) {
        let TotalRes = parseFloat(parseInt(this.RES_NC)+parseInt(this.RES_MIG)*0.3);
        await this.sheet.addRow({
          Data: this.today,
          Ano: moment().locale("pt").format('YYYY'),
          Mes: moment().locale("pt").format('MM'),
          Sem: moment().locale("pt").format('W'),
          GC: this.user,
          Cel: this.Cel,
          Ctt: this.Ctt,
          Cv: this.CV,
          Ap: this.AP,
          Op: this.OP,
          Res_NC: this.RES_NC,
          Res_Mig: this.RES_MIG*0.3,
          Total_Res: TotalRes
        });
        this.cachedCtt = parseInt(this.cachedCtt)+parseInt(this.Ctt);
        this.cachedCV = parseInt(this.cachedCV)+parseInt(this.CV);
        this.cachedAP = parseInt(this.cachedAP)+parseInt(this.AP);
        this.cachedOP = parseInt(this.cachedOP)+parseInt(this.OP);
        this.cachedRES_NC = parseInt(this.cachedRES_NC)+parseInt(this.RES_NC);
        this.cachedRES_MIG = parseInt(this.cachedRES_MIG)+parseInt(this.RES_MIG);
        this.cachedTotal_Res = parseFloat(this.cachedTotal_Res)+TotalRes;
        this.cachedScore = parseFloat(this.cachedScore)+parseInt(this.RES_NC)+parseInt(this.RES_MIG);
        await this.updateSheetData(1, this.UID, {
          TotalCtt: this.cachedCtt,
          TotalCv: this.cachedCV,
          TotalAp: this.cachedAP,
          TotalOp: this.cachedOP,
          TotalRes_NC: this.cachedRES_NC,
          TotalRes_Mig: this.cachedRES_MIG,
          Total_Res: this.cachedTotal_Res,
          Score: this.cachedScore
        });
        if (!this.development) {
          setTimeout(() => (
            this.Cel = '',
            this.Ctt = null,
            this.CV = null,
            this.AP = null,
            this.OP = null,
            this.RES_NC = null,
            this.RES_MIG = null
          ), 1000)
        }
      }
    },
    async accessSpreadSheet(id) {
      // https://www.npmjs.com/package/google-spreadsheet#examples
			const doc = new GoogleSpreadsheet('16jf-wF9ydYh6-5zceRzunKH3rgBFkHU_DiNEDqp_FEk');
			await doc.useServiceAccountAuth(creds);
			await doc.loadInfo(); 
			const sheet = doc.sheetsByIndex[id];
      this.sheet = sheet;
			const  rows = await sheet.getRows({
				//offset: 1
			})
			this.rows = rows;
      if (id == 1){
        this.userSheet = sheet;
        this.userRows = this.rows;
      }
      this.DBConnected = true;
      console.log(this.rows);
		},
    async updateSheetData(sheetIndex, rowIndex, data) {
      // https://www.npmjs.com/package/google-spreadsheet#examples
			const doc = new GoogleSpreadsheet('16jf-wF9ydYh6-5zceRzunKH3rgBFkHU_DiNEDqp_FEk');
			await doc.useServiceAccountAuth(creds);
			await doc.loadInfo(); 
			const sheet = doc.sheetsByIndex[sheetIndex];
			const rows = await sheet.getRows()
      if (data.COORD != null) {
        rows[rowIndex].COORD = data.COORD;
      }
      if (data.Password != null) {
        rows[rowIndex].Password = data.Password;
      }
      if (data.Foto != null) {
        rows[rowIndex].Foto = data.Foto;
      }
      if (data.GEV != null) {
        rows[rowIndex].GEV = data.GEV;
      }
      if (data.GE != null) {
        rows[rowIndex].GE = data.GE;
      }
      if (data.GC != null) {
        rows[rowIndex].GC = data.GC;
      }
      if (data.Objetivo != null) {
        rows[rowIndex].Objetivo = data.Objetivo;
      }
      if (data.TotalCtt != null) {
        rows[rowIndex].TotalCtt = data.TotalCtt;
      }
      if (data.TotalCv != null) {
        rows[rowIndex].TotalCv = data.TotalCv;
      }
      if (data.TotalAp != null) {
        rows[rowIndex].TotalAp = data.TotalAp;
      }
      if (data.TotalOp != null) {
        rows[rowIndex].TotalOp = data.TotalOp;
      }
      if (data.TotalRes_NC != null) {
        rows[rowIndex].TotalRes_NC = data.TotalRes_NC;
      }
      if (data.TotalRes_Mig != null) {
        rows[rowIndex].TotalRes_Mig = data.TotalRes_Mig;
      }
      if (data.Total_Res != null) {
        rows[rowIndex].Total_Res = data.Total_Res;
      }
      if (data.AppData != null) {
        rows[rowIndex].AppData = data.AppData;
      }
			rows[rowIndex].Score = data.Score;
      await rows[rowIndex].save();
      //setTimeout(() => (this.accessSpreadSheet(sheetIndex)), 300);
      //console.log(rows[rowIndex]);
		},
    onclose(index) {
      this.notifications = false;
      this.notificationList.splice(index, 1);
      var textUserData = '{ "isAdmin":"' + this.userData.isAdmin + '", "notifications":' + JSON.stringify(this.notificationList) + '}';
      console.log(textUserData, this.userData,);
      this.updateSheetData(1, this.UID, {AppData: textUserData});
      setTimeout(() => { this.notifications = true }, 300);
    },
    // addTodo
    addEvent: function() {
        if(this.event.name) {
            this.events.push(this.event);
            this.event = { name: '', description: '', date: '' };
        }
    },
    drawerClick(selected) {
      this.title = this.drawerOptions[selected].title;
      setTimeout(() => { this.drawerOption = selected; }, 100);
    },
    localStorageSave(name, checked) {
      localStorage.setItem(name, checked)
      console.log(name, checked);
    }
  }
};
</script>

<style lang="less">
@import url('https://fonts.googleapis.com/css2?family=Outfit&display=swap');

* {
  box-sizing: border-box;
  font-family: ui-sans-serif, system-ui, -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, "Noto Sans", sans-serif, "Apple Color Emoji", "Segoe UI Emoji", "Segoe UI Symbol", "Noto Color Emoji";
  font-weight: 600;
}

body, html {
    width: 100vw;
    height: 100vh;
    overflow: none;
    padding: 0;
    margin: 0;
    -webkit-font-smoothing: antialiased;
    -moz-osx-font-smoothing: grayscale;
}

::-webkit-scrollbar {
  display: none;
}

.loginCard {
  position: absolute;
  width: 100%;
  height: 100%;
  background-color: #121212;
  z-index: 9999;
}

.v-data-table > .v-data-table__wrapper > table > tbody > tr > td {
  font-size: 20px !important;
}

.notifications {
  position: absolute !important;
  top: 50px;
  right: 0px;
  padding: 12px 12px 0px 12px;
  z-index: 9999;
  
  .v-alert {
    margin-bottom: 12px;
  }
}
</style>