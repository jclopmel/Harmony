import HelloWorld from "./components/HelloWorld.vue";
import Store from "./components/Store.vue";

export default [
    {path: "/", component: Store},
    {path: "/store", component: HelloWorld}
]