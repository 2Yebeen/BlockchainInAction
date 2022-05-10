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

    // 수정자
    modifier validPhase(Phase reqPhase) {
        require(state == reqPhase);
        _;
    }
    
    modifier onlyChair() {
        require(state == chairperson);
        _;
    }

    constructor (uint numProposals) public {
        chairperson = msg.sender;
        voters[chairperson].weight = 2; // 테스트를 위한 가중치 2로 설정
        // 제안 개수는 constructor의 파라미터다.
        for (uint prop = 0; prop < numProposals; prop++) {
            proposals.push(Proposal(0));
        }
        state = Phase.Regs; // Regs 단계로 변경
    }

    // 단계를 변화시키는 함수 : 오직 의장만이 실행할 수 있다.
    function changeState(Phase x) public {
        require (x > state);
        state = x;
    }

    // 함수 헤더에 validPhase 수정자를 사용
    function register(address voter) public validPhase(Phase.Regs) {
        onlyChair{
            require(! voters[voter].voted);
            voters[voter].weight = 1;
            //voters[voter].voted = false;
        }
    }

    function vote(uint toProposal) public validPhase(Phase.Vote) {
        Voter memory sender = voters[msg.sender];
        // 통상적인 if 대신 require() 사용
        require(!sender.voted);
        require(toProposal < proposals.length);
        // if (sender.voted || toProposal >= proposals.length) revert();
        sender.voted = true;
        sender.vote = toProposal;
        proposals[toProposal].voteCount += sender.weight;
    }

    // 읽기용 ㅎ마수, 체인에 Tx를 기록하지 않는다.
    function reqWinner() public validPhase(Phase.Done) view returns (uint winningProposal) {
        uint winningVoteCount = 0;
        for (uint prop= 0; prop < proposals.length; prop++) {
            if (proposals[prop].voteCount > winningVoteCount) {
                winningVoteCount = proposals[prop].voteCount;
                winningProposal = prop;
            }
        }
        // assert()사용
        assert(winningVoteCount>=3);
    }
}
