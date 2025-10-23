// SPDX-License-Identifier: MIT

pragma solidity ^0.8.26;

// ===============================
// NATSENEC CONTRACT DOCUMENTATION
// ===============================

/// @title KipuBank
/// @author g-centurion
/// @notice Vault contract allowing users to deposit ETH and withdraw it subject to a transaction limit.
contract KipuBank {

// ==============================================
// CUSTOM ERRORS (Requirement: use custom errors)
// ==============================================

/// @dev Thrown when the deposited amount exceeds the remaining capacity of the bank.
error Bank__DepositExceedsCap(uint256 currentBalance, uint256 bankCap, uint256 attemptedDeposit);

/// @dev Thrown when the requested amount exceeds the per-transaction withdrawal limit.
error Bank__WithdrawalExceedsLimit(uint256 limit, uint256 requested);

/// @dev Thrown when the user tries to withdraw more than their available balance.
error Bank__InsufficientBalance(uint256 available, uint256 requested);

/// @dev Thrown when an ETH transfer fails.
error Bank__TransferFailed();

/// @dev Thrown when an owner-only function is called by another user.
error Bank__Unauthorized();

// ===================================
// EVENTS (Requirement: Emit events)
// ===================================

/// @dev Emitted when a user deposits ETH.
/// @param user The address that performed the deposit.
/// @param amount The amount of ETH deposited (in Wei).
event DepositSuccessful(address indexed user, uint256 amount);

/// @dev Emitted when a user withdraws ETH.
/// @param user The address that performed the withdrawal.
/// @param amount The amount of ETH withdrawn (in Wei).
event WithdrawalSuccessful(address indexed user, uint256 amount);

// =============================================================
// STATE VARIABLES (Requirement: Immutables, Mappings, Counters)
// =============================================================

/// @dev Global deposit limit for the contract (set in the constructor).
uint256 public immutable bankCap;

/// @dev Fixed maximum threshold a user can withdraw in a single transaction.
uint256 public immutable MAX_WITHDRAWAL_PER_TX;

/// @dev Address of the contract deployer for access control.
address private immutable _owner;

/// @dev Mapping of user address to their ETH balance (in Wei).
mapping(address => uint256) public balances;

/// @dev Total count of successful deposits.
uint256 private _depositCount = 0;

/// @dev Total count of successful withdrawals.
uint256 private _withdrawalCount = 0;

// =========================
// CONSTRUCTOR AND MODIFIERS
// =========================

/// @dev Initializes the maximum bank capacity and the per-transaction withdrawal limit.
/// @param initialBankCap The total ETH limit the bank can hold (in Wei).
/// @param maxWithdrawalAmount The maximum ETH limit that can be withdrawn in one transaction (in Wei).
constructor(uint256 initialBankCap, uint256 maxWithdrawalAmount) {
    bankCap = initialBankCap;
    MAX_WITHDRAWAL_PER_TX = maxWithdrawalAmount;
    _owner = msg.sender;
}

/// @dev Restricts function execution to only the contract owner (Requirement: Modifier).
modifier onlyOwner() {
    if (msg.sender != _owner) revert Bank__Unauthorized();
    _;
}

// =============================
// EXTERNAL AND PUBLIC FUNCTIONS
// =============================

/// @dev Allows users to deposit ETH into their personal vault (Requirement: external payable).
function deposit() external payable {
    // A. CHECKS

    // Correction 1 & 2: Check logic. To correctly verify the cap (address(this).balance + msg.value),
    // we use the current balance (which already includes msg.value upon entry to this payable function) 
    // and store the initial balance for accurate error reporting.
    // We cache address(this).balance for the cap check and error reporting.
    uint256 currentContractBalance = address(this).balance; 
    
    // Correction 1 logic applied: Check if the current total balance exceeds the immutable cap.
    if (currentContractBalance > bankCap) { 
        // Report balance *before* the current deposit for better context in the error.
        revert Bank__DepositExceedsCap(currentContractBalance - msg.value, bankCap, msg.value);
    }

    // B. EFFECTS
    balances[msg.sender] += msg.value;
    _depositCount++;

    // C. INTERACTIONS
    emit DepositSuccessful(msg.sender, msg.value);
}

/// @dev Allows users to withdraw ETH from their vault, subject to the transaction limit.
/// @param amountToWithdraw The amount of ETH (in Wei) to withdraw.
function withdraw(uint256 amountToWithdraw) external {
    // A. CHECKS
    // Correction 2: Cache necessary state variable reads to avoid multiple storage accesses.
    uint256 userBalance = balances[msg.sender];
    uint256 limit = MAX_WITHDRAWAL_PER_TX; // MAX_WITHDRAWAL_PER_TX is already immutable, accessing it repeatedly is low risk but caching enhances consistency.
    
    if (amountToWithdraw > limit) {
        revert Bank__WithdrawalExceedsLimit(limit, amountToWithdraw);
    }

    // Correction 2: Avoid reading balances[msg.sender] again in the error message.
    if (userBalance < amountToWithdraw) {
        revert Bank__InsufficientBalance(userBalance, amountToWithdraw);
    }

    // B. EFFECTS (Checks-Effects-Interactions Pattern)
    // Update state before external call to prevent reentrancy [6-8].
    
    // Correction 3: Use unchecked block. Since the previous check (userBalance < amountToWithdraw) 
    // ensures there is no underflow, we use unchecked arithmetic for optimization (gas saving) [9, 10].
    unchecked {
        balances[msg.sender] = userBalance - amountToWithdraw;
    }
    _withdrawalCount++;

    // C. INTERACTIONS
    // Use low-level `call` for secure ETH transfer, avoiding the gas limit of `transfer`/`send` [11, 12].
    (bool success, ) = payable(msg.sender).call{value: amountToWithdraw}("");

    if (!success) {
        revert Bank__TransferFailed();
    }

    emit WithdrawalSuccessful(msg.sender, amountToWithdraw);
}

// ===========================
// INTERNAL AND VIEW FUNCTIONS
// ===========================

// Private function (Requirement: one private function)
/// @dev Returns the internal balance of a user. This is an auxiliary internal function.
/// @param user The user's address.
/// @return The user's balance.
function _getInternalBalance(address user) private view returns (uint256) {
    // Note: Since balances is public, reading it is already optimized via the getter function (external view), 
    // but internal/private functions read directly from storage. This function serves the private requirement.
    return balances[user];
}

// View functions (Requirement: one external view function)

/// @dev Returns the total number of deposits made to the contract.
/// @return The total deposit count.
function getDepositCount() external view returns (uint256) {
    return _depositCount;
}

/// @dev Returns the total number of withdrawals made from the contract.
/// @return The total withdrawal count.
function getWithdrawalCount() external view returns (uint256) {
    return _withdrawalCount;
}
}
