<template>
	<v-container>
	<v-row>
		<v-col xs="6">
			<h2>Create you NFT</h2>
			<v-text-field
				v-model="name"
				label="Name"
				required
			></v-text-field>

			<v-text-field
				v-model="description"
				label="Author Description"
				required
			></v-text-field>
			<v-text-field
				v-model="nftImage"
				label="Art Url"
				required
			></v-text-field>
			<v-btn
				color="success"
				@click="sendNFT"
			>
				Create NFT
			</v-btn>
		</v-col>
		<v-col xs="6">
			<h2>Load the NFTs</h2>
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
	<!-- <v-row>
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
	</v-row> -->
	<v-row>
		<v-col xs="6">
			<h2>Create Auctions</h2>
			<v-text-field v-model="newAuctionMinBidField" label="Enter Minimum Bid increment"></v-text-field>
			<v-text-field v-model="newAuctionStartBlockField" label="Enter Start Block"></v-text-field>
			<v-text-field v-model="newAuctionEndBlockField" label="Enter End Block"></v-text-field>
			<v-text-field v-model="newAuctionHash" label="Enter Auction Hash"></v-text-field>

			<v-btn color="yellow lighten-3" @click="createAuction" >
				Create Auction
			</v-btn>

		</v-col>
		<v-col xs="6">
			<h2>Load Auctions</h2>
			<v-text-field
				v-model="findex"
				label="Select Auction index"
			></v-text-field>
			<v-btn
				color="success"
				@click="getAuctionAddresses"
			>
				Load Auction Address
			</v-btn>
			{{auctionCollection}}
		</v-col>
		<v-col xs="6">
			<h2>Interact with the Auctions</h2>
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
			
		</v-col>
		
	</v-row>
	<v-row>
		<v-col
		xs="12"
		sm="12"
		md="6"
		lg="4"
		xl="3"
		v-for="(auction, index) in auctionCollection" :key="index"
		>
			<v-label class="">Symbol: {{auction.nftSymbol}}</v-label><br>
			<v-label class="">Bid: {{auction.highestBid}}</v-label><br>
			<v-label class="">Endblock: {{auction.endBlock/(60*60)}} hours</v-label><br>
			<v-btn
				color="red lighten-3"
				@click="placeBid(index)"
			>
				Bid
			</v-btn>
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
//   import TokenCard from './TokenCard';
  // import VueMetamask from 'vue-metamask';
  import Web3 from 'web3';
  import Abis from '../abi.js';
  import Address from '../address.js';
  
  export default {
    name: 'Store',
    components: {
    //   TokenCard,
      // VueMetamask
    },
    data: () => ({
		// New Auction Form fields
		newAuctionMinBidField: 1,
		newAuctionStartBlockField: 1,
		newAuctionEndBlockField: 999,
		newAuctionHash:  "{\"name\":\"Example Art\",\"description\":\"Description of this artistic representation\",\"url\":\"https://img.freepik.com/free-photo/old-wooden-door-with-bougainvillea_1401-306.jpg?w=1380\"}" ,
		msg: "This is a demo metamask work",
		web3: "",
		ArtTokenInstance: "",
		AuctionInstance: "",
		accounts: "",
		artistAccount: "",
		bidderAccount: "",
		// New Art Token Form fields
		name:"Example Art",
		description:"Description of this artistic representation",
		nftImage: "https://img.freepik.com/free-photo/old-wooden-door-with-bougainvillea_1401-306.jpg?w=1380",
		nftName: "",
		NFTindex: "",
		findex: 0,
		nftCollection:[],
		auctionCollection:[]
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
        that.ArtTokenInstance = new that.web3.eth.Contract(Abis.contract_artToken_abi, Address.contract_artToken_address);
        that.AuctionInstance = new that.web3.eth.Contract(Abis.contract_auction_abi, Address.contract_auction_address);
		that.FactoryInstance = new that.web3.eth.Contract(Abis.contract_factory_abi, Address.contract_factory_address);

        // Get name ArtToken
        /* that.ArtTokenInstance.methods.name().call(function(error, result){
          if(!error){
              that.nftName = result;
          }
          else
              console.error("name error: ", error);
        }); */

          // Get symbol ArtToken
          that.ArtTokenInstance.methods.symbol().call(function(error, result){
            if(!error){
                that.nftName = result;
            }
            else
                console.error("symbol error: ", error);
          });
      }

      start();

          //Contracts Address
          
          // var contract_ownable_abi= "0x46bB1BD959C071f5e2bE4D20F3e869FaC6BA69Ad";
          // var contract_art_abi= "0x263BDDcC5b330d6D736d87736f329cd788998a61";
              

          //Instance Contracts

          // Get Bid Increment
          /* AuctionInstance.methods.bidIncrement().call(function(error, result){
            if(!error){
                console.log("bidIncrement: ", result);
            }
            else
                console.error("bidIncrement error: ", error);
          }); */

          // Get Owner
          /* AuctionInstance.methods.owner().call(function(error, result){
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
			var jsonData = JSON.stringify(
				{
					name: this.name,
					description: this.description,
					url: this.nftImage
				}
			);
			this.ArtTokenInstance.methods.mint(this.artistAccount, jsonData).send({from: this.artistAccount,  gas: 300000}, function(error, result){
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
			this.ArtTokenInstance.methods.tokenURI(tokenIndex).call(function(error, result){
				if(!error){
						console.log("tokenUri: ", result);
						that.nftCollection.push( result );
				}
				else
						console.error("tokenUri error: ", error);
			});
		},
		loadNFTByIndex(){
			this.getNFTUri(this.NFTindex);
		},
		getNFTHash(auctionObject, index){
			var that = this;
			auctionObject.methods.ntfHash().call(function(error, result){
			if(!error){
				that.auctionCollection[index].nftSymbol = result;
			}
			else
				console.error("ntfHash error: ", error);
			});

		},
		async getEndBlock(auctionObject, index){
			var that = this;
			var leftTime;
			const currentBlockNumber = await this.web3.eth.getBlockNumber();
			console.log(currentBlockNumber)
			auctionObject.methods.endBlock().call(function(error, result){
			if(!error){
				leftTime = (result-currentBlockNumber)*15;
				that.auctionCollection[index].endBlock = leftTime;
			}
			else
				console.error("ntfHash error: ", error);
			});

		},
		placeBid(index){		
			var newAuctionObject = new this.web3.eth.Contract(Abis.contract_auction_abi, this.auctionCollection[index].contractAddress);
			// Send Place Bid
			newAuctionObject.methods.placeBid().send( {from: this.bidderAccount, gas: 300000, value: 2}, function(error, result){
				if(!error){
					console.log("placeBid:", result);
				}
				else
					console.error("placeBid:", error);
			});
			this.getHighestBid(newAuctionObject, index);
		},
		getHighestBidder(){
			// Get highest Bidder
			this.AuctionInstance.methods.highestBidder().call(function(error, result){
				if(!error){
					console.log("highestBidder: ", result);
				}
				else
					console.error("highestBidder error: ", error);
			});
		},
		getHighestBid(auctionObject, index){
			// Get highest Bid
			var that = this;
			auctionObject.methods.getHighestBid().call(function(error, result){
				if(!error){
					that.auctionCollection[index].highestBid = result;
				}
				else
					console.error("getHighestBid error: ", error);
			});
		},
		createAuction(){
			this.FactoryInstance.methods.createAuction(this.newAuctionMinBidField, this.newAuctionStartBlockField, this.newAuctionEndBlockField, JSON.stringify(this.newAuctionHash))
			.send( {from: this.artistAccount, gas: 3000000}, function(error, result){
				if(!error){
					console.log("New Auction Address: ", result);
				}
				else
				console.error("New Auction error: ", error);
			});
		},
		getAuctionAddresses(){
			var that=this;
			var data = {
				nftSymbol: "<loading name>",
				contractAddress: "",
				highestBid: 0,
				endBlock: 0
			};
			this.FactoryInstance.methods.getaActionByIndex(0).call(function(error, result){
				if(!error){
					data.contractAddress = result;
					that.auctionCollection.push( data );
					that.instanceAuction();
				}
				else
				console.error("New Auction error: ", error);
			});
		},
		instanceAuction(){
			var that=this;
			var newAuctionObject;
			this.auctionCollection.forEach( (e, i) => {
				newAuctionObject = new this.web3.eth.Contract(Abis.contract_auction_abi, e.contractAddress);
				that.getHighestBid(newAuctionObject, i);
				that.getNFTHash(newAuctionObject, i);
				that.getEndBlock(newAuctionObject, i);
			});
		}
    }
  }
</script>
