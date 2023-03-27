// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./utils/Error.sol";
import "./utils/ChainlinkOracle.sol";

pragma solidity ^0.8.0;

contract ICO is Error, ChainlinkOracle, ReentrancyGuard {
    IERC20 public token;

    using SafeMath for uint256;

    uint priceOfSingleToken; // USD, Updatable
    uint Inflation; // 5%, Updatable

    uint public Minimum; // Updatable
    uint public Maximum; // Updatable

    uint LimitedSaledTokens;
    uint public TotalInflation;
    uint public TotalSupply;
    uint Index;

    mapping(uint => Holders) public HoldersWithIndex;
    mapping(uint => address) public UserAddress;
    mapping(address => uint) public UserIndex;
    mapping(address => Holders) public HoldersWithAddress;

    constructor(address _token) {
        token = IERC20(_token);
        Minimum = 4000000 * 10 ** 18;
        Maximum = 40000000 * 10 ** 18;
        LimitedSaledTokens = 240000000 * 10 ** 18;
        Inflation = 5;
        priceOfSingleToken = 0.000005 ether;
    }

    struct Holders {
        address User;
        uint amountOfHold;
        uint Alltransactions;
        uint MoneyToContract;
    }

    modifier AtLeast(uint _amountOfTokens) {
        require(
            _amountOfTokens >= Minimum && _amountOfTokens <= Maximum,
            "Atleast_ERROR"
        );
        _;
    }

    modifier UserBalance() {
        require(
            HoldersWithAddress[msg.sender].amountOfHold < Maximum,
            "balance_ERROR"
        );
        _;
    }

    function preSale(
        uint256 amount,
        string memory _password
    ) public onlyOwner(_password) returns (uint) {
        token.transferFrom(msg.sender, address(this), amount);
        TotalSupply += amount;
        return amount;
    }

    receive() external payable {}

    function GetPriceInBNB(uint _PriceInUSD) public pure returns (uint) {
        uint256 USDprice = getlatestCustomePrice();
        uint256 calculated = SafeMath.mul(_PriceInUSD, 10 ** 18);
        uint256 PriceInBNB = SafeMath.div(calculated, USDprice);
        return PriceInBNB;
    }

    function Calculator(uint amountOfTokens) public view returns (uint) {
        uint PriceOfTokensInUSD = SafeMath.mul(
            amountOfTokens,
            priceOfSingleToken
        );
        uint BNBpriceInUSD = getlatestCustomePrice();
        uint totalAmountInBNB = SafeMath.div(PriceOfTokensInUSD, BNBpriceInUSD);
        return totalAmountInBNB;
    }

    function GiveBNBGetTokens(uint _PriceInBNB) public view returns (uint) {
        uint BNBToUSD = getlatestCustomePrice();
        uint calculated = SafeMath.mul(_PriceInBNB, BNBToUSD);
        uint AmountOfTokens = SafeMath.div(calculated, priceOfSingleToken);
        return AmountOfTokens;
    }

    function GiveBNBGetUSD(uint _PriceInBNB) public pure returns (uint) {
        uint BNBtoUSD = getlatestCustomePrice();
        uint calculate = SafeMath.mul(BNBtoUSD, _PriceInBNB);
        uint RealPrice = SafeMath.div(calculate, 10 ** 18);
        return RealPrice;
    }

    function BuyToken(
        uint amount
    ) public payable nonReentrant AtLeast(amount) returns (uint) {
        uint TransactionIndex = 1;
        // address user = HoldersWithIndex[Index].User;
        address payable _to = payable(address(this));
        uint PriceOfTokensInBNB = Calculator(amount);
        require(msg.value >= PriceOfTokensInBNB, "BuyToken_Error!!!!");
        (bool sent, ) = _to.call{value: msg.value}("");
        require(sent, "Failed to send BNB");
        // UserAddress[Index] = msg.sender;
        if (UserIndex[msg.sender] > 0) {
            uint userindex = UserIndex[msg.sender];
            uint balance = HoldersWithIndex[userindex].amountOfHold;
            uint LastValue = HoldersWithIndex[userindex].MoneyToContract;
            uint LastIndex = HoldersWithIndex[userindex].Alltransactions;
            HoldersWithIndex[userindex] = Holders({
                User: msg.sender,
                amountOfHold: balance + amount,
                Alltransactions: LastIndex + TransactionIndex,
                MoneyToContract: LastValue + msg.value
            });
        } else if (UserIndex[msg.sender] == 0) {
            Index++;
            UserIndex[msg.sender] = Index;
            uint userindex = UserIndex[msg.sender];
            HoldersWithIndex[userindex] = Holders({
                User: msg.sender,
                amountOfHold: amount,
                Alltransactions: TransactionIndex,
                MoneyToContract: msg.value
            });
        }
        TotalInflation += amount;
        if (TotalInflation >= LimitedSaledTokens) {
            Minimum -= (Minimum * Inflation) / 100;
            Maximum -= (Maximum * Inflation) / 100;

            uint Condition = SafeMath.sub(TotalInflation, LimitedSaledTokens);
            TotalInflation = 0;
            TotalInflation += Condition;
        }
        uint _Limited = 240000000 * 10 ** 18 - TotalInflation;
        token.transfer(msg.sender, amount);
        return _Limited;
    }

    function ChangePriceOfSingletoken(
        uint _NewAmount,
        string memory _password
    ) public onlyOwner(_password) returns (uint) {
        priceOfSingleToken = _NewAmount;
        return priceOfSingleToken;
    }

    function UpdateInflation(
        uint _NewInflation,
        string memory _password
    ) public onlyOwner(_password) returns (uint) {
        Inflation = _NewInflation;
        return Inflation;
    }

    function UpdateMinimumMaximum(
        string memory _password,
        uint _NewMinimum,
        uint _NewMaximum
    ) public onlyOwner(_password) returns (uint, uint) {
        Minimum = _NewMinimum * 10 ** 18;
        Maximum = _NewMaximum * 10 ** 18;
        return (Minimum, Maximum);
    }

    function Withdraw(string memory _password) public onlyOwner(_password) {
        address payable _to = payable(msg.sender);
        _to.transfer(address(this).balance);
    }

    function CancelTotalSupply(
        string memory _password,
        uint amount
    ) public onlyOwner(_password) {
        TotalSupply -= amount;
    }

    function ChangeOwner(
        string memory _password,
        address _NewOwner
    ) public onlyOwner(_password) {
        owner = _NewOwner;
    }

    function MinAndMax() public view returns (uint, uint) {
        return (Minimum, Maximum);
    }

    function HoldersData(uint index) public view returns (Holders memory) {
        return HoldersWithIndex[index];
    }
}
