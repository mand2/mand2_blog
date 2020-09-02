---
title: "자바스크립트로 AWS autoscaling group 정보 가져오기"
date: 2020-09-02T22:35:44+09:00
categories: TIL
tags:
- Javascript
- AWS
- TIL
draft: false
---

각 리전의 인스턴스를 컨트롤하는 람다를 유지보수하는 일을 맡았다. 
일단 리전 하나에서 관리하는 것도 충분히 힘들지만, 여러 리전에서 관리를 하다니...
같이 일하시는 분들이 대단해 보인다.
다들 기억력이 정말 좋으신듯 ㅠ_ㅠ 리전 하나당 관리하는 인스턴스 종류도 여러가지인데 
꼼꼼하셔서 큰 사고없이 잘 유지중인 것 같다.

아무튼 각설하고, 오늘의 주제는 `AWS autoScalingGroup 정보 가져오기 by. javascript`.  
AWS에서는 SDK라고 해서 aws 관련한 모든 것에 접근할 수 있는 라이브러리를 제공한다. 
평소에는 java-sdk로 aws에 접근하지만,
이번에는 람다용으로 개발할 거라서 javascript-sdk 용으로 설명한다.
(특이한 점: 각 언어별로 제공되는 파라미터 값이나 입력값이 다름. 메서드도 다르다!)

참고한 부분은 역시나 AWS docs의 AutoScaling 관련 부분임. [AWS docs](https://docs.aws.amazon.com/AWSJavaScriptSDK/latest/AWS/AutoScaling.html#describeAutoScalingGroups-property)

## 호출방식
1. aws-sdk를 가져온다.
2. aws.autoScaling 객체 생성.  
3. params에 원하는 정보를 입력해준다. (filtering)  
`AutoScalingGroupNames` / `MaxRecords` / `NextToken`은 필수값은 아님.
4. autoScaling.describeAutoScalingGroups 호출!

{{< gist c80d737ff84b1b01f6b510dad4eaa01e >}}

<br><br>


## 예제
리턴하는 방식은 아래와 같다.  
받아온 `data`로 autoScaling을 어떻게 조작할지 개발하면 된다(이제 시작이라는 뜻ㅎ).
{{< gist 856f5c7ea44b838011bff118b5ec3367 >}}

<br><br>


## 궁금했던 점

Q. AutoScalingGroups의 `DesiredCapacity`와 `instances`의 차이?  
**desiredCapacity** : scale-in / out이 발생하지 않으면 지속될 인스턴스 개수.  
**instances** : 해당 오토스케일링 그룹에서 띄운 instance의 세부정보.  
출처: [스택오버플로우](https://stackoverflow.com/questions/36270873/aws-ec2-auto-scaling-groups-i-get-min-and-max-but-whats-desired-instances-lim#:~:text=Scale-in%20or%20Scale-out,or%20increasing%20the%20DesiredCapacity%20value.&text=Desired%20capacity%20simply%20means%20the,when%20you%20launch%20the%20autoscaling.) 

