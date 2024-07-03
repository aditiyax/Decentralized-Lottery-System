//SPDX-License-Indentifier- 
pragma solidity^0.8.0;

contract Lottery {
     address public admin;
     uint public Id;
     address payable[] public Players;
     mapping (uint => address payable) public History;

     constructor(){
          admin = msg.sender;
          Id=1;
     }

     function getBalance() public view returns(uint) {
          return  address(this).balance;
     }

     function enter() public payable{
          require(msg.value > 0.05 ether);
          Players.push(payable(msg.sender)); 
     }

     function random() public view returns(uint){
          return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, Players)));
     }

     function pickWinner() public restricted{
          uint index = random() %  Players.length;
          Players[index].transfer(address(this).balance);
 
           History[Id] = Players[index];
           Id++;

           Players= new address payable[](0);
          
     }

     function getPlayers() public view returns (address payable[] memory){
          return Players;
     }

    modifier restricted() {
     require(msg.sender == admin);
     _;
    }
    
}