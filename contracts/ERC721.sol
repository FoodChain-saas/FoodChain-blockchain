//SPDX-License_Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC165.sol";
import "./IERC721Metadata.sol";
import "./IERC721Enumerable.sol";
import "./ERC721Enumerable.sol";
import "./IERC721Receiver.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract ERC721 is IERC165,
IERC721Metadata, IERC721Receiver,
IERC721Enumerable, ERC721Enumerable{
    // using Address for address;
    // using Strings for uint256;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private _name;
    string private _symbol;

    mapping(uint256 => address) private _owners;
    mapping(address => uint256) private _balances;
    mapping(uint256 => address) private _tokenApprovals;
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    constructor(string memory name, string memory symbol){
        _name = name;
        _symbol = symbol;
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override (IERC165, ERC721Enumerable) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId  ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Address zero is an invalid owner");
        return _balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Address zero is an invalid owner");
        return owner;
    }

    function approve(address delegate, uint256 tokenId) public returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        require(delegate != owner, "Check delegated user");

        require(msg.sender == owner, "This token does not belong to you");
        require(msg.sender == isApprovalForAll(owner, delegate), "Approval Unsuccessful");

        approve(delegate, tokenId);
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token does not exist:");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId)) : " ";
    }

    function _baseURI() internal view virtual returns (string memory) {
        return " ";
    }

    function getApproved(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return tokenId;
    }

    function setApprovalForAll(
        address owner, uint256 tokenId, address delegate)
        public returns(address) {
        require(owner != delegate, "Owner cannot approve himself");
        // address approved = _operatorApprovals[owner][delegate];
        
        return delegate;

        emit ApprovalForAll(msg.sender, delegate, tokenId);
    }

    function isApprovalForAll(address owner, address operator) public view returns (address) {
        return operator;
    }

    function safeTransfer(address from, address to, uint256 tokenId) public returns (uint256) {
        require(from == ownerOf(tokenId), "Token does not belong to this user");
        require(_exists(tokenId), "Token does not exist");
        require(to != address(0), "Wrong destination");

        _beforeTokenTransfer(from, to, tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);

        return tokenId;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public payable returns (uint256) {
        require(_exists(tokenId), "Item does not exist");
        require(from == ownerOf(tokenId), "Item does not belong to this user");
        require(to != address(0), "Inappropriate transfer");
        // require(from == msg.sender, isApprovedOrOwner(msg.sender, tokenId), 
        // "Error: Unapproved Tranfer");
        
        safeTransfer(from, to, tokenId);

        emit Transfer(msg.sender, to, tokenId);

        return tokenId;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal 
    returns(address) {
        require(_exists(tokenId), "Item does not exist");
        address owner = ERC721.ownerOf(tokenId);
        return spender;
        // return(spender ==  owner || isApprovalForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function safeMint(address to, uint256 tokenId, bytes memory _data) internal {
        require(to != address(0), "Token cannot be minted to this address");
        require(!_exists(tokenId), "Token exist already");
        require(checkOnERC721Received(address(0), to, tokenId, _data),
        "Please transfer to a Reeicever account");

        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        _afterTokenTransfer(address(0), to, tokenId);

    }

    function burn(address owner, uint256 tokenId) internal {
        require(owner == ownerOf(tokenId), "Token does not belong to you");
        require(_exists(tokenId), "Token does not exist");
        _beforeTokenTransfer(address(0), owner, tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        _afterTokenTransfer(address(0), owner, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId)
        public view returns
        (uint256) {
        return tokenId;
    }

    function checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
    private returns (bool){
      if (isContract(to)) {
          try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data) returns (bytes4 retval) {
              return retval == IERC721Receiver.onERC721Received.selector;
        } catch (bytes memory reason) {
            if (reason.length == 0) {
                revert("ERC721: transfer to non ERC721Receiver implementer");
        } else {
                assembly {
                    revert(add(32, reason), mload (reason))
                }
            }
        }
      } else {
          return true;
      }
    }

        function isContract(address _address) public view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(_address)
        }

        return(size > 0);
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override  virtual {}
    function _afterTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}

    //CONTEXT: _msgSender() _msgData()
}