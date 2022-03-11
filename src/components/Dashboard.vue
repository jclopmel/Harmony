<template>
  <v-container>
    <v-row>
      <v-col xs="12">
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
					{{nftCollection}}
      </v-col>
    </v-row>
    <v-row>

    </v-row>
  </v-container>
</template>

<script>
  import Web3 from 'web3'
  
  export default {
    name: 'Dashboard',
    components: {
    },
    data: () => ({
			web3: "",
      // ArtTokens ABI
      contract_artToken_abi: [ { "inputs": [], "stateMutability": "nonpayable", "type": "constructor" }, { "anonymous": false, "inputs": [ { "indexed": true, "internalType": "address", "name": "_owner", "type": "address" }, { "indexed": true, "internalType": "address", "name": "_approved", "type": "address" }, { "indexed": true, "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "Approval", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": true, "internalType": "address", "name": "_owner", "type": "address" }, { "indexed": true, "internalType": "address", "name": "_operator", "type": "address" }, { "indexed": false, "internalType": "bool", "name": "_approved", "type": "bool" } ], "name": "ApprovalForAll", "type": "event" }, { "anonymous": false, "inputs": [ { "indexed": true, "internalType": "address", "name": "_from", "type": "address" }, { "indexed": true, "internalType": "address", "name": "_to", "type": "address" }, { "indexed": true, "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "Transfer", "type": "event" }, { "inputs": [ { "internalType": "address", "name": "_approved", "type": "address" }, { "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "approve", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_owner", "type": "address" } ], "name": "balanceOf", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "getApproved", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getLastIndex", "outputs": [ { "internalType": "uint256", "name": "", "type": "uint256" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getNftName", "outputs": [ { "internalType": "string", "name": "", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "getNftSymbol", "outputs": [ { "internalType": "string", "name": "", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_owner", "type": "address" }, { "internalType": "address", "name": "_operator", "type": "address" } ], "name": "isApprovedForAll", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_to", "type": "address" }, { "internalType": "string", "name": "_uri", "type": "string" } ], "name": "mint", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [], "name": "name", "outputs": [ { "internalType": "string", "name": "_name", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "owner", "outputs": [ { "internalType": "address", "name": "", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "ownerOf", "outputs": [ { "internalType": "address", "name": "_owner", "type": "address" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_from", "type": "address" }, { "internalType": "address", "name": "_to", "type": "address" }, { "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "safeTransferFrom", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_from", "type": "address" }, { "internalType": "address", "name": "_to", "type": "address" }, { "internalType": "uint256", "name": "_tokenId", "type": "uint256" }, { "internalType": "bytes", "name": "_data", "type": "bytes" } ], "name": "safeTransferFrom", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_operator", "type": "address" }, { "internalType": "bool", "name": "_approved", "type": "bool" } ], "name": "setApprovalForAll", "outputs": [], "stateMutability": "nonpayable", "type": "function" }, { "inputs": [ { "internalType": "bytes4", "name": "_interfaceID", "type": "bytes4" } ], "name": "supportsInterface", "outputs": [ { "internalType": "bool", "name": "", "type": "bool" } ], "stateMutability": "view", "type": "function" }, { "inputs": [], "name": "symbol", "outputs": [ { "internalType": "string", "name": "_symbol", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "tokenURI", "outputs": [ { "internalType": "string", "name": "", "type": "string" } ], "stateMutability": "view", "type": "function" }, { "inputs": [ { "internalType": "address", "name": "_from", "type": "address" }, { "internalType": "address", "name": "_to", "type": "address" }, { "internalType": "uint256", "name": "_tokenId", "type": "uint256" } ], "name": "transferFrom", "outputs": [], "stateMutability": "nonpayable", "type": "function" } ],
      //ArtTokens Address
      contract_artToken_address: "0x663690dB484f2f819533D6A1771a630A9FB02062",
      ArtTokenInstance: "",
			accounts: "",
			artistAccount: "",
      name:"",
      description:"",
      nftImage: "",
      nftCollection:[]
    }),
    created: function () {
			var that = this;
      that.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:7545"));

      async function start() {
        // Get all the accounts
        that.accounts = await that.web3.eth.getAccounts();
        // var auctionOwnerAccount = accounts[1]
        that.artistAccount = that.accounts[0];

          //Instance Contracts
        that.ArtTokenInstance = new that.web3.eth.Contract(that.contract_artToken_abi, that.contract_artToken_address);

					// Get name ArtToken
          /* ArtTokenInstance.methods.name().call(function(error, result){
            if(!error){
                console.log("name: ", result);
            }
            else
                console.error("name error: ", error);
          }); */

          // Get symbol ArtToken
          /* ArtTokenInstance.methods.symbol().call(function(error, result){
            if(!error){
                console.log("symbol: ", result);
            }
            else
                console.error("symbol error: ", error);
          }); */

          /* // Mint new NFT ArtToken
          ArtTokenInstance.methods.mint(artistAccount, "HashExample2").send({from: artistAccount}, function(error, result){
            if(!error){
                console.log("mint result: ", result);
            }
            else
                console.error("mint error: ", error);
          }); */
      }

      start();

    },
    methods:{
      sendNFT () {
        // Mint new NFT ArtToken
				// var that = this;
        /* this.ArtTokenInstance.methods.mint(this.artistAccount, "HashExample2").send({from: this.artistAccount,  gas: 300000}, function(error, result){
          if(!error){
						console.log("mint result: ", result);
						that.nftCollection.push(that.getNFTUri());
          }
          else
              console.error("mint error: ", error);
        }); */
				this.searchForNFT();
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
				this.ArtTokenInstance.methods.tokenURI(tokenIndex).call(function(error, result){
					if(!error){
							console.log("tokenUri: ", result);
							that.nftCollection.push( result );
					}
					else
							console.error("tokenUri error: ", error);
				});
			},
			searchForNFT(){
				for (let index = 0; index < 8; index++) {
					this.getNFTUri(index);					
				}
			}
    }
  }
</script>
