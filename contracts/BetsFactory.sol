// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Bets.sol";
contract BetsFactory {
    mapping (address => address[]) public userBets;

    address[] private _bets;

    event BetCreated(address better, address eventAddress, address marketAddress, address poolAddress, uint stake);

    function createBet(address _eventAddress, address _marketAddress, address _poolAddress, uint _stake,address _better) external returns(address) {
        Bets bet =new Bets(_eventAddress, _marketAddress,_poolAddress, _stake,_better);
        _bets.push(address(bet));
        userBets[_better].push(address(bet));
        emit BetCreated(_better, _eventAddress, _marketAddress, _poolAddress, _stake);
        return address(bet);
    }


    function getAllBetsByAddress(address _address) external view returns (address[] memory){
        return userBets[_address];
    } 


    function getTotalBets() external view returns(uint){
        return _bets.length;
    }

      function getAllBets() external view returns (address[] memory){
        return _bets;
    }

}