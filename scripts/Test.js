const connector = require('../utils/connect');

async function ListingFee() {
    const contract = await connector()
    const amount = "2"
    const fee = await contract.ListingFeeWithBNB(amount)
    console.log(fee.toString());
}
ListingFee()