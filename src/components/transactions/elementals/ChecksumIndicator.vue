<template>
  <v-layout row wrap justify-space-between>
    <v-flex>
      <v-card>
        <v-card-text>Open Amount: {{checksum}}</v-card-text>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
export default {
  computed: {
    getRecordQueue() {
      return this.$store.state.transactionsForm.recordQueue;
    },

    checksum() {
      let checksum = 0;
      let currentRecordQueue = JSON.parse(JSON.stringify(this.getRecordQueue));
      currentRecordQueue.forEach(record => {
        checksum += parseFloat(record.amount);
      });
      return checksum;
    }
  }
};
</script>

<style>
</style>
