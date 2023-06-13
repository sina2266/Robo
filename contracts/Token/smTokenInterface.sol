// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

abstract contract SMTokenInterface is IERC20 {
    function buyTokens() external payable virtual;

    function sellTokens(uint256 amount) external virtual;

    function calculatePurchaseAmount(
        uint256 amount
    ) public view virtual returns (uint256);

    function calculateSaleRefund(
        uint256 amount
    ) public view virtual returns (uint256);
}
