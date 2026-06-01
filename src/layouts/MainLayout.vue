<script setup>
import { useRoute, useRouter } from 'vue-router';
import BaseButton from '../components/BaseButton.vue';
import BaseButtonLink from '../components/BaseButtonLink.vue';

const route = useRoute()
const router = useRouter()

// Back button
function goBack() {
    router.back()
}
</script>

<template>
    <!-- Navigation Bar -->
    <div class="sticky top-0 z-40 glass border-b border-white/10">
        <div class="max-w-xl mx-auto py-4 flex items-center justify-between px-6">
            <div class="flex items-center gap-3 w-full">
                <div class="text-right">
                    <h1 class="text-2xl font-medium tracking-tight text-nowrap">Optical Raze</h1>
                    <p class="text-xs text-white/60 -mt-1 text-nowrap">Jailbreak Repo</p>
                </div>
            </div>
            <div v-if="false" class="w-full flex items-center">
                <img src="/favicon.svg" alt="Logo" class="w-12 h-12">
            </div>
            <div v-if="false" class="flex items-center gap-4 justify-end text-xl w-full">
                <button class="p-2">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
                <button class="p-2">
                    <i class="fa-solid fa-ellipsis-vertical"></i>
                </button>
            </div>
            <div>
                <div v-if="false">
                    <BaseButton class="px-3 py-1 bg-white/0! border border-white/20! hover:bg-white/5! transition duration-300 text-white!">Login</BaseButton>
                </div>
                <div v-else>
                    <BaseButton v-if="$route.path==='/cart'" @click="goBack()" class="relative flex items-center gap-3 py-2 border border-white/20 hover:bg-white/5! transition duration-300 bg-white/20 text-white">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <p class="">Cart</p>
                        <p class="absolute top-0 right-0 translate-x-2.5 -translate-y-2.5 text-xs font-light text-white rounded-full w-5 h-5 flex items-center justify-center bg-red-500 shadow-xl">2</p>
                    </BaseButton>
                    <BaseButtonLink v-else to="/cart" class="relative flex items-center gap-3 py-2 bg-white/0 border border-white/20 hover:bg-white/20! transition duration-300 text-white">
                        <i class="fa-solid fa-cart-shopping"></i>
                        <p class="">Cart</p>
                        <p class="absolute top-0 right-0 translate-x-2.5 -translate-y-2.5 text-xs font-light text-white rounded-full w-5 h-5 flex items-center justify-center bg-red-500 shadow-xl">2</p>
                    </BaseButtonLink>
                </div>
            </div>
        </div>
    </div>
    
    <div class="max-w-xl mx-auto pt-8 pb-20 min-h-screen bg-white/5 border-x border-white/10">
        <slot />  
    </div>

<!-- Bottom Navigation -->
<div class="fixed z-40 bottom-0 left-0 right-0 glass border-t border-white/10">
    <div class="max-w-xl mx-auto flex justify-around py-3 text-xs">
        <RouterLink to="/" class="flex flex-col items-center text-white/60" :class="{'text-[#00b4ff]!': $route.path === '/'}">
            <i class="fa-solid fa-house text-2xl mb-1"></i>
            <span>Repo</span>
        </RouterLink>
        <RouterLink to="/featured" class="flex flex-col items-center text-white/60" :class="{'text-[#00b4ff]!': $route.path === '/featured'}">
            <i class="fa-solid fa-star text-2xl mb-1"></i>
            <span>Featured</span>
        </RouterLink>
        <RouterLink to="/" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-magnifying-glass text-2xl mb-1"></i>
            <span>Search</span>
        </RouterLink>
        <RouterLink to="/profile" class="flex flex-col items-center text-white/60" :class="{'text-[#00b4ff]!': $route.path === '/profile'}">
            <i class="fa-solid fa-user text-2xl mb-1"></i>
            <span>Profile</span>
        </RouterLink>
    </div>
</div>
</template>
