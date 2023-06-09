//SPDX-License-Identifier: GPL-3.0
 
pragma solidity >=0.5.0 <0.9.0;

contract lottery{

    address payable[] public players;
    address public manager;

    constructor(){
        manager = msg.sender;
    }
   
    receive() payable external{
        require(msg.value == 0.1 ether);
        players.push(payable(msg.sender));
    }

    function getbalance() public view returns(uint){
        require(msg.sender == manager);
        return address(this).balance;
    }

    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function pickwinner() public{
        require(msg.sender == manager);
        require(players.length >= 3);

        uint r = random();
        address payable winner;

        uint index = r % players.length;
        winner = players[index];

        winner.transfer(getbalance());

        players = new address payable[](0);

    }
}

   