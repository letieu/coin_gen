// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./lib/BEP20Mintable.sol";
import "./lib/BEP20Burnable.sol";

/**
 * @title UnlimitedBEP20
 * @dev Implementation of the UnlimitedBEP20
 */
contract UnlimitedBEP20 is BEP20Mintable, BEP20Burnable {

    constructor (
        string memory name,
        string memory symbol,
        uint8 decimals,
        uint256 initialBalance
    )
      BEP20(name, symbol)
    {
        _setupDecimals(decimals);
        _mint(_msgSender(), initialBalance);
    }

    /**
     * @dev Function to mint tokens.
     *
     * NOTE: restricting access to owner only. See {BEP20Mintable-mint}.
     *
     * @param account The address that will receive the minted tokens
     * @param amount The amount of tokens to mint
     */
    function _mint(address account, uint256 amount) internal override onlyOwner {
        super._mint(account, amount);
    }

    /**
     * @dev Function to stop minting new tokens.
     *
     * NOTE: restricting access to owner only. See {BEP20Mintable-finishMinting}.
     */
    function _finishMinting() internal override onlyOwner {
        super._finishMinting();
    }
}
