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

    // Version 2
    // 배포자로서 의장을 설정한다.
    constructor (uint numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // 테스트를 위한 가중치 2로 설정
        // 제안 개수는 constructor의 파라미터다.
        for (uint prop = 0; prop < numProposals; prop++) {
            proposals.push(Proposal(0));
        }
    }

    // 단계를 변화시키는 함수 : 오직 의장만이 실행할 수 있다.
    function changeState(Phase x) public {
        if (msg.sender != chairperson) revert(); // 오직 의장만이 상태를 바꿀 수 있으며 그렇지 않을 경우 되돌린다.
        if (x < state) revert();                 // 0, 1, 2, 3순서대로 진행하며, 그렇지 않을 경우 되돌린다.
        state = x;
    }
}