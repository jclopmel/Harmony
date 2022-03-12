# Harmony project

Auction Blockchain project based in the auction of NFTs.

## Project setup
```bash
npm install
```

### Compiles and hot-reloads for development
1. Compiles and hot-reloads for development
```bash
npm run serve
```
2. 

### Once It is running...
1. Compile and deploy next contracts in your network to start working with the project:
- ArtToken.sol
- AuctionToken.sol
- FactoryAuction.sol

2. Fill in result contract addresses once deployed, to interact with them in /src/address.js file.

3. Possible actions to be triggered by the contract:
- To create NFT
- To see next parameters from the NFT: name, description, URI
- To create Auctions
- To see next parameters from the Auction: name, highest bid, bid left time
- Both are accesible by unique incremental index or their contract addresses
- To bid individually per Auction

### Compiles and minifies for production
```
npm run build
```

### Lints and fixes files
```
npm run lint
```

### Customize configuration
See [Configuration Reference](https://cli.vuejs.org/config/).

