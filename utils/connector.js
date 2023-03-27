const { ethers } = require('hardhat');
const abi = require("../artifacts/contracts/ICO.sol/ICO.json").abi;
var address = "0x9E545E3C0baAB3E08CdfD552C960A1050f373042";
async function run() {
    var [signer] = await ethers.getSigners();
    var contract = new ethers.Contract(address, abi, signer.provider);
    return contract;
}
module.exports = run;
