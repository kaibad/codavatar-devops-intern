# Database
 what is data? data are the raw facts that are found after some experiment observation or after some experiments. Data iteself do nyoprovide any menaing but after processing it becomes information

Database: the collection of data orgaized in some specific manner is know as database. for example, univeristy database for maintaining information about students course and grade in wniveristiy

DBMS: softeare , computerized way of keepin record


data abstraction: hiding mechanism of deatils of data org and storage and highliighting of the essential features for a improves understanfing of data.

There are 3 levels of abstraction
1. physical level/lowest level : describes how deta is actually stored in database
2. logical level: describes type od ata  -stored and relation between them
3. View level/highest level: describes interaction between users and system

Data modes: ollection od condepts  thact can be used to describe structure of a database.

## database language
- specialized lnaguage used to intercat with a database
- definfing, controllign and m anipulating data


ddms langs: DDL, DCL, DML, TCL

DDL: CREATE, ALTER, DROP, TRUNCATE, RENAME
DCL: GRANT, REVOKE
DML: SELECT,INSERT,UPDATE,DELETE,MERGE,CALL
TCL: COMMIT,ROLLBACK

DCL is used to control the access permissions fo users to the databases. It helps grant or revoke privileges to used, determining who can perfom actions like reading or modifying data.

GRANT PRIVILEGES ON OBJECT TO user

GRANT SELECT,INSERT ON student TO user
REVOKE ALL PRIVILEGS ON student FROM user

What type of statents are generally controlled bu oj=bject privilegs? DML

COMMIT command is used to save all changes made during the transaction in the DB. thi commanda ensures thta modeficstion made bythe DML statements such as  INSERT, UPDATE OR DELETE becomde permanent in the dabase

the rollback command is used to restire the DB  to its state at the last commit, efectiverly undoing any changes made since that point.

## Relation mdeo,, concepts

IT reprets teh datvase an a colection of a relations, A relation is nothin but a table of values.

Every row in a table represents a collection of realted data values

the table name and cou=lumne names and helpful to interprre the meanibg of valuesin each row
the data rae represnt as th set of relations.

Domain: A domainis a ser of acceptable values rha a colume is allowed to cintaine this is based on a varous propertis ad values ot model data.
 for example: the domain of marital sattus has a set possibilities: married, single, divorced

attribues: each row in the relation is known as tuple. IT contains teh data recoreds

Relation: A reltion is relation data mmodel represnt the respectibve attirbutes models represnt the repsectie attibutes and teh correleation amoomng them

## SQL STRUCTURED QUERY LANGUAGE

1. create a table: CREATE tabel_name{
  col1 datype, col2 datatype PRIMARY KEY(ONE OR MORE)
}

example

### DATATYOPE SIN SQL
1. number: INTEER,Int,SMALL INT, FLOAT, DOUBLE PRECIISON, DECIMAL(I,J) where i = total no. of decimal digit and j is the toatal no. og digit after deciaml point
2. charater sstrng
3. bit string
4. boolean and null
5. DATE
6. TIME

## bASIC RETRIEVAL QUERIS 

SELECT-FROM-WHERE

SELECT <attrname>
FROM <table list>
where <condition>

## Ambigious Attribute names

In sql the same name can be used for two or more attribures as long as the attributes are indifferebt tabkes

if this is the acse ans a multibale query refers to the attribire namw with the relation name to present ambihty

This is done by prefixing the relation name of teh name and separting the two by period .

```sql
SELECT EMPLOYEE.fname, Address
FROM employee, department
WHERE Dnmae="Reaserch" AND Dnumber='dno'

```

## Aliasing and tupe variables

keyword: AS

```SQL
 SELECT e.fname, e.lname, s.fname,s.lname
FROM EMPLOYEE AS E, EMPLOYEE AS s
WHERE e.siper_ssn=s.ssn

```

Asterik (*) = all

## Pattern matching and arithmertic operatos

This feature allows comparison conditions on any parts of a character string, sunginthe LIKE compariosn operatio . this can be used for string pattern matching

Partial strings are speified using two reserves characters, % replaces an arbotary number of ero ro more charcaters and the  unerscore (_)  replaces a single characters

Patterns are case sensitive special characters (percent, underscore) can be uncluded in patterns using an escpe charavter \ baclslash

### example

1. 'RAJ%' MATCHE ANU STRING starting ith RAj
2. '%RAJ' matches any string ending with RAJ
3. --91 matches with any string ending with 91 wuth any two characters before that
4. ---- matches any string with exactly four characters

%,_ are the wild card ioperators 

##  Other operatoes

arithmatic operator; + - * / %
comparison operatoes: also called WHERE clause opeators: =,< , > , <=,=>, <> or != ,!> , !< etc
logical operator: NAD OR NOT

BETWEEN:- seacrhes the values within the range metnioned
EXISTS: uses to search for the row's present in the table
LIKE: compares a pattern using wildcar operatos
ALL: used to compare specific values to all otehr values in set
ANY: compares a specific values to any of the values in set

since null can never be equal to any value, it can never be unqual, either

the coret way to write the queries is insted of using boolean compariosn operators such as less than a greater thean , equal to and not equal to these queris must be written with the special comparison opertor. IS NUL the is null operator test wheregr values is null or not null and returnns a boolean

for ex: select * from table where columen is not null;

similary there are nested quesries

## concepot of view

single table that is derived from other tables 

```sql
CREATE VIEW command

CREATE VIEW new_name AS
SELECT col1, col2
FROM table_name
WHERE cindition


```

## TRANSACTION PROCESSING

A transaction is an executinf program that forms a logical unit of database processing.

A transacgtion includes one or more databasea access operations these can include insertion, deletion, modification ot retrieval operations.

### Read abd write operatons

read_item(x)
write_items(x)

DBMS buffer

Consurrency and concurency control

read write and write write conflict issues

ACID PROPTIES
NORMALIZATION
transcstion states nad operatis



A trancation is an atomic unnit of work that should either be completed in its entirert ir not done at all




## Instalation od mysql using docker

```bash
docker run -d --name mysql-container -e MYSQL_ROOT_PASSWORD=root -p 3306:3306 -v mysql-data: /var/lib/mysql mysql:8.4

docker exec -it mysql-container /bin/bash 

mysql -u root -p
```

#3 port number of popular database

- mysql: 3306
- postgres: 5432:5432
- mongodv:  27017
- redis: 6379






# REFERENCES

1. https://dev.to/gbengelebs/unboxing-a-database-how-databases-work-internally-155h
2. https://stackoverflow.com/questions/10378693/how-does-mysql-store-data
3. https://vijayasimhabr.medium.com/running-mysql-database-server-with-docker-ad10533473c7
4. https://www.geeksforgeeks.org/dbms/database-languages-in-dbms/
