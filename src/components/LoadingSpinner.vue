<template>
    <svg class="absolute bottom-1/2 right-1/2 translate-1/2 w-12 h-12" fill="currentColor" viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"><defs><linearGradient id="RadialGradient8932"><stop offset="0%" stop-color="currentColor" stop-opacity="1"/><stop offset="100%" stop-color="currentColor" stop-opacity="0.25"/></linearGradient></defs><circle cx="10" cy="10" r="8" id="circle8932" stroke-width="2"/></svg>
</template>

<style scoped>
@keyframes spin8932 {
    to {
        transform: rotate(360deg);
    }
}

#circle8932 {
    transform-origin: 50% 50%;
    stroke: url(#RadialGradient8932);
    fill: none;
    animation: spin8932 .5s infinite linear;
}
</style>