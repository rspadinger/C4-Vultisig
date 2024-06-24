// SPDX-License-Identifier: BUSL-1.1

pragma solidity =0.7.6;

import "forge-std/console.sol";

abstract contract Initializable {
    bool private _initialized;

    function _disableInitialize() internal {
        //console.log("******** _disableInitialize **********");
        _initialized = true;
        //console.logBool(_initialized);
    }

    modifier whenNotInitialized() {
        // console.log("******** whenNotInitialized **********");
        // console.logBool(_initialized);
        require(!_initialized);
        _;
        //@audit-ok => assures that initializecan only be called once
        _initialized = true;
        //console.logBool(_initialized);
    }
    modifier afterInitialize() {
        require(_initialized);
        _;
    }
}
