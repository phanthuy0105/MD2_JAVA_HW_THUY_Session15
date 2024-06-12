create database BookManagement_DB;
use BookManagement_DB;
create table BookType (
                          catalog_id char(5) primary key,
                          catalog_name varchar(100) not null,
                          catalog_status bit
);
create table Book (
                      book_id int primary key auto_increment,
                      book_name varchar(100) not null unique,
                      book_price float check (book_price > 0),
                      author varchar(200),
                      publisher varchar(200),
                      publisher_year int,
                      catalog_id char(5),
                      foreign key (catalog_id) references BookType(catalog_id),
                      book_status bit
);
insert into BookType(catalog_id, catalog_name, catalog_status)
VALUES('DM1','Sách văn học',1),
      ('DM2','Sách thiếu nhi',0),
      ('DM3','Sách văn hoá xã hội',1),
      ('DM4','Sách triết học, tâm lý',1),
      ('DM5','Sách văn hóa thông tin',0);
select * from BookType;

insert into Book (book_name, book_price, author, publisher, publisher_year, catalog_id, book_status)
VALUES('Chí Phèo',100000,'Nam Cao','Văn học',2013,'DM1',1),
      ('Tự Thú Của Người Gác Rừng',150000,'Đỗ Kim Cuông','Văn hóa thông tin',2003,'DM5',1),
      ('Bản Chất Của Dối Trá',200000,'Dan Ariely','NXB Thế Giới',2009,'DM4',1),
      ('Gió Lạnh Đầu Mùa',220000,'Thạch Lam','Kim Đồng',2010,'DM1',1),
      ('100 Kỹ Năng Sinh Tồn',50000,'	Clint Emerson','Thanh niên',2020,'DM2',0),
      ('Việt Nam phong tục',180000,'Phan Kế Bính','Giáo dục',2017,'DM3',0),
      ('Tuổi Thơ Dữ Dội',160000,'Phùng Quán','Kim Đồng',2019,'DM2',1);
select * from Book;
-- 1. Viết procedure cho phép lấy danh sách danh mục sách
DELIMITER &&
create procedure get_all_BookType(

)
BEGIN
    select * from BookType;
end &&
DELIMITER &&;
call get_all_BookType();

-- 2. Viết procedure cho phép thêm mới danh mục sách
DELIMITER &&
Create procedure create_BookType(
    catalog_id_in char(5),
    catalog_name_in varchar(100),
    catalog_status_in bit
)
BEGIN
    insert into BookType(catalog_id, catalog_name, catalog_status)
    values (catalog_id_in,catalog_name_in,catalog_status_in);
end &&
DELIMITER &&
call create_BookType('DM6','Dân Trí',0);

-- 3. Viết procedure cho phép cập nhật danh mục sách
DELIMITER &&
create procedure update_BookType(
    catalog_id_in char(5),
    catalog_name_in varchar(100),
    catalog_status_in bit
)
BEGIN
    update BookType
    set catalog_id = catalog_id_in,
        catalog_name = catalog_name_in,
        catalog_status = catalog_status_in
    where catalog_id = catalog_id_in;
end &&
DELIMITER &&
call update_BookType('DM6','Công An Nhân Dân',0);

-- 4. Viết procedure cho phép xóa danh mục sách nếu danh mục sách chưa chứa quyển sách nào
DELIMITER &&
create procedure delete_BookType(
    catalog_id_in char(5)
)
BEGIN
    declare cntProduct int;
    set cntProduct = (select count(*) from Book b where b.catalog_id = catalog_id_in);
    if cntProduct = 0 then
        delete from Booktype where catalog_id = catalog_id_in;
    end if;
end &&
DELIMITER &&
call delete_BookType('DM4');

-- 5. Viết procedure cho phép lấy thông tin danh mục sách theo mã danh mục
DELIMITER &&
create procedure get_BookType_by_Id(
    catalog_id_in char(5)
)
BEGIN
    select * from BookType where catalog_id = catalog_id_in;
end &&
DELIMITER &&
call get_BookType_by_Id('DM2');

-- 6. Viết procedure cho phép lấy danh sách các sách
DELIMITER &&
create procedure get_all_Book(

)
BEGIN
    select * from Book;
end &&
DELIMITER &&;
call get_all_Book();

-- 7. Viết procedure cho phép thêm mới sách
DELIMITER &&
Create procedure create_Book(
    book_name_in varchar(100),
    book_price_in float,
    author_in varchar(200),
    publisher_in varchar(200),
    publisher_year_in int,
    catalog_id_in char(5),
    book_status_in bit
)
BEGIN
    insert into Book(book_name, book_price, author, publisher, publisher_year,catalog_id,book_status)
    values (book_name_in,book_price_in,author_in,publisher_in,publisher_year_in,catalog_id_in,book_status_in);
end &&
DELIMITER &&
call create_Book('Những ngày cuối cùng',250000,'Scott Westerfeld','Văn hóa thông tin',2008,'DM5',0);

-- 8. Viết procedure cho phép cập nhật sách
DELIMITER &&
create procedure update_Book(
    book_id_in int,
    book_name_in varchar(100),
    book_price_in float,
    author_in varchar(200),
    publisher_in varchar(200),
    publisher_year_in int,
    catalog_id_in char(5),
    book_status_in bit
)
BEGIN
    update Book
    set book_id = book_id_in,
        book_name = book_name_in,
        book_price = book_price_in,
        author = author_in,
        publisher = publisher_in,
        publisher_year = publisher_year_in,
        catalog_id = catalog_id_in,
        book_status = book_status_in
    where book_id = book_id_in;
end &&
DELIMITER &&
call update_Book(5,'100 Kỹ Năng Sinh Tồn',50000,'Clint Emerson','Thanh niên',2020,'DM2',0);

-- 9. Viết procedure cho phép xóa sách

DELIMITER &&
create procedure delete_Book(
    book_id_in int
)
BEGIN
    delete from Book where book_id = book_id_in;
end &&
DELIMITER &&
call delete_Book(8);

-- 10. Viết procedure cho phép lấy thông tin sách theo mã sách
DELIMITER &&
create procedure get_Book_by_Id(
    book_id_in char(5)
)
BEGIN
    select * from Book where book_id = book_id_in;
end &&
DELIMITER &&
call get_Book_by_Id(1);

-- 11. Viết procedure cho phép thống kê số lượng sách theo tác giả
DELIMITER &&
create procedure get_cnt_book_by_author(
    author_in varchar(200),
    out cnt_book int
)
BEGIN
    set cnt_book = (select count(b.book_id) from Book b where b.author = author_in);
end &&
DELIMITER &&;
call get_cnt_book_by_author('Thạch Lam',@cnt);
select @cnt;

-- 12. Viết procedure cho phép thống kê số lượng sách trong khoảng giá a-b
DELIMITER &&
create procedure get_cnt_book_by_price(
    from_price float,
    to_price float,
    out cnt_book int
)
BEGIN
    set cnt_book = (select count(b.book_id) from Book b where b.book_price between from_price and to_price);
end &&
DELIMITER &&;
call get_cnt_book_by_price(100000,200000,@cnt);
select @cnt;
