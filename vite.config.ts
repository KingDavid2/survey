import { defineConfig } from 'vite'
import RubyPlugin from 'vite-plugin-ruby'
import FullReload from "vite-plugin-full-reload";
import VuePlugin from "@vitejs/plugin-vue";
import ReactPlugin from "@vitejs/plugin-react";

export default defineConfig({
  plugins: [
    RubyPlugin(),
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 200 }),
    VuePlugin(),
    ReactPlugin()
  ],
})
