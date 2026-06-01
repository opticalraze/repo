<script setup>
defineProps({
  icon: String,
  name: String,
  subtitle: String
})
</script>

<template>
  <div class="header">
    <img :src="icon" class="icon" :alt="name + ' Icon'">
    <div class="title">
      <h1>{{ name }}</h1>
      <p class="subtitle">{{ subtitle }}</p>
    </div>
  </div>
</template>

<style scoped>
.header {
  text-align: center;
  padding: 40px 0 25px;
}
.icon {
  width: 128px;
  height: 128px;
  border-radius: 28px;
  margin-bottom: 16px;
}
.title h1 {
  font-size: 32px;
  font-weight: 600;
  margin: 0 0 8px;
}
.subtitle {
  font-size: 18px;
  color: #aaa;
}
</style>