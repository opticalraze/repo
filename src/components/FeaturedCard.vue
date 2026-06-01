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
        <div class="relative w-full h-36 overflow-hidden bg-white/10 rounded-t-3xl border-b border-white/10">
            <!-- Spinner behind the image -->
             <div class="absolute inset-0 z-10 flex items-center justify-center">
                <LoadingSpinner class="mb-4" />
             </div>
            
            <!-- Image on top -->
            <img 
            :src="imageSrc" 
            class="absolute inset-0 z-20 w-full h-full object-cover rounded-t-3xl"
            />

            <div class="absolute z-30 flex flex-col justify-end text-center w-full h-full">
                
                <div class="h-10 w-full bg-black">
                    <img :src="imageSrc" alt="" class="absolute w-full h-full object-cover blur-3xl" />
                    <p v-if="pkg.subtitle" class="relative z-20 w-full font-medium italic text-xs h-10 flex flex-col justify-center">"{{ pkg.subtitle }}"</p>
                </div>
                
            </div>
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