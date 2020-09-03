---
title: "자바 형변환 안전하게 하기"
date: 2020-09-03T22:39:54+09:00
categories: TIL
tags:
- Java
- parsing
- TIL
draft: false
---

형변환 할 때마다 참 고민이다.  
long -> int 형변환은 쉽게 `java.lang.Math.toIntExtract(long value)`을 이용하면 된다지만, 
그 외의 형변환을 할 때 <지금 내가 사용하는 게 정말 안전한 방법>인지 궁금해졌다.
어떻게 하면 더 **안전하게** 형변환 할 수 있을지 궁금해서 찾아본 안전하게 형변환하는 방법.


다른 예도 많지만 String에서 double로 형변환 하는 방법을 들어보겠다.
{{% notice warning %}}
**new Double("1.23")** 와 같이 Double을 새로 만들어서 사용하는 건 **Java 9부터 deprecated** 되었다. 지양할 것.
{{% /notice %}}

<br>


## 형변환을 도와주는 메서드
자바에서 형변환을 도와주는 메서드는 크게 세 가지로 볼 수 있다. :  
- Double.parseDouble  
- Double.valueOf  
- DecimalFormat.parse : 엑셀의 셀서식과 같이, format 즉 형식을 세팅해준다.   
형식을 갖춘 값을 만들고 싶다면 쓰면 됨(예- $ 20,746.1746). 형식 지정 없이 그냥 double 형으로만 갖고오고 싶다면, Double.parseDouble or the Double.valueOf 을 사용하길 바람.

<br>

그런데 문제는, 이 세 방법 모두 Exception을 뱉어낸다.  
- Double.parseDouble  : `NullPointerException`, `NumberFormatException`    
- Double.valueOf      : `NullPointerException`, `NumberFormatException`  
- DecimalFormat.parse : `NullPointerException`, `ParseException`    

<br>


## Exception 걱정없이 형변환 하기
#### 1. Optional과 Guava 라이브러리의 Doubles 사용 

Optional과 Guava 라이브러리의 Doubles 사용해서 exception을 회피한다. 
[참고 출처](https://stackoverflow.com/questions/5585779/how-do-i-convert-a-string-to-an-int-in-java) 
에서는 String to int 형변환을 말했지만, 어쨌든 Guava에 Doubles 있으니까 답변을 참고로, double 형변환 메서드를 찾음.
```java
int foo = Optional.ofNullable(myString)
 .map(Doubles::tryParse)
 .orElse(0);
```
얘의 단점은 Optional이 비싸다는 것.   
그리고 double로 변경할 수 없을 땐 바로 null을 뱉어버린다.([Guava docs](https://guava.dev/releases/19.0/api/docs/com/google/common/primitives/Doubles.html#tryParse(java.lang.String)))
그래서 `orElse`로 기본값을 세팅해야 함.

<br>

#### 2. NumberUtils 사용
1의 방법도 좋지만 좀 더 null-safe한 다른 방법이 있나 찾아봤더니, 
NumberUtils라고 Util용 라이브러리를 사용하는 방법도 있다.
`org.apache.commons.lang3.math.NumberUtils`의 메서드를 사용하면 된다.
  
찾아보니 여러가지 형변환을 도와주는 Util이다!! 엄청난 듯.  
오늘의 예제는 **String에서 double**로 형변환 하는 거니까, 그 용례는 다음과 같다.
```java
NumberUtils.toDouble(null)   = 0.0d
NumberUtils.toDouble("")     = 0.0d
NumberUtils.toDouble("1.5")  = 1.5d
```
심지어 원하는 형태로 변환이 안되면 **기본값 0으로 세팅**해서 보내준다.

<br>

**내가 원하는 기본값으로 세팅하고 싶을 땐?**  
오버로딩된 메서드(`toDouble(String str, double defaultValue)`)를 사용하면 된다.
```java
NumberUtils.toDouble(null, 1.1d)   = 1.1d
NumberUtils.toDouble("", 1.1d)     = 1.1d
NumberUtils.toDouble("1.5", 0.0d)  = 1.5d
```


출처: [apache docs](https://commons.apache.org/proper/commons-lang/javadocs/api-3.9/org/apache/commons/lang3/math/NumberUtils.html#toInt-java.lang.String-int-)


<br>
<br>

역시 구글링은 해도해도 끝이 없다..    
어딘가 더 좋은 답안이 있을 것 같아서 구글링하는 시간이 줄지 않는다🤣


