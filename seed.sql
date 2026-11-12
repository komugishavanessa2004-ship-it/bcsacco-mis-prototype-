-- Sample data for the Tukolerewamu SACCO MIS (run AFTER schema.sql).
-- In phpMyAdmin: select the "sacco" database > Import (or SQL tab) > run this file.
-- Safe to re-run: it clears the tables first.
-- Sample logins: password for every user below is  sacco123

USE sacco;

-- Clear children first, then parents. DELETE (not TRUNCATE) is allowed on
-- tables that other tables reference, so this works even when phpMyAdmin
-- has "Enable foreign key checks" ticked.
DELETE FROM audit_log;
DELETE FROM repayment;
DELETE FROM guarantor;
DELETE FROM savings_transaction;
DELETE FROM loan;
DELETE FROM staff_user;
DELETE FROM member;

-- Restart auto-increment counters so ids start from 1 again
ALTER TABLE audit_log AUTO_INCREMENT = 1;
ALTER TABLE repayment AUTO_INCREMENT = 1;
ALTER TABLE guarantor AUTO_INCREMENT = 1;
ALTER TABLE savings_transaction AUTO_INCREMENT = 1;
ALTER TABLE loan AUTO_INCREMENT = 1;
ALTER TABLE staff_user AUTO_INCREMENT = 1;

-- MEMBERS
INSERT INTO member (member_id, full_name, phone, village, join_date) VALUES
('M001', 'Nakato Sarah',        '0772100201', 'Seeta',     '2024-02-10'),
('M002', 'Ssemwogerere Joseph', '0701220332', 'Nakisunga', '2024-03-18'),
('M003', 'Namuli Grace',        '0753410118', 'Goma',      '2024-06-05'),
('M004', 'Okello Peter',        '0782905447', 'Ngogwe',    '2023-11-21'),
('M005', 'Babirye Ruth',        '0775330921', 'Kasawo',    '2025-01-14'),
('M006', 'Kato Moses',          '0706118654', 'Seeta',     '2024-09-02');

-- USERS (staff and one member login)
INSERT INTO staff_user (user_id, username, password_hash, role, member_id) VALUES
(1, 'teller1',   '$2y$10$jST1CzA6q/R/MgP5vCZxpeAi46ieqT22xnb0xQY4XUOnpMglMTBZ.', 'teller',        NULL),
(2, 'officer1',  '$2y$10$jST1CzA6q/R/MgP5vCZxpeAi46ieqT22xnb0xQY4XUOnpMglMTBZ.', 'loans_officer', NULL),
(3, 'accountant1','$2y$10$jST1CzA6q/R/MgP5vCZxpeAi46ieqT22xnb0xQY4XUOnpMglMTBZ.', 'accountant',   NULL),
(4, 'manager1',  '$2y$10$jST1CzA6q/R/MgP5vCZxpeAi46ieqT22xnb0xQY4XUOnpMglMTBZ.', 'manager',       NULL),
(5, 'nakato',    '$2y$10$jST1CzA6q/R/MgP5vCZxpeAi46ieqT22xnb0xQY4XUOnpMglMTBZ.', 'member',        'M001');

-- SAVINGS TRANSACTIONS (a member's balance = deposits minus withdrawals)
INSERT INTO savings_transaction (member_id, txn_type, amount, txn_date, recorded_by) VALUES
('M001', 'deposit',    600000, '2026-06-03 09:15:00', 1),
('M001', 'deposit',    300000, '2026-09-12 10:02:00', 1),
('M001', 'withdrawal',  50000, '2026-10-05 14:40:00', 1),
('M002', 'deposit',   1000000, '2026-05-20 11:30:00', 1),
('M002', 'deposit',    500000, '2026-10-01 08:55:00', 1),
('M003', 'deposit',    420000, '2026-07-08 13:10:00', 1),
('M004', 'deposit',   1500000, '2026-04-15 09:00:00', 1),
('M004', 'deposit',    600000, '2026-09-28 15:20:00', 1),
('M005', 'deposit',    300000, '2026-08-19 10:45:00', 1),
('M006', 'deposit',   1000000, '2026-03-11 12:00:00', 1),
('M006', 'withdrawal',  30000, '2026-08-02 16:05:00', 1);

-- LOANS (next_due is relative to today, so overdue loans always show as overdue)
INSERT INTO loan (loan_id, member_id, amount, interest_rate, months, purpose, status, next_due, approved_by) VALUES
('L001', 'M001', 1200000, 12.00, 6,  'Seed and fertiliser', 'approved', DATE_SUB(CURDATE(), INTERVAL 12 DAY), 4),
('L002', 'M002', 2000000, 12.00, 12, 'Dairy cows',          'approved', DATE_ADD(CURDATE(), INTERVAL 9 DAY),  4),
('L003', 'M004', 3000000, 12.00, 10, 'Maize mill',          'approved', DATE_SUB(CURDATE(), INTERVAL 45 DAY), 4),
('L004', 'M003',  600000, 12.00, 4,  'School fees',         'pending',  NULL,                                 NULL),
('L005', 'M006',  800000, 12.00, 5,  'Goat rearing',        'closed',   NULL,                                 4);

-- GUARANTORS
INSERT INTO guarantor (loan_id, member_id) VALUES
('L001', 'M002'), ('L001', 'M006'),
('L002', 'M004'),
('L003', 'M002'),
('L004', 'M001'),
('L005', 'M001');

-- REPAYMENTS
INSERT INTO repayment (loan_id, amount, channel, reference, paid_on, recorded_by) VALUES
('L001', 200000, 'cash',         NULL,          '2026-07-10 10:00:00', 2),
('L001', 200000, 'mtn_momo',     'MP261012A1B2', '2026-08-11 09:30:00', 2),
('L002', 300000, 'airtel_money', 'AM260915C3D4', '2026-09-15 11:15:00', 2),
('L002', 300000, 'cash',         NULL,          '2026-10-14 14:00:00', 2),
('L003', 450000, 'cash',         NULL,          '2026-06-20 10:20:00', 2),
('L003', 450000, 'mtn_momo',     'MP260721E5F6', '2026-07-22 16:45:00', 2),
('L005', 420000, 'cash',         NULL,          '2026-07-01 09:05:00', 2),
('L005', 420000, 'airtel_money', 'AM260801G7H8', '2026-08-01 12:30:00', 2);

-- AUDIT LOG
INSERT INTO audit_log (user_id, action, logged_at) VALUES
(1, 'Registered member M006',                     '2024-09-02 09:00:00'),
(2, 'Application L003 submitted for M004',        '2026-05-28 10:10:00'),
(4, 'Approved loan L003',                         '2026-06-02 11:00:00'),
(4, 'Approved loan L001',                         '2026-06-25 09:45:00'),
(2, 'Repayment 200000 on L001 via cash',          '2026-07-10 10:00:00'),
(2, 'Application L004 submitted for M003',        '2026-11-02 13:25:00');

-- ============================================================
-- QUERIES TO SHOW THE INFORMATION (run these in the SQL tab)
-- ============================================================

-- 1. Savings balance per member
SELECT m.member_id, m.full_name,
       SUM(CASE WHEN s.txn_type='deposit' THEN s.amount ELSE -s.amount END) AS savings_balance
FROM member m LEFT JOIN savings_transaction s ON s.member_id = m.member_id
GROUP BY m.member_id, m.full_name;

-- 2. Loan register with amount paid, balance and days overdue
SELECT l.loan_id, m.full_name, l.purpose, l.status,
       ROUND(l.amount*(1+l.interest_rate/100*l.months/12)) AS total_repayable,
       COALESCE(SUM(r.amount),0) AS paid,
       ROUND(l.amount*(1+l.interest_rate/100*l.months/12) - COALESCE(SUM(r.amount),0)) AS balance,
       CASE WHEN l.status='approved' AND l.next_due < CURDATE()
            THEN DATEDIFF(CURDATE(), l.next_due) ELSE 0 END AS days_overdue
FROM loan l
JOIN member m ON m.member_id = l.member_id
LEFT JOIN repayment r ON r.loan_id = l.loan_id
GROUP BY l.loan_id, m.full_name, l.purpose, l.status, l.amount, l.interest_rate, l.months, l.next_due;

-- 3. Overdue accounts needing follow-up
SELECT l.loan_id, m.full_name, m.phone, DATEDIFF(CURDATE(), l.next_due) AS days_overdue
FROM loan l JOIN member m ON m.member_id = l.member_id
WHERE l.status='approved' AND l.next_due < CURDATE()
ORDER BY days_overdue DESC;

-- 4. Recent audit trail
SELECT a.logged_at, u.username, u.role, a.action
FROM audit_log a JOIN staff_user u ON u.user_id = a.user_id
ORDER BY a.logged_at DESC;
