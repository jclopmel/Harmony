<template>
  <v-container>
    <v-row>
      <v-col
        xs="12"
        sm="12"
        md="6"
        lg="4"
        xl="3"
        v-for="(auctionToken, index) in auctionTokens" :key="index"
      >
        <TokenCard :tokenName="auctionToken"/>
      </v-col>
    </v-row>
    <v-row>
      <vue-metamask 
          userMessage="msg" 
          @onComplete="onComplete"
      >
      </vue-metamask>
    </v-row>
  </v-container>
</template>

<script>
  import TokenCard from './TokenCard';
  import VueMetamask from 'vue-metamask';
  
  export default {
    name: 'Store',
    components: {
      TokenCard,
      VueMetamask
    },
    data: () => ({
      auctionTokens: [
        { name: 'NFT 01', img: "https://picsum.photos/250/300", currentBid: 0.1 },
        { name: 'NFT 02', img: "https://picsum.photos/250/300", currentBid: 0.2 },
        { name: 'NFT 03', img: "https://picsum.photos/250/300", currentBid: 1.0 }
      ],
      msg: "This is a demo metamask work"
    }),
    methods:{
      onComplete(data){
          console.log('data:', data);
      }
    }
  }
</script>
