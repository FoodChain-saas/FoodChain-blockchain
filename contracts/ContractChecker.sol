//SPDX-License_Identifier: MIT
pragma solidity ^0.8.0;

contract ContractChecker {
        function isContract(address to) public view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(to)
        }

        return(size > 0);
    }
}