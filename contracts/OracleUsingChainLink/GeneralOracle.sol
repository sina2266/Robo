// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@chainlink/contracts/src/v0.8/ConfirmedOwner.sol";

contract APIConsumer is ChainlinkClient, ConfirmedOwner {
    using Chainlink for Chainlink.Request;

    string public response;
    bytes32 private jobId;
    uint256 private fee;

    event RequestResponse(bytes32 indexed requestId, string response);

    constructor(
        address tokenAddress,
        address oracleAddress
    ) ConfirmedOwner(msg.sender) {
        setChainlinkToken(tokenAddress);
        setChainlinkOracle(oracleAddress);
        jobId = "ca98366cc7314957b8c012c72f05aeeb";
        fee = (1 * LINK_DIVISIBILITY) / 10; // 0,1 * 10**18 (Varies by network and job)
    }

    function requestResponseData(
        string memory url
    ) public returns (bytes32 requestId) {
        Chainlink.Request memory req = buildChainlinkRequest(
            jobId,
            address(this),
            this.fulfill.selector
        );

        // Set the URL to perform the GET request on
        req.add("get", url);

        req.add("path", "");

        // Sends the request
        return sendChainlinkRequest(req, fee);
    }

    /**
     * Receive the response in the form of string (json/xml)
     */
    function fulfill(
        bytes32 _requestId,
        string memory _response
    ) public recordChainlinkFulfillment(_requestId) {
        emit RequestResponse(_requestId, _response);
        response = _response;
    }

    /**
     * Allow withdraw of Link tokens from the contract
     */
    function withdrawLink() public onlyOwner {
        LinkTokenInterface link = LinkTokenInterface(chainlinkTokenAddress());
        require(
            link.transfer(msg.sender, link.balanceOf(address(this))),
            "Unable to transfer"
        );
    }
}
