// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "node_modules/@openzeppelin/contracts/access/Ownable.sol";
import "node_modules/@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @title DynamicNFT - A dynamic non-fungible token contract with loyalty rewards.
/// @dev This contract extends the ERC721 standard and allows for the minting of dynamic NFTs.
contract DynamicNFT is ERC721, Ownable {
    uint256 public loyaltyLevel;
    uint256 public constant TOKENS_FOR_LEVEL_2 = 10;
    uint256 public constant TOKENS_FOR_LEVEL_3 = 30;
    IERC20 public token; // Assuming ERC20 token for simplicity

    // Event to track loyalty level upgrades
    event LoyaltyLevelUpgrade(address indexed user, uint256 newLevel);

    /// @dev Constructor to initialize the DynamicNFT contract.
    /// @param _name The name of the NFT.
    /// @param _symbol The symbol of the NFT.
    /// @param _tokenAddress The address of the ERC20 token used for rewards.
    constructor(string memory _name, string memory _symbol, address _tokenAddress) ERC721(_name, _symbol) Ownable(msg.sender) {
        loyaltyLevel = 1;
        token = IERC20(_tokenAddress);
    }

    /// @dev Function to mint a new NFT and assign it to the specified address.
    /// @param _to The address to which the NFT will be minted.
    function mint(address _to) external onlyOwner {
        _mint(_to, totalSupply() + 1);
    }

    /// @dev Function to allow users to claim rewards based on their loyalty level.
    function claimReward() external {
        require(loyaltyLevel >= 2, "You need to reach a higher loyalty level to claim this reward");
        
        if (loyaltyLevel == 2) {
            token.transfer(msg.sender, TOKENS_FOR_LEVEL_2);
        } else if (loyaltyLevel == 3) {
            token.transfer(msg.sender, TOKENS_FOR_LEVEL_3);
        }
    }

    /// @dev Function to allow the owner to evolve the loyalty level.
    /// @param _newLevel The new loyalty level to set.
    function evolveLoyaltyLevel(uint256 _newLevel) external onlyOwner {
        loyaltyLevel = _newLevel;
        emit LoyaltyLevelUpgrade(msg.sender, _newLevel);
    }

    /// @dev Function to get the total supply of tokens.
    /// @return The total number of NFTs minted in the contract.
    function totalSupply() view public returns (uint256) {
        return balanceOf(address(this));
    }
}
