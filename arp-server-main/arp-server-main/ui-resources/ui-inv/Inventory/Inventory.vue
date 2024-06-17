<template>
<div>
    <transition name ="slide">
    <div class="itemAddNotification" v-if="itemNotif">
        <InventoryItem :item="itemNotif" :itemData="itemData"></InventoryItem>
        <div class="slot-count"> {{ itemNotif.count }}</div>

    </div>
    </transition>
    <transition name="fade">
        <div class="inventoryContainer" v-if="show">  
        <InventoryItem class="ghost-item" v-if="heldItem" :item="heldItem" :itemData="itemData" :style="ghostStyle" :ghost="true"></InventoryItem>

        <div class="inventories">
            <div v-if="localInventory" class="inventory">
                <div class="items-container">
                    <div class="items">
                        <div class="item-slot" 
                            :class="{'bind-slot': slot <= 6 }" 
                            v-for='slot in localInventory.maxSlots' 
                            v-bind:key="slot"
                            draggable 
                            @mouseenter="hover(localInventory.items[slot])" 
                            @mouseleave="unhover"
                            @dragstart.prevent='setHeld(slot, false)'
                            @contextmenu.prevent
                            @click="itemShiftClick(slot)"
                            @mouseup.left.prevent.stop='release($event, slot, false)'
                            @mouseup.right.prevent.stop='viewItemInfo(localInventory.items[slot], slot, false)'
                        >
                            <InventoryItem v-if='localInventory.items[slot]' :item='localInventory.items[slot]' :itemData="itemData"></InventoryItem>
                            <div class="slot-count" v-if='localInventory.items[slot] && itemData[localInventory.items[slot].item].max > 1'>{{localInventory.items[slot].count}}/{{itemData[localInventory.items[slot].item].max}}</div>
                            <div class="slot-bind" v-if="slot <= 6">{{ slot }}</div>
                            <Busy :busy='isBusy(slot, false)'></busy>
                        </div>
                    </div>
                </div>
                <div class="heading">
                    {{ localInventory.type }} {{ localInventory.identifier }}
                    <span>{{localInventory.currentWeight}}/{{ localInventory.maxWeight }} KG  | {{ localInventory.maxSlots }} Slots</span>
                </div> 
                <div class="useArea" @mouseup='useDrop'>
                    <div class="heading">
                        Use Item
                    </div>
                    <div class="useQuantity">
                        <input type="number" min="0" max="100" v-model="moveAmount">
                    </div>
                </div>
            </div>

            <div v-if="remoteInventory" class="inventory">
                <div class="items-container">
                    <div class="items">
                        <div class="item-slot" 
                            v-for='slot in remoteInventory.maxSlots' 
                            v-bind:key="slot"
                            draggable 
                            @mouseenter="hover(remoteInventory.items[slot])" 
                            @mouseleave="unhover"
                            @dragstart.prevent='setHeld(slot, true)'
                            @contextmenu.prevent

                            @mouseup.left.prevent.stop='release($event, slot, true)'
                            @mouseup.right.prevent.stop='viewItemInfo(remoteInventory.items[slot], slot, true)'
                        >
                            <InventoryItem v-if='remoteInventory.items[slot]' :item='remoteInventory.items[slot]' :itemData="itemData"></InventoryItem>
                            <div class="slot-count" v-if='remoteInventory.items[slot] && itemData[remoteInventory.items[slot].item].max > 1'>{{remoteInventory.items[slot].count}}/{{itemData[remoteInventory.items[slot].item].max}}</div>

                            <busy :busy='isBusy(slot, true)'></busy>
                        </div>
                    </div>
                </div>
                <div class="heading">
                    {{ remoteInventory.type }} {{ remoteInventory.identifier }}
                    <span>{{remoteInventory.currentWeight}}/{{ remoteInventory.maxWeight }} KG  | {{ remoteInventory.maxSlots }} Slots</span>
                </div> 
            </div>

        </div>

        <v-dialog v-model="viewingItemInfo" max-width="290"> 
            <v-card v-if="viewingItemInfoData && viewingItemInfoData.itemData && viewingItemInfoData.item">
               <v-card-title>
                    <span>{{ viewingItemInfoData.remote ? 'Remote' : 'Local'}} Item Slot {{ viewingItemInfoData.slot + 1 }}</span>
                    <v-spacer></v-spacer>
                    <v-btn icon @click="viewingItemInfo = false">
                        <v-icon>mdi-close</v-icon>
                    </v-btn>
               </v-card-title>
                <InventoryItem style="margin: 0 auto; user-select: none;" v-if='viewingItemInfoData.item' :item='viewingItemInfoData.item' :itemData="data.itemData" :avoidHealth="true"></InventoryItem>
                <v-card-text class="text-center">
                    {{ viewingItemInfoData.itemData.description }}
                    <br><br>
                    <div v-if="viewingItemInfoData.item.meta && viewingItemInfoData.item.meta.health">
                        <b>Health</b>: {{ viewingItemInfoData.item.meta.health }}%
                    </div>
                    <div v-if="viewingItemInfoData.item.meta && viewingItemInfoData.itemData.metaToDisplay && viewingItemInfoData.itemData.metaToDisplay.length >= 1">
                        <u><b>Item Metadata:</b></u>
                        <!-- eslint-disable vue/no-use-v-if-with-v-for !-->
                        <div v-for="(mData, mIndex) in viewingItemInfoData.item.meta" v-bind:key="mIndex" v-if="viewingItemInfoData.itemData.metaToDisplay.includes(mIndex)">
                            <b>{{ mIndex }}</b>: {{ mData }}
                        </div>
                    </div>
                </v-card-text>

                <v-card-actions>
                <v-spacer></v-spacer>

                <v-btn v-if="!viewingItemInfoData.remote" text @click="useItem(viewingItemInfoData.slot)">
                    Use
                </v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
    </transition>
</div>
</template>



<script>
import Nui from '../../utils/Nui';
import Busy from './Busy';
import InventoryItem from './InvItem';

export default {
    name: 'Inventory',
    components: {
        InventoryItem,
        Busy
    },
    props: {},
    data: () =>  ({
        show: false,
        localInventory: false,
        remoteInventory: false,
        itemData: {},
        itemNotif: false,
        itemNotifTimer: false,
        itemNotifInterval: false,

        heldItem: null,
        heldFromRemote: false,
        viewingItemInfo: false,
        viewingItemInfoData: {},
        heldFromSlot: 1,
        busyCharSlots: {},
        busyRemoteSlots: {},
        mouseX: 0,
        mouseY: 0,
        moveAmount: 1,
        hoveredItem: null,
        hoveredInfo: null,
        holdingShift: false,
    }),
    destroyed() {
        window.removeEventListener('message', this.listener);
    },
    computed: {
        ghostStyle() {
            return `left: ${this.mouseX - 50}px; top: ${this.mouseY - 50}px;`
        },
    },
    filters: {
        title(str) {
            return str.toLowerCase().split(' ').map((word) => {
                if (word === 'of') return word
                return (word.charAt(0).toUpperCase() + word.slice(1))
            }).join(' ')
        }
    },
    methods: {
        async close() {
            await Nui.send('closeInventory', {});
        },
        finishClose() {
            this.show = false
            this.clearBusies();
            this.heldItem = null;

            this.holdingShift = false;
        },
        hover(item) {
            if (!item) return
            this.hoveredItem = item;
            this.hoveredInfo = this.itemData[item.item];
        },
        clearBusies(rem, char) {
            if (rem) {
                this.busyRemoteSlots = {};
            }
            if (char) {
                this.busyCharSlots = {};
            }
        },
        unhover() {
            this.hoveredItem = null
            this.hoveredInfo = null
        },
        viewItemInfo(item, slot, remote) {
            if (item && item.item) { // Does the slot have an item in it
                console.log(this.viewingItemInfo)
                console.log('shift clicked?');
                const itemData = this.itemData[item.item];
                this.viewingItemInfo = true
                this.viewingItemInfoData = {
                    item,
                    slot, 
                    remote,
                    itemData
                }
            } 
        },
        itemShiftClick(slot) { // Move all of stack to remote inventory
            console.log(this.holdingShift)
            if (!this.holdingShift) {
                return;
            }
            this.useItem(slot)
        },
        useItem(slot) {
            this.viewingItemInfo = false;
            console.log('useSlot', slot)
            if (typeof(slot) !== 'number') return
            if (this.busyCharSlots[slot]) return
            const item = this.localInventory.items[slot];
            if (!item) return   
            //const itemInfo = this.itemData[item.item];
            //if (!itemInfo) return

            this.$set(this.busyCharSlots, slot, true)
            console.log('use item', item, slot);

            Nui.send('inventoryUseItem', slot);
        },
        useDrop(/*e*/) {
            if (this.heldFromRemote) return
            if (this.heldItem) {
                this.useItem(this.heldFromSlot)
                this.heldItem = null
            }
        },
        cancelUse(data) {
            if (!data.slot) return
            this.$delete(this.busyCharSlots, data.slot)
        },
        updateCharacterInventory(data) {
            this.heldItem = false;
            this.unhover();
            if (data.inventory) {
                this.charInv = data.inventory;
            }
        },
        updateRemoteInventory(data) {
            this.unhover();
            this.heldItem = false;
            this.remoteInv = data.inventory;
        },
        setHeld(slot, remote) {
            if (this.isBusy(slot, remote)) return
            if (remote) {
                this.heldItem = this.remoteInventory.items[slot]
            } else {
                this.heldItem = this.localInventory.items[slot]
            }
            
            this.heldFromRemote = remote;
            this.heldFromSlot = slot;
        },
        getMoveAmount(fromItem, toItem) {
            let amount = parseInt(this.moveAmount);
            let max = 1;
            //const fromItemMax = this.itemData[fromItem.item].max || 0;
            if (toItem)  { // If moving on top of another item
                const toItemMax = this.itemData[toItem.item].max || 1;
                max = toItemMax - toItem.count;
                if (max < 0) return 0;

                if (max > fromItem.count) {
                    max = fromItem.count;
                }
                return max;
            } else {
                max = fromItem.count;
            }

            console.log('mmxa', max, amount)

            if (amount > max) {
                amount = max;
            }

            if (amount <= 0) {
                amount = fromItem.count
            }
            console.log(amount)
            return amount
        },
        predictTransaction(fromInv, fromSlot, toInv, toSlot, moveAmount) {
            const fromItem = fromInv.items[fromSlot];
            const toItem = toInv.items[toSlot];
            //console.log('toItem', toItem.count);
            if (toItem) {
                // occupied slot
                if (toItem.item === fromItem.item) {
                    console.log('here geerer', this.itemData[toItem.item].max)
                    if (toItem.count + moveAmount > this.itemData[toItem.item].max) {
                        console.log('no predict end')
                        return false;
                    }
                    console.log('still predicting')

                    fromItem.count = fromItem.count - moveAmount;
                    toItem.count = toItem.count + moveAmount;
                    console.log(fromItem.count);
                    console.log(toItem.count);
                    this.$set(toInv.items, toSlot, {
                        item: toItem.item,
                        count: moveAmount
                    });
                    console.log('set yo')

                    if (fromItem.count === 0) {
                        console.log('del from')
                        this.$delete(fromInv.items, fromSlot);
                    } else {
                        this.$set(fromInv.items, fromSlot, {
                            item: fromItem.item,
                            count: fromItem.count
                        });
                    }
                }
            } else {
                // move to empty
                if (moveAmount === fromItem.count) {
                    // whole thing
                    console.log('whole thing', toSlot);
                    this.$delete(fromInv.items, fromSlot);
                    this.$set(toInv.items, toSlot, fromItem);
                } else {
                    // partial
                    fromItem.count -= moveAmount;

                    this.$set(toInv.items, toSlot, {
                        item: fromItem.item,
                        count: moveAmount
                    });
                }
            }
            return true;
        },
        async release(e, slot, remote) {
            if (!this.heldItem) return;
            if (this.heldFromSlot === slot && this.heldFromRemote === remote) return this.heldItem = null;
            if (this.isBusy(slot, remote)) return;
            const fromBusy = this.heldFromRemote ? this.busyRemoteSlots : this.busyCharSlots;
            const toBusy = remote ? this.busyRemoteSlots : this.busyCharSlots;
            const fromInv = this.heldFromRemote ? this.remoteInventory : this.localInventory;
            const toInv = remote ? this.remoteInventory : this.localInventory;
            const fromItem = fromInv.items[this.heldFromSlot];
            const toItem = toInv.items[slot];
            const fromItemData = this.itemData[fromItem.item];

            let amount = this.getMoveAmount(fromItem, toItem);
            if (amount <= 0) return this.heldItem = null;
            const fromCharacter = this.heldFromRemote;
            const targetInv = remote;

            const weightOfMovement = amount * fromItemData.weight;
            if (fromCharacter !== targetInv && (toInv.currentWeight + weightOfMovement) > toInv.maxWeight) {
                return this.heldItem = null;
            }
            // predict the transaction
            if (!this.predictTransaction(fromInv, this.heldFromSlot, toInv, slot, amount)) return this.heldItem = null;

            // mark that the slots are busy
            this.$set(fromBusy, this.heldFromSlot, true);
            this.$set(toBusy, slot, true);

            const fromSlot = this.heldFromSlot;
            const targetSlot = slot;
            const veryNiceMove = parseInt(this.moveAmount);

            console.log(fromCharacter, fromSlot, targetInv, targetSlot);

            setTimeout(() => {
                this.$delete(fromBusy, this.heldFromSlot);
                this.$delete(toBusy, slot);
            }, 5000);

            this.heldItem = null;

            await Nui.send('inventoryMoveItems', {
                from: fromCharacter,
                fromSlot: fromSlot,
                target: targetInv,
                targetSlot: targetSlot,
                moveAmount: veryNiceMove
            });
        },
        isBusy(slot, remote) {
            const busyList = remote ? this.busyRemoteSlots : this.busyCharSlots
            return !!busyList[slot]
        },
    },
    async mounted() {
        window.addEventListener('mousemove', (e) => {
            this.mouseX = e.clientX;
            this.mouseY = e.clientY;
        });

        window.addEventListener('keydown', (e) => {
            const {key} = e
            if (key === 'F2' || key === 'Escape') {
                if (this.show) {
                    console.log('plz close')
                    this.close();
                    return;
                }
            } else if (key === 'Shift') {
                this.holdingShift = true;
            }
        });

        window.addEventListener('keyup', (e) => {
            const {key} = e;

            if (key === 'Shift') this.holdingShift = false;
        });

        this.$root.$on('inventoryFinishClose', () => {
            this.finishClose();
        });

        this.$root.$on('inventoryClearBusies', (rem, local) => {
            this.clearBusies(rem, local);
        });

        this.$root.$on('inventoryOpen', async (data) => {
            this.localInventory = data.localInventory;
            this.remoteInventory = data.remoteInventory;
            this.clearBusies(true, true);
            await Nui.doDelay(200);
            this.show = true;
            //this.inventoryClose()
        })

        this.$root.$on('inventoryClose', () => {
            this.finishClose();
        })

        this.$root.$on('inventorySetItemData', (data) => {
            this.itemData = data;
        })


        this.$root.$on('inventoryUpdateLocal', (data) => {
            this.localInventory = data;
            this.clearBusies(false, true);
        })

        this.$root.$on('inventoryUpdateRemote', (data) => {
            this.remoteInventory = data;
            this.clearBusies(true, false);
        })

        this.$root.$on('inventoryItemNotif', (item) => {
            if (item.item) {
                this.itemNotif = item
                this.itemNotifTimer = Date.now() + 3000;
                if (!this.itemNotifInterval) {
                    this.itemNotifInterval = setInterval(() => {
                        if (this.itemNotif && Date.now() >= this.itemNotifTimer) {
                            this.itemNotif = false;
                        }
                    }, 800);
                }
            }
        })

        this.$root.$on('inventoryItemNotifClear', () => {
            this.itemNotifTimer = Date.now()
        })
    },
};
</script>

<style lang="less">
@import '@/inventory.less';
</style>
