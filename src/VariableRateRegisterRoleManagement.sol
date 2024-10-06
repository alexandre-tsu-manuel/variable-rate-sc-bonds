// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "sc-bonds/src/RegisterRoleManagement.sol";
import "./intf/IVariableRateRegister.sol";

contract VariableRateRegisterRoleManagement is RegisterRoleManagement, IVariableRateRegisterRoleManagement {
    /**
     * Roles
     * They are managed through AccessControl smart contract
     * The roles are declared below
     */

    bytes32 public constant ANA_ROLE = keccak256("ANA_ROLE"); //Analyst role

    constructor() {
        _setRoleAdmin(ANA_ROLE, CAK_ROLE); // ANA_ROLE admin is CAK_ROLE
    }

    function isAna(address account) public view returns (bool) {
        return hasRole(ANA_ROLE, account);
    }

    /**
     * @dev The aim of this function is to enable a CAK to grant ANA role to an address
     */
    function grantAnaRole(address anaAddress_) public override {
        grantRole(ANA_ROLE, anaAddress_);
    }

    /**
     * @dev The aim of this function is to enable a CAK to revoke ANA role of an address
     */
    function revokeAnaRole(address anaAddress_) public override {
        revokeRole(ANA_ROLE, anaAddress_);
    }
}
