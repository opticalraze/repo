<script setup>

defineProps({
    src: String,
});
</script>

<template>
    <div class="w-16 h-16 rounded-2xl overflow-hidden border border-white/5 bg-white/10">
        <img :src="src" alt="icon" class="w-full h-full object-cover">
    </div>
</template>