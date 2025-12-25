// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MaffiaCoin is ERC20, Ownable {
    uint256 public burnRate = 2; // 2% burn per transazione

    constructor(uint256 initialSupply) ERC20("MaffiaCoin", "MAFF") {
        _mint(msg.sender, initialSupply * (10 ** decimals()));
    }

    // Override del trasferimento per implementare burn
    function _transfer(address sender, address recipient, uint256 amount) internal override {
        uint256 burnAmount = amount * burnRate / 100;
        uint256 sendAmount = amount - burnAmount;
        super._transfer(sender, address(0), burnAmount); // brucia i token
        super._transfer(sender, recipient, sendAmount);
    }

    // Funzione di airdrop: invia token a più indirizzi
    function airdrop(address[] calldata recipients, uint256 amount) external onlyOwner {
        for(uint i = 0; i < recipients.length; i++) {
            _transfer(msg.sender, recipients[i], amount);
        }
    }

    // Funzione per cambiare il burn rate (solo owner)
    function setBurnRate(uint256 newRate) external onlyOwner {
        require(newRate <= 10, "Burn troppo alto");
        burnRate = newRate;
    }
}
