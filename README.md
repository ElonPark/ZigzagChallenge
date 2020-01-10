# ZigzagChallengeApp

### 수행과제

* alter-date-format
* inflect-string
* shop-list-filter

---
> **개발환경**  
> `macOS 10.14.6`  
> `Xcode 11.0`  
> `Swift 5.1`

- shop-list-filter 실행 시 주의 사항

```shell
$ cd /ZigzagChallenge/shopListFilter
$ pod install --repo-update

```

Comment feedbak

1. ~~점수가 높을수록 쇼핑몰 순위가 높습니다. → 반대로 정렬~~
-> 조건 수정

2. ~~스타일을 두개 이상 선택한 경우, 두 스타일을 모두 만족하는 쇼핑몰을 하나만 만족하는 쇼핑몰보다 위에 표시합니다. 같은 개수안에서는 쇼핑몰 점수 순으로 정렬합니다. →   score + matching point 로 정렬하여 하나의 스타일이 만족하는 쇼핑몰이 모두 만족하는 쇼핑몰 보다 위에 표시됨(1 사항을 개선하였을 때)~~
-> 조건 수정

3. (마이너) 쇼핑몰 로그 파싱 오류: 다홍
-> 실제 API에서는 이런 방식으로 사용하지 않을 것이라 예상하며, 중요도가 높지 않다고 판단되서 수정 하지 않음.