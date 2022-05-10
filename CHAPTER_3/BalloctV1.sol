pragma solidity >=0.4.2 <=0.6.0;
contract BallocV1 {
    // vVoter 타입은 투표자 상세 정보를 담고 있다.
    struct Voter {
        uint weight;
        bool voted;
        uint vote;
    }
    // Proposal타입은 제안의 상세 정보를 담고 있는데, 현재는 voteCount만을 가지고 있다.
    struct Proposal {
        uint voteCount;
    }
    
    address chairperson;
    mapping(address => Voter) voters; // 투표자 주소를 투표자 상세 정보로 매핑
    Proposal[] proposals;

    enum Phase {Init, Regs, Vote, Done} // 투표의 여러 단계(0, 1, 2, 3)를 나타내고, Init 단계로 상태가 초기화 된다.
    Phase public state = Phase.Init;
}