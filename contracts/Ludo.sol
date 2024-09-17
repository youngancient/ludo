// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// a simple ludo with max of 2 players playing One game at a time
contract SimpleLudo{
    error MaxRegistrationsReached();
    error UserRegisteredAlready();
    error ZeroAddressNotAllowed();
    error NonPlayerNotAllowed();

    enum playerColor{
        RED, BLUE
    }

    struct Player{
        uint id;
        playerColor color;
    }

    uint8 counter;

    // a dice contains 2 die with have 6 faces each
    // a dice is a 2D-array
    
    uint8[6][6] dice;

    mapping (address => Player) registeredPlayer;

    // this boolean starts the game when 2 players are registered
    bool startGame;

    // prevents any unregisterd player from interfering
    function onlyPlayer() private view{
        if(registeredPlayer[msg.sender].id == 0){
            revert NonPlayerNotAllowed();
        }
    }

    // a dice contains 2 die with have 6 faces each
    // a dice is a 2D-array
    function rollDice() external{
        onlyPlayer();
        if(startGame){
            // dice roll logic here

        }
    }

    function registerToPlay(playerColor _color) external{
        // does not allow more than 2 players
        if(counter + 1 > 2){
            revert MaxRegistrationsReached();
        }
        if(msg.sender == address(0)){
            revert ZeroAddressNotAllowed();
        }

        if(registeredPlayer[msg.sender].id != 0){
            revert UserRegisteredAlready();
        }
        counter++;
        registeredPlayer[msg.sender] = Player(counter,_color);

        // start game if no of player == 2
        if(counter == 2){
            startGame = true;
        }
    }
}
