<template>
<transition name="fade">
    <div class="menu" v-if="show">
        <div class="menuTitle" v-if="menu.header && menu.header.type === 'text'">
            <h2>{{ menu.header.title }}</h2>
            <h5>{{ menu.header.subtitle }}</h5>
        </div>
        <v-divider></v-divider>
        <div class="elements">
            <!-- /* eslint-disable vue/no-use-v-if-with-v-for */ !-->
            <component class="comp" v-for="(element, index) in menu.data" v-bind:key="index" v-bind:is="element.type" v-bind:data="element.data" v-bind:index="index" @onChange="doChange"></component>
            <!-- /* eslint-enable vue/no-use-v-if-with-v-for */ !-->
        </div>
        <v-divider></v-divider>
        <div class="controls" v-if="menu.controls && menu.controls.type === 'Close'">
            <SimpleButton index="99" :data="{ text: 'Close', color: 'red darken-4' }" @onChange="doClose"/>
        </div>
        <div class="controls" v-if="menu.controls && menu.controls.type === 'Button'">
            <SimpleButton index="99" v-bind:data="menu.controls.data" @onChange="doControlClick"/>
        </div>
        <div class="controls controlsDouble" v-if="menu.controls && menu.controls.type === 'DoubleButton'">
            <DoubleButton v-bind:data="menu.controls.data" index="99" @onChange="doControlClick" />
        </div>
    </div>
</transition>
</template>

<script>
import SimpleButton from './SimpleButton';
import TextField from './TextField';
import NumberField from './NumberField';
import SliderField from './SliderField';
import Picker from './Picker';
import DoubleButton from './DoubleButton';
import Toggler from './Toggler';
import TextDisplay from './TextDisplay';
import MenuSpacer from './MenuSpacer';
import ColorPalette from './ColorPalette';
import Color from './Color';
import Nui from '../../utils/Nui';
export default {
    name: 'Menu',
    components: {
        SimpleButton,
        TextField,
        NumberField,
        SliderField,
        Picker,
        DoubleButton,
        Toggler,
        TextDisplay,
        MenuSpacer,
        ColorPalette,
        Color
    },
    data: () => ({
        show: false,
        menu: {}
    }),
    props: {},
    methods: {
        doChange(menuElement, data) {
            const elementType = this.menu.data[menuElement].type;
            if (elementType === 'SimpleButton') { // Clicky Elements
                Nui.send('menuButtonClick', {
                    element: menuElement,
                    data: {}
                });
            } else if (elementType === 'DoubleButton') { // Clicky Elements
                Nui.send('menuButtonClick', {
                    element: menuElement,
                    data: {
                        buttonNum: data
                    }
                });
            } else { // Value(y) Elements
                Nui.send('menuValueUpdate', {
                    element: menuElement,
                    data: {
                        newValue: this.menu.data[menuElement].data.value
                    }
                });
            }
        },
        doClose() {
            Nui.send('menuStartClose', {});
        },
        doControlClick(_, index) {
            Nui.send('menuControlButton', { index });
        }
    },
    mounted() {
        this.$root.$on('menuSetData', (data) => {
            this.menu = data;
        })

        this.$root.$on('menuUpdateElement', (data) => {
            if (this.menu) {
                const element = data.element - 1;
                if (data.update) {
                    this.menu.data[element].data = data.data.data;
                } else {
                    const copyOfCurrentData = { ...this.menu };
                    copyOfCurrentData.data[element] = false;
                    this.menuSetData(copyOfCurrentData)
                }
            }
        })

        this.$root.$on('menuUpdateHeader', (data) => {
            this.menu.header = data;
        })

        this.$root.$on('menuUpdateControls', (data) => {
            this.menu.controls = data;
        })

        this.$root.$on('menuOpen', () => {
            this.show = true;
        })

        this.$root.$on('menuClose', () => {
            this.show = false;
        })
    }
};

/*

SimpleButton

Properties
loading: boolean
disabled: boolean
color: string
icon: string
text :string


TextField

Properties
value :string
color :string
label :string
readonly :boolean
counter :boolean
hint :string
persistentHint :boolean
icon :string

NumberField

Properties
value :number
color :string
label :string
readonly :boolean
hint :string
persistentHint :boolean
min :number
max: number
step :number
prefix :string



MenuSlider

value :number
color :string
label :string
readonly :boolean
hint :string
persistentHint :boolean
icon :string
thumbColor :string
trackColor :string
sliderLabel :string
thumbLabel :string or :boolean 'always' or true
customThumbLabels :string[]
min :number
max: number
showField :boolean show text field next to 
showTicks :boolean
tickLabels :string[]
step :number


Picker 

value: :string, :string[] when multiple options are selectable
multiple :boolean, see above
label :string
items: string[] see example below
    items: [
        { id: 'option', name: 'An Option' },
        { id: 'option2', name: 'Another Option' }
    ],
hint :string
persistentHint :boolean
readonly :boolean
color :string
loading :boolean

DoubleButton

buttons: array of two objects for each button

Toggler
Switch/Tickbox (both go between true and false)

value :boolean
color :string
label :string
readonly :boolean
type :string switch or checkbox


*/
</script>

<style scoped lang="less">
@import '@/arp-theme.less';
.menu {
    position: fixed;
    width: 500px;
    height: auto;
    top: 4.5vh;
    right: 1.5vw;
    background: @containerbg;
    border-radius: 10px;
    display: flex;
    flex-direction: column;
    .menuTitle {
        width: 90%;
        height: 8vh;
        margin: 1vh 5%;
        h2, h5 {
            text-align: center;
            text-decoration: none;
            white-space: nowrap;
            overflow: hidden;
            text-overflow: ellipsis;
        }
        h2 {
            font-size: 3vh;
        }
        h5 {
            font-size: 1.5vh;
        }
    }
    .elements {
        //background: @red3;
        width: 100%;
        height: 72vh;
        padding: 1vh 1vw 0 1vw;
        border-radius: 10px;
        overflow-y: scroll;
        overflow-x: hidden;
        .comp {
            margin-bottom: 1vh;
        }
        &::-webkit-scrollbar-track {
            background-color: transparent;
        }

        &::-webkit-scrollbar {
            width: 5px;
            background-color: transparent;
        }

        &::-webkit-scrollbar-thumb {
            border-radius: 1.8vh;
            -webkit-box-shadow: inset 0 0 6px rgba(0,0,0,.3);
            background-color: @medium;
        }
    }
    .controls {
        padding: 1vh 1vw;
        width: 100%;
        height: auto;
    }
    //.controlsDouble {
        //height: 10vh;
    //}
}
</style>
