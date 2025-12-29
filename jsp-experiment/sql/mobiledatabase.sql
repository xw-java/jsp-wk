create table if not exists mobiledatabase.chat_msg
(
    id       int auto_increment
        primary key,
    logname  char(30)     null,
    content  varchar(200) null,
    sendTime datetime     null
);

create table if not exists mobiledatabase.mobileclassify
(
    id   int auto_increment
        primary key,
    name varchar(50) null
);

create table if not exists mobiledatabase.mobileform
(
    mobile_version char(30)     not null
        primary key,
    mobile_name    varchar(50)  null,
    mobile_made    varchar(20)  null,
    mobile_price   float        null,
    mobile_mess    varchar(600) null,
    mobile_pic     varchar(200) null,
    id             int          null,
    constraint mobileform_ibfk_1
        foreign key (id) references mobiledatabase.mobileclassify (id)
);

create table if not exists mobiledatabase.online_users
(
    logname     char(30) not null
        primary key,
    last_active datetime null
);

create table if not exists mobiledatabase.orderform
(
    orderNumber int auto_increment
        primary key,
    logname     char(30)      null,
    mess        varchar(5000) null
);

create table if not exists mobiledatabase.user
(
    logname  char(30)    not null
        primary key,
    password varchar(30) null,
    phone    char(20)    null,
    address  char(50)    null,
    realname char(60)    null
);

create table if not exists mobiledatabase.comments
(
    cid         int auto_increment
        primary key,
    logname     char(30)     null,
    goodsId     char(30)     null,
    content     varchar(500) null,
    commentDate datetime     null,
    constraint comments_ibfk_1
        foreign key (logname) references mobiledatabase.user (logname)
);

create index logname
    on mobiledatabase.comments (logname);

create table if not exists mobiledatabase.shoppingform
(
    goodsId     char(30)    not null,
    logname     char(30)    not null,
    goodsName   varchar(50) null,
    goodsPrice  float       null,
    goodsAmount int         null,
    constraint shoppingform_ibfk_1
        foreign key (logname) references mobiledatabase.user (logname)
);

create index logname
    on mobiledatabase.shoppingform (logname);

