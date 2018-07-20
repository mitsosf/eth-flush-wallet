pragma solidity ^0.4.23;

interface ERC20 {
    function totalSupply() constant returns (uint _totalSupply);
    function balanceOf(address _owner) constant returns (uint balance);
    function transfer(address _to, uint _value) returns (bool success);
    function transferFrom(address _from, address _to, uint _value) returns (bool success);
    function approve(address _spender, uint _value) returns (bool success);
    function allowance(address _owner, address _spender) constant returns (uint remaining);
    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
    }

contract Wallet {
    //Forwards all ETH, supports ERC-20 tokens

    bool avoidReentrancy = false;
    address private owner;
    address private forwardingAddress;

    constructor(address toForward) public {
       owner = msg.sender;
       forwardingAddress = toForward;
   }

    function () public payable {
        forwardingAddress.transfer(msg.value);
    }

    function transferTokensTo(address token, address to, uint256 amount) public onlyOwner{
        require(!avoidReentrancy);
        avoidReentrancy = true;
        ERC20(token).transfer(to, amount);
        avoidReentrancy = false;
    }

    //Reserve access only for the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }
}
