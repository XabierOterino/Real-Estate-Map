// SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
* This contract holds a more complex kind of metaverse
* Its divided in parcels, that are divided in buildings, that are divided in properties;
 */
contract EthLand is ERC721 {
    error Minting_Error();
    IERC20 public inmutable TOKEN;
    // Size of the map
    uint256 public constant x= 1 * 10 ** 10; 
    uint256 public constant y= 1 * 10 ** 10;
    // The 1.2 multiplier to penalize building higher buildings
    uint256 public constant heigthInvarian = 120;

    // Square meters prices for different types of assets
    uint256 public constant parcel_sqr_m_price = 1000;
    uint256 public constant building_sqr_m_price = 1100;
    uint256 public constant property_sqr_m_price = 1400;

    uint private _parcelCount=1;
    uint private _propertyCount=1;
    uint private _buildingCount=1;

    mapping(address=>mapping(uint256 => uint256[])) private _balances;
    mapping(uint256=> Parcel) private _idToParcel;
    mapping(uint256=> Building) private _idToBuilding;
    mapping(uint256=> Property) private _idToProperty;
   
   ///STRUCTS
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

    constructor(address tokenAddress){
        token = IERC20(tokenAddress);

    }
    /**
    @dev funciton to mint a new parcel from the map
    @param position(x,y)
    @param dimensions(x,y)
     */
   function mintParcel(
        uint256 posX,
        uint256 posY,
        uint256 sizeX,
        uint256 sizeY
   ) public 
    parcelIsFree( 
        uint256 posX,
        uint256 posY,
        uint256 sizeX,
        uint256 sizeY
    )
    {
        uint256 mintingPrice = sizeX * sizeY * parcel_sqr_m_price;
        _pullFunds(mintingPrice);
        _mint(msg.sender,1, _parcelCount);
        _parcelCount++;
    }

   function mintBuilding(
    uint256 parcelId,
    uint256 posRelativeX,
    uint256 posRelativeY,
    uint256 sizeRelativeX,
    uint256 sizeRelativeY
   ) public buildingIsFree() {


   }
   function mintProperty() public {

   }

    /**
    Checks that the parcel doesnt overlap other(s)
     */
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
        if(
            (routeX[1] >= _routeX[0] || routeX[0] <= _routeX[1])
            || (routeY[1] >= _routeY[0] || routeY[0] <= _routeY[1])    
        ) revert Minting_Error();
    }
    _;
   }
    /**
    * Checks that the parcel is owner by the user and that the building van be built
     */

   modifier buildingIsFree(
        uint256 id,
        uint256 posX,
        uint256 posY,
        uint256 sizeX,
        uint256 sizeY
   ){
    require(_balances[msg.sender][1].length>0);
    bool isOwner;
    Parcel memory parcel;
    for(uint256 i=0; i<_balances[msg.sender][1].length; i++){
        if(_balances[msg.sender][1][i]==id){ 
            isOwner=true;
            parcel = _balances[msg.sender][1][i];
        }
    }
    if(!isOwner) revert Minting_Error();

    require(posX + sizeX<parcel.x && posY + sizeY < parcel.y , "Out of parcel");
    uint256 routeX= [posX , posX + sizeX]
    uint256 routeY = [posY , posY + sizeY];
    for(uint i = 0 ; i< _parcelCount; i++){
        uint256 _routeX= [_idToParcel[i].posX , _idToParcel[i].posX +_idToParcel[i].sizeX]
        uint256 _routeY= [_idToParcel[i].posY , _idToParcel[i].posY +_idToParcel[i].sizeY]
        if(
            (routeX[1] >= _routeX[0] || routeX[0] <= _routeX[1])
            || (routeY[1] >= _routeY[0] || routeY[0] <= _routeY[1])    
        ) revert Minting_Error();
    }
    _;
   }


   function _pullFunds(uint256 amount) private{
        TOKEN.transferFrom(msg.sender ,address(this) , amount);
   }

   function _mint(address recipient , uint256 token, uint256 id) private{
        _balances[recipient][token].push(id);
   }


   
}
