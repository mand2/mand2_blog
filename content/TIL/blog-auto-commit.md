---
title: "블로그 커밋 메세지 만들고 자동 배포 하기"
date: 2020-08-31T19:36:11+09:00
draft: false
categories: TIL
tags:
- TIL
- Bash 
hidden: false
---

정말 짧은 기간이긴 하지만, `Hugo` 테마로 블로그를 구축하다 보니 git commit 하기가 귀찮아졌다.\
회사에서는 웬만하면 git 커맨드로 직접 push 하는 스타일이긴 한데, 
이렇게 자주 수정하고 push를 여러 단계에 걸쳐서 하는 건 아니라서💦 더 귀찮아진 느낌이다. 

결국 배포 자동화 하는 쉘스크립트를 작성하였다.\
기본적인 뼈대는 [한정수님 블로그](https://github.com/Integerous/Integerous.github.io)의 README.md에서 참고하였다. 
그냥 커밋 메세지를 똑같이 `auto commit!`으로 하기엔 넘 멋없어 보여서 커밋 메세지를 따로 입력받아 처리하였다.
쉘스크립트를 호출하면서 커밋메세지를 받아올 수도 있지만, 그렇게 하면 순간적으로 오타가 날 수도 있고 다른 내용을 작성하고 싶기도 해서
관리하기 쉽게 **커밋 메세지용 파일을 따로** 만들어 두었다.


<br>

#### 전제
- public, blog 모두 현재 세팅된 브랜치에 push 한다.\
public이 master 브랜치, blog가 dev브랜치에 있다면 각각 원격 브랜치로 push.

- 로컬, 원격 저장소 모두 연결된 상태다. (연결되지 않았다면 `--set-upstream` 커맨드 날릴 것.)
    ```shell script
    $ git branch --set-uptream-to=origin/[remote 브랜치명] [로컬 브랜치명]
    ```
- 사용하는 테마가 하나다. (여러가지 있다면 프로젝트 빌드 할 때 `hugo -t [테마명]`으로 세팅.)
- 커밋 메세지는 파일에 각각 저장해둔다. \
나의 경우, blog 관련 커밋메세지를 `/d/Hugo/mand2_blog/msg/blog.md` 파일 내부에 작성하였다.\
이 파일의 경로를 쉘스크립트 초반 `msg_blog_files` 변수에 넣는다.
- 쉘스크립트의 위치는 블로그(hugo blog) 루트에 위치한다.


<br>
<br>

#### 쉘 스크립트 deploy.sh 작성
{{< gist 277f0c526d51e6a3ca5b9270575360fa >}}

<br>

#### 실행 가능하게 만들기

`chmod +x deploy.sh` 커맨드를 날려서 `deploy.sh` 파일을 실행 할 수 있도록 변경한다.

<br>

#### 작성 후 실행

`.\deploy.sh` 로 실행한다. 아래는 결과 화면.\
- blog 커밋 내역
![blog](/images/TIL/blog-auto-commit-1.png)
- public 커밋 내역
![public](/images/TIL/blog-auto-commit-2.png)