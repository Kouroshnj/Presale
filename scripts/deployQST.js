const QST = "QST";
const { ethers } = require('hardhat');

async function mint() {
    const [deployer] = await ethers.getSigners();

    const QST_Contract = await ethers.getContractFactory(QST);
    const contract = await QST_Contract.deploy();
    contract.deployed()
    console.log("QST address is:", contract.address);

    let contractAddress = {}
    contractAddress["QST"] = contract.address;
    return contractAddress;
}
module.exports = {
    mint
};