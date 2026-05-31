<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'

const route = useRoute()
const router = useRouter()

const packageData = ref(null)
const loading = ref(true)

// Load single package
async function loadPackage() {
    try {
        const response = await fetch('https://raw.githubusercontent.com/opticalraze/repo/refs/heads/main/packages.json')
        const data = await response.json()
        
        const slug = route.params.slug
        const found = data.packages.find(pkg => 
            pkg.name.toLowerCase().replace(/\s+/g, '-') === slug
        )
        
        if (found) {
            packageData.value = found
        } else {
            // Fallback: try by exact name
            packageData.value = data.packages.find(pkg => pkg.name === route.params.name)
        }
    } catch (error) {
        console.error("Failed to load package:", error)
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    loadPackage()
})

// Back button
function goBack() {
    router.back()
}
</script>

<template>
    <div class="min-h-screen bg-black text-white pb-20">
        <!-- Back Button -->
        <div class="sticky top-21 left-0 right-0 z-40 bg-black/80 backdrop-blur-lg border-b border-white/10">
            <div class="flex items-center px-6 py-4">
                <button @click="goBack" class="flex items-center gap-2 text-white/70 hover:text-white transition">
                    <i class="fa-solid fa-chevron-left"></i>
                    <span>Back</span>
                </button>
            </div>
        </div>

        <div v-if="loading" class="flex justify-center items-center h-96">
            <p class="text-white/50">Loading tweak...</p>
        </div>

        <div v-else-if="packageData" class="pt-16">
            <!-- Hero Image -->
            <div class="relative h-80">
                <img 
                    :src="`https://raw.githubusercontent.com/opticalraze/repo/refs/heads/main/${packageData.icon}`" 
                    class="w-full h-full object-cover brightness-75"
                >
                <div class="absolute inset-0 bg-linear-to-b from-transparent via-black/60 to-black"></div>
                
                <!-- Name Overlay -->
                <div class="absolute bottom-0 left-0 right-0 p-6">
                    <h1 class="text-4xl font-bold tracking-tighter">{{ packageData.name }}</h1>
                    <p class="text-white/70 mt-1">{{ packageData.author || 'Optical Raze' }}</p>
                </div>
            </div>

            <!-- Main Content -->
            <div class="px-6 -mt-6 relative">
                <div class="glass rounded-3xl p-6 mb-8">
                    <div class="flex justify-between items-center">
                        <div>
                            <span class="text-xs bg-white/10 px-3 py-1.5 rounded-full">{{ packageData.version }}</span>
                            <span class="ml-3 text-xs text-white/60">{{ packageData.category }}</span>
                        </div>
                        
                        <button class="bg-white text-black font-semibold px-8 py-3 rounded-2xl active:scale-95 transition">
                            {{ packageData.price === "Free" ? "Install" : packageData.price }}
                        </button>
                    </div>
                </div>

                <!-- Description -->
                <div class="mb-10">
                    <h3 class="text-xl font-semibold mb-4">Description</h3>
                    <p class="text-white/80 leading-relaxed">
                        {{ packageData.longDescription || packageData.description }}
                    </p>
                </div>

                <!-- Screenshots -->
                <div v-if="packageData.screenshots && packageData.screenshots.length" class="mb-10">
                    <h3 class="text-xl font-semibold mb-4">Screenshots</h3>
                    <div class="flex gap-4 overflow-x-auto pb-4 scrollbar-hide">
                        <img 
                            v-for="(screenshot, i) in packageData.screenshots"
                            :key="i"
                            :src="`https://raw.githubusercontent.com/opticalraze/repo/refs/heads/main/${screenshot}`"
                            class="rounded-3xl max-h-96 object-contain border border-white/10"
                        >
                    </div>
                </div>

                <!-- What's New -->
                <div v-if="packageData.changelog" class="mb-10">
                    <h3 class="text-xl font-semibold mb-4">What's New</h3>
                    <div class="glass rounded-3xl p-6 text-sm text-white/80">
                        <pre class="whitespace-pre-wrap">{{ packageData.changelog }}</pre>
                    </div>
                </div>

                <!-- Info -->
                <div class="glass rounded-3xl p-6 text-sm">
                    <div class="grid grid-cols-2 gap-y-6">
                        <div>
                            <p class="text-white/50 text-xs">Version</p>
                            <p>{{ packageData.version }}</p>
                        </div>
                        <div>
                            <p class="text-white/50 text-xs">Category</p>
                            <p>{{ packageData.category }}</p>
                        </div>
                        <div>
                            <p class="text-white/50 text-xs">Price</p>
                            <p>{{ packageData.price }}</p>
                        </div>
                        <div>
                            <p class="text-white/50 text-xs">Compatibility</p>
                            <p>iOS 14.0+</p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.glass {
    background: rgba(255, 255, 255, 0.06);
    backdrop-filter: blur(20px);
    border: 1px solid rgba(255, 255, 255, 0.1);
}
</style>