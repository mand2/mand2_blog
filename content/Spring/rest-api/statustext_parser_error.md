---
title: "statustext parsererror 해결방법"
date: 2019-09-11T12:31:53+09:00
draft: false
weight: 20
categories: Rest-API
tags:
- Spring
- Rest-API 
- TIL 
hidden: true
---

## 200 도 뜨는데 왜 에러로 걸리지?

Spring으로 회원가입 페이지를 만들었다. 회원가입하기 버튼을 눌렀을 때 콘솔에서 에러로 들어왔다고 나왔다. DB에 제대로 들어가는 건 함정...

서버쪽에서 제대로 넘어갔고,  200으로도 뜨는데 왜  ajax로 넘어올 때 success가 아닌 error로 넘어갈까 찾아보았다. 

```javascript
$.ajax({
    url: '',
    type: 'post',
    data: JSON.stringify(all),
    contentType : 'application/json;charset=utf-8',
    dataTyep: 'json',

    success: function(data){
        if(data == 'success'){
            console.log('success성공');
        }
        else if(data == 'fail'){
            console.log('success:실패')
        } else {
            console.log('success:요상한값들어간듯,' + data)
        }
    },
    error: function(data){
        console.log('에러'+ data);
        console.log('에러'+ JSON.stringify(data));
    }
```
찾아보니 dataType이 맞지 않아 생기는 오류라고.

<br><br>

### StackOverFlow 와 구글링을 통해 찾은 해결방법 

1. dataType을 지워라

2. dataType = 'text' 로 해라

3. header값에 캐릭터셋을 UTF-8로 오도록 설정해라.

나는 dataType을 지움으로써 해결함.

`Controller`  에서 ResponseBody에 String으로 주는 걸 설정해놨었기 때문에 'success'라는 단어가 맞으면 성공으로 뜨게 만듬.

<br><br><br><br>

### 결과

![결과이미지](/images/Spring/rest-api/statustext_parser_error_1.jpg)

