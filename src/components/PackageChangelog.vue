<script setup>
defineProps({ changelog: Array })
</script>

<template>
  <div class="section">
    <h2>Changelog</h2>
    <div class="changelog" v-if="changelog">
      <div class="entry pt-2.5" v-for="(entry, i) in changelog" :key="i">
        <div class="version">{{ entry.version }}</div>
        <p v-html="entry.changes"></p>
      </div>
    </div>
  </div>
</template>