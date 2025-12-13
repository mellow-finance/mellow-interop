// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.25;

import "../common/DeployTarget.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    function run() external {
        uint256 deployerPk = uint256(bytes32(vm.envBytes("HOT_DEPLOYER")));
        address deployer = vm.addr(deployerPk);

        vm.startBroadcast(deployerPk);
        (TargetCore targetCoreSingleton, TransparentUpgradeableProxy targetCore, MellowOFT mellowOFT) = DeployTarget
            .deploy(
            Constants.THQ_MAINNET_VAULT_PROXY_ADMIN(),
            deployer,
            bytes32(uint256(0x0)),
            "Base Omnichain Theoriq Token (Internal)",
            "BaseTHQInternal"
        );

        vm.stopBroadcast();

        console2.log("TargetCore impl %s;", address(targetCoreSingleton));
        console2.log("TargetCore THQ %s;", address(targetCore));
        console2.log("MellowOFT THQ %s.", address(mellowOFT));

        //revert("ok");
    }
}
