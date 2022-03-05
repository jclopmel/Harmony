<template>
    <v-card
      :loading="loading"
      class="mx-auto my-12"
      max-width="374"
    >
      <template slot="progress">
        <v-progress-linear
          color="deep-purple"
          height="10"
          indeterminate
        ></v-progress-linear>
      </template>

      <v-img
        height="250"
        :src=tokenName.img
      ></v-img>

      <v-card-title>{{tokenName.name}}</v-card-title>

      <v-card-text>
        <div>
          Short description of the NFT exclusive value
        </div>
      </v-card-text>

      <v-divider class="mx-4"></v-divider>

      <v-card-text class="text-right">
        <v-label class="mr-3">Top bid:</v-label>
        <v-chip>
          <v-img
            max-height="15"
            max-width="10"
            src="../assets/img/eth_icon.png"
            class="mr-1"
          >
          </v-img>
            {{ tokenName.currentBid }}
        </v-chip>
      </v-card-text>

      <v-card-actions>
        <v-btn
          color="teal lighten-2"
          block
          text
          @click="reserve"
        >
        <v-progress-circular
          class="mr-3"
          :rotate="360"
          :size="20"
          :width="2"
          color="teal"
          :value="auctionEnds"
        >
          {{ auctionEnd }}
        </v-progress-circular>
            hours left
        </v-btn>
      </v-card-actions>
    </v-card>

    
</template>

<script>
  export default {
    name: 'TokenCard',
    props: ['tokenName'],
    data: () => ({
      loading: false,
      selection: 1,
      auctionEnd: 8,
      auctionEnds: 75,
      currentBid: 0.1,
    }),
    methods:{
      reserve () {
        console.log('Try Auction');
      },
    }
  }
</script>
