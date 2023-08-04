// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SendEtherAndERC20Token {
  string public name;
  string public symbol;
  uint8 public decimals;
  uint256 public totalSupply;

  receive() external payable {}

  constructor(
    string memory _name,
    string memory _symbol,
    uint8 _decimals,
    uint256 _initialSupply
  ) payable {
    name = _name;
    symbol = _symbol;
    decimals = _decimals;
    totalSupply = _initialSupply * (10**uint256(_decimals));
    balanceOf[msg.sender] = totalSupply;
  }

  mapping(address => uint256) public balanceOf;
  mapping(address => mapping(address => uint256)) public allowance;

  event Transfer(address indexed from, address indexed to, uint256 value);
  event Approval(address indexed owner, address indexed spender, uint256 value);

  function approve(address spender, uint256 value) external returns (bool) {
    allowance[msg.sender][spender] = value;

    emit Approval(msg.sender, spender, value);
    return true;
  }

  function transferToken(
    address payable from,
    address payable to,
    uint256 value
  ) external returns (bool) {
    require(to != address(0), "Invalid recipient");
    require(balanceOf[from] >= value, "Insufficient balance");
    require(allowance[from][msg.sender] >= value, "Allowance exceeded");

    balanceOf[from] -= value;
    balanceOf[to] += value;
    allowance[from][msg.sender] -= value;

    emit Transfer(from, to, value);
    return true;
  }

  function transferEth(address payable _to, uint256 amount) external payable {
    _to.transfer(amount);
  }
}