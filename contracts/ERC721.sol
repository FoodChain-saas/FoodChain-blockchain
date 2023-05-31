//SPDX-License_Identifier: MIT
pragma solidity ^0.8.7;

import "./IERC721.sol";
import "./IERC165.sol";
import "./IERC721Metadata.sol";
import "./IERC721Enumerable.sol";
import "./ERC721Enumerable.sol";
import "./IERC721Receiver.sol";

contract ERC721 is IERC721, IERC165, IERC721Metadata, IERC721Receiver, IERC721Enumberable, ERC721Enumerable{
    using Address for address;
    using Strings for uint256;

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

    function supportsInterface(bytes4 interfaceId) public view virtual override (ERC165, IERC165) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId  ||
            interfaceId == type(IERC721JMetadata).interfaceId ||
            super.supportsInterface(interfaceId);
    }
    
    function balanceOf(address owner) public view returns (uint256) {
        require(owner != address(0), "Address zero is an invalid owner");
        return balances[owner];
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address owner = _owners[tokenId];
        require(owner != address(0), "Address zero is an invalid owner");
        return owner;
    }

    function approve(address delegate, uint256 tokenId) public returns (bool) {
        address owner = ERC721.ownerOf(tokenId);
        require(delegate != owner, "Check delegated user");

        require(msg.sender == owner || isApprovedForAll(owner, msg.sender), "Approval Unsuccessful");

        _approve(to, tokenId);
    }

    function tokenURI(uint256 tokenId) public virtual override returns (string memory) {
        require(_exixts(tokenId), "Token does not exist:");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : " ";
    }

    function baseURI() internal view virtual returns (string memory) {
        return " ";
    }

    function getApproved(uint256 tokenId) public returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return _tokenApprovals[tokenId];
    }

    function setApprovalForAll(address owner, address delegate, bool _tokenApproval) public returns(bool) {
        require(owner != delegate, "Owner cannot approve himself");
        _operatorApprovals[owner][delegate] = approved;
        emit ApprovalForAll(msg.sender, delegate, approved);
        return _tokenApproval;
    }

    function isApprovalForAll(address owner, address operator) public returns (address) {
        return _operatorApprovals[owner][operator];
    }

    function approve(address to, uint256 tokenId) internal virtual {
        _tokenApprovals[tokenId] = to;
        emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
    }

    function safeTransfer(address from, address to, uint256 tokenId) public returns (uint256) {
        require(from == ownerOf(tokenId), "Token does not belong to this user");
        require(_exist(tokenId), "Token does not exist");
        require(to != address(0), "Wrong destination");

        _beforeTokenTransfer(from, to, tokenId);

        _balances[from] -= 1;
        _balances[to] += 1;
        _owners[tokenId] = to;

        emit Transfer(from, to, tokenId);

        _afterTokenTransfer(from, to, tokenId);

        return tokenId;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public returns (uint256) {
        require(_exists(tokenId), "Item does not exist");
        require(from == ownerOf(tokenId), "Item does not belong to this user");
        require(to != address(0), "Inappropriate transfer");
        require(_isApprovedOrOwner(msg.sender, tokenId), "Error: Unapproved Tranfer");
        
        _safeTransfer(from, to, tokenId);

        emit Transfer(msg.sender, to, tokenId);

        return tokenId;
    }

    function _exists(uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal {
        require(_exists(tokenId), "Item does not exist");
        address owner = ERC721.ownerOf(tokenId);
        return(spender ==  owner || isApprovedForAll(owner, spender) || getApproved(tokenId) == spender);
    }

    function safeMint(address to, uint256 tokenId) internal {
        require(to != address(0), "Token cannot be minted to this address");
        require(!_exists(tokenId), "Token exist already");
        require(_checkOnERC721received(address(0), to, tokenId), "Please transfer to a Reeicever account");

        _beforeTokenTransfer(address(0), to, tokenId);

        _mint(to, tokenId);

        _balances[to] += 1;
        _owners[tokenId] = to;

        _afterTokenTransfer(address(0), to, tokenId);

    }

    function burn(address owner, uint256 tokenId) internal {
        require(owner == ownerOf(tokenId), "Token does not belong to you");
        require(_exists(tokenId), "Token does not exist");
        _beforeTokenTransfer(address(0), to, tokenId);

        _balances[owner] -= 1;
        delete _owners[tokenId];

        _afterTokenTransfer(address(0), to, tokenId);
    }

    function transferFrom(
        address from,
        address to,
        uint256 tokenId)
        public view returns
        (uint256) {
        return tokenId;
    }

    function checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data)
    private view returns (bool){
      if (to.isContract()) {
          try IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, data) returns (bytes4 retval) {
              return retval == IERC721Receiver.onERC721Received.selected;
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

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {}
    function _afterTokenTransfer(addres from, addres to, uint256 tokenId) internal virtual {}

    //CONTEXT: _msgSender() _msgData()
}