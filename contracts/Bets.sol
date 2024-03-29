// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./interface/IWeb3BetsBetsV1.sol";
import "./interface/IWeb3BetsMarketV1.sol";
import "./interface/IWeb3BetsEventsV1.sol";
import "./interface/IWeb3BetsPoolsV1.sol";

/// @author Ibekason Alexander Onyebuchi
/// @title Bet Contract
/// @notice Contain function signatures for creating bets in a
/// pool

contract Bets is IWeb3BetsBetsV1 {
    address public better;

    address public eventAddress;

    address public marketAddress;

    address public poolAddress;

    uint256 public stake;

    modifier onlyEventOwner() {
        IWeb3BetsEventV1 betEvent = IWeb3BetsEventV1(eventAddress);
        require(
            tx.origin == betEvent.getEventOwner(),
            "Only bet owners can apply this function"
        );

        _;
    }

    modifier onlyBetter() {
        require(
            tx.origin == better,
            "Only event better can call this function"
        );
        _;
    }

    constructor(
        address _eventAddress,
        address _marketAddress,
        address _poolAddress,
        uint256 _stake,
        address _better
    ) {
        eventAddress = _eventAddress;
        marketAddress = _marketAddress;
        stake = _stake;
        better = _better;
        poolAddress = _poolAddress;
    }

    function getBetStake() external view override returns (uint256) {
        return stake;
    }

    function getBetter() external view override returns (address) {
        return better;
    }

    function getBetPoolAddress() external view override returns (address) {
        return poolAddress;
    }

    function getBetMarketAddress() external view override returns (address) {
        return marketAddress;
    }

    function getBetEventAddress() external view override returns (address) {
        return eventAddress;
    }
 
    function withdraw() external override onlyBetter {
        require(address(this).balance > 0, "This bet has no funds");

        // IWeb3BetsEventV1 eventV1 = IWeb3BetsEventV1(eventAddress);
        // uint256 status = eventV1.getEventStatus();

        // // its not equal to pending or started
        // if (status == 0 && status == 1) {
        //     revert(
        //         "An event must be cancelled or ended to withdraw funds and earnings"
        //     );
        // }

        // IWeb3BetsMarketV1 marketV1 = IWeb3BetsMarketV1(marketAddress);
        // bool isWinningPool = marketV1.isWinningPool(poolAddress);
        // if (!isWinningPool) {
        //     revert("You lost this bet");
        // }

        payable(msg.sender).transfer(address(this).balance);
    }

    fallback() external payable {}

    receive() external payable {}
}
