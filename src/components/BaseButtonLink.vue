<script setup>
defineProps({
    to: String,
});
</script>

<template>
    <RouterLink :to="to" class="font-semibold px-6 py-1 rounded-lg active:scale-95 transition text-nowrap">
        <slot />
    </RouterLink>
</template>