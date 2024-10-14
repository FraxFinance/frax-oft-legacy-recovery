// SPDX-License-Identifier: ISC
pragma solidity ^0.8.19;

import { BaseScript } from "frax-std/BaseScript.sol";
import { console } from "frax-std/FraxTest.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import { SemiDeterministicRecovery } from "src/contracts/SemiDeterministicRecovery.sol";

contract RescueFunds is BaseScript {
    uint256 public PK_OFT_DEPLOYER = vm.envUint("PK_OFT_DEPLOYER");

    modifier broadcastAs(uint256 privateKey) {
        vm.startBroadcast(privateKey);
        _;
        vm.stopBroadcast();
    }

    address constant sFRAX = 0xe4796cCB6bB5DE2290C417Ac337F2b66CA2E770E;
    address constant contractAddr = 0x5Bff88cA1442c2496f7E475E9e7786383Bc070c0;
    address constant recipient = 0x2DF44f531F9B8cD82f181f7e3F3401e392F1b19e;

    function run() public broadcastAs(PK_OFT_DEPLOYER) {
        SemiDeterministicRecovery recovery = SemiDeterministicRecovery(contractAddr);
        uint256 amount = IERC20(sFRAX).balanceOf(contractAddr);

        recovery.recover(sFRAX, recipient, amount);
    }
}
