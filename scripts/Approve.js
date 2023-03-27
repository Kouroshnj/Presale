const connectorQST = require("../utils/connectorQST");
const { ethers } = require('hardhat');

async function Approve() {
    const [signer] = await ethers.getSigners();

    const QST = await connectorQST();
    const Approve = await QST.connect(signer).approve("0x9E545E3C0baAB3E08CdfD552C960A1050f373042", "1200000000000000000000000000000");
    return Approve;
}
Approve();