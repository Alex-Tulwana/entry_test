pragma solidity ^0.8.18;

contract SkillsMarketplace {
    address public owner;
    uint256 public nextGigId;

    struct Worker {
        string skill;
        bool registered;
    }

    struct Gig {
        uint256 id;
        string description;
        string skillRequired;
        address employer;
        uint256 bounty;
        bool completed;
        string submissionUrl;
    }

    mapping(address => Worker) public workers;
    mapping(uint256 => Gig) public gigs;
    mapping(uint256 => address[]) public applications;

    event WorkerRegistered(address worker, string skill);
    event GigPosted(uint256 gigId, address employer, string skillRequired, uint256 bounty);
    event AppliedForGig(uint256 gigId, address worker);
    event WorkSubmitted(uint256 gigId, address worker, string submissionUrl);
    event WorkApproved(uint256 gigId, address worker, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    function registerWorker(string memory skill) public {
        require(!workers[msg.sender].registered, "Already registered");
        workers[msg.sender] = Worker(skill, true);
        emit WorkerRegistered(msg.sender, skill);
    }

    function postGig(string memory description, string memory skillRequired) public payable {
        require(msg.value > 0, "Bounty must be > 0");
        gigs[nextGigId] = Gig(nextGigId, description, skillRequired, msg.sender, msg.value, false, "");
        emit GigPosted(nextGigId, msg.sender, skillRequired, msg.value);
        nextGigId++;
    }

    function applyForGig(uint256 gigId) public {
        require(workers[msg.sender].registered, "Not registered");
        require(keccak256(bytes(workers[msg.sender].skill)) == keccak256(bytes(gigs[gigId].skillRequired)), "Skill mismatch");

        address[] storage appl = applications[gigId];
        for (uint i = 0; i < appl.length; i++) {
            require(appl[i] != msg.sender, "Already applied");
        }
        appl.push(msg.sender);
        emit AppliedForGig(gigId, msg.sender);
    }

    function submitWork(uint256 gigId, string memory submissionUrl) public {
        address[] storage appl = applications[gigId];
        bool applied = false;
        for (uint i = 0; i < appl.length; i++) {
            if (appl[i] == msg.sender) {
                applied = true;
                break;
            }
        }
        require(applied, "Did not apply");

        gigs[gigId].submissionUrl = submissionUrl;
        emit WorkSubmitted(gigId, msg.sender, submissionUrl);
    }

    function approveAndPay(uint256 gigId, address worker) public {
        Gig storage gig = gigs[gigId];
        require(msg.sender == gig.employer, "Only employer can approve");
        require(!gig.completed, "Already completed");

        gig.completed = true; 
        payable(worker).transfer(gig.bounty);
        emit WorkApproved(gigId, worker, gig.bounty);
    }
}