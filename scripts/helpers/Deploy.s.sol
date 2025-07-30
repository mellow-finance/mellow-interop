// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.25;

import {Collector} from "../../src/helpers/Collector.sol";
import "../../src/helpers/SourceHelper.sol";
import "../../src/helpers/TargetHelper.sol";
import "forge-std/Script.sol";

interface IWETH {
    function deposit() external payable;
}

contract Deploy is Script {
    function run() external {
        uint256 deployerPk = uint256(bytes32(vm.envBytes("HOT_DEPLOYER")));
        address deployer = vm.addr(deployerPk);
        vm.startBroadcast(deployerPk);
        SourceHelper helper = new SourceHelper();
        console2.log(address(helper));
    }
}
