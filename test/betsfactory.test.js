const Web3Bets = artifacts.require("Web3Bets");
const EventFactory = artifacts.require("EventFactory");
const MarketFactory = artifacts.require("MarketFactory");
const PoolsFactory = artifacts.require("PoolsFactory");
const BetsFactory = artifacts.require("BetsFactory");

const Events = artifacts.require("Events");
const Market = artifacts.require("Markets");
const Pools = artifacts.require("Pools");

const truffleAssert = require("truffle-assertions");

let eventFactory;
let marketFactory;
let poolFactory;
let betFactory;
let web3bets;
let demoEventAddress;
let eventOwner;
let demoEvent;
let demoMarket;
let demoMarketAddress;
let marketName;
let demoPoolAddress;

before(async function () {
  this.timeout(20000);
  web3bets = await Web3Bets.deployed();
  accounts = await web3.eth.getAccounts();
  eventOwner = accounts[1];

  eventFactory = await EventFactory.deployed();
  marketFactory = await MarketFactory.deployed();
  poolFactory = await PoolsFactory.deployed();
  betFactory = await BetsFactory.deployed();

  await eventFactory.createEvent("Man U v Villa", 2, { from: eventOwner });
  let events = await eventFactory.getAllEvents();
  demoEventAddress = events[events.length - 1];
  demoEvent = await Events.at(demoEventAddress);
  marketName = "Paribet";
  await demoEvent.createMarket(marketName, 1, { from: eventOwner });
  let newEventsMarkets = await demoEvent.getMarkets();
  demoMarketAddress = newEventsMarkets[newEventsMarkets.length - 1];
  demoMarket = await Market.at(demoMarketAddress);
  await poolFactory.createPool("12", demoEventAddress, demoMarketAddress, 2);
  let newMarketPools = await poolFactory.getPoolsOfMarket(demoMarketAddress);
  demoPoolAddress = newMarketPools[newMarketPools.length - 1];
});

contract("BetFactory", (accounts) => {
  it("Can create a bet", async () => {
    let poolBets = await betFactory.getAllBetsByAddress(accounts[0]);
    await betFactory.createBet(
      demoEventAddress,
      demoMarketAddress,
      demoPoolAddress,
      2,
      eventOwner
    );
    let newPoolBets = await betFactory.getAllBetsByAddress(accounts[0]);

    assert.equal(newPoolBets.length - poolBets.length === 1, true);
  });

  it("Can fetch all bets", async () => {
    await truffleAssert.passes(betFactory.getAllBets());
  });

  it("Can get count of all bets", async () => {
    await truffleAssert.passes(betFactory.getTotalBets());
  });
});