<script setup>
import AppIcon from './AppIcon.vue';

defineProps({
    pkg: Object,
});
</script>

<template>
    <!-- Populated dynamically -->
    <RouterLink :to="`/tweak/${pkg.bundle_id.toLowerCase().replace(/\s+/g, '-')}`"
        class="flex items-center gap-4 glass rounded-3xl p-4 ios-card border border-white/10"
    >
        <AppIcon :src="`${pkg.icon}`" class="w-14 h-14" />
        <div class="flex-1 min-w-0">
            <h4 class="font-medium">{{ pkg.name }}</h4>
            <p class="text-sm text-white/60 line-clamp-1">{{ pkg.description }}</p>
            <p class="text-xs text-white/40 mt-1">{{ pkg.version }} • {{ pkg.category }}</p>
        </div>
        <button class="bg-white text-black text-sm font-medium px-6 py-2 rounded-2xl active:scale-95 transition">
            {{ pkg.price === "Free" ? "Get" : pkg.price }}
        </button>
    </RouterLink>
</template>