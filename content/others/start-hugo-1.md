---
title: "Hugo로 블로그 만들기 1"
date: 2020-09-13T19:34:07+09:00
draft: false
categories: Blog
tags:
- Hugo
- Others 
hidden: false
---

## hugo 설치

#### 1 백업
일단 기존 github blog 글들을 백업해둔다

#### 2 전제조건  
기존에 git bash 와 node.js (npm, yarn 모두) 설치 되어 있었다. 

#### 3 Hugo 디렉토리 생성   
원하는 디렉토리에 생성.    
나는 D: 에 설치하는게 편하므로 `D:\Hugo` 내부에 `bin` , `Sites` 디렉토리를 생성
> D:  
> |-- Hugo  
> 	|--bin  
> 	|--Sites

#### 4 Hugo 다운로드   
최신 release 파일을 [주소](https://github.com/gohugoio/hugo/releases)에서 다운로드.  (🔊 당시 v.0.74.3이 최신버전이었음.)   
아까 생성한 `D:\Hugo\bin` 폴더에 해당 zip 파일 풀어준다. 



#### 5 환경변수 설정  
환경변수 설정 `win 키+Q` -> **시스템 환경 변수 편집** -> `고급` 탭의 환경변수 -> 시스템 변수 의 `Path` 에 내가 정한 `Hugo\bin` 디렉토리를 써준다
> Path = D:\Hugo\bin

#### 6 설치확인

- git bash 프롬프트에서 `$ hugo version` 으로 확인 해본다. 설치한 v.0.74.3이 나오면 OK👌

- `$ hugo help` 를 치면 아래와 같은 결과가 나오면 OK👌

  ```bash
  hugo is the main command, used to build your Hugo site.
  
  Hugo is a Fast and Flexible Static Site Generator
  built with love by spf13 and friends in Go.
  
  Complete documentation is available at http://gohugo.io/.
  ```

  만약 안나온다? hugo.exe 파일이 있는 디렉토리 경로를 환경변수에 정확히 넣어준다. 

  > 💥그래도 안나와요!!  👉 [forum](https://discourse.gohugo.io/)에 들어가세요.
  > If you’re still not getting the output, search the [Hugo discussion forum](https://discourse.gohugo.io/) to see if others have already figured out our problem. If not, add a note—in the “Support” category—and be sure to include your command and the output.



## github 저장소 2개 만들기

- 컨텐츠와 소스 파일을 포함할 repo    
-> 컨텐츠 관련이라 `mand2_blog` 로 생성
  (https://github.com/mand2/mand2_blog)
- 실제 blog에 보여질 github.io repo    
-> 나의 경우 `mand2.github.io` 로 생성



## hugo site 만들기

#### 1. 테마 설치하기

Hugo 가 설치되어있는 파일로 들어간다.

> $ cd d:  
> $ cd Hugo    
> $ hugo new site {{blog name}}

나는 mand2_blog 로 했으므로 `$ hugo new site mand2_blog` 로 했고 
해당 디렉토리에서 `$ git init` 함.   
여러가지 테마를 봤지만, 그나마 내가 원하는 형식에 부합하는 테마가 `hugo-theme-learn` 이라 선택(~~aws 교육 받을 때 볼 수 있는 guide book 느낌~~).

좀 더 **안전하게** 하기 위해, 해당 테마를 fork 하고 **submodule**로 가져온다.

> $ git submodule add {{git_theme_repo}} theme/{{원하는 테마 이름}}
>
> 나의 경우: d:\Hugo\mand2_blog 에서 함.
> `$ git submodule add https://github.com/mand2/hugo-theme-learn.git themes/learn`


#### 2 conf 설정값 변경
```toml
baseURL = "{{나의 깃허브 주소}}"
languageCode = "en-us,ko-kr" # i18n 에 맞춰 작성.
title = "GoRaNee's dev-log" # 웹사이트제목

# Change the default theme to be use when building the site with Hugo
theme = "learn" # 테마이름: themes 디렉토리 아래 저장한 테마명을 입력한다.

# For search functionality
[outputs]
home = [ "HTML", "RSS", "JSON"]
```

#### 3 git 저장소로 등록
- 블로그 컨텐츠 git 저장소로 등록 : 
$ git remote add origin git@github.com:mand2/mand2_blog.git

- 실제 보여질 블로그 git 저장소 추가등록:
`$ git submodule add -b master git@github.com:{{깃 user name}}/{{깃 user name}}.github.io.git public`

> 나는 RSA 등록을 해버렸...기 때문에 접근을 https 로만 가능하다.
> `$ git submodule add -b master https://github.com/mand2/mand2.github.io public`

- 이렇게 함으로써 `hugo` 명령으로 `public`에 웹사이트를 만들 때, 만들어진 `public` 디렉토리는 다른 remote origin을 가질 것이다.





### contents 만들기 

1 내가 선택한 **Hugo-theme-learn** 은 기본 골격을 보여주므로, 커맨드라인을 잘 사용하자

2 chapter 만들기

```bash
$ hugo new -k chapter about/_index.md
$ hugo new --kind chapter about/_index.md
# 커맨드 위치는 d:\Hug\mand2_blog
```

- `-k` 나 `--kind` 나 상관없다. 어떤 종류의 content 로 만들건지 미리 정해주는 커맨드임.  
👉 `mand2_blog\content` 디렉토리 안에 `about` 이라는 폴더가 생성됨!! 

- 확인사항: `about\_index.md` 파일을 열고, chapter 가 `true`로 설정되었는지 확인해야 한다. 그 후, 해당 chapter의 기본적인 내용을 적어준다.

3 chapter 내부에 해당하는 page 만들기

```bash
$ hugo new about\first-content.md
```



4 실제 로컬에서 확인

```bash
$ hugo server # 실제 배포될 때의 모습
$ hugo server -D # 실제 배포될 때의 모습 + draft도.
```

`page`의 옵션이 draft = true 가 되면 server를 로컬로 돌렸을 때 draft 용 옵션 커맨드를 추가해야 보여진다.



### 컨텐츠 업로드 (블로그에)
아래 단계가 귀찮으므로 [auto commit 하기](http://mand2.github.io/til/blog-auto-commit/)를 참고해도 좋다👍
- `C:\Hugo\blog`로 이동

- `$ hugo -t 테마이름` 명령을 통해 테마가 적용된 블로그 내용을 public에 생성한다.

- `$ cd public` public 디렉토리로 이동하여

- `$ git add .` 수정된 파일들을 index에 올린다.

- `$ git commit -m "커밋메세지"` 변경 내용을 commit하고

- `$ git push origin master` commit을 Integerous.github.io에 푸시

- ```
  blog 저장소
  ```

  에도 변경내용 push 하기

  - `$ cd blog`
  - `$ git add .`
  - `$ git commit -m "커밋메세지"`
  - `$ git push origin master`

