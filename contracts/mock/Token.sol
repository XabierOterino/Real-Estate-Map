// SPDX-License-Identifier:MIT
import "@openzpeppelin/contracts/token/ERC20/ERC20.sol";
pragma solidity ^0.8.9;

contract Token is ERC20 {
    constructor() ERC20("UtilityToken", "UT") {}
}
