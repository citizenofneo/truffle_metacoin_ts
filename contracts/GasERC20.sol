pragma solidity ^0.5.1;

import './Ownable.sol';
import './SafeMath.sol';

contract GasERC20 is Ownable {
    using SafeMath for uint256;

    mapping (address => uint256) private _balances;

    mapping (address => mapping (address => uint256)) private _allowances;

    // Addresses that will not be taxed
    struct ExcludeAddress {bool isExist;}

    mapping (address => ExcludeAddress) public excludeSendersAddresses;
    mapping (address => ExcludeAddress) public excludeRecipientsAddresses;

    address serviceWallet;

    uint taxPercent = 2;

    // Token params
    string public constant name = "TestName";
    string public constant symbol = "TectCoin";
    uint public constant decimals = 18;
    uint constant total = 10000;
    uint256 private _totalSupply;
    // -- Token params

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() public {
        _mint(msg.sender, total * 10**decimals);
    }

    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _taxTransfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
        _taxTransfer(sender, recipient, amount);
        _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount, "ERC20: transfer amount exceeds allowance"));
        return true;
    }

    function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
        return true;
    }

    function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
        _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");

        _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
        _balances[recipient] = _balances[recipient].add(amount);
        emit Transfer(sender, recipient, amount);
    }

    function _mint(address account, uint256 amount) internal {
        require(account != address(0), "ERC20: mint to the zero address");

        _totalSupply = _totalSupply.add(amount);
        _balances[account] = _balances[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");

        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

     function _taxTransfer(address _sender, address _recipient, uint256 _amount) internal returns (bool) {

       if(!excludeSendersAddresses[_sender].isExist && !excludeRecipientsAddresses[_recipient].isExist){
        uint _taxedAmount = _amount.mul(taxPercent).div(100);
        uint _transferedAmount = _amount.sub(_taxedAmount);

        _transfer(_sender, serviceWallet, _taxedAmount); // tax to serviceWallet
        _transfer(_sender, _recipient, _transferedAmount); // amount - tax to recipient
       } else {
        _transfer(_sender, _recipient, _amount);
       }

        return true;
    }



    // OWNER utils
    function setAddressToExcludeRecipients (address addr) public onlyOwner {
        excludeRecipientsAddresses[addr] = ExcludeAddress({isExist:true});
    }

    function setAddressToExcludeSenders (address addr) public onlyOwner {
        excludeSendersAddresses[addr] = ExcludeAddress({isExist:true});
    }

    function removeAddressFromExcludes (address addr) public onlyOwner {
        excludeSendersAddresses[addr] = ExcludeAddress({isExist:false});
        excludeRecipientsAddresses[addr] = ExcludeAddress({isExist:false});
    }

    function changePercentOfTax(uint percent) public onlyOwner {
        taxPercent = percent;
    }

    function changeServiceWallet(address addr) public onlyOwner {
        serviceWallet = addr;
    }
}
