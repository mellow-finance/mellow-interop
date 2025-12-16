// SPDX-License-Identifier: BUSL-1.1

pragma solidity 0.8.25;

import "../common/InitSource.sol";
import "forge-std/Script.sol";

contract Deploy is Script {
    struct CoreDeployment {
        uint256 targetChainId;
        address SourceCore;
        address SourceMellowOFTAdapter;
        address TargetCore;
        address TargetMellowOFT;
    }

    uint256 public constant EPOCH_DURATION = 1 days;
    uint256 public constant ORACLE_MAX_AGE = 14 days;
    uint256 public constant WITHDRAWAL_DELAY = 15 days;

    function run() external {
        uint256 deployerPk = uint256(bytes32(vm.envBytes("HOT_DEPLOYER")));
        address deployer = vm.addr(deployerPk);

        CoreDeployment memory coreDeployment = CoreDeployment({
            targetChainId: Constants.ETHEREUM_CHAINID,
            SourceCore: 0xbe515939fBA844A7063f119225012B072cE40D0c, // [Base] SourceCore
            SourceMellowOFTAdapter: 0x25Aef70C4387f883F5657F2B83dE4d20aFADa217, // [Base] MellowOFTAdapter
            TargetCore: 0xA2598154978aBE38f017617972ED989283975fDD, // [Ethereum] TargetCore
            TargetMellowOFT: 0xA9402c888102fc725902caf5B243300bE24B77EF // [Ethereum] MellowOFT
        });

        vm.startBroadcast(deployerPk);
        InitSource.init(
            InitSource.InitParams({
                deployer: deployer,
                vaultAdmin: Constants.THQ_BASE_VAULT_ADMIN(),
                vaultProxyAdmin: Constants.THQ_BASE_VAULT_PROXY_ADMIN(),
                oracleUpdater: Constants.THQ_BASE_ORACLE_UPDATER(),
                curatorAdmin: Constants.THQ_BASE_CURATOR_ADMIN(),
                curatorOperator: Constants.THQ_BASE_CURATOR_OPERATOR_1(),
                sourceCore: SourceCore(coreDeployment.SourceCore),
                targetEid: Constants.endpointId(coreDeployment.targetChainId),
                targetCoreAddress: coreDeployment.TargetCore,
                mellowOFTAdapter: MellowOFTAdapter(coreDeployment.SourceMellowOFTAdapter),
                mellowOFT: MellowOFT(coreDeployment.TargetMellowOFT),
                name: "Staked THQ",
                symbol: "sTHQ",
                epochDuration: EPOCH_DURATION,
                limit: 1e8 ether, // 100 millions sTHQ limit
                oracleMaxAge: ORACLE_MAX_AGE,
                withdrawalDelay: WITHDRAWAL_DELAY
            })
        );
        vm.stopBroadcast();
        // revert("ok");
    }
}
