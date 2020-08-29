---
title: "DB index의 정의"
date: 2019-12-19T18:20:06+09:00
draft: false
categories: TIL
tags:
- TIL
- DB
hidden: false
---

## What is index?

**USAGE 1 : Support for fast Lookup**  
An index is any data structure that improves the performance of lookup. There are many different [data structures](https://en.wikipedia.org/wiki/Category:Data_structures) used for this purpose. There are complex design trade-offs involving lookup performance, index size, and index-update performance. Many index designs exhibit logarithmic (O(log(N)) lookup performance and in some applications it is possible to achieve flat (O(1)) performance. 

**USAGE 2 : Policing the database constraints** (I assumed it as a DB table guideline)  
Indexes are used to police [database constraints](https://en.wikipedia.org/wiki/Database_constraints), such as UNIQUE, EXCLUSION, [PRIMARY KEY](https://en.wikipedia.org/wiki/Unique_key) and [FOREIGN KEY](https://en.wikipedia.org/wiki/Foreign_key).   

- An index may be declared as UNIQUE, which creates an implicit constraint on the underlying table. Database systems usually implicitly create an index on a set of columns declared PRIMARY KEY, and some are capable of using an already-existing index to police this constraint. 
- Many database systems require that both referencing and referenced sets of columns in a FOREIGN KEY constraint are indexed, thus improving performance of inserts, updates and deletes to the tables participating in the constraint. 

<br><br>

### 1 Applications and limitations

{{% notice note %}}
-index가 없으면 full scan 함<br>
-index가 있다면 쉽게 B-tree 구조로 되어 스캔(시간단축된다)<br>
-like 를 쓸 때에는 index가 있더라도 full scan 될 수 있음
{{% /notice %}}


Indexes are useful for many applications but come with some limitations. Consider the following [SQL](https://en.wikipedia.org/wiki/SQL) statement: `SELECT first_name FROM people WHERE last_name = 'Smith';`. To process this statement without an index the database software must look at the last_name column on every row in the table (this is known as a [full table scan](https://en.wikipedia.org/wiki/Full_table_scan)). With an index the database simply follows the [B-tree](https://en.wikipedia.org/wiki/B-tree) data structure until the Smith entry has been found; this is much less computationally expensive than a full table scan.

Consider this SQL statement: `SELECT email_address FROM customers WHERE email_address LIKE '%@wikipedia.org';`. This query would yield an email address for every customer whose email address ends with "@wikipedia.org", but even if the email_address column has been indexed the database must perform a full index scan. This is because the index is built with the assumption that words go from left to right. With a [wildcard](https://en.wikipedia.org/wiki/Wildcard_character) at the beginning of the search-term, the database software is unable to use the underlying B-tree data structure (in other words, the WHERE-clause is *not [sargable](https://en.wikipedia.org/w/index.php?title=Sargable&action=edit&redlink=1)*). This problem can be solved through the addition of another index created on `reverse(email_address)` and a SQL query like this: `SELECT email_address FROM customers WHERE reverse(email_address) LIKE reverse('%@wikipedia.org');`. This puts the wild-card at the right-most part of the query (now gro.aidepikiw@%), which the index on reverse(email_address) can satisfy.

When the wildcard characters are used on both sides of the search word as *%wikipedia.org%*, the index available on this field is not used. Rather only a sequential search is performed, which takes O(N) time.

<br><br>



### 2 Types of indexes

#### 2-1 Bitmap index

Main article: [Bitmap index](https://en.wikipedia.org/wiki/Bitmap_index)

A bitmap index is a special kind of indexing that stores the bulk of its data as [bit arrays](https://en.wikipedia.org/wiki/Bit_array) (bitmaps) and answers most queries by performing [bitwise logical operations](https://en.wikipedia.org/wiki/Bitwise_operation) on these bitmaps. The most commonly used indexes, such as [B+ trees](https://en.wikipedia.org/wiki/B%2B_tree), are most efficient if the values they index do not repeat or repeat a small number of times. In contrast, the bitmap index is designed for cases where the values of a variable repeat very frequently. For example, the sex field in a customer database usually contains at most three distinct values: male, female or unknown (not recorded). For such variables, the bitmap index can have a significant performance advantage over the commonly used trees.

<br><br>

### 3 Others to see

- search engine indexing [URL](https://en.wikipedia.org/wiki/Search_engine_indexing)
- InnoDB [URL](https://en.wikipedia.org/wiki/InnoDB)
- more information about index [URL](https://en.wikipedia.org/wiki/Database_index)

<br><br><br>

------

quotes from [wiki](https://en.wikipedia.org/wiki/Database_index)