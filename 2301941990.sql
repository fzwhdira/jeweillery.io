--NIM: 2301941990
--Nama: Fauza Wahidira

--No 1
select j.JewelleryID,
	JewelleryName,
	cast(sum(Quantity)as varchar) + ' Jewelleries' as [Total Jewellery Sold ]
from Jewellery j join DetailTransaction dt on dt.JewelleryID = j.JewelleryID
group by j.JewelleryID, JewelleryName

--No 2
go
create proc [Insert New Customer] 
	@id char(5), @name varchar(50), @gender varchar(50), @dob date, @email varchar(50), @phone varchar(50) as 
begin
	if exists(select * from Customer where len(@name) >= 3 and (2021 - year(@dob) >= 17))
	begin
		insert into Customer values(@id, @name, @gender, @dob, @email, @phone)
		select * from Customer
	end
	else
		print 'CustomerName length must be at least 3 characters.'
		print 'CustomerAge must be at least 17 years old.'
end

drop proc [Insert New Customer]

exec [Insert New Customer] 'CU008', 'Agustina Intania', 'Female', '2000-08-08', 'agustina@yahoo.com', '+6285623195667'
exec [Insert New Customer] 'CU008', 'AI', 'Female', '2005-08-08', 'agustina@yahoo.com', '+6285623195667'
exec [Insert New Customer] 'CU008', 'Agustina Intania', 'Female', '2005-08-08', 'agustina@yahoo.com', '+6285623195667'

select * from customer

--No 3
go
create proc [View My Transaction] @CustomerName varchar(50)
as
begin
	print 'My Jewellery Transaction'
	print 'Customer Name: ' + @CustomerName
	print '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
	print 'List Transactions'

	declare @jewelleryName varchar(50), 
			@totalQuantity int
	
	declare c cursor for
	select JewelleryName,
			sum(Quantity)as [TotalQuantity]
	from DetailTransaction dt join Jewellery j on dt.JewelleryID = j.JewelleryID join HeaderTransaction ht on ht.TransactionID = dt.TransactionID join Customer c on c.CustomerID = ht.CustomerID
	where CustomerName = @CustomerName
	group by JewelleryName, CustomerName

	open c
	fetch next from c into @jewelleryName, @totalQuantity
	while @@FETCH_STATUS = 0
	begin 
		print '+ ' + @jewelleryName + ' -> ' + cast(@totalQuantity as varchar) + ' Jewelleries'
		fetch next from c into @jewelleryName, @totalQuantity
	end
	print '~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~'
	close c
	deallocate c
end

drop proc [View My Transaction]

exec [View My Transaction] 'Louis Hood'

--No 4
go
create trigger InsertJewelleryTrigger on Jewellery 
for insert as
begin
	select * from Jewellery
	declare @id char(5), @name varchar(50), @material varchar(50), @weight int, @price decimal(10,2)
	select *from inserted 
end

drop trigger InsertJewelleryTrigger

begin tran
insert into Jewellery
values('JE008', 'Haera Necklace', 'Diamond', 5, 5000000)

select * from Jewellery

rollback