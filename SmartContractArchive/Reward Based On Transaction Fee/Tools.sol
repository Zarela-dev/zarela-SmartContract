// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.6.0 <0.8.0;
library Tools{
    function isstringEQAL(string memory a, string memory b)internal pure returns(bool){
        if (uint(keccak256(abi.encode(a))) == uint(keccak256(abi.encode(b))))
            return(true);
        return(false);
    }

    function concatstring(string memory a , string memory b )internal pure returns(string memory){
        bytes memory sa = bytes(a);
        bytes memory sb = bytes(b);
        uint len = sa.length + sb.length;
        bytes memory sc = new bytes(len);
        uint i;
        for (i=0 ; i < sa.length ; i++)
            sc[i]= sa[i];
        for (i=0 ; i <sb.length ; i++)
            sc[i+sa.length] = sb[i];
        return(string(sc));

    }
    function uint2str(uint i) internal pure returns (string memory) {
    if (i == 0) return "0";
    uint j = i;
    uint length;
    while (j != 0) {
        length++;
        j /= 10;
    }
    bytes memory bstr = new bytes(length);
    uint k = length - 1;
    while (i != 0) {
        bstr[k--] = byte(uint8(48 + i % 10));
        i /= 10;
    }
    return string(bstr);
    }
}
