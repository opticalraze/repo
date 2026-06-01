<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import AppIcon from '../components/AppIcon.vue'
import BaseLayout from '../layouts/BaseLayout.vue'

const baseUrl = import.meta.env.VITE_BASE_URL || 'https://repo.opticalraze.com'

const route = useRoute()
const router = useRouter()

const packageData = ref(null)
const loading = ref(true)

// Load single package
async function loadPackage() {
    try {
        const response = await fetch('/packages.json')
        const data = await response.json()
        
        const slug = route.params.slug
        const found = data.packages.find(pkg => 
            pkg.bundle_id.toLowerCase().replace(/\s+/g, '-') === slug
        )
        
        if (found) {
            packageData.value = found
        } else {
            // Fallback: try by exact name
            packageData.value = data.packages.find(pkg => pkg.name === route.params.name)
        }
    } catch (error) {
        console.error("Failed to load package:", error)
    } finally {
        loading.value = false
    }
}

onMounted(() => {
    loadPackage()
})

// Back button
function goBack() {
    router.back()
}
</script>

<template>
    <BaseLayout>
    <div class="container">

        <!-- Header -->
        <div class="header">
            <img :src="`${baseUrl}/depictions/com.opticalraze.neosiri/icon.png`" class="icon" alt="NeoSiri Icon">
            <div class="title">
                <h1>NeoSiri</h1>
                <p class="subtitle">Make Siri Think Different</p>
            </div>
        </div>

        <!-- Description -->
        <div class="section">
            <h2>About NeoSiri</h2>
            <p class="description">
                NeoSiri completely transforms the Siri interface with vibrant gradients, 
                smooth animations, and a fresh modern aesthetic. Say goodbye to the old look — 
                experience Siri like never before.
            </p>
            
            <h2 style="margin-top: 25px;">Key Features</h2>
            <ul class="features">
                <li>Stunning new color themes & gradients</li>
                <li>Enhanced visual effects and glows</li>
                <li>Fluid animations and transitions</li>
                <li>Lightweight with no battery impact</li>
                <li>Compatible with iOS 15 - 16.x</li>
            </ul>
        </div>

        <!-- Screenshots -->
        <div class="section">
            <h2>Screenshots</h2>
            <div class="screenshots">
                <img :src="`${baseUrl}/depictions/com.opticalraze.neosiri/screenshots/1.png`" alt="NeoSiri Screenshot 1">
                <img :src="`${baseUrl}/depictions/com.opticalraze.neosiri/screenshots/1.png`" alt="NeoSiri Screenshot 2">
                <img :src="`${baseUrl}/depictions/com.opticalraze.neosiri/screenshots/1.png`" alt="NeoSiri Screenshot 3">
            </div>
        </div>

        <!-- Information -->
        <div class="section">
            <h2>Information</h2>
            <table>
                <tbody>
                <tr><td>Developer</td><td>Optical Raze Inc.</td></tr>
                <tr><td>Version</td><td>1.0</td></tr>
                <tr><td>Bundle ID</td><td>com.opticalraze.neosiri</td></tr>
                <tr><td>Compatible with</td><td>iOS 15.0 - 16.x</td></tr>
                <tr><td>Section</td><td>Tweaks</td></tr>
                </tbody>
            </table>
        </div>

        <!-- Changelog -->
        <div class="section">
            <h2>Changelog</h2>
            <div class="changelog">
                <div class="entry">
                    <div class="version">Version 1.0</div>
                    <p>• Initial public release<br>
                       • Beautiful new Siri color themes<br>
                       • Optimized performance</p>
                </div>
            </div>
        </div>

        <div class="footer">
            <p>&copy; Copyright 2026, Optical Raze Inc.</p>
        </div>

    </div>
    </BaseLayout>
</template>

<style scoped>
        @import url('https://fonts.googleapis.com/css2?family=SF+Pro+Display:wght@400;500;600&display=swap');
        
        body {
            font-family: 'SF Pro Display', -apple-system, BlinkMacSystemFont, sans-serif;
            background: #0f0f0f;
            color: #ffffff;
            margin: 0;
            padding: 20px 10px;
            line-height: 1.6;
        }
        .container {
            max-width: 700px;
            margin: 0 auto;
            padding-inline: 1.5rem;
        }
        .header {
            text-align: center;
            padding: 30px 0 20px;
        }
        .icon {
            width: 120px;
            height: 120px;
            border-radius: 28px;
            /* box-shadow: 0 10px 30px rgba(0, 122, 255, 0.4); */
            margin-bottom: 15px;
            margin-inline: auto;
        }
        .title h1 {
            font-size: 32px;
            font-weight: 600;
            margin: 10px 0 5px;
        }
        .subtitle {
            font-size: 18px;
            color: #aaa;
            margin: 0;
        }

        .section {
            background: #1c1c1e;
            border-radius: 18px;
            padding: 22px;
            margin-bottom: 20px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        .section h2 {
            margin-top: 0;
            font-size: 22px;
            color: #00b4ff;
            border-bottom: 1px solid #333;
            padding-bottom: 10px;
        }

        .description {
            font-size: 17px;
            color: #ddd;
        }

        .features {
            list-style: none;
            padding: 0;
        }
        .features li {
            padding: 10px 0;
            border-bottom: 1px solid #333;
            display: flex;
            align-items: center;
        }
        .features li:last-child {
            border-bottom: none;
        }
        .features li:before {
            content: "✦";
            color: #00d4ff;
            margin-right: 12px;
            font-size: 18px;
        }

        .screenshots {
            display: flex;
            gap: 12px;
            overflow-x: auto;
            padding: 10px 0;
            scrollbar-width: none;
        }
        .screenshots img {
            border-radius: 16px;
            width: 280px;
            flex-shrink: 0;
            box-shadow: 0 8px 25px rgba(0,0,0,0.5);
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }
        td {
            padding: 12px 0;
            border-bottom: 1px solid #333;
        }
        td:first-child {
            color: #888;
            width: 40%;
            font-weight: 500;
        }

        .changelog .entry {
            margin-bottom: 20px;
        }
        .changelog .version {
            color: #00d4ff;
            font-weight: 600;
            font-size: 18px;
        }

        .footer {
            text-align: center;
            padding: 30px 0;
            color: #666;
            font-size: 14px;
        }
    </style>