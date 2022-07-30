pragma solidity ^0.8.4;

interface IWeb3Bets{

    function shareBetEarnings() payable external;

    function getVigPercentage() external returns(uint);

    function isEventOwner(address _owner) external returns (bool);
}