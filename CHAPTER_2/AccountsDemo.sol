pragma solidity ^0.6.0;
contract AccountsDemo {

    address public whoDeposited;
    uint public depositAmt;
    uint public accountBalance;

    // 페이먼트를 수신할 수 있다 (payable)
    function deposit() public payable {
        whoDeposited = msg.sender; // 모든 함수 호출은 msg.sender라는 내포적 속성을 가진다.
        depositAmt = msg.value; // 모든 함수 호출은 msg.sender가 보내는 msg.value를 전송할 수 있다.
        accountBalance = address(this).balance;
    }
}