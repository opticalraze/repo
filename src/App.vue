<script setup>
import { ref, onMounted, watch } from 'vue'

// Reactive state
const allPackages = ref([])
const filteredPackages = ref([])

// Load packages
async function loadPackages() {
    try {
        const response = await fetch('packages.json')
        const data = await response.json()
        
        allPackages.value = data.packages
        filteredPackages.value = [...data.packages] // Start with all packages
        
        // Render first 2 as featured
        renderFeatured(allPackages.value.slice(0, 2))
    } catch (error) {
        console.error("Failed to load packages:", error)
    }
}

function renderFeatured(packages) {
    // This can be handled directly in the template with v-for
    // But if you want to keep it as a separate reactive list:
    featuredPackages.value = packages
}

// Search functionality
const searchTerm = ref('')

function filterPackages() {
    const term = searchTerm.value.toLowerCase().trim()
    
    if (!term) {
        filteredPackages.value = [...allPackages.value]
    } else {
        filteredPackages.value = allPackages.value.filter(pkg =>
        pkg.name.toLowerCase().includes(term) ||
        pkg.description.toLowerCase().includes(term)
        )
    }
}

// Watch search term
watch(searchTerm, filterPackages)

// Load on mount
onMounted(() => {
    loadPackages()
})
</script>

<template>
    <!-- Navigation Bar -->
    <div class="sticky top-0 z-50 glass border-b border-white/10">
        <div class="max-w-xl mx-auto py-4 flex items-center justify-between px-6">
            <div class="flex items-center gap-12 w-full">
                <img src="/favicon.svg" alt="Logo" class="w-12 h-12">
                
            </div>
            <div class="w-full flex items-center">
                <div class="text-right">
                    <h1 class="text-2xl font-semibold tracking-tight text-nowrap">Optical Raze</h1>
                    <p class="text-xs text-white/60 -mt-1 text-nowrap">Jailbreak Repo</p>
                </div>
            </div>
            <div class="flex items-center gap-4 justify-end text-xl w-full">
                <button class="p-2">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </button>
                <button class="p-2">
                    <i class="fa-solid fa-ellipsis-vertical"></i>
                </button>
            </div>
        </div>
    </div>
    
    <div class="max-w-xl mx-auto pt-8 pb-20 min-h-screen bg-white/5 border-x border-white/10">
        
        <!-- Welcome Header -->
        <div class="mb-10 px-6">
            <h2 class="text-4xl font-bold tracking-tighter mb-1">Welcome</h2>
            <p class="text-white/60">Discover premium jailbreak tweaks & themes</p>
        </div>
        
        <!-- Search Bar -->
        <div class="relative mb-10 px-6">
            <div class="absolute inset-y-0 left-0 pl-11 flex items-center pointer-events-none">
                <i class="fa-solid fa-magnifying-glass text-white/50"></i>
            </div>
            <input v-model="searchTerm" type="text" id="search" 
            class="w-full bg-white/10 border border-white/20 rounded-3xl py-4 pl-12 pr-6 text-base focus:outline-none focus:border-purple-500 transition-colors"
            placeholder="Search tweaks, themes...">
        </div>
        
        <!-- Featured -->
        <div class="mb-10">
            <div class="flex justify-between items-center mb-4 px-6">
                <h3 class="text-xl font-semibold">Featured</h3>
                <a href="#" class="text-purple-400 text-sm font-medium">See all →</a>
            </div>
            <div id="featured-list" class="flex gap-4 overflow-scroll w-full mb-10 scrollbar-hide px-6">
                <!-- Populated by JS -->
                <div
                v-for="pkg in allPackages.slice(0, 2)"
                :key="pkg.name"
                class="ios-card glass rounded-3xl overflow-hidden border border-white/10 shrink-0 w-64"
                >
                <img :src="pkg.icon" class="w-full h-36 overflow-hidden object-cover" />
                <div class="p-4">
                    <h4 class="font-semibold">{{ pkg.name }}</h4>
                    <p class="text-sm text-white/60">{{ pkg.description }}</p>
                    <div class="flex justify-between items-center mt-4">
                        <span class="text-xs bg-white/10 px-3 py-1 rounded-full">{{ pkg.version }}</span>
                        <button class="bg-white text-black text-sm font-medium px-6 py-2 rounded-2xl active:scale-95 transition">
                            {{ pkg.price === "Free" ? "Get" : pkg.price }}
                        </button>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Categories -->
        <div class="mb-10">
            <h3 class="text-xl font-semibold mb-4 px-8">Categories</h3>
            <div class="relative">
                <div class="flex gap-3 overflow-x-auto pb-4 scrollbar-hide px-6">
                    <div class="glass px-6 py-3 rounded-3xl whitespace-nowrap border border-white/10">All Tweaks</div>
                    <div class="glass px-6 py-3 rounded-3xl whitespace-nowrap border border-white/10">Themes</div>
                    <div class="glass px-6 py-3 rounded-3xl whitespace-nowrap border border-white/10">Status Bar</div>
                    <div class="glass px-6 py-3 rounded-3xl whitespace-nowrap border border-white/10">Lockscreen</div>
                    <div class="glass px-6 py-3 rounded-3xl whitespace-nowrap border border-white/10">Utilities</div>
                </div>
                <div v-if="false" class="absolute z-20 w-6 h-full top-0 left-0 bg-linear-to-r from-black to-transparent pointer-events-none"></div>
                <div v-if="false" class="absolute z-20 w-6 h-full top-0 right-0 bg-to-left bg-linear-to-l from-black to-transparent pointer-events-none"></div>
            </div>
        </div>
        
        <!-- All Packages -->
        <div class="px-6">
            <h3 class="text-xl font-semibold mb-4">All Packages</h3>
            <div id="packages-list" class="space-y-4">
                <!-- Populated dynamically -->
                <div
                v-for="pkg in filteredPackages"
                :key="pkg.name"
                class="flex items-center gap-4 glass rounded-3xl p-4 ios-card"
                >
                <img :src="pkg.icon" class="w-14 h-14 rounded-2xl object-cover flex-shrink-0" />
                <div class="flex-1 min-w-0">
                    <h4 class="font-medium">{{ pkg.name }}</h4>
                    <p class="text-sm text-white/60 line-clamp-1">{{ pkg.description }}</p>
                    <p class="text-xs text-white/40 mt-1">{{ pkg.version }} • {{ pkg.category }}</p>
                </div>
                <button class="bg-white text-black text-sm font-medium px-6 py-2 rounded-2xl active:scale-95 transition">
                    {{ pkg.price === "Free" ? "Get" : pkg.price }}
                </button>
            </div>
            
            <!-- Empty state -->
            <p
            v-if="filteredPackages.length === 0"
            class="text-white/60 text-center py-12"
            >
            No packages found.
        </p>
    </div>
</div>
</div>
</div>

<!-- Bottom Navigation -->
<div class="fixed bottom-0 left-0 right-0 glass border-t border-white/10">
    <div class="max-w-xl mx-auto flex justify-around py-3 text-xs">
        <a href="#" class="flex flex-col items-center text-purple-400">
            <i class="fa-solid fa-house text-2xl mb-1"></i>
            <span>Repo</span>
        </a>
        <a href="#" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-star text-2xl mb-1"></i>
            <span>Featured</span>
        </a>
        <a href="#" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-magnifying-glass text-2xl mb-1"></i>
            <span>Search</span>
        </a>
        <a href="#" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-user text-2xl mb-1"></i>
            <span>Me</span>
        </a>
    </div>
</div>
</template>
