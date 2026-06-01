<script setup>
defineProps({
  baseUrl: String,
  bundleId: String,
  screenshotCount: { type: Number, default: 3 }
})
</script>

<template>
  <div class="section">
    <h2>Screenshots</h2>
    <div class="screenshots">
      <img 
        v-for="n in screenshotCount" 
        :key="n"
        :src="`${baseUrl}/depictions/${bundleId}/screenshots/${n}.png`"
        :alt="`Screenshot ${n}`"
      >
    </div>
  </div>
</template>