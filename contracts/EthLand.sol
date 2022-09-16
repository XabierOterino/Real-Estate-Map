// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract EthLand is ERC721 {
    error Minting_Error();

    uint256 public constant x= 1 * 10 ** 10; 
    uint256 public constant y= 1 * 10 ** 10;

    uint256 public constant heigthInvarian = 120;

    uint256 public constant parcel_sqr_m_price = 1000;
    uint256 public constant building_sqr_m_price = 1100;
    uint256 public constant property_sqr_m_price = 1400;

    uint private _parcelCount=1;
    uint private _propertyCount=1;
    uint private _buildingCount=1;

    mapping(uint256=> Parcel) private _idToParcel;
    mapping(uint256=> Building) private _idToBuilding;
    mapping(uint256=> Property) private _idToProperty;
   
    struct Parcel{
        uint256 id;
        uint256 posX;
        uint256 posY;
        uint256 sizeX;
        uint256 sizeY;
        uint256 [] buildings;
        address owner;
    }

    struct Building{
        uint256 id;
        uint256 posRelativeX;
        uint256 posRelativeY;
        uint256 sizeX;
        uint256 sizeY;
        uint256 sizeZ;
        uint256 [] properties;
        address owner;
    }

    struct Property{
        uint256 id;
        uint256 posRelativeX;
        uint256 posRelativeY;
        uint256 sizeX;
        uint256 sizeY;
        uint256 sizeZ=3;
        uint256 floorNumber;
        bool luxury;
        address owner;
    }

   function mintParcel(
        uint256 posX,
        uint256 posY,
        uint256 sizeX,
        uint256 sizeY
   ) public payable{

        uint256 mintingPrice = pos  
        require(msg.value>=mintingPrice , "Didnt pay enough");
   }

   function mintBuilding() public payable{

   }
   function mintProperty() public payable{

   }

   modifier parcelIsFree(
        uint256 posX,
        uint256 posY,
        uint256 sizeX,
        uint256 sizeY
   ){
    require(posX + sizeX<x && posY + sizeY < y , "Out of map");
    uint256 routeX= [posX , posX + sizeX]
    uint256 routeY = [posY , posY + sizeY];
    for(uint i = 0 ; i< _parcelCount; i++){
        uint256 _routeX= [_idToParcel[i].posX , _idToParcel[i].posX +_idToParcel[i].sizeX]
        uint256 _routeY= [_idToParcel[i].posY , _idToParcel[i].posY +_idToParcel[i].sizeY]
    }
    _;
   }
}
