import { createApp } from "vue";
import Rating from "../components/Rating.vue";
import App from "../components/App.vue";

// Vuetify
import "@mdi/font/css/materialdesignicons.css"; // Ensure you are using css-loader
import "vuetify/styles";
import { createVuetify } from "vuetify";
import * as components from "vuetify/components";
import * as directives from "vuetify/directives";

const vuetify = createVuetify({
  components,
  directives,
});

createApp(Rating).use(vuetify).mount("#app");
