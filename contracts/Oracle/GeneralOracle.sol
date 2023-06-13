// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/access/Ownable.sol";

contract GeneralOracle is Ownable {
    enum RequestType {
        WEATHER,
        MARKET,
        TRRAFIC //,...
    }

    uint jobId;

    mapping(address => bool) private admins;
    mapping(uint => bool) private jobStatus;
    mapping(uint => string) private jobResults;

    //event to trigger Oracle API
    event NewJobArrived(
        RequestType indexed reqType,
        uint indexed jobId,
        string payload
    );

    modifier restricted() {
        if (admins[msg.sender] == true) _;
    }

    constructor(uint initialId) Ownable() {
        jobId = initialId;
    }

    function requestUpdateVariable(
        RequestType reqType,
        string memory payload
    ) external returns (uint) {
        emit NewJobArrived(reqType, jobId, payload);
        jobId++;
        return jobId;
    }

    function updateVariable(
        string memory temp,
        uint _jobId
    ) external restricted {
        //when update weather is called by node.js upon API results, data is updated
        jobResults[_jobId] = temp;
        jobStatus[_jobId] = true;
    }

    function getStatusAndResult(
        uint _jobId
    ) external view returns (bool, string memory) {
        return (jobStatus[_jobId], jobResults[_jobId]);
    }

    function addAdmin(address newAdmin) external onlyOwner {
        admins[newAdmin] = true;
    }

    function removeAdmin(address oldAdmin) external onlyOwner {
        admins[oldAdmin] = false;
    }
}
