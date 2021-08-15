---
title: "Java 형식으로 AWS SQS에 메세지 보내기"
date: 2021-08-16T01:40:33+09:00
draft: false
categories: TIL
tags:
- TIL
- AWS
- SQS
- JAVA
hidden: false
---

오랜만에 쓰는 블로그 글이다. 이것 저것 이슈로 블로그를 방치해 두었었는데, 이제서야 한번 다시 돌아보는 나의 블로그... 😂
오늘의 주제는 '**Java 형식으로 AWS SQS에 메세지 보내기**'다  

사용자(User)가 주문을 하면 backend-api 쪽에서 주문 등록을 하고, 
사장님에게 '주문이 되었습니다'라는 알람과 함께 주문내역 메세지를 보내는 시스템을 구현했다고 가정해보자
(**가정**일 뿐이다. 주문 관련 업무를 설계해 본 적은 없다. 
설명하기 쉽게 가정을 했을 뿐😅 주문 내역을 만들 때 batch를 쓸 수도 있고 큐를 안 쓰고 API를 바로 호출 할 수도 있고.. 
설계 방안은 여러가지일 것이다.)  


> **AWS SQS ?** TL;DR  
간단한 메세지를 큐 형태로 쌓아서(send) 받도록(recieve) 하는 서비스이다.  
이름(`Amazon Simple Queue Service`)에서 알 수 있듯이 '간단하게'가 포인트.  
pub/sub 형태로 메세징 처리를 하고 싶다면 rabbitMQ나 JMS, Amazon MQ를 사용해야 한다.

<br>

**장점과 단점**

| 장점 | 단점 |
| ---- | ---- |
| - AWS 인프라내에서 장애에 대한 대응성이 뛰어나다. <br>- 쉽다. <br>- 별도로 관리할 필요가 없다.   | - JMS,Rabbit MQ와 같이 다양한 기능을 기대할 수 없다. <br>- 다른 Message Queue 대비 느리다. <br>- Polling 방식이기 때문에, Consumer 설계시 <br>매번 polling하는 식의 로직을 구현해야 한다.   |

<br>

### SQS 설계

![design sqs](/images/TIL/sqs_basic_design.png)  
사장님 쪽으로 주문 관련 메세지를 보내는 `receiver`를 람다로 구현했고, SQS를 람다와 연결시켰다. 
AWS끼리 연결하면 편리한게, SQS에 메세지 큐가 쌓이면 자동으로 람다가 호출되는 시스템이다. 

**👀 주의사항**  
여기서 주의할 점은, 
메세지 1개씩 n번 쏘았다고 해서 SQS에서 처리하는 메세지 큐가 n개가 아닐 수 있다는 점이다. 
AWS에 따르면 최대 10개의 메세지가 한꺼번에 큐 하나로(a single message batch request) 될 수 있다는 점을 참고해야 한다. 
따라서 람다에서 처리할 때 하나의 요청에 10개 메세지를 각각 처리하도록 설계해야 한다. 
그 외에 SQS 제약사항에 대해 알고 싶다면 [AWS DOCS](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/quotas-messages.html)를 참고해 보자


![design sqs](/images/TIL/sqs_message_queue.png)  
앞에 설명한 주의사항이 이해가 안 갈 수 있다. 
좀 더 예를 들어보자면, 서버 쪽에서 SQS를 호출하는 메세지 10개를 만들었을 때 SQS가 처리하는 메세지 큐는 최대 1개~10개가 된다. 

그림과 같이 최종 메세지 큐(람다에 요청하는 메세지큐)가 4개가 되었다고 한다면 람다는 **4번 호출**된다.  
A → B → C → D 순으로 호출되었다고 가정한다면 A를 람다가 처리할 때 실제 메세지 큐의 body에는 메세지가 2개 들어가있다. 
**즉, 람다 내부에서 `2 / 3 / 1 / 4 개` 의 메세지를 각각 처리해야 총 10개의 메세지가 처리된다는 것이다.** 
나눠지는 규칙이 있나요? 한다면 나도 잘 모른다 😅 AWS docs에서 10개까지 한번에 된다는 것만 설명했을 뿐.  
이런 제약사항에 대해 더 자세히 알고싶다면 [quota 부분](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/quotas-queues.html)을 보시라.



<br>

### SQS 호출하기

아무튼, 위의 방식이 이해가 되었든 아니었든 간에 java 형식으로 sqs 서버 호출하는 방법을 작성해보자면

#### 1. 설정

aws-sdk-sqs 를 가져와야 한다. **aws-sdk 버전(예를 들어 dynamodb 같은)이 더 추가되어 있다면 그 버전과 버전이 똑같아야 할 수도** 있다. (sqs를 호출하는 api를 두 개 만들었었는데 하나는 버전이 달라도 잘 작동했고, 하나는 버전을 맞춰줘야 했었다)

- maven pom.xml

    ```xml
    <dependency>
        <groupId>com.amazonaws</groupId>
        <artifactId>aws-java-sdk-sqs</artifactId>
        <version>1.12.44</version>
    </dependency>
    ```

- gradle

    ```java
    implementation 'com.amazonaws:aws-java-sdk-sqs:1.12.44'
    ```

<br>

#### 2. 주문 객체 만들기

{{< gist 3e9b7b9c88a300176067c99e6f93ebc4 >}}

<br>

#### 3. SQS 객체 만들기

메세지 하나를 보낼 땐 `SendMessageRequest` 를, 여러개 보낼 땐 `SendMessageBatchRequest` 를 사용한다.  

**한 개**만 보낼 때: [docs](https://docs.amazonaws.cn/AWSJavaSDK/latest/javadoc/com/amazonaws/services/sqs/model/SendMessageRequest.html)  
`SendMessageRequest(String queueUrl, String messageBody)`  
SQS에 보낼 message Body 는 무조건 String 형식이어야 한다. 


**동시에 여러개** 보낼 때: [docs](https://docs.amazonaws.cn/AWSJavaSDK/latest/javadoc/com/amazonaws/services/sqs/model/SendMessageBatchRequestEntry.html)  
`SendMessageBatchRequest(String queueUrl, List<SendMessageBatchRequestEntry> entries)`  
SendMessageBatchRequest의 entries 값을 세팅해주기 위해 OrderSqs 객체 내부에 setOrders() 메서드를 만들었다.  
생성자로 **SendMessageBatchRequestEntry(String id, String messageBody)** 를 사용하며, 각 entry id는 entries 객체 내에선 unique한 값이어야 한다. 
그러므로 Order의 orderSeq 값을 해당 id 값으로 지정해주었다(int 값을 String으로 바꿔야 하는데 조금 편법을 썼다 ㅎ). 

{{< gist 9e4cb49564249f150cd3d10de8b4a827 >}}

<br>

#### 4. SQS 호출 예시

junit5 기준으로 작성했다. 예시 테스트 코드라 간단하게 만들었다.

{{< gist 3a27c23ed1d42a18059c85a1845dab75 >}}

<br>
<br>


### 정리
AWS docs는 항상 느끼지만 친절한 듯 하면서 친절하지 않다.  
정보가 너무 많아서 그런 것 같다. docs 설명도 많고 주의사항 페이지도 따로 있고, github 나 API 도 따로 있으니... 😅  
나만의 팁은 docs에 올라온 샘플 코드를 먼저 본 다음에 API를 샅샅히 보면 원하는 대로 커스텀하기 좀 수월한 것 같다. 


<br>

---
출처: 
- [AWS DOCS](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/quotas-messages.html)  
- [AWS Example Github](https://github.com/awsdocs/aws-doc-sdk-examples/blob/master/java/example_code/sqs/src/main/java/aws/example/sqs/SendReceiveMessages.java)  
- [조대협의 블로그 AWS SQS(Simple Queue Service) 소개](https://bcho.tistory.com/683)  

