<script setup>
import { ref, onMounted, watch } from 'vue'
import FeaturedCard from '../components/FeaturedCard.vue'
import ListCard from '../components/ListCard.vue'

// Reactive state
const allPackages = ref([])
const filteredPackages = ref([])
const featuredPackages = ref([])

// Load packages
async function loadPackages() {
    try {
        const response = await fetch('/packages.json')
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
    
    <!-- Welcome Header -->
    <div class="mb-10 px-6">
        <h2 class="text-4xl font-bold tracking-tighter mb-1">Welcome</h2>
        <p class="text-white/60">Discover Jailbreak Tweaks & Themes</p>
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
            <RouterLink to="/featured" class="text-red-400 text-sm font-medium">See all →</RouterLink>
        </div>
        <div id="featured-list" class="flex gap-4 overflow-scroll w-full mb-10 pt-4 scrollbar-hide px-6">
            <FeaturedCard 
            v-for="(pkg, i) in featuredPackages"
            :key="i"
            :pkg="pkg"
            />
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
                
                <ListCard v-for="(pkg, i) in filteredPackages" :key="i" :pkg="pkg" />
                
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
</template>