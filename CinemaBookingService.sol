// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.4.0 <0.7.0;

/// @author Jorge Lopez Pellicer
/// @title Cinema Booking Service
contract CinemaBooking {

    int cinemaRoomSpace = 100;
    int cinemaOcupationStatus = 0;

    address owner;
    mapping (address => bool) assistans;

    // Events
    event no_space_left();
    event ticket_already_bought();
    event user_not_yet_registered();

    /*
    *   Constructor used to set the owner of the contract 
    *   as the one who deploys it into the blockchain
    */
    constructor () public{
        owner = msg.sender;
    }

    /*
    *   Buys a ticket and blocks a spot for you
    */
    function BuyTicket() public {
        if(!SpaceForOneMore()){
            emit no_space_left();
            return;
        }

        if(assistans[msg.sender]) {
            emit ticket_already_bought();
            return;
        }

        assistans[msg.sender] = true;
        cinemaOcupationStatus++;
    }

    /*
    *   Returns how many space are still free 
    */
    function SpaceLeft() public view returns(int) {
        return cinemaRoomSpace - cinemaOcupationStatus;
    }

    /*
    *   Cancel your ticket
    */
    function CancelTicket() public {
        if(assistans[msg.sender]) {
            assistans[msg.sender] = false;
            cinemaOcupationStatus--;
            return;
        }

        emit user_not_yet_registered();

    }

    /*
    *   Check if there is space left in the cinema
    */
    function SpaceForOneMore() private view returns(bool){
        return cinemaOcupationStatus < cinemaRoomSpace;
    }

    /*
    *   As long as you are the owner you are able to cancel anyone's ticket
    */
    function CancelTicket(address _address) public OnlyCinemaManager(msg.sender) {
        if(assistans[_address]) {
            assistans[_address] = false;
            cinemaOcupationStatus--;
            return;
        }
        emit user_not_yet_registered();
    }

    /*
    *   Modified to validate the user is the owner of the contract
    */
    modifier OnlyCinemaManager(address _address){
        require(_address == owner, "You need to be the cinema manager in order to cancel other people's tickets.");
        _;
    }

}
