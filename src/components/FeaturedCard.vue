<script setup>
import { usePackageImage } from '../composables/usePackageImage'

const props = defineProps({
    pkg: Object
})

const { imageSrc } = usePackageImage(props.pkg)
</script>

<template>
    <!-- Populated by JS -->
            <RouterLink :to="`/tweak/${pkg.bundle_id.toLowerCase().replace(/\s+/g, '-')}`"
            class="ios-card glass rounded-3xl overflow-hidden border border-white/10 shrink-0 w-64"
            >
            <img :src="imageSrc" class="w-full h-36 overflow-hidden object-cover" />
            <div class="p-4">
                <h4 class="font-semibold">{{ pkg.name }}</h4>
                <p class="text-sm text-white/60 h-16 overflow-hidden text-ellipsis">{{ pkg.description }}</p>
                <div class="flex justify-between items-center mt-4">
                    <span class="text-xs bg-white/10 px-3 py-1 rounded-full">{{ pkg.version }}</span>
                    <button class="bg-white text-black text-sm font-medium px-6 py-2 rounded-2xl active:scale-95 transition">
                        {{ pkg.price === "Free" ? "Get" : pkg.price }}
                    </button>
                </div>
            </div>
        </RouterLink>
</template>