# CareSync: Relational Hospital Management System (HMS) Database

A comprehensive, highly normalized relational database architecture engineered to streamline clinical operations, optimize resource scheduling, ensure data integrity, and handle transactional financial tracking in a modern multi-specialty healthcare facility.

---

## 📊 1. Relational Schema Description (3NF Mapping)

The following schema represents the normalized schema mapping of the system, illustrating the structural integrity rules, primary keys (<u>**Underlined**</u>), and foreign key references mapped explicitly from your SQL DDL.

### 🏢 Department & Employee Infrastructure
* **Department2** (<u>**Dept\_Id**</u>, Dept\_Name, Dept\_Location)
    * *Primary Key:* `Dept_Id` (Identity)
* **Employee1** (<u>**Employee\_Id**</u>, First\_Name, Last\_Name, CNIC, Gender, phone, Addresse, Joining\_Date, Salary, Role\_Type)
    * *Primary Key:* `Employee_Id` (Identity)
    * *Integrity Constraints:* `CNIC` is unique; `Role_Type` explicitly restricted via `CHECK (Role_Type IN ('Doctor', 'Nurse', 'Admin', 'Staff'))`.

### 🩺 Clinical Staff & Patient Demographics
* **Doctor** (<u>**Doctor\_Id**</u>, Dept\_Id, Specialization, License\_Number, Schedule, Consultation\_Fee)
    * *Primary Key:* `Doctor_Id`
    * *Foreign Key 1:* `Doctor_Id` references `Employee1(Employee_Id)` *(Implements 1:1 Specialization/Inheritance)*
    * *Foreign Key 2:* `Dept_Id` references `Department2(Dept_Id)`
* **Patient** (<u>**Patient\_Id**</u>, First\_Name, Last\_Name, DOB, Gender, Blood\_Group, Phone, Addresse, Email)
    * *Primary Key:* `Patient_Id` (Identity)
    * *Note:* Extended post-initialization with an `Alter table` modification adding the `Email` column field.

### 📅 Clinical Records & Encounters
* **Medical\_History** (<u>**History\_Id**</u>, Patient\_Id, Condition, Diagnosed\_Date, Extra\_Details)
    * *Primary Key:* `History_Id` (Identity)
    * *Foreign Key:* `Patient_Id` references `Patient(Patient_Id)`
* **Room** (<u>**Room\_Id**</u>, Dept\_Id, Type\_Of\_Room, Cost\_Per\_Day, Statuss)
    * *Primary Key:* `Room_Id`
    * *Foreign Key:* `Dept_Id` references `Department2(Dept_Id)`
* **Appointment** (<u>**Appt\_Id**</u>, Patient\_Id, Doctor\_Id, Appt\_Date\_Time, Statuss)
    * *Primary Key:* `Appt_Id` (Identity)
    * *Foreign Key 1:* `Patient_Id` references `Patient(Patient_Id)`
    * *Foreign Key 2:* `Doctor_Id` references `Doctor(Doctor_Id)`
* **Admission** (<u>**Admission\_Id**</u>, Patient\_Id, Room\_Id, Admit\_Date, Discharge\_Date)
    * *Primary Key:* `Admission_Id` (Identity)
    * *Foreign Key 1:* `Patient_Id` references `Patient(Patient_Id)`
    * *Foreign Key 2:* `Room_Id` references `Room(Room_Id)`

### 💊 Pharmacy Inventory & Diagnostics
* **Medicine** (<u>**Medicine\_Id**</u>, MName, MType, Stock\_Quantity, Unit\_Price)
    * *Primary Key:* `Medicine_Id` (Identity)
* **Prescription** (<u>**Prescription\_ID**</u>, Appt\_Id, Medicine\_Id, Dosage)
    * *Primary Key:* `Prescription_ID` (Identity)
    * *Foreign Key 1:* `Appt_Id` references `Appointment(Appt_Id)`
    * *Foreign Key 2:* `Medicine_Id` references `Medicine(Medicine_Id)`
* **Lab\_Test** (<u>**Test\_Id**</u>, Test\_Name, Cost)
    * *Primary Key:* `Test_Id`
* **Lab\_Report** (<u>**Report\_Id**</u>, Patient\_Id, Test\_Id, Result\_Date, Result\_Details)
    * *Primary Key:* `Report_Id`
    * *Foreign Key 1:* `Patient_Id` references `Patient(Patient_Id)`
    * *Foreign Key 2:* `Test_Id` references `Lab_Test(Test_Id)`

### 💳 Ledger & Billing Operations
* **Bill** (<u>**Bill\_Id**</u>, Patient\_Id, Admission\_Id, Total\_Amount, Payment\_Status, Genrated\_Date)
    * *Primary Key:* `Bill_Id` (Identity)
    * *Foreign Key 1:* `Patient_Id` references `Patient(Patient_Id)`
    * *Foreign Key 2:* `Admission_Id` references `Admission(Admission_Id)`



---

## ⚡ 3. Programmable Features & Business Optimization

### 📦 Automated Real-Time Inventory Control (Triggers)
* **`ReduceStock` Trigger:** Built on top of the transactional pharmacy layer. The moment an out-patient prescription is generated via an `INSERT` statement on `Prescription`, this automated routine captures the `Medicine_Id` from the virtual `inserted` queue and decrements `Stock_Quantity` by exactly 1 unit, avoiding storage synchronization lag.

### 🔒 Operational Security and Data Masking (Views)
* **`Public_Doctor_Directory`:** Abstracts sensitive employee details away from patient-facing applications. By performing an `INNER JOIN` across `Employee1` and `Doctor`, it securely surfaces critical operational fields like First/Last Name, Specialization, and Consultation Fee parameters while masking confidential data points (CNICs, home addresses, base salaries).

### ⚙️ Encapsulated Functional Interface (Stored Procedures)
* **`sp_ShowName`:** An optimized query interface procedure designed to pull patient matching identifiers efficiently via indexed parameters, accepting `@ID int` to quickly look up data without running verbose raw `SELECT` filters across the network.

---

## 🚀 4. Database Setup & Execution Sequence

To successfully initialize care syncing on a fresh instance of Microsoft SQL Server (MSSQL), clone this repository and compile the provided scripts using the specified ordering sequence:

### Step 1: Clone Project Files
```bash
git clone [https://github.com/mhamzashahidw/Hospital-Management-System-DB.git](https://github.com/mhamzashahidw/Hospital-Management-System-DB.git)
cd CareSync-HMS-Database
