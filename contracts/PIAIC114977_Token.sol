// SPDX-License-Identifier: MIT
// Assignment#3_ERC20, submitted by PIAIC114977 

pragma solidity ^0.8.0;

interface IERC20{
    
    function totalSupply() external view returns(uint256);
    function balanceOf(address account) external view returns(uint256);
    function transfer(address receipient, uint256 amount) external returns(bool);
    function allowance(address owner, address spender) external returns(uint256);
    function approve(address spender, uint256 amount) external returns(bool);
    function transferFrom(address sender, address receipient, uint256 amount) external returns(bool);
    
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract PIAIC114977_Token is IERC20{
    
    mapping (address => uint256) private _balances;
    mapping (address => mapping (address => uint256)) private _allowances;
    
    uint256 private _totalSupply;
    address public owner;
    string public name;
    string public symbol;
    uint256 public decimals;
    uint256 public tokenPrice;
    
    event Price(bool success,uint256 price);
    event TokensSold(address owner, address recipient, uint256 numberOfTokens);
    event AmountReceived(string);
    
    
    constructor(uint256 _price) {
        
        require(_price > 0, "BCC1: Token price must be valid");
        
        owner = msg.sender;
        name = "PIAIC114977 Token";
        symbol = "BCC-13";
        decimals = 18;
        tokenPrice = _price;
        
        _totalSupply = 1000000 * 10 ** decimals;
        _balances[owner] = _totalSupply;
        
        emit Transfer(address(this),owner,_totalSupply);
    }
    
    modifier ownerOnly(){
        require(msg.sender == owner, "BCC1: Only token owner allowed");
        _;
    }
    
    function totalSupply() external override view returns(uint256){
        return _totalSupply;
    }
    
    function balanceOf(address account) external override view returns(uint256){
        return _balances[account];
    }
    
    function transfer(address receipient, uint256 amount) public virtual override returns (bool){
        address sender = msg.sender;
        require(msg.sender != address(0), "BCC1: Transfer from the zero address");
        require(receipient != address(0), "BCC1: Transfer to the zero address");
        require(_balances[sender] > amount, "BCC: Transfer amount exceeds balance");
        
        _balances[sender] = _balances[sender] - amount;
        _balances[receipient] = _balances[receipient] + amount;
        
        emit Transfer(sender, receipient, amount);
        
        return true;
    }
    
    function allowance(address tokenOwner, address spender) public view virtual override returns(uint256){
        return _allowances[tokenOwner][spender];
    } 
    
    function approve(address spender, uint256 amount) public virtual override returns(bool){
        address tokenOwner = msg.sender;
        require(tokenOwner != address(0), "BCC1: Approve from the zero address");
        require(spender != address(0), "BCC1: Transfer to the zero address");
        _allowances[tokenOwner][spender] = amount;
        
        emit Transfer(tokenOwner, spender,amount);
        return true;
    }
    
    function transferFrom(address tokenOwner, address receipient, uint256 amount) public virtual override returns(bool){
        address spender = msg.sender;
        uint256 _allowance =  _allowances[tokenOwner][spender];
        require(_allowance > amount, "BCC1: Transfer amount exceeds balance");
        
        _allowance = _allowance - amount;
        _balances[tokenOwner] = _balances[tokenOwner] - amount;
        _balances[receipient] = _balances[receipient] + amount;
        
        emit Approval(tokenOwner, spender, amount);
        
        return true;
    }
    
    function adjustPrice(uint256 _price) public ownerOnly returns(bool){
        require(_price > 0, "BCC1: Token price must be valid");
        tokenPrice = _price;
        emit Price(true, _price);
        return true;
    } 
    
    function buyToken() public payable returns(bool){
    
        address _recipient = msg.sender;
        
        require(_recipient != address(this), "BCC1: Buyer cannot be a contract");
        require(_recipient != address(0), "BCC1: Transfer to the zero address");
        require(msg.value > 0, "BCC1: Amount must be valid");
        
        
        uint256 _numberOfTokens = (msg.value*10**decimals)/tokenPrice;
       
        require(_numberOfTokens > 0, "BCC1: Number of tokens must be valid");
        require(_balances[owner] >= _numberOfTokens, "BCC1: insufficient tokens");
        
        _balances[owner] = _balances[owner] - _numberOfTokens; 
        
        _balances[_recipient] = _balances[_recipient] + _numberOfTokens;
        
        //transfer incoming ethers(money) to contractOwner
        payable(owner).transfer(msg.value);
        
        emit TokensSold(owner, _recipient, _numberOfTokens);
        return true;
    }
    
    /**
     * This is fallback function and sends tokens if anyone sends ether
     *
     * - if anyone sends 1 wei than 100 tokens will be transferred to him/her if 
     * tokenPrice is 0.01 ether i.e 10000000000000000 wei (subject to change with tokenPrice)
     */
    
    receive() external payable {
        buyToken();
        emit AmountReceived("Receive fallback");
    }
    
}