<template>
	<v-container>
	<v-row>
		<v-col xs="6">
			<v-card class="pa-3" elevation="2" outlined>
				<h2>Create your NFT</h2>
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
					dark
					@click="sendNFT"
				>
					Create NFT
				</v-btn>
			</v-card>
		</v-col>
		<v-col xs="6">
			<v-card class="pa-3" elevation="2" outlined>
				<h2>Create Auctions</h2>
				<v-text-field v-model="newAuctionMinBidField" label="Enter Minimum Bid increment"></v-text-field>
				<v-text-field v-model="newAuctionStartBlockField" label="Enter Start Block"></v-text-field>
				<v-text-field v-model="newAuctionEndBlockField" label="Enter End Block"></v-text-field>
				<v-text-field v-model="newAuctionHash" label="Enter Auction Hash"></v-text-field>

				<v-btn dark @click="createAuction" >
					Create Auction
				</v-btn>
			</v-card>

		</v-col>
	</v-row>
	<v-row>
		<v-col xs="6">
			<v-card class="pa-3" elevation="2" outlined>
				<h2>Load the NFTs</h2>
				<v-text-field
					v-model="NFTindex"
					label="Index to load NFT"
				></v-text-field>
				<v-btn dark @click="loadNFTByIndex">
					Load NFT
				</v-btn>
				{{nftCollection}}
			</v-card>
		</v-col>
		<v-col xs="6">
			<v-card class="pa-3" elevation="2" outlined>
				<h2>Load Auctions</h2>
				<v-text-field
					v-model="findex"
					label="Select Auction index"
				></v-text-field>
				<v-btn dark @click="getAuctionAddresses(findex)">
					Load Auction Address
				</v-btn>
			</v-card>
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
			<v-card
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
					:src=auction.url
				></v-img>
				<v-card-title>{{auction.name}}</v-card-title>

				<v-card-text>
					<div>
					{{auction.description}} <br>
					<b>Minimum bid:</b> {{auction.bidIncrement}}
					</div>
				</v-card-text>

				<v-divider class="mx-4"></v-divider>
				<v-row class="mx-3 my-3">
					<v-col xs="6">
						<v-btn color="yelow lighten-3" @click="placeBid(index)" >
							Bid
						</v-btn>
						<v-btn color="red lighten-3" @click="cancelAuction(index)" >
							Cancel!
						</v-btn>
						<v-btn color="green lighten-3" @click="withdraw(index)" >
							withdraw
						</v-btn>
					</v-col>
					<v-col xs="6">
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
								{{ auction.highestBid }}
							</v-chip>
						</v-card-text>
					</v-col>
				</v-row>

				<v-card-actions>
					<v-btn color="teal lighten-2" block text>
						<v-progress-circular
							class="mr-3"
							:rotate="360"
							:size="20"
							:width="2"
							color="teal"
							:value="75"
						>
							{{ ((auction.endBlock)/(60)).toFixed(0) }}
						</v-progress-circular>
						hours left
					</v-btn>
				</v-card-actions>
			</v-card>


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
  // import VueMetamask from 'vue-metamask';
  import Web3 from 'web3';
  import Abis from '../abi.js';
  import Address from '../address.js';
  
  export default {
    name: 'Store',
    components: {
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
			var decodedResult;
			auctionObject.methods.ntfHash().call(function(error, result){
			if(!error){
				try {
					decodedResult = JSON.parse(JSON.parse(result));
					
					that.auctionCollection[index].name =  that.nftName+" | "+decodedResult.name;
					that.auctionCollection[index].description = decodedResult.description;
					that.auctionCollection[index].url = decodedResult.url;
					
				} catch (error) {
					console.log("Fail in JSON format:", error, decodedResult)
				}
			}
			else
				console.error("ntfHash error: ", error);
			});

		},
		async getEndBlock(auctionObject, index){
			var that = this;
			var leftTime;
			const currentBlockNumber = await this.web3.eth.getBlockNumber();

			auctionObject.methods.endBlock().call(function(error, result){
			if(!error){
				leftTime = (result-currentBlockNumber)*15;
				that.auctionCollection[index].endBlock = leftTime;
			}
			else
				console.error("endBlock error: ", error);
			});

		},
		getBidIncrement(auctionObject, index){
			var that = this;

			auctionObject.methods.bidIncrement().call(function(error, result){
			if(!error){
				that.auctionCollection[index].bidIncrement = result;
			}
			else
				console.error("bidIncrement error: ", error);
			});

		},
		isCanceled(index){
			var newAuctionObject = new this.web3.eth.Contract(Abis.contract_auction_abi, this.auctionCollection[index].contractAddress);

			newAuctionObject.methods.canceled().call(function(error, result){

				if(!error){
					return result;
				}
				else{
					console.error("canceled:", error);
				}
			});
		},
		placeBid(index){
			var that = this;		
			var newAuctionObject = new this.web3.eth.Contract(Abis.contract_auction_abi, this.auctionCollection[index].contractAddress);

			newAuctionObject.methods.canceled().call(function(error, cancel){
				if(!error){

					console.log("canceled:", cancel);
					
					if(!cancel){
						// Send Place Bid
						newAuctionObject.methods.placeBid().send( {from: that.bidderAccount, gas: 300000, value: 2}, function(error, result){
							if(!error){
								console.log("placeBid:", result);
							}
							else
								console.error("placeBid:", error);
						});
						that.getHighestBid(newAuctionObject, index);
					}

				}
				else
					console.error("canceled:", error);
			});


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
		cancelAuction(index){
			var newAuctionObject = new this.web3.eth.Contract(Abis.contract_auction_abi, this.auctionCollection[index].contractAddress);
			console.log("Canceling Auction:", this.auctionCollection[index].contractAddress)
			newAuctionObject.methods.cancelAuction().send( {from: this.artistAccount,  gas: 3000000}, function(error, result){
				if(!error){
					console.log("cancelAuction:", result);
				}else{
					console.error("cancelAuction:", error);
				}
			});
		},
		withdraw(index){
			var newAuctionObject = new this.web3.eth.Contract(Abis.contract_auction_abi, this.auctionCollection[index].contractAddress);

			newAuctionObject.methods.withdraw().send( {from: this.bidderAccount, gas: 3000000, value: 1}, function(error, result){
				if(!error){
					console.log("withdraw success:", result);
				}else{
					console.error("withdraw failure:", error);
				}
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
		getAuctionAddresses(findex){
			var that=this;
			var data = {
				name: "<loading name>",
				description: "<loading description>",
				img: "",
				contractAddress: "",
				highestBid: 0,
				endBlock: 0,
				bidIncrement: 0
			};
			this.FactoryInstance.methods.getaActionByIndex(findex).call(function(error, result){
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
				that.getBidIncrement(newAuctionObject, i);
			});
		}
    }
}
</script>
