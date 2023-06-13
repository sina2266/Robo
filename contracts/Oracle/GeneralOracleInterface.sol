// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface GeneralOracleInterface {
    enum RequestType {
        WEATHER,
        MARKET,
        TRRAFIC //,...
    }

    function requestUpdateVariable(
        RequestType reqType,
        string memory payload
    ) external returns (uint);

    function updateVariable(string memory temp, uint _jobId) external;

    function getStatusAndResult(
        uint _jobId
    ) external view returns (bool, string memory);

    function addAdmin(address newAdmin) external;

    function removeAdmin(address oldAdmin) external;
}
