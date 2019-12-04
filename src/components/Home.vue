<template>
  <div>
    <h1>Home</h1>
    <v-btn :to="{path: '/database'}">database</v-btn>
    <v-btn :to="{path: '/databaseTypeORM'}">databaseTypeORM</v-btn>
  </div>
</template>

<script>
export default {
  data: () => ({}),

  methods: {}
};
</script>

<style>
</style>