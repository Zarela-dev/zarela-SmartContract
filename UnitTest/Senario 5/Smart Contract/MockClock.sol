// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.8.0;
import "./IClock.sol";
contract MockClock is IClock {
    uint public time;
    
    function setTime(uint _time)public {
        time = _time;
    }
    
    function incTime()public {
        time++;
    }
    
    function addOneDay()public {
        time = time + 24 hours;
    }
    
    function decTime()public {
        time--;
    }
    
   
    function currentTime()override public view returns(uint){
        return time;
    }
}