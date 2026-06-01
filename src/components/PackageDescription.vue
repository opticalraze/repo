<script setup>
defineProps({
  description: String,
  features: Array
})
</script>

<template>
  <div class="section pt-2.5">
    <h2>About {{ $parent.packageData?.name || 'This Tweak' }}</h2>
    <p class="description">{{ description }}</p>

    <h2>Key Features</h2>
    <ul class="features" v-if="features">
      <li v-for="(feature, i) in features" :key="i">{{ feature }}</li>
    </ul>
  </div>
</template>

<style scoped>
/* Reuse your existing styles */
</style>