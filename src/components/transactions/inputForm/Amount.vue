<template>
  <div>
    <div v-if="!fastCash">
      <v-text-field
        ref="refamnt"
        @keyup.enter.stop="submit"
        label="Betrag"
        :value="amount"
        @input="updateAmount($event)"
        @change="determineIncomeExpense(amnt)"
        required
        hint="Muss einen gültigen Geldbetrag enthalten (z.B. 1234,56)."
        :hide-details="!displayHelptext"
        persistent-hint
      ></v-text-field>

      <v-combobox
        v-if="incomeExpenseShow"
        :items="incomeExpenseItems"
        v-model="incomeExpense"
        label="Geldfluss wählen... (automatisch)"
        single-line
        :menu-props="{ auto: true }"
        append-icon="note_add"
        hide-details
      ></v-combobox>
    </div>

    <div v-if="fastCash">
      <v-layout justify-space-between ref="amountSignWrapper" align-end>
        <v-flex xs4>
          <v-text-field
            ref="refamnt"
            @keyup.enter.stop="submit"
            label="Betrag"
            v-model="amnt"
            @change="determineIncomeExpense(amnt)"
            required
            hint="Muss einen gültigen Geldbetrag enthalten (z.B. 1234,56)."
            :hide-details="!displayHelptext"
            persistent-hint
          ></v-text-field>
        </v-flex>

        <v-flex xs7 align-end>
          <v-text-field
            hint="Wird bei Eingabe der Kontonummer automatisch befüllt. Auswahl über Icon möglich."
            persistent-hint
            dense
            disabled
            v-model="incomeExpense"
            label="Geldfluss... (automatisch)"
            single-line
            auto
            hide-details
          ></v-text-field>
        </v-flex>
      </v-layout>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      amnt: null,
      incomeExpense: null,
      incomeExpenseItems: ["Ausgabe", "Einnahme"]
    };
  },
  computed: {
    amount() {
      return this.$store.state.transactionsForm.amount;
    },
    fastCash() {
      //boolean, determines whether to show the normal table or the simplified version for the simple booking modes
      return this.$store.state.transactions.fastCash;
    },
    incomeExpenseShow() {
      //boolean, determines if the simpler "Income or Expense" selection gets shown
      return this.$store.state.transactions.incomeExpenseShow;
    },
    displayHelptext() {
      return this.$store.state.transactionsForm.displayhelptexts;
    }
  },

  methods: {
    updateAmount(e) {
      this.$store.commit("transactionsForm/updateAmount", e);
    },

    determineIncomeExpense(amount) {
      console.log(amount);
      if (amount >= 0) {
        this.incomeExpense = "Einnahme";
      } else {
        this.incomeExpense = "Ausgabe";
      }
    }
  }
};
</script>

<style>
</style>
