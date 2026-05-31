<script setup>

</script>

<template>
    <!-- Navigation Bar -->
    <div class="sticky top-0 z-50 glass border-b border-white/10">
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
                <div>
                    <button class="px-3 py-1 border border-white/20 hover:bg-white/5 transition duration-300 text-white rounded-lg text-nowrap">Login</button>
                </div>
            </div>
        </div>
    </div>
    
    <div class="max-w-xl mx-auto pt-8 pb-20 min-h-screen bg-white/5 border-x border-white/10">
        <RouterView />    
    </div>

<!-- Bottom Navigation -->
<div class="fixed bottom-0 left-0 right-0 glass border-t border-white/10">
    <div class="max-w-xl mx-auto flex justify-around py-3 text-xs">
        <RouterLink to="/" class="flex flex-col items-center text-purple-400">
            <i class="fa-solid fa-house text-2xl mb-1"></i>
            <span>Repo</span>
        </RouterLink>
        <RouterLink to="/featured" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-star text-2xl mb-1"></i>
            <span>Featured</span>
        </RouterLink>
        <RouterLink to="/" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-magnifying-glass text-2xl mb-1"></i>
            <span>Search</span>
        </RouterLink>
        <RouterLink to="/profile" class="flex flex-col items-center text-white/60">
            <i class="fa-solid fa-user text-2xl mb-1"></i>
            <span>Me</span>
        </RouterLink>
    </div>
</div>
</template>
