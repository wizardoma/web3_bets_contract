// SPDX-License-Identifier: MIT
pragma solidity >0.4.23 <0.9.0;
import "./Events.sol";
contract EventFactory {
    mapping (address => Event[]) events;

    Event[] private _events;
    function createEvent(
        string memory eventName, string memory eventDescription, uint endTime
    ) public returns(address) {
        Event wEvent = new Event(marketId, marketName, marketDescription, eventAddress);
        
        eventMarkets[eventAddress].push(market);

        return address(market);
    }


    function getMarketsByEvent(address eventAddress)
        public
        view
        returns (Market[] memory markets)
    {
        return eventMarkets[eventAddress];

    }
}