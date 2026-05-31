import { createWebHistory, createRouter } from 'vue-router'

import HomeView from './views/HomeView.vue'
import FeaturedView from './views/FeaturedView.vue'
import ProfileVIew from './views/ProfileVIew.vue'

const routes = [
  { path: '/', component: HomeView },
  { path: '/featured', component: FeaturedView },
  { path: '/profile', component: ProfileVIew },
]

export const router = createRouter({
  history: createWebHistory(),
  routes,
})