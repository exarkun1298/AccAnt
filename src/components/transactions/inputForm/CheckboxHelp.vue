<template>
  <v-checkbox
    label="Hilfetexte"
    @change="toggleHelptext()"
    v-model="isChecked"
    v-if="displayCheckbox"
    hide-details
  ></v-checkbox>
</template>

<script>
export default {
  data() {
    return {
      isChecked: false
    };
  },

  computed: {
    displayCheckbox() {
      return this.$store.state.transactions.showHelpCheckbox;
    }
  },

  methods: {
    toggleHelptext() {
      this.$store.commit("transactionsForm/toggleDisplay", this.isChecked);
    }
  }
};
</script>

<style>
</style>
