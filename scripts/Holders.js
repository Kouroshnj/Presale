const connector = require("../utils/connector");
const { ethers } = require('hardhat');

async function Holders() {
    const contract = await connector();
    const data = await contract.HoldersData("1");
    console.log(data);
}
Holders();