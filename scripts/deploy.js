const { ethers } = require("hardhat");
const fs = require('fs');
const { mint } = require("./deployQST");

async function main() {
  const [deployer] = await ethers.getSigners();
  const addresses = await mint()
  fs.writeFileSync("./data/addresses.json", JSON.stringify(addresses));
  const ICO_Contract = await ethers.getContractFactory("ICO");
  const contract = await ICO_Contract.deploy(addresses.QST);
  console.log("ICO address is:", contract.address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
