// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.0 <0.9.0;

contract CoinFlip {
    int SIZE  = 10;  // Maximum number of users
    struct betDetails{
        bool input;
        int amount;
        bool output;
    }

    mapping(int => int) userBalance; // For user's balance
    mapping(int => betDetails) userBets;

    // Initialize all user with 100 points
    function UserInit() public{
        for(int i=0; i<SIZE; i++){
            userBalance[i] = 100;
        }
    }

    // Return User's Balance using userId
    function UserBalance(int userId) public view returns(int){
        if(userId>=0 && userId<SIZE)
            return userBalance[userId];
        else return -1;
    }

    
    function placingBet(int userId, int amount, bool input) public returns(bool){
        //conditions
        if(userId<0 || userId>=SIZE) return false; 
        if(userBalance[userId]<amount) return false;
        if(userBets[userId].output) return false;

        //deducing amount for placing a bet
        userBalance[userId] -= amount;
        //updating details
        userBets[userId].amount = amount;
        userBets[userId].input = input;
        userBets[userId].output = true;

        return true;       
    }

    //using harmony one VRF for random number generation
    function vrf() public view returns (bytes32 result) {
        uint[1] memory bn;
        bn[0] = block.number;
        assembly {
            let memPtr := mload(0x40)
            if iszero(staticcall(not(0), 0xff, bn, 0x20, memPtr, 0x20)) {
            invalid()
            }
        result := mload(memPtr)
        }
    }

    //Handling Bets Here
    function HandlingBet() public {
        bool coinResult = true;
        uint randNumber = uint(vrf());//here we are converting bytes32 to uint, as vrf output is in bytes32
        if(randNumber%2 == 0)
            coinResult = true;
        else 
            coinResult = false;
            
        //All results
        for(int i=0; i<SIZE; i++){
            if(userBets[i].output && userBets[i].input == coinResult){
                userBalance[i] += (2*userBets[i].amount);
                userBets[i].output = false;
            }
        }
    }

}
