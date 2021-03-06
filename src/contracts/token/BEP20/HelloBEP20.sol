// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "./lib/BEP20.sol";

import "../../service/ServicePayer.sol";
import "../../utils/GeneratorCopyright.sol";

/**
 * @title HelloBEP20
 * @author BEP20 Generator (https://vittominacori.github.io/bep20-generator)
 * @dev Implementation of the HelloBEP20
 */
contract HelloBEP20 is BEP20 {

    constructor (
        string memory name,
        string memory symbol
    )
        BEP20(name, symbol)
    {
        _mint(_msgSender(), 100000e18);
    }
}
