// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

interface IVariableRateRegisterRoleManagement {
    function isAna(address account) external view returns(bool);

    function grantAnaRole(address anaAddress) external;

    function revokeAnaRole(address anaAddress) external;
}

interface IVariableRateRegister {
    function setCouponRate(uint256 couponRate_) external;

    event CouponRateChanged(
        address indexed emitter,
        string name,
        string isin,
        uint256 newRate
    );
}
