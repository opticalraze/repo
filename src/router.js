import { createWebHashHistory, createRouter } from 'vue-router'

import HomeView from './views/HomeView.vue'
import FeaturedView from './views/FeaturedView.vue'
import ProfileVIew from './views/ProfileVIew.vue'
import PackageView from './views/PackageView.vue'
import DepictionView from './views/DepictionView.vue'
import NotFoundView from './views/NotFoundView.vue'
import CartView from './views/CartView.vue'

const routes = [
    { path: '/', component: HomeView },
    { path: '/featured', component: FeaturedView },
    { path: '/profile', component: ProfileVIew },
    { path: '/cart', component: CartView },
    { path: '/package/:slug', component: PackageView },
    { path: '/depiction/:slug', component: DepictionView },
    {
        path: '/:catchAll(.*)',
        redirect: '/404'
    },
    {
        path: '/404',
        name: 'not-found',
        component: NotFoundView
    }
]

export const router = createRouter({
    history: createWebHashHistory(import.meta.env.BASE_URL),
    routes,
    
    // Reset scroll to top on navigation
    scrollBehavior(to, from, savedPosition) {
        // Always scroll to top on new navigation
        return { top: 0, left: 0, behavior: 'instant' } // or 'auto'
        
        // Alternative: Restore position when using browser back/forward
        // return savedPosition || { top: 0, left: 0 }
    }
});