const { ethers } = require('hardhat');
const abi = require("../artifacts/contracts/utils/QST.sol/QST.json").abi;
var { QST } = require('../data/addresses.json');
async function run() {
    var [signer] = await ethers.getSigners();
    var contract = new ethers.Contract(QST, abi, signer.provider);
    return contract;
}
module.exports = run;
