// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.25;

import "../common/InitTarget.sol";

import {IMultiVault, MultiVault} from "@mellow-finance/simple-lrt/vaults/MultiVault.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    struct CoreDeployment {
        uint256 sourceChainId;
        address SourceCore;
        address SourceMellowOFTAdapter;
        address TargetCore;
        address TargetMellowOFT;
        address TargetMultiVault;
    }

    function run() external {
        uint256 deployerPk = uint256(bytes32(vm.envBytes("HOT_DEPLOYER")));
        address deployer = vm.addr(deployerPk);

        CoreDeployment memory coreDeployment = CoreDeployment({
            sourceChainId: Constants.BASE_CHAINID,
            SourceCore: 0xbe515939fBA844A7063f119225012B072cE40D0c, // [Base] SourceCore
            SourceMellowOFTAdapter: 0x25Aef70C4387f883F5657F2B83dE4d20aFADa217, // [Base] MellowOFTAdapter
            TargetCore: 0xA2598154978aBE38f017617972ED989283975fDD, // [Ethereum] TargetCore
            TargetMellowOFT: 0xA9402c888102fc725902caf5B243300bE24B77EF, // [Ethereum] MellowOFT
            TargetMultiVault: 0x10d2DAb00E1d3F015C9be79F60947BC1BD413e36 // [Ethereum] MultiVault
        });

        vm.startBroadcast(deployerPk);
        InitTarget.init(
            InitTarget.InitParams({
                targetCore: TargetCore(coreDeployment.TargetCore),
                sourceEid: Constants.endpointId(coreDeployment.sourceChainId),
                sourceCoreAddress: coreDeployment.SourceCore,
                mellowOFT: MellowOFT(coreDeployment.TargetMellowOFT),
                mellowOFTAdapter: coreDeployment.SourceMellowOFTAdapter,
                deployer: deployer,
                vaultAdmin: Constants.THQ_MAINNET_VAULT_ADMIN(),
                vaultProxyAdmin: Constants.THQ_MAINNET_VAULT_PROXY_ADMIN(),
                curatorAdmin: Constants.THQ_MAINNET_CURATOR_ADMIN(),
                curatorOperator: Constants.THQ_MAINNET_CURATOR_OPERATOR_1(),
                vault: coreDeployment.TargetMultiVault,
                claimer: 0x25024a3017B8da7161d8c5DCcF768F8678fB5802
            })
        );

        vm.stopBroadcast();
        // revert("ok");
    }
}
