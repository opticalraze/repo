<script setup>
import { ref, onMounted } from 'vue'
import { useRoute } from 'vue-router'
import PackageHeader from '../components/PackageHeader.vue'
import PackageDescription from '../components/PackageDescription.vue'
import PackageScreenshots from '../components/PackageScreenshots.vue'
import PackageInfo from '../components/PackageInfo.vue'
import PackageChangelog from '../components/PackageChangelog.vue'
import BaseLayout from '../layouts/BaseLayout.vue'

const route = useRoute()
const baseUrl = import.meta.env.VITE_BASE_URL || 'https://repo.opticalraze.com'

const packageData = ref(null)
const loading = ref(true)
const error = ref(null)

async function loadPackage() {
  try {
    const response = await fetch('/packages.json')
    const data = await response.json()

    const slug = route.params.slug?.toLowerCase()

    // Find by slug (recommended)
    packageData.value = data.packages.find(pkg => 
      pkg.bundle_id.toLowerCase().replace(/\s+/g, '-') === slug
    )

    if (!packageData.value) {
      // Fallback: find by name
      packageData.value = data.packages.find(pkg => 
        pkg.name.toLowerCase() === route.params.name?.toLowerCase()
      )
    }

    if (!packageData.value) {
      error.value = "Package not found"
    }
  } catch (err) {
    console.error(err)
    error.value = "Failed to load package"
  } finally {
    loading.value = false
  }
}

onMounted(() => {
  loadPackage()
})
</script>

<template>
  <BaseLayout>
    <div class="container" v-if="!loading && packageData">
      
      <PackageHeader 
        :icon="`${baseUrl}/depictions/${packageData.bundle_id}/icon.png`"
        :name="packageData.name"
        :subtitle="packageData.subtitle"
      />

      <PackageDescription 
        :description="packageData.description"
        :features="packageData.features"
      />

      <PackageScreenshots 
        :base-url="baseUrl"
        :bundle-id="packageData.bundle_id"
        :screenshot-count="packageData.screenshotCount || 3"
      />

      <PackageInfo :package-data="packageData" />

      <PackageChangelog :changelog="packageData.changelog" />

      <div class="footer">
        <p>&copy; Copyright {{ new Date().getFullYear() }}, Optical Raze Inc.</p>
      </div>

    </div>

    <div v-else-if="error" class="error">
      {{ error }}
    </div>
    <div v-else>Loading...</div>
  </BaseLayout>
</template>

<style scoped>
.container {
  max-width: 700px;
  margin: 0 auto;
  padding: 0 1.5rem;
}

.footer {
  text-align: center;
  padding: 40px 0;
  color: #666;
  font-size: 14px;
}

.error {
  text-align: center;
  color: #ff6b6b;
  padding: 50px;
}
</style>