import { App } from "vue";
import Icon from "./ItIcon.vue";

Icon.install = (Vue: App) => {
  Vue.component(Icon.icon, Icon);
};

export default Icon;
