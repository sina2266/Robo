// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract SMToken is ERC20 {
    using SafeMath for uint256;

    uint256 internal reserveBalance;
    uint8 constant DECIMALS = 1;

    constructor() ERC20("SinaMirshafieiToken", "SMT") {
        _mint(msg.sender, 1);
        reserveBalance = 1; //Charge the smart contract at the begining
    }

    function buyTokens() public payable {
        require(
            msg.value > 0,
            "You need to send some Ether to purchase tokens."
        );

        uint256 amountToMint = calculatePurchaseAmount(msg.value);
        require(amountToMint > 0, "Insufficient Ether sent.");

        _mint(msg.sender, amountToMint);
        //        totalSupply += amountToMint;
        reserveBalance += msg.value;
    }

    function sellTokens(uint256 amount) public {
        require(amount > 0, "You need to specify an amount of tokens to sell.");
        require(amount <= balanceOf(msg.sender), "Insufficient balance.");

        uint256 refundAmount = calculateSaleRefund(amount);
        require(refundAmount > 0, "Insufficient token balance.");

        _burn(msg.sender, amount);
        //totalSupply -= amount;
        reserveBalance -= refundAmount;

        (bool success, ) = payable(msg.sender).call{value: refundAmount}("");
        require(success, "Failed to send Ether.");
    }

    function calculatePurchaseAmount(
        uint256 amount
    ) public view returns (uint256) {
        uint256 newTotal = totalSupply().add(amount);
        uint256 newPrice = ((newTotal * newTotal) / DECIMALS) *
            (newTotal / DECIMALS);

        return (sqrt(newPrice) * 2) / 3 - reserveBalance;
    }

    function calculateSaleRefund(uint256 amount) public view returns (uint256) {
        uint256 newTotal = totalSupply().sub(amount);
        uint256 newPrice = ((newTotal * newTotal) / DECIMALS) *
            (newTotal / DECIMALS);

        return reserveBalance - (sqrt(newPrice) * 2) / 3;
    }

    function sqrt(uint256 x) internal pure returns (uint256 y) {
        uint256 z = (x + 1) / 2;
        y = x;
        while (z < y) {
            y = z;
            z = (x / z + z) / 2;
        }
    }
}
