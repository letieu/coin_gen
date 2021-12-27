<script setup lang="ts">
// https://github.com/vueuse/head
// you can use this to manipulate the document head in any components,
// they will be rendered correctly in the html results with vite-ssg
useHead({
  title: 'Soin coin generator',
  meta: [
    { name: 'description', content: 'BEP20, ERC20 coin generator' },
  ],
})
</script>

<template>
  <router-view />
</template>
