const { ethers } = require('ethers');
const fs = require('fs');
const path = require('path');

const provider = new ethers.WebSocketProvider('wss://cacib-saturn-test.francecentral.cloudapp.azure.com:9443');
const wallet = new ethers.Wallet('[YOUR_WALLET_PRIVATE_KEY_HERE]', provider);

const compiledContracts = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'contracts', 'combined.json'), 'utf8'));

async function deploy() {
  const contractData = compiledContracts.contracts['src/VariableRateRegister.sol:VariableRateRegister'];
  const factory = new ethers.ContractFactory(contractData.abi, contractData.bin, wallet);

  const args = {
    name: "Bondify v1",
    isin: "FR0000123455", // End digit is 5 because it's the sum mod 10 of other digits (see https://www.isin.org/isin/)
    expectedSupply: 1000000n,
    currency: ethers.encodeBytes32String("EUR"),
    unitVal: 100n,
    couponRate: 5n,
    creationDate: Math.floor(Date.now() / 1000),
    issuanceDate: Math.floor(Date.now() / 1000) + 60*60*24, // Bond will exist in 1 day
    maturityDate: Math.floor(Date.now() / 1000) + 60*60*24 + 60*60*24*365*3 + 60*60*48, // Bond will mature 3 years after issuance
    couponDates: [
        Math.floor(Date.now() / 1000) + 60*60*24 + 60*60*24*365*1, // 1 year after issuance
        Math.floor(Date.now() / 1000) + 60*60*24 + 60*60*24*365*2, // 2 years after issuance
        Math.floor(Date.now() / 1000) + 60*60*24 + 60*60*24*365*3, // 3 years after issuance
    ],
    cutOffTime: 60*60*12 // 12 hours
  }
  const contract = await factory.deploy(
    args.name,
    args.isin,
    args.expectedSupply,
    args.currency,
    args.unitVal,
    args.couponRate,
    args.creationDate,
    args.issuanceDate,
    args.maturityDate,
    args.couponDates,
    args.cutOffTime
  );

  console.log('Contract deployed at address:', contract.target);
  console.log(contract);
}

deploy().catch(console.error);
