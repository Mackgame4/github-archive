<template>
  <div id="app">
    <v-app>
      <v-fade-transition>
      <main v-if="show">
    <v-btn v-if="development" color="primary" @click="addItem('bread')">Add Bread</v-btn>
    <!-- Clone/Dragging item -->
    <div id="clone" style="position: absolute; z-index: 9999; opacity: 0.9;" class="item">
      <transition name="fade">
        <v-card v-if="draggingItem" height="110" width="110">
          <v-card-subtitle class="itemWeight">{{ getItem(draggingItem.name).weight }}Kg</v-card-subtitle>
          <v-card-subtitle class="itemQuantity">{{ draggingItem.quantity }}</v-card-subtitle>
          <img class="itemImage" max-width="90" :src="getItem(draggingItem.name).image" draggable="false" />
          <v-card-text class="itemName">{{ getItem(draggingItem.name).label }}</v-card-text>
        </v-card>
      </transition>
    </div>
    <!-- Player Inventory Container -->
    <v-card id="playerInventory">
      <v-card :id="'slot'+slot" class="slot" v-for="slot in inventorySlots" :key="slot" height="120" width="120">
            <div v-for="(item, i) in playerInventory" :key="i">
              <div v-if="item.slot === slot" class="item">
                <v-card-subtitle :id="'slot'+slot" class="itemWeight">{{ getItem(item.name).weight }}Kg</v-card-subtitle>
                <v-card-subtitle :id="'slot'+slot" class="itemQuantity">{{ item.quantity }}</v-card-subtitle>
                <img :id="'slot'+slot" class="itemImage" max-width="90" :src="getItem(item.name).image" draggable="false" />
                <v-card-text :id="'slot'+slot" class="itemName">{{ getItem(item.name).label }}</v-card-text>
              </div>
            </div>
      </v-card>
    </v-card>
    <!-- Player Actions Container -->
    <v-card id="actions">
      <v-fade-transition>
        <div v-if="draggingItem" style="position: absolute; top: 3px; right: 3px; text-align: right; width: 500px;">
          <v-card-title style="position: absolute; top: 5px; right: 0px;">{{ getItem(draggingItem.name).label }}</v-card-title>
          <v-card-subtitle style="position: absolute; top: 63px; right: 0px;">{{ getItem(draggingItem.name).description }}</v-card-subtitle>
        </div>
      </v-fade-transition>
      <v-fade-transition>
        <div v-if="!draggingItem" style="position: absolute; top: 3px; right: 3px; text-align: right; width: 500px;">
          <v-text-field style="position: absolute; top: 26px; right: 12px;" v-model="splitNumber" hint="Change the amount you want to move." label="Amount" single-line color="black" type="number" min="1" max="100" outlined dense></v-text-field>
        </div>
      </v-fade-transition>
      <v-tooltip top color="info"><template v-slot:activator="{ on, attrs }"><v-btn id="useBtn" fab large v-bind="attrs" v-on="on"><v-icon id="useBtn">mdi-hand-back-left</v-icon></v-btn></template><span>Use</span></v-tooltip>
      <v-tooltip top color="error"><template v-slot:activator="{ on, attrs }"><v-btn id="dropBtn" style="margin-left: 15px;" fab large v-bind="attrs" v-on="on"><v-icon id="dropBtn">mdi-delete</v-icon></v-btn></template><span>Drop</span></v-tooltip>
      <v-tooltip top color="success"><template v-slot:activator="{ on, attrs }"><v-btn id="giveBtn" style="margin-left: 15px;" fab large v-bind="attrs" v-on="on"><v-icon id="giveBtn">mdi-hand-extended</v-icon></v-btn></template><span>Give</span></v-tooltip>
      <v-tooltip top color=""><template v-slot:activator="{ on, attrs }"><v-btn id="craftBtn" style="margin-left: 15px;" fab large v-bind="attrs" v-on="on" @click="craft = !craft"><v-icon id="craftBtn">mdi-hammer-screwdriver</v-icon></v-btn></template><span>Craft</span></v-tooltip>
    </v-card>
    <!-- Player Secondary Inventory -->
    <v-card id="player">
      <transition name="fade">
        <div v-if="!craft && !animationTimer" id="secondInventory">
          <img :src="playerModel" class="playerImage" />
          <div class="hotbar">
            <v-card :id="'slot'+slot" class="slot" v-for="slot in 3" :key="slot" height="120" width="120" style="margin: 4px;">
              <div v-for="(item, i) in playerInventory" :key="i">
                <div v-if="item.slot === slot" class="item">
                  <v-card-subtitle :id="'slot'+slot" class="itemWeight">{{ getItem(item.name).weight }}Kg</v-card-subtitle>
                  <v-card-subtitle :id="'slot'+slot" class="itemQuantity">{{ item.quantity }}</v-card-subtitle>
                  <img :id="'slot'+slot" class="itemImage" max-width="90" :src="getItem(item.name).image" draggable="false" />
                  <v-card-text :id="'slot'+slot" class="itemName">{{ getItem(item.name).label }}</v-card-text>
                  <v-card-subtitle :id="'slot'+slot" class="itemPosition">{{ slot }}</v-card-subtitle>
                </div>
              </div>
            </v-card>
          </div>
        </div>
      </transition>
        <transition name="fade">
        <div v-if="craft && animationTimer" id="craft">
          <div id="crafttable">
            <v-card :id="'craftslot'+slot" class="craftslot" v-for="slot in 9" :key="slot" height="120" width="120">
                <div v-for="(item, i) in crafting" :key="i">
                  <div v-if="item.slot === slot" class="item">
                    <v-card-subtitle :id="'craftslot'+slot" class="itemWeight">{{ getItem(item.name).weight }}Kg</v-card-subtitle>
                    <v-card-subtitle :id="'craftslot'+slot" class="itemQuantity">{{ item.quantity }}</v-card-subtitle>
                    <img :id="'craftslot'+slot" class="itemImage" max-width="90" :src="getItem(item.name).image" draggable="false" />
                    <v-card-text :id="'craftslot'+slot" class="itemName">{{ getItem(item.name).label }}</v-card-text>
                  </div>
                </div>
            </v-card>
          </div>
          <!--v-card-subtitle style="text-align: center; margin-top: -2px;">Wow look what you found. Looks like you're crafting a cake!</v-card-subtitle-->
          <v-card id="craftedItem" class="craftedItem" height="120" width="120">
              <div v-for="(item, i) in craftingRecepies" :key="i">
                <div v-if="checkRecipe(item)" class="item">
                  <v-card-subtitle id="craftedItem" class="itemWeight" style="color: lightgrey;">{{ getItem(item.name).weight }}Kg</v-card-subtitle>
                  <v-card-subtitle id="craftedItem" class="itemQuantity">1</v-card-subtitle>
                  <img id="craftedItem" class="itemImage" max-width="90" :src="getItem(item.name).image" draggable="false" />
                  <v-card-text id="craftedItem" class="itemName">{{ getItem(item.name).label }}</v-card-text>
                </div>
              </div>
          </v-card>
          <v-btn absolute bottom large color="error" @click="craft = false"><v-icon left>mdi-close</v-icon>Close</v-btn>
          <v-btn absolute bottom right large color="" @click="executeCraft"><v-icon left>mdi-hammer-screwdriver</v-icon>Craft</v-btn>
        </div>
        </transition>
      </v-card>
      </main>
      </v-fade-transition>
    </v-app>
  </div>
</template>

<script>
import Nui from './utils/Nui';

export default {
    name: 'Inventory',
    components: {
    },
    data: () => ({
        // Debug
        development: process.env.NODE_ENV !== 'production',
        animationTimer: false,
        items: [
            { name: 'bread', label: 'Bread', description: 'A bread', image: 'https://breadmaker.com.br/wp-content/uploads/2021/04/bg-frances.png', weight: 3, stackable: true, singleuse: true }, 
            { name: 'water', label: 'Water', description: 'A bottle of water', image: 'https://www.monde-selection.com/wp-content/uploads/2021/05/1031071.png', weight: 3, stackable: true, singleuse: true },
            { name: 'carabine', label: 'Assault Carabine', description: 'A weapon', image: 'https://upload.wikimedia.org/wikipedia/commons/d/d4/Bushmaster_Carbon-15_SBR.png', weight: 8, stackable: false, singleuse: false },
            { name: 'soda', label: 'Sprunk Soda', description: 'A soda', image: 'https://i.imgur.com/b9aZtfW.png', weight: 5, stackable: true, singleuse: true },
            { name: 'cake', label: 'Cake', description: 'A cake', image: 'https://i.imgur.com/iQrGb3Y.png', weight: 10, stackable: true, singleuse: true },
        ],
        // App Data
        show: false,
        splitNumber: 1,
        playerSex: 'male',
        craft: false,
        inventorySlots: 40,
        playerInventory: [
            { name: 'bread', quantity: 2, slot: 1 },
            { name: 'soda', quantity: 2, slot: 4 },
            { name: 'water', quantity: 1, slot: 2 },
            { name: 'bread', quantity: 1, slot: 3 },
            { name: 'water', quantity: 1, slot: 6 },
            { name: 'carabine', quantity: 1, slot: 7 }
        ],
        draggingItem: null,
        crafting: [
          { name: 'bread', quantity: 1, slot: 1 },
          { name: 'soda', quantity: 1, slot: 4 },
          { name: 'water', quantity: 1, slot: 2 },
        ],
        craftingRecepies: [
          { name: 'cake', recepi : [{ name: 'bread', quantity: 1, slot: 1 }, { name: 'soda', quantity: 1, slot: 4 }, { name: 'water', quantity: 1, slot: 2 }] },
          { name: 'bread', recepi : [{ name: 'soda', quantity: 1, slot: 1 }, { name: 'bread', quantity: 1, slot: 4 }, { name: 'water', quantity: 1, slot: 2 }] },
          { name: 'soda', recepi : [{ name: 'soda', quantity: 1, slot: 1 }, { name: 'soda', quantity: 1, slot: 2 }] },
        ],
        craftedItem: null
    }),
    mounted() {
      this.$nextTick(() => {
        const that = this;
        window.addEventListener('mousemove', function(e) {
          let clone = document.getElementById('clone');
          clone.style.left = e.pageX + 8 + 'px';
          clone.style.top = e.pageY + 8 + 'px';
        });
        window.addEventListener('mousedown', function(e) {
          e = e || window.event;
          var target = e.target || e.srcElement;
          if (target.className.indexOf('itemImage') !== -1 || target.className.indexOf('v-card__text') !== -1 || target.className.indexOf('v-card__subtitle') !== -1) {
            let slot = target.id.replace('slot', '');
            if (e.which === 1) {
              that.startDrag(slot);
            }
          }
        }, false);
        window.addEventListener('mouseup', function(e) {
          e = e || window.event;
          var target = e.target || e.srcElement;
          that.stopDrag(target);
        }, false);
      });
      if (this.development) {
        this.show = true;
      }
      if (!this.development) {
          this.listener = window.addEventListener('message', e => {
              const item = e.data || e.detail;
              const { event, data } = item;
              if (event) {
                this.$root.$emit(event, data)
                this.$root.$emit('addNuiEventLog', false, event, data);
              }

              if (item.action == "show") {
                this.show = true;
              } else if (item.action == "hide") {
                this.show = false;
              } else if (item.action == "loadItems") {
                this.items = item.items;
              }
          }, false);

          if (Nui.inDev()) {
            this.development = true;
          }
      }
      console.log(`UI Loaded [${this.development ? 'Development Mode' : 'Built'}]`);
    },
    computed: {
      playerModel() {
        if (this.playerSex == 'male') {
          return './assets/maleModel.png';
        } else if (this.playerSex == 'female') {
          return './assets/femaleModel.png';
        }
        return './assets/maleModel.png';
      },
    },
    watch: {
      craft() {
        setTimeout(() => {
          this.animationTimer = !this.animationTimer;
        }, 120);
      }
    },
    methods: {
        debugLog(message) {
            if (this.development) {
                console.log(message);
            }
        },
        getItem(itemName) {
          return this.items.find(item => item.name === itemName);
        },
        getItemBySlot(slot) {
          return this.playerInventory.find(item => item.slot === slot);
        },
        getFreeSlot(slot) {
          if (slot) {
            if (this.playerInventory.find(item => item.slot === slot) === undefined) {
              return true;
            } else {
              return false;
            }
          } else {
            for (let i = 1; i <= this.inventorySlots; i++) {
              if (this.playerInventory.find(item => item.slot === i) === undefined) {
                //this.debugLog(`Free slot found: ${i}`);
                return i;
              }
              if (i == this.inventorySlots) {
                //this.debugLog(`Slot ${i} is not free`);
                return -1;
              }
            }
          }
        },
        addItem(itemName) {
          const item = this.getItem(itemName);
          const freeSlot = this.getFreeSlot();
          if (item && freeSlot != -1) {
            this.playerInventory.push({ name: itemName, quantity: 1, slot: freeSlot });
          } else {
            this.debugLog('No free slot');
          }
        },
        removeItem(slot) {
          const item = this.playerInventory.find(item => item.slot === slot);
          if (item) {
            if (this.splitNumber >= item.quantity) {
              this.playerInventory.splice(this.playerInventory.indexOf(item), 1);
            } else {
              item.quantity -= this.splitNumber;
            }
          }
        },
        checkRecipe(item) {
          this.debugLog(item, item.recepi, this.crafting);
          let correctItems = 0;
          if (item.recepi.length == this.crafting.length) {
            item.recepi.forEach(item => {
              if (this.crafting.find(item2 => item2.name === item.name && item2.quantity === item.quantity && item2.slot === item.slot)) {
                correctItems++;
                this.debugLog('Recipe found', correctItems);
              }
            });
          }
          if (correctItems == item.recepi.length) {
            this.craftedItem = item;
            return true;
          } else {
            return false;
          }
        },
        executeCraft() {
          if (this.craftedItem) {
            /*this.crafting.forEach(item => {
              this.removeItem(item.slot);
            });*/
            this.crafting = [];
            this.addItem(this.craftedItem.name);
            this.craftedItem = null;
          } else {
            this.debugLog('Recipe not found');
          }
        },
        removeItemFromCraft(slot) {
          this.debugLog("removed item from craft in slot " + slot);
          const item = this.crafting.find(item => item.slot === slot);
          if (item) {
            this.crafting.splice(this.crafting.indexOf(item), 1);
          }
        },
        useItem(slot) {
          const item = this.playerInventory.find(item => item.slot === slot);
          const itemData = this.getItem(item.name);
          if (item && itemData.singleuse) {
            this.removeItem(slot);
            fetch(`https://ui-inventory/useInventoryItem`, {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                  name: item.name
                })
            });
          } else {
            fetch(`https://ui-inventory/useInventoryItem`, {
                method: 'POST',
                headers: {
                  'Content-Type': 'application/json; charset=UTF-8',
                },
                body: JSON.stringify({
                  name: item.name
                })
            });
          }
        },
        startDrag(slot) {
          let startSlot = parseInt(slot);
          if (startSlot) {
            this.debugLog('Started dragging slot '+slot);
            this.playerInventory.forEach(item => {
              if (item.slot === startSlot) {
                this.debugLog('Found item '+item.name);
                //this.draggingItem = item;
                if (this.splitNumber <= item.quantity) {
                  this.draggingItem = { name: item.name, quantity: this.splitNumber, slot: item.slot };
                } else {
                  this.draggingItem = { name: item.name, quantity: item.quantity, slot: item.slot };
                }
              }
            });
          } else {
            let craftSlot = parseInt(slot.replace('craft', ''));
            if (typeof craftSlot == 'number') {
              this.debugLog('Started dragging craft slot '+craftSlot);
              this.addItem(this.crafting.find(item => item.slot === craftSlot).name);
              this.removeItemFromCraft(craftSlot);
            }
          }
        },
        stopDrag(target) {
          if (this.draggingItem) {
            if (target.id == 'useBtn') {
              this.debugLog('Used item '+this.draggingItem.name);
              this.useItem(this.draggingItem.slot);
            } else if (target.id == 'dropBtn') {
              this.debugLog('Dropped item '+this.draggingItem.name);
              this.removeItem(this.draggingItem.slot);
            } else if (target.id == 'giveBtn') {
              this.debugLog('Gived item '+this.draggingItem.name);
              this.removeItem(this.draggingItem.slot);
            } else if (target.id == 'craftBtn') {
              this.craft = !this.craft;
            }
            this.debugLog("ID:", target.id);
            if (target.id != 'craftedItem') {
            if (target.className.indexOf('slot') !== -1 || target.className.indexOf('itemImage') !== -1 || target.className.indexOf('v-card__text') !== -1 || target.className.indexOf('v-card__subtitle') !== -1) {
              let slot = target.id.replace('slot', '');
              let placeSlot = parseInt(slot);
              if (placeSlot) {
              this.debugLog(placeSlot, this.getFreeSlot(placeSlot));
              //this.debugLog('Stopped dragging slot '+placeSlot);
              this.playerInventory.forEach(item => {
                if (this.draggingItem.slot == item.slot && item.slot !== placeSlot) {
                  if (this.getFreeSlot(placeSlot)) {
                    this.debugLog('placed item '+item.name);
                    if (this.splitNumber <= item.quantity) {
                      this.playerInventory.push({ name: this.draggingItem.name, quantity: this.splitNumber, slot: placeSlot });
                      item.quantity -= this.splitNumber;
                      if (item.quantity <= 0) {
                        this.removeItem(item.slot);
                      }
                    } else {
                      this.removeItem(item.slot);
                      this.playerInventory.push({ name: this.draggingItem.name, quantity: item.quantity, slot: placeSlot });
                    }
                  } else {
                    this.debugLog('stacked item '+item.name);
                    if (this.draggingItem.name == this.getItemBySlot(placeSlot).name && this.getItem(this.draggingItem.name).stackable) {
                      this.debugLog('success stacked item');
                      if (this.splitNumber <= item.quantity) {
                        this.getItemBySlot(placeSlot).quantity = (parseInt(this.getItemBySlot(placeSlot).quantity) + parseInt(this.splitNumber));
                        item.quantity = (parseInt(item.quantity) - parseInt(this.splitNumber));
                        if (item.quantity <= 0) {
                          this.removeItem(item.slot);
                        }
                      } else {
                        this.getItemBySlot(placeSlot).quantity = (parseInt(this.getItemBySlot(placeSlot).quantity) + parseInt(item.quantity));
                        this.removeItem(item.slot);
                      }
                    }
                  }
                }
              });
            } else {
              let craftSlot = parseInt(slot.replace('craft', ''));
              if (typeof craftSlot == 'number') {
                this.debugLog('Stopped dragging craft slot '+craftSlot);
                this.crafting.push({ name: this.draggingItem.name, quantity: this.draggingItem.quantity, slot: craftSlot });
                this.removeItem(this.draggingItem.slot);
              }
            }
          }
        }
        this.draggingItem = null;
      }
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
  background: #1E1E1E;
  border-radius: 4px;
}

::-webkit-scrollbar-thumb:hover {
  background: rgba(0, 0, 0, 0.4);
}

.v-application {
  background: transparent !important;
  overflow: hidden !important;
}

.fade-enter-active, .fade-leave-active {
  transition: opacity .12s;
}

.fade-enter, .fade-leave-to {
  opacity: 0;
}

.slot {
  min-width: 120px !important;
  min-height: 120px !important;
}

.item {
  display: flex;
  flex-direction: column;
  height: 100%;
  width: 100%;
  cursor: pointer;

  .itemWeight {
    position: absolute;
    left: -7px;
    font-size: 0.8rem;
    font-weight: bold;
    color: gray;
    text-align: center;
    margin-top: -13px;
    z-index: 1;
  }

  .itemQuantity {
    position: absolute;
    right: -7px;
    font-size: 0.8rem;
    font-weight: bold;
    color: #fff;
    text-align: center;
    margin-top: -13px;
    z-index: 1;
  }

  .itemImage {
    position: absolute;
    top: 40%;
    left: 50%;
    transform: translate(-50%, -50%);
    max-width: 90%;
    object-fit: contain;
  }

  .itemName {
    position: absolute;
    bottom: 0;
    left: 50%;
    transform: translate(-50%, 20%);
    font-size: 0.8rem;
    font-weight: bold;
    color: #fff;
    text-align: center;
    z-index: 1;
  }

  .itemMenu {
    position: absolute;
    font-size: 0.8rem;
    font-weight: bold;
    color: #fff;
    text-align: center;
    z-index: 1;
  }
}

#playerInventory {
    display: grid;
    grid-template-columns: repeat(auto-fill, minmax(122px, 1fr));
    grid-template-rows: repeat(auto-fill, minmax(122px, 1fr));
    grid-gap: 0px; // grid-gap: 7px;
    row-gap: 7px;
    position: absolute;
    top: 230px; // top: 25%;
    right: 15px;
    width: 55vw;
    height: 51vh;
    max-height: 473px;
    padding: 17px;
    background-color: rgba(0, 0, 0, 0.4);
    overflow-y: auto;
}

#actions {
  position: absolute;
  top: 720px; // top: 77.8%;
  right: 15px;
  width: 55vw;
  padding: 17px;
  background-color: rgba(0, 0, 0, 0.4);
  overflow: hidden;
}

#player {
  position: absolute;
  top: 230px; // top: 25%;
  left: 15px;
  min-width: 409px;
  max-width: 38vw;
  height: 64vh; //height: 545px;
  max-height: 594px;
  padding: 17px;
  background-color: rgba(0, 0, 0, 0.4);
  overflow: hidden;
}

#secondInventory {
  width: 375px;
  height: 100%;
}

.hotbar {
  position: absolute;
  left: 12px;
  bottom: 12px;
  display: flex;
  flex-direction: row;
  flex-wrap: wrap;
  justify-content: space-between;
  align-items: center;

  .itemPosition {
    position: absolute;
    bottom: 4px;
    left: 4px;
    font-size: 0.7rem;
    font-weight: bold;
    color: white;
    border: 1px solid white;
    border-radius: 4px;
    padding: 0px 6px 0px 6px;
    text-align: center;
    z-index: 1;
  }
}

#craft {
  width: 375px;
  height: 100%;
}

#crafttable {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(100px, 1fr));
  grid-template-rows: repeat(auto-fill, minmax(122px, 1fr));
  grid-gap: 7px;
  row-gap: 7px;
}

.craftedItem {
  position: absolute !important;
  background-color: rgba(0, 0, 0, 0.2) !important;
  left: 35%;
  bottom: 17px;
}

.playerImage {
  margin-left: 30%;
  max-width: 37.5% !important;
  height: auto;
  object-fit: contain;
}

</style>