pragma solidity ^0.4.23;

import "./TokenAsset.sol";

contract TokenAssetRefining is TokenAsset {

    function refineToken(uint _tokenId) public onlyOwnerOf(_tokenId) {

        require(canBeRefined[_tokenId]);

        uint8 _origin;
        uint8 _quality;
        (,_origin,,_quality,) = getBarrelById(_tokenId);

        _mint(msg.sender, newBarrel(_origin, 1, _quality, false));
        _mint(msg.sender, newBarrel(_origin, 2, _quality, false));
        _mint(msg.sender, newBarrel(_origin, 3, _quality, false));

        canBeRefined[_tokenId] = false;

    }

}