<script setup>
defineProps({ packageData: Object })
</script>

<template>
  <div class="section">
    <h2>Information</h2>
    <table>
      <tbody>
        <tr><td>Developer</td><td>{{ packageData.developer }}</td></tr>
        <tr><td>Version</td><td>{{ packageData.version }}</td></tr>
        <tr><td>Bundle ID</td><td>{{ packageData.bundle_id }}</td></tr>
        <tr><td>Compatible with</td><td>{{ packageData.compatible }}</td></tr>
        <tr><td>Section</td><td>{{ packageData.section }}</td></tr>
      </tbody>
    </table>
  </div>
</template>