// SPDX-License-Identifier: MIT

pragma solidity 0.8.17;

import "sc-bonds/src/Register.sol";
import "./VariableRateRegisterRoleManagement.sol";
import "./intf/IVariableRateRegister.sol";

contract VariableRateRegister is Register, VariableRateRegisterRoleManagement, IVariableRateRegister {
    constructor(
        string memory name_,
        string memory isin_,
        uint256 expectedSupply_,
        bytes32 currency_,
        uint256 unitVal_,
        uint256 couponRate_,
        uint256 creationDate_,
        uint256 issuanceDate_,
        uint256 maturityDate_,
        uint256[] memory couponDates_,
        uint256 cutofftime_
    ) Register(
        name_,
        isin_,
        expectedSupply_,
        currency_,
        unitVal_,
        couponRate_,
        creationDate_,
        issuanceDate_,
        maturityDate_,
        couponDates_,
        cutofftime_
    ) {}

    function setCouponRate(uint256 couponRate_) public override {
        require(hasRole(ANA_ROLE, msg.sender), "Caller must be ANA");

        require(status == Status.Issued, "Cannot change the coupon rate if the bond is not issued");
        //FIXME: disallow rate change if a coupon date just passed, in order to not have it changed between CACEIS
        //coupon amount calculation and coupon distribution (48 hours delay after each couponDate should be reasonable) 

        _data.couponRate = couponRate_;

        emit CouponRateChanged(msg.sender, name(), symbol(), _data.couponRate);
    }
}
