-- Reference schema for the production version of the SACCO MIS (matches the ERD).
CREATE TABLE member (
  member_id   VARCHAR(10) PRIMARY KEY,
  full_name   VARCHAR(100) NOT NULL,
  phone       VARCHAR(20)  NOT NULL,
  village     VARCHAR(60),
  join_date   DATE NOT NULL
);
CREATE TABLE staff_user (
  user_id     INT PRIMARY KEY AUTO_INCREMENT,
  username    VARCHAR(40) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role        ENUM('teller','loans_officer','accountant','manager','board','member') NOT NULL,
  member_id   VARCHAR(10) NULL,
  FOREIGN KEY (member_id) REFERENCES member(member_id)
);
CREATE TABLE savings_transaction (
  txn_id      INT PRIMARY KEY AUTO_INCREMENT,
  member_id   VARCHAR(10) NOT NULL,
  txn_type    ENUM('deposit','withdrawal') NOT NULL,
  amount      DECIMAL(12,2) NOT NULL CHECK (amount > 0),
  txn_date    DATETIME NOT NULL,
  recorded_by INT NOT NULL,
  FOREIGN KEY (member_id)   REFERENCES member(member_id),
  FOREIGN KEY (recorded_by) REFERENCES staff_user(user_id)
);
CREATE TABLE loan (
  loan_id     VARCHAR(10) PRIMARY KEY,
  member_id   VARCHAR(10) NOT NULL,
  amount      DECIMAL(12,2) NOT NULL,
  interest_rate DECIMAL(5,2) NOT NULL,
  months      INT NOT NULL,
  purpose     VARCHAR(120),
  status      ENUM('pending','approved','rejected','closed') NOT NULL,
  next_due    DATE,
  approved_by INT NULL,
  FOREIGN KEY (member_id)   REFERENCES member(member_id),
  FOREIGN KEY (approved_by) REFERENCES staff_user(user_id)
);
CREATE TABLE guarantor (
  loan_id     VARCHAR(10),
  member_id   VARCHAR(10),
  PRIMARY KEY (loan_id, member_id),
  FOREIGN KEY (loan_id)   REFERENCES loan(loan_id),
  FOREIGN KEY (member_id) REFERENCES member(member_id)
);
CREATE TABLE repayment (
  repayment_id INT PRIMARY KEY AUTO_INCREMENT,
  loan_id     VARCHAR(10) NOT NULL,
  amount      DECIMAL(12,2) NOT NULL,
  channel     ENUM('cash','mtn_momo','airtel_money') NOT NULL,
  reference   VARCHAR(40),
  paid_on     DATETIME NOT NULL,
  recorded_by INT NOT NULL,
  FOREIGN KEY (loan_id)     REFERENCES loan(loan_id),
  FOREIGN KEY (recorded_by) REFERENCES staff_user(user_id)
);
CREATE TABLE audit_log (
  log_id      INT PRIMARY KEY AUTO_INCREMENT,
  user_id     INT NOT NULL,
  action      VARCHAR(200) NOT NULL,
  logged_at   DATETIME NOT NULL,
  FOREIGN KEY (user_id) REFERENCES staff_user(user_id)
);
