
pragma solidity ^0.8.19;

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address recipient, uint256 amount) external returns (bool);
}

contract PumpVendingMachine {
    IERC20 public immutable token;
    uint256 public immutable interval;
    uint256 public lastDistribution;

    constructor(address tokenAddress) {
        token = IERC20(tokenAddress);
        interval = 600;
        lastDistribution = block.timestamp;
    }

    function executeDistribution(address[] calldata holders) external {
        require(block.timestamp >= lastDistribution + interval, "Interval not elapsed");

        uint256 pool = token.balanceOf(address(this));
        require(pool > 0, "No tokens to distribute");

        uint256 totalSupply = 0;
        for (uint256 i = 0; i < holders.length; i++) {
            totalSupply += token.balanceOf(holders[i]);
        }

        require(totalSupply > 0, "No eligible supply");

        for (uint256 i = 0; i < holders.length; i++) {
            uint256 holderBalance = token.balanceOf(holders[i]);
            if (holderBalance == 0) continue;

            uint256 payout = (pool * holderBalance) / totalSupply;
            if (payout > 0) {
                token.transfer(holders[i], payout);
            }
        }

        lastDistribution = block.timestamp;
    }
}
