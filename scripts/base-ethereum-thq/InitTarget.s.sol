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

    address claimer = Constants.OG_MAINNET_CURATOR_OPERATOR();

    function run() external {
        uint256 deployerPk = uint256(bytes32(vm.envBytes("HOT_DEPLOYER")));
        address deployer = vm.addr(deployerPk);

        CoreDeployment memory coreDeployment = CoreDeployment({
            targetChainId: Constants.ETHEREUM_CHAINID,
            SourceCore: address(0), // [Base] SourceCore
            SourceMellowOFTAdapter: address(0), // [Base] MellowOFTAdapter
            TargetCore: address(0), // [Ethereum] TargetCore
            TargetMellowOFT: address(0), // [Ethereum] MellowOFT
            TargetMultiVault: address(0) // [Ethereum] MultiVault
        });

        vm.startBroadcast(deployerPk);
        {
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
                    curatorOperator: Constants.THQ_MAINNET_CURATOR_OPERATOR(),
                    vault: coreDeployment.TargetMultiVault,
                    claimer: claimer
                })
            );
        }

        vm.stopBroadcast();
        //revert("ok");
    }
}
