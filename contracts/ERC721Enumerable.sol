//SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

// import "./ERC721.sol";
import "./IERC721Enumerable.sol";

contract ERC721Enumerable is IERC721Enumerable{

    mapping(address => mapping(uint256 => uint256)) private _ownedTokens;

    mapping(uint256 => uint256) private _ownedTokensIndex;

    uint256[] private _allTokens;

    mapping(uint256 => uint256) private allTokensIndex;

    function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
        return interfaceId == type(IERC721Enumerable).interfaceId || 
        supportsInterface(interfaceId);
    }

    function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
        // require(index < ERC721.balanceOf(owner), "Owner's index out of bound");
        return _ownedTokens[owner][index];
    }

    function totalSupply() public view virtual override returns (uint256) {
        return _allTokens.length;
    }

    function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
        require(index < ERC721Enumerable.totalSupply(), "Enumerable index out of bounds");

        return _allTokens[index];
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual {
        _beforeTokenTransfer(from, to, tokenId);

        if (from ==  address(0)) {_addTokenToAllTokensEnumeration(tokenId);}
        else if (from != to) {_removeTokenFromOwnerEnumeration (from, tokenId);}

        if (to == address(0)) {_removeTokenFromAllTokensEnumeration(tokenId);}
        else if (to != from) {_addtokenToOwnerEnumeration (to, tokenId);}
    }

    function _addtokenToOwnerEnumeration(address to, uint256 tokenId) private {
        uint256 length;
        _ownedTokens[to][length] = tokenId;
        _ownedTokensIndex[tokenId] = length;
    }

    function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
        allTokensIndex[tokenId] = _allTokens.length;
        _allTokens.push(tokenId);
    }

    function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
        uint256 lastTokenIndex;
        uint256 tokenIndex = _ownedTokensIndex[tokenId];

        if (tokenIndex != lastTokenIndex) {
            uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];

            _ownedTokens[from][tokenIndex] = lastTokenId;
            _ownedTokensIndex[lastTokenId] = tokenIndex;

            delete _ownedTokensIndex[tokenId];
            delete _ownedTokens[from][lastTokenIndex];
        }
    }

    function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
        uint256 lastTokenIndex = _allTokens.length - 1;
        uint256 tokenIndex = allTokensIndex[tokenId];

        uint256 lastTokenId = _allTokens[lastTokenIndex];

        _allTokens[tokenIndex] = lastTokenId;
        allTokensIndex[lastTokenId] = tokenIndex;

        delete allTokensIndex[tokenId];
        _allTokens.pop();
    }
}