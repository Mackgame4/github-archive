<template>
    <!--div v-if="item" class="item" :class="{'account-bound': bound, focus}"!-->
    <div v-if="item" class="item">
        <div class="item-life" v-if="!avoidHealth && !ghost && item.meta && item.meta.health" :style="lifeColor"></div>
        <div class="item-label" v-if="!ghost">
            <div class="item-label-text">{{ name }}</div>
        </div>
        <img class="item-image" :src="image" />
    </div>
</template>

<script>
export default {
    name: 'InventoryItem',
    props: ['item', 'ghost', 'focus', 'itemData', 'avoidHealth' ],
    data () {
        return {
            show: false,
            lock: false,
            timeout: null
        }
    },
    methods: {

    },
    computed: {
        name () {
            if (this.itemData[this.item.item] && this.itemData[this.item.item].name) {
                return this.itemData[this.item.item].name
            } else {
                return `Unknown`
            }
        },
        image () {
            if (this.itemData[this.item.item] && this.itemData[this.item.item].image) {
                return `assets/inventory/items/${this.itemData[this.item.item].image}`
            } else {
                return `assets/inventory/items/unknown.png`
            }
        },
        lifeColor () {
            const h = this.item.meta.health;
            let w = this.item.meta.health;
            if (w < 5) {
                w = 5;
            }
            return `background: hsl(${h}, 67%, 50%); width: ${w}%;`;
        }
    }
};
</script>

<style scoped>
    
</style>