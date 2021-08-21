// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.6.0 <0.8.0;

interface IClock {
    
    function currentTime()external view returns(uint);
}