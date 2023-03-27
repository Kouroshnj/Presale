const connector = require("../utils/connector");

async function getBNB() {
    const contract = await connector();
    const amount = "4000000000000000000000000"
    const data = await contract.Calculator(amount);
    console.log(data.toString());
}
getBNB();