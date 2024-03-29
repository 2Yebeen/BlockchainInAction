# Web3와 채널 Dapp

~~~
💡
web3를 사용해 Dapp의 거의 모든 것을 자동화할 수 있다. web3 API는 블록체인 함수를 액세스하기 위한 포괄적 패키지다.
블록체인 클라이언트 노드의 함수를 노출 시키는데, 외부 애플리케이션과 블록체인 노드간의 상호작용을 쉽게 하고, 프로그램이 블록체인 서비스에 쉽게 액세스할 수 있도록 한다.
이더리움 블록체인이 지원하는 마이크로 페이먼트의 단순한 버전을 위한 종단 간 솔루션을 개발해 보도록 한다.
~~~

<br>

## 1. web3 API

web3 API는 탈중앙화 애플리케이션의 모든 참여자가 같은 구문과 의미로 블록체인과 상호작용할 수 있도록 하는 함수와 클래스의 푶준적 집합이다. 그렇지 않다면 참여자 간의 일관성이 깨지고 블록체인이 무용지물이 될 수도 있다.

<br>

### 1.1 Dapp 스택에서의 web3

web3가 제공하는 함수는 아래와 같다.
- 블록체인 노드의 코어 오퍼레이션을 지원하는 함수
- 블록체인 상에 탈중앙화 애플리케이션 스택을 가능하게 하는 함수

#### 블록체인 기반 Dapp 스택에서 web의 역할
![image](https://user-images.githubusercontent.com/68188768/170184150-4d1ab4f1-248c-4fc8-ba28-b3d8480edb72.png)

~~~
* 웹 클라이언트
    - 블록체인 서비스가 필요한 모든 클라이언트
* 웹 애플리케이션 : app.js web3.js
    - 블록체인 서비스를 액세스한다.
* 웹 서버
    - 클라이언트 리퀘스트를 처리
    - Node.js 서버를 사용해서 구현한다.
* web3.js는 app.js 애플리케이션 로직이 블록체인 노드의 web3 프로바이더에 연결될 수 있도록한다.
~~~

![image](https://user-images.githubusercontent.com/68188768/170187123-85e1502b-ad72-473b-a60e-69fd1340497a.png)
