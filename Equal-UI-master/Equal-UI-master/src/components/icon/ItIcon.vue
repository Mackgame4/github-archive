<template>
  <i
    :class="[box ? `mdi it-icon--box mdi-${icon}` : `mdi it-icon mdi-${icon}`]"
    :style="{ color, 'background-color': box && boxColor ? boxColor : '' }"
  >
    <!--slot>{{ icon ? icon : '' }}</slot-->
  </i>
</template>

<script lang="ts">
import { defineComponent } from "vue";

export default defineComponent({
  name: "it-icon",
  props: {
    icon: { type: String, required: true },
    color: { type: String, default: null },
    box: { type: Boolean, default: false },
    boxColor: { type: String, default: null },
  },
});
</script>
