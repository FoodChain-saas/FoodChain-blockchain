//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./IERC165.sol";

interface IERC721 is IERC165 {
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed from, address indexed to, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed delegate, uint256 indexed tokenId);

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256  tokenId) external view returns (address);

    function safeTransferFrom(address from, address to, uint256 tokenId) external payable returns (uint256);

    function approve(address to, uint256 tokenId) external returns (bool);

    function getApproved(uint256 tokenId) external view returns (uint256);

    function setApprovalForAll(address delegate, bool _tokenApprovals) external;

    function isApprovalForAll(address owner, address operator) external view returns (address);

     function _exist(address _owners, uint256 tokenId) external view returns (bool);

    function _isApprovedOrOwner(address owner, address approved) external view returns (bool);

    function _safeTransfer(address recepient, uint256 tokenId) external returns (uint256);

    function _operatorApprovals(address approvedOperator) external view returns (address);
}