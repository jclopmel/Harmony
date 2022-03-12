<template>
  <v-container>
    <v-row>
      <v-col xs="6">
        <v-text-field
          v-model="name"
          label="Name"
          required
        ></v-text-field>

        <v-text-field
          v-model="description"
          label="Author Description"
        ></v-text-field>
        <v-file-input
          v-model="nftImage"
          accept="image/*"
          label="File input"
        ></v-file-input>
        <v-btn
          color="success"
          @click="sendNFT"
        >
          Create NFT
        </v-btn>
      </v-col>
      <v-col xs="6">
        <v-text-field
          v-model="NFTindex"
          label="Index to load NFT"
        ></v-text-field>
        <v-btn
          color="success"
          @click="loadNFTByIndex"
        >
          Load NFT
        </v-btn>
        {{nftCollection}}
      </v-col>
    </v-row>
    <v-row>
      <v-col
        xs="12"
        sm="12"
        md="6"
        lg="4"
        xl="3"
        v-for="(auctionToken, index) in nftCollection" :key="index"
      >
        <TokenCard :tokenName="auctionToken"/>
      </v-col>
    </v-row>
    <v-row>
      <v-btn
        color="success"
        @click="getNFTHash"
      >
        Get Auction Hash
      </v-btn>
      <v-btn
        color="red lighten-3"
        @click="placeBid"
      >
        Bid
      </v-btn>
      <v-btn
        color="success"
        @click="getHighestBidder"
      >
        Highest Bidder
      </v-btn>
      <v-btn
        color="success"
        @click="getHighestBid"
      >
        Highest Bid
      </v-btn>
    </v-row>
    <v-row>
      <!-- <vue-metamask 
          userMessage="msg" 
          @onComplete="onComplete"
      >
      </vue-metamask> -->
    </v-row>
  </v-container>
</template>

<script>
  import TokenCard from './TokenCard';
  // import VueMetamask from 'vue-metamask';
  import Web3 from 'web3';
  import Abis from '../abi.js';
  import Address from '../address.js';
  
  export default {
    name: 'Store',
    components: {
      TokenCard,
      // VueMetamask
    },
    data: () => ({
      imgsUrl:[
        "https://img.freepik.com/free-photo/old-wooden-door-with-bougainvillea_1401-306.jpg?w=1380",
        "https://img.freepik.com/free-photo/filament-bulb-lying-euro-coins_1401-453.jpg?t=st=1647064264~exp=1647064864~hmac=cfa50958afeb6df71e0a366c93c85aacaad5c363577af788294bc96610751e50&w=1380",
        "https://img.freepik.com/free-photo/time-is-money-concept-alarm-clock-lots-euro-coins_1401-456.jpg?w=1380"
      ],
      auctionTokens: [
        { name: 'NFT 01', img: "https://picsum.photos/250/300", currentBid: 0.1 },
        { name: 'NFT 02', img: "https://picsum.photos/250/300", currentBid: 0.2 },
        { name: 'NFT 03', img: "https://picsum.photos/250/300", currentBid: 1.0 }
      ],
      msg: "This is a demo metamask work",
      web3: "",
      contract_artToken_address: Address.contract_artToken_address,
      contract_aution_address: Address.contract_aution_address,
      ArtTokenInstance: "",
      instanciaAuction: "",
			accounts: "",
			artistAccount: "",
      bidderAccount: "",
      name:"",
      description:"",
      nftImage: "",
      nftName: "",
      NFTindex: "",
      nftCollection:[],
    }),
    created: function () {
      var that = this;
      that.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));

      async function start() {
        // Get all the accounts
        that.accounts = await that.web3.eth.getAccounts();
        // var auctionOwnerAccount = accounts[1]
        that.artistAccount = that.accounts[0];
        that.bidderAccount = that.accounts[1];

          //Instance Contracts
        that.ArtTokenInstance = new that.web3.eth.Contract(Abis.contract_artToken_abi, that.contract_artToken_address);
        that.instanciaAuction = new that.web3.eth.Contract(Abis.contract_aution_abi, that.contract_aution_address);

        // Get name ArtToken
        that.ArtTokenInstance.methods.name().call(function(error, result){
          if(!error){
              that.nftName = result;
          }
          else
              console.error("name error: ", error);
        });

          // Get symbol ArtToken
          /* ArtTokenInstance.methods.symbol().call(function(error, result){
            if(!error){
                console.log("symbol: ", result);
            }
            else
                console.error("symbol error: ", error);
          }); */
      }

      start();

          //Contracts Address
          
          // var contract_ownable_abi= "0x46bB1BD959C071f5e2bE4D20F3e869FaC6BA69Ad";
          // var contract_art_abi= "0x263BDDcC5b330d6D736d87736f329cd788998a61";
              

          //Instance Contracts

          // Get Bid Increment
          /* instanciaAuction.methods.bidIncrement().call(function(error, result){
            if(!error){
                console.log("bidIncrement: ", result);
            }
            else
                console.error("bidIncrement error: ", error);
          }); */

          // Get Owner
          /* instanciaAuction.methods.owner().call(function(error, result){
            if(!error){
                console.log("owner: ", result);
            }
            else
                console.error("owner error: ", error);
          }); */
    },
    methods:{
      sendNFT () {
        // Mint new NFT ArtToken
				var that = this;
        this.ArtTokenInstance.methods.mint(this.artistAccount, that.imgsUrl[2]).send({from: this.artistAccount,  gas: 300000}, function(error, result){
          if(!error){
						console.log("mint result: ", result);
						that.nftCollection.push(that.getNFTUri());
          }
          else
              console.error("mint error: ", error);
        });
      },
			getLastTokenIndex(){
				this.ArtTokenInstance.methods.getLastIndex().call(function(error, result){
					if(!error){
						console.log("tokenUri: ", result);
						return result;
					}
					else
							console.error("index error: ", error);
				});
			},
			getNFTUri(tokenIndex){
				// Get tokenUri ArtToken
				var that=this;
        var data;
				this.ArtTokenInstance.methods.tokenURI(tokenIndex).call(function(error, result){
					if(!error){
							console.log("tokenUri: ", result);
              data = {
                name: that.nftName,
                img: result,
                currentBid: 0
              };
							that.nftCollection.push( data );
					}
					else
							console.error("tokenUri error: ", error);
				});
			},
      loadNFTByIndex(){
        this.getNFTUri(this.NFTindex);
      },
      getNFTHash(){
         // Get NFT Hash
          this.instanciaAuction.methods.ntfHash().call(function(error, result){
            if(!error){
                console.log("ntfHash: ", result);
            }
            else
                console.error("ntfHash error: ", error);
          });
      },
      placeBid(){
        // Send Place Bid
        this.instanciaAuction.methods.placeBid().send( {from: this.bidderAccount, gas: 300000, value: 10}, function(error, result){
          if(!error){
              console.log("placeBid:", result);
          }
          else
              console.error("placeBid:", error);
        });
      },
      getHighestBidder(){
        // Get highest Bidder
        this.instanciaAuction.methods.highestBidder().call(function(error, result){
          if(!error){
              console.log("highestBidder: ", result);
          }
          else
              console.error("highestBidder error: ", error);
        });
      },
      getHighestBid(){
        // Get highest Bid
        this.instanciaAuction.methods.getHighestBid().call(function(error, result){
          if(!error){
              console.log("getHighestBid: ", result);
          }
          else
              console.error("getHighestBid error: ", error);
        });
      }
    }
  }
</script>
