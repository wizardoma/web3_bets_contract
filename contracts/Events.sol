// SPDX-License-Identifier: MIT

pragma solidity ^0.8.4;

import "./interface/IWeb3BetsEventsV1.sol";
import "./MarketFactory.sol";

import "@openzeppelin/contracts/utils/Strings.sol";

contract Events is IWeb3BetsEventV1 {
    address public eventOwner;

    address public marketFactoryAddress;

    uint256 public minimumStake;

    mapping(address => string) public marketsNames;

    address[] public markets;

    string public name;

    uint constant MINIMUM_STAKE = 10000000000;

    EventStatus public status = EventStatus.PENDING;

    struct EventMarket {
        string marketName;
        address marketAddress;
    }

    function getName() public view override returns (string memory) {
        return name;
    }

    constructor(
        string memory eventName,
        address _marketFactoryAddress,
        uint256 _minimumStake
    ) {
        require(_minimumStake >= MINIMUM_STAKE, "Minimum stake for creating an event must be greater than 10000000000 wei");
        name = eventName;
        marketFactoryAddress = _marketFactoryAddress;
        eventOwner = tx.origin;
        minimumStake = _minimumStake;
    }

    enum EventStatus {
        PENDING,
        STARTED,
        ENDED,
        CANCELED
    }

    modifier onlyOwner() {
        require(
            msg.sender == eventOwner,
            "Event operations only applicable to owner"
        );
        _;
    }

    function createMarket(string memory _name)
        external
        override
        onlyOwner
    {
        // bytes32 marketId = keccak256(abi.encodePacked(eName,Strings.toString(block.timestamp)));

        MarketFactory factory = MarketFactory(marketFactoryAddress);
        address marketAddress = factory.createMarket(
            _name,
            address(this)
        );
        markets.push(marketAddress);
        marketsNames[marketAddress] = name;
    }

    function cancelEvent() external override onlyOwner {
        if (status == EventStatus.CANCELED) {
            revert("Event already canceled");
        } else if (status == EventStatus.ENDED) {
            revert("Event already ended");
        }

        for (uint256 i = 0; i < markets.length; i++) {
            IWeb3BetsMarketV1 marketv1 = IWeb3BetsMarketV1(markets[i]);
            marketv1.cancelMarket();
        }

        status = EventStatus.CANCELED;
    }

    function getMarkets() external view override returns (address[] memory) {
        return markets;
    }

    function getMinimumStake() external view returns (uint256) {
        return minimumStake;
    }

    function getCount() internal view returns (uint256 count) {
        return markets.length;
    }

    function getEventOwner() external view override returns (address) {
        return eventOwner;
    }

    function endEvent() external onlyOwner{
        if (status == EventStatus.CANCELED) {
            revert("Canceled event can not be ended");
        } else if (status == EventStatus.ENDED) {
            revert("Event already ended");
        }

        bool allMarketsAreSettled = false;
        for (uint256 i = 0; i < markets.length; i++) {
            IWeb3BetsMarketV1 marketv1 = IWeb3BetsMarketV1(markets[i]);
            if (!marketv1.isWinningPoolSet()) {
                allMarketsAreSettled = false;
                break;
            } else {
                allMarketsAreSettled = true;
                break;
            }
        }

        if (!allMarketsAreSettled) {
            revert(
                "You must set winning pools in all markets before ending event"
            );
        } else {
            status = EventStatus.ENDED;
        }
    }

    function startEvent() external onlyOwner{
        if (status == EventStatus.CANCELED) {
            revert("Canceled event can not be started");
        } else if (status == EventStatus.ENDED) {
            revert("Ended event can not be started");
        } else if (status == EventStatus.STARTED) {
            revert("Event already started");
        } else if (status == EventStatus.PENDING) {
            status = EventStatus.STARTED;
        } else {
            revert("An error occurred starting event");
        }
    }

    function getEventStatus() external view override returns (uint256) {
        return uint256(status);
    }
}
