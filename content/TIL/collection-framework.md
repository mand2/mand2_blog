---
title: "컬렉션 프레임워크의 정의와 stream 사용법 간단 정리"
date: 2019-10-30T18:58:29+09:00
draft: false
categories: TIL
tags:
- TIL
- Java 
hidden: false
---

최근, 알고리즘 문제를 풀 때 ([링크]([https://github.com/mand2/Daily-Algorithm/blob/master/Programmers/%EB%AA%A8%EC%9D%98%EA%B3%A0%EC%82%AC.md](https://github.com/mand2/Daily-Algorithm/blob/master/Programmers/모의고사.md))) 다른 사람의 문제풀이에서 stream()을 사용한 풀이가 있었다. 그동안 stackOverFlow에서나, 다른 레퍼런스 문서 등에서 가끔 보던 형식이었다. 그 땐 이 형식이 람다식으로 만들어진 줄도 몰랐다. 내 기억상 음,, 이건 다른 언어에서 쓰는건가? 하고 넘겼던 듯. 이번 문제풀이를 통해 컬렉션과 람다식에 대해 꼼꼼히 배울 수 있는 계기가 되었다고 생각하고, 간단히 정리를 해 보려고 한다. 아래는 내가 보았던 식이다.

```java
return list.stream().mapToInt(i->i.intValue()).toArray();
```

이 뜻은 

- list를 스트림으로 만들고, 
- int 형식으로 변환 후 
- 다시 배열로 바로 반환

한다는 뜻이다.

<br>

여기서 궁금한 **순서**가   

1. stream()은 뭐지?   
2. stream은 언제부터 사용 가능했나? (== 도입시기)  
3. 사용법 / 주의사항은? 

<br><br>

------

### 1-1 stream 이란?

자바 8부터 추가된 기능으로 "**컬렉션, 배열등의 저장 요소를 하나씩 참조하며 함수형 인터페이스(람다식)를 적용하며 반복적으로 처리할 수 있도록 해주는 기능**"이다.  java api문서를 보면 `java.util.Collection.stream()` 에서 찾을 수 있다. 이 정의에서 다시 '컬렉션'이란 무엇일까 궁금해진다.

<br><br>

### 1-2 Collection 이란?

Interface로 분리되며, `Iterable`을 상속한다. 컬렉션 프레임워크에 속하는 인터페이스를 구현한 클래스를 컬렉션 클래스(collection class)라고 한다.

**Since:** 1.2

**See Also: ** [`Set`](https://docs.oracle.com/javase/8/docs/api/java/util/Set.html), [`List`](https://docs.oracle.com/javase/8/docs/api/java/util/List.html), [`Map`](https://docs.oracle.com/javase/8/docs/api/java/util/Map.html), [`SortedSet`](https://docs.oracle.com/javase/8/docs/api/java/util/SortedSet.html), [`SortedMap`](https://docs.oracle.com/javase/8/docs/api/java/util/SortedMap.html), [`HashSet`](https://docs.oracle.com/javase/8/docs/api/java/util/HashSet.html), [`TreeSet`](https://docs.oracle.com/javase/8/docs/api/java/util/TreeSet.html), [`ArrayList`](https://docs.oracle.com/javase/8/docs/api/java/util/ArrayList.html), [`LinkedList`](https://docs.oracle.com/javase/8/docs/api/java/util/LinkedList.html), [`Vector`](https://docs.oracle.com/javase/8/docs/api/java/util/Vector.html), [`Collections`](https://docs.oracle.com/javase/8/docs/api/java/util/Collections.html), [`Arrays`](https://docs.oracle.com/javase/8/docs/api/java/util/Arrays.html), [`AbstractCollection`](https://docs.oracle.com/javase/8/docs/api/java/util/AbstractCollection.html)

<br>
구조 간단 정리 

![컬렉션 구조](/images/TIL/collection-framework_1.png)
<br><br>

[출처](https://postitforhooney.tistory.com/entry/JavaCollection-Java-Collection-Framework%EC%97%90-%EB%8C%80%ED%95%9C-%EC%9D%B4%ED%95%B4%EB%A5%BC-%ED%86%B5%ED%95%B4-Data-Structure-%EC%9D%B4%ED%95%B4%ED%95%98%EA%B8%B0) 링크로 들어가면 메서드까지 잘 정리되어 있음. 필요할 때 보자-! [다른 링크](http://tcpschool.com/java/java_collectionFramework_concept)는 학원에서 처음 자바를 배울 때 애용했던 TCP school 페이지임. 이 페이지도 잘 정리되어있다. 

자세히 보면 collection 자체가 시작된 건 java 2 부터라니,, 의외다. 1.8 기준으로 보면 `
Support for Lambda Expressions, Streams, and Aggregate Operations
` 을 지원하기 시작했다고 뜬다. 

여기서 `Aggregate Operation` 이란게 뭘까 찾아보았는데 지금 포스팅 주제와 달라서 따로 공부하고 포스팅해야 할 필요성을 느꼈다. 뭔가 방대해보임. aggregation(집약관계, 연관)과 composition(포함관계, 복합연관)의 개념을 다 알아야 한다. 지금은 검색하고 바로 포스팅한 거라서 **확실치는 않다**.이 단락은 100% 신뢰하지 말 것!

[링크1](http://ojc.asia/bbs/board.php?bo_table=LecJava&wr_id=541)    /   [링크2](https://www.gpgstudy.com/forum/viewtopic.php?t=10598)

<br><br>

### 1-3 그러면 Collection Framework는?

다수의 데이터를 쉽고 효과적으로 처리할 수 있는 **표준화된 방법을 제공**하는 **클래스의 집합**이며, 데이터를 저장하는 **자료 구조**와 데이터를 처리하는 **알고리즘을 구조화**하여 클래스로 구현해 놓은 것이다. 

정리하자면, Collection Framework에는 크게 3가지 인터페이스가 있다.

- List 인터페이스 > Collection 상속
- Set 인터페이스 > Collection 상속
- Map 인터페이스     
  구조상 차이로 인해 Collection 상속X 바로 `java.util.Map`으로 시작.

<br><br><br><br>

### 2 stream 도입은 언제라고?

1-2에서 설명했듯, stream은 람다식과 함께 `java 8` 부터 사용할 수 있다.

<br><br>

### 2-2 stream은 왜 사용하는 걸까

불필요한 코딩(for, if 문법)을 걷어낼 수 있고 **직관적**이기 때문에 **가독성**이 좋아진다. 주로 **Collection 과 Array**에서 사용된다고 함.

##### stream 사용 전

```java
for(int i = 0 ; i < list.size() ; i++){
    answer[i] = list.get(i);
}
```

##### stream 사용

```java
return list.stream().mapToInt(i -> i.intValue()).toArray();
```

사용 예시를 보면 알 수 있듯이 계속해서 `.`으로 쭉- 이어나갈 수 있다. 즉 `파이프라인 구조`를 쓴다. 

<br>stream을 사용하는 다른 이유로는 **성능/공짜점심**이 있다고 하는데, [HAMA 님](https://hamait.tistory.com/547)은 <u>성능만을 이유로 stream을 쓰기엔 애매하다</u> 라는 평을 하셨다. 더 찾아봐야 할 듯.

<br>

<br><br>

### 3 스트림 사용법과 주의할 사항?

스트림의 기본 구조는 **스트림 생성 -> 중개연산 -> 최종연산** 순으로 이루어진다. 

```
Collection 같은 객체 집합.스트림생성().중개연산().최종연산();
```

스트림의 특징은 **한번 닫으면 다시 쓸 수 없다**는 점이 있다. 여기서 파생되는 문제가, (1)**재사용**을 못할 수도 있지만 (2)스트림을 **무한으로 생성**할 수도 있다는 문제가 있다. 닫히지 않는 문제!! 또한 파이프라인 구조로 인해 **중개연산 선언순서가 달라지면** 다른 값이 나온다는 점도 주의해야 한다.

<br><br><br><br>

------

##### 출처

[stream 정의와 사용법 관련 1 : futurecreator 님 블로그](https://futurecreator.github.io/2018/08/26/java-8-streams/)  
[stream 정의와 사용법 관련 2: 정프로 님 블로그](https://jeong-pro.tistory.com/165) : API 내용을 간단하게 훑어준다.  
[stream 주의사항 관련: HAMA 님 블로그](https://hamait.tistory.com/547)

<br><br>