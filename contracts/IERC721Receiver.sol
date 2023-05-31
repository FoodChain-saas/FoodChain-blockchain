//SPDX-License-Identifer: MIT

pragma solidity ^0.8.7;

interface IERC721Receiver {
    
    function onERC721Received(
        address operator,
        address form,
        uint256 tokenId,
        bytes calldata data
    ) external returns (bytes4);
    
}