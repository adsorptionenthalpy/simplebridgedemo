## Summary
This protocol contains a single oracle and bridge, representing an incorrectly authored contract or system of compromised oracles on the bridge. </br>
Reliance on a single manipulatable oracle can allow an atacker to inflate the assets price artificially which will mint a disproportional amount of wrapped assets.  </br>
If the oracle's price feed is sourced from a DEX with low liquidity then the executor can manipulate the price with large traders, </br>
which will lead to inflated minting and runaway draining of the DEX's treasury accounts. </br>
</br>
### Precondition:  </br>
The oracle returns a price scaled by 1e18 </br>
The contract converts locked asset amounts to wrapped tokens using the price provided by the oracle </br>
The contract assumes the asset is ETH for simplicity and the wrapped tokens are minted proportionally to USD value </br>

### Exploit Instructions: </br>
1- Confirm the asset price is being fetched from a low liquidity dex </br>
2- Manipulate the oracle price by executing large buy orders for ETH using a stablecoin to artificially inflate the ETH price. This requires a lot of capital (borrow against your assets or supply  your own funds) </br>
3- Call wrap, deposit a small amount of ETH into the wrap function and path the fee. If the price has been inflated correctly, the contract will mint more tokens than expected. </br>
4- Swap the wrapped tokens for profit before the oracle system has a chance to readjust the price.  </br>
</br>
### Mitigation strategies:</br>
1- Require oracle consensus from multiple price feeds</br>
2- Add a challenge period for minting large amounts of wrapped assets</br>
3- Implement a cap on price deviation (reject extreme fluctuations in price over certain periods)</br>
</br>
