---
title: "REST API Client에서 호출가능한 Library"
date: 2020-03-04T23:13:53+09:00
draft: false
weight: 25
categories: Rest-API
tags:
- Spring
- Rest-API 
- TIL 
hidden: true
---

<br>

우리 팀은 MSA 방식으로 웹 어플리케이션을 만들기 때문에 api 통신이 중요하다. api 통신을 하기 위해서 client 단에서 호출 가능한 library가 무엇이 있는지 찾아보았다. 크게 두 라이브러리를 사용하는데, `HttpURLConnection` 과 `RestTemplate` 이다.

<br><br><br><br>

### 1 HttpURLConnection

```java
void sendRequest(String request)
{
    // i.e.: request = "http://example.com/index.php?param1=a&param2=b&param3=c";
    URL url = new URL(request); 
    HttpURLConnection connection = (HttpURLConnection) url.openConnection();           
    connection.setDoOutput(true); 
    connection.setInstanceFollowRedirects(false); 
    connection.setRequestMethod("GET"); 
    connection.setRequestProperty("Content-Type", "text/plain"); 
    connection.setRequestProperty("charset", "utf-8");
    connection.connect();
}
```

<br><br>



### 2 RestTemplate

[DOCS](https://docs.spring.io/spring/docs/current/javadoc-api/org/springframework/web/client/RestTemplate.html)

요즘 들어 선호하는 형태는 `postForObject`  . 어떤 형태로든 받아 올 수 있어서 개발 생산성이 조금 더 높은 것 같다. `uriVariables` 형태도 있어서 `https://naver.com/{id}/posts/{index}` 이런 형식으로 url을 작성하면 더 간편하게 구현할 수 있다.

물론 #1의 `HttpURLConnection` 보다 속도가 느림. 가벼운 건 아님. 조금 더 안정성이 높다고 하는데 그건 잘 모르겠고 개발할 때 조금 더 간편하고 길게 쓰지 않아도 되어서 선호하는 편.

<br><br>



### 3 개발하며 느낀 점

예전부터 `RestTemplate`을 사용하는 걸 선호했던 터라 `HttpURLConnection` 의 필요성을 느끼지 못했다. 그런데 모듈형식으로 생각한다면 `HttpURLConnection`을 사용하는 게 더 관리하기 용이하다고 생각했다. 호출하는 형식이 거기서 거기 + 메서드에 **HttpMethod** 형식을 어떻게 받아올 건지만 세팅해주면 되니까... 일단 api 만들고 다시 리팩토링 해야지... 😥 resttemplate을 더 효율적으로 사용하는 방법은 나중에 찾아봐야겠다.



<br><br><br><br>

### 참고 주소

- HttpURLConnection과 RestTemplate 등 다른 라이브러리를 잘 설명한 [스택오버플로우](https://stackoverflow.com/questions/53795268/should-i-use-httpurlconnection-or-resttemplate)
- 한글로 된 설명 [Aaron_h님 블로그](https://digitalbourgeois.tistory.com/56?category=678387)

