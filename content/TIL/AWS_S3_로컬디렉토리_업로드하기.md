---
title: "[AWS S3] 로컬 디렉토리에 있는 모든 파일 S3로 업로드하기"
date: 2021-09-02T22:53:31+09:00
draft: false
categories: TIL
tags:
- TIL
- AWS
- Kotlin
- Java
- Spring Boot
- Gradle
hidden: false
---

로컬에 있는 특정 파일(디렉토리) 안에 있는 모든 파일들을 
s3로 옮기는 작업을 진행하는 코드를 코틀린으로 만들어보자 🚀   
처음으로 코틀린으로 작성해본거라 코딩 컨벤션에 맞지 않을 수 있다 😅

aws 깃허브를 많이 참고하였고, 해당 참고했던 깃허브는 java 언어를 보고 참고하였다.  
참고했던 자료들은 이 글 제일 하단에 있다.  
<br>

전제조건은 다음과 같다.

### 1. 전제조건
- gradle 
- kotlin 
- jdk : aws-correto-11 (aws 오픈소스) 
- **로컬 파일 구조**  
  |-- d  
&nbsp;&nbsp;&nbsp;|-- test  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;|-- uploader
- AWS 버킷 생성 완료 + public 으로 전환

<br>

### 2. gradle 세팅

1. 기본 세팅
    ```kotlin
    implementation("com.amazonaws:aws-java-sdk-s3:1.12.52")
    ```
<br>

2. 버전관리용 세팅  
   aws-sdk 라이브러리를 많이 사용한다면 `aws-java-sdk-bom` 라는 걸로 한번에 버전관리를 할 수 있다.
   (관련 [docs](https://docs.aws.amazon.com/ko_kr/sdk-for-java/v1/developer-guide/setup-project-gradle.html)).  
   [bom 버전 확인하러 가기](https://mvnrepository.com/artifact/com.amazonaws/aws-java-sdk-bom)   
   bom 버전은 **1.xx 대 버전이어야 한다**. high-level 메서드인 TransferManager를 사용하므로 bom 2.xx 버전은 사용 불가.  
아마존에서는 2.xx 대 버전으로 마이그레이션을 많이 해두었긴 했는데 아직 S3에서 사용하는 주요 메서드들은 마이그레이션이 덜 되었다 ...ㅎ
[aws sdk chagne log](https://github.com/aws/aws-sdk-java-v2/blob/master/docs/LaunchChangelog.md#411-s3-operation-migration) 참고
  - 코틀린 4.6 버전 이상:
      ```kotlin
      dependencies {
          implementation("com.amazonaws:aws-java-sdk-bom:1.12.52")
          implementation("software.amazon.awssdk:s3")
      }
      ```

  - 코틀린 4.6 버전 이전:
      ```kotlin
      dependencyManagement {
          imports {
              mavenBom("software.amazon.awssdk:bom:1.12.52")
          }
      }
      dependencies {
          implementation("software.amazon.awssdk:s3")
      }
      ```

<br>
<br>

### 3. 디렉토리 S3 업로더 코틀린으로 작성하기
#### 3-1. 업로드할 S3 버킷과 연결하기 - TransferManagerBuilder 생성하기
S3 버킷에 접근 가능한 `aws_access_key_id` 와 `aws_secret_access_key`, `region` 을 사용하여   
`AmazonS3ClientBuilder` 를 만든다. 그 후 한꺼번에 업로드 할 수 있는 `TransferManagerBuilder` 를 만들어 반환하기

{{< gist a95dd54290f467838f76438fa323c17c >}}

<br>
<br>

#### 3-2. S3 버킷에 업로드하는 부분 만들기 - basic
1. 먼저 `local_path` 가 /d/test/uploader/ 라고 하자.   
   uploader 내부에는 수많은 파일이 있고, 각 파일마다 2mb 를 넘지 않는다고 가정.  
   만약 파일 하나 하나의 사이즈가 크다면 다른 방식으로 해야 됨. 하단 참고부분에서 **멀티파트 업로드를 사용한 객체 업로드** 부분을 참고할 것.  
   <br>

2. s3에 업로드 될 path 는 {bucket_name} path1/path2/upload/210831/ 이라고 가정.  
   `bucket_name` = mand2 로 한다.  
   `default_path` = /path1/path2/ 로 가정.  
   참고로 s3 업로드시 해당 객체(경로)가 없어도 자동으로 생성되므로 '먼저 객체를 만들어야하나?🤔' 하고 고민하지 않아도 된다. (내가 고민하다 삽질해봄..ㅎ)
   > 👀 주의사항   
   각 path 앞, 뒤에 `/` 가 있다면 없애주자.   
   예를들어 `/mand2/path1/path2/....` 이라고 설정이 된다면 실제로 업로드 되지 않음.   
   테스트 해보면 알겠지만 업로드 완료 라고 뜨지만 **실제 s3에는 객체가 생성이 되지 않는다**.

<br>

{{< gist 3cae451b66ed8460ff46c531ab242a48 >}}


<br>
<br>


#### 3-3. S3 버킷에 업로드하는 부분 만들기 - advanced
위에 코드를 실행해보면 답답할 것이다. 얼마나 완료되었는지 확인을 못하므로..🤔   
그러니 진행률을 같이 볼 수 있도록 로그를 남겨서 확인할 수 있게 해주자.

좀 더 보기 편하게 진행율 포맷을 **0.00%** 로 보이도록 만들었다.

{{< gist 26a3c01cf3f14d2f747e50bc5bb76d7f >}}

<br>
<br>

결과 예시
```text
[Running] upload progressing... start
[Running] 0.35% upload progressing...
[Running] 0.70% upload progressing...
[Running] 1.06% upload progressing...
[Running] 1.44% upload progressing...
[Running] 1.80% upload progressing...
[Running] 2.15% upload progressing...
[Running] 2.52% upload progressing...
[Running] 6.81% upload progressing...
[Running] 11.00% upload progressing...
[Running] 15.00% upload progressing...
[Running] 19.12% upload progressing...
[Running] 23.31% upload progressing...
```



<br>
<br>
<br>


어쩌다 보니 코틀린까지 하게 되었는데, 변수 선언 방식도 그렇고 좀 더 유동적이라 재밌는것 같다.   
같이 일하는 동료가 '쓸데없는 코드 작성시간을 줄인다' 는 평을 했었는데 왜 그런 평을 했는지 알 것 같다. ㅎㅎ   
어찌저찌 코틀린으로 작성한거라 문제 많을 수 있음.   
참고로 cli 로는 아주 간단하다. 
```shell
aws s3 cp {{local_directory}} s3://{{s3_bucket}} --recursive
```
<br>
<br>

----------

#### 참고 

**AWS**
- Basics
  - 기본적인 docs 안내사항: [TransferManager를 이용한 디렉토리 업로드](https://docs.aws.amazon.com/ko_kr/sdk-for-java/v1/developer-guide/examples-s3-transfermanager.html#transfermanager-upload-directory)
  - 위의 [github 예제코드](https://github.com/awsdocs/aws-doc-sdk-examples/blob/master/java/example_code/s3/src/main/java/aws/example/s3/XferMgrUpload.java)
- Advanced - 진행률 관련
  - 관련 docs [Poll the Current Progress of a Transfer](https://docs.aws.amazon.com/sdk-for-java/v1/developer-guide/examples-s3-transfermanager.html#transfermanager-get-status-and-progress)
  - 관련 [깃허브 예제코드](https://github.com/awsdocs/aws-doc-sdk-examples/blob/master/java/example_code/s3/src/main/java/aws/example/s3/XferMgrProgress.java)
- docs: [Performing Operations on Amazon S3 Objects](https://docs.aws.amazon.com/ko_kr/sdk-for-java/v1/developer-guide/examples-s3-objects.html)
- **멀티파트 업로드**를 사용한 [객체 업로드_AWS SDK 사용(상위 수준 API)](https://docs.aws.amazon.com/ko_kr/AmazonS3/latest/userguide/mpu-upload-object.html)  
    plus) `하위 수준 API` 사용 기준:
  - 멀티파트 업로드를 일시 중지한 후 다시 시작해야 하거나
  - 업로드 중에 부분 크기를 변경해야 하거나
  - 업로드 데이터 크기를 미리 확인하지 않은 경우

**Blogs**
- Spring Boot :: Kotlin으로 AWS S3 업로드 기능 구현
  [https://wave1994.tistory.com/131](https://wave1994.tistory.com/131)


