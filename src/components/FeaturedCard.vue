<script setup>
import { usePackageImage } from '../composables/usePackageImage'
import BaseButton from './BaseButton.vue';
import LoadingSpinner from './LoadingSpinner.vue';

const props = defineProps({
    pkg: Object
})

const { imageSrc } = usePackageImage(props.pkg)
</script>

<template>
    <!-- Populated by JS -->
    <RouterLink :to="`/package/${pkg.bundle_id.toLowerCase().replace(/\s+/g, '-')}`"
        class="ios-card glass rounded-3xl overflow-hidden border border-white/10 shrink-0 w-64"
    >
        <div class="relative w-full h-36 overflow-hidden bg-white/10">
            <!-- Spinner behind the image -->
             <div class="absolute inset-0 z-10">
                <LoadingSpinner class="flex items-center justify-center" />
             </div>
            
            <!-- Image on top -->
            <img 
            :src="imageSrc" 
            class="absolute inset-0 z-20 w-full h-full object-cover"
            />
        </div>
        <div class="p-4">
            <h4 class="font-semibold">{{ pkg.name }}</h4>
            <p class="text-sm text-white/60 h-16 overflow-hidden text-ellipsis">{{ pkg.description }}</p>
            <div class="flex justify-between items-center mt-4">
                <span class="text-xs bg-white/10 px-3 py-1 rounded-full">{{ pkg.version }}</span>
                <BaseButton>
                    {{ pkg.price === "Free" ? "Get" : pkg.price }}
                </BaseButton>
            </div>
        </div>
    </RouterLink>
</template>