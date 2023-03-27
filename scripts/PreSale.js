const connector = require("../utils/connector");
const { ethers } = require('hardhat');

async function PreSale() {
    const [signer] = await ethers.getSigners();
    // console.log(signer);
    const contract = await connector();
    const amount = "120000000000000000000000000000";
    const pass = "universe12#@"
    const presale = await contract.connect(signer).preSale(amount, pass)
    console.log(presale);
}
PreSale();