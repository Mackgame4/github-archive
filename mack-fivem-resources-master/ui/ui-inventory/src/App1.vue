<template>
    <div id="app">
        <v-app>
          <div id="playerInventory">
            <grid-layout :layout.sync="playerInventory" :col-num="colNum" :row-height="8.1" :is-draggable="true" :is-resizable="false">
                <grid-item v-for="(item, i) in playerInventory" :key="i" @moved="isInHotbar" :static="false" :x="item.x" :y="item.y" :w="item.w" :h="item.h" :i="item.i">
                  <v-card class="item" style="width: 100%; height: 100%;">
                    <v-card-subtitle class="itemHotbar">{{ item.isInHotbar  }}</v-card-subtitle>
                    <v-card-subtitle class="itemSubtitle">{{ getItem(item.name).weight }}Kg</v-card-subtitle>
                    <img class="itemImage" :src="getItem(item.name).image" draggable="false" />
                    <v-card-text class="itemName">{{ getItem(item.name).label }}</v-card-text>
                  </v-card>
                </grid-item>
            </grid-layout>
          </div>
          <div id="actions">
            <v-btn color="primary" @click="addItem('bread')">Add Bread</v-btn>
            <v-btn color="primary" @click="addItem('carabine')">Add Carabine</v-btn>
            <v-btn color="primary" @click="addItem('rpg')">Add RPG</v-btn>
            <v-btn color="primary" @click="addItem('knife')">Add Knife</v-btn>
          </div>
          <div id="secondInventory">
          </div>
        </v-app>
    </div>
</template>

<script>
import Nui from './utils/Nui';
import { GridLayout, GridItem } from "vue-grid-layout"

export default {
    name: 'Inventory',
    components: {
      GridLayout,
      GridItem
    },
    data: () => ({
        // Debug
        development: process.env.NODE_ENV !== 'production',
        items: [
            { name: 'bread', label: 'Bread', description: 'A bread', image: 'https://breadmaker.com.br/wp-content/uploads/2021/04/bg-frances.png', weight: 3, slotSize: 'normal' }, 
            { name: 'water', label: 'Water', description: 'A bottle of water', image: 'https://www.monde-selection.com/wp-content/uploads/2021/05/1031071.png', weight: 3, slotSize: 'normal' },
            { name: 'carabine', label: 'Assault Carabine', description: 'A weapon', image: 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Bushmaster_Carbon-15_SBR.png', weight: 8, slotSize: 'droubleSlot' },
            { name: 'rpg', label: 'RPG', description: 'An rpg', image: 'https://oyster.ignimgs.com/mediawiki/apis.ign.com/grand-theft-auto-5/b/b1/W_LR_RPG.png', weight: 18, slotSize: 'tripleSlot' },
            { name: 'soda', label: 'Sprunk', description: 'A soda', image: 'https://i.imgur.com/1cRbGzg.png', weight: 5, slotSize: 'normal' },
            { name: 'knife', label: 'Knife', description: 'A knife', image: 'https://i.imgur.com/Jo5Bw2A.png', weight: 2, slotSize: 'vertical' }
        ],
        // App Data
        colNum: 17,
        playerInventory: [
          {"x":0,"y":0,"w":2,"h":5,"i":"0", name: 'bread'},
          {"x":2,"y":0,"w":2,"h":5,"i":"1", name: 'water'},
          {"x":4,"y":0,"w":3,"h":5,"i":"2", name: 'carabine'},
          {"x":7,"y":0,"w":6,"h":5,"i":"3", name: 'rpg'},
          {"x":13,"y":0,"w":2,"h":5,"i":"4", name: 'soda'},
          {"x":15,"y":0,"w":2,"h":5,"i":"5", name: 'bread'},
          {"x":0,"y":5,"w":2,"h":5,"i":"6", name: 'water'},
          {"x":0,"y":5,"w":2,"h":10,"i":"7", name: 'knife'}
        ]
    }),
    mounted() {
      this.$nextTick(() => {
        const that = this;
        that.isInHotbar();
      });
      if (!this.development) {
          this.listener = window.addEventListener('message', e => {
              const item = e.data || e.detail;
              const { event, data } = item;
              if (event) {
                  this.$root.$emit(event, data)
                  this.$root.$emit('addNuiEventLog', false, event, data);
              }
          }, false);

          if (Nui.inDev()) {
              this.development = true;
          }
      }
      console.log(`UI Loaded [${this.development ? 'Development Mode' : 'Built'}]`);
    },
    computed: {
    },
    methods: {
      getItem(name) {
        return this.items.find(item => item.name === name);
      },
      isInHotbar() {
        for (let i = 0; i < this.playerInventory.length; i++) {
          if (this.playerInventory[i].x <= 7 && this.playerInventory[i].y == 0) {
            this.playerInventory[i].isInHotbar = true;
          } else {
            this.playerInventory[i].isInHotbar = false;
          }
        }
      },
      addItem(itemName) {
          this.playerInventory.push({
            x: 0,
            y: 0,
            w: this.getItem(itemName).slotSize == 'normal' || this.getItem(itemName).slotSize == 'vertical' ? 2 : this.getItem(itemName).slotSize == 'tripleSlot' ? 6 : 3,
            h: this.getItem(itemName).slotSize == 'vertical' ? 10 : 5,
            i: this.playerInventory.length,
            name: itemName
          });
      }
    }
}
</script>

<style lang="less">
@import '@/theme.less';

body, html, #app {
  width: 100vw;
  height: 100vh;
  overflow: hidden !important;
  padding: 0;
  margin: 0;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  user-select: none;
}

::-webkit-scrollbar {
  width: 10px;
}

::-webkit-scrollbar-track {
  background: none;
}

::-webkit-scrollbar-thumb {
  background: #888;
  border-radius: 5px;
}

::-webkit-scrollbar-thumb:hover {
  background: #555;
}

.v-application {
  background: transparent !important;
  overflow: hidden !important;
}

.vue-grid-layout {
  background: rgba(0, 0, 0, 0.6);
  border-radius: 5px;
  width: 100%;
  min-height: 105px;
  max-height: 372px;
  overflow-y: auto;
  overflow-x: hidden;
}

.vue-grid-item.vue-grid-placeholder {
  background: rgba(0, 0, 0, 0.6) !important;
  border-radius: 5px;
  opacity: 0.2;
  transition-duration: 100ms;
  z-index: 2;
  -webkit-user-select: none;
  -moz-user-select: none;
  -ms-user-select: none;
  -o-user-select: none;
  user-select: none;
}

.vue-grid-item {
  touch-action: none !important;
}

#playerInventory {
  position: absolute;
  top: 25%;
  right: 12px;
  width: 800px;
}

.item {
  width: 100%;
  height: 100%;

  .itemHotbar {
    position: absolute;
    top: -15px;
    right: -10px;
    color: white !important;
    font-size: 12px;
    z-index: 999;
  }

  .itemSubtitle {
    position: absolute;
    top: -15px;
    left: -10px;
    font-size: 12px;
    z-index: 999;
  }

  .itemImage {
    position: absolute;
    width: 70%;
    transform: translate(-50%, -60%);
    top: 50%;
    left: 50%;
  }

  .itemName {
    position: absolute;
    bottom: -14px;
    text-align: center;
    width: 100%;
    color: white !important;
    z-index: 999;
  }
}
</style>