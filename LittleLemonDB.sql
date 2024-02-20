create table Customers
(
    CustomerID   int auto_increment
        primary key,
    CustomerName varchar(255) not null,
    Contact      varchar(255) not null
);

create table Bookings
(
    BookingID   int auto_increment
        primary key,
    TableNo     int      null,
    BookingSlot time     not null,
    CustomerID  int      not null,
    BookingDate datetime not null,
    constraint CustomerID
        foreign key (CustomerID) references Customers (CustomerID)
);

create table Employees
(
    EmployeeID     int auto_increment
        primary key,
    Name           varchar(255) null,
    Role           varchar(100) null,
    Address        varchar(255) null,
    Contact_Number int          null,
    Email          varchar(255) null,
    Annual_Salary  varchar(100) null
);

create table MenuItems
(
    ItemID int auto_increment
        primary key,
    Name   varchar(200) null,
    Type   varchar(100) null,
    Price  int          null
);

create table Menus
(
    MenuID  int          not null,
    ItemID  int          not null,
    Cuisine varchar(100) null,
    primary key (MenuID, ItemID)
);

create table Orders
(
    OrderID     int     not null,
    TableNo     int     not null,
    MenuID      int     null,
    BookingID   int     null,
    TotalCost   decimal not null,
    Quantity    int     not null,
    column_name int     null,
    primary key (OrderID, TableNo),
    constraint BookingID
        foreign key (BookingID) references Bookings (BookingID),
    constraint MenuID
        foreign key (MenuID) references Menus (MenuID)
);

create table OrderDelivery
(
    DeliveryID     int          null,
    DeliveryStatus varchar(255) not null,
    DeliveryDate   datetime     not null,
    OrderID        int          not null
        primary key,
    constraint OrderID
        foreign key (OrderID) references Orders (OrderID)
);

create
    definer = root@localhost procedure BasicSalesReport()
BEGIN
    SELECT 
    SUM(BillAmount) AS Total_Sale,
    AVG(BillAmount) AS Average_Sale,
    MIN(BillAmount) AS Min_Bill_Paid,
    MAX(BillAmount) AS Max_Bill_Paid
    FROM Orders;
    END;

create
    definer = root@localhost procedure GuestStatus()
BEGIN
    
    SELECT 
        CONCAT(b.GuestFirstName, b.GuestLastName) AS GuestName,
        CASE
        WHEN e.Role = 'Head Chef' THEN 'Ready to serve'
        WHEN e.Role = 'Assistant Chef' THEN 'Preparing Order'
        WHEN e.Role = 'Head Waiter' THEN 'Order served'
        WHEN e.Role = 'Manager or Assistant Manager' THEN 'Ready to pay'
        ELSE 'Pending'
        END
        AS OrderStatus
    FROM Bookings b
    LEFT JOIN Employees e 
    ON b.EmployeeID = e.EmployeeID;
    END;

create
    definer = root@localhost procedure PeakHours()
BEGIN
    
    SELECT 
        HOUR(BookingSlot) AS Booking_Hour,
        COUNT(HOUR(BookingSlot)) AS n_Bookings
    FROM Bookings
    GROUP BY Booking_Hour
    ORDER BY n_Bookings DESC;
    
    END;


