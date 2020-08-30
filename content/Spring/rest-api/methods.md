---
title: "Methods @Get, @Post, Delete, @Put"
date: 2019-08-19T14:30:56+09:00
draft: false
weight: 10
categories: Rest-API
tags:
- Spring
- Rest-API 
- TIL 
hidden: true
---

### **목적**

@RestController 어노테이션을 이용한 RESTFUL로 변경하기

<br>

### basics

- Spring `4.0` 버전 이후부터 @RestController 적용 가능

- **`@GetMapping`**  

  `get`으로 들어오는 URL 형식에 응답

- **`@PostMapping`**  

  `post`로 들어오는 URL 형식에 응답

- **`@DeleteMapping`**   

  `delete`로 들어오는 URL 형식에 응답

- **`@PutMapping`**   

  `put`으로 들어오는 URL 형식에 응답

<br>

## 예제

```java
@CrossOrigin
@GetMapping
public ResponseEntity<List<Member>> getAllList(){

    List<Member> list = listService.getAllList();
    ResponseEntity<List<Member>> entity 
        = new ResponseEntity<List<Member>>(list, HttpStatus.OK );

    return entity;
}
```

<br>

### ResponseEntity 란?

------

- @ResponseBody 어노테이션 대신 사용

- ResponseEntity < `반환형타입`  >의 `반환형타입`에 객체 사용 가능.

- ResponseEntity<`List<Member>`>(`body`, `status`)

  해당 메서드는 오버로딩되어있으며, body는 `반환형타입`과 같은 type이 들어가야 함

  `status`는 `HttpStatus`의 상태를 따로 지정함.

<br><br><br>

### HttpStatus 종류

 * HttpStatus.OK 200정상
 * HttpStatus.NOT_FOUND 404에러
 * HttpStatus.INTERNAL_SERVER_ERROR 500에러

