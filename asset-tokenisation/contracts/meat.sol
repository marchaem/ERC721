pragma solidity ^0.4.23;

import "zeppelin-solidity/contracts/token/ERC721/ERC721Token.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

contract MeatToken is ERC721Token("MEAT", "MET"), Ownable {

    struct Meat{

        uint8 origin;
        uint8 productType;
        uint8 quality;

    }

    Meat[] meats;

    mapping (uint => bool) canBeRefined; 

    function getInt() public pure  returns (uint) {
        return 9;
    }

    
    /// @dev Create a new barrel and returns is id which is the length of the array minus 1
    /// @param _origin location code
    /// @param _productType product code (see Barrel Struct)
    /// @param _quality 0 to 255, 0 is not analyze barrel
    /// @param _refinable true if refinable token 
    function newMeat(uint8 _origin, uint8 _productType, uint8 _quality, bool _refinable) internal returns(uint){
        Meat memory _barrel = Meat(_origin, _productType, _quality);
        uint _id = meats.push(_barrel) - 1;
        canBeRefined[_id] = _refinable;
        return _id;
    }

    /// @dev Create a brut token token_id is the index in barrels Array
    /// @param _origin location code
    function mintBrut(uint8 _origin, uint8 _productType, uint8 _quality) public onlyOwner {
        _mint(msg.sender, newMeat(_origin, _productType,  _quality, true));
    }

    /// @dev Retrieve un array of id corresponding to allOwned Token
    function getOwnedBarrels() public view returns(uint[]) {
        return ownedTokens[msg.sender];
    }

    /// @dev Retrieve un array of id corresponding to allOwned Token
    function getBarrelById(uint _id) public view returns(uint256, uint8, uint8, uint8, bool){
        require(_id < meats.length);

        Meat memory _barrel = meats[_id];
        return (_id, _barrel.origin, _barrel.productType, _barrel.quality, canBeRefined[_id]);
    }

}
