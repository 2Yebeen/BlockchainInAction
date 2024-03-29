pragma solidity ^0.6.0;
contract Airlines {
    address chairperson;
    // 항공사 데이터 구조
    struct details {
        uint escrow; // 지불 정산을 위한 예치
        uint status;
        uint hashOfDetails;
    }
    
    // 항공사 어카운트 페이먼트와 회원 매칭
    mapping (address=>details) public balanceDetails; 
    mapping (address=>uint) membership;

    // 수정자 또는 규칙들
    modifier onlyChairperson {
        require(msg.sender==chairperson);
        _;
    }
    modifier onlyMember {
        require(membership[msg.sender] == 1);
        _;
    }

    // 생성자 함수; payable 함수를 위한 msg.sender와 msg.value사용
    constructor() public payable {
        chairperson=msg.sender;
        membership[msg.sender] = 1; // 자동으로 등록
        balanceDetails[msg.sender].escrow = msg.value;
    }

    function register() public payable {
        address AirlineA = msg.sender;
        membership[AirlineA] = 1;
        balanceDetails[msg.sender].escrow = msg.value;
    }

    function unregister(address payable AirlineZ) onlyChairperson public{
        membership[AirlineZ] = 0;
        // 출발 항공사에게 에스크로를 반환: 다른 조건들 확인
        AirlineZ.transfer(balanceDetails[AirlineZ].escrow);
        balanceDetails[AirlineZ].escrow = 0;
    }

    function request(address toAirline, uint hashOfDetails) onlyMember public {
        if (membership[toAirline] != 1) {
            revert();
        }
        balanceDetails[msg.sender].status = 0;
        balanceDetails[msg.sender].hashOfDetails = hashOfDetails;
    }

    function response(address fromAirline, uint hashOfDetails, uint done) onlyMember public {
        if (membership[fromAirline] != 1) {
            revert();
        }
        balanceDetails[msg.sender].status = done;
        balanceDetails[fromAirline].hashOfDetails = hashOfDetails;
    }

    function settlePayment(address payable toAirline) onlyMember payable public {
        address fromAirline = msg.sender;
        uint amt = msg.value;

        balanceDetails[toAirline].escrow = balanceDetails[toAirline].escrow + amt;
        balanceDetails[fromAirline].escrow = balanceDetails[fromAirline].escrow - amt;

        // msg.send로 부터 amt를 차감해 toAirline에게 보냄
        toAirline.transfer(amt);
    }
    
}