pragma solidity ^0.6.0; // 사용한 언어의 버전을 지정 필수
contract Counter {
    uint value; // 카운터값을 위한 공유 데이터
    function initialize (uint x) public {
        value = x;
    }
    
    function get() view public returns (uint) {
        return value;
    }

    function increment (uint n) public {
        value = vlaue + n;
        // return (optional)
    }

    function decrement (uint n) public {
        value = value - n;
    }
}