<script setup>
import BaseButton from '../components/BaseButton.vue';
import MainLayout from '../layouts/MainLayout.vue';


</script>

<template>
    
    <MainLayout>
        
        <!-- Page Header -->
        <div class="mb-10 px-6">
            <h2 class="text-4xl font-bold tracking-tighter mb-1">Cart</h2>
            <p class="text-white/60">Continue to Checkout</p>
        </div>
        
        <div class="fixed bottom-16 left-0 w-full py-6 glass border-t border-white/20">

            <div class="w-full max-w-xl mx-auto flex items-center justify-between px-6">


            <div>
                <p class="text-2xl font-medium flex items-center gap-4"><b class="font-bold">Total:</b> <span>$5.99</span></p>
            </div>

            <BaseButton class="bg-white! text-black">
                Checkout
            </BaseButton>

            </div>

        </div>
        
    </MainLayout>
    
</template>