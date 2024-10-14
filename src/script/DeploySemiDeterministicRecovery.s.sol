// SPDX-License-Identifier: ISC
pragma solidity ^0.8.19;

import { BaseScript } from "frax-std/BaseScript.sol";
import { console } from "frax-std/FraxTest.sol";
import { SemiDeterministicRecovery } from "src/contracts/SemiDeterministicRecovery.sol";

contract DeploySemiDeterministicRecovery is BaseScript {
    uint256 public PK_OFT_DEPLOYER = vm.envUint("PK_OFT_DEPLOYER");

    modifier broadcastAs(uint256 privateKey) {
        vm.startBroadcast(privateKey);
        _;
        vm.stopBroadcast();
    }

    function run() public broadcastAs(PK_OFT_DEPLOYER) {
        // create many to ensure address exists
        for (uint256 i = 0; i < 10; i++) {
            new SemiDeterministicRecovery();
        }
    }
}
