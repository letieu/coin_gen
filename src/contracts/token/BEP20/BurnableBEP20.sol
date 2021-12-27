// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./lib/BEP20Burnable.sol";


/**
 * @title BurnableBEP20
 * @dev Implementation of the BurnableBEP20
 */
contract BurnableBEP20 is BEP20Burnable {

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 initialBalance
    )
        BEP20(name, symbol)
    {
        require(initialBalance > 0, "BurnableBEP20: supply cannot be zero");

        _setupDecimals(decimals);
        _mint(_msgSender(), initialBalance);
    }
}
