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

    //Transfer tokens out of the contract
    function transferTokensTo(address token, address to, uint256 amount) public onlyOwner{
        require(!avoidReentrancy);
        avoidReentrancy = true;
        ERC20(token).transfer(to, amount);
        avoidReentrancy = false;
    }

    //Change the address you wish the ETH to be forwarded to
    function changeForwardingAddress(address newAddress) public onlyOwner{
        forwardingAddress = newAddress;
    }

    //Change the current owner
    function changeOwner(address newOwner) public onlyOwner{
        owner = newOwner;
    }

    //Reserve access only for the owner
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

}
