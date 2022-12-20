// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import { Script } from "forge-std/Script.sol";
import { CramBit } from "src/CramBit.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract CramBitScript is Script {

    function run() public {
        vm.startBroadcast();
        // stub
        vm.stopBroadcast();
    }
}
