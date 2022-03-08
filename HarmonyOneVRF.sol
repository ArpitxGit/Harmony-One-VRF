// SPDX-License-Identifier: GPL-3.0

//version of soldity and its compiler
pragma solidity >=0.8.0 <0.9.0;

//contract object
contract HarmonyVRF{

    // Harmony One VRF function
    // As we can see it returns a value in bytes32
    // The input of the precompiled contract at 0xff is the block number for which the VRF is requested.
    // The block number should only be within the last 256 blocks.
    // If a block number outside this range is provided, the current block's VRF will be returned.

    function vrf() public view returns (bytes32 result) {
        
        //they have created an array of size 1 for stroing current block number
        uint[1] memory bn;
        bn[0] = block.number;

        //assembly for more efficient computing:
        assembly {

            // Load free memory pointer
            let memPtr := mload(0x40)

            // STATICCALL opcode enforces read-only calls at runtime
            // Syntax :: <address>.staticcall(bytes memory) returns (bool, bytes memory)
            // This initiates a low-level staticcall instruction with a given payload or transaction data and
            // returns a Boolean condition along with the return data.
            // Upon failure of the transaction, it returns false.
            if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
            invalid()
            }
            result := mload(memPtr)
            }
    }
}

//it will give random numbers only if connected to harmony networks, local, testnet or mainnet.
