// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.8.0;
import "./IClock.sol";
contract Clock is IClock {
    
    function currentTime()override public view returns(uint){
        return block.timestamp;
    }
}