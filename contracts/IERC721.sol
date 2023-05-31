//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed from, address indexed to, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed delegate, uint256 indexed tokenId);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256  tokenId) external view returns (address);

    function safeTransferFrom(address from, address to, uint256 tokenId) external payable {
        require(from != address(0), "Inappropriate Transaction");
        require(from != address(0), "Inappropriate Transaction");
        require(_exist(tokenId), "Token does not exist");
        require(from == ownerOf(tokenId), "Token does not belong to this address");
        require(_isApprovedOrOwner(msg.sender, tokenId), "Error: User not approved or Invalid owner");

        _safeTransfer(from, to, tokenId);

        emit Transfer(msg.sender, to, tokenId);
    }

    function approve(address to, uint256 tokenId) external {
        require(_exist(tokenId), "Token does not exist");
        require(_isApprovedOrOwner(msg.sender, tokenId), "Invalid Owner");

        emit Approval(ownerOf(tokenId), to, tokenId);
    }

    function getApproved(uint256 tokenId) external view returns (address delegate) {
        require(_exist(tokenId), "Token does not exist");
    }

    function setApprovalForAll(address delegate, bool _tokenApprovals) external {
        require(msg.sender != delegate, "Inappropriate Transaction");

        emit ApprovalForAll(msg.sender, delegate, _tokenApprovals);
    }

    function isApprovalForAll(address owner, address operator) external view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

     function _exist(address _owners, uint256 tokenId) internal view returns (bool) {
        return _owners[tokenId] != address(0);
    }

    function _isApprovedOrOwner(address owner, address approved) public view returns (bool) {

    }

    function _safeTransfer(address recepient, uint256 tokenId) public view
    returns (uint256) {

    }

    function _operatorApprovals(address approvedOperator) public view returns (address) {

    }
}