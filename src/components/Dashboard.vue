<template>
  <v-layout column>
    <v-flex>
      <v-card>
        <v-container fluid grid-list-md>
          <v-layout row wrap>
            <v-flex
              v-bind="{ [`xs${card.flex}`]: true }"
              v-for="card in cards"
              :key="card.title"
            >
              <v-card>
                <v-card-media
                  :src="card.src"
                  height="300px"
                >
                  <v-container fill-height fluid>
                    <v-layout fill-height>
                      <v-flex xs12 align-end flexbox>
                        <span class="headline white--text" v-text="card.title"></span>
                      </v-flex>
                    </v-layout>
                  </v-container>
                </v-card-media>
              </v-card>
            </v-flex>
          </v-layout>
        </v-container>
      </v-card>
    </v-flex>
  </v-layout>
</template>

<script>
  export default {
    data: () => ({
      cards: [
        { title: 'fancy Datenpanel 1', src: '../../../media/ant2.png', flex: 6 },
        { title: 'fancy Datenpanel 2', src: '../../../media/ant2.png', flex: 6 },
        { title: 'fancy Datenpanel 3', src: '../../../media/ant2.png', flex: 6 },
        { title: 'fancy Datenpanel 4', src: '../../../media/ant2.png', flex: 6 },
      ]
    })
  }
</script>

<style>

</style>