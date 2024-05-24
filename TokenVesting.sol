// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract TokenVesting is Ownable {
    IERC20 public token;

    enum Role { None, User, Partner, Team }

    struct VestingSchedule {
        uint256 cliff;
        uint256 duration;
        uint256 allocated;
        uint256 released;
    }

    bool public vestingStarted = false;
    uint256 public startTimestamp;

    mapping(address => Role) public beneficiaries;
    mapping(address => VestingSchedule) public schedules;

    event VestingStarted(uint256 startTimestamp);
    event BeneficiaryAdded(address indexed beneficiary, Role role, uint256 amount);
    event TokensWithdrawn(address indexed beneficiary, uint256 amount);

    modifier onlyWhenVestingNotStarted() {
        require(!vestingStarted, "Vesting already started");
        _;
    }

    constructor(IERC20 _token, address initialOwner) Ownable(initialOwner) {
        token = _token;
    }

    function startVesting() external onlyOwner onlyWhenVestingNotStarted {
        startTimestamp = block.timestamp;
        vestingStarted = true;
        emit VestingStarted(startTimestamp);
    }

    function addBeneficiary(address _beneficiary, Role _role, uint256 _amount) external onlyOwner onlyWhenVestingNotStarted {
        require(beneficiaries[_beneficiary] == Role.None, "Beneficiary already added");
        require(_role != Role.None, "Invalid role");

        uint256 cliff;
        uint256 duration;

        if (_role == Role.User) {
            cliff = 10 * 30 days; // 10 months
            duration = 2 * 365 days; // 2 years
        } else if (_role == Role.Partner || _role == Role.Team) {
            cliff = 2 * 30 days; // 2 months
            duration = 365 days; // 1 year
        }

        beneficiaries[_beneficiary] = _role;
        schedules[_beneficiary] = VestingSchedule({
            cliff: cliff,
            duration: duration,
            allocated: _amount,
            released: 0
        });

        emit BeneficiaryAdded(_beneficiary, _role, _amount);
    }

    function claimTokens() external {
        require(vestingStarted, "Vesting not started");
        require(beneficiaries[msg.sender] != Role.None, "Not a beneficiary");

        VestingSchedule storage schedule = schedules[msg.sender];

        uint256 vested = _vestedAmount(schedule);
        uint256 releasable = vested - schedule.released;

        require(releasable > 0, "No tokens to release");

        schedule.released += releasable;

        require(token.transfer(msg.sender, releasable), "Token transfer failed");
        emit TokensWithdrawn(msg.sender, releasable);
    }

    function _vestedAmount(VestingSchedule memory schedule) internal view returns (uint256) {
        if (block.timestamp < startTimestamp + schedule.cliff) {
            return 0;
        } else if (block.timestamp >= startTimestamp + schedule.duration) {
            return schedule.allocated;
        } else {
            return (schedule.allocated * (block.timestamp - startTimestamp)) / schedule.duration;
        }
    }
}
