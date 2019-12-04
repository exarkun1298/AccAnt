<template>
  <v-checkbox
    label="Automatische Gegenbuchung in gleicher Höhe"
    v-model="checkboxCounterBooking"
    v-if="counterBookingCheckboxShow"
    :disabled="!counterBookingCheckboxClickable"
    @change="updateCounterBookingCheckbox()"
    hide-details
  ></v-checkbox>
</template>

<script>
export default {
  /**
   * TO DO
   * update Checkbox state on Transaction UI state change
   */

  data() {
    return {
      checkboxCounterBooking: true
    };
  },
  computed: {
    counterBookingCheckboxShow() {
      return this.$store.state.transactionsForm.autoCounterbookingShow;
    },
    counterBookingCheckboxClickable() {
      return this.$store.state.transactions.clickableCounterBookingCheckbox;
    }
  },

  methods: {
    updateCounterBookingCheckbox() {
      this.$store.commit(
        "transactionsForm/toggleCounterBookingCBValue",
        this.checkboxCounterBooking
      );
    }
  }
};
</script>

<style>
</style>
