pragma solidity ^0.8.18;

contract SecureLottery {
    address public owner;
    uint256 public lotteryId;
    bool public isPaused;

    address[] public entries;
    mapping(address => uint256) public playerEntryCount;

    event Entered(address player);
    event WinnerSelected(address winner, uint256 amount);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }

    modifier whenNotPaused() {
        require(!isPaused, "Paused");
        _;
    }

    constructor() {
        owner = msg.sender;
        lotteryId = 1;
        isPaused = false;
    }

    function enter() public payable whenNotPaused {
        require(msg.value >= 0.01 ether, "Minimum 0.01 ETH");
        entries.push(msg.sender);
        playerEntryCount[msg.sender]++;
        emit Entered(msg.sender);
    }

    function selectWinner() public onlyOwner {
        require(entries.length >= 3, "Need at least 3 entries");

        uint256 random = uint256(
            keccak256(
                abi.encodePacked(blockhash(block.number - 1), block.timestamp, entries.length)
            )
        );
        uint256 winnerIndex = random % entries.length;
        address winner = entries[winnerIndex];

        uint256 prize = (address(this).balance * 90) / 100;
        uint256 fee = address(this).balance - prize;

        isPaused = true; 
        payable(winner).transfer(prize); 
        payable(owner).transfer(fee);

        emit WinnerSelected(winner, prize);

        delete entries;
        lotteryId++;
        isPaused = false;
    }

    function pause() public onlyOwner {
        isPaused = true;
    }

    function unpause() public onlyOwner {
        isPaused = false;
    }

    function getPot() public view returns (uint256) {
        return address(this).balance;
    }

    function getPlayerEntries(address player) public view returns (uint256) {
        return playerEntryCount[player];
    }
}