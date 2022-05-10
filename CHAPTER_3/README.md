#### 수정자 예

~~~
// 수정자 구문
modifier name_of_modifier(parameters) {
    require { conditions_to_be_checked};
    _;
}

// validPhase 규칙을 위한 실제 수정자 정의
modifier validPhase(Phase reqPhase) {
    require(state == reqPhase);
    _;
}
~~~

#### 수정자 사용
~~~
// 함수 헤더에 있는 수정자. 만일 조건이 맞지 않다면 트랜잭션을 되돌린다.
function register(address voter) public validPhase(Phase.Regs) {
    // if (state != Phase.Regs) {revert();}
    if (msg.sender != chairperson || voters[voter].voted) return;
    voters[voter].weight = 1;
    voters[voter].voted = false;
    ...
}
~~~

#### onlyChair 수정자의 정의와 사용
~~~
if (msg.sender != chairperson ..) // onlyChair 수정자를 통해 교체해야 할 구문

// 수정자 onlyChairf 정의
modifier onlyChair () {
    require(msg.sender == chairperson);
    _;
}

// register()함수 헤더에 두 개의 수정자 사용
function register(address voter) public validPhase(Phase.Resg) onlyChair {
    ...
}
~~~