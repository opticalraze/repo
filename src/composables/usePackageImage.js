import { ref, onMounted } from 'vue'

export function usePackageImage(pkg) {
    const imageSrc = ref(null)
    
    const checkImage = (url) => {
        return new Promise((resolve) => {
            if (!url) {
                resolve(false)
                return
            }
            const img = new Image()
            img.onload = () => resolve(true)
            img.onerror = () => resolve(false)
            img.src = url
        })
    }
    
    const loadImage = async () => {
        if (pkg.banner) {
            const exists = await checkImage(pkg.banner)
            if (exists) {
                imageSrc.value = pkg.banner
                return
            }
        }
        imageSrc.value = pkg.icon
    }
    
    onMounted(loadImage)
    
    return { imageSrc }
}