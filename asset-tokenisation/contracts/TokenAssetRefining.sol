pragma solidity ^0.4.23;

import "./TokenAsset.sol";

contract TokenAssetRefining is TokenAsset {
    mapping(uint => uint) _previousToken;
    function refineToken(uint _tokenId) public onlyOwnerOf(_tokenId) {
        
        require(canBeRefined[_tokenId]);

        uint8 _origin;
        uint _price;
        uint8 _type;
        (, _origin, _type, _price,) = getBarrelById(_tokenId);
        if(_type == 3) {
            _mint(msg.sender, newBarrel(_origin, 4, _price/5, false));
        }
        else if(_type != 4 ){
            _mint(msg.sender, newBarrel(_origin, 1, _price/2, false));
            _mint(msg.sender, newBarrel(_origin, 2, _price/2, false));
            _mint(msg.sender, newBarrel(_origin, 3, _price/3, true));
        }

        _previousToken[_tokenId] = _tokenId; //a changer  dans les crochets
        canBeRefined[_tokenId] = false;

    }

    function previousToken(uint _tokenId) internal view returns(uint){
        return _previousToken[_tokenId];
    }

}