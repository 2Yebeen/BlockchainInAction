pragma solidity >=0.4.22 <=0.6.0;

contract BlindAuction {
    // 입찰 정보
    struct Bid {                   
        bytes32 blindedBid;
        uint deposit;
    }

    // 상태는 수혜자에 의해 설정된다 (경매 상태 정보)  
    enum Phase {Init, Bidding, Reveal, Done}  
    Phase public state = Phase.Init; 

    address payable beneficiary;    // 컨트랙트 배포자가 수혜자이다.
    mapping(address => Bid) bids;   // 주소당 오직 1회만 입찰

    // 최고가 입찰자의 정보
    address public highestBidder; 
    uint public highestBid = 0;   
    
    // 낙찰 탈락자의 예치금 반환
    mapping(address => uint) depositReturns; 
    
    //수정자, 경매 단계를 위한 수정자
    modifier validPhase(Phase reqPhase) { 
        require(state == reqPhase); 
        _; 
    } 
    // 수정자, 수혜자를 확인하는 수정자
   modifier onlyBeneficiary() { 
       require(msg.sender == beneficiary); 
       _;
   }

// constructor가 수혜자를 설정
constructor(  ) public {    
        beneficiary = msg.sender;
        state = Phase.Bidding;
    }

    function changeState(Phase x) public onlyBeneficiary {
        if (x < state ) revert();
        state = x;
    }
    
    // 블라인드 경매 함수
    function bid(bytes32 blindBid) public payable validPhase(Phase.Bidding)
    {  
        bids[msg.sender] = Bid({
            blindedBid: blindBid,
            deposit: msg.value
        });
    }

    // 블라인드 입찰을 확인
    function reveal(uint value, bytes32 secret) public   validPhase(Phase.Reveal){
        uint refund = 0;
            Bid storage bidToCheck = bids[msg.sender];
            if (bidToCheck.blindedBid == keccak256(abi.encodePacked(value, secret))) {
            refund += bidToCheck.deposit;
            if (bidToCheck.deposit >= value) {
                if (placeBid(msg.sender, value))
                    refund -= value;
            }}
            
        msg.sender.transfer(refund);
    }

    // placeBid()는 내부(interal) 함수이다
    function placeBid(address bidder, uint value) internal 
            returns (bool success)
    {
        if (value <= highestBid) {
            return false;
        }
        if (highestBidder != address(0)) {
            // Refund the previously highest bidder.
            depositReturns[highestBidder] += highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
    }


    // Withdraw a non-winning bid
    function withdraw() public {   
        uint amount = depositReturns[msg.sender];
        require (amount > 0);
        depositReturns[msg.sender] = 0;
        msg.sender.transfer(amount);
        }
    
    
    //End the auction and send the highest bid to the beneficiary.
    function auctionEnd() public  validPhase(Phase.Done) 
    {
        beneficiary.transfer(highestBid);
    }
}

    
    
