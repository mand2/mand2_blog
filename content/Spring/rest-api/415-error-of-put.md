---
title: "@PutMapping 사용 시 415 오류 해결방법"
date: 2019-08-19T17:37:13+09:00
draft: false
weight: 15
categories: Rest-API
tags:
- Spring
- Rest-API 
- TIL 
hidden: true
---

## 원인?   

### PUT일 때 ResponseEntity< String >으로 써야하지?

> `ResponseEntity<Integer>` 일 때엔 아예 인식을 못함   
> 415 error 발생!

| Exception                          | 설명                                                   | 응답코드                     |
| :--------------------------------- | :----------------------------------------------------- | :--------------------------- |
| HttpMediaTypeNotSupportedException | 요청의 Content Type을 핸들러가 지원하지 않는 경우 발생 | 415 - Unsupported Media Type |

출처 [(Spring Boot)오류 처리](https://supawer0728.github.io/2019/04/04/spring-error-handling/)

<br>

### 415 코드 **해결방법**

`contentType`을 JSON이라 명시해준다.
```javascript
contentType: 'application/json; charset=utf-8'
```




<br>

### 1. JSON <> JSON 으로 변환해줘야 한다  

request를 JSON으로 보냈다면, response도 JSON으로 보내줘야 한다.  
그래서 `@RequestBody`를 쓴다.   
JSON형태로 받게해주는 Annotation임

<br>

### 2. tomcat의 문제  

GET 혹은 POST 는 `tomcat`이 기본적으로 parsing 하게 하지만,    
PUT, DELETE는 parsing이 안됨,, 따로 server.xml에서 설정해야 함.

<br>

### 3. 컨테이너의 Request Message Converter의 문제

```
앞의 `1번` 내용과 결을 같이 함.
OKKY의 답변을 그대로 가져옴
```

컨테이너가 Request 메시지의 컨버터를 선정하는 기준을 이해하시면 쉽습니다. HttpMessageConverter 인터페이스에는 canRead, canWrite 메서드가 있는데 아래처럼 생겼어요.

```java
        @Override
	public boolean canRead(Class<?> clazz, MediaType mediaType) {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public boolean canWrite(Class<?> clazz, MediaType mediaType) {
		// TODO Auto-generated method stub
		return false;
	}
```

인자에 clazz, mediaType이 보이실거에요. canRead의 clazz는 @RequestBody 어노테이션이 붙은 변수의 데이터 타입입니다. 위의 예제에서는 @RequestBody String input이니까 String이 되겠네요.. 두 번째 인자mediaType은 Request Header의 ContentType입니다. "application/json"으로 요청을 보내셨다면 MediaType.APPLICATION_JSON이 될 겁니다.

어떤 요청이 들어왔고, 요청 URL을 핸들러 매핑이 조사하여 컨트롤러 메서드를 찾습니다. 찾은 핸들러의 인자에 @RequestBody가 있고, String 타입을 원하고 있습니다. 그러면 "현재 등록되어 있는"메시지 컨버터를 집합시켜 canRead에 String, MediaType.APPLICATION_JSON을 넣어 true를 반환하는 메시지 컨버터를 찾아요. 있으면 위임하여 처리시킵니다. 없으면 415를 뱉습니다..

Jackson 라이브러리를 추가하면 자동으로 MappingJackson2HttpMessageConverter 메시지 컨버터를 추가해 줍니다. 이 컨버터는 clazz가 String이고, mediaType이 APPLICATION_JSON이에요. 따라서 @RequestBody를 String으로 받으면 MappingJackson2HttpMessageConverter가 요청을 처리하구요 Object가 들어가면 메시지 컨버터는 canRead 메서드에서 false를 반환하므로 무시됩니다. 따라서 Object는 처리할 메시지 컨버터가 없어서 415를 뱉는 거에요.

프론트에서 보내신 JSON객체는 보통 JSON.stringify()로 보내지요? 이는 JSON객체를 문자열화 하여 보내라는 의미라 컨트롤러에서는 "{name : value}" 이런 "문자열"로 도착하게 됩니다. 컨트롤러에서는 JSON객체가 아니라 그냥 문자열이에요

이해가 잘 되셨는지 모르겠습니다. 아님 TMI라 알고 계신 것 까지 설명했나 모르겠네요;



<br><br><br>

# 결과코드

### VIEW

```javascript
function getEdit(idx) {

    $.ajax({
        url:'http://localhost:8080/mc/rest/members',
        type: 'PUT',
        data: JSON.stringify({
            idx: idx,
            pw : $('#pw2').val(),
            name : $('#name2').val()
        }),
        contentType: 'application/json; charset=utf-8',
        success: function(data) {
            alert(data);

            if(data == 'success' ){
                alert('수정되었습니다');
            } else {
                alert('실-패');
            }
        },
        error: function(data){
            alert('error ㅠㅠㅠㅠ');
            alert(data);
        },
        complete: function() {
            list();
            $('#edit').css('display','none');
            $('#join').css('display','block');
        }
    });
}
```



<br>

### Controller

```java
//회원수정
@CrossOrigin
@PutMapping
public ResponseEntity<String> editMember(@RequestBody EditMember edit) {
    System.out.println("edit :" + edit );
    return new ResponseEntity<String>(editService.editRest(edit)>0 ? "success" : "fail", HttpStatus.OK);
}
```

- 문자열로 받을 때에는   
  view에서 (ResponseEntity< String >) 과 같이 문자열로 받아온다면     
  **`dataType = json` 으로 명시하지 않아야** 함.   
- json으로 명시하면 dataType 이 맞지 않아서 오류남.



<br>