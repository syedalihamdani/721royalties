// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "./ERC2981ContractWideRoyalties.sol";

contract nft is ERC721,ERC2981ContractWideRoyalties{
    using Strings for uint256;
    string public baseURI;
    string private baseExtension=".json";
      uint256 public royaltyValue; // Royalty value between 0 and 10,000
    address public royaltyRecipient; // Royalty Recipient
    uint public lastTokenId;

    constructor(string memory _name,string memory _symbol,string memory initialBaseURI)ERC721(_name,_symbol){
        baseURI=initialBaseURI;

    }

    function _baseURI() internal view virtual override returns (string memory) {
        return baseURI;
    }
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721,ERC2981Base) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = _baseURI();
        return bytes(currentBaseURI).length > 0 ? string(abi.encodePacked(currentBaseURI, tokenId.toString(),baseExtension))
         : "";
    }

     /// @dev Sets the royalty value and recipient
    /// @notice Only admin or claimer can call the function
    /// @param recipient The new recipient for the royalties
    /// @param value percentage (using 2 decimals - 10000 = 100, 0 = 0)
    function setRoyalties(address recipient, uint256 value) external {
            _setRoyalties(recipient, value);
            require(
                recipient != 0x0000000000000000000000000000000000000000,
                "Royalty recipient address cannot be Zero Address"
            );
            royaltyRecipient = recipient;
            royaltyValue = value;
    }

    function mint(address _to,uint _amount) public {
        for(uint i=0;i<_amount;i++){
        lastTokenId+=1;
        _safeMint(_to,lastTokenId);

        }
    }

}