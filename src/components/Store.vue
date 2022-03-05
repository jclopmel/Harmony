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
  import Web3 from 'web3'
  
  export default {
    name: 'Store',
    components: {
      TokenCard,
      // VueMetamask
    },
    data: () => ({
      auctionTokens: [
        { name: 'NFT 01', img: "https://picsum.photos/250/300", currentBid: 0.1 },
        { name: 'NFT 02', img: "https://picsum.photos/250/300", currentBid: 0.2 },
        { name: 'NFT 03', img: "https://picsum.photos/250/300", currentBid: 1.0 }
      ],
      msg: "This is a demo metamask work"
    }),
    created: function () {
          // Contracts ABI
          const contract_aution_abi = [ { "inputs": [ { "internalType": "uint256", "name": "_bidIncrement", "type": "uint256" }, { "internalType": "uint256", "name": "_startBlock", "type": "uint256" }, { "internalType": "uint256", "name": "_endBlock", "type": "uint256" }, { "internalType": "string", "name": "_ntfHash", "type": "string" } ], "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "address", "name": "bidder", "type": "address" }, { "indexed": false, "internalType": "uint256", "name": "bid", "type": "uint256" }, { "indexed": false, "internalType": "address", "name": "highestBidder", "type": "address" }, { "indexed": false, "internalType": "uint256", "name": "highestBid", "type": "uint256" }, { "indexed": false, "internalType": "uint256", "name": "highestBindingBid", "type": "uint256" } ], "name": "LogBid", "type": "event" }, { "anonymous": false, "inputs": [], "name": "LogCanceled", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": false, "internalType": "address", "name": "withdrawer", "type": "address" }, { "indexed": false, "internalType": "address", "name": "withdrawalAccount", "type": "address" }, { "indexed": false, "internalType": "uint256", "name": "amount", "type": "uint256" } ], "name": "LogWithdrawal", "type": "event" }, { "inputs": [], "name": "bidIncrement", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "cancelAuction", "outputs": [ { "internalType": "bool", "name": "success", "type": "bool" } ], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "canceled", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "endBlock", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "", "type": "address" } ], "name": "fundsByBidder", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getHighestBid", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "highestBidder", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "highestBindingBid", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "ntfHash", "outputs": [ { "internalType": "string", "name": "", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "owner", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "placeBid", "outputs": [ { "internalType": "bool", "name": "success", "type": "bool" } ], "stateMutability": "payable", "type": "function" }, { "inputs": [], "name": "startBlock", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "withdraw", "outputs": [ { "internalType": "bool", "name": "success", "type": "bool" } ], "stateMutability": "payable", "type": "function" } ];

          //Contracts Address
          var contract_aution_address= "0xa6364e1CF80E31008cBA5487FA4039B46Cc1EC7C";
          // var contract_ownable_abi= "0x46bB1BD959C071f5e2bE4D20F3e869FaC6BA69Ad";
          // var contract_art_abi= "0x263BDDcC5b330d6D736d87736f329cd788998a61";

          var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));

          var instanciaAuction, bidderAccount;

          async function start() {
              // Get all the accounts
              const accounts = await web3.eth.getAccounts();
              bidderAccount = accounts[1];

              //Instance Contracts
              instanciaAuction = new web3.eth.Contract(contract_aution_abi, contract_aution_address);

              // Get highest Bid
              instanciaAuction.methods.getHighestBid().call(function(error, result){
                if(!error){
                    console.log("getHighestBid: ", result);
                }
                else
                    console.error("getHighestBid error: ", error);
              });

              // Get Bid Increment
              instanciaAuction.methods.bidIncrement().call(function(error, result){
                if(!error){
                    console.log("bidIncrement: ", result);
                }
                else
                    console.error("bidIncrement error: ", error);
              });

              // Get highest Bidder
              instanciaAuction.methods.highestBidder().call(function(error, result){
                if(!error){
                    console.log("highestBidder: ", result);
                }
                else
                    console.error("highestBidder error: ", error);
              });

              // Get NFT Hash
              instanciaAuction.methods.ntfHash().call(function(error, result){
                if(!error){
                    console.log("ntfHash: ", result);
                }
                else
                    console.error("ntfHash error: ", error);
              });

              // Get Owner
              instanciaAuction.methods.owner().call(function(error, result){
                if(!error){
                    console.log("owner: ", result);
                }
                else
                    console.error("owner error: ", error);
              });

              // Send Place Bid
              instanciaAuction.methods.placeBid().send( {from: bidderAccount, gas: 300000, value: 10}, function(error, result){
                if(!error){
                    console.log("placeBid:", result);
                }
                else
                    console.error("placeBid:", error);
              });
          }

          start();
    },
    methods:{
      onComplete(){
          // console.log('data:', data);

      }
    }
  }
</script>
