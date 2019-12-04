<template>
  <v-text-field
    ref="refbooktext"
    @keyup.enter.stop="submit"
    :label="booktextDescription"
    :value="booktext"
    @input="updateBooktext($event)"
    required
    hint="Der Buchtext ist erforderlich und sollte aussagekräftig sein."
    :hide-details="!displayHelptext"
    persistent-hint
  ></v-text-field>
</template>

<script>
export default {
  data() {
    return {};
  },
  computed: {
    booktext() {
      return this.$store.state.transactionsForm.updateBooktext;
    },
    booktextDescription() {
      //label of the booktext input field
      return this.$store.state.transactions.booktextDescription;
    },
    displayHelptext() {
      return this.$store.state.transactionsForm.displayhelptexts;
    }
  },

  methods: {
    updateBooktext(e) {
      this.$store.commit("transactionsForm/updateBooktext", e);
    }
  }
};
</script>

<style>
</style>
