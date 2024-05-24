# TokenVesting Smart Contract

The TokenVesting smart contract allows for the management of token vesting schedules for different beneficiaries. It supports various roles, such as users, partners, and team members, each with customizable vesting parameters.

## Overview

Token vesting is a mechanism commonly used in token distribution to ensure that tokens are released to beneficiaries gradually over a specified period, often with a cliff period at the beginning. The TokenVesting smart contract provides a flexible and secure solution for token vesting, allowing contract owners to define vesting schedules and beneficiaries to claim their vested tokens over time.

## Features

- **Role-based Vesting**: Define vesting schedules for users, partners, and team members, with configurable cliff periods and vesting durations for each role.
- **Owner Control**: The contract owner has the authority to start the vesting process, add beneficiaries, and manage the vesting schedule.
- **Token Claiming**: Beneficiaries can claim their vested tokens according to the predefined schedule, ensuring fair and transparent distribution.
- **Event Emission**: Emit events for key contract actions, such as vesting start, beneficiary addition, and token withdrawal, for easy tracking and auditing.

## Usage

### Deployment

To deploy the TokenVesting contract, follow these steps:

1. Deploy the contract, providing the address of an already deployed ERC20 token contract and the initial owner address.
2. Once deployed, the contract owner can start the vesting process and add beneficiaries.

### Interacting with the Contract

After deployment, interact with the TokenVesting contract as follows:

1. **Start Vesting**: Call the `startVesting` function to initiate the vesting process. This action marks the beginning of the vesting period.
2. **Add Beneficiaries**: Use the `addBeneficiary` function to add beneficiaries for each role before vesting starts. Specify the beneficiary's address, role, and allocated token amount.
3. **Claim Tokens**: After the cliff period, beneficiaries can call the `claimTokens` function to withdraw their vested tokens. The contract calculates the vested amount based on the elapsed time since the start of the vesting period.

## Testing

To ensure the correctness and reliability of the TokenVesting contract, conduct thorough testing covering the following aspects:

1. Test the creation of vesting schedules by the admin.
2. Verify proper token claiming by beneficiaries according to the schedule.
3. Ensure the correct calculation of vested tokens based on the cliff period and vesting duration.

## Example

Below is an example demonstrating the deployment and usage of the TokenVesting contract:

```solidity
// Deploy TokenVesting contract
TokenVesting tokenVesting = new TokenVesting(address(_erc20Token), msg.sender);

// Start vesting
tokenVesting.startVesting();

// Add beneficiaries
tokenVesting.addBeneficiary(address(0x123...), TokenVesting.Role.User, 50000);
tokenVesting.addBeneficiary(address(0x456...), TokenVesting.Role.Partner, 25000);
tokenVesting.addBeneficiary(address(0x789...), TokenVesting.Role.Team, 25000);

// Simulate time and claim tokens
// ...

```

## License

This project is licensed under the MIT License.

---

Feel free to customize this README with additional information specific to your project or requirements!
