const { ethers } = require("hardhat");
const ICO = "ICO";

async function ICO_Contract() {
    const [deployer] = await ethers.getSigners();
    // console.log("Account balance is:", (await deployer.getBalance()).toString());
    const ICOcontract = await ethers.getContractFactory(ICO);
    const contract = await ICOcontract.deploy();
    contract.deployed()
    console.log("ICO:", contract.address);
}
module.exports = {
    ICO_Contract
};