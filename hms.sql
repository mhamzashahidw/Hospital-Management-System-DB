create database hms;
use hms;
create table Department2(
Dept_Id int identity(1,1) primary key,
Dept_Name varchar(50),
Dept_Location varchar(50)
);
create table Employee1(
Employee_Id int identity(1,1) primary key,
First_Name varchar(50),
Last_Name varchar(50),
CNIC varchar(50) unique,
Gender varchar(50),
phone varchar(50),
Addresse varchar(150),
Joining_Date date,
Salary bigint,
Role_Type varchar(50) check(Role_type in('Doctor','Nurse','Admin','Staff'))
);
create table Doctor(
Doctor_Id int primary key,
foreign key(Doctor_Id)references Employee1(Employee_Id),
Dept_Id int foreign key(Dept_Id)references Department2(Dept_Id),
Specialization varchar(50),
License_Number varchar(50),
Schedule varchar(50),
Consultation_Fee bigint
);


;


create table Patient(
Patient_Id int identity(1,1) primary key,
First_Name varchar(50),
Last_Name varchar(50),
DOB date,
Gender varchar(50),
Blood_Group varchar(50),
Phone varchar(50),
Addresse varchar(150)
);

create table Medical_History(
History_Id int identity(1,1)primary key,
Patient_Id int foreign key(Patient_Id)references Patient(Patient_Id),
Condition varchar(50),
Diagnosed_Date date,
Extra_Details varchar(300)
);



create table Room(
Room_Id int primary key,
Dept_Id int foreign key(Dept_Id)references Department2(Dept_Id),
Type_Of_Room varchar(50),
Cost_Per_Day bigint,
Statuss varchar(50)
);



create table Appointment(
Appt_Id int identity(1,1) primary key,
Patient_Id int foreign key(Patient_Id) references Patient(Patient_Id),
Doctor_Id int foreign key(Doctor_Id)references Doctor(Doctor_Id),
Appt_Date_Time datetime,
Statuss varchar(50) default'Scheduled'
);

create table Admission(
Admission_Id int identity(1,1)primary key,
Patient_Id int foreign key(Patient_Id)references Patient(Patient_Id),
Room_Id int foreign key(Room_Id)references Room(Room_Id),
Admit_Date date,
Discharge_Date date
);

create table Medicine(
Medicine_Id int primary key identity(1,1),
MName varchar(50),
MType varchar(50),
Stock_Quantity int,
Unit_Price bigint
);


create table Prescription(
Prescription_ID int identity(1,1)primary key,
Appt_Id int foreign key (Appt_Id)references Appointment(Appt_Id),
Medicine_Id int foreign key(Medicine_Id)references Medicine(Medicine_Id),
Dosage varchar(50)
);

go
create trigger ReduceStock
on Prescription 
After insert
As
Begin
Declare @Med_Id int;
select @Med_Id=Medicine_Id from inserted;
update Medicine
set Stock_Quantity=Stock_Quantity-1
where Medicine_Id=@Med_Id;
End;


create table Lab_Test(
Test_Id int primary key,
Test_Name varchar(50),
Cost bigint
);

create table Lab_Report(
Report_Id int primary key,
Patient_Id int foreign key(Patient_Id)references Patient(Patient_Id),
Test_Id int foreign key(Test_Id)references Lab_Test(Test_Id),
Result_Date date,
Result_Details varchar(300)
);


create table Bill(
Bill_Id int identity(1,1) primary key,
Patient_Id int foreign key(Patient_Id)references Patient(Patient_Id),
Admission_Id int foreign key(Admission_Id)references Admission(Admission_Id),
Total_Amount bigint,
Payment_Status varchar(50),
Genrated_Date datetime
);



create view Public_Doctor_Directory as
select
E.First_Name,
E.Last_Name,
D.Specialization,
D.Consultation_Fee 
from Employee1 E join Doctor D
on E.Employee_Id=D.Doctor_Id;


insert into Department2(Dept_Name,Dept_Location)values
('Cardiology','First Floor,Wing A'),
('Neurology','Second Floor,Wing B'),
('Pharmacy','Ground Floor'),
('Laboratory','Basement');
insert into Employee1(First_Name,Last_Name,CNIC,Gender,phone,Addresse,Joining_Date,Salary,Role_Type) values
('Ali','Khan','35201-1111111-1','Male','0300-1111111','Lahore','2020-01-01',150000,'Doctor'),
('Sara','Ahmed','35201-2222222-2','Female','0300-2222222','Karachi','2021-06-15',120000,'Doctor'),
('Joy','Bhatti','35201-3333333-3','Female','0300-3333333','Islamabad','2022-01-01',60000,'Nurse'),
('Bob','Builder','35201-4444444-4','Male','0300-4444444','Multan','2019-05-20',45000,'Admin');
insert into Doctor(Doctor_Id,Dept_Id,Specialization,License_Number,Schedule,Consultation_Fee)values
(1,1,'Cardiologist','PMC-1001','Mon-Fri 09:00-14:00',2000),
(2,2,'Neurologist','PMC-1002','Mon-Fri 14:00-18:00',2500);
insert into Patient(First_Name,Last_Name,DOB,Gender,Blood_Group,Phone,Addresse)values
('Usman','Tariq','1990-05-15','Male','A+','0301-555555','Model Town,Lahore'),
('Fatima','Zahra','1995-08-20','Female','O-','0301-6666666','DHA Lahore'),
('Bilal','Sheikh','1985-12-10','Male','B+','0301-7777777','Gulberg,Lahore');
insert into Room(Room_Id,Dept_Id,Type_Of_Room,Cost_Per_Day,Statuss)values
(101,1,'ICU',15000,'Available'),
(102,1,'Private',8000,'Available'),
(201,2,'Ward',3000,'Occupied');
insert into Medicine(MName,MType,Stock_Quantity,Unit_Price)values
('Panadol','Tablet',100,10),
('Brufen','syrup',50,150),
('Augmentin','Injection',30,450);
insert into Lab_Test(Test_Id,Test_Name,Cost)values
(1,'CBC Blood Test',500),
(2,'MRI Scan',15000),
(3,'X-Ray',1000);

insert into Medical_History(Patient_Id,Condition,Diagnosed_Date,Extra_Details)values
(1,'HyperTension','2023-01-10','Patient has history of the high BP.'),
(2,'Migraine','2023-05-20','Chronic headaches reported.');



insert into Appointment(Patient_Id,Doctor_Id,Appt_Date_Time,Statuss)
values
(1,1,'2025-12-25 10:00:00','Completed'),
(2,2,'2025-12-25 11:30:00','Scheduled'),
(1, 1, GETDATE(), 'Cancelled');


insert into prescription(Appt_Id,Medicine_Id,Dosage)values
(1,1,'1+0+1 (5 Days)');

insert into Admission(Patient_Id,Room_Id,Admit_Date,Discharge_Date)values
(3,201,'2025-12-24',Null);

insert into Lab_Report(Report_Id,Patient_Id,Test_Id,Result_Date,Result_Details)values
(1001,1,1,'2025-12-25','Hemoglobin Levels Normal.');

insert into Bill(Patient_Id,Admission_Id,Total_Amount,Payment_Status,Genrated_Date)values
(3,1,50000,'Pending',GETDATE());



Alter table Patient add Email varchar(50);

update Employee1
set Salary=Salary*1.10
where Role_Type='Doctor';

delete from Appointment
where Statuss='Cancelled';


select P.First_Name as Patient_Name,
E.First_Name as Doctor_Name,
A.Appt_Date_Time,
A.Statuss
from Employee1 E 
inner join Doctor D on E.Employee_Id=D.Doctor_Id 
inner join Appointment A on D.Doctor_Id=A.Doctor_Id 
inner join Patient P on A.Patient_Id=P.Patient_Id;



select
D.Dept_Name,
R.Type_Of_Room,
R.Statuss
from Department2 D 
left join  Room R on D.Dept_Id=R.Dept_Id 





select T.Test_Name,
L.Result_Details
from Lab_Test T right join Lab_Report L
on T.Test_Id=L.Test_Id




SELECT 
    SUM(D.Consultation_Fee) AS Total_Expected_Revenue
FROM Appointment A
JOIN Doctor D ON A.Doctor_Id = D.Doctor_Id
WHERE A.Statuss = 'Scheduled';


SELECT Role_Type, 
count(*) AS Total_Employees
FROM Employee1
GROUP BY Role_Type;




select E.First_Name,
E.Last_Name,
D.Specialization,
D.Consultation_Fee
from Employee1 E join Doctor D
on E.Employee_Id=D.Doctor_Id
where D.Consultation_Fee=(
select max(Consultation_Fee) from Doctor
);





select*from Public_Doctor_Directory;

go
create procedure sp_ShowName @ID int
AS
begin
select First_Name FROM Patient WHERE Patient_Id = @ID;
end
EXEC sp_ShowName 1;