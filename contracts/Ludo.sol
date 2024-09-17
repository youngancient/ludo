// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

// Uncomment this line to use console.log
// import "hardhat/console.sol";

// a simple ludo with min of 2 players and max of 4 playing One game at a time
contract SimpleLudo {
    error MaxRegistrationsReached();
    error UserRegisteredAlready();
    error ZeroAddressNotAllowed();
    error NonPlayerNotAllowed();
    error GameHasNotStarted();

    uint8 constant NO_OF_SEEDS = 4;

    enum playerColor {
        RED,
        BLUE,
        YELLOW,
        GREEN
    }

    struct Player {
        uint id;
        playerColor color;
        uint playerDicePosition;
        bool isWinner;
        uint8 noOfSeeds;
    }

    uint8 counter;

    // a dice contains 2 die with have 6 faces each
    // a dice is a 2D-array

    address public winner;

    // finishing line
    uint8 finishLine = 255;

    mapping(address => Player) registeredPlayer;

    // this boolean starts the game when 2 players are registered
    bool startGame;

    // prevents any unregisterd player from interfering
    function onlyPlayer() private view {
        if (registeredPlayer[msg.sender].id == 0) {
            revert NonPlayerNotAllowed();
        }
    }

    function pseudorandomDiceRoll(uint seed) private view returns (uint8) {
        uint256 blockTimestamp = block.timestamp;
        uint8 dieRoll = uint8((( seed * blockTimestamp) % 6) + 1);
        return dieRoll;
    }

    // rollDice generates 2 random numbers representing the faces
    function rollDice() external {
        onlyPlayer();
        if (!startGame) {
            revert GameHasNotStarted();
        }
        // if the player reaches 255, end the game
        Player storage player = registeredPlayer[msg.sender];

        if (player.playerDicePosition == 255) {
            startGame = false;
            player.isWinner = true;
            winner = msg.sender;
        }

        // dice roll logic here
        uint8 firstRoll = pseudorandomDiceRoll(player.id);
        uint8 secondRoll = pseudorandomDiceRoll(player.id);
        player.playerDicePosition +=
            firstRoll +
            secondRoll;
    }

    function registerToPlay(playerColor _color) external {
        // does not allow more than 2 players
        if (counter + 1 > 4) {
            revert MaxRegistrationsReached();
        }
        
        if (msg.sender == address(0)) {
            revert ZeroAddressNotAllowed();
        }

        if (registeredPlayer[msg.sender].id != 0) {
            revert UserRegisteredAlready();
        }
        counter++;
        registeredPlayer[msg.sender] = Player(
            counter,
            _color,
            0,
            false,
            NO_OF_SEEDS
        );

        // start game if no of player == 2
        if (counter >= 2) {
            startGame = true;
        }
    }
}
