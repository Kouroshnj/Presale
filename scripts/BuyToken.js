const connector = require("../utils/connector");
const { ethers } = require('hardhat');


async function BUY() {
    const [owner, addr1] = await ethers.getSigners();
    // console.log(owner);
    const contract = await connector();
    const amount = "4000000000000000000000000";
    const func = await contract.connect(owner).BuyToken(amount, { value: "70250857355873378" })
    console.log(func);
}
BUY();
//70250857355873378