// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";
import "./Ownable.sol";

contract QuimioToken is IERC20, Ownable{
    string public constant name = "QuimioToken";
    string public constant symbol = "QMO";
    uint public constant decimals = 9;
    
    mapping(address=>uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    uint256 totalSupply_;

    constructor(uint initialSupply){
        totalSupply_ = initialSupply;
        balances[msg.sender]=totalSupply_;
    }

    function totalSupply() public override view returns (uint256){
        return totalSupply_;
    }

    function balanceOf(address tokenOwner) public override view returns (uint256){
        return balances[tokenOwner];
    }

    function allowance(address owner, address delegate) public override view returns (uint256){
        return allowed[owner][delegate];
    }

    function transfer(address recipient, uint256 numTokens) public override returns (bool){
        require(numTokens <=balances[msg.sender]);
        balances[msg.sender]=balances[msg.sender] - (numTokens);
        balances[recipient]=balances[recipient] + (numTokens);
        emit Transfer(msg.sender, recipient, numTokens);
        return true;
    }

    function approve(address delegate, uint256 numTokens) public override returns (bool){
        allowed[msg.sender][delegate]=numTokens;
        emit Approval(msg.sender, delegate, numTokens);
        return true;
    }
    
    function increaseTotalSupply(uint newTokensAmount) public onlyOwner() {
        totalSupply_+=newTokensAmount;
        balances[msg.sender]+= newTokensAmount;
    }

    function transferFrom(address owner, address buyer, uint256 numTokens) public onlyOwner() override returns (bool){
        require(numTokens <= balances[owner]);
        require(numTokens <= allowed[owner][msg.sender]);
        balances[owner] = balances[owner] - (numTokens);
        allowed[owner][msg.sender]=allowed[owner][msg.sender] - (numTokens);
        balances[buyer]=balances[buyer] + (numTokens);
        emit Transfer (owner, buyer, numTokens);
        return true;
    }

    function burn(address _account, uint256 _amount) public onlyOwner {
        require(_amount != 0);
        require(_amount <= balances[_account]);
        totalSupply_ -= _amount;
        balances[_account] -= _amount;
        emit Transfer(_account, address(0), _amount);
    }
}