// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;
import "./IBaseInterface.sol";

interface IWeb3BetsMarketV1 is IBaseInterface{

    function createMarketPool(string memory name) external;

// Setting a winning pool marks a market as finished and cannot be undone
    function setWinningPool(address poolAddress) external;

    function getEventAddress() external returns (address);

    function getEventName() external returns (string memory);

}