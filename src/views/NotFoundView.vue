<script setup>
import BaseButton from '../components/BaseButton.vue';
import MainLayout from '../layouts/MainLayout.vue';


</script>

<template>
    
    <MainLayout>
        
        <div class="max-w-xl mx-auto pt-20 pb-12 text-center">
            <h1 class="text-6xl font-bold text-white mb-4">404</h1>
            <h2 class="text-2xl font-medium mb-2">Page Not Found</h2>
            <p class="text-white/60 mb-8">The page you're looking for doesn't exist.</p>
            
            <BaseButton 
                @click="$router.push('/')"
            >
                Return to Home
            </BaseButton>
        </div>
    
</MainLayout>

</template>