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
            SourceCore: address(0), // [Base] SourceCore
            SourceMellowOFTAdapter: address(0), // [Base] MellowOFTAdapter
            TargetCore: address(0), // [Ethereum] TargetCore
            TargetMellowOFT: address(0) // [Ethereum] MellowOFT
        });

        vm.startBroadcast(deployerPk);
        InitSource.init(
            InitSource.InitParams({
                deployer: deployer,
                vaultAdmin: Constants.THQ_BASE_VAULT_ADMIN(),
                vaultProxyAdmin: Constants.THQ_BASE_VAULT_PROXY_ADMIN(),
                oracleUpdater: Constants.THQ_BASE_ORACLE_UPDATER(),
                curatorAdmin: Constants.THQ_BASE_CURATOR_ADMIN(),
                curatorOperator: Constants.THQ_BASE_CURATOR_OPERATOR(),
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
