import { createWebHashHistory, createRouter } from 'vue-router'

import HomeView from './views/HomeView.vue'
import FeaturedView from './views/FeaturedView.vue'
import ProfileVIew from './views/ProfileVIew.vue'

const routes = [
    { path: '/', component: HomeView },
    { path: '/featured', component: FeaturedView },
    { path: '/profile', component: ProfileVIew },
]

export const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes,
    
    // Reset scroll to top on navigation
    scrollBehavior(to, from, savedPosition) {
        // Always scroll to top on new navigation
        return { top: 0, left: 0, behavior: 'smooth' } // or 'auto'
        
        // Alternative: Restore position when using browser back/forward
        // return savedPosition || { top: 0, left: 0 }
    }
});