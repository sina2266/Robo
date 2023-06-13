// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts (last updated v4.9.0) (token/ERC20/ERC20.sol)

pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract SMTokenInterface is IERC20 {
    function buyTokens() external payable;

    function sellTokens(uint256 amount) external;

    function calculatePurchaseAmount(
        uint256 amount
    ) public view returns (uint256);

    function calculateSaleRefund(uint256 amount) public view returns (uint256);
}
