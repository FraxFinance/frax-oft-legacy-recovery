# Frax OFT Legacy Recovery

## Introduction
An ERC20 token of Frax Protocol may have a different address depending on the chain:
- Ethereum mainnet: Address of original deployment
- Fraxtal: pre-set proxy address
- "Legacy" LayerZero: same address across Base, Metis, and Blast
- "Upgradeable" LayerZero: same address across Mode, Sei, Fraxtal, X-Layer

For example, sFRAX has the address of:
- `0xA663B02CF0a4b149d2aD41910CB81e23e1c41c32`: Ethereum
- `0xfc00000000000000000000000000000000000008`: Fraxtal-native
- `0xe4796cCB6bB5DE2290C417Ac337F2b66CA2E770E`: "Legacy" LayerZero
- `0x5bff88ca1442c2496f7e475e9e7786383bc070c0`: "Upgradeable" LayerZero

## What happened?
1. User goes on Stargate and bridges sFRAX with LayerZero from Blast to Fraxtal.
  - [Tx (LayerZero)](https://layerzeroscan.com/tx/0xa86d0b8b72273b4b5d6599d9476064a2c4b6b025dec27e996bcd64bc5ddc489f)
2. User realizes LayerZero-bridged sFRAX is not the same as Fraxtal-native sFRAX and is not currently supported.
3. User decides to move their LayerZero sFRAX to Base, where they can utilize the active LayerZero sFRAX liquidity.
  - User incorrectly puts the address of the "Upgradeable" LayerZero token as the Base bridge recipient, sending the sFRAX to the wrong address.
  - [Tx (LayerZero)](https://layerzeroscan.com/tx/0x65df498f6feaf0c30a5d4b3c60ed6de7af2d81a43dec50e3c42c15063d5cac5d)

## Technical introduction
When an Ethereum account deploys a contract it may appear that the contract deployed has a randomly-generated address.  However, this address is *deterministic* based on the address of the creator (`sender`) and how many transactions the creator has sent (`nonce`) ([forum link](https://ethereum.stackexchange.com/questions/760/how-is-the-address-of-an-ethereum-contract-computed/761#761))

What's great about this functionality is it applies to all EVM-based chains.  So, if you use a fresh address `A` with its' first submitted transaction as a contract deployment, that contract will have the same address on Ethereum as it will on Fraxtal, Base, Mode, etc. It doesn't matter if the contract is a staking contract on Fraxtal, a NFT on Base, or a DEX on Mode: the address is the same, regardless of its' code.

### Fun Fact
Frax-LZ "Legacy" tokens were all deployed with by an account owned by LayerZero.  Frax-LZ "Upgradeable" are always deployed with an account owned by Frax, guaranteeing:
- future deployments at the same addresses across new chains.
- maximum contract security by keeping the deployer private-key internal to Frax.

## So how did we do it?
The funds were located at an address which, had it been on an "Upgradeable" LayerZero chain, would be the sFRAX OFT (for example, on [Sei](https://seitrace.com/token/0x5Bff88cA1442c2496f7E475E9e7786383Bc070c0)).  Fortunately, as we are looking at a "Legacy" LayerZero chain, the address remained untouched by our deployer.

All our deployer needed to do was deploy a recovery contract at the right `nonce`, populating the address with the recovery code and enabling our team to securely withdraw the tokens.

So, we
- Deployed the recovery contract 10 times, filling up the needed address with contract code
- Called `recover()` on the contract, sending the rescued tokens to the user.

[Link to deployer](https://basescan.org/address/0x9c9dd956b413cdbd81690c9394a6b4d22afe6745)

## Lessons Learned
Frax has some exciting things in store to (a) secure Fraxtal as the hub of Frax token liquidity and (b) solidify the future of omnichain strategy.  As we set everything up behind the scenes, we left the LayerZero sFRAX on Fraxtal visible on Stargate, and users unknowingly bridged to Fraxtal only to realize their LayerZero-branded tokens were not the same as the Fraxtal-native tokens.

We have since contacted Stargate to hide Fraxtal as a LayerZero destination until we finish our diligent work to provide seamless, affordable management of Frax tokens across the EVM, SVM, and beyond.