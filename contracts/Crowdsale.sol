pragma solidity ^0.5.1;

import './Ownable.sol';
import './GasERC20.sol';

contract Crowdsale {
    address payable owner;
    address me = address(this);
    uint sat = 1e18;

    // *** Config ***
    uint startFst = block.timestamp;
    uint periodFst = 1 days;
    uint periodScd = 1 days;
    uint percentSell = 35;
    uint manualSaleAmount = 10 * sat;
    uint256 price = 4; // 0.4 ETH
    // --- Config ---

    uint startScd =  startFst + periodFst;
    uint stopSell = startScd + periodScd;
    GasERC20 token = new GasERC20();

    constructor() public {
        owner = msg.sender;
        token.setAddressToExcludeRecipients(owner);
        token.setAddressToExcludeSenders(owner);
        token.changeServiceWallet(owner);
        token.transferOwnership(owner);
        token.transfer(owner, token.totalSupply() / 100 * (100 - percentSell) + manualSaleAmount);
    }

    function() external payable {
        require(startFst < block.timestamp && block.timestamp < stopSell, "Period error");
        uint amount = msg.value / price * 10;
        require(amount <= token.balanceOf(address(this)), "Infucient token balance in ICO");
        token.transfer(msg.sender, amount);
    }

    function manualGetETH() public payable {
        require(msg.sender == owner, "You is not owner");
        owner.transfer(address(this).balance);
    }

    function getLeftTokens() public {
        require(msg.sender == owner, "You is not owner");
        token.transfer(owner, token.balanceOf(address(this)));
    }

    // Utils
    function getStartICO() public view returns (uint) {
        return startFst - block.timestamp;
    }
    function getStartScd() public view returns (uint) {
        return startScd - block.timestamp;
    }
    function getStopSell() public view returns(uint){
        return stopSell - block.timestamp;
    }
    function getTokenAddress() public view returns (address){
        return address(token);
    }
    function ICO_deposit() public view returns(uint){
        return token.balanceOf(address(this));
    }
    function myBalance() public view returns(uint){
        return token.balanceOf(msg.sender);
    }
}
