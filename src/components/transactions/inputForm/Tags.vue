<template>
  <div>
    <v-spacer>&nbsp;</v-spacer>
    <!-- On default there's no space between text-input line and tags, what looks weird -->
    <v-combobox
      :value="tags"
      :items="items"
      @input="updateTags($event)"
      label="Transaktions-Tags (optional)"
      chips
      multiple
      tags
      prepend-icon="label"
      clearable
    >
      <!-- v-model="tags" -->
      <template slot="selection" slot-scope="data">
        <v-chip :selected="data.selected" close @input="removeTag(data.item)">
          <strong>{{ data.item }}</strong>&nbsp;
        </v-chip>
      </template>
    </v-combobox>
    <div class="input-group__details" v-if="displayHelptext">
      <div class="input-group__messages input-group__hint">
        Mehrere Tags dieser Transaktion. Ein Tag wird mit Enter
        <code>
          <v-icon light>keyboard_return</v-icon>
        </code> erstellt.
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      items: ["Food", "Rent", "Electricity", "Car"]
    };
  },

  computed: {
    tags() {
      this.$store.state.transactionsForm.tags;
    },
    displayHelptext() {
      return this.$store.state.transactionsForm.displayhelptexts;
    }
  },

  methods: {
    updateTags(e) {
      this.$store.commit("transactionsForm/updateTags", e);
    },
    //execute on click of the delete button of a tag
    removeTag(tag) {
      console.log(tag);
      this.$store.commit("transactionsForm/removeTags", tag);
    }
  }
};
</script>

<style>
</style>
