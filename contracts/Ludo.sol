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
    error GameHasNotStarted();

    enum playerColor{
        RED, BLUE
    }

    struct Player{
        uint id;
        playerColor color;
        uint playerDicePosition;
        bool isWinner;
    }

    uint8 counter;

    // a dice contains 2 die with have 6 faces each
    // a dice is a 2D-array

    uint8[6][6] dice;

    // finishing line
    uint8 finishLine = 255;
    

    mapping (address => Player) registeredPlayer;

    // this boolean starts the game when 2 players are registered
    bool startGame;

    // prevents any unregisterd player from interfering
    function onlyPlayer() private view{
        if(registeredPlayer[msg.sender].id == 0){
            revert NonPlayerNotAllowed();
        }
    }

    function pseudorandomDiceRoll() private view returns(uint8){
        uint256 blockTimestamp = block.timestamp;
        uint8 dieRoll = uint8((blockTimestamp % 6) + 1);
        return dieRoll;
    }
    // rollDice generates 2 random numbers representing the faces
    function rollDice() external{
        onlyPlayer();
        if(!startGame){
            revert GameHasNotStarted();
        }
        // if the player reaches 255, end the game
        if(registeredPlayer[msg.sender].playerDicePosition == 255){
            startGame = false;
            registeredPlayer[msg.sender].isWinner = true;
        }
        // dice roll logic here
        uint8 firstRoll = pseudorandomDiceRoll();
        uint8 secondRoll = pseudorandomDiceRoll();
        registeredPlayer[msg.sender].playerDicePosition += firstRoll + secondRoll ;
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
        registeredPlayer[msg.sender] = Player(counter,_color,0, false);

        // start game if no of player == 2
        if(counter == 2){
            startGame = true;
        }
    }
}
