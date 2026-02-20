
SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for accounts_receivable
-- ----------------------------
DROP TABLE IF EXISTS `accounts_receivable`;
CREATE TABLE `accounts_receivable` (
  `ar_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_number` varchar(50) NOT NULL,
  `coa_id` int(11) NOT NULL,
  `pttype` varchar(10) DEFAULT NULL,
  `hn` varchar(20) DEFAULT NULL,
  `vn` varchar(20) DEFAULT NULL,
  `cid` varchar(13) DEFAULT NULL,
  `an` varchar(20) DEFAULT NULL,
  `diag_list` varchar(200) DEFAULT NULL,
  `patient_name` varchar(200) DEFAULT NULL,
  `service_date` date DEFAULT NULL,
  `discharge_date` date DEFAULT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `ar_amount` decimal(15,2) NOT NULL,
  `original_ar_amount` decimal(15,2) DEFAULT NULL COMMENT 'ยอดลูกหนี้ต้นฉบับ (สำรองข้อมูล)',
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `balance` decimal(15,2) NOT NULL,
  `payment_source` enum('claim_rep','claim_statement','cash','transfer_insurance','transfer_compulsory','transfer_other','write_off','other') DEFAULT 'claim_rep' COMMENT 'ช่องทางรับชดเชย',
  `payment_source_note` text DEFAULT NULL COMMENT 'หมายเหตุเกี่ยวกับช่องทางรับชดเชย',
  `status` enum('pending','approved','adjusted','paid','cancelled') DEFAULT 'pending',
  `submission_status` enum('draft','submitted','recorded','adjusted','cancelled') DEFAULT 'draft' COMMENT 'สถานะการส่ง: draft=ร่าง, submitted=ส่งแล้ว, recorded=บันทึกแล้ว, adjusted=ปรับปรุง, cancelled=ยกเลิก',
  `rep_number` varchar(50) DEFAULT NULL,
  `claim_amount` decimal(15,2) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `recorded_by` int(11) DEFAULT NULL COMMENT 'ผู้บันทึกเข้าบัญชี (user_id)',
  `approved_at` timestamp NULL DEFAULT NULL,
  `recorded_at` datetime DEFAULT NULL COMMENT 'วันที่บันทึกเข้าบัญชี',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `rep_approved_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดที่ได้จาก REP',
  `statement_approved_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดที่ได้จาก Statement',
  `total_approved_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดรวมที่ได้รับชดเชย',
  `statement_matched_at` timestamp NULL DEFAULT NULL COMMENT 'วันที่จับคู่กับ statement',
  `rep_matched_at` date DEFAULT NULL,
  `updated_by` int(11) DEFAULT NULL,
  PRIMARY KEY (`ar_id`),
  KEY `idx_ar_status` (`status`),
  KEY `idx_ar_pttype` (`pttype`),
  KEY `idx_ar_date` (`service_date`),
  KEY `idx_ar_number` (`ar_number`),
  KEY `ar_number` (`ar_number`) USING BTREE,
  KEY `idx_submission_status` (`submission_status`),
  KEY `idx_recorded_at` (`recorded_at`),
  KEY `fk_ar_coa` (`coa_id`),
  KEY `fk_ar_created_by` (`created_by`),
  KEY `fk_ar_approved_by` (`approved_by`),
  KEY `fk_ar_recorded_by` (`recorded_by`),
  KEY `idx_total_approved` (`total_approved_amount`),
  KEY `idx_statement_match` (`hn`,`vn`,`an`,`cid`,`status`),
  KEY `idx_payment_source` (`payment_source`),
  KEY `idx_match_with_source` (`hn`,`vn`,`an`,`service_date`,`payment_source`,`status`),
  KEY `idx_vn` (`vn`),
  CONSTRAINT `fk_ar_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_coa` FOREIGN KEY (`coa_id`) REFERENCES `chart_of_accounts` (`coa_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_recorded_by` FOREIGN KEY (`recorded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of accounts_receivable
-- ----------------------------

-- ----------------------------
-- Table structure for account_std
-- ----------------------------
DROP TABLE IF EXISTS `account_std`;
CREATE TABLE `account_std` (
  `id` varchar(255) DEFAULT NULL,
  `acc_code` varchar(255) DEFAULT NULL,
  `acc_name` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Records of account_std
-- ----------------------------
INSERT INTO `account_std` VALUES ('1', '1102050101.103', 'ลูกหนี้ค่าตรวจสุขภาพหน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('2', '1102050101.106', 'ลูกหนี้ค่ารักษา-หน่วยงานภาครัฐอื่น');
INSERT INTO `account_std` VALUES ('3', '1102050101.107', 'ลูกหนี้ค่ารักษา-เบิกต้นสังกัด OP');
INSERT INTO `account_std` VALUES ('5', '1102050101.201', 'ลูกหนี้ค่ารักษา OP-UC ใน CUP');
INSERT INTO `account_std` VALUES ('7', '1102050101.203', 'ลูกหนี้ค่ารักษา OP-UC นอก CUP ในจังหวัดสังกัด สธ.');
INSERT INTO `account_std` VALUES ('9', '1102050101.205', 'ลูกหนี้ค่ารักษา OP-UC นอก CUP ต่างจังหวัดสังกัด สธ.');
INSERT INTO `account_std` VALUES ('11', '1102050101.207', 'ลูกหนี้ค่ารักษา UC-OPD ต่างสังกัด สป.');
INSERT INTO `account_std` VALUES ('13', '1102050101.216', 'ลูกหนี้ค่ารักษา UC OP บริการเฉพาะ');
INSERT INTO `account_std` VALUES ('15', '1102050101.218', 'ลูกหนี้ค่ารักษา UC OP - HC');
INSERT INTO `account_std` VALUES ('17', '1102050101.220', 'ลูกหนี้ค่ารักษา UC OP - DMI');
INSERT INTO `account_std` VALUES ('19', '1102050101.301', 'ลูกหนี้ค่ารักษาประกันสังคม OP-เครือข่าย');
INSERT INTO `account_std` VALUES ('21', '1102050101.303', 'ลูกหนี้ค่ารักษาประกันสังคม OP-นอกเครือข่าย');
INSERT INTO `account_std` VALUES ('23', '1102050101.305', 'ลูกหนี้ค่ารักษาประกันสังคม OP-ต่างสังกัด สป.');
INSERT INTO `account_std` VALUES ('25', '1102050101.307', 'ลูกหนี้ค่ารักษาประกันสังคม-กองทุนทดแทน');
INSERT INTO `account_std` VALUES ('26', '1102050101.308', 'ลูกหนี้ค่ารักษาประกันสังคม 72 ชั่วโมงแรก');
INSERT INTO `account_std` VALUES ('27', '1102050101.309', 'ลูกหนี้ค่ารักษาประกันสังคม-ค่าใช้จ่ายสูง/อุบัติเหตุ/ฉุกเฉิน OP');
INSERT INTO `account_std` VALUES ('29', '1102050101.401', 'ลูกหนี้ค่ารักษา-เบิกจ่ายตรงกรมบัญชีกลาง OP');
INSERT INTO `account_std` VALUES ('31', '1102050101.501', 'ลูกหนี้ค่ารักษา-แรงงานต่างด้าว OP');
INSERT INTO `account_std` VALUES ('33', '1102050101.503', 'ลูกหนี้ค่ารักษา-แรงงานต่างด้าว OP นอก CUP');
INSERT INTO `account_std` VALUES ('35', '1102050101.505', 'ลูกหนี้ค่ารักษา-แรงงานต่างด้าว ค่าใช้จ่ายสูง/อุบัติเหตุ/ฉุกเฉิน');
INSERT INTO `account_std` VALUES ('36', '1102050101.701', 'ลูกหนี้ค่ารักษา-บุคคลที่มีปัญหาสถานะและสิทธิ OP ใน CUP');
INSERT INTO `account_std` VALUES ('37', '1102050101.702', 'ลูกหนี้ค่ารักษา-บุคคลที่มีปัญหาสถานะและสิทธิ OP นอก CUP');
INSERT INTO `account_std` VALUES ('38', '1102050101.703', 'ลูกหนี้ค่ารักษา-บุคคลที่มีปัญหาสถานะสิทธิ-เบิกจากส่วนกลาง');
INSERT INTO `account_std` VALUES ('41', '1102050101.801', 'ลูกหนี้ค่ารักษา-เบิกจ่ายตรง อปท.OP');
INSERT INTO `account_std` VALUES ('43', '1102050102.106', 'ลูกหนี้ค่ารักษา-ชำระเงิน OP');
INSERT INTO `account_std` VALUES ('47', '1102050102.602', 'ลูกหนี้ค่ารักษา-พรบ.รถ OP');
INSERT INTO `account_std` VALUES ('49', '1102050194.203', 'ลูกหนี้ค่ารักษาด้านการสร้างเสริมสุขภาพและป้องกันโรค(P&P)');
INSERT INTO `account_std` VALUES ('50', '1102050194.803', 'ลูกหนี้ค่ารักษา-เบิกจ่ายตรงอปท. รูปแบบพิเศษ OP');
INSERT INTO `account_std` VALUES ('45', '1102050102.301', 'ลูกหนี้ประกันสังคม OP-นอกเครือข่าย ต่างสังกัด สปสธ.');
INSERT INTO `account_std` VALUES ('4', '1102050101.108', 'ลูกหนี้ค่ารักษา-เบิกต้นสังกัด IP');
INSERT INTO `account_std` VALUES ('6', '1102050101.202', 'ลูกหนี้ค่ารักษา IP-UC');
INSERT INTO `account_std` VALUES ('8', '1102050101.204', 'ลูกหนี้ค่ารักษา IP-UC นอก CUP ในจังหวัดสังกัด สธ.');
INSERT INTO `account_std` VALUES ('10', '1102050101.206', 'ลูกหนี้ค่ารักษา IP-UC นอก CUP ต่างจังหวัดสังกัด สธ.');
INSERT INTO `account_std` VALUES ('12', '1102050101.208', 'ลูกหนี้ค่ารักษา IP-UC ต่างสังกัด สป.');
INSERT INTO `account_std` VALUES ('14', '1102050101.217', 'ลูกหนี้ค่ารักษา UC IP บริการเฉพาะ');
INSERT INTO `account_std` VALUES ('16', '1102050101.219', 'ลูกหนี้ค่ารักษา UC IP - HC');
INSERT INTO `account_std` VALUES ('18', '1102050101.221', 'ลูกหนี้ค่ารักษา UC IP - DMI');
INSERT INTO `account_std` VALUES ('20', '1102050101.302', 'ลูกหนี้ค่ารักษาประกันสังคม IP-เครือข่าย');
INSERT INTO `account_std` VALUES ('22', '1102050101.304', 'ลูกหนี้ค่ารักษาประกันสังคม IP-นอกเครือข่าย');
INSERT INTO `account_std` VALUES ('24', '1102050101.306', 'ลูกหนี้ค่ารักษาประกันสังคม IP-ต่างสังกัด สป.');
INSERT INTO `account_std` VALUES ('28', '1102050101.310', 'ลูกหนี้ค่ารักษาประกันสังคม-ค่าใช้จ่ายสูง/อุบัติเหตุ/ฉุกเฉิน IP');
INSERT INTO `account_std` VALUES ('30', '1102050101.402', 'ลูกหนี้ค่ารักษา-เบิกจ่ายตรงกรมบัญชีกลาง IP');
INSERT INTO `account_std` VALUES ('32', '1102050101.502', 'ลูกหนี้ค่ารักษา-แรงงานต่างด้าว IP');
INSERT INTO `account_std` VALUES ('34', '1102050101.504', 'ลูกหนี้ค่ารักษา-แรงงานต่างด้าว IP นอก CUP');
INSERT INTO `account_std` VALUES ('39', '1102050101.704', 'ลูกหนี้ค่ารักษา-บุคคลที่มีปัญหาสถานะและสิทธิ IPD นอก CUP ในจังหวัด');
INSERT INTO `account_std` VALUES ('40', '1102050101.705', 'ลูกหนี้ค่ารักษา-บุคคลที่มีปัญหาสถานะและสิทธิ IPD นอก CUP ต่างจังหวัด');
INSERT INTO `account_std` VALUES ('42', '1102050101.802', 'ลูกหนี้ค่ารักษา-เบิกจ่ายตรง อปท.IP');
INSERT INTO `account_std` VALUES ('44', '1102050102.107', 'ลูกหนี้ค่ารักษา-ชำระเงิน IP');
INSERT INTO `account_std` VALUES ('48', '1102050102.603', 'ลูกหนี้ค่ารักษา-พรบ.รถ IP');
INSERT INTO `account_std` VALUES ('51', '1102050194.804', 'ลูกหนี้ค่ารักษา-เบิกจ่ายตรงอปท. รูปแบบพิเศษ IP');
INSERT INTO `account_std` VALUES ('46', '1102050102.302', 'ลูกหนี้ประกันสังคม IP-นอกเครือข่าย ต่างสังกัด สปสธ.');
INSERT INTO `account_std` VALUES ('10', '1101010101.101', 'เงินสด');
INSERT INTO `account_std` VALUES ('11', '1101010104.101', 'เงินทดรองราชการ');
INSERT INTO `account_std` VALUES ('12', '1101010112.101', 'บัญชีพักเงินนำส่ง');
INSERT INTO `account_std` VALUES ('13', '1101010113.101', 'พักรอ Clearing');
INSERT INTO `account_std` VALUES ('14', '1101020501.101', 'เงินฝากคลัง - หน่วยเบิกจ่าย');
INSERT INTO `account_std` VALUES ('15', '1101020501.103', 'เงินฝากคลัง - ที่มีวัตถุประสงค์เฉพาะ');
INSERT INTO `account_std` VALUES ('16', '1101020501.104', 'เงินฝากคลัง - ที่มีวัตถุประสงค์เฉพาะ (เงินบริจาค)');
INSERT INTO `account_std` VALUES ('17', '1101020501.201', 'เงินฝากคลัง - ที่มีวัตถุประสงค์เฉพาะ งบลงทุน UC');
INSERT INTO `account_std` VALUES ('18', '1101020504.101', 'เงินฝากหน่วยเบิกจ่าย-ฝากคลัง');
INSERT INTO `account_std` VALUES ('19', '1101020601.101', 'เงินฝากธนาคารเพื่อนำส่งเงินรายได้แผ่นดิน');
INSERT INTO `account_std` VALUES ('20', '1101020603.101', 'เงินฝากธนาคาร - ในงบประมาณ');
INSERT INTO `account_std` VALUES ('21', '1101020604.101', 'เงินฝากธนาคาร - นอกงบประมาณ');
INSERT INTO `account_std` VALUES ('22', '1101020605.101', 'เงินฝากธนาคารรับจากคลัง (เงินกู้)');
INSERT INTO `account_std` VALUES ('23', '1101020606.101', 'เงินฝากธนาคารรายบัญชีเพื่อนำส่งคลัง');
INSERT INTO `account_std` VALUES ('24', '1101030101.101', 'เงินฝากธนาคาร - นอกงบประมาณ กระแสรายวัน');
INSERT INTO `account_std` VALUES ('25', '1101030101.102', 'เงินฝากธนาคาร- นอกงบประมาณ รอการจัดสรร กระแสรายวัน');
INSERT INTO `account_std` VALUES ('26', '1101030101.103', 'เงินฝากธนาคาร - นอกงบประมาณที่มีวัตถุประสงค์เฉพาะกระแสรายวัน');
INSERT INTO `account_std` VALUES ('27', '1101030101.104', 'เงินฝากธนาคาร-นอกงบประมาณที่มีวัตถุประสงค์เฉพาะ กระแสรายวัน (งบลงทุน UC)');
INSERT INTO `account_std` VALUES ('28', '1101030102.101', 'เงินฝากธนาคาร - นอกงบประมาณ ออมทรัพย์');
INSERT INTO `account_std` VALUES ('29', '1101030102.102', 'เงินฝากธนาคาร - นอกงบประมาณรอการจัดสรรออมทรัพย์');
INSERT INTO `account_std` VALUES ('30', '1101030102.103', 'เงินฝากธนาคาร - นอกงบประมาณที่มีวัตถุประสงค์เฉพาะออมทรัพย์');
INSERT INTO `account_std` VALUES ('31', '1101030102.104', 'เงินฝากธนาคาร - นอกงบประมาณที่มีวัตถุประสงค์เฉพาะ ออมทรัพย์ (งบลงทุน UC)');
INSERT INTO `account_std` VALUES ('32', '1101030102.105', 'เงินฝากธนาคาร - นอกงบประมาณที่มีวัตถุประสงค์เฉพาะออมทรัพย์');
INSERT INTO `account_std` VALUES ('33', '1102010101.101', 'ลูกหนี้เงินยืมในงบประมาณ');
INSERT INTO `account_std` VALUES ('34', '1102010102.101', 'ลูกหนี้เงินยืมนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('35', '1102010108.101', 'ลูกหนี้เงินยืม - เงินบำรุง');
INSERT INTO `account_std` VALUES ('36', '1102050101.102', 'ลูกหนี้ค่าสิ่งส่งตรวจหน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('37', '1102050101.104', 'ลูกหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('38', '1102050101.105', 'ลูกหนี้ค่าสินค้า หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('39', '1102050101.109', 'ลูกหนี้ - ระบบปฏิบัติการฉุกเฉิน');
INSERT INTO `account_std` VALUES ('40', '1102050101.209', 'ลูกหนี้ค่ารักษาด้านการสร้างเสริมสุขภาพและป้องกันโรค (P&P)');
INSERT INTO `account_std` VALUES ('41', '1102050101.222', 'ลูกหนี้ค่ารักษา OP - Refer');
INSERT INTO `account_std` VALUES ('42', '1102050101.223', 'ลูกหนี้ค่าบริการสาธารณสุขสำหรับโรคคิดเชื้อไวรัวโคโลนาOP');
INSERT INTO `account_std` VALUES ('43', '1102050101.224', 'ลูกหนี้ค่าบริการสาธารณสุขสำหรับโรคคิดเชื้อไวรัวโคโลนา IP');
INSERT INTO `account_std` VALUES ('44', '1102050101.506', 'ลูกหนี้ค่ารักษา - คนต่างด้าวและแรงงานต่างด้าวเบิกจากส่วนกลาง IP');
INSERT INTO `account_std` VALUES ('45', '1102050102.102', 'ลูกหนี้ค่าสิ่งส่งตรวจบุคคลภายนอก');
INSERT INTO `account_std` VALUES ('46', '1102050102.103', 'ลูกหนี้ค่าตรวจสุขภาพบุคคล ภายนอก');
INSERT INTO `account_std` VALUES ('47', '1102050102.104', 'ลูกหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('48', '1102050102.105', 'ลูกหนี้ค่าสินค้า บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('49', '1102050102.108', 'ลูกหนี้ค่ารักษา - เบิกต้นสังกัด OP');
INSERT INTO `account_std` VALUES ('50', '1102050102.109', 'ลูกหนี้ค่ารักษา - เบิกต้นสังกัด IP');
INSERT INTO `account_std` VALUES ('51', '1102050102.110', 'ลูกหนี้ค่ารักษา - เบิกจ่ายตรงหน่วยงานอื่น OP');
INSERT INTO `account_std` VALUES ('52', '1102050102.111', 'ลูกหนี้ค่ารักษา - เบิกจ่ายตรงหน่วยงานอื่น IP');
INSERT INTO `account_std` VALUES ('53', '1102050102.201', 'ลูกหนี้ค่ารักษา UC - OP นอกสังกัด สธ.');
INSERT INTO `account_std` VALUES ('54', '1102050102.801', 'ลูกหนี้ค่ารักษา - เบิกจ่ายตรง อปท. OP');
INSERT INTO `account_std` VALUES ('55', '1102050102.802', 'ลูกหนี้ค่ารักษา - เบิกจ่ายตรง อปท. IP');
INSERT INTO `account_std` VALUES ('56', '1102050102.803', 'ลูกหนี้ค่ารักษา - เบิกจ่ายตรง อปท.รูปแบบพิเศษ OP');
INSERT INTO `account_std` VALUES ('57', '1102050102.804', 'ลูกหนี้ค่ารักษา - เบิกจ่ายตรงอปท.รูปแบบพิเศษ IP');
INSERT INTO `account_std` VALUES ('58', '1102050106.106', 'รายได้ค้างรับ - หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('59', '1102050107.103', 'รายได้ค้างรับ - บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('60', '1102050107.104', 'รายได้จากงบประมาณค้างรับ (หน่วยงานย่อย)');
INSERT INTO `account_std` VALUES ('61', '1102050107.105', 'รายได้ค้างรับส่วนต่างค่ารักษาที่ต่ำกว่า OP - Non UC');
INSERT INTO `account_std` VALUES ('62', '1102050107.106', 'รายได้ค้างรับส่วนต่างค่ารักษาที่ต่ำกว่า IP - Non UC');
INSERT INTO `account_std` VALUES ('63', '1102050107.201', 'รายได้ค้างรับส่วนต่างค่ารักษาที่ต่ำกว่า OP - UC');
INSERT INTO `account_std` VALUES ('64', '1102050107.202', 'รายได้ค้างรับส่วนต่างค่ารักษาที่ต่ำกว่า IP - UC');
INSERT INTO `account_std` VALUES ('65', '1102050123.103', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่าสิ่งส่งตรวจหน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('66', '1102050123.105', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('67', '1102050123.106', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่าสินค้าหน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('68', '1102050123.114', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่ารักษาชำระเงิน OP');
INSERT INTO `account_std` VALUES ('69', '1102050123.115', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่ารักษาชำระเงิน IP');
INSERT INTO `account_std` VALUES ('70', '1102050123.203', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่ารักษา UC- OP นอก CUP (ในจังหวัด)');
INSERT INTO `account_std` VALUES ('71', '1102050123.205', 'ค่าเผื่อหนี้สงสัยจะสูญ - ลูกหนี้ค่ารักษา UC- OP นอก CUP (ต่างจังหวัด)');
INSERT INTO `account_std` VALUES ('72', '1102050124.101', 'ค้างรับจากกรมบัญชีกลาง - หน่วยเบิกจ่าย');
INSERT INTO `account_std` VALUES ('73', '1102050194.101', 'ลูกหนี้อื่น - หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('74', '1102050194.102', 'ลูกหนี้อื่น-บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('75', '1103020111.101', 'เงินจ่ายล่วงหน้า');
INSERT INTO `account_std` VALUES ('76', '1104010101.101', 'เงินฝากประจำ');
INSERT INTO `account_std` VALUES ('77', '1105010101.101', 'วัตถุดิบ');
INSERT INTO `account_std` VALUES ('78', '1105010102.101', 'สินค้าระหว่างผลิต');
INSERT INTO `account_std` VALUES ('79', '1105010103.101', 'สินค้าสำเร็จรูป');
INSERT INTO `account_std` VALUES ('80', '1105010103.102', 'ยา');
INSERT INTO `account_std` VALUES ('81', '1105010103.103', 'วัสดุเภสัชกรรม');
INSERT INTO `account_std` VALUES ('82', '1105010103.104', 'วัสดุการแพทย์ทั่วไป');
INSERT INTO `account_std` VALUES ('83', '1105010103.105', 'วัสดุวิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('84', '1105010103.106', 'วัสดุเอกซเรย์');
INSERT INTO `account_std` VALUES ('85', '1105010103.107', 'วัสดุทันตกรรม');
INSERT INTO `account_std` VALUES ('86', '1105010103.108', 'วัสดุบริโภค');
INSERT INTO `account_std` VALUES ('87', '1105010103.109', 'วัสดุเครื่องแต่งกาย');
INSERT INTO `account_std` VALUES ('88', '1105010105.105', 'วัสดุสำนักงาน');
INSERT INTO `account_std` VALUES ('89', '1105010105.106', 'วัสดุยานพาหนะและขนส่ง');
INSERT INTO `account_std` VALUES ('90', '1105010105.107', 'วัสดุเชื้อเพลิงและหล่อลื่น');
INSERT INTO `account_std` VALUES ('91', '1105010105.108', 'วัสดุไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('92', '1105010105.109', 'วัสดุโฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('93', '1105010105.110', 'วัสดุคอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('94', '1105010105.111', 'วัสดุงานบ้านงานครัว');
INSERT INTO `account_std` VALUES ('95', '1105010105.114', 'วัสดุก่อสร้าง');
INSERT INTO `account_std` VALUES ('96', '1105010105.115', 'วัสดุอื่น');
INSERT INTO `account_std` VALUES ('97', '1106010103.103', 'ค่าใช้จ่ายจ่ายล่วงหน้า');
INSERT INTO `account_std` VALUES ('98', '1106010103.201', 'เงินกองทุน UC จ่ายล่วงหน้า');
INSERT INTO `account_std` VALUES ('99', '1106010112.101', 'ใบสำคัญรองจ่าย');
INSERT INTO `account_std` VALUES ('100', '1106010199.101', 'สินทรัพย์หมุนเวียนอื่น');
INSERT INTO `account_std` VALUES ('101', '1201020101.101', 'เงินให้ยืมระยะยาว-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('102', '1201050198.101', 'ลูกหนี้อื่นระยะยาว');
INSERT INTO `account_std` VALUES ('103', '1204020103.101', 'ที่ดินราชพัสดุรอโอน');
INSERT INTO `account_std` VALUES ('104', '1205010101.101', 'อาคารเพื่อการพักอาศัย');
INSERT INTO `account_std` VALUES ('105', '1205010102.101', 'พักอาคารเพื่อการพักอาศัย');
INSERT INTO `account_std` VALUES ('106', '1205010103.101', 'ค่าเสื่อมราคาสะสม - อาคารเพื่อการพักอาศัย');
INSERT INTO `account_std` VALUES ('107', '1205020101.101', 'อาคารสำนักงาน');
INSERT INTO `account_std` VALUES ('108', '1205020102.101', 'พักอาคารสำนักงาน');
INSERT INTO `account_std` VALUES ('109', '1205020103.101', 'ค่าเสื่อมราคาสะสม - อาคารสำนักงาน');
INSERT INTO `account_std` VALUES ('110', '1205030101.101', 'อาคารเพื่อประโยชน์อื่น');
INSERT INTO `account_std` VALUES ('111', '1205030102.101', 'พักอาคารเพื่อประโยชน์อื่น');
INSERT INTO `account_std` VALUES ('112', '1205030103.101', 'ค่าเสื่อมราคาสะสม-อาคารเพื่อประโยชน์อื่น');
INSERT INTO `account_std` VALUES ('113', '1205030106.101', 'ส่วนปรับปรุงอาคาร');
INSERT INTO `account_std` VALUES ('114', '1205030107.101', 'พักส่วนปรับปรุงอาคาร');
INSERT INTO `account_std` VALUES ('115', '1205030108.101', 'ค่าเสื่อมราคาสะสม-ส่วนปรับปรุงอาคาร');
INSERT INTO `account_std` VALUES ('116', '1205040101.101', 'สิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('117', '1205040101.102', 'ระบบประปา');
INSERT INTO `account_std` VALUES ('118', '1205040101.103', 'ระบบบำบัดน้ำเสีย');
INSERT INTO `account_std` VALUES ('119', '1205040101.104', 'ระบบไฟฟ้า');
INSERT INTO `account_std` VALUES ('120', '1205040101.105', 'ระบบโทรศัพท์');
INSERT INTO `account_std` VALUES ('121', '1205040101.106', 'ระบบถนนภายใน');
INSERT INTO `account_std` VALUES ('122', '1205040102.101', 'พักสิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('123', '1205040102.102', 'พักระบบประปา');
INSERT INTO `account_std` VALUES ('124', '1205040102.103', 'พักระบบบำบัดน้ำเสีย');
INSERT INTO `account_std` VALUES ('125', '1205040102.104', 'พักระบบไฟฟ้า');
INSERT INTO `account_std` VALUES ('126', '1205040102.105', 'พักระบบโทรศัพท์');
INSERT INTO `account_std` VALUES ('127', '1205040102.106', 'พักระบบถนนภายใน');
INSERT INTO `account_std` VALUES ('128', '1205040103.101', 'ค่าเสื่อมราคาสะสม-สิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('129', '1205040103.102', 'ค่าเสื่อมราคาสะสม-ระบบประปา');
INSERT INTO `account_std` VALUES ('130', '1205040103.103', 'ค่าเสื่อมราคาสะสม-ระบบบำบัดน้ำเสีย');
INSERT INTO `account_std` VALUES ('131', '1205040103.104', 'ค่าเสื่อมราคาสะสม-ระบบไฟฟ้า');
INSERT INTO `account_std` VALUES ('132', '1205040103.105', 'ค่าเสื่อมราคาสะสม-ระบบโทรศัพท์');
INSERT INTO `account_std` VALUES ('133', '1205040103.106', 'ค่าเสื่อมราคาสะสม-ระบบถนนภายใน');
INSERT INTO `account_std` VALUES ('134', '1205050101.101', 'อาคารเพื่อการพักอาศัย-Interface');
INSERT INTO `account_std` VALUES ('135', '1205050101.102', 'อาคารสำนักงาน-Interface');
INSERT INTO `account_std` VALUES ('136', '1205050101.103', 'อาคารเพื่อประโยชน์ อื่น-Interface');
INSERT INTO `account_std` VALUES ('137', '1205050101.104', 'สิ่งปลูกสร้าง-Interface');
INSERT INTO `account_std` VALUES ('138', '1205050101.105', 'ระบบประปา-Interface');
INSERT INTO `account_std` VALUES ('139', '1205050101.106', 'ระบบบำบัดน้ำเสีย-Interface');
INSERT INTO `account_std` VALUES ('140', '1205050101.107', 'ระบบไฟฟ้า-Interface');
INSERT INTO `account_std` VALUES ('141', '1205050101.108', 'ระบบโทรศัพท์-Interface');
INSERT INTO `account_std` VALUES ('142', '1205050101.109', 'ระบบถนนภายใน-Interface');
INSERT INTO `account_std` VALUES ('143', '1205050102.101', 'ค่าเสื่อมราคาสะสมอาคารเพื่อการพักอาศัย - Interface');
INSERT INTO `account_std` VALUES ('144', '1205050102.102', 'ค่าเสื่อมราคาสะสมอาคารสำนักงาน-Interface');
INSERT INTO `account_std` VALUES ('145', '1205050102.103', 'ค่าเสื่อมราคาสะสมอาคารเพื่อประโยชน์ อื่น - Interface');
INSERT INTO `account_std` VALUES ('146', '1205050102.104', 'ค่าเสื่อมราคาสะสมสิ่งปลูกสร้าง -Interface');
INSERT INTO `account_std` VALUES ('147', '1205050102.105', 'ค่าเสื่อมราคาสะสมระบบประปา -Interface');
INSERT INTO `account_std` VALUES ('148', '1205050102.106', 'ค่าเสื่อมราคาสะสมระบบบำบัดน้ำเสีย - Interface');
INSERT INTO `account_std` VALUES ('149', '1205050102.107', 'ค่าเสื่อมราคาสะสมระบบไฟฟ้า -Interface');
INSERT INTO `account_std` VALUES ('150', '1205050102.108', 'ค่าเสื่อมราคาสะสมระบบโทรศัพท์-Interface');
INSERT INTO `account_std` VALUES ('151', '1205050102.109', 'ค่าเสื่อมราคาสะสมระบบถนนภายใน-Interface');
INSERT INTO `account_std` VALUES ('152', '1205060101.101', 'อาคารและสิ่งปลูกสร้างไม่ระบุราย ละเอียด');
INSERT INTO `account_std` VALUES ('153', '1205060102.101', 'ค่าเสื่อมราคาสะสม-อาคารและสิ่งปลูกสร้างไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('154', '1206010101.101', 'ครุภัณฑ์สำนักงาน');
INSERT INTO `account_std` VALUES ('155', '1206010102.101', 'พักครุภัณฑ์สำนักงาน');
INSERT INTO `account_std` VALUES ('156', '1206010103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์สำนักงาน');
INSERT INTO `account_std` VALUES ('157', '1206020101.101', 'ครุภัณฑ์ยานพาหนะและขนส่ง');
INSERT INTO `account_std` VALUES ('158', '1206020102.101', 'พักครุภัณฑ์ยานพาหนะและขนส่ง');
INSERT INTO `account_std` VALUES ('159', '1206020103.101', 'ค่าเสื่อมราคาสะสม -ครุภัณฑ์ยานพาหนะและขนส่ง');
INSERT INTO `account_std` VALUES ('160', '1206030101.101', 'ครุภัณฑ์ไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('161', '1206030102.101', 'พักครุภัณฑ์ไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('162', '1206030103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์ไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('163', '1206040101.101', 'ครุภัณฑ์โฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('164', '1206040102.101', 'พักครุภัณฑ์โฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('165', '1206040103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์โฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('166', '1206050101.101', 'ครุภัณฑ์การเกษตร');
INSERT INTO `account_std` VALUES ('167', '1206050102.101', 'พักครุภัณฑ์การเกษตร');
INSERT INTO `account_std` VALUES ('168', '1206050103.101', 'ค่าเสื่อมราคาสะสม -ครุภัณฑ์การเกษตร');
INSERT INTO `account_std` VALUES ('169', '1206060101.101', 'ครุภัณฑ์โรงงาน');
INSERT INTO `account_std` VALUES ('170', '1206060102.101', 'พักครุภัณฑ์โรงงาน');
INSERT INTO `account_std` VALUES ('171', '1206060103.101', 'ค่าเสื่อมราคาสะสม -ครุภัณฑ์โรงงาน');
INSERT INTO `account_std` VALUES ('172', '1206070101.101', 'ครุภัณฑ์ก่อสร้าง');
INSERT INTO `account_std` VALUES ('173', '1206070102.101', 'พักครุภัณฑ์ก่อสร้าง');
INSERT INTO `account_std` VALUES ('174', '1206070103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์ก่อสร้าง');
INSERT INTO `account_std` VALUES ('175', '1206090101.101', 'ครุภัณฑ์วิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('176', '1206090102.101', 'พักครุภัณฑ์วิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('177', '1206090103.101', 'ค่าเสื่อมราคาสะสม -ครุภัณฑ์วิทยา ศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('178', '1206100101.101', 'ครุภัณฑ์คอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('179', '1206100102.101', 'พักครุภัณฑ์คอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('180', '1206100103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์คอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('181', '1206110101.101', 'ครุภัณฑ์การศึกษา');
INSERT INTO `account_std` VALUES ('182', '1206110102.101', 'พักครุภัณฑ์การศึกษา');
INSERT INTO `account_std` VALUES ('183', '1206110103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์การศึกษา');
INSERT INTO `account_std` VALUES ('184', '1206120101.101', 'ครุภัณฑ์งานบ้านงานครัว');
INSERT INTO `account_std` VALUES ('185', '1206120102.101', 'พักครุภัณฑ์งานบ้านงานครัว');
INSERT INTO `account_std` VALUES ('186', '1206120103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์งานบ้านงานครัว');
INSERT INTO `account_std` VALUES ('187', '1206130101.101', 'ครุภัณฑ์กีฬา');
INSERT INTO `account_std` VALUES ('188', '1206130102.101', 'พักครุภัณฑ์กีฬา');
INSERT INTO `account_std` VALUES ('189', '1206130103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์กีฬา');
INSERT INTO `account_std` VALUES ('190', '1206140101.101', 'ครุภัณฑ์ดนตรี');
INSERT INTO `account_std` VALUES ('191', '1206140102.101', 'พักครุภัณฑ์ดนตรี');
INSERT INTO `account_std` VALUES ('192', '1206140103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์ดนตรี');
INSERT INTO `account_std` VALUES ('193', '1206150101.101', 'ครุภัณฑ์สนาม');
INSERT INTO `account_std` VALUES ('194', '1206150102.101', 'พักครุภัณฑ์สนาม');
INSERT INTO `account_std` VALUES ('195', '1206150103.101', 'ค่าเสื่อมราคาสะสม-ครุภัณฑ์สนาม');
INSERT INTO `account_std` VALUES ('196', '1206160101.101', 'ครุภัณฑ์อื่น');
INSERT INTO `account_std` VALUES ('197', '1206160102.101', 'พักครุภัณฑ์อื่น');
INSERT INTO `account_std` VALUES ('198', '1206160103.101', 'ค่าเสื่อมราคาสะสม- ครุภัณฑ์อื่น');
INSERT INTO `account_std` VALUES ('199', '1206170101.101', 'ครุภัณฑ์สำนักงาน-Interface');
INSERT INTO `account_std` VALUES ('200', '1206170101.102', 'ครุภัณฑ์ยานพาหนะและขนส่ง-Interface');
INSERT INTO `account_std` VALUES ('201', '1206170101.103', 'ครุภัณฑ์ไฟฟ้าและวิทยุ-Interface');
INSERT INTO `account_std` VALUES ('202', '1206170101.104', 'ครุภัณฑ์โฆษณาและเผยแพร่-Interface');
INSERT INTO `account_std` VALUES ('203', '1206170101.105', 'ครุภัณฑ์การเกษตร-Interface');
INSERT INTO `account_std` VALUES ('204', '1206170101.106', 'ครุภัณฑ์ก่อสร้าง-Interface');
INSERT INTO `account_std` VALUES ('205', '1206170101.107', 'ครุภัณฑ์วิทยาศาสตร์และการแพทย์-Interface');
INSERT INTO `account_std` VALUES ('206', '1206170101.108', 'ครุภัณฑ์คอมพิวเตอร์-Interface');
INSERT INTO `account_std` VALUES ('207', '1206170101.109', 'ครุภัณฑ์งานบ้านงานครัว-Interface');
INSERT INTO `account_std` VALUES ('208', '1206170101.110', 'ครุภัณฑ์อื่น-Interface');
INSERT INTO `account_std` VALUES ('209', '1206170102.101', 'ค่าเสื่อมราคาสะสมครุภัณฑ์สำนักงาน-Interface');
INSERT INTO `account_std` VALUES ('210', '1206170102.102', 'ค่าเสื่อมราคาสะสมครุภัณฑ์ยานพาหนะและขนส่ง-Interface');
INSERT INTO `account_std` VALUES ('211', '1206170102.103', 'ค่าเสื่อมราคาสะสมครุภัณฑ์ไฟฟ้าและวิทยุ-Interface');
INSERT INTO `account_std` VALUES ('212', '1206170102.104', 'ค่าเสื่อมราคาสะสมครุภัณฑ์โฆษณาและเผยแพร่-Interface');
INSERT INTO `account_std` VALUES ('213', '1206170102.105', 'ค่าเสื่อมราคาสะสมครุภัณฑ์การเกษตร-Interface');
INSERT INTO `account_std` VALUES ('214', '1206170102.106', 'ค่าเสื่อมราคาสะสมครุภัณฑ์ก่อสร้าง-Interface');
INSERT INTO `account_std` VALUES ('215', '1206170102.107', 'ค่าเสื่อมราคาสะสมครุภัณฑ์วิทยาศาสตร์และการแพทย์-Interface');
INSERT INTO `account_std` VALUES ('216', '1206170102.108', 'ค่าเสื่อมราคาสะสมครุภัณฑ์คอมพิวเตอร์-Interface');
INSERT INTO `account_std` VALUES ('217', '1206170102.109', 'ค่าเสื่อมราคาสะสมครุภัณฑ์งานบ้านงานครัว-Interface');
INSERT INTO `account_std` VALUES ('218', '1206170102.110', 'ค่าเสื่อมราคาสะสมครุภัณฑ์อื่น-Interface');
INSERT INTO `account_std` VALUES ('219', '1206180101.101', 'ครุภัณฑ์ไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('220', '1206180102.101', 'ค่าเสื่อมราคาสะสม- ครุภัณฑ์ไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('221', '1209010101.101', 'โปรแกรมคอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('222', '1209010102.101', 'พักโปรแกรมคอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('223', '1209010103.101', 'ค่าตัดจำหน่ายสะสม - โปรแกรมคอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('224', '1209030101.101', 'โปรแกรมคอมพิวเตอร์ -Interface');
INSERT INTO `account_std` VALUES ('225', '1209030101.104', 'สินทรัพย์ไม่มีตัวตนอื่น - Interface');
INSERT INTO `account_std` VALUES ('226', '1209030102.101', 'ค่าตัดจำหน่ายสะสมโปรแกรมคอมพิวเตอร์ - Interface');
INSERT INTO `account_std` VALUES ('227', '1209030102.103', 'ค่าตัดจำหน่ายสะสมสินทรัพย์ไม่มีตัวตนอื่น - Interface');
INSERT INTO `account_std` VALUES ('228', '1211010101.101', 'งานระหว่างก่อสร้าง');
INSERT INTO `account_std` VALUES ('229', '1211010102.101', 'พักงานระหว่างก่อสร้าง');
INSERT INTO `account_std` VALUES ('230', '1211010103.101', 'งานระหว่างก่อสร้าง- Interface');
INSERT INTO `account_std` VALUES ('231', '1213010105.101', 'สินทรัพย์รอการโอน');
INSERT INTO `account_std` VALUES ('232', '1213010199.101', 'สินทรัพย์ไม่หมุนเวียนอื่น');
INSERT INTO `account_std` VALUES ('233', '2101010101.102', 'เจ้าหนี้การค้า - หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('234', '2101010102.102', 'เจ้าหนี้การค้า-บุคคลภายนอก-ยา (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('235', '2101010102.103', 'เจ้าหนี้การค้า-บุคคลภายนอก -วัสดุการแพทย์ทั่วไป (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('236', '2101010102.105', 'เจ้าหนี้การค้า-บุคคลภายนอก - วัสดุวิทยาศาสตร์และการแพทย์ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('237', '2101010102.116', 'เจ้าหนี้การค้า-บุคคลภายนอก-วัสดุอื่น ๆ(เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('238', '2101010102.129', 'เจ้าหนี้การค้า-บุคคลภายนอก - อื่น ๆ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('239', '2101010102.130', 'เจ้าหนี้การค้า-บุคคลภายนอก- วัสดุเภสัชกรรม (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('240', '2101010102.131', 'เจ้าหนี้การค้า-บุคคลภายนอก- วัสดุทันตกรรม (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('241', '2101010102.132', 'เจ้าหนี้การค้า-บุคคลภายนอก- วัสดุเอกซเรย์ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('242', '2101010102.133', 'เจ้าหนี้การค้า-บุคคลภายนอก-ยา (เงินนอกประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('243', '2101010102.134', 'เจ้าหนี้การค้า-บุคคลภายนอก-วัสดุเภสัชกรรม (เงินนอกประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('244', '2101010102.135', 'เจ้าหนี้การค้า-บุคคลภายนอก-วัสดุการแพทย์ทั่วไป (เงินนอกประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('245', '2101010102.136', 'เจ้าหนี้การค้า-บุคคลภายนอก -วัสดุวิทยาศาสตร์การแพทย์ (เงินนอกงบประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('246', '2101010102.137', 'เจ้าหนี้การค้า-บุคคลภายนอก-วัสดุเอกซเรย์ (เงินนอกงบประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('247', '2101010102.138', 'เจ้าหนี้การค้า-บุคคลภายนอก-วัสดุทันตกรรม (เงินนอกงบประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('248', '2101010102.139', 'เจ้าหนี้การค้า-บุคคลภายนอก-วัสดุอื่น ๆ (เงินนอกงบประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('249', '2101010102.140', 'เจ้าหนี้การค้า-บุคคลภายนอก-อื่น ๆ (เงินนอกงบประมาณฝากคลัง)');
INSERT INTO `account_std` VALUES ('250', '2101010103.101', 'รับสินค้า/ใบสำคัญ (GR/IR) - เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('251', '2101010103.102', 'รับสินค้า/ใบสำคัญ (GR/IR) - เงินนอกงบประมาณฝากคลัง');
INSERT INTO `account_std` VALUES ('252', '2101010103.103', 'รับสินค้า/ใบสำคัญ (GR/IR) - เงินนอกงบประมาณฝากคลัง ยาและเวชภัณฑ์มิใช่ยา');
INSERT INTO `account_std` VALUES ('253', '2101010107.101', 'เจ้าหนี้การค้า Interface - บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('254', '2101020106.101', 'เจ้าหนี้ส่วนราชการ - รายได้รับแทนกัน');
INSERT INTO `account_std` VALUES ('255', '2101020198.102', 'เจ้าหนี้อื่น - หน่วยงานภาครัฐ - ยา (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('256', '2101020198.103', 'เจ้าหนี้หน่วยงานภาครัฐ -วัสดุการแพทย์ทั่วไป (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('257', '2101020198.105', 'เจ้าหนี้หน่วยงานภาครัฐ - วัสดุวิทยาศาสตร์และการแพทย์ (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('258', '2101020198.107', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุอื่น (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('259', '2101020198.111', 'เจ้าหนี้หน่วยงานภาครัฐ-อื่น (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('260', '2101020198.112', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุเภสัชกรรม(กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('261', '2101020198.113', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุทันตกรรม (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('262', '2101020198.114', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุเอกซเรย์(กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('263', '2101020198.115', 'เจ้าหนี้อื่น - หน่วยงานภาครัฐ - ยา (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('264', '2101020198.116', 'เจ้าหนี้หน่วยงานภาครัฐ -วัสดุการแพทย์ทั่วไป (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('265', '2101020198.117', 'เจ้าหนี้หน่วยงานภาครัฐ - วัสดุวิทยาศาสตร์และการแพทย์ (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('266', '2101020198.118', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุอื่น (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('267', '2101020198.119', 'เจ้าหนี้หน่วยงานภาครัฐ-อื่น (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('268', '2101020198.120', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุเภสัชกรรม(กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('269', '2101020198.121', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุทันตกรรม (กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือหน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('270', '2101020198.122', 'เจ้าหนี้หน่วยงานภาครัฐ-วัสดุเอกซเรย์(กรมบัญชีกลางจ่ายตรงให้ผู้ขายที่เป็นรัฐวิสาหกิจหรือ หน่วยงานของรัฐ)');
INSERT INTO `account_std` VALUES ('271', '2101020199.134', 'เจ้าหนี้-ยา');
INSERT INTO `account_std` VALUES ('272', '2101020199.135', 'เจ้าหนี้-วัสดุการแพทย์ทั่วไป');
INSERT INTO `account_std` VALUES ('273', '2101020199.136', 'เจ้าหนี้ - วัสดุวิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('274', '2101020199.137', 'เจ้าหนี้ -วัสดุอื่น');
INSERT INTO `account_std` VALUES ('275', '2101020199.138', 'เจ้าหนี้-อื่น');
INSERT INTO `account_std` VALUES ('276', '2101020199.139', 'เจ้าหนี้ - ครุภัณฑ์');
INSERT INTO `account_std` VALUES ('277', '2101020199.140', 'เจ้าหนี้ - ที่ดิน อาคาร และสิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('278', '2101020199.141', 'เจ้าหนี้-วัตถุดิบ');
INSERT INTO `account_std` VALUES ('279', '2101020199.142', 'เจ้าหนี้-สินค้าสำเร็จรูป');
INSERT INTO `account_std` VALUES ('280', '2101020199.143', 'เจ้าหนี้-วัสดุเภสัชกรรม');
INSERT INTO `account_std` VALUES ('281', '2101020199.144', 'เจ้าหนี้-วัสดุทันตกรรม');
INSERT INTO `account_std` VALUES ('282', '2101020199.145', 'เจ้าหนี้-วัสดุเอกซเรย์');
INSERT INTO `account_std` VALUES ('283', '2101020199.146', 'เจ้าหนี้-ค่าจ้างเหมาบริการทางการแพทย์');
INSERT INTO `account_std` VALUES ('284', '2101020199.147', 'เจ้าหนี้-ค่าจ้างเหมาตรวจห้องปฏิบัติการ (LAB)');
INSERT INTO `account_std` VALUES ('285', '2101020199.148', 'เจ้าหนี้-ค่าตรวจเอกซเรย์ (X-Ray)');
INSERT INTO `account_std` VALUES ('286', '2101020199.149', 'เจ้าหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('287', '2101020199.150', 'เจ้าหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา หน่วยงานภายนอก');
INSERT INTO `account_std` VALUES ('288', '2101020199.151', 'เจ้าหนี้- เงินบริจาค');
INSERT INTO `account_std` VALUES ('289', '2101020199.201', 'เจ้าหนี้- งบลงทุน UC');
INSERT INTO `account_std` VALUES ('290', '2101020199.202', 'เจ้าหนี้ค่ารักษา OP-UC นอก CUP (ในจังหวัดสังกัด สธ.)');
INSERT INTO `account_std` VALUES ('291', '2101020199.203', 'เจ้าหนี้ค่ารักษา OP-UC นอก CUP (ต่างจังหวัดสังกัด สธ.)');
INSERT INTO `account_std` VALUES ('292', '2101020199.204', 'เจ้าหนี้ค่ารักษา OP-UC นอกสังกัด สป.สธ.');
INSERT INTO `account_std` VALUES ('293', '2101020199.301', 'เจ้าหนี้ค่ารักษาพยาบาล-ประกันสังคม');
INSERT INTO `account_std` VALUES ('294', '2101020199.501', 'เจ้าหนี้ค่ารักษา -แรงงานต่างด้าว ในสังกัด สธ.');
INSERT INTO `account_std` VALUES ('295', '2101020199.502', 'เจ้าหนี้ค่ารักษา -แรงงานต่างด้าวนอกสังกัด สธ.');
INSERT INTO `account_std` VALUES ('296', '2101020199.503', 'เจ้าหนี้ค่ารักษา -แรงงานต่างด้าว ในสังกัด สธ.(จ่ายจากเงินบำรุง)');
INSERT INTO `account_std` VALUES ('297', '2101020199.504', 'เจ้าหนี้ค่ารักษา -แรงงานต่างด้าวนอกสังกัด สธ. (จ่ายจากเงินบำรุง)');
INSERT INTO `account_std` VALUES ('298', '2101020199.701', 'เจ้าหนี้ค่ารักษา -บุคคลที่มีปัญหาสถานะและสิทธินอก CUP');
INSERT INTO `account_std` VALUES ('299', '2102040101.101', 'ค่าสาธารณูปโภคค้างจ่าย');
INSERT INTO `account_std` VALUES ('300', '2102040102.101', 'ใบสำคัญค้างจ่าย');
INSERT INTO `account_std` VALUES ('301', '2102040103.101', 'ภาษีหัก ณ ที่จ่ายรอนำส่ง - ภาษีเงินได้บุคคลธรรมดา');
INSERT INTO `account_std` VALUES ('302', '2102040104.101', 'ภาษีหัก ณ ที่จ่ายรอนำส่ง - ภาษีเงินได้บุคคลธรรมดา ภงด 1');
INSERT INTO `account_std` VALUES ('303', '2102040106.101', 'ภาษีหัก ณ ที่จ่ายรอนำส่ง - ภาษีเงินได้นิติบุคคลจากบุคคลภายนอก');
INSERT INTO `account_std` VALUES ('304', '2102040110.101', 'ใบสำคัญค้างจ่ายอื่น (เงินนอกงบประมาณฝากธนาคารพาณิชย์)');
INSERT INTO `account_std` VALUES ('305', '2102040110.102', 'ค่าจ้างชั่วคราวค้างจ่าย (บริการ)');
INSERT INTO `account_std` VALUES ('306', '2102040110.103', 'ค่าจ้างชั่วคราวค้างจ่าย (สนับสนุน)');
INSERT INTO `account_std` VALUES ('307', '2102040110.104', 'ค่าจ้างพนักงานกระทรวงสาธารณสุขค้างจ่าย (บริการ)');
INSERT INTO `account_std` VALUES ('308', '2102040110.105', 'ค่าจ้างพนักงานกระทรวงสาธารณสุขค้างจ่าย (สนับสนุน)');
INSERT INTO `account_std` VALUES ('309', '2102040110.106', 'ค่าตอบแทนเงินเพิ่มพิเศษไม่ทำเวชปฏิบัติฯลฯ(บริการ) ค้างจ่าย');
INSERT INTO `account_std` VALUES ('310', '2102040110.107', 'ค่าตอบแทนในการปฏิบัติงานของเจ้าหน้าที่ (บริการ) ค้างจ่าย');
INSERT INTO `account_std` VALUES ('311', '2102040110.108', 'ค่าตอบแทนในการปฏิบัติงานของเจ้าหน้าที่ (สนับสนุน) ค้างจ่าย');
INSERT INTO `account_std` VALUES ('312', '2102040110.109', 'ค่าตอบแทนเงินเพิ่มพิเศษสำหรับผู้ปฏิบัติงานด้านการสาธารณสุข (พ.ต.ส.) เงินนอกงบประมาณค้างจ่าย');
INSERT INTO `account_std` VALUES ('313', '2102040110.110', 'ค่าตอบแทนตามผลการปฏิบัติงานค้างจ่าย');
INSERT INTO `account_std` VALUES ('314', '2102040110.111', 'ค่าตอบแทนการปฏิบัติงานในลักษณะเบี้ยเลี้ยงเหมาจ่ายค้างจ่าย');
INSERT INTO `account_std` VALUES ('315', '2102040110.112', 'ค่าตอบแทนอื่นค้างจ่าย');
INSERT INTO `account_std` VALUES ('316', '2102040110.113', 'ค่าสาธารณูปโภคค้างจ่าย');
INSERT INTO `account_std` VALUES ('317', '2102040110.114', 'ค่าใช้จ่ายโครงการ P&P ค้างจ่าย');
INSERT INTO `account_std` VALUES ('318', '2102040110.115', 'ค่าใช้จ่ายโครงการค้างจ่าย');
INSERT INTO `account_std` VALUES ('319', '2102040198.101', 'ค่าใช้จ่ายค้างจ่ายอื่น-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('320', '2102040199.101', 'ค่าใช้จ่ายค้างจ่ายอื่น-บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('321', '2102040199.105', 'ใบสำคัญค้างจ่าย');
INSERT INTO `account_std` VALUES ('322', '2103010103.101', 'รายได้ค่าบริการอื่นรับล่วงหน้า');
INSERT INTO `account_std` VALUES ('323', '2103010103.502', 'รายได้ค่ารักษาแรงงานต่างด้าวรับล่วงหน้า');
INSERT INTO `account_std` VALUES ('324', '2104010101.101', 'รายได้แผ่นดินอื่นรอนำส่งคลัง-หน่วยเบิกจ่าย');
INSERT INTO `account_std` VALUES ('325', '2109010199.101', 'รายได้เงินช่วยเหลือรอการรับรู้');
INSERT INTO `account_std` VALUES ('326', '2109010199.201', 'รายได้กองทุน UC- รอรับรู้');
INSERT INTO `account_std` VALUES ('327', '2109010199.701', 'รายได้เงินอุดหนุนเหมาจ่ายรายหัวสำหรับบุคคลที่มีปัญหาสถานะและสิทธิรอรับรู้');
INSERT INTO `account_std` VALUES ('328', '2111020199.103', 'เงินรับฝากรายได้แผ่นดินอื่น-หน่วยงานย่อย');
INSERT INTO `account_std` VALUES ('329', '2111020199.105', 'เงินรับฝากอื่น(หมุนเวียน)');
INSERT INTO `account_std` VALUES ('330', '2111020199.107', 'ภาษีเงินได้หัก ณ ที่จ่ายรอนำส่ง');
INSERT INTO `account_std` VALUES ('331', '2111020199.108', 'เงินรับฝากหักจากเงินเดือน');
INSERT INTO `account_std` VALUES ('332', '2111020199.109', 'เงินสมทบประกันสังคมส่วนของลูกจ้าง (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('333', '2111020199.110', 'เงินสมทบประกันสังคมส่วนของลูกจ้าง(เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('334', '2111020199.201', 'เงินรับฝากกองทุน UC');
INSERT INTO `account_std` VALUES ('335', '2111020199.202', 'เงินรับฝากกองทุน UC (งบลงทุน)');
INSERT INTO `account_std` VALUES ('336', '2111020199.204', 'เงินรับฝากกองทุน UC วัสดุ');
INSERT INTO `account_std` VALUES ('337', '2111020199.205', 'เงินรับฝากกองทุน UC -Fixed Cost');
INSERT INTO `account_std` VALUES ('338', '2111020199.206', 'เงินรับฝากกองทุน UC -นอกเหนือ Fixed Cost');
INSERT INTO `account_std` VALUES ('339', '2111020199.207', 'เงินกองทุน UC (วัสดุ) สอน. และ รพ.สต. (อบจ.)');
INSERT INTO `account_std` VALUES ('340', '2111020199.301', 'เงินกองทุนประกันสังคม');
INSERT INTO `account_std` VALUES ('341', '2111020199.304', 'เงินรับฝากค่าบริหารจัดการประกันสังคม');
INSERT INTO `account_std` VALUES ('342', '2111020199.501', 'เงินรับฝากกองทุนแรงงานต่างด้าว-ค่าบริหารจัดการ');
INSERT INTO `account_std` VALUES ('343', '2111020199.502', 'เงินรับฝากกองทุนแรงงานต่างด้าว-ค่าใช้จ่ายสูง');
INSERT INTO `account_std` VALUES ('344', '2111020199.503', 'เงินรับฝากกองทุนแรงงานต่างด้าว-P&P');
INSERT INTO `account_std` VALUES ('345', '2112010101.101', 'เงินประกันสัญญา');
INSERT INTO `account_std` VALUES ('346', '2112010102.101', 'เงินประกันผลงาน');
INSERT INTO `account_std` VALUES ('347', '2112010199.101', 'เงินประกันอื่น');
INSERT INTO `account_std` VALUES ('348', '2112010199.102', 'เงินประกันอื่น - เงินมัดจำประกันสัญญา');
INSERT INTO `account_std` VALUES ('349', '2112010199.103', 'เงินประกันอื่น - เงินประกันซอง');
INSERT INTO `account_std` VALUES ('350', '2112010199.104', 'เงินประกันอื่น - เงินประกันผลงาน');
INSERT INTO `account_std` VALUES ('351', '2116010104.101', 'เบิกเกินส่งคืนรอนำส่ง');
INSERT INTO `account_std` VALUES ('352', '2116010199.101', 'หนี้สินหมุนเวียนอื่น');
INSERT INTO `account_std` VALUES ('353', '2116010199.102', 'สำรองเงินชดเชยความเสียหาย');
INSERT INTO `account_std` VALUES ('354', '2202010101.101', 'เงินทดรองราชการรับจากคลัง-เพื่อการดำเนินงาน');
INSERT INTO `account_std` VALUES ('355', '2203010101.101', 'เงินยืมระยะยาว-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('356', '2208010101.101', 'เงินมัดจำประกันสัญญา-ระยะยาว');
INSERT INTO `account_std` VALUES ('357', '2208010102.101', 'เงินมัดจำประกันผลงาน-ระยะยาว');
INSERT INTO `account_std` VALUES ('358', '2208010103.101', 'เงินประกันอื่น - ระยะยาว');
INSERT INTO `account_std` VALUES ('359', '2213010101.101', 'รายได้จากเงินบริจาครอการรับรู้');
INSERT INTO `account_std` VALUES ('360', '2213010101.103', 'รายได้อื่นรอการรับรู้');
INSERT INTO `account_std` VALUES ('361', '2213010199.102', 'หนี้สินไม่หมุนเวียนอื่น');
INSERT INTO `account_std` VALUES ('362', '3101010101.101', 'รายได้สูง(ต่ำ)กว่า ค่าใช้จ่ายสุทธิ');
INSERT INTO `account_std` VALUES ('363', '3102010101.101', 'รายได้สูง(ต่ำ)กว่า ค่าใช้จ่ายสะสม (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('364', '3102010101.102', 'รายได้สูง(ต่ำ)กว่า ค่าใช้จ่ายสะสม (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('365', '3102010102.101', 'ผลสะสมจาการแก้ไขข้อผิดพลาด');
INSERT INTO `account_std` VALUES ('366', '3102010102.102', 'ผลสะสมจากการแก้ไขข้อผิดพลาด - รายได้');
INSERT INTO `account_std` VALUES ('367', '3102010102.103', 'ผลสะสมจากการแก้ไขข้อผิดพลาด - ค่าใช้จ่าย');
INSERT INTO `account_std` VALUES ('368', '3102010102.201', 'กำไร/ขาดทุนสะสมจากข้อผิดพลาดเงินกองทุนUC ปีก่อน');
INSERT INTO `account_std` VALUES ('369', '3105010101.101', 'ทุนของหน่วยงาน');
INSERT INTO `account_std` VALUES ('370', '3105010103.101', 'ทุน-คงยอดเงินต้น');
INSERT INTO `account_std` VALUES ('371', '4201020106.101', 'รายได้แผ่นดิน-เงินชดใช้จากการผิดสัญญาการศึกษาและดูงาน');
INSERT INTO `account_std` VALUES ('372', '4201020199.101', 'รายได้แผ่นดิน-ค่าปรับอื่น');
INSERT INTO `account_std` VALUES ('373', '4202010199.101', 'รายได้ค่าธรรมเนียมการบริการอื่น');
INSERT INTO `account_std` VALUES ('374', '4202020102.101', 'รายได้ค่าเช่าอสังหาริมทรัพย์จากบุคคลภายนอก');
INSERT INTO `account_std` VALUES ('375', '4202030105.101', 'รายได้แผ่นดิน-ค่าขายของเบ็ดเตล็ด');
INSERT INTO `account_std` VALUES ('376', '4203010101.101', 'รายได้ดอกเบี้ยเงินฝากที่สถาบันการเงิน');
INSERT INTO `account_std` VALUES ('377', '4205010104.101', 'รายรับจากการขายอาคารและสิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('378', '4205010110.101', 'รายรับจากการขายครุภัณฑ์');
INSERT INTO `account_std` VALUES ('379', '4206010102.101', 'รายได้เงินเหลือจ่ายปีเก่า');
INSERT INTO `account_std` VALUES ('380', '4206010199.101', 'บัญชีรายได้ที่ไม่ใช่ภาษีอื่น');
INSERT INTO `account_std` VALUES ('381', '4207010102.102', 'รายได้แผ่นดิน-ค่าปรับอื่นจ่ายคืน');
INSERT INTO `account_std` VALUES ('382', '4301010102.101', 'รายได้จากการจำหน่ายยาสมุนไพร -บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('383', '4301010102.102', 'รายได้จากการจำหน่ายสินค้าอื่น ๆ -บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('384', '4301010102.103', 'รายได้จากการจำหน่ายยาสมุนไพร -หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('385', '4301010102.104', 'รายได้จากการจำหน่ายสินค้าอื่น ๆ -หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('386', '4301020102.101', 'รายได้ค่าสิ่งส่งตรวจ - บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('387', '4301020102.102', 'รายได้ค่าตรวจสุขภาพ - บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('388', '4301020102.103', 'รายได้ค่าสิ่งส่งตรวจ - หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('389', '4301020102.104', 'รายได้ค่าตรวจสุขภาพ-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('390', '4301020102.105', 'รายได้จากระบบปฏิบัติ การฉุกเฉิน (EMS)');
INSERT INTO `account_std` VALUES ('391', '4301020102.106', 'รายได้สนับสนุนยาและอื่น ๆ');
INSERT INTO `account_std` VALUES ('392', '4301020104.104', 'รายได้ค่ารักษาเบิกต้นสังกัด OP');
INSERT INTO `account_std` VALUES ('393', '4301020104.105', 'รายได้ค่ารักษาเบิกต้นสังกัด IP');
INSERT INTO `account_std` VALUES ('394', '4301020104.106', 'รายได้ค่ารักษาชำระเงิน OP');
INSERT INTO `account_std` VALUES ('395', '4301020104.107', 'รายได้ค่ารักษาชำระเงิน IP');
INSERT INTO `account_std` VALUES ('396', '4301020104.108', 'รายได้ค่ารักษาเบิกจ่ายตรง-หน่วยงานอื่น - OP');
INSERT INTO `account_std` VALUES ('397', '4301020104.109', 'รายได้ค่ารักษาเบิกจ่ายตรงหน่วยงานอื่น-IP');
INSERT INTO `account_std` VALUES ('398', '4301020104.110', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรง หน่วยงานอื่น');
INSERT INTO `account_std` VALUES ('399', '4301020104.111', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรง หน่วยงานอื่น');
INSERT INTO `account_std` VALUES ('400', '4301020104.401', 'รายได้ค่ารักษาเบิกจ่ายตรงกรมบัญชีกลาง OP');
INSERT INTO `account_std` VALUES ('401', '4301020104.402', 'รายได้ค่ารักษาเบิกจ่ายตรงกรมบัญชีกลาง IP');
INSERT INTO `account_std` VALUES ('402', '4301020104.405', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรงกรมบัญชีกลาง');
INSERT INTO `account_std` VALUES ('403', '4301020104.406', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรงกรมบัญชีกลาง');
INSERT INTO `account_std` VALUES ('404', '4301020104.602', 'รายได้ค่ารักษา พรบ.รถ OP');
INSERT INTO `account_std` VALUES ('405', '4301020104.603', 'รายได้ค่ารักษา พรบ.รถ IP');
INSERT INTO `account_std` VALUES ('406', '4301020104.801', 'รายได้ค่ารักษาเบิกจ่ายตรง- อปท. OP');
INSERT INTO `account_std` VALUES ('407', '4301020104.802', 'รายได้ค่ารักษาเบิกจ่ายตรง-อปท. IP');
INSERT INTO `account_std` VALUES ('408', '4301020104.803', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรง - อปท.');
INSERT INTO `account_std` VALUES ('409', '4301020104.804', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรง - อปท.');
INSERT INTO `account_std` VALUES ('410', '4301020104.805', 'รายได้ค่ารักษาเบิกจ่ายตรง - อปท.รูปแบบพิเศษ OP');
INSERT INTO `account_std` VALUES ('411', '4301020104.806', 'รายได้ค่ารักษาเบิกจ่ายตรง- อปท.รูปแบบพิเศษ IP');
INSERT INTO `account_std` VALUES ('412', '4301020104.807', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรง (พนักงานส่วนท้องถิ่นรูปแบบพิเศษ)');
INSERT INTO `account_std` VALUES ('413', '4301020104.808', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG -เบิกจ่ายตรง (พนักงานส่วนท้องถิ่นรูปแบบพิเศษ)');
INSERT INTO `account_std` VALUES ('414', '4301020105.201', 'รายได้ค่ารักษา UC -OP ใน CUP');
INSERT INTO `account_std` VALUES ('415', '4301020105.202', 'รายได้ค่ารักษา UC-IP');
INSERT INTO `account_std` VALUES ('416', '4301020105.203', 'รายได้ค่ารักษา UC - OP นอก CUP ในจังหวัด');
INSERT INTO `account_std` VALUES ('417', '4301020105.205', 'รายได้ค่ารักษา UC-OP นอก CUP ต่างจังหวัด');
INSERT INTO `account_std` VALUES ('418', '4301020105.207', 'รายได้ค่ารักษา UC-OP นอกสังกัด สป.');
INSERT INTO `account_std` VALUES ('419', '4301020105.211', 'รายได้กองทุน UC (งบลงทุน)');
INSERT INTO `account_std` VALUES ('420', '4301020105.214', 'รายได้กองทุน UC - OP แบบเหมาจ่ายต่อผู้มีสิทธิ');
INSERT INTO `account_std` VALUES ('421', '4301020105.217', 'รายได้กองทุน UC - P&P แบบเหมาจ่ายต่อผู้มีสิทธิ');
INSERT INTO `account_std` VALUES ('422', '4301020105.222', 'รายได้กองทุน UC เฉพาะโรคอื่น');
INSERT INTO `account_std` VALUES ('423', '4301020105.223', 'รายได้กองทุน UC-P&P อื่น');
INSERT INTO `account_std` VALUES ('424', '4301020105.228', 'รายได้กองทุน UC อื่น');
INSERT INTO `account_std` VALUES ('425', '4301020105.229', 'ส่วนต่างค่ารักษาที่สูงกว่าเหมาจ่ายรายหัว - กองทุน UC OP');
INSERT INTO `account_std` VALUES ('426', '4301020105.231', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG-กองทุน UC -IP');
INSERT INTO `account_std` VALUES ('427', '4301020105.232', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG-กองทุน UC -IP');
INSERT INTO `account_std` VALUES ('428', '4301020105.239', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการตามจ่าย UC OP');
INSERT INTO `account_std` VALUES ('429', '4301020105.240', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการตามจ่าย UC OP');
INSERT INTO `account_std` VALUES ('430', '4301020105.241', 'รายได้ค่ารักษาด้านการสร้างเสริมสุขภาพและป้องกันโรค (P&P)');
INSERT INTO `account_std` VALUES ('431', '4301020105.242', 'รายได้กองทุน UC-บริการพื้นที่เฉพาะ');
INSERT INTO `account_std` VALUES ('432', '4301020105.243', 'รายได้กองทุน UC (CF)');
INSERT INTO `account_std` VALUES ('433', '4301020105.244', 'รายได้ค่ารักษา UC- OP บริการกรณีเฉพาะ (CR)');
INSERT INTO `account_std` VALUES ('434', '4301020105.245', 'รายได้ค่ารักษา UC - IP บริการกรณีเฉพาะ (CR)');
INSERT INTO `account_std` VALUES ('435', '4301020105.251', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตามDRG กองทุน UC (บริการเฉพาะ) CR- IP');
INSERT INTO `account_std` VALUES ('436', '4301020105.252', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG กองทุน UC (บริการเฉพาะ) CR- IP');
INSERT INTO `account_std` VALUES ('437', '4301020105.255', 'รายได้กองทุน UC-P&P ตามเกณฑ์คุณภาพผลงานบริการ');
INSERT INTO `account_std` VALUES ('438', '4301020105.256', 'รายได้จากการยกหนี้กรณีส่งต่อผู้ป่วยระหว่างรพ.');
INSERT INTO `account_std` VALUES ('439', '4301020105.257', 'ส่วนต่างค่ารักษาที่สูงกว่าเหมาจ่ายรายหัว - กองทุน UC P&P');
INSERT INTO `account_std` VALUES ('440', '4301020105.258', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงตามหลักเกณฑ์การจ่ายกองทุนUC-บริการเฉพาะ (CR) - OP');
INSERT INTO `account_std` VALUES ('441', '4301020105.260', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงตามหลักเกณฑ์การจ่ายกองทุนUC-บริการเฉพาะ (CR) -OP');
INSERT INTO `account_std` VALUES ('442', '4301020105.263', 'รายได้ค่ารักษา OP Refer');
INSERT INTO `account_std` VALUES ('443', '4301020105.264', 'ส่วนปรับลดค่าแรง OP');
INSERT INTO `account_std` VALUES ('444', '4301020105.265', 'ส่วนปรับลดค่าแรง IP');
INSERT INTO `account_std` VALUES ('445', '4301020105.266', 'ส่วนปรับลดค่าแรง PP');
INSERT INTO `account_std` VALUES ('446', '4301020105.271', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการตามจ่าย UC OP (หน่วยบริการที่ตามจ่าย)');
INSERT INTO `account_std` VALUES ('447', '4301020106.303', 'รายได้กองทุนประกันสังคม');
INSERT INTO `account_std` VALUES ('448', '4301020106.305', 'รายได้ค่ารักษาประกันสังคม OP-เครือข่าย');
INSERT INTO `account_std` VALUES ('449', '4301020106.306', 'รายได้ค่ารักษาประกันสังคม IP-เครือข่าย');
INSERT INTO `account_std` VALUES ('450', '4301020106.307', 'รายได้ค่ารักษาประกันสังคม OP-นอกเครือข่าย สังกัด สป.สธ.');
INSERT INTO `account_std` VALUES ('451', '4301020106.308', 'รายได้ค่ารักษาประกันสังคม IP-นอกเครือข่าย สังกัด สป.สธ.');
INSERT INTO `account_std` VALUES ('452', '4301020106.309', 'รายได้ค่ารักษาประกันสังคม OP-นอกเครือข่าย ต่างสังกัด สป.สธ.');
INSERT INTO `account_std` VALUES ('453', '4301020106.310', 'รายได้ค่ารักษาประกันสังคม IP-นอกเครือข่าย ต่างสังกัด สป.สธ.');
INSERT INTO `account_std` VALUES ('454', '4301020106.311', 'รายได้ค่ารักษาประกันสังคม-กองทุนทดแทน');
INSERT INTO `account_std` VALUES ('455', '4301020106.312', 'รายได้ค่ารักษาประกันสังคม 72 ชั่วโมงแรก');
INSERT INTO `account_std` VALUES ('456', '4301020106.313', 'รายได้ค่ารักษาประกันสังคม-ค่าใช้จ่ายสูง/อุบัติเหตุ/ฉุกเฉิน OP');
INSERT INTO `account_std` VALUES ('457', '4301020106.314', 'รายได้ค่ารักษาประกันสังคม-ค่าใช้จ่ายสูง IP');
INSERT INTO `account_std` VALUES ('458', '4301020106.315', 'ส่วนต่างค่ารักษาที่สูงกว่าเหมาจ่ายรายหัว - กองทุนประกันสังคม - OP');
INSERT INTO `account_std` VALUES ('459', '4301020106.317', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงตามหลักเกณฑ์การจ่าย - กองทุนประกันสังคม - IP');
INSERT INTO `account_std` VALUES ('460', '4301020106.319', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม กองทุนประกันสังคม');
INSERT INTO `account_std` VALUES ('461', '4301020106.320', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม กองทุนประกันสังคม');
INSERT INTO `account_std` VALUES ('462', '4301020106.321', 'รายได้ค่าบริหารจัดการประกันสังคม');
INSERT INTO `account_std` VALUES ('463', '4301020106.322', 'รายได้ค่าตอบแทนและพัฒนากิจการ');
INSERT INTO `account_std` VALUES ('464', '4301020106.502', 'รายได้กองทุนคนต่างด้าวและแรงงานต่างด้าว');
INSERT INTO `account_std` VALUES ('465', '4301020106.503', 'รายได้ค่ารักษาคนต่างด้าวและแรงงานต่างด้าว OP');
INSERT INTO `account_std` VALUES ('466', '4301020106.504', 'รายได้ค่ารักษาคนต่างด้าวและแรงงานต่างด้าว IP');
INSERT INTO `account_std` VALUES ('467', '4301020106.505', 'ส่วนต่างค่ารักษาที่สูงกว่ากองทุนเหมาจ่ายรายหัว - กองทุนคนต่างด้าวและแรงงานต่างด้าว - OP');
INSERT INTO `account_std` VALUES ('468', '4301020106.507', 'ส่วนต่างค่ารักษาที่สูงกว่ากองทุนเหมาจ่ายรายหัว - กองทุนคนต่างด้าวและแรงงานต่างด้าว - IP');
INSERT INTO `account_std` VALUES ('469', '4301020106.509', 'รายได้ค่ารักษาคนต่างด้าวและแรงงานต่างด้าว - เบิกจากส่วนกลาง OP');
INSERT INTO `account_std` VALUES ('470', '4301020106.510', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG -คนต่างด้าวและแรงงานต่างด้าว - IP');
INSERT INTO `account_std` VALUES ('471', '4301020106.511', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG - คนต่างด้าวและแรงงานต่างด้าว - IP');
INSERT INTO `account_std` VALUES ('472', '4301020106.512', 'รายได้ค่ารักษาคนต่างด้าวและแรงงานต่างด้าว OP นอก CUP');
INSERT INTO `account_std` VALUES ('473', '4301020106.513', 'รายได้ค่ารักษาคนต่างด้าวและแรงงานต่างด้าว IP นอก CUP');
INSERT INTO `account_std` VALUES ('474', '4301020106.514', 'รายได้ค่ารักษาคนต่างด้าวและแรงงานต่างด้าว - เบิกจากส่วนกลาง IP');
INSERT INTO `account_std` VALUES ('475', '4301020106.515', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตามหลักเกณฑ์ฯ เงินประกันสุขภาพคนต่างด้าวและแรงงานต่างด้าว OP');
INSERT INTO `account_std` VALUES ('476', '4301020106.516', 'รายได้ค่าตรวจสุขภาพคนต่างด้าวและแรงงานต่างด้าว');
INSERT INTO `account_std` VALUES ('477', '4301020106.517', 'รายได้ค่าบริหารจัดการคนต่างด้าวและแรงงานต่างด้าว');
INSERT INTO `account_std` VALUES ('478', '4301020106.518', 'รายได้คนต่างด้าวและแรงงานต่างด้าว - ค่าบริการทางการแพทย์(P&P)');
INSERT INTO `account_std` VALUES ('479', '4301020106.519', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตามหลักเกณฑ์ฯ เงินประกันสุขภาพคนต่างด้าวและแรงงานต่างด้าว OP');
INSERT INTO `account_std` VALUES ('480', '4301020106.701', 'รายได้ค่ารักษาบุคคลที่มีปัญหาสถานะและสิทธิ OP นอก CUP');
INSERT INTO `account_std` VALUES ('481', '4301020106.703', 'รายได้ค่ารักษาบุคคลที่มีปัญหาสถานะและสิทธิ - เบิกจากส่วนกลาง OP');
INSERT INTO `account_std` VALUES ('482', '4301020106.704', 'ส่วนต่างค่ารักษาพยาบาลที่สูงกว่าข้อตกลงในการจ่ายตามหลักเกณฑ์ฯ - บุคคลที่มีปัญหาสถานะและสิทธิ OP');
INSERT INTO `account_std` VALUES ('483', '4301020106.705', 'ส่วนต่างค่ารักษาที่สูงกว่าข้อตกลงในการจ่ายตาม DRG บุคคลที่มีปัญหาสถานะและสิทธิ');
INSERT INTO `account_std` VALUES ('484', '4301020106.706', 'ส่วนต่างค่ารักษาที่ต่ำกว่าข้อตกลงในการจ่ายตาม DRG บุคคลที่มีปัญหาสถานะและสิทธิ');
INSERT INTO `account_std` VALUES ('485', '4301020106.709', 'รายได้ค่ารักษา-บุคคลที่มีปัญหาสถานะและสิทธิ OP ใน CUP');
INSERT INTO `account_std` VALUES ('486', '4301020106.710', 'รายได้ค่ารักษาบุคคลที่มีปัญหาสถานะและสิทธิ - เบิกจากส่วนกลาง IP');
INSERT INTO `account_std` VALUES ('487', '4301020106.711', 'ส่วนต่างค่ารักษาที่สูงกว่าเหมาจ่ายรายหัว-เงินอุดหนุนบุคคลที่มีปัญหาและสถานะและสิทธิ OP ใน CUP');
INSERT INTO `account_std` VALUES ('488', '4301020106.712', 'รายได้เงินอุดหนุนเหมาจ่ายรายหัวสำหรับบุคคลที่มีปัญหาสถานะและสิทธิ');
INSERT INTO `account_std` VALUES ('489', '4301020108.101', 'รายได้เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('490', '4301030102.101', 'รายได้ค่าเช่าอสังหาริมทรัพย์');
INSERT INTO `account_std` VALUES ('491', '4301030104.101', 'รายได้ค่าเช่าอื่น');
INSERT INTO `account_std` VALUES ('492', '4302010101.101', 'รายได้จากการอุดหนุน-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('493', '4302010106.101', 'รายได้จากการช่วยเหลือเพื่อการดำเนินงานจาก อปท.');
INSERT INTO `account_std` VALUES ('494', '4302010199.101', 'รายได้จากการช่วยเหลือเพื่อการดำเนินงานอื่น');
INSERT INTO `account_std` VALUES ('495', '4302020107.101', 'รายได้จากการช่วยเหลือเพื่อการลงทุนจากอปท.');
INSERT INTO `account_std` VALUES ('496', '4302020199.101', 'รายได้จากการช่วยเหลือเพื่อการลงทุนอื่น');
INSERT INTO `account_std` VALUES ('497', '4302030101.101', 'รายได้จากการรับบริจาค-เงินสดและรายการเทียบเท่าเงินสด');
INSERT INTO `account_std` VALUES ('498', '4302030101.102', 'รายได้จากการรับบริจาค-สินทรัพย์อื่น');
INSERT INTO `account_std` VALUES ('499', '4302040101.101', 'พักรับเงินงบอุดหนุน');
INSERT INTO `account_std` VALUES ('500', '4303010101.101', 'รายได้ดอกเบี้ยจากสถาบันการเงิน');
INSERT INTO `account_std` VALUES ('501', '4306010104.101', 'รายรับจากการขายอาคารและสิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('502', '4306010110.101', 'รายรับจากการขายครุภัณฑ์');
INSERT INTO `account_std` VALUES ('503', '4306010110.102', 'รายรับจากการขายวัสดุที่ใช้แล้ว');
INSERT INTO `account_std` VALUES ('504', '4307010103.201', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินงบบุคลากรจากรัฐบาล');
INSERT INTO `account_std` VALUES ('505', '4307010104.101', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินงบลงทุนจากรัฐบาล');
INSERT INTO `account_std` VALUES ('506', '4307010105.101', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินงบดำเนินงานจากรัฐบาล');
INSERT INTO `account_std` VALUES ('507', '4307010106.101', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินงบอุดหนุนจากรัฐบาล');
INSERT INTO `account_std` VALUES ('508', '4307010107.101', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินงบรายจ่ายอื่นจากรัฐบาล');
INSERT INTO `account_std` VALUES ('509', '4307010108.101', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินงบกลางจากรัฐบาล');
INSERT INTO `account_std` VALUES ('510', '4307010110.101', 'บัญชีรายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินกู้จากรัฐบาล');
INSERT INTO `account_std` VALUES ('511', '4307010112.101', 'บัญชีรายได้ระหว่างหน่วยงาน-กรมบัญชี กลางรับเงินเบิกเกินส่งคืนจากหน่วยงาน');
INSERT INTO `account_std` VALUES ('512', '4308010101.101', 'รายได้ระหว่างหน่วยงาน-หน่วยงานรับเงินนอกงบประมาณจากกรมบัญชีกลาง');
INSERT INTO `account_std` VALUES ('513', '4308010105.101', 'รายได้ระหว่างหน่วยงาน-ปรับเงินฝากคลัง');
INSERT INTO `account_std` VALUES ('514', '4308010106.101', 'รายได้ระหว่างหน่วยงาน-หน่วยงานรับเงินจากหน่วยงานอื่น');
INSERT INTO `account_std` VALUES ('515', '4308010111.101', 'รายได้ระหว่างหน่วยงาน - หน่วยงานรับเงินถอนคืนรายได้จากรัฐบาล');
INSERT INTO `account_std` VALUES ('516', '4308010117.101', 'รายได้ระหว่างหน่วยงาน -เงินทดรองราชการ');
INSERT INTO `account_std` VALUES ('517', '4308010118.101', 'รายได้ระหว่างกัน-ภายในกรมเดียวกัน');
INSERT INTO `account_std` VALUES ('518', '4308010121.101', 'รายได้ระหว่างกัน-ภายในกรมเดียวกัน (Manual)');
INSERT INTO `account_std` VALUES ('519', '4313010101.101', 'หนี้สูญได้รับคืน');
INSERT INTO `account_std` VALUES ('520', '4313010103.101', 'รายได้ค่าปรับ');
INSERT INTO `account_std` VALUES ('521', '4313010199.101', 'รายได้ค่าวัสดุ/อุปกรณ์/น้ำยา-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('522', '4313010199.102', 'รายได้ค่าวัสดุ/อุปกรณ์/น้ำยา-บุคคลภายนอก');
INSERT INTO `account_std` VALUES ('523', '4313010199.105', 'รายได้ค่าใบรับรองแพทย์');
INSERT INTO `account_std` VALUES ('524', '4313010199.108', 'รายได้จากเงินโครงการผลิตแพทย์');
INSERT INTO `account_std` VALUES ('525', '4313010199.109', 'รายได้จากโครงการผลิตบุคลากรทางการแพทย์');
INSERT INTO `account_std` VALUES ('526', '4313010199.110', 'รายได้ลักษณะอื่น');
INSERT INTO `account_std` VALUES ('527', '4313010199.113', 'รายได้ค่าธรรมเนียม');
INSERT INTO `account_std` VALUES ('528', '4313010199.114', 'รายได้อื่น-สินค้ารับโอนจาก สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('529', '4313010199.115', 'รายได้อื่น-วัสดุรับโอนจาก สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('530', '4313010199.116', 'รายได้อื่น-ครุภัณฑ์ ที่ดินและสิ่งก่อสร้างรับโอนจาก สสจ./รพศ./รพท./รพช./ รพ.สต.');
INSERT INTO `account_std` VALUES ('531', '4313010199.117', 'รายได้อื่น-เงินนอกงบประมาณรับโอนจาก สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('532', '4313010199.118', 'รายได้อื่น-เงินงบประมาณงบลงทุน รับโอนจาก สสจ./รพศ./รพท./รพช./ รพ.สต.');
INSERT INTO `account_std` VALUES ('533', '4313010199.119', 'รายได้อื่น-เงินงบประมาณงบดำเนินงานรับโอนจาก สสจ./รพศ./รพท./รพช. / รพ.สต.');
INSERT INTO `account_std` VALUES ('534', '4313010199.120', 'รายได้อื่น-เงินงบประมาณงบอุดหนุนรับโอนจาก สสจ./รพศ. /รพท./รพช. /รพ.สต');
INSERT INTO `account_std` VALUES ('535', '4313010199.121', 'รายได้อื่น-เงินงบประมาณงบรายจ่ายอื่นรับโอนจาก สสจ./รพศ. /รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('536', '4313010199.122', 'รายได้อื่น-เงินงบประมาณงบกลางรับโอนจาก สสจ./รพศ. /รพท./รพช. /รพ.สต.');
INSERT INTO `account_std` VALUES ('537', '4313010199.123', 'รายได้อื่น - เงินงบประมาณงบเงินกู้จากรัฐบาลรับโอนจาก สสจ./รพศ./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('538', '4313010199.202', 'รายได้ค่าธรรมเนียม UC');
INSERT INTO `account_std` VALUES ('539', '5101010101.101', 'เงินเดือนข้าราชการ(บริการ)');
INSERT INTO `account_std` VALUES ('540', '5101010101.102', 'เงินเดือนข้าราชการ(สนับสนุน)');
INSERT INTO `account_std` VALUES ('541', '5101010103.101', 'เงินประจำตำแหน่งระดับสูง/ระดับกลาง(สนับสนุน)');
INSERT INTO `account_std` VALUES ('542', '5101010103.102', 'เงินประจำตำแหน่งวิชาชีพเฉพาะ(บริการ)');
INSERT INTO `account_std` VALUES ('543', '5101010103.103', 'เงินประจำตำแหน่งผู้เชี่ยวชาญ (บริการ)');
INSERT INTO `account_std` VALUES ('544', '5101010108.101', 'ค่าล่วงเวลา(สนับสนุน)');
INSERT INTO `account_std` VALUES ('545', '5101010109.101', 'เงินตอบแทนพิเศษของข้าราชการผู้ได้รับเงินเดือนถึงขั้นสูงสุดของอันดับ(บริการ)');
INSERT INTO `account_std` VALUES ('546', '5101010109.102', 'เงินตอบแทนพิเศษของข้าราชการผู้ได้รับเงินเดือนถึงขั้นสูงสุดของอันดับ(สนับสนุน)');
INSERT INTO `account_std` VALUES ('547', '5101010109.103', 'เงินตอบแทนพิเศษของลูกจ้างประจำผู้ได้รับค่าจ้างถึงขั้นสูงสุดของตำแหน่ง(บริการ)');
INSERT INTO `account_std` VALUES ('548', '5101010109.104', 'เงินตอบแทนพิเศษของลูกจ้างประจำผู้ได้รับค่าจ้างถึงขั้นสูงสุดของตำแหน่ง(สนับสนุน)');
INSERT INTO `account_std` VALUES ('549', '5101010113.101', 'ค่าจ้างประจำ(บริการ)');
INSERT INTO `account_std` VALUES ('550', '5101010113.102', 'ค่าจ้างประจำ(สนับสนุน)');
INSERT INTO `account_std` VALUES ('551', '5101010113.103', 'ค่าจ้างชั่วคราว(บริการ)');
INSERT INTO `account_std` VALUES ('552', '5101010113.104', 'ค่าจ้างชั่วคราว(สนับสนุน)');
INSERT INTO `account_std` VALUES ('553', '5101010113.105', 'ค่าจ้างพนักงานกระทรวงสาธารณสุข (บริการ)');
INSERT INTO `account_std` VALUES ('554', '5101010113.106', 'ค่าจ้างพนักงานกระทรวงสาธารณสุข (สนับสนุน)');
INSERT INTO `account_std` VALUES ('555', '5101010113.107', 'ค่าจ้างเหมาบุคลากร (บริการ)');
INSERT INTO `account_std` VALUES ('556', '5101010113.108', 'ค่าจ้างเหมาบุคลากร (สนับสนุน)');
INSERT INTO `account_std` VALUES ('557', '5101010115.101', 'เงินค่าตอบแทนพนักงานราชการ (บริการ)');
INSERT INTO `account_std` VALUES ('558', '5101010115.102', 'เงินค่าตอบแทนพนักงานราชการ (สนับสนุน)');
INSERT INTO `account_std` VALUES ('559', '5101010116.101', 'เงินค่าครองชีพสำหรับข้าราชการ (บริการ)');
INSERT INTO `account_std` VALUES ('560', '5101010116.102', 'เงินค่าครองชีพสำหรับข้าราชการ(สนับสนุน)');
INSERT INTO `account_std` VALUES ('561', '5101010116.103', 'เงินค่าครองชีพสำหรับลูกจ้างประจำ(บริการ)');
INSERT INTO `account_std` VALUES ('562', '5101010116.104', 'เงินค่าครองชีพสำหรับลูกจ้างประจำ(สนับสนุน)');
INSERT INTO `account_std` VALUES ('563', '5101010116.105', 'เงินค่าครองชีพสำหรับพนักงานราชการ(บริการ)');
INSERT INTO `account_std` VALUES ('564', '5101010116.106', 'เงินค่าครองชีพสำหรับพนักงานราชการ(สนับสนุน)');
INSERT INTO `account_std` VALUES ('565', '5101010199.101', 'เงินตอบแทนรายเดือนสำหรับข้าราชการเท่ากับอัตราเงินประจำตำแหน่ง (บริการ)');
INSERT INTO `account_std` VALUES ('566', '5101010199.102', 'เงินตอบแทนชำนาญการพิเศษที่ไม่ใช่วิชาชีพ (สนับสนุน)');
INSERT INTO `account_std` VALUES ('567', '5101010199.103', 'ค่าตอบแทนในการปฏิบัติงานเวรหรือผลัดบ่ายและหรือผลัดดึกของพยาบาล');
INSERT INTO `account_std` VALUES ('568', '5101020101.101', 'เงินช่วยพิเศษกรณีเสียชีวิต');
INSERT INTO `account_std` VALUES ('569', '5101020101.102', 'เงินช่วยพิเศษกรณีเสียชีวิต (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('570', '5101020102.101', 'เงินทำขวัญข้าราชการและลูกจ้าง');
INSERT INTO `account_std` VALUES ('571', '5101020103.101', 'เงินชดเชยสมาชิก กบข.');
INSERT INTO `account_std` VALUES ('572', '5101020104.101', 'เงินสมทบ กบข.');
INSERT INTO `account_std` VALUES ('573', '5101020105.101', 'เงินสมทบ กสจ.');
INSERT INTO `account_std` VALUES ('574', '5101020106.101', 'เงินสมทบกองทุนประกันสังคมส่วนของนายจ้าง (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('575', '5101020106.102', 'เงินสมทบกองทุนประกันสังคมส่วนของนายจ้าง (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('576', '5101020108.101', 'ค่าเช่าบ้าน');
INSERT INTO `account_std` VALUES ('577', '5101020112.101', 'เงินสมทบกองทุนสำรองเลี้ยงชีพพนักงานและเจ้าหน้าที่รัฐ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('578', '5101020114.107', 'ค่าตอบแทนเงินเพิ่มพิเศษสำหรับผู้ปฏิบัติงานด้านการสาธารณสุข (พ.ต.ส.-เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('579', '5101020114.114', 'ค่าตอบแทนเงินเพิ่มพิเศษสำหรับผู้ปฏิบัติงานด้านการสาธารณสุข (พ.ต.ส./ค.ต.ส.-เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('580', '5101020114.126', 'เงินเพิ่มสำหรับตำแหน่งที่มีเหตุพิเศษ (บริการ)');
INSERT INTO `account_std` VALUES ('581', '5101020114.127', 'เงินเพิ่มสำหรับตำแหน่งที่มีเหตุพิเศษ (สนับสนุน)');
INSERT INTO `account_std` VALUES ('582', '5101020115.101', 'ค่าตอบแทนพิเศษชายแดนภาคใต้ (บริการ)');
INSERT INTO `account_std` VALUES ('583', '5101020116.101', 'เงินสมทบกองทุนทดแทน - เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('584', '5101020116.102', 'เงินสมทบกองทุนทดแทน-เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('585', '5101020199.105', 'ค่าใช้จ่ายบุคลากรอื่น(เงิบงบประมาณ)');
INSERT INTO `account_std` VALUES ('586', '5101020199.106', 'ค่าใช้จ่ายบุคลากรอื่น(เงิบนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('587', '5101030101.101', 'เงินช่วยการศึกษาบุตร');
INSERT INTO `account_std` VALUES ('588', '5101030205.101', 'เงินช่วยค่ารักษาพยาบาลประเภทผู้ป่วยนอก รพ.รัฐ สำหรับผู้มีสิทธิตามกฎหมายยกเว้นผู้รับเบี้ยหวัด/บำนาญ');
INSERT INTO `account_std` VALUES ('589', '5101030206.101', 'เงินช่วยค่ารักษาพยาบาลประเภทผู้ป่วยใน รพ.รัฐ สำหรับผู้มีสิทธิตามกฎหมายยกเว้นผู้รับเบี้ยหวัด/บำนาญ');
INSERT INTO `account_std` VALUES ('590', '5101030207.101', 'เงินช่วยค่ารักษาพยาบาลประเภทผู้ป่วยนอก รพ.เอกชนสำหรับผู้มีสิทธิตามกฎหมายยกเว้นผู้รับเบี้ยหวัด /บำนาญ');
INSERT INTO `account_std` VALUES ('591', '5101030208.101', 'เงินช่วยค่ารักษาพยาบาลประเภทผู้ป่วยในร.พ.เอกชนสำหรับผู้มีสิทธิตามกฎหมายยกเว้นผู้รับเบี้ยหวัด /บำนาญ');
INSERT INTO `account_std` VALUES ('592', '5101030211.101', 'เงินช่วยเหลือค่ารักษาพยาบาลตามกฎหมายสงเคราะห์ข้าราชการ');
INSERT INTO `account_std` VALUES ('593', '5101040107.101', 'บำเหน็จตกทอด');
INSERT INTO `account_std` VALUES ('594', '5101040111.101', 'เงินช่วยพิเศษกรณีผู้รับบำนาญเสียชีวิต');
INSERT INTO `account_std` VALUES ('595', '5101040118.101', 'บำนาญตกทอด');
INSERT INTO `account_std` VALUES ('596', '5101040202.101', 'เงินช่วยการศึกษาบุตร');
INSERT INTO `account_std` VALUES ('597', '5101040204.101', 'เงินช่วยค่ารักษาพยาบาลประเภทผู้ป่วยนอก รพ.รัฐ สำหรับผู้รับเบี้ยหวัด /บำนาญตามกฎหมาย');
INSERT INTO `account_std` VALUES ('598', '5101040205.101', 'เงินช่วยค่ารักษาพยาบาลประเภท ผู้ป่วยใน รพ.รัฐ สำหรับผู้รับเบี้ยหวัด /บำนาญตามกฎหมาย');
INSERT INTO `account_std` VALUES ('599', '5101040206.101', 'เงินช่วยค่ารักษา พยาบาลประเภทผู้ป่วยนอก รพ.เอกชน สำหรับผู้รับเบี้ยหวัด/บำนาญตามกฎหมาย');
INSERT INTO `account_std` VALUES ('600', '5101040207.101', 'เงินช่วยค่ารักษาพยาบาลประเภท ผู้ป่วยใน รพ.เอกชน สำหรับผู้รับ เบี้ยหวัด/บำนาญตามกฎหมาย');
INSERT INTO `account_std` VALUES ('601', '5102010106.101', 'ค่าใช้จ่ายทุนการศึกษา-ในประเทศ');
INSERT INTO `account_std` VALUES ('602', '5102010199.101', 'ค่าใช้จ่ายด้านการฝึกอบรม-ในประเทศ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('603', '5102010199.102', 'ค่าใช้จ่ายด้านการฝึกอบรม - ในประเทศ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('604', '5102030199.101', 'ค่าใช้จ่ายด้านการฝึกอบรม -บุคคล ภายนอก (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('605', '5102030199.102', 'ค่าใช้จ่ายด้านการฝึกอบรม -บุคคล ภายนอก (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('606', '5103010102.101', 'ค่าเบี้ยเลี้ยง-ในประเทศ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('607', '5103010102.102', 'ค่าเบี้ยเลี้ยง-ในประเทศ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('608', '5103010103.101', 'ค่าที่พัก-ในประเทศ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('609', '5103010103.102', 'ค่าที่พัก-ในประเทศ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('610', '5103010199.101', 'ค่าใช้จ่ายเดินทางอื่น -ในประเทศ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('611', '5103010199.102', 'ค่าใช้จ่ายเดินทางอื่น -ในประเทศ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('612', '5104010104.101', 'วัสดุสำนักงานใช้ไป');
INSERT INTO `account_std` VALUES ('613', '5104010104.102', 'วัสดุยานพาหนะและขนส่งใช้ไป');
INSERT INTO `account_std` VALUES ('614', '5104010104.103', 'วัสดุไฟฟ้าและวิทยุใช้ไป');
INSERT INTO `account_std` VALUES ('615', '5104010104.104', 'วัสดุโฆษณาและเผยแพร่ใช้ไป');
INSERT INTO `account_std` VALUES ('616', '5104010104.105', 'วัสดุคอมพิวเตอร์ใช้ไป');
INSERT INTO `account_std` VALUES ('617', '5104010104.106', 'วัสดุงานบ้านงานครัวใช้ไป');
INSERT INTO `account_std` VALUES ('618', '5104010104.107', 'วัสดุก่อสร้างใช้ไป');
INSERT INTO `account_std` VALUES ('619', '5104010104.108', 'วัสดุอื่นใช้ไป');
INSERT INTO `account_std` VALUES ('620', '5104010104.109', 'สินค้าใช้ไป');
INSERT INTO `account_std` VALUES ('621', '5104010107.101', 'ค่าซ่อมแซมอาคารและสิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('622', '5104010107.102', 'ค่าซ่อมแซมครุภัณฑ์สำนักงาน');
INSERT INTO `account_std` VALUES ('623', '5104010107.103', 'ค่าซ่อมแซมครุภัณฑ์ยานพาหนะและขนส่ง');
INSERT INTO `account_std` VALUES ('624', '5104010107.104', 'ค่าซ่อมแซมครุภัณฑ์ไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('625', '5104010107.105', 'ค่าซ่อมแซมครุภัณฑ์โฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('626', '5104010107.106', 'ค่าซ่อมแซมครุภัณฑ์วิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('627', '5104010107.107', 'ค่าซ่อมแซมครุภัณฑ์คอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('628', '5104010107.108', 'ค่าซ่อมแซมครุภัณฑ์อื่น');
INSERT INTO `account_std` VALUES ('629', '5104010107.109', 'ค่าจ้างเหมาบำรุงรักษาดูแลลิฟท์');
INSERT INTO `account_std` VALUES ('630', '5104010107.110', 'ค่าจ้างเหมาบำรุงรักษาสวนหย่อม');
INSERT INTO `account_std` VALUES ('631', '5104010107.111', 'ค่าจ้างเหมาบำรุงรักษาครุภัณฑ์วิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('632', '5104010107.112', 'ค่าจ้างเหมาบำรุงรักษาเครื่องปรับอากาศ');
INSERT INTO `account_std` VALUES ('633', '5104010107.113', 'ค่าจ้างเหมาซ่อมแซมบ้านพัก');
INSERT INTO `account_std` VALUES ('634', '5104010110.101', 'ค่าเชื้อเพลิง');
INSERT INTO `account_std` VALUES ('635', '5104010112.101', 'ค่าจ้างเหมาทำความสะอาด');
INSERT INTO `account_std` VALUES ('636', '5104010112.103', 'ค่าจ้างเหมาประกอบอาหารผู้ป่วย');
INSERT INTO `account_std` VALUES ('637', '5104010112.106', 'ค่าจ้างเหมารถ');
INSERT INTO `account_std` VALUES ('638', '5104010112.108', 'ค่าจ้างเหมาดูแลความปลอดภัย');
INSERT INTO `account_std` VALUES ('639', '5104010112.110', 'ค่าจ้างเหมาซักรีด');
INSERT INTO `account_std` VALUES ('640', '5104010112.111', 'ค่าจ้างเหมากำจัดขยะติดเชื้อ');
INSERT INTO `account_std` VALUES ('641', '5104010112.112', 'ค่าจ้างเหมาบริการทางการแพทย์');
INSERT INTO `account_std` VALUES ('642', '5104010112.113', 'ค่าจ้างเหมาบริการอื่น(สนับสนุน)');
INSERT INTO `account_std` VALUES ('643', '5104010112.114', 'ค่าจ้างตรวจทางห้องปฏิบัติการ (Lab)');
INSERT INTO `account_std` VALUES ('644', '5104010112.115', 'ค่าจ้างตรวจเอ็กซเรย์ (X-Ray)');
INSERT INTO `account_std` VALUES ('645', '5104010114.101', 'ค่าธรรมเนียมทางกฎหมาย');
INSERT INTO `account_std` VALUES ('646', '5104010115.101', 'ค่าธรรมเนียมธนาคาร');
INSERT INTO `account_std` VALUES ('647', '5104020101.101', 'ค่าไฟฟ้า');
INSERT INTO `account_std` VALUES ('648', '5104020103.101', 'ค่าน้ำประปาและน้ำบาดาล');
INSERT INTO `account_std` VALUES ('649', '5104020105.101', 'ค่าโทรศัพท์');
INSERT INTO `account_std` VALUES ('650', '5104020106.101', 'ค่าบริการสื่อสารและโทรคมนาคม');
INSERT INTO `account_std` VALUES ('651', '5104020107.101', 'ค่าไปรษณีย์และขนส่ง');
INSERT INTO `account_std` VALUES ('652', '5104030202.101', 'ค่าจ้างที่ปรึกษา');
INSERT INTO `account_std` VALUES ('653', '5104030203.101', 'ค่าเบี้ยประกันภัย');
INSERT INTO `account_std` VALUES ('654', '5104030205.101', 'ยาใช้ไป');
INSERT INTO `account_std` VALUES ('655', '5104030205.102', 'วัสดุเภสัชกรรมใช้ไป');
INSERT INTO `account_std` VALUES ('656', '5104030205.103', 'วัสดุทางการแพทย์ทั่วไปใช้ไป');
INSERT INTO `account_std` VALUES ('657', '5104030205.104', 'วัสดุวิทยาศาสตร์และการแพทย์ใช้ไป');
INSERT INTO `account_std` VALUES ('658', '5104030205.112', 'วัสดุบริโภคใช้ไป');
INSERT INTO `account_std` VALUES ('659', '5104030205.113', 'วัสดุเครื่องแต่งกายใช้ไป');
INSERT INTO `account_std` VALUES ('660', '5104030205.117', 'วัสดุทันตกรรมใช้ไป');
INSERT INTO `account_std` VALUES ('661', '5104030205.118', 'วัสดุเอกซเรย์ใช้ไป');
INSERT INTO `account_std` VALUES ('662', '5104030206.101', 'ค่าครุภัณฑ์มูลค่าต่ำกว่าเกณฑ์/ค่าจัดหาสินทรัพย์มูลค่าต่ำกว่าเกณฑ์');
INSERT INTO `account_std` VALUES ('663', '5104030207.101', 'ค่าใช้จ่ายในการประชุม');
INSERT INTO `account_std` VALUES ('664', '5104030208.101', 'ค่ารับรองและพิธีการ');
INSERT INTO `account_std` VALUES ('665', '5104030210.101', 'ค่าเช่าอสังหาริมทรัพย์');
INSERT INTO `account_std` VALUES ('666', '5104030212.101', 'ค่าเช่าเบ็ดเตล็ด');
INSERT INTO `account_std` VALUES ('667', '5104030217.101', 'เงินชดเชยค่างานสิ่งก่อสร้าง');
INSERT INTO `account_std` VALUES ('668', '5104030218.101', 'ค่าใช้จ่ายผลักส่งเป็นรายได้แผ่นดิน');
INSERT INTO `account_std` VALUES ('669', '5104030219.101', 'ค่าประชาสัมพันธ์');
INSERT INTO `account_std` VALUES ('670', '5104030220.101', 'ค่าชดใช้ค่าเสียหาย');
INSERT INTO `account_std` VALUES ('671', '5104030299.102', 'ค่าใช้จ่ายตามโครงการ (UC) (PP)');
INSERT INTO `account_std` VALUES ('672', '5104030299.103', 'ค่าใช้จ่ายตามโครงการ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('673', '5104030299.104', 'ค่าใช้สอยอื่นๆ');
INSERT INTO `account_std` VALUES ('674', '5104030299.105', 'ค่าใช้จ่ายตามโครงการ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('675', '5104030299.202', 'ค่ารักษาตามจ่าย UC ในสังกัด สป. สธ.');
INSERT INTO `account_std` VALUES ('676', '5104030299.203', 'ค่ารักษาตามจ่าย UC นอกสังกัด สป. สธ.');
INSERT INTO `account_std` VALUES ('677', '5104030299.204', 'ค่าจ้าง/ค่าเช่า/ค่าซ่อมบำรุง สิ่งก่อสร้างและครุภัณฑ์ (งบลงทุน UC)');
INSERT INTO `account_std` VALUES ('678', '5104030299.501', 'ค่ารักษาตามจ่ายคนต่างด้าวและแรงงานต่างด้าว');
INSERT INTO `account_std` VALUES ('679', '5104030299.502', 'ค่าใช้จ่ายตามโครงการ (P&P) แรงงานต่างด้าว');
INSERT INTO `account_std` VALUES ('680', '5104030299.701', 'ค่าใช้จ่ายตามโครงการ (P&P) บุคคลที่มีปัญหาสถานะและสิทธิ');
INSERT INTO `account_std` VALUES ('681', '5104030299.702', 'ค่ารักษาตามจ่ายบุคคลที่มีปัญหาสถานะและสิทธิ');
INSERT INTO `account_std` VALUES ('682', '5104040102.101', 'ค่าตอบแทนเงินเพิ่มพิเศษแพทย์ไม่ทำเวชปฏิบัติฯลฯ (บริการ)');
INSERT INTO `account_std` VALUES ('683', '5104040102.102', 'ค่าตอบแทนเงินเพิ่มพิเศษทันตแพทย์ไม่ทำเวชปฏิบัติฯลฯ(บริการ)');
INSERT INTO `account_std` VALUES ('684', '5104040102.103', 'ค่าตอบแทนเงินเพิ่มเภสัชกรไม่ทำเวชปฏิบัติฯลฯ (บริการ)');
INSERT INTO `account_std` VALUES ('685', '5104040102.104', 'ค่าตอบแทนในการปฏิบัติงานของเจ้าหน้าที่ (บริการ)');
INSERT INTO `account_std` VALUES ('686', '5104040102.105', 'ค่าตอบแทนในการปฏิบัติงานของเจ้าหน้าที่ (สนับสนุน)');
INSERT INTO `account_std` VALUES ('687', '5104040102.106', 'ค่าตอบแทนการปฏิบัติงานในคลินิกพิเศษนอกเวลา');
INSERT INTO `account_std` VALUES ('688', '5104040102.107', 'ค่าตอบแทนการปฏิบัติงานชันสูตรพลิกศพ (เงินงบประมาณ)');
INSERT INTO `account_std` VALUES ('689', '5104040102.108', 'ค่าตอบแทนการปฏิบัติงานชันสูตรพลิกศพ (เงินนอกงบประมาณ)');
INSERT INTO `account_std` VALUES ('690', '5104040102.109', 'ค่าตอบแทนปฏิบัติงานแพทย์สาขาส่งเสริมพิเศษ');
INSERT INTO `account_std` VALUES ('691', '5104040102.110', 'ค่าตอบแทนปฏิบัติงานส่งเสริมสุขภาพและเวชปฏิบัติครอบครัว');
INSERT INTO `account_std` VALUES ('692', '5104040102.111', 'ค่าตอบแทนการปฏิบัติงานในลักษณะค่าเบี้ยเลี้ยงเหมาจ่าย (บริการ) - เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('693', '5104040102.112', 'ค่าตอบแทนการปฏิบัติงานในลักษณะค่าเบี้ยเลี้ยงเหมาจ่าย (สนับสนุน) - เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('694', '5104040102.113', 'ค่าตอบแทนการปฏิบัติงานในลักษณะค่าเบี้ยเลี้ยงเหมาจ่าย (บริการ) - เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('695', '5104040102.114', 'ค่าตอบแทนการปฏิบัติงานในลักษณะค่าเบี้ยเลี้ยงเหมาจ่าย (สนับสนุน) - เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('696', '5104040102.115', 'ค่าตอบแทนตามผลการปฏิบัติงาน (บริการ) - เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('697', '5104040102.116', 'ค่าตอบแทนตามผลการปฏิบัติงาน (สนับสนุน) - เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('698', '5104040102.117', 'ค่าตอบแทนตามผลการปฏิบัติงาน (บริการ) - เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('699', '5104040102.118', 'ค่าตอบแทนตามผลการปฏิบัติงาน (สนับสนุน) - เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('700', '5104040102.119', 'ค่าตอบแทนการปฏิบัติงานอื่น -เงินงบประมาณ');
INSERT INTO `account_std` VALUES ('701', '5104040102.120', 'ค่าตอบแทนการปฏิบัติงานอื่น-เงินนอกงบประมาณ');
INSERT INTO `account_std` VALUES ('702', '5105010101.101', 'ค่าเสื่อมราคา -อาคารเพื่อการพักอาศัย');
INSERT INTO `account_std` VALUES ('703', '5105010103.101', 'ค่าเสื่อมราคา - อาคารสำนักงาน');
INSERT INTO `account_std` VALUES ('704', '5105010105.101', 'ค่าเสื่อมราคา - อาคารเพื่อประโยชน์อื่น');
INSERT INTO `account_std` VALUES ('705', '5105010107.101', 'ค่าเสื่อมราคา - สิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('706', '5105010107.102', 'ค่าเสื่อมราคา -ระบบประปา');
INSERT INTO `account_std` VALUES ('707', '5105010107.103', 'ค่าเสื่อมราคา - ระบบบำบัดน้ำเสีย');
INSERT INTO `account_std` VALUES ('708', '5105010107.104', 'ค่าเสื่อมราคา - ระบบไฟฟ้า');
INSERT INTO `account_std` VALUES ('709', '5105010107.105', 'ค่าเสื่อมราคา - ระบบโทรศัพท์');
INSERT INTO `account_std` VALUES ('710', '5105010107.106', 'ค่าเสื่อมราคา-ระบบถนนภายใน');
INSERT INTO `account_std` VALUES ('711', '5105010109.101', 'ค่าเสื่อมราคา-ครุภัณฑ์สำนักงาน');
INSERT INTO `account_std` VALUES ('712', '5105010111.101', 'ค่าเสื่อมราคา-ยานพาหนะและอุปกรณ์การขนส่ง');
INSERT INTO `account_std` VALUES ('713', '5105010113.101', 'ค่าเสื่อมราคา-ครุภัณฑ์ไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('714', '5105010115.101', 'ค่าเสื่อมราคา-ครุภัณฑ์โฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('715', '5105010117.101', 'ค่าเสื่อมราคา-ครุภัณฑ์การเกษตร');
INSERT INTO `account_std` VALUES ('716', '5105010119.101', 'ค่าเสื่อมราคา-ครุภัณฑ์โรงงาน');
INSERT INTO `account_std` VALUES ('717', '5105010121.101', 'ค่าเสื่อมราคา-ครุภัณฑ์ก่อสร้าง');
INSERT INTO `account_std` VALUES ('718', '5105010125.101', 'ค่าเสื่อมราคา-ครุภัณฑ์วิทยาศาสตร์ และการแพทย์');
INSERT INTO `account_std` VALUES ('719', '5105010127.101', 'ค่าเสื่อมราคา-อุปกรณ์คอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('720', '5105010129.101', 'ค่าเสื่อมราคา - ครุภัณฑ์การศึกษา');
INSERT INTO `account_std` VALUES ('721', '5105010131.101', 'ค่าเสื่อมราคา-ครุภัณฑ์งานบ้านงานครัว');
INSERT INTO `account_std` VALUES ('722', '5105010133.101', 'บัญชีค่าเสื่อมราคา - ครุภัณฑ์กีฬา');
INSERT INTO `account_std` VALUES ('723', '5105010135.101', 'บัญชีค่าเสื่อมราคา - ครุภัณฑ์ดนตรี');
INSERT INTO `account_std` VALUES ('724', '5105010137.101', 'บัญชีค่าเสื่อมราคา - ครุภัณฑ์สนาม');
INSERT INTO `account_std` VALUES ('725', '5105010139.101', 'ค่าเสื่อมราคา-ครุภัณฑ์อื่น');
INSERT INTO `account_std` VALUES ('726', '5105010148.101', 'ค่าตัดจำหน่าย-โปรแกรมคอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('727', '5105010149.102', 'ค่าตัดจำหน่าย-สินทรัพย์ที่ไม่มีตัวตนอื่น');
INSERT INTO `account_std` VALUES ('728', '5105010158.101', 'ค่าเสื่อมราคา-ส่วนปรับปรุงอาคาร');
INSERT INTO `account_std` VALUES ('729', '5105010160.101', 'ค่าเสื่อมราคาอาคารเพื่อพักอาศัย - Interface');
INSERT INTO `account_std` VALUES ('730', '5105010160.102', 'ค่าเสื่อมราคาอาคารสำนักงาน- Interface');
INSERT INTO `account_std` VALUES ('731', '5105010160.103', 'ค่าเสื่อมราคาอาคารเพื่อประโยชน์อื่น- Interface');
INSERT INTO `account_std` VALUES ('732', '5105010160.104', 'ค่าเสื่อมราคาสิ่งปลูกสร้าง -Interface');
INSERT INTO `account_std` VALUES ('733', '5105010160.105', 'ค่าเสื่อมราคาระบบประปา -Interface');
INSERT INTO `account_std` VALUES ('734', '5105010160.106', 'ค่าเสื่อมราคาระบบบำบัดน้ำเสีย - Interface');
INSERT INTO `account_std` VALUES ('735', '5105010160.107', 'ค่าเสื่อมราคาระบบไฟฟ้า -Interface');
INSERT INTO `account_std` VALUES ('736', '5105010160.108', 'ค่าเสื่อมราคาระบบโทรศัพท์ - Interface');
INSERT INTO `account_std` VALUES ('737', '5105010160.109', 'ค่าเสื่อมราคาระบบถนนภายใน - Interface');
INSERT INTO `account_std` VALUES ('738', '5105010161.101', 'ค่าเสื่อมราคาครุภัณฑ์สำนักงาน- Interface');
INSERT INTO `account_std` VALUES ('739', '5105010161.102', 'ค่าเสื่อมราคาครุภัณฑ์ยานพาหนะและขนส่ง -Interface');
INSERT INTO `account_std` VALUES ('740', '5105010161.103', 'ค่าเสื่อมราคาครุภัณฑ์ไฟฟ้าและวิทยุ - Interface');
INSERT INTO `account_std` VALUES ('741', '5105010161.104', 'ค่าเสื่อมราคาครุภัณฑ์โฆษณาและเผยแพร่ - Interface');
INSERT INTO `account_std` VALUES ('742', '5105010161.105', 'ค่าเสื่อมราคาครุภัณฑ์การเกษตร- Interface');
INSERT INTO `account_std` VALUES ('743', '5105010161.106', 'ค่าเสื่อมราคาครุภัณฑ์ก่อสร้าง -Interface');
INSERT INTO `account_std` VALUES ('744', '5105010161.107', 'ค่าเสื่อมราคาครุภัณฑ์วิทยาศาสตร์และการแพทย์ -Interface');
INSERT INTO `account_std` VALUES ('745', '5105010161.108', 'ค่าเสื่อมราคาอุปกรณ์คอมพิวเตอร์ - Interface');
INSERT INTO `account_std` VALUES ('746', '5105010161.109', 'ค่าเสื่อมราคาครุภัณฑ์งานบ้านงานครัว -Interface');
INSERT INTO `account_std` VALUES ('747', '5105010161.110', 'ค่าเสื่อมราคาครุภัณฑ์อื่น - Interface');
INSERT INTO `account_std` VALUES ('748', '5105010164.101', 'ค่าตัดจำหน่ายโปรแกรมคอมพิวเตอร์-Interface');
INSERT INTO `account_std` VALUES ('749', '5105010164.103', 'ค่าตัดจำหน่ายสินทรัพย์ไม่มีตัวตนอื่น- Interface');
INSERT INTO `account_std` VALUES ('750', '5105010194.101', 'ค่าเสื่อมราคา-อาคารและสิ่งปลูกสร้างไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('751', '5105010195.101', 'ค่าเสื่อมราคา-ครุภัณฑ์ไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('752', '5107010101.101', 'ค่าใช้จ่ายอุดหนุน-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('753', '5107010199.101', 'ค่าใช้จ่ายอุดหนุนเพื่อการดำเนินงานอื่น');
INSERT INTO `account_std` VALUES ('754', '5107020199.101', 'ค่าใช้จ่ายเงินอุดหนุนเพื่อการลงทุนอื่น');
INSERT INTO `account_std` VALUES ('755', '5107030101.101', 'บัญชีพักเบิกเงินอุดหนุน');
INSERT INTO `account_std` VALUES ('756', '5108010101.102', 'หนี้สูญ-ลูกหนี้ค่าสิ่งส่งตรวจ-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('757', '5108010101.104', 'หนี้สูญ-ลูกหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('758', '5108010101.105', 'หนี้สูญ-ลูกหนี้ค่าสินค้า-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('759', '5108010101.114', 'หนี้สูญ-ลูกหนี้ค่ารักษา-ชำระเงิน OP');
INSERT INTO `account_std` VALUES ('760', '5108010101.115', 'หนี้สูญ-ลูกหนี้ค่ารักษา-ชำระเงิน IP');
INSERT INTO `account_std` VALUES ('761', '5108010101.203', 'หนี้สูญ-ลูกหนี้ค่ารักษา UC -OP นอก CUP (ในจังหวัด)');
INSERT INTO `account_std` VALUES ('762', '5108010101.205', 'หนี้สูญ-ลูกหนี้ค่ารักษา UC -OP นอก CUP (ต่างจังหวัด)');
INSERT INTO `account_std` VALUES ('763', '5108010107.102', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่าสิ่งส่งตรวจ -หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('764', '5108010107.104', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่าวัสดุ/อุปกรณ์/น้ำยา-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('765', '5108010107.105', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่าสินค้า-หน่วยงานภาครัฐ');
INSERT INTO `account_std` VALUES ('766', '5108010107.114', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่ารักษา-ชำระเงิน OP');
INSERT INTO `account_std` VALUES ('767', '5108010107.115', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่ารักษา-ชำระเงิน IP');
INSERT INTO `account_std` VALUES ('768', '5108010107.203', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่ารักษา UC-OP นอก CUP (ในจังหวัด)');
INSERT INTO `account_std` VALUES ('769', '5108010107.205', 'หนี้สงสัยจะสูญ-ลูกหนี้ค่ารักษา UC-OP นอก CUP (ต่างจังหวัด)');
INSERT INTO `account_std` VALUES ('770', '5112010103.101', 'ค่าสวัสดิการสังคม-อื่น');
INSERT INTO `account_std` VALUES ('771', '5203010105.101', 'ค่าจำหน่าย-อาคารเพื่อการพักอาศัย');
INSERT INTO `account_std` VALUES ('772', '5203010106.101', 'ค่าจำหน่าย-อาคารสำนักงาน');
INSERT INTO `account_std` VALUES ('773', '5203010107.101', 'ค่าจำหน่าย-อาคารเพื่อประโยชน์อื่น');
INSERT INTO `account_std` VALUES ('774', '5203010109.101', 'ค่าจำหน่าย-สิ่งปลูกสร้าง');
INSERT INTO `account_std` VALUES ('775', '5203010110.101', 'ค่าจำหน่าย-อาคารและสิ่งปลูกสร้าง - Interface');
INSERT INTO `account_std` VALUES ('776', '5203010111.101', 'ค่าจำหน่าย-ครุภัณฑ์สำนักงาน');
INSERT INTO `account_std` VALUES ('777', '5203010112.101', 'ค่าจำหน่าย-ยานพาหนะและอุปกรณ์การขนส่ง');
INSERT INTO `account_std` VALUES ('778', '5203010113.101', 'ค่าจำหน่าย-ครุภัณฑ์ไฟฟ้าและวิทยุ');
INSERT INTO `account_std` VALUES ('779', '5203010114.101', 'ค่าจำหน่าย-ครุภัณฑ์โฆษณาและเผยแพร่');
INSERT INTO `account_std` VALUES ('780', '5203010115.101', 'ค่าจำหน่าย-ครุภัณฑ์การเกษตร');
INSERT INTO `account_std` VALUES ('781', '5203010117.101', 'ค่าจำหน่าย-ครุภัณฑ์ก่อสร้าง');
INSERT INTO `account_std` VALUES ('782', '5203010119.101', 'ค่าจำหน่าย-ครุภัณฑ์วิทยาศาสตร์และการแพทย์');
INSERT INTO `account_std` VALUES ('783', '5203010120.101', 'ค่าจำหน่าย-อุปกรณ์คอมพิวเตอร์');
INSERT INTO `account_std` VALUES ('784', '5203010122.101', 'ค่าจำหน่าย-ครุภัณฑ์งานบ้านงานครัว');
INSERT INTO `account_std` VALUES ('785', '5203010126.101', 'ค่าจำหน่าย-อุปกรณ์อื่น ๆ');
INSERT INTO `account_std` VALUES ('786', '5203010141.101', 'ค่าจำหน่าย - ครุภัณฑ์ Interface');
INSERT INTO `account_std` VALUES ('787', '5203010142.101', 'ค่าจำหน่าย - สินทรัพย์ไม่มีตัวตน Interface');
INSERT INTO `account_std` VALUES ('788', '5203010145.101', 'ค่าจำหน่าย-อาคารและสิ่งปลูกสร้างไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('789', '5203010146.101', 'ค่าจำหน่าย-ครุภัณฑ์ไม่ระบุรายละเอียด');
INSERT INTO `account_std` VALUES ('790', '5205010101.101', 'ค่าใช้จ่ายเงินช่วยเหลือผู้ประสบภัย');
INSERT INTO `account_std` VALUES ('791', '5209010112.101', 'ค่าใช้จ่ายระหว่างหน่วยงาน-หน่วยงานส่งเงินเบิกเกินส่งคืนให้กรมบัญชีกลาง');
INSERT INTO `account_std` VALUES ('792', '5210010101.101', 'ค่าใช้จ่ายระหว่างหน่วยงาน - กรมบัญชีกลางโอนเงินนอกงบประมาณให้หน่วยงาน');
INSERT INTO `account_std` VALUES ('793', '5210010102.101', 'ค่าใช้จ่ายระหว่างหน่วยงาน - หน่วยงานโอนเงินนอกงบประมาณให้กรมบัญชีกลาง');
INSERT INTO `account_std` VALUES ('794', '5210010103.101', 'ค่าใช้จ่ายระหว่างหน่วยงาน - หน่วยงานโอนเงินรายได้แผ่นดินให้กรมบัญชีกลาง');
INSERT INTO `account_std` VALUES ('795', '5210010105.101', 'ค่าใช้จ่ายระหว่างหน่วยงาน - ปรับเงินฝากคลัง');
INSERT INTO `account_std` VALUES ('796', '5210010112.101', 'ค่าใช้จ่ายระหว่างหน่วยงาน - รายได้แผ่นดินรอนำส่งคลัง');
INSERT INTO `account_std` VALUES ('797', '5210010118.101', 'ค่าใช้จ่ายระหว่างกัน-ภายในกรมเดียวกัน (Auto)');
INSERT INTO `account_std` VALUES ('798', '5210010121.101', 'ค่าใช้จ่ายระหว่างกัน-ภายในกรมเดียวกัน (Manual)');
INSERT INTO `account_std` VALUES ('799', '5211010101.101', 'โอนสินทรัพย์ให้หน่วยงานของรัฐ');
INSERT INTO `account_std` VALUES ('800', '5211010102.101', 'บัญชีบริจาคสินทรัพย์ให้หน่วยงานภายนอก');
INSERT INTO `account_std` VALUES ('801', '5212010199.101', 'ค่าใช้จ่ายโครงการผลิตแพทย์');
INSERT INTO `account_std` VALUES ('802', '5212010199.102', 'ค่าใช้จ่ายโครงการผลิตบุคลากรทางการแพทย์');
INSERT INTO `account_std` VALUES ('803', '5212010199.104', 'ค่าใช้จ่ายที่ดิน');
INSERT INTO `account_std` VALUES ('804', '5212010199.105', 'ค่าใช้จ่ายลักษณะอื่น');
INSERT INTO `account_std` VALUES ('805', '5212010199.106', 'ค่าใช้จ่ายอื่น-สินค้าโอนไป สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('806', '5212010199.107', 'ค่าใช้จ่ายอื่น-วัสดุโอนไป สสจ./ รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('807', '5212010199.108', 'ค่าใช้จ่ายอื่น-ครุภัณฑ์ ที่ดิน และสิ่งก่อสร้าง โอนไป สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('808', '5212010199.109', 'ค่าใช้จ่ายอื่น-เงินงบประมาณงบลงทุนโอนไปสสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('809', '5212010199.110', 'ค่าใช้จ่ายอื่น-เงินงบประมาณงบดำเนินงานโอนไป สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('810', '5212010199.111', 'ค่าใช้จ่ายอื่น-เงินงบประมาณงบอุดหนุนโอนไป สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('811', '5212010199.112', 'ค่าใช้จ่ายอื่น-เงินงบประมาณงบรายจ่ายอื่นโอนไป สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('812', '5212010199.113', 'ค่าใช้จ่ายอื่น-เงินงบประมาณงบกลางโอนไป สสจ./รพศ. /รพท./รพช./ รพ.สต.');
INSERT INTO `account_std` VALUES ('813', '5212010199.114', 'ค่าใช้จ่ายอื่น-เงินนอกงบประมาณโอนไป สสจ./รพศ./รพท./รพช./รพ.สต.');
INSERT INTO `account_std` VALUES ('814', '5401010101.101', 'ค่าใช้จ่ายรายการพิเศษนอกเหนือการดำเนินงานปกติ');

-- ----------------------------
-- Table structure for activity_logs
-- ----------------------------
DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE `activity_logs` (
  `log_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL,
  `action` varchar(100) NOT NULL,
  `description` text DEFAULT NULL COMMENT 'คำอธิบายการทำงาน',
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'ประเภทการอ้างอิง (receipt, ar, statement)',
  `reference_id` int(11) DEFAULT NULL COMMENT 'ID ที่อ้างอิง',
  `table_name` varchar(50) DEFAULT NULL,
  `record_id` int(11) DEFAULT NULL,
  `old_data` text DEFAULT NULL,
  `new_data` text DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`log_id`),
  KEY `idx_user_action` (`user_id`,`action`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  CONSTRAINT `fk_activity_logs_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of activity_logs
-- ----------------------------

-- ----------------------------
-- Table structure for adjustment_requests
-- ----------------------------
DROP TABLE IF EXISTS `adjustment_requests`;
CREATE TABLE `adjustment_requests` (
  `request_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_id` int(11) NOT NULL COMMENT 'รหัสลูกหนี้',
  `claim_id` int(11) DEFAULT NULL COMMENT 'รหัสการเบิกที่เกี่ยวข้อง',
  `request_type` enum('increase','decrease','cancel','data_fix') NOT NULL COMMENT 'ประเภทคำขอ',
  `current_amount` decimal(10,2) NOT NULL COMMENT 'ยอดปัจจุบัน',
  `requested_amount` decimal(10,2) NOT NULL COMMENT 'ยอดที่ขอปรับ',
  `reason` text NOT NULL COMMENT 'เหตุผล',
  `supporting_doc` varchar(255) DEFAULT NULL COMMENT 'เอกสารประกอบ',
  `status` enum('pending','approved','rejected') DEFAULT 'pending' COMMENT 'สถานะ',
  `requested_by` int(11) NOT NULL COMMENT 'ผู้ขอปรับปรุง (user_id)',
  `reviewed_by` int(11) DEFAULT NULL COMMENT 'ผู้พิจารณา (user_id)',
  `reviewed_at` datetime DEFAULT NULL COMMENT 'วันที่พิจารณา',
  `review_note` text DEFAULT NULL COMMENT 'หมายเหตุจากผู้พิจารณา',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`request_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_status` (`status`),
  KEY `idx_requested_by` (`requested_by`),
  KEY `fk_adj_req_claim` (`claim_id`),
  KEY `fk_adj_req_reviewed_by` (`reviewed_by`),
  CONSTRAINT `fk_adj_req_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_adj_req_claim` FOREIGN KEY (`claim_id`) REFERENCES `claim_details` (`claim_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_adj_req_requested_by` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_adj_req_reviewed_by` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางคำขอปรับปรุงลูกหนี้จากงานประกัน';

-- ----------------------------
-- Records of adjustment_requests
-- ----------------------------

-- ----------------------------
-- Table structure for aipn_rep_downloads
-- ----------------------------
DROP TABLE IF EXISTS `aipn_rep_downloads`;
CREATE TABLE `aipn_rep_downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `rep_no` varchar(50) NOT NULL,
  `file_type` varchar(20) DEFAULT 'AIPN_IPD',
  `patient_type` varchar(10) DEFAULT 'IPD',
  `is_downloaded` tinyint(1) DEFAULT 0,
  `downloaded_at` timestamp NULL DEFAULT NULL,
  `downloaded_by` int(11) DEFAULT NULL,
  `local_filepath` varchar(500) DEFAULT NULL,
  `filename` varchar(255) DEFAULT NULL,
  `file_size` bigint(20) DEFAULT NULL,
  `is_imported` tinyint(1) DEFAULT 0,
  `imported_at` timestamp NULL DEFAULT NULL,
  `import_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_rep_no` (`rep_no`),
  KEY `idx_downloaded` (`is_downloaded`),
  KEY `idx_imported` (`is_imported`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Records of aipn_rep_downloads
-- ----------------------------

-- ----------------------------
-- Table structure for aipn_sessions
-- ----------------------------
DROP TABLE IF EXISTS `aipn_sessions`;
CREATE TABLE `aipn_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `session_id` varchar(255) NOT NULL,
  `hcode` varchar(10) DEFAULT NULL,
  `username` varchar(50) DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user` (`user_id`),
  KEY `idx_active` (`is_active`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Records of aipn_sessions
-- ----------------------------

-- ----------------------------
-- Table structure for ar_adjustments
-- ----------------------------
DROP TABLE IF EXISTS `ar_adjustments`;
CREATE TABLE `ar_adjustments` (
  `adjustment_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_number` varchar(50) NOT NULL,
  `adjustment_type` enum('paid_amount','total_amount','reimport','coa','other') NOT NULL,
  `old_value` decimal(10,2) DEFAULT NULL,
  `new_value` decimal(10,2) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `adjusted_by` int(11) NOT NULL,
  `adjusted_at` datetime DEFAULT current_timestamp(),
  `approved_by` int(11) DEFAULT NULL,
  `approved_at` datetime DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  PRIMARY KEY (`adjustment_id`),
  KEY `adjusted_by` (`adjusted_by`),
  KEY `approved_by` (`approved_by`),
  KEY `idx_ar_number` (`ar_number`),
  KEY `idx_status` (`status`),
  CONSTRAINT `ar_adjustments_ibfk_1` FOREIGN KEY (`adjusted_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ar_adjustments_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ar_adjustments
-- ----------------------------

-- ----------------------------
-- Table structure for ar_adjustment_requests
-- ----------------------------
DROP TABLE IF EXISTS `ar_adjustment_requests`;
CREATE TABLE `ar_adjustment_requests` (
  `request_id` int(11) NOT NULL AUTO_INCREMENT,
  `issue_id` int(11) NOT NULL,
  `ar_number` varchar(50) NOT NULL,
  `adjustment_type` enum('paid_amount','total_amount','reimport','coa','other') NOT NULL,
  `old_value` varchar(255) DEFAULT NULL,
  `new_value` varchar(255) DEFAULT NULL,
  `reason` text NOT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `requested_by` int(11) NOT NULL,
  `requested_at` datetime DEFAULT current_timestamp(),
  `reviewed_by` int(11) DEFAULT NULL,
  `reviewed_at` datetime DEFAULT NULL,
  `review_note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`request_id`),
  KEY `issue_id` (`issue_id`),
  KEY `requested_by` (`requested_by`),
  KEY `reviewed_by` (`reviewed_by`),
  KEY `idx_status` (`status`),
  KEY `idx_ar_number` (`ar_number`),
  CONSTRAINT `ar_adjustment_requests_ibfk_1` FOREIGN KEY (`issue_id`) REFERENCES `ar_validation_issues` (`issue_id`),
  CONSTRAINT `ar_adjustment_requests_ibfk_2` FOREIGN KEY (`requested_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ar_adjustment_requests_ibfk_3` FOREIGN KEY (`reviewed_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ar_adjustment_requests
-- ----------------------------

-- ----------------------------
-- Table structure for ar_notifications
-- ----------------------------
DROP TABLE IF EXISTS `ar_notifications`;
CREATE TABLE `ar_notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `issue_id` int(11) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('validation_issue','assignment','resolution','approval') DEFAULT 'validation_issue',
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` datetime DEFAULT current_timestamp(),
  `read_at` datetime DEFAULT NULL,
  PRIMARY KEY (`notification_id`),
  KEY `issue_id` (`issue_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_read` (`is_read`),
  CONSTRAINT `ar_notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ar_notifications_ibfk_2` FOREIGN KEY (`issue_id`) REFERENCES `ar_validation_issues` (`issue_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ar_notifications
-- ----------------------------

-- ----------------------------
-- Table structure for ar_payment_source_history
-- ----------------------------
DROP TABLE IF EXISTS `ar_payment_source_history`;
CREATE TABLE `ar_payment_source_history` (
  `history_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_id` int(11) NOT NULL COMMENT 'รหัสลูกหนี้',
  `old_payment_source` varchar(50) DEFAULT NULL COMMENT 'ช่องทางเดิม',
  `new_payment_source` varchar(50) NOT NULL COMMENT 'ช่องทางใหม่',
  `old_note` text DEFAULT NULL COMMENT 'หมายเหตุเดิม',
  `new_note` text DEFAULT NULL COMMENT 'หมายเหตุใหม่',
  `reason` text DEFAULT NULL COMMENT 'เหตุผลการเปลี่ยนแปลง',
  `changed_by` int(11) NOT NULL COMMENT 'ผู้เปลี่ยนแปลง (user_id)',
  `changed_at` datetime DEFAULT current_timestamp() COMMENT 'วันที่เปลี่ยนแปลง',
  PRIMARY KEY (`history_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_changed_at` (`changed_at`),
  KEY `fk_changed_by` (`changed_by`),
  CONSTRAINT `fk_ps_history_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='ประวัติการเปลี่ยนแปลงช่องทางรับชดเชย';

-- ----------------------------
-- Records of ar_payment_source_history
-- ----------------------------

-- ----------------------------
-- Table structure for ar_payment_transactions
-- ----------------------------
DROP TABLE IF EXISTS `ar_payment_transactions`;
CREATE TABLE `ar_payment_transactions` (
  `transaction_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_id` int(11) NOT NULL COMMENT 'รหัสลูกหนี้',
  `receipt_id` int(11) DEFAULT NULL COMMENT 'รหัสใบเสร็จ (ถ้ามี)',
  `transaction_type` enum('payment','write_off','adjustment','reversal') NOT NULL DEFAULT 'payment' COMMENT 'ประเภทรายการ',
  `transaction_date` datetime NOT NULL COMMENT 'วันที่ทำรายการ',
  `amount` decimal(15,2) NOT NULL COMMENT 'จำนวนเงินที่ตัด (บวกหรือลบ)',
  `description` text DEFAULT NULL COMMENT 'รายละเอียด',
  `payment_source` enum('claim_rep','claim_statement','cash','transfer_insurance','transfer_compulsory','transfer_other','write_off','other') DEFAULT NULL COMMENT 'แหล่งที่มาของเงิน',
  `created_by` int(11) DEFAULT NULL COMMENT 'ผู้บันทึก',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`transaction_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_receipt_id` (`receipt_id`),
  KEY `idx_transaction_date` (`transaction_date`),
  KEY `idx_transaction_type` (`transaction_type`),
  KEY `fk_ar_trans_user` (`created_by`),
  KEY `idx_ar_date` (`ar_id`,`transaction_date`),
  KEY `idx_date_type` (`transaction_date`,`transaction_type`),
  CONSTRAINT `fk_ar_trans_ar_id` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_trans_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `finance_receipts` (`receipt_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_trans_user` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางเก็บประวัติการชำระ/ตัดลูกหนี้';

-- ----------------------------
-- Records of ar_payment_transactions
-- ----------------------------

-- ----------------------------
-- Table structure for ar_submissions
-- ----------------------------
DROP TABLE IF EXISTS `ar_submissions`;
CREATE TABLE `ar_submissions` (
  `submission_id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_number` varchar(50) NOT NULL,
  `submission_type` enum('new','adjustment') NOT NULL,
  `from_role` enum('insurance','accounting') NOT NULL,
  `to_role` enum('accounting','finance') NOT NULL,
  `total_count` int(11) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `pdf_file` varchar(255) DEFAULT NULL,
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `approved_at` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`submission_id`),
  UNIQUE KEY `submission_number` (`submission_number`),
  KEY `created_by` (`created_by`),
  KEY `approved_by` (`approved_by`),
  KEY `idx_submission_status` (`status`),
  CONSTRAINT `ar_submissions_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ar_submissions_ibfk_2` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ar_submissions
-- ----------------------------

-- ----------------------------
-- Table structure for ar_submission_items
-- ----------------------------
DROP TABLE IF EXISTS `ar_submission_items`;
CREATE TABLE `ar_submission_items` (
  `item_id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_id` int(11) NOT NULL,
  `ar_id` int(11) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `adjustment_amount` decimal(15,2) DEFAULT 0.00,
  PRIMARY KEY (`item_id`),
  KEY `fk_ar_sub_items_submission` (`submission_id`),
  KEY `fk_ar_sub_items_ar` (`ar_id`),
  CONSTRAINT `fk_ar_sub_items_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ar_sub_items_submission` FOREIGN KEY (`submission_id`) REFERENCES `ar_submissions` (`submission_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ar_submission_items
-- ----------------------------

-- ----------------------------
-- Table structure for ar_validation_issues
-- ----------------------------
DROP TABLE IF EXISTS `ar_validation_issues`;
CREATE TABLE `ar_validation_issues` (
  `issue_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_number` varchar(50) NOT NULL,
  `issue_type` enum('paid_amount_mismatch','total_amount_mismatch','coa_mismatch') NOT NULL,
  `description` text DEFAULT NULL,
  `system_value` decimal(10,2) DEFAULT NULL,
  `hosxp_value` decimal(10,2) DEFAULT NULL,
  `difference` decimal(10,2) DEFAULT NULL,
  `detected_at` datetime DEFAULT current_timestamp(),
  `detected_by` int(11) NOT NULL,
  `assigned_to` int(11) DEFAULT NULL,
  `status` enum('open','in_progress','resolved','ignored') DEFAULT 'open',
  `resolved_at` datetime DEFAULT NULL,
  `resolved_by` int(11) DEFAULT NULL,
  `resolution_notes` text DEFAULT NULL,
  PRIMARY KEY (`issue_id`),
  KEY `detected_by` (`detected_by`),
  KEY `resolved_by` (`resolved_by`),
  KEY `idx_ar_number` (`ar_number`),
  KEY `idx_status` (`status`),
  KEY `idx_assigned_to` (`assigned_to`),
  CONSTRAINT `ar_validation_issues_ibfk_1` FOREIGN KEY (`detected_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ar_validation_issues_ibfk_2` FOREIGN KEY (`assigned_to`) REFERENCES `users` (`user_id`),
  CONSTRAINT `ar_validation_issues_ibfk_3` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of ar_validation_issues
-- ----------------------------

-- ----------------------------
-- Table structure for chart_of_accounts
-- ----------------------------
DROP TABLE IF EXISTS `chart_of_accounts`;
CREATE TABLE `chart_of_accounts` (
  `coa_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_code` varchar(20) NOT NULL,
  `account_name` varchar(200) NOT NULL,
  `pttype` varchar(10) DEFAULT NULL,
  `pttype_name` varchar(100) DEFAULT NULL,
  `patient_type` enum('OPD','IPD','BOTH') NOT NULL DEFAULT 'BOTH' COMMENT 'ประเภทผู้ป่วย: OPD=ผู้ป่วยนอก, IPD=ผู้ป่วยใน, BOTH=ทั้งสอง',
  `source_type` enum('pttype','query') NOT NULL DEFAULT 'pttype' COMMENT 'ประเภทการดึงข้อมูล: pttype=ตามสิทธิ, query=ตาม Custom Query',
  `custom_query` text DEFAULT NULL COMMENT 'SQL Query สำหรับดึงข้อมูล (ถ้าเลือก source_type=query)',
  `query_description` text DEFAULT NULL COMMENT 'คำอธิบาย Custom Query',
  `priority` int(11) DEFAULT 100 COMMENT 'ลำดับความสำคัญ (น้อยกว่า = ทำก่อน)',
  `payer_code` varchar(10) DEFAULT NULL,
  `payer_name` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`coa_id`),
  KEY `account_code` (`account_code`) USING BTREE,
  KEY `idx_patient_type` (`patient_type`),
  KEY `fk_coa_created_by` (`created_by`),
  KEY `idx_source_type` (`source_type`),
  KEY `idx_priority` (`priority`),
  CONSTRAINT `fk_coa_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=272 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- ----------------------------
-- Table structure for claim_details
-- ----------------------------
DROP TABLE IF EXISTS `claim_details`;
CREATE TABLE `claim_details` (
  `claim_id` int(11) NOT NULL AUTO_INCREMENT,
  `claim_date` datetime DEFAULT NULL,
  `claim_type` enum('manual','imported') DEFAULT 'manual' COMMENT 'ประเภทการเบิก: manual=บันทึกเอง, imported=นำเข้าจาก REP',
  `import_id` int(11) DEFAULT NULL COMMENT 'อ้างอิงจาก claim_imports (optional)',
  `ar_id` int(11) DEFAULT NULL,
  `rep_number` varchar(50) DEFAULT NULL,
  `statement_number` varchar(50) DEFAULT NULL,
  `hn` varchar(20) DEFAULT NULL,
  `vn` varchar(20) DEFAULT NULL,
  `an` varchar(20) DEFAULT NULL,
  `claim_number` int(11) DEFAULT NULL,
  `rep_file` varchar(255) DEFAULT NULL COMMENT 'ไฟล์ REP ที่นำเข้า',
  `claim_amount` decimal(15,2) DEFAULT NULL,
  `approved_amount` decimal(15,2) DEFAULT NULL,
  `difference_amount` decimal(15,2) DEFAULT NULL,
  `reject_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `match_status` enum('matched','unmatched','partial') DEFAULT 'unmatched',
  `status` varchar(20) DEFAULT NULL,
  `remark` varchar(200) DEFAULT NULL,
  `imported_by` int(11) DEFAULT NULL COMMENT 'ผู้นำเข้าข้อมูล (user_id)',
  `imported_at` datetime DEFAULT NULL COMMENT 'วันที่นำเข้าข้อมูล',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`claim_id`),
  KEY `idx_match_status` (`match_status`),
  KEY `idx_claim_type` (`claim_type`),
  KEY `idx_import_id` (`import_id`),
  KEY `fk_claim_ar` (`ar_id`),
  KEY `fk_claim_imported_by` (`imported_by`),
  CONSTRAINT `fk_claim_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_claim_imported_by` FOREIGN KEY (`imported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of claim_details
-- ----------------------------

-- ----------------------------
-- Table structure for claim_errors
-- ----------------------------
DROP TABLE IF EXISTS `claim_errors`;
CREATE TABLE `claim_errors` (
  `claim_error_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_id` int(11) NOT NULL COMMENT 'อ้างอิงไปยัง accounts_receivable',
  `submission_id` int(11) DEFAULT NULL COMMENT 'อ้างอิงไปยัง claim_submissions',
  `rep_file_id` int(11) DEFAULT NULL COMMENT 'อ้างอิงไปยัง rep_files',
  `error_code` varchar(10) NOT NULL COMMENT 'รหัส Error',
  `error_type` enum('C','E','W') NOT NULL COMMENT 'ประเภท Error',
  `insurance_type` varchar(10) DEFAULT NULL COMMENT 'UCS, OFC, LGO, SSS',
  `claim_type` enum('IP','OP','IPCS','OPCS','IPLGO','OPLGO') DEFAULT NULL,
  `error_message` text DEFAULT NULL COMMENT 'ข้อความ Error จาก REP',
  `error_detail` text DEFAULT NULL COMMENT 'รายละเอียดเพิ่มเติม',
  `status` enum('pending','in_progress','resolved','cancelled') DEFAULT 'pending' COMMENT 'สถานะการแก้ไข',
  `detected_at` datetime NOT NULL COMMENT 'วันที่พบ Error',
  `resolved_at` datetime DEFAULT NULL COMMENT 'วันที่แก้ไขสำเร็จ',
  `resolved_by` int(11) DEFAULT NULL COMMENT 'ผู้แก้ไข (user_id)',
  `resolution_note` text DEFAULT NULL COMMENT 'บันทึกการแก้ไข',
  `resubmitted` tinyint(1) DEFAULT 0 COMMENT 'ส่งเคลมใหม่หรือยัง',
  `resubmit_date` datetime DEFAULT NULL COMMENT 'วันที่ส่งเคลมใหม่',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`claim_error_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_submission_id` (`submission_id`),
  KEY `idx_error_code` (`error_code`),
  KEY `idx_error_type` (`error_type`),
  KEY `idx_status` (`status`),
  KEY `idx_insurance_type` (`insurance_type`),
  KEY `idx_claim_type` (`claim_type`),
  KEY `idx_detected_at` (`detected_at`),
  KEY `idx_resolved_at` (`resolved_at`),
  KEY `fk_claim_error_resolved_by` (`resolved_by`),
  CONSTRAINT `fk_claim_error_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_claim_error_resolved_by` FOREIGN KEY (`resolved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of claim_errors
-- ----------------------------

-- ----------------------------
-- Table structure for claim_imports
-- ----------------------------
DROP TABLE IF EXISTS `claim_imports`;
CREATE TABLE `claim_imports` (
  `import_id` int(11) NOT NULL AUTO_INCREMENT,
  `import_type` enum('rep','statement') NOT NULL,
  `file_name` varchar(255) NOT NULL,
  `total_records` int(11) NOT NULL,
  `matched_records` int(11) DEFAULT 0,
  `total_claim_amount` decimal(15,2) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`import_id`),
  KEY `fk_claim_imports_created_by` (`created_by`),
  CONSTRAINT `fk_claim_imports_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of claim_imports
-- ----------------------------

-- ----------------------------
-- Table structure for claim_matching
-- ----------------------------
DROP TABLE IF EXISTS `claim_matching`;
CREATE TABLE `claim_matching` (
  `match_id` int(11) NOT NULL AUTO_INCREMENT,
  `ar_id` int(11) NOT NULL COMMENT 'รหัสลูกหนี้',
  `claim_id` int(11) DEFAULT NULL COMMENT 'รหัสการเบิก',
  `ar_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดลูกหนี้ที่บันทึก',
  `claim_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'ยอดที่เบิกได้จาก REP',
  `approved_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'ยอดที่อนุมัติจริง',
  `difference_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'ส่วนต่าง',
  `match_status` enum('matched','unmatched','partial','over') DEFAULT 'unmatched' COMMENT 'matched=ตรง, unmatched=ไม่มีข้อมูล, partial=ขาด, over=เกิน',
  `match_note` text DEFAULT NULL COMMENT 'หมายเหตุการกระทบ',
  `matched_by` int(11) DEFAULT NULL COMMENT 'ผู้กระทบยอด (user_id)',
  `matched_at` datetime DEFAULT NULL COMMENT 'วันที่กระทบยอด',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`match_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_claim_id` (`claim_id`),
  KEY `idx_match_status` (`match_status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางประวัติการกระทบยอดเคลม';

-- ----------------------------
-- Records of claim_matching
-- ----------------------------

-- ----------------------------
-- Table structure for error_codes
-- ----------------------------
DROP TABLE IF EXISTS `error_codes`;
CREATE TABLE `error_codes` (
  `error_code_id` int(11) NOT NULL AUTO_INCREMENT,
  `error_code` varchar(10) NOT NULL COMMENT 'รหัส Error เช่น C001, E001',
  `error_type` enum('C','E','W') NOT NULL COMMENT 'C=Critical, E=Error, W=Warning',
  `insurance_type` enum('UCS','OFC','LGO','SSS','ALL') DEFAULT 'ALL' COMMENT 'ประเภทประกัน',
  `error_description` text DEFAULT NULL COMMENT 'คำอธิบาย Error',
  `solution_guideline` text DEFAULT NULL COMMENT 'แนวทางการแก้ไข',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`error_code_id`),
  UNIQUE KEY `uk_error_code_type` (`error_code`,`insurance_type`),
  KEY `idx_error_type` (`error_type`),
  KEY `idx_insurance_type` (`insurance_type`)
) ENGINE=InnoDB AUTO_INCREMENT=759 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of error_codes
-- ----------------------------
INSERT INTO `error_codes` VALUES ('45', '101', 'E', 'ALL', 'ไม่มีชื่อ-สกุลผู้ป่วย', 'ใส่ข้อมูลให้ครบ แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('46', '102', 'E', 'ALL', 'ข้อมูลวันเกิดผู้ป่วยใช้ไม่ได้ หรือไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('47', '103', 'E', 'ALL', 'ข้อมูลเพศผู้ป่วยใช้ไม่ได้ หรือไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('48', '104', 'E', 'ALL', 'เลขบัตรประชาชนของผู้ป่วย ใช้ไม่ได้ หรือไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('49', '105', 'E', 'ALL', 'HN ไม่มี หรือใช้ไม่ได้', 'ใส่ข้อมูลให้ครบ แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('50', '106', 'E', 'ALL', 'AN ไม่มี หรือใช้ไม่ได้', 'ใส่ข้อมูลให้ครบ แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('51', '107', 'E', 'ALL', 'วันที่รับไว้หรือวันที่จำหน่ายใช้ไม่ได้ หรือไม่มี', 'ตรวจสอบวันที่รับไว้ หรือ จำหน่ายบันทึกให้ครบถ้วน ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('52', '108', 'E', 'ALL', 'ไม่มีวันที่จำหน่าย', 'ใส่ข้อมูลให้ครบ แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('53', '109', 'E', 'ALL', 'เวลาที่รับไว้ในร.พ.ใช้ไม่ได้ หรือไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('54', '110', 'E', 'ALL', 'เวลาที่จำหน่ายออกจากร.พ.ใช้ไม่ได้ หรือไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('55', '111', 'E', 'ALL', 'ประเภทการจำหน่าย ใช้ไม่ได้/ไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('56', '112', 'E', 'ALL', 'สถานภาพเมื่อจำหน่าย ใช้ไม่ได้/ไม่มี', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('57', '113', 'E', 'ALL', 'ประเภทการจำหน่าย และสถานภาพเมื่อจำหน่าย ไม่สอดคล้องกัน', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('58', '114', 'E', 'ALL', 'น้ำหนักตัวแรกรับ ใช้ไม่ได้ หรือไม่มี (กลุ่มเด็กแรกเกิด)', 'ใส่ข้อมูลให้ครบ/แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('59', '115', 'E', 'ALL', 'ไม่ระบุการใช้สิทธิ หรือ ไม่ต้องการเบิกชดเชยค่าบริการ', 'ตรวจสอบการบันทึกข้อมูล ให้ระบุการใช้สิทธิเพื่อเบิกชดเชยค่าบริการ แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('60', '116', 'E', 'ALL', 'เลขบัตรประชาชนของผู้ป่วย ผิดรูปแบบ', 'เลขบัตรประชาชนต้องเป็นเลขจริงจากบัตรของผป.   ถ้าไม่มีให้ว่างไว้   ถ้าผิดรูปแบบ เช่นไม่ครบ 13 หลัก ให้แก้แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('61', '117', 'E', 'ALL', 'รูปแบบ (Format) การบันทึกข้อมูลการเงินไม่ถูกต้อง', 'แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('62', '118', 'E', 'ALL', 'จากเลขบัตรประชาชน บันทึกเพศไม่ตรงกับเพศที่ตรวจสอบได้ใน สนบท.', 'ตรวจสอบเลขบัตรประชาชน หรือ เพศ บันทึกให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('63', '119', 'E', 'ALL', 'จากเลขบัตรประชาชน บันทึกวัน เดือน ปีเกิด ไม่ตรงกับวัน เดือน ปี เกิดที่ตรวจสอบได้ใน สนบท.', 'ตรวจสอบเลขบัตรประชาชน หรือ วัน เดือน ปี เกิด  บันทึกให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('64', '120', 'E', 'ALL', 'วันที่รับไว้ ก่อนวันเกิด', 'แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('65', '121', 'E', 'ALL', 'วัน/เวลาที่รับไว้ในร.พ. หลังวันที่จำหน่าย', 'แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('66', '122', 'E', 'ALL', 'เป็นข้อมูลสิทธิข้าราชการของหน่วยบริการที่กำหนดให้ส่งในโปรแกรมของ สกส.', 'บันทึกข้อมูลและส่งผ่านโปรแกรมของ สกส.', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('67', '123', 'E', 'ALL', 'วันที่จำหน่าย หลังวันที่ได้รับข้อมูล', 'แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('68', '124', 'E', 'ALL', 'วันที่รับบริการ หลังวันส่งข้อมูลไปที่ สปสช.', 'แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('69', '125', 'E', 'ALL', 'ผู้ป่วยในสิทธิข้าราชการ/อปท.ไม่มีเลขอนุมัติ หรือ บันทึกเลขอนุมัติไม่ถูกต้อง หรือ ไม่มีเลขที่หนังสือส่งตัวจากหน่วยงานต้นสังกัด', 'ผู้ป่วยในสิทธิข้าราชการ/อปท. บันทึกเลขอนุมัติ/เลขที่หนังสือส่งตัวจากหน่วยงานต้นสังกัดให้ถูกต้องครบถ้วน แล้วส่งข้อมูลเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('70', '126', 'E', 'ALL', 'ระยะเวลาที่อยู่ในหน่วยบริการสั้นเกินไป', 'ตรวจสอบ วัน/เวลา ที่ Admit/Discharge แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('71', '127', 'E', 'ALL', 'ข้อมูลผู้ป่วยนอกสิทธิข้าราชการ/อปท.ไม่มีในฐานเบิกจ่ายตรงของหน่วยบริการหรือไม่มีเลขอนุมัติ', 'ตรวจสอบการบันทึกข้อมูล  ผู้ป่วยนอกกรณีสิทธิข้าราชการ/อปท.กรณีไม่ได้ลงทะเบียนเบิกจ่ายตรงหรือไม่มีเลขอนุมัติไม่สามารถบันทึกเบิกผ่านโปรแกรม e-Claim ได้', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('72', '128', 'E', 'ALL', 'เป็นข้อมูลสิทธิข้าราชการ/อปท.ที่รับบริการหรือจำหน่ายก่อน 1 ต.ค 56', 'ข้อมูลสิทธิข้าราชการ/อปท.ที่รับบริการหรือจำหน่ายก่อน 1 ต.ค 56 ให้ส่งเบิกในระบบเดิม', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('73', '129', 'E', 'ALL', 'เป็นข้อมูลจำหน่ายก่อน 1 เม.ย 2556', 'ตรวจสอบข้อมูลที่จำหน่ายก่อน 1 เม.ย 56 ม่ส่งเบิกชดเชยค่าบริการผ่านระบบโปรแกรม e-Claim', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('74', '130', 'E', 'ALL', 'เป็นผู้ป่วยในเกิน 180 วัน แต่ไม่บ่งบอกการยืนยันความจำเป็น เตือนในกรณีวันลา', 'เก็บส่งข้อมูลอีกครั้ง โดยตอบให้แน่นอนว่ายืนยันหรือไม่ยืนยันความจำเป็นในการรักษาเกิน 180 วัน', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('75', '131', 'E', 'ALL', 'ไม่เป็นไปตามเงื่อนไขการเบิกจ่ายกรณี ผู้ป่วยในรักษาข้ามเขต', 'ตรวจสอบการบันทึกข้อมูลในหน้า F4 การเบิกชดเชยกรณีการรรักษาผู้ป่วยในข้ามเขต ต้องเป็นกรณี A/E หรือ รับ Refer เท่านั้น', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('76', '132', 'E', 'ALL', 'ไม่เป็นไปตามเงื่อนไขการเบิกจ่ายกรณีกองทุนโรคเฉพาะ ผู้ป่วยในรักษาข้ามเขต', 'ตรวจสอบการบันทึกข้อมูลในหน้า F4 กรณีผ่าตัดต้อกระจก/สลายนิ่ว/เลเซอร์จากเบาหวานขึ้นจอประสาทตา ผู้ป่วยในรักษาข้ามเขตต้องเป็นกรณีรับ refer เท่านั้น', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('77', '133', 'E', 'ALL', 'บันทึกข้อมูลกรณีใช้หนังสือรับรองสิทธิไม่ครบถ้วน', 'ตรวจสอบการบันทึกข้อมูลกรณีมีหนังสือรับรองสิทธิ บันทึกเลขที่นังสือ รหัสและชื่อหน่วยงานต้นสังกัดให้ครบถ้วน', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('78', '134', 'E', 'ALL', 'ไม่มีเลขที่บัตร ชื่อ-สกุล ของผู้มีสิทธิหลัก กรณีเป็นผู้อาศัยสิทธิ', 'ตรวจสอบการบันทึกข้อมูล กรณีเป็นผู้อาศัยสิทธิ บันทึกเลขที่บัตร ปชช และชื่อ-สกุลของผู้มีสิทธิให้ครบถ้วน', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('79', '135', 'E', 'ALL', 'ไม่ระบุประเภทสิทธิ หรือความสัมพันธ์ กรณีใช้หนังสือรับรองสิทธิ', 'ตรวจสอบการบันทึกข้อมูล กรณีใช้หนังสือรับรองสิทธิ บันทึกประเภทสิทธิและความสัมพันธ์ให้ครบถ้วน', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('80', '136', 'E', 'ALL', 'ข้อมูลผู้ป่วยสิทธิประกันสังคม/ทุพพลภาพ รับบริการก่อน 1 ม.ค 57', 'ข้อมูลผู้ป่วยสิทธิประกันสังคม/ทุพพลภาพที่รับบริการก่อน ก่อน 1 ม.ค 57 ให้ส่งเบิกในระบบเดิมประกันสังคม', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('81', '137', 'E', 'ALL', 'รหัสบัตรประชาชนของผู้มีสิทธิไม่สัมพันธ์กับรหัสของผู้ป่วยกรณีใช้สิทธิตัวเอง', 'ตรวจสอบการบันทึกเลขบัตรประชาชน ทั้งในช่องเลขบัตรผู้ป่วย และเลขบัตรประชาชน (ผู้มีสิทธิ) ในหน้า F1แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('82', '138', 'E', 'ALL', 'รหัสบัตรประชาชนของผู้มีสิทธิไม่สัมพันธ์กับรหัสของผู้ป่วย กรณีใช้ร่วมของบิดาหรือมารดา', 'ตรวจสอบการบันทึกเลขบัตรประชาชน ทั้งในช่องเลขบัตรผู้ป่วย และเลขบัตรประชาชน (ผู้มีสิทธิ) กรณีใช้สิทธิร่วมของบิดา-มารดา แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('83', '139', 'E', 'ALL', 'รหัสบัตรประชาชนของผู้มีสิทธิไม่สัมพันธ์กับรหัสของผู้ป่วย กรณีใช้สิทธิร่วมของบุตร', 'ตรวจสอบการบันทึกเลขบัตรประชาชน ทั้งในช่องเลขบัตรผู้ป่วย และเลขบัตรประชาชน (ผู้มีสิทธิ) กรณีใช้สิทธิร่วมของบุตร แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('84', '140', 'E', 'ALL', 'AN ซ้ำกับรายที่เคยส่งข้อมูลและตรวจผ่านแล้ว', 'ตรวจสอบ AN แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ หรือ หากเป็นข้อมูลซ้ำซ้อนจริงไม่ต้องแก้ไขเป็นการแจ้งเพื่อทราบ', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('85', '141', 'E', 'ALL', 'รหัสบัตรประชาชนของผู้มีสิทธิไม่สัมพันธ์กับรหัสของผู้ป่วย กรณีใช้สิทธิร่วมของคู่สมรส', 'ตรวจสอบการบันทึกเลขบัตรประชาชน ทั้งในช่องเลขบัตรผู้ป่วย และเลขบัตรประชาชน (ผู้มีสิทธิ) กรณีใช้สิทธิร่วมของคู่สมรส แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('86', '142', 'E', 'ALL', 'HN ตรงกับรายที่เคยส่งแล้ว แต่เลขบัตรปชช.13 หลักไม่ตรงกัน', 'ตรวจสอบ HN และเลขบัตรประชาชนของผู้ป่วยให้ถูกต้อง ตรงกัน \n -ถ้าข้อมูลใหม่ผิด แก้ไขให้ถูกต้องแล้วส่งใหม่ \n-ถ้าข้อมูลเดิมผิดแก้ไข EPAC หากยังไม่ตัดยอดออก STM หรือ e-Appeal หากตัดยอดออก STM แล้ว เมื่อข้อมูลนี้ผ่าน A แล้ว จึงส่งข้อมูลที่ติด C นี้เข้ามาอีกครั้ง ', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('87', '143', 'E', 'ALL', 'เพศผู้ป่วยที่บันทึกเบิกไม่ตรงกับ สนบท.', 'ตรวจสอบเพศผู้ป่วยให้ถูกต้อง ตรงกับ สนบท.', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('88', '144', 'E', 'ALL', 'หน่วยบริการได้ขอยกเลิกข้อมูลดังกล่าวแล้ว', 'แจ้งเพื่อทราบ', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('89', '145', 'E', 'ALL', 'รหัสบัตรประชาชนของผู้มีสิทธิหลักไม่ถูกต้องไม่มีใน สนบท.', 'กรณีใช้หนังสือรับรองสิทธิตรวจสอบการบันทึกเลขบัตรประชาชนของผู้มีสิทธิหลัก แก้ไขให้ถูกต้อง แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('90', '146', 'E', 'ALL', 'ผลตรวจสอบสถานพยาบาลหลักไม่ตรงสถานพยาบาลในฐานสำนักงานประกันสังคม', 'ตรวจสอบการบันทึกข้อมูลสถานพยาบาลหลักของผู้ประกันตน บันทึกให้ถูกต้อง ตามสิทธิ ณ วันที่รับบริการ แล้วส่งข้อมูลเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('91', '147', 'E', 'ALL', 'รหัส รพ.รักษาไม่ตรงกับรหัส รพ.หลักกรณีเลือกสถานะ รพ.รักษาเป็น maincontractor หรือรหัส รพ.ที่รักษาและรหัส รพ.หลักเป็นรหัสเดียวกัน แต่สถานะรพ.รักษาไม่ใช่ maincontractor', 'กรณีเลือกสถานะ รพ.ที่รักษาเป็น main contractor รหัส รพ.รักษาต้องตรงกับรหัส รพ.หลัก หรือกรณี รพ.ที่รักษาและ รพ.หลักเป็นรหัสเดียวกัน สถานะรพ.รักษาต้องเป็น maincontractor เท่านั้น', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('92', '148', 'E', 'ALL', 'ไม่ระบุสถานพยาบาลหลักของผู้ประกันตน', 'ระบุสถานพยาบาลหลักของผู้ประกันตน', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('93', '149', 'E', 'ALL', 'สิทธิประกันสังคม ไม่ระบุ maincontractor', 'สิทธิประกันสังคม ระบุ maincontractor', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('94', '150', 'E', 'ALL', 'ผู้ป่วยเข้ารับการรักษาในช่วงเวลาเดียวกันในหน่วยบริการมากกว่า 1 แห่ง (ช่วงเวลาทับซ้อน)', 'โปรดดำเนินการตามที่แจ้งใน http://eclaim.nhso.go.th', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('95', '151', 'E', 'ALL', 'ช่วงการเข้ารับบริการของผู้ป่วยรายเดียวกัน ในหน่วยบริการเดียวกัน มีวัน/เวลาทับซ้อนกันของผู้ป่วยในกับผู้ป่วยใน หรือผู้ป่วยในกับผู้ป่วยนอก', 'ตรวจสอบการบันทึกช่วงวัน/เวลา   การเข้ารับบริการ  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ สิทธิ  \nUC \n -ระยะเวลาการเป็นผู้ป่วยนอกกับผู้ป่วยใน ต้องห่างกันไม่น้อยกว่า 4 ชม. \n -หากระยะเวลาระหว่างผู้ป่วยนอก และ ผู้ป่วยในห่างกันน้อยกว่า 4 ชม. รวมค่าใช้จ่ายบันทึกเบิกมาเป็นกรณีผู้ป่วยในเท่านั้น \nสิทธิข้าราชการ/อปท กรณีรับบริการผู้ป่วยนอกและในภายใน 24 ชม.บันทึกเบิกเป็นผู้ป่วยในเท่านั้น ตรวจตาม ว112 ในสิ่งที่ส่งมาด้วยข้อ 8 โดยตรวจสอบรหัส ICD9', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('96', '152', 'E', 'ALL', 'ส่งข้อมูลเบิกกรณีผู้ป่วยนอกซ้ำซ้อน ในโรคเดียวกัน', 'ตรวจสอบวันที่/เวลาการรับบริการ กรณีรับบริการในวันเดียวกันมากกว่า 1 ครั้ง รวมค่าใช้จ่ายบันทึกเบิกเป็น visit เดียว', '1', '2025-12-22 10:20:30', '2025-12-22 10:20:30');
INSERT INTO `error_codes` VALUES ('97', '153', 'E', 'ALL', 'เด็กแรกเกิด นน.น้อยกว่า 0.5 กก. หรือ มากกว่า 6 กก.', 'ตรวจสอบการบันทึก นน.เด็กแรกเกิด หรือ วัน เดือน ปี เกิด แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('98', '154', 'E', 'ALL', 'สิทธิประกันสังคม ที่ส่งข้อมูลก่อนวันที่ สำนักงานประกันสังคม มีประกาศให้ส่งข้อมูลให้ สปสช.', 'ให้ดำเนินการส่งข้อมูลมาภายในวันที่ สำนักงานประกันสังคม มีประกาศให้ส่งข้อมูลให้ สปสช.', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('99', '155', 'E', 'ALL', 'ไม่ใช่หน่วยบริการในฐานเบิกจ่ายตรงของ สปสช.', 'ตรวจสอบการตั้งค่าการใช้งาน หรือสิทธิประโยชน์ แก้ไชให้ถูกต้อง สิทธิ สปสช.บันทึกเบิกได้เฉพาะหน่วยบริการที่กำหนดเท่านั้น', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('100', '156', 'E', 'ALL', 'รหัสสถานพยาบาลที่รักษาไม่มีในฐานข้อมูลหน่วยบริการ', 'ตรวจสอบการตั้งค่าการใช้งาน แก้ไขการตั้งค่าหน่วยบริการให้ถูกต้อง แล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('101', '157', 'E', 'ALL', 'หน่วยบริการประจำของผู้ป่วยไม่อยู่ในจังหวัดที่เกิดอุทกภัย', 'ตรวจสอบหน่วยบริการประจำของผู้ช่วย กรณีไม่ใช่อยู่ในจังหวัดที่เกิดอุทกภัย บันทึกเบิกตามเงื่อนไข OP/IP ปกติ (ไม่บันทึกรหัสโครงการพิเศษ X38000 อุทกภัยน้ำท่วม)', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('102', '158', 'E', 'ALL', 'สิทธิเจ้าหน้าที่ สปสช.อายุน้อยกว่าเกณฑ์ที่กำหนด', 'ตรวจสอบเลขบัตรประชาชน หรือ วัน เดือน ปี เกิด  บันทึกให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('103', '159', 'E', 'ALL', 'รหัสโรงพยาบาลที่รับส่งต่อ ไม่มีในฐานทะเบียนหน่วยบริการ', 'ตรวจสอบรหัสโรงพยาบาลที่รับ หรือส่งต่อ จะต้องเป็นรหัส 5 หลัก แก้ไขมาให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('104', '160', 'E', 'ALL', 'ไม่มีรหัสประเภทการบริการ (svctype)', 'เฉพาะผู้ป่วยใน ตรวจสอบประเภทบริการ/รักษา  เลือก เป็น IPD หรือ Ambulatory Care  ตามเงื่อนไขที่ต้องการเบิกชดเชย แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('105', '161', 'E', 'ALL', 'รหัสประเภทการบริการ (svctype) ใช้ไม่ได้ หรือไม่มีใน lookup', 'กรณีผู้ป่วยใน ตรวจสอบประเภทบริการ/รักษา ต้องเป็น \n 1= IPD หรือ 2= Ambulatory Care  แก้ไข แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('106', '162', 'E', 'ALL', 'พบว่า Serial Number  ที่บันทึกถูกใช้ในระบบแล้ว', 'ตรวจสอบหมาย serial number  แก้ไขและบันทึกเลขอุปกรณ์ให้ถูกต้อง ครบถ้วน แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('107', '163', 'E', 'ALL', 'ไม่บันทึก Serail NO. ของอุปกรณ์เลนส์แก้วตาเทียมที่ใช้', 'ตรวจสอบการบันทึกข้อมูลในหน้าอวัยวะเทียม/อุปกรณ์บำบัดรักษากรณีใช้เลนส์แก้วตาเทียม บันทึก Serail NO. แล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('108', '164', 'E', 'ALL', 'บันทึกรหัสอุปกรณ์ ไม่ตรงตามรายการอุปกรณ์ที่ประกาศในปีงบประมาณ', 'ตรวจสอบรหัสอุปกรณ์ที่ขอเบิกบันทึกให้ถูกต้องตามเงื่อนไขและราคาของแต่ละช่วงเวลาที่กำหนดหรือปีงบประมาณ แก้ไขแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('109', '165', 'E', 'ALL', 'เกิดจากมีการขอเบิกกรณี Instrument และ OPAE แต่ค่าบริการในส่วนของ Instrument เท่ากับค่าบริการรวม', 'ตรวจสอบค่าบริการที่เรียกเก็บ แก้ไขให้ถูกต้อง ตามการให้บริการ แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('110', '166', 'E', 'ALL', 'กรณีผู้ป่วยนอกไม่มีการบันทึกข้อมูลเบิกชดเชย ทั้งในส่วนของ OPAE , HC, Inst. หรืออื่นๆ', 'ตรวจสอบข้อมูลการขอเบิกชดเชย ว่าเป็นกรณี OPAE ,HC,Inst. หรือ อื่นๆ บันทึกให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('111', '167', 'E', 'ALL', 'เกิดจากบันทึกเบิกอวัยวะเทียม/อุปกรณ์บำบัดรักษาไม่ตรงตามเงื่อนไขที่กำหนด', '1. ตรวจสอบการให้รหัสโรค รหัสหัตถการ ให้ตรงตามเงื่อนไข/ข้อบ่งชี้ของอวัยวะเทียม/อุปกรณ์บำบัดรักษา นั้นๆ \n2. ตรวจสอบราคา อวัยวะเทียม/อุปกรณ์บำบัดรักษาบันทึกเบิกตามราคาที่กำหนดในแต่ละปีงบประมาณ', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('112', '168', 'E', 'ALL', 'เบิกค่าพาหนะไม่ตรงกับสิทธิประโยชน์', 'ตรวจสอบ PID / สิทธิของผู้ป่วย แก้ไขข้อมูลให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีไม่มีสิทธิเบิก ไม่ต้องแก้ไข หรือหากแก้ไขเลือกไม่ใช้สิทธิ', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('113', '169', 'E', 'ALL', 'เกิดจากมีการบันทึกข้อมูลค่าใช้จ่ายเกี่ยวกับค่าพาหนะส่งต่อแต่ไม่ได้ทำการบันทึกข้อมูลระยะทาง', 'ตรวจสอบการบันทึกระยะทาง บันทึกระยะทางให้ถูกต้อง ครบถ้วน และต้องมีรหัสเบิก S1801 มาก่อน S1802 เสมอ', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('114', '170', 'E', 'ALL', 'ยอดรวมค่ารักษาพยาบาล  มีค่าน้อยกว่ายอดเรียกเก็บ', 'ให้ตรวจสอบการบันทึกหรือการนำเข้าข้อมูลครบถ้วนหรือไม่  กรณี OP Refer ตรวจสอบการบันทึกรหัสยา / รหัสหัตถการจากหน้าค่าใช้จ่ายสูงมาบันทึกในหน้าค่ารักษาพยาบาลให้ครบถ้วน  แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('115', '171', 'E', 'ALL', 'เกิดจากมีการบันทึกข้อมูลค่าใช้จ่ายเกี่ยวกับค่ารถส่งต่อ', 'ทำการบันทึกรพ.ที่รับหรือส่งต่อและสาเหตุที่ส่งต่อ \n ๏ กรณีผู้ป่วยนอกไม่ได้ทำการบันทึกข้อมูลหน่วยบริการส่งต่อ \n ๏ กรณีผู้ป่วยในไม่ได้ทำการบันทึกข้อมูลหน่วยบริการรับหรือส่งต่อ', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('116', '172', 'E', 'ALL', 'เกิดจากมีการบันทึกรหัสเบิก IP002-IP006  ในหน้าผู้ป่วยนอก เมนูค่ารักษาพยาบาล ช่องรายการอวัยวะเทียม/อุปกรณ์บำบัดรักษา ซึ่งรหัสนี้จะเบิกได้เฉพาะผู้ป่วยในเท่านั้น', 'กรณีผู้ป่วยนอกให้เบิกในหน้าค่าใช้จ่ายสูงเท่านั้น', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('117', '173', 'E', 'ALL', 'เกิดจากมีการให้รหัสอุปกรณ์ที่ขอเบิกแต่ไม่ได้ทำการบันทึกจำนวนชิ้นหรือจำนวนเงินที่ขอเบิกต่อชิ้น', 'ทำการแก้ไข/บันทึก จำนวนชิ้น/ จำนวนเงินต่อชิ้นของรายการอุปกรณ์ที่ขอเบิก', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('118', '174', 'E', 'ALL', 'เกิดจากมีการให้รหัสโครงการพิเศษ Z34007 ซึ่งเป็นกรณีคลอดบุตรผู้ป่วยต้องเป็นเพศหญิงเท่านั้น', 'ตรวจสอบการบันทึกเพศ หรือ รหัสโครงการพิเศษ แก้ไขการบันทึกเบิกให้ตรงตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('119', '175', 'E', 'ALL', 'บันทึกจำนวนชิ้นของอุปกรณ์มากกว่าที่กำหนด', 'ตรวจสอบการบันทึกจำนวนชิ้นที่ขอเบิกของอวัยวะเทียมและอุปกรณ์บำบัดรักษา แก้ไขให้ถูกต้อง ส่งเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('120', '176', 'E', 'ALL', 'กรณีผู้ป่วยนอกเลือกเงื่อนไขการเรียกเก็บ (A/E/N) แต่ไม่มียอดค่ารักษาพยาบาล', 'ตรวจสอบการบันทึกข้อมูลค่ารักษาพยาบาล  หากต้องการเบิกกรณี OPAE ให้บันทึกยอดที่ต้องการเรียกเก็บ (เบิกได้) ในหน้าค่ารักษาพยาบาล   แต่หากต้องการเบิกเฉพาะกรณี HC/Inst/MO/HD/ยาละลายลิ่มเลือด ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('121', '177', 'E', 'ALL', 'เกิดจากไม่ได้ทำการบันทึกข้อมูลหน่วยบริการที่รักษา', 'ทำการบันทึกข้อมูลหน่วยบริการ (เมนูตั้งค่าระบบ –>ผู้ใช้งานระบบ >>>ตั้งค่าหน่วยบริการ ) และต้องบันทึกข้อมูลใหม่ทั้งราย', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('122', '178', 'E', 'ALL', 'บันทึกค่ารักษาพยาบาลเกินกว่าที่กำหนด', 'ตรวจสอบการบันทึกค่ารักษาพยาบาล  กรณีผู้ป่วยนอกยอดการเรียกเก็บไม่เกิน  xxx,xxx  บาท  กรณีผู้ป่วยใน ยอดการเรียกเก็บไม่เกิน   x,xxx,xxx   บาท', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('123', '179', 'E', 'ALL', 'เกิดจากบันทึกข้อมูลซ้ำซ้อนกันกับข้อมูลที่เคยส่งขอเบิก หรือ มีข้อมูลผู้ป่วยใน admit  วันเดียวกันมากกว่า 1  ครั้ง ในหน่วยบริการเดียวกัน', '1. ตรวจสอบ รหัส HN,AN  หรือ เลขประจำตัวประชาชน + วันที่รักษา +เวลาที่เข้ารับรักษา ว่าซ้ำกับข้อมูลที่ขอเบิกมาก่อนหน้านี้หรือไม่ 2. มีการบันทึกข้อมูลผู้ป่วยใน/ผู้ป่วยนอก ซ้ำซ้อนหรือไม่  กรณีเป็นข้อมูลซ้ำซ้อน ไม่ต้องแก้ไขเข้ามา หรือ หากต้องการแก้ไข ขยับวันที่รับริการไม่ให้ทับซ้อนกันและ เลือกเป็น ไม่ใช้สิทธิ', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('124', '180', 'E', 'ALL', 'ไม่ใช่หน่วยบริการในระบบ หลักประกันสุขภาพแห่งชาติ', 'ตรวจสอบรหัสหน่วยบริการ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('125', '181', 'E', 'ALL', 'ไม่ใช่หน่วยบริการในฐานเบิกจ่ายตรงของกรมบัญชีกลาง หรือ อปท.', 'ตรวจสอบการตั้งค่าการใช้งาน แก้ไชให้ถูกต้อง หรือสิทธิข้าราชการ ติดต่อกรมบัญชีกลาง หรือสิทธิ อปท.ติดต่อ สปสช.เพื่อดำเนินการสมัครเป็นหน่วยบริการเบิกจ่ายตรง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('126', '182', 'E', 'ALL', 'รหัสหน่วยบริการที่บันทึกเบิกไม่สอดคล้องกับการให้บริการตามสิทธิของผู้ป่วย หน่วยบริการสังกัดกรมแพทย์ทหารเรือ/ทหารอากาศ', 'ตรวจสอบการตั้งค่าหน่วยบริการ หรือ สิทธิของผู้ป่วย ตั้งค่าหน่วยบริการที่บันทึกเบิกให้สอดคล้องกับการให้บริการผู้ป่วย เช่น หน่วยบริการสังกัดกรมแพทย์ทหารเรือ/อากาศ ให้บริการพลเรือนต้องตั้งค่าหน่วยบริการตามรหัส 5 หลัก เป็นต้น', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('127', '183', 'E', 'ALL', 'ไม่ใช่หน่วยบริการในฐานเบิกจ่ายค่าบริการของสิทธิ อปท.', 'ตรวจสอบการตั้งค่าการใช้งาน แก้ไชให้ถูกต้อง หรือ ติดต่อ สปสช.เพื่อดำเนินการสมัครเป็นหน่วยบริการเบิกจ่ายตรงของสิทธิ อปท.', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('128', '184', 'E', 'ALL', 'ชื่อ file ที่ส่งไม่ตรงกับสิทธิประโยชน์ที่บันทึกเบิก หรือ ชื่อหน่วยบริการในไฟล์กับหน่วยบริการที่ส่งไม่ตรงกัน หรือ ในไฟล์เดียวกันมี รพ.ที่รักษามากกว่า 1 แห่ง', 'ตรวจสอบชื่อ file ที่ส่งออกกับสิทธิประโยชน์ที่เบิก หรือ รพ.ที่รักษาต้องเป็น 1 หน่วยต่อ 1 ไฟล์ แก้ไขให้ตรงกันแล้วส่งเข้ามาใม่อีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('129', '185', 'E', 'ALL', 'ข้อมูลนำเข้าค่าห้องค่าอาหารไม่มีในรายการที่กำหนด', 'ตรวจสอบรหัสเบิกค่าห้องค่าอาหาร แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('130', '186', 'E', 'ALL', 'ข้อมูลนำเข้ารายการอวัยวะเทียม/อุปกรณ์บำบัดรักษาไม่มีในรายการที่กำหนด', 'ตรวจสอบรหัสรายการอวัยวะเทียม/อุปกรณ์บำบัดรักษา แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('131', '187', 'E', 'ALL', 'ข้อมูลนำเข้ารหัสยามีไม่ครบถ้วนตามเงื่อนไขที่กำหนด (24 หลัก)', 'ตรวจสอบรหัสยา แก้ไขให้ถูกต้อง แล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('132', '188', 'E', 'ALL', 'ข้อมูลนำเข้าเวชภัณฑ์ที่ไม่ใช่ยา ไม่มีในรายการที่กำหนด', 'ตรวจสอบรหัสเบิกเวชภัณฑ์ที่ไม่ใช่ยา แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('133', '189', 'E', 'ALL', 'ข้อมูลนำเข้าในเมนูบริการอื่นๆที่ยังไม่จัดหมวด ไม่มีในรายการที่กำหนด', 'ตรวจสอบรหัสเบิกที่กำหนดให้บันทึกในเมนูบริการอืนๆที่ยังไม่จัดหมวด แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('134', '190', 'E', 'ALL', 'ข้อมูลนำเข้าในเมนูการตรวจวินิจฉัย หมวด 7,8,9 ไม่มีในรายการที่กำหนด', 'ตรวจสอบรหัสเบิกที่กำหนดให้บันทึกในเมนูการตรวจวินิจฉัย หมวด 7,8,9  แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('135', '191', 'E', 'ALL', 'ข้อมูลนำเข้าในเมนูหัตถการและค่าบริการ หมวด 11,12 หน้าค่ารักษาพยาบาล ไม่มีในรายการที่กำหนด', 'ตรวจสอบรหัสเบิกที่กำหนดให้บันทึกในเมนูหัตถการและค่าบริการ หมวด 11,12 หน้าค่ารักษาพยาบาล  แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('136', '192', 'E', 'ALL', 'ข้อมูลนำเข้ารหัสยาไม่มีในฐานของ e-Claim', 'ตรวจสอบความถูกต้องของรหัสยา หากรหัสยาที่นำเข้าครบถ้วนถูกต้อง ส่งรายละเอียดข้อมูลยามาที่ eclaim@live.com เพื่อตรวจสอบต่อไป', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('137', '193', 'E', 'ALL', 'บันทึกเบิกค่าห้องไม่ถูกต้องตามราคาที่ประกาศ', 'ตรวจสอบการบันทึกเบิกค่าห้อง เบิกให้สอดคล้องกับอัตราที่กำนดโดยดูจากวันที่จำหน่าย', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('138', '194', 'E', 'ALL', 'เบิกข้อเข่าเทียมแต่ไม่ระบุรหัสโครงการพิเศษ', 'ตรวจสอบการบันทึกรหัสโครงการพิเศษและรหัสข้อเข่า กรณีบริการซื้อข้อเข่าเอง (KNEE17) หรือเบิกจากองค์การเภสัช (GPOM17) ต้องบันทึกทั้งรหัสข้อเข่าและรหัสโครงการพิเศษให้ครบถ้วน หรือ กรณีบันทึกโครงการพิเศษ GPOM17 ไม่บันทึกรหัสข้อเข่า', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('139', '195', 'E', 'ALL', 'บันทึกเบิกค่ายาไม่เท่ากับราคาใน Drug catalog', 'ตรวจสอบการบันทึกรหัสยา หรือ ราคาที่ขอเบิก บันทึกให้ถูกต้องตรงกัน แก้ไขแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('140', '196', 'E', 'ALL', 'บันทึกเบิกกรณีการให้ยาเคมีบำบัดไม่ถูกต้อง', 'ตรวจสอบการบันทึกรหัสโครงการพิเศษ Z51158 บันทึกได้เฉพาะหน่วยบริการที่ให้ยาเคมีบำบัดระดับ 1 และ 2', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('141', '197', 'E', 'ALL', 'บันทึกเบิกยาละลายลิ่มเลือดกรณี STROKE หรือ STEMI มากกว่า 1 รายการ', 'ตรวจสอบการบันทึกรหัสโรค หรือรายการยา กรณีให้ยาละลายลิ่มเลือด STROKE หรือ STEMI บันทึกเบิกยาได้รายการเดียวเท่านั้น แก้ไขให้ถูกต้องแล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('142', '198', 'E', 'ALL', 'ไฟล์ .ecd เป็นไฟล์ที่ส่งออกจากโปรแกรม E-Claim ก่อนเวอร์ชั่น 2.0', 'Update โปรแกรม E-Claim ให้เป็นเวอร์ชั่นปัจจุบัน', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('143', '199', 'E', 'ALL', 'บันทึกเบิกกรณี STROKE หรือ STEMI  ไม่ถูกต้อง ยกเลิกการบันทึกเบิกใน>>บริการอื่นๆที่ยังไม่จัดหมวด ให้บันทึกเบิกเป็นรายการยา', 'ตรวจสอบการเบิก  STROKE หรือ STEMI ยกเลิกการบันทึกเบิกใน >>บริการอื่นๆที่ยังไม่จัดหมวด ให้บันทึกเบิกเป็นรายการยา', '1', '2025-12-22 10:20:31', '2025-12-22 10:20:31');
INSERT INTO `error_codes` VALUES ('144', '201', 'E', 'ALL', 'ไม่มี รหัสการวินิจฉัยโรคหลัก', 'บันทึกรหัสโรคหลัก แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('145', '202', 'E', 'ALL', 'มีรหัสการวินิจฉัยโรคหลักมากกว่า 1 รหัส', 'ลดรหัสการวินิจฉัยโรคหลักให้เหลือ 1 รหัส แล้วส่งใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('146', '203', 'E', 'ALL', 'รหัสการวินิจฉัยโรคไม่สอดคล้องกับกรณีที่ขอเบิก หรือเป็นรหัสที่ถูกยกเลิก', 'ตรวจสอบการบันทึกรหัสโรค\n 1. บันทึกให้สอดคล้องกับกรณีที่ขอเบิก หรือ ตามเงื่อนไขที่กำหนด / กรณีรหัสแพทย์แผนไทยบันทึกเป็นโรครอง (Sdx.) เท่านั้น \n2. หากเป็นรหัสที่ถูกยกเลิก ตรวจสอบรหัสใหม่ แก้ไขแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('147', '204', 'E', 'ALL', 'รหัสการวินิจฉัยโรคหลัก ไม่สอดคล้องกับเพศ', 'ตรวจสอบการบันทึกเพศ และรหัสการวินิจฉัยโรค\n แก้ไขข้อมูลให้ถูกต้องตามหลักการให้รหัสโรค  แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('148', '205', 'E', 'ALL', 'รหัสการวินิจฉัยโรคหลัก ( Pdx.)  ไม่สอดคล้องกับอายุ', 'ตรวจสอบการบันทึก ว/ด/ป เกิด และรหัสการวินิจฉัยโรคแก้ไขข้อมูลให้ถูกต้อง แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('149', '206', 'E', 'ALL', 'รหัสการวินิจฉัยโรคหลักไม่เหมาะกับการเป็นผู้ป่วยใน ได้แก่ Pdx.= Z13.- , Z76.3 ,รหัส V,W,X,Y', 'ตรวจสอบการบันทึกรหัสการวินิจฉัยโรคหลัก แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('150', '207', 'E', 'ALL', 'รหัสการวินิจฉัยโรคกรณีทารกแรกเกิด ไม่สอดคล้องกับน้ำหนัก', 'ตรวจสอบรหัสการวินิจฉับโรคกรณีทารกแรกเกิด ให้สัมพันธ์กับน้ำหนัก แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('151', '208', 'E', 'ALL', 'รหัสการวินิจฉัยโรคหลักไม่อยู่ในเงื่อนไขที่ให้บันทึกเบิกผ่านระบบโปรแกรม e-Claim', 'ตรวจสอบการให้รหัสโรคหลัก กรณีอยู่ในกลุ่มโรคยกเว้น 14 โรค/การทำฟัน/การ Follow up หรือ การฝากครรภ์ ไม่ต้องบันทึกเบิกผ่านระบบโปรแกรม e-Claim', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('152', '209', 'E', 'ALL', 'รหัสการวินิจฉัยในการคลอดผิดหลัก ICD', 'ตรวจสอบรหัสการวินิฉัยและหัตถการเกี่ยวกับการคลอด แก้ไข แล้วส่งใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('153', '210', 'E', 'ALL', 'จัดกลุ่ม DRG ไม่ได้ ( DRG กลุ่ม 26509)', 'ตรวจสอบการวินิจฉัยโรคหลัก, อายุ, เพศ, น้ำหนัก, จำนวนวันนอน, ชนิดการจำหน่าย ให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('154', '211', 'E', 'ALL', 'รหัสการวินิจฉัยโรคหลักใช้ไม่ได้ (DRG กลุ่ม 26519)', 'ตรวจสอบการให้รหัสการวินิจฉัยโรคหลักให้ถูกต้องตามหลักเกณฑ์การให้รหัสแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('155', '212', 'E', 'ALL', 'รหัสการวินิจฉัยโรคและรหัสหัตถการการคลอดใช้ไม่ได้หรือไม่มี (DRG กลุ่ม 26529)', 'ตรวจสอบการให้รหัสการวินิจฉัยโรคหลัก, การวินิจฉัยโรครอง และรหัสหัตถการให้สอดคล้อง หรือเรียงลำดับการให้รหัสโรคให้ถูกต้องตามหลักเกณฑ์การให้รหัสแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('156', '213', 'E', 'ALL', 'รหัสประเภทโรครองไม่ถูกต้อง', 'ตรวจสอบการให้รหัสประเภทโรครอง  โดยที่รหัสประเภทโรครองต้องไม่ใช่ 1 ( Subclass<>1 )  แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('157', '214', 'E', 'ALL', 'ให้รหัสกลุ่มที่รับไว้ดูแลหลังคลอด ร่วมกับรหัสคลอดปกติ หรือ ให้รหัสกลุ่มที่รับไว้ดูแลหลังคลอดร่วมกับรหัสหัตถการรักษา', 'ตรวจสอบรหัสโรค กรณีคลอดปกติ ต้องไม่มีรหัสกลุ่มที่รับไว้ดูแลหลังคลอด หรือ กรณีรับไว้ดูแลหลังคลอด ต้องไม่มีรหัสหัตถการรักษา', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('158', '215', 'E', 'ALL', 'ให้รหัสโรคความดันโลหิตสูงทำให้เกิดโรคหัวใจ ร่วมกับรหัสโรค Congestive heart failure', 'ตรวจสอบการให้รหัสโรค รหัสโรคความดันโลหิตสูงทำให้เกิดโรคหัวใจ(I110) ไม่สามารถให้ร่วมกับรหัสโรค  Congestive heart failure (I50-,I54-I519) ได้', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('159', '216', 'E', 'ALL', 'ให้รหัสโรคความดันโลหิตสูงทำให้เกิดโรคไต ร่วมกับรหัสโรคไตวาย', 'ตรวจสอบการให้รหัสโรค รหัสโรคความดันโลหิตสูงทำให้เกิดโรคไต (I120) ไม่สามารถให้ร่วมกับรหัสโรคไตวายได้  (N17-,N18-,N19-) ได้', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('160', '217', 'E', 'ALL', 'รหัสโรคหรือรหัตถการไม่สัมพันธ์กับวิธีการคุมกำเนิด', 'ตรวจสอบการให้รหัสโรคหรือรหัตถการ บันทึกให้สัมพันธ์กับวิธีการคุมกำเนิด', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('161', '230', 'E', 'ALL', 'เป็นกรณีอุบัติเหตุ แต่ไม่มีรหัสการวินิจฉัยที่เป็นการบาดเจ็บ หรือมีแต่ใช้ไม่ได้', 'ตรวจสอบการให้รหัสโรค บันทึกให้ถูกต้อง แล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('162', '231', 'E', 'ALL', 'เป็นกรณีอุบัติเหตุ แต่ไม่มีรหัส ICD ของสาเหตุ (V,W,X,Y) หรือมีแต่ใช้ไม่ได้', 'บันทึกรหัสการวินิจฉัยโรคที่เป็นสาเหตุการบาดเจ็บ (V,W,X,Y) แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('163', '232', 'E', 'ALL', 'รหัสวินิจฉัยหลักเป็นการบาดเจ็บ แต่ไม่มีรหัส ICD ของสาเหตุ (V,W,X,Y) หรือมีแต่ใช้ไม่ได้', 'บันทึกรหัสการวินิจฉัยโรคที่เป็นสาเหตุการบาดเจ็บ(V,W,X,Y)  แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('164', '233', 'E', 'ALL', 'ไม่มีรหัส ICD ของสาเหตุภายนอก (External cause) กรณีใช้ พรบ.ผู้ประสบภัยจากรถ', 'ตรวจสอบการบันทึก ICD ของสาเหตุภายนอก (External cause) กรณีใช้ พรบ.ผู้ประสบภัยจากรถต้องมีรหัส V เสมอ  แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('165', '300', 'W', 'ALL', 'รายการที่ขอเบิกไม่อยู่ในเงื่อนไขการจ่ายชดเชย ยอดจ่ายชดเชย = 0 บาท', 'ตรวจสอบรายการที่ขอเบิก เป็นรายการที่เบิกชดเชยได้ตามประกาศหรือไม่  กรณีที่ไม่ต้องการขอเบิกเลือกไม่ใช้สิทธิ แก้ไขให้ถูกต้องและส่งเบิกใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('166', '301', 'W', 'ALL', 'ไม่มีค่าใช้จ่ายในการรักษา หรือ ค่ารักษาพยาบาลเป็นลบ', 'ตรวจสอบการบันทึกข้อมูลค่ารักษาพยาบาล  บันทึกเบิกค่าใช้จ่ายให้ถูกต้อง ครบถ้วน แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('167', '302', 'W', 'ALL', 'ไม่มีรายละเอียดค่าใช้จ่ายราย Item ในหน้าค่ารักษาพยาบาล', 'ตรวจสอบการบันทึกข้อมูลหน้าค่ารักษาพยาบาล ให้บันทึกรายการแบบละเอียด โดยเฉพาะหมวดค่าห้องค่าอาหาร ยาที่ใช้ใน รพ.และค่าบริการทางการพยาบาลรวมทั้งเมนูอื่นๆ บันทึกให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('168', '303', 'W', 'ALL', 'บันทึกรายการยา ไม่มีจำนวนที่ใช้ หรือขอเบิก', 'ตรวจสอบการบันทึกรายการยา ระบุจำนวนที่ใช้หรือขอเบิก ให้ครบถ้วน ส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('169', '304', 'W', 'ALL', 'บันทึกค่าใช้จ่ายแบบสรุป ไม่มีรายละเอียดค่าใช้จ่ายราย Item ในหน้าค่ารักษาพยาบาล', 'ตรวจสอบการบันทึกข้อมูลหน้าค่ารักษาพยาบาล ให้บันทึกรายการแบบละเอียด โดยเฉพาะหมวดค่าห้องค่าอาหาร ยาที่ใช้ใน รพ.และค่าบริการทางการพยาบาลรวมทั้งเมนูอื่นๆ บันทึกให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('170', '305', 'W', 'ALL', 'Approve Code ที่บันทึกเบิกในโปรแกรม e-Claim ไม่ตรงกันฐานข้อมูลของหน่วยบริการ', 'ตรวจสอบ Approve Code แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง กรณีไม่มีเลข Approve Code ไม่สามารถส่งเบิกได้', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('171', '306', 'W', 'ALL', 'ค่าใช้จ่ายที่บันทึกเบิกใน e-Claim ไม่ตรงกับค่าใช้จ่ายในฐานข้อมูลของหน่วยบริการ', 'ตรวจสอบค่าใช้จ่าย แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง กรณีไม่มีค่าใช้จ่ายไม่ต้องส่งเข้ามาในระบบ', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('172', '307', 'W', 'ALL', 'ไม่บันทึกเลข Approve Code หรือ เลข Approve Code ที่บันทึกในโปรแกรม e-Claim ไม่พบในฐานข้อมูลของหน่วยบริการ', 'ตรวจสอบ Approve Code บันทึก หรือ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง กรณีไม่มีในฐานของหน่วยบริการไม่สามารถเบิกได้', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('173', '308', 'W', 'ALL', 'ไวันที่ออก Approve Code หลังวันรับบริการ', 'การดำเนินการในระบบ EDC ผู้ป่วยนอกให้ดำเนินการภายในวัน หรือกรณีเหลื่อมวันสามารถขอในวันถัดไปเท่านั้น', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('174', '309', 'W', 'ALL', 'ไม่มีรหัสเบิกหมวด 6 หมวด 7 หน้าค่ารักษาพยาบาล', 'update version โปรแกรมตามที่แจ้งในหน้าเวบ e-Claim ข้อมูลตั้งแต่ 1 ต.ค 61 เป็นต้นไปบันทึกเบิกตามรหัสที่กำหนดในหมวด 6 และ 7', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('175', '310', 'W', 'ALL', 'บันทึกเบิกรหัสรับส่งต่อผู้ป่วย COVID (COVV01) แต่ไม่มีรหัสค่ารถรับส่งต่อ (S1801,S1802)', 'ตรวจสอบการบันทึกค่ารถรับส่งต่อ กรณีเบิกรหัสรับส่งต่อผู้ป่วย COVID (COVV01) ต้องมีรหัส S1801 และ S1802 หากไม่ได้ส่งต่อ ตัดรหัส COVV01 ออก แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกคร้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('176', '311', 'W', 'ALL', 'มีการบันทึกเบิกค่าพาหนะ และค่าชุด PPE รวมค่าทำความสะอาดฆ่าเชื้อพาหนะ แต่ไม่ระบุสถานที่รับ-ส่งต่อ', 'ตรวจสอบการบันทึกข้อมูลการส่งต่อ กรณีเบิกค่าชุด PPE และค่าทำความสะอาดพาหนะในการส่งต่อ ต้องระบุสถานที่ หรือ รพ.ที่รับส่งต่อ', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('177', '312', 'W', 'ALL', 'บันทึกเบิกค่าห้อง มากกว่าจำนวนวันนอน', 'ตรวจสอบการบันทึกเบิกค่าห้อง เบิกได้ไม่เกินจำนวนวันที่ผู้ป่วย admit', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('178', '313', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ SCRCOV แต่ไม่มีการเก็บตัวอย่างส่งตรวจ หรือการตรวจ Lab', 'ตรวจสอบการบันทึกข้อมูลกรณีการตรวจคัดกรอง COVID19 บันทึกรหัสโครงการพิเศษ SCRCOV และบันทึกรหัสเบิกการเก็บตัวอย่างส่งตรวจหรือการตรวจ LAB ให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('179', '314', 'W', 'ALL', 'ไม่มีรหัสโรค หรือรหัสโครงการพิเศษ กรณีการตรวจคัดกรอง COVID19', 'กรณีเบิก Lab คัดกรอง COVID  หรือ ชุด PPE บันทึกรหัสโครงการพิเศษ SCRCOV และรหัสโรคให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('180', '315', 'W', 'ALL', 'รหัสโรค หรือรหัสโครงการพิเศษไม่สอดคล้องกับการเบิกรหัสรายการที่เกี่ยวข้องกับ COVID19', 'ตรวจสอบการบันทึกรหัสโรคให้สอดคล้องกับการเบิกรหัสรายการที่เกี่ยวข้องกับการรักษา COVID19  แก้ไขให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('181', '316', 'W', 'ALL', 'เป็นหน่วยบริการที่ไม่สามารถเบิกรายการที่เกี่ยวข้องกับ COVID19 ได้', 'ติดต่อ สปสช.เขตพื้นที่เพื่อประเมินศักยภาพหากผ่านการประเมินแล้ว ส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('182', '317', 'W', 'ALL', 'เบิกค่าตรวจ lab covid แต่ไม่บันทึกผลการตรวจ', 'บันทึกผลการตรวจ Lab covid ให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('183', '318', 'W', 'ALL', 'เบิกค่าตรวจ lab covid ไม่ระบุหน่วยบริการที่ส่งตรวจ', 'ระบุหน่วยบริการที่ส่ง lab covid มาตรวจ (รับจาก) ให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('184', '319', 'W', 'ALL', 'เบิกกรณี Screening covid19 เลือกสิทธิประโยชน์ไม่ถูกต้อง', 'ตรวจสอบการเบิกกรณี Screening covid19 หน่วยที่ขึ้นทะเบียนเป็นหน่วยคัดกรองหรือหน่วยตรวจ Lab .ให้เลือกสิทธิประโยชน์เป็น UC ทั้งหมด (ทุกสิทธิ) แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('185', '320', 'W', 'ALL', 'บันทึกเบิกค่าชุด PPE แต่ไม่มีการตรวจ lab', 'ตรวจสอบการบันทึกข้อมูลกรณีเบิกค่าชุด PPE บันทึกการตรวจ Lab มาให้ครบถ้วน หากไม่มีการตรวจ Lab ไม่สามารถเบิกได้', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('186', '321', 'W', 'ALL', 'การเบิกกรณี Screening covid ของสิทธิประกันสังคมบันทึกรหัสหน่วยบริการที่รักษาไม่ถูกต้อง', 'ตรวจสอบการบันทึกหน่วยบริการที่รักษา กรณีเบิก Screening covid หน่วยบริการที่บันทึกเบิกต้องเป็นหน่วยบริการที่รักษาเท่านั้น', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('187', '322', 'W', 'ALL', 'ไม่ใช่ผู้มีสัญชาติไทย ไม่สามารถเบิกกรณีคัดกรอง covid19 จากสำนักงานหลักประกันสุขภาพแห่งชาติได้ (Project =SCRCOV)', 'ตรวจสอบเลขบัตรประชาชน 13 หลักที่บันทึก กรณีไม่ใช่สัญชาติไทยไม่สามารถเบิกกรณีคัดกรอง covid19 จาก สปสช.ได้', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('188', '323', 'W', 'ALL', 'บันทึกเบิกกรณีการรักษา covid19 แต่ไม่ใช่หน่วยบริการในระบบ UC หรือ สถานพยาบาลในระบบเบิกจ่ายตรงของกรมบัญชีกลาง หรือ อปท.', 'กรณีเป็นสถานพยาบาลที่ไม่ใช่หน่วยบริการในระบบ UC หรือ สถานพยาบาลในระบบเบิกจ่ายตรงของกรมบัญชีกลาง รักษา covid19 ให้บันทึกเบิกในโปรแกรม UCEP', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('189', '324', 'W', 'ALL', 'บันทึกรหัสเบิกกรณีการคัดกรอง covid19 ไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'กรณีบันทึกเบิกการคัดกรอง covid19 (Proj code = SCRCOV) จากกองทุน UC ต้องบันทึกรหัสรายการ screening ที่ สปสช.กำหนดเท่านั้น แก้ไขมาให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('190', '325', 'W', 'ALL', 'บันทึก Project code SCRCOV แต่ไม่มีรายการ Lab Screening', 'ตรวจสอบการบันทึกข้อมูลกรณีการตรวจคัดกรอง covid บันทึกรหัสโครงการพิเศษ SCRCOV และรายการ Lab ให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('191', '326', 'W', 'ALL', 'รายการ Lab Screening ที่บันทึกเบิกไม่อยู่ในสิทธิประโยชน์ของประกันสังคม', 'ตรวจสอบการบันทึกรายการ Lab กรณีเบิก srceeing ของสิทธิประกันสังคมเบิกได้เฉพาะ LAB RT-PCR เท่านั้น แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('192', '327', 'W', 'ALL', 'ข้อมูลให้บริการเชิงรุก เลือกเงือนไขการเรียกเก็บไม่ถูกต้อง', 'ตรวจสอบการบันทึกข้อมูลหน้า F1 ช่องเงื่อนไขการเรียกเก็บ กรณีให้บริการเชิงรุกเลือกเงื่อนไขเป็น “บริการเชิงรุก” แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('193', '328', 'W', 'ALL', 'เบิกรายการ Lab คัดกรอง covid มากกว่า 1 รหัส', 'ตรวจสอบการบันทึกรหัส Lab คัดกรอง Covid สามารถตรวจและเบิกได้เพียงรหัสเดียวเท่านั้น', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('194', '329', 'W', 'ALL', 'บันทึกเบิกชุด PPE ร่วมกับค่าบริการเกี่ยวกับกระบวนการ หรืออุปกรณ์อื่นเพื่อป้องกันการแพร่กระจายเชื้อ', 'บันทึกเบิกชุด PPE หรือ ค่าบริการเกี่ยวกับกระบวนการ หรืออุปกรณ์อื่นเพื่อป้องกันการแพร่กระจายเชื้อ สามารถเบิกได้เพียงรหัสเดียวเท่านั้น แก้ไขข้อมูลให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('195', '330', 'W', 'ALL', 'บันทึกรหัสเบิกไม่ถูกต้อง กรณีการตรวจ Covid19 เชิงรุก', 'ตรวจสอบการบันทึกรหัสเบิก กรณีให้บริการเชิงรุกที่เลือกเงื่อนไขเป็น “บริการเชิงรุก” บันทึกรหัสเบิกที่เป็นบริการเชิงรุกเท่านั้นแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('196', '331', 'W', 'ALL', 'บันทึกเบิกเลนส์แก้วตาเทียมแต่ไม่ได้บันทึก Serail Number', 'กรณีเบิกเลนส์แก้วตาเทียม ขอให้บันทึก Serail Number ด้วย แก้ไขแล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('197', '332', 'W', 'ALL', 'บันทึกหัตถการไม่สอดคล้องกับการเบิกเลนส์แก้วตาเทียม', 'กรณีการเบิกเลนส์แก้วตาเทียมมากกว่า 1 ชิ้น ต้องบันทึก Extension code ในหน้าหัตถการให้สอดคล้องกับจำนวนที่ชอเบิก เช่น ผ่าตัด 2 ข้าง บันทึก 1341+21 หรือ 1341+11, 1341+12 ,1371,1372', '1', '2025-12-22 10:20:32', '2025-12-22 10:20:32');
INSERT INTO `error_codes` VALUES ('198', '333', 'W', 'ALL', 'รหัสโรคไม่ถูกต้องกรณีเบิกชดเชยการผ่าตัดต้อกระจก', 'ตรวจสอบการให้รหัสโรค กรณีการผ่าตัดต้อกระจกต้องเป็นโรคหลักที่กำหนด (PDX): H250 หรือ H251 หรือ H252 หรือ H258 หรือ H259', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('199', '334', 'W', 'ALL', 'ไม่ใช่ DRG ในกลุ่ม Cataract ที่กำหนด', 'ตรวจสอบการให้รหัสโรค รหัสหัตถการ ต้องเป็นกลุ่มโรคและหัตถการที่กำหนด แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('200', '335', 'W', 'ALL', 'รหัสหัตถการไม่ถูกต้องกรณีเบิกชดเชยการผ่าตัดต้อกระจก', 'ตรวจสอบการให้รหัสหัตถการ กรณีการผ่าตัดต้อกระจกต้องมีรหัสหัตถการ ที่กำหนด มีรหัสหัตถการ 1319 หรือ 132 หรือ 1341 หรือ 1342 หรือ 1343 หรือ 1351 หรือ 1359 หรือ 1369 หรือ 1371', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('201', '336', 'W', 'ALL', 'บันทึกเบิกกรณีผ่าตัดตาต้อกระจกแต่อายุน้อยกว่า 40 ปี', 'ตรวจสอบการบันทึก วัน เดือน ปีเกิด แก้ไขให้ถูกต้อง หรือ หากอายุน้อยกว่า 40 จริงบันทึกเบิกตามเงื่อนไข OP/IP ปกติ', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('202', '337', 'W', 'ALL', 'ให้รหัสโรคหลัก (Pdx.) ไม่ถูกต้อง', 'รหัสกลุ่ม H54- ให้บันทึกเป็นรหัสโรครอง (Sdx.) เท่านั้น แก้ไขให้ถูกต้องแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('203', '338', 'W', 'ALL', 'ไม่ใช่หน่วยบริการกรณี Conea Transplant', 'ตรวจสอบการบันทึกรหัสหัตถการ กรณีการผ่าตัดเปลี่ยนกระจกตา บันทึกเบิกได้เฉพาะหน่วยบริการที่กำหนดเท่านั้น กรณีไม่ใช่การผ่าตัดเปลี่ยนกระจกตาแก้ไขการบันทึกรหัสหัตถการแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('204', '339', 'W', 'ALL', 'ให้รหัสโรคที่ระบุระดับสายตา (กลุ่ม H54-) ไม่ถูกต้อง', 'ตรวจสอบการบันทึกรหัสโรคที่ระบุระดับสายตา (กลุ่ม H54-) กรณีให้รหัส 2 ข้าง (binocular) แล้วไม่ต้องมีรหัสข้างเดียว (monocular) อีก แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('205', '340', 'W', 'ALL', 'บันทึกเบิกกรณีผ่าตัดต้อกระจก แต่ให้รหัสโรคที่ยังไม่ระบุระดับสายตา', 'ตรวจสอบการบันทึกรหัสโรคที่ระบุระดับสายตา รหัส H549 ยังไม่ระบุระดับสายตา ไม่สามารถผ่าตัดต้อกระจกได้ ตรวจสอบแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('206', '341', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณีผ่าตัดเปลี่ยนกระจกตา', 'ตรวจสอบการบันทึกรหัสหัตถการ กรณีเลือกรหัสเบิก DMISCnT ในหน้าบริการอื่นที่ยังไม่จัดหมวดต้องเป็นหัตถการผ่าตัดเปลี่ยนกระจกตาเท่านั้น', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('207', '342', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณีผ่าตัดเปลี่ยนกระจกตา', 'ตรวจสอบการบันทึกรหัสหัตถการ กรณีเลือกรหัสเบิก 2011ต้องเป็นหัตถการผ่าตัดเปลี่ยนกระจกตาเท่านั้น', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('208', '343', 'W', 'ALL', 'มีภาวะแทรกซ้อนจากการผ่าตัดต้อกระจก ไม่ระบุการทำหัตถการ', 'ตรวจสอบการบันทึกรหัสหัตถการ กรณีมีภาวะแทรกซ้อนจากการผ่าตัดต้อกระจก บันทึกให้ครบถ้วนแก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('209', '344', 'W', 'ALL', 'เบิกค่าบริการกรณีตรวจ Lab covid ที่ไม่อยู่ในสิทธิประโยชน์สิทธิข้าราชการ/อปท', 'ตรวจสอบการบันทึกค่าตรวจ Lab covid สิทธิข้าราชการ/อปท.เป็นราคาเหมาจ่ายไม่สามารถเบิกค่าบริการตรวจ Lab และค่าเก็บตัวอย่างเพิ่มเติมได้อีก แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('210', '345', 'W', 'ALL', 'เบิกกรณีการตรวจวินิจฉัยด้วยเพท-ซีที สแกน (PET/CT Scan) ไม่ตรงตามข้อบ่งชี้ที่กำหนด', 'บริการตรวจวินิจฉัยด้วยเพท-ซีที สแกน (PET/CT Scan) สามารถเบิกได้กรณี \nการประเมินระยะของโรคมะเร็งปอดชนิดเซลล์ไม่เล็ก (NSCLC) และ การประเมินระยะโรคเริ่มต้นและประเมินการตอบสนองระหว่างให้ยาเคมีบำบัดและหลังสิ้นสุดการรักษาสำหรับผู้ป่วยโรคมะเร็งต่อมน้ำเหลืองชนิดฮอดจ์กิน (HL) เท่านั้น ตรวจสอบรหัสโรค หากไม่เข้าเกณฑ์ไม่สามารถเบิกการตรวจวินิจฉัยด้วยเพท-ซีที สแกน (PET/CT Scan)  ได้', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('211', '346', 'W', 'ALL', 'ข้อมูลบริการก่อนวันที่กำหนดให้เบิกกรณีการตรวจวินิจฉัยด้วยเพท-ซีที สแกน (PET/CT Scan) ตามเงื่อนไขที่กำหนด', 'ตรวจสอบวันที่รับบริการ กรณีบริการก่อนวันที่ 7 มิ.ย. 64 ไม่สามารถเบิกการตรวจวินิจฉัยด้วยเพท-ซีที สแกน (PET/CT Scan) ตามข้อบ่งชี้ที่กำหนดได้', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('212', '347', 'W', 'ALL', 'เป็นหน่วยบริการที่ไม่มีศักยภาพในการเบิกรายการVaccine-induced immune thrombotic thrombocytopenia (VITT)', 'ตรวจสอบการบันทึกรหัส 070001 หรือ 30115 หรือ 30116 ยกเลิกรหัสนี้แล้วส่งข้อมูลเข้ามาใหม่เพื่อรับค่าใช้จ่ายอื่นๆ ตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('213', '348', 'W', 'ALL', 'ไม่ใช่หน่วยบริการรับส่งต่อทั่วไปไม่สามารถเบิกกรณี Home Isolation ได้', 'หน่วยบริการที่สามารถให้การรักษากรณี Home Isolation ได้ต้องเป็นหน่วยบริการรับส่งต่อทั่วไปในระบบหลักประกันสุขภาพแห่งชาติเท่านั้น', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('214', '349', 'W', 'ALL', 'ไม่พบข้อมูลการ Authentication', 'ข้อมูลบริการสิทธิ UC ต้องรูดบัตร Smart card หรือบันทึกเลขบัตรเพื่อขอเลข Authentication ทุกครั้งในวันที่ให้บริการ หรือ admit', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('215', '350', 'W', 'ALL', 'เบิกรหัสรายการ Home Isolation หรือ Community Isolation แต่ไม่ใช่ผู้ติดเชื้อ Covid19', 'ตรวจสอบรหัสโรค กรณีเบิกรหัส 080001  หรือ COVR05 หรือ COVR06 หรือ 045009 หรือ 045008 ต้องเป็นผู้ป่วย Covid19 positive (U071) เท่านั้น  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีไม่ใช่ผู้ป่วยติดเชื้อ Covid19 ยกเลิกรหัสข้างต้น แล้วส่งเข้ามาใหม่เพื่อรับค่าใช้จ่ายอื่นๆตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('216', '351', 'W', 'ALL', 'เบิกค่าชุด/อุปการณ์/กระบวนการป้องกัน รหัส 045008 ไม่มีข้อมูลการดูแลผู้ป่วยกรณี Home Isolation หรือ Community Isolation', 'ตรวจสอบการบันทึกข้อมูลหากไม่ใช่การดูแลผู้ป่วยกรณี Home Isolation หรือ Community Isolation (รหัสเบิก COVR05 หรือ COVR06) ไม่สามารถเบิกรหัส  045008 ได้ แก้ไขให้ครบถ้วน ถูกต้องตามเงื่อนไขที่กำหนดแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('217', '352', 'W', 'ALL', 'ข้อมูลเบิกค่าฉีดวัคซีนเป็นบริการก่อนวันที่กำหนดให้เบิกผ่านโปรแกรม e-Claim', 'ข้อมูลการฉีดวัคซีนก่อนวันที่ …..ก.พ. 64 ไม่เข้าเกณฑ์การเบิกจ่ายจาก สปสช.', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('218', '353', 'W', 'ALL', 'เบิกค่าอุปกรณ์หรืออวัยวะในการบำบัดรักษา/กรณีจ่ายเพิ่มสำหรับคนพิการ ไม่ถูกต้องตามแนวทางที่กำหนด', 'ให้เบิกผ่านสำนักงานสาขาเขตพื้นที่/ช่องทางการเบิกชดเชยตามที่กำหนด', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('219', '354', 'W', 'ALL', 'เบิกค่าอุปกรณ์/กรณีจ่ายเพิ่มสำหรับคนพิการ แต่ไม่พบสิทธิย่อยคนพิการ (ท.74)', 'ให้ตรวจสอบการบันทึกรหัสอุปกรณ์ กรณีเป็นอุปกรณ์ผู้พิการให้เบิกผ่านสาขาเขต หรือ หากไม่ใช่แก้ไขรหัสอุปกรณ์ที่ขอเบิก (ไม่ใช่เฉพาะกลุ่มผู้พิการ)  แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('220', '355', 'W', 'ALL', 'รายการ Instument ที่บันทึกเบิกถูกยกเลิกโดยกรมบัญชีกลาง', 'ตรวจสอบอุปกรณ์ที่บันทึกเบิก รหัส 9101,9102 และ 9103 ถูกยกเลิกตามหนังสือ ที่ กค 422.2/ ว118  ลงวันที่ 29 มีนาคม 2554', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('221', '356', 'W', 'ALL', 'เบิกอุปกรณ์ผู้พิการมากกว่า 1 รายการในวันเดียวกัน', 'ตรวจสอบการบันทึกเบิกอุปกรณ์สำหรับผู้พิการ เบิกได้ 1 คนต่อรายการในวันเดียวกัน', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('222', '357', 'W', 'ALL', 'หน่วยบริการบันทึกเบิกอุปกรณ์ผู้พิการ ไม่ใช่หน่วยบริการในเขต กทม.', 'การบันทึกเบิกอปุกรณ์ผู้พิการในโปรแกรม e-Claim ต้องเป็นหน่วยบริการในเขต กทม เท่านั้น ส่วนหน่วยบริการเขตอื่นๆ บันทึกเบิกในโปรแกรมเดิม', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('223', '358', 'W', 'ALL', 'เบิกอุปกรณ์รหัส 8301,8302  แต่ไม่ใช่สิทธิว่างจากกรณีหน่วยบริการถูกยกเลิกในเขต กทม.', 'ไม่ใช่ผู้มีสิทธิว่างจากกรณีหน่วยบริการถูกยกเลิกในเขต กทม.ไม่สามารถเบิกอุปกรณ์รหัส 8301,8302 ได้', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('224', '359', 'W', 'ALL', 'เบิกอุปกรณ์ผู้พิการกรณีเป็นผู้ป่วยใน', 'การเบิกอุปกรณ์คนพิการ เบิกได้เฉพาะกรณี OP เท่านั้น', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('225', '360', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ R9OPCH เฉพาะหน่วยบริการในเขต 9 นครราชสีมาเท่านั้น', 'กรณีไม่ใช่หน่วยบริการในเขต 9 นครราชสีมาไม่ต้องบันทึกรหัสโครงการพิเศษ R9OPCH แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('226', '361', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ R9OPCH หรือ R9OPFS แต่เป็นการให้บริการในหน่วยบริการประจำของผู้ป่วย', 'รหัสโครงการพิเศษ R9OPCH หรือ  R9OPFS บันทึกกรณีให้บริการข้ามเครือข่ายภายในจังหวัดของเขต 9 เท่านั้น กรณีรับบริการในหน่วยบริการประจำของผู้ป่วยไม่สามารถเบิกผ่าน e-Claim ได้', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('227', '362', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ R9OPCH แต่เป็นการให้บริการข้ามจังหวัดกับหน่วยบริการประจำ', 'รหัสโครงการพิเศษ R9OPCH บันทึกกรณีให้บริการข้ามเครือข่ายภายในจังหวัดของเขต 9 เท่านั้น กรณีข้ามจังหวัดบันทึกเบิกตามเงื่อนไข OPAE หรือ OP Refer ตามเงื่อนไขปกติ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('228', '363', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ R9OPFS เฉพาะหน่วยบริการในเขต 9 นครราชสีมาเท่านั้น', 'กรณีไม่ใช่หน่วยบริการในเขต 9 นครราชสีมาไม่ต้องบันทึกรหัสโครงการพิเศษ R9OPFS แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('229', '364', 'W', 'ALL', 'บันทึกเงื่อนไขการเรียกเก็บเป็น OP Refer เป็นการให้บริการในจังหวัด', 'กรณีให้บริการข้ามเครือข่ายภายในจังหวัดของเขต 9 ให้บันทึกรหัสโครงการพิเศษ R9OPCH ไม่เลือกเงื่อนไขการเรียกเก็บ OP Refer เนื่องจากใช้กรณีรับส่งต่อข้ามจังหวัดเท่านั้น แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('230', '365', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ R9OPFS หรือ R9OPCH แต่ตรวจสอบสิทธิเป็นผู้ป่วยที่เปลี่ยนหน่วยบริการทันที', 'ผลการตรวจสอบสิทธิเป็นผู้ป่วยเปลี่ยนหน่วยบริการ แก้ไขข้อมูลการเรียกเก็บโดยไม่ต้องบันทึกรหัสโครงการพิเศษ R9OPFS เลือกเงื่อนไขการเรียกเก็บเป็น C และบันทึกค่ารักษาพยาบาลในหน้า F8 ให้ถูกต้องครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('231', '366', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ R9OPFS แต่เป็นกรณีการส่งต่อข้ามจังหวัด', 'กรณีการส่งต่อข้ามจังหวัด ให้เลือกเงื่อนไขการเรียกเก็บเป็น OP Refer โดยไม่ต้องบันทึกรหัสโครงการพิเศษ R9OPFSและบันทึกค่ารักษาพยาบาลในหน้า F8 ให้ถูกต้องครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('232', '367', 'W', 'ALL', 'บันทึกข้อมูลเบิกไม่ถูกต้อง กรณีการเจ็บป่วยที่เป็นอุบัติเหตุ (รหัสโรค S หรือ T)', 'ตรวจสอบการบันทึกข้อมูลเบิกในหน้า F1 กรณีเป็นอุบัติเหตุ (รหัสโรค S หรือ T) เลือกเงื่อนไขการเรียกเก็บเป็น A กรณีบริการในจังหวัดบันทึกรหัสโครงการพิเศษ R9OPCH กรณีให้บริการข้ามจังหวัดไม่ต้องบันทึกรหัสโครงการพิเศษ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('233', '368', 'W', 'ALL', 'ข้อมูลให้บริการปฐมภูมิที่ไหนก็ได้ เขต 7 บันทึกเบิกไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'ข้อมูลให้บริการปฐมภูมิที่ไหนก็ได้ เขต 7 บันทึกรหัสโครงการพิเศษ R7OPGR บันทึกให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('234', '369', 'W', 'ALL', 'บันทึกเบิกกรณีให้บริการปฐมภูมิที่ไหนก็ได้ เขต 7 (R7OPNC) รหัสโรคไม่ตรงตามเงื่อนไขที่กำหนด', 'ตรวจสอบรหัส ICD10 แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่อีกครั้ง กรณีเป็นโรคที่ไม่ตรงตามเงื่อนไขที่กำหนดให้เบิกตามระบบปกติ', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('235', '370', 'W', 'ALL', 'ข้อมูลการเบิกของหน่วยบริการปฐมภูมิไม่เข้าเกณฑ์การเบิกจ่ายผ่านระบบโปรแกรม e-Claim', 'หน่วยบริการปฐมภูมิเบิกค่าใช้จ่ายตามแนวทางที่เขตหรือจังหวัดกำหนด', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('236', '371', 'W', 'ALL', 'ไม่เข้าเกณฑ์การเบิกอุบัติเหตุฉุกเฉินข้ามจังหวัด', 'การเบิกกรณีอุบัติเหตุฉุกเฉินข้ามจังหวัดตาม Model 5 เขต กทม.ต้องเป็นคลินิกที่มีสถานะเป็นปฐมภูมิ หรือศูนย์บริการสาธารณสุขที่มีสถานะเป็นปฐมภูมิ หรือหน่วยบริการประจำเท่านั้น', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('237', '372', 'W', 'ALL', 'ข้อมูลผู้ป่วยนอกในเขตภาคอีสานไม่เข้าเกณฑ์การเบิกจ่ายในโปรแกรม e-Claim', 'ตรวจสอบการบันทึกข้อมูลกรณีให้บริการในจังหวัด กรณีไม่ใช่รับบริการในหน่วยบริการที่กำหนด หรือไม่มีการเบิกรายการอุปกรณ์/อวัยวะเทียม หรือค่าใช้จ่ายสูง ไม่เข้าเกณฑ์การส่งเบิกในโปรแกรม e-Claim', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('238', '373', 'W', 'ALL', 'บันทึกเบิกค่าดูแลผู้ป่วย Covid19 ที่บ้าน (COVR05)  ร่วมกับ ค่าดูแลผู้ป่วย Covid19 ในชุมชน (COVR06) หรือข้อมูลรับบริการตั้งแต่ 1 มีนาคม 2565 มีข้อมูลเบิกรหัสเหมาจ่าย COVR14,COVR15,COVR16,COVR17 หรือ COVR22 มาพร้อมกัน', 'ตรวจสอบการบันทึกรหัส COVR05 และ COVR06 หรือ COVR14,COVR15,COVR16,COVR17 หรือ COVR22สามารถเบิกได้เพียงรหัสเดียวไม่สามารถเบิกร่วมกันได้ แก้ไขใหถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('239', '374', 'W', 'ALL', 'เบิกค่ารถรับจากที่พักแต่ไม่ใช่ผู้ป่วยติดเชื้อ Covid19', 'ตรวจสอบรหัสโรค กรณีเบิกค่ารถรับจากที่พักต้องเป็นผู้ป่วยติดเชื้อ Covid19 แล้วเท่านั้น แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('240', '375', 'W', 'ALL', 'เบิกค่าอุปกรณ์สำหรับผู้ป่วย Covid19 ที่บ้าน หรือชุมชน แต่ไม่มีการให้บริการที่บ้านหรือชุมชน', 'ตรวจสอบการบันทึกรหัส 045009,145009,145016,145017,145018 หากไม่ใช่ผู้ป่วยที่ดูแลที่บ้าน (รหัส COVR05,COVR11) หรือ ชุมชน (รหัส COVR06,COVR12) ไม่สามารถเบิกได้ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('241', '376', 'W', 'ALL', 'เบิกรายการ x-ray ผู้ป่วยนอก  ไม่เป็นไปตามเงื่อนไขการเบิกกรณีผู้ป่วย Covid19', 'ตรวจสอบการบันทึกรหัส x-ray (080001) กำหนดให้เบิกได้กรณีผู้ป่วยโควิท (U071) เท่านั้น หากไม่ใช่ตัดรหัสนี้ออก แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('242', '377', 'W', 'ALL', 'เบิกค่าออกซิเจนไม่สัมพันธ์กับจำนวนวันที่ดูแลผู้ป่วย HI/CI', 'ตรวจสอบการบันทึกจำนวนออกซิเจน สามารถเบิกได้ไม่เกินจำนวนวันที่ดูแลผู้ป่วยใน HI/CI', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('243', '378', 'W', 'ALL', 'บันทึกรหัสเบิกกรณีโควิด 19 ไม่ตรงตามสิทธิประโยชน์', 'ตรวจสอบรหัสเบิกที่เกี่ยวข้องกับโควิด 19 กรณีผลการตรวจเป็นบวก ให้บันทึกรหัสเบิกตามสิทธิของผู้ป่วย และตามช่องทางการส่งเบิกที่กำหนด (สกส.หรือ สปสช.) กรณีส่ง สปสช.แก้ไขรหัสเบิกให้ถูกต้องตามสิทธิแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('244', '379', 'W', 'ALL', 'บันทึกเบิกค่าใช้จ่ายการแพร่กระจายเชื้อสำหรับบุคลากรที่จัดการศพผู้เสียชีวิตด้วยโรคโควิด-19 ร่วมกับการการตรวจคัดกรองโรคโควิด-19', 'ตรวจสอบการบันทึกรหัสการตรวจคัดกรองโรคโควิด-19 ไม่สามารถเบิกร่วมกับค่าใช้จ่ายการแพร่กระจายเชื้อสำหรับบุคลากรที่จัดการศพผู้เสียชีวิตด้วยโรคโควิด-19 ได้ แก้ไขข้อมูลให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('245', '380', 'W', 'ALL', 'บันทึกเบิกค่าใช้จ่ายการแพร่กระจายเชื้อสำหรับบุคลากรที่จัดการศพผู้เสียชีวิตด้วยโรคโควิด-19 ในผู้ป่วยที่ยังไม่เสียชีวิต', 'ตรวจสอบการบันทึกรหัสโครงการพิเศษ DEADCO หรือรหัสบัตรประชาชน กรณียังไม่เสียชีวิตไม่สามารถเบิกรหัสนี้ได้ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('246', '381', 'W', 'ALL', 'บันทึกรหัสเบิกไม่ถูกต้องตรงตามเงื่อนไข หรืออัตราจ่ายที่กำหนด หรือเป็นรหัสเบิกที่ถูกยกเลิก', 'ตรวจสอบวันที่รับบริการ รหัสเบิก เลือกรหัสเบิกและอัตราการจ่ายตามเงื่อนไขและช่วงเวลาที่กำหนด', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('247', '382', 'W', 'ALL', 'รหัสโรค หรือรหัสหัตถการไม่สอดคล้องกับค่าห้องผู้ป่วยโควิด19 (เขียว เหลือง แดง)', 'ตรวจสอบการบันทึกรหัสค่าห้องผู้ป่วยโควิด19 และรหัสโรค แก้ไขให้ถูกต้องตามอาการของผู้ป่วย เขียว เหลือง หรือแดง แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('248', '383', 'W', 'ALL', 'รหัสโรค หรือรหัสหัตถการไม่สอดคล้องกับค่าชุด PPE โควิด19 (เขียว เหลือง แดง แดงเข้ม)', 'ตรวจสอบการบันทึกรหัสค่าชุด PPE ผู้ป่วยโควิด19 และรหัสโรค แก้ไขให้ถูกต้องตามอาการของผู้ป่วย เขียว เหลือง แดง หรือ แดงเข้ม แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('249', '384', 'W', 'ALL', 'บันทึกเบิกรหัส 9302(HI) และ 9303(CI) มาใน VISIT เดียวกัน', 'ตรวจสอบการบันทึกรหัส 9301,9302,9303,9901 ไม่สามารถเบิกร่วมกันได้ แก้ไขเบิกรหัสให้ถูกต้องและส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('250', '385', 'W', 'ALL', 'เบิกชดเชยการเก็บ specimen ทุกรูปแบบซ้ำซ้อนใน 24 ชั่วโมง ใน PID เดียวกัน', 'ตรวจสอบ เลขประจำตัวประชาชน + วันที่รักษา ว่าซ้ำกับข้อมูลที่ขอเบิกมาก่อนหน้านี้หรือไม่ หากยืนยันการเบิกจ่าย อุทธรณ์เป็นเอกสาร', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('251', '386', 'W', 'ALL', 'เบิกชดเชยการค่า lab ทุกรูปแบบซ้ำซ้อนใน 24 ชั่วโมง ใน PID เดียวกัน ที่มีผลเป็น Negative', 'ตรวจสอบ เลขประจำตัวประชาชน + วันที่รักษา ว่าซ้ำกับข้อมูลที่ขอเบิกมาก่อนหน้านี้หรือไม่ หากยืนยันการเบิกจ่าย อุทธรณ์เป็นเอกสาร', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('252', '387', 'W', 'ALL', 'เบิกชดเชยค่า lab RT-PCR ซ้ำซ้อน ใน PID ที่ได้รับการจ่ายชดเชยค่า RT-PCR ไปแล้ว ในช่วงเวลา 3 วัน', 'ตรวจสอบ เลขประจำตัวประชาชน + วันที่รักษา ว่าซ้ำกับข้อมูลที่ขอเบิกมาก่อนหน้านี้หรือไม่ หากยืนยันการเบิกจ่าย อุทธรณ์เป็นเอกสาร', '1', '2025-12-22 10:20:33', '2025-12-22 10:20:33');
INSERT INTO `error_codes` VALUES ('253', '388', 'W', 'ALL', 'เบิกชดเชยค่า lab RT-PCR ซ้ำซ้อน ใน PID ที่ได้รับการจ่ายชดเชยค่า RT-PCR ซ้ำซ้อนใน 24 ชั่วโมง ใน PID เดียวกัน', 'ตรวจสอบ เลขประจำตัวประชาชน + วันที่รักษา ว่าซ้ำกับข้อมูลที่ขอเบิกมาก่อนหน้านี้หรือไม่ หากยืนยันการเบิกจ่าย อุทธรณ์เป็นเอกสาร', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('254', '389', 'W', 'ALL', 'เบิกรหัส COVR22 หรือ 9902 : ค่าบริการดูแลรักษา แบบผู้ป่วยนอกและแยกกักตัวที่บ้าน (OP self Isolation) ซ้ำภายใน 90 วัน ในผู้ป่วยรายเดียวกัน', 'รหัส COVR22 หรือ 9902 : ค่าบริการดูแลรักษา แบบผู้ป่วยนอกและแยกกักตัวที่บ้าน (OP self Isolation) ไม่สามารถเบิกซ้ำภายใน 90 วัน ในผู้ป่วยรายเดียวกันได้', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('255', '390', 'W', 'ALL', 'เบิกกรณี OP Self Isolation หลัง 48 ชม. (รหัส COVR23 หรือ 55080 ) ไม่มีรหัสการดูแลก่อน 48 ชม (รหัส COVR22 หรือ 9902) หรือ ระยะเวลาที่ดูแลยังไม่ครบ 48 ชม. หรือ ดูแลมากกว่า 168 ชม.', 'ตรวจสอบรหัส COVR23 หรือ 55080  สามารถเบิกได้หลังการดูแลผู้ป่วยครบ 48 ชั่วโมง และในผู้ป่วยรายนั้นต้องเบิกรหัส COVR22 หรือ 55080 มาก่อน และระยะเวลาอยู่ในช่วงที่กำหนดเท่านั้น', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('256', '391', 'W', 'ALL', 'เบิกรหัส COVR24,COVR25 แต่ไม่ใช่ร้านขายยา', 'ตรวจสอบการบันทึกเบิกรหัส COVR24,COVR25 ต้องเป็นร้านขายยาเท่านั้น', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('257', '392', 'W', 'ALL', 'รหัสโรค หรือรหัสหัตถการไม่สอดคล้องกับค่าห้องผู้ป่วยโควิด19 (เขียว เหลือง แดง)', 'ตรวจสอบการบันทึกรหัสค่าห้องผู้ป่วยโควิด19 (รหัส COVR19,COVR20,COVR21,21421,21424,21425,21423 )และรหัสโรค แก้ไขให้ถูกต้องตามอาการของผู้ป่วย เขียว เหลือง หรือแดง แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('258', '393', 'W', 'ALL', 'บันทึกเบิกโควิด 19 กรณี HI, CI, เหมาจ่าย, OP SELF ซ้ำใน 90 วัน ในผู้ป่วยรายเดียวกัน', 'ตรวจสอบการบันทึกเบิกโควิด 19 กรณี HI, CI, เหมาจ่าย, OP SELF ไม่สามารถเบิกซ้ำได้ภายใน 90 วัน หากยืนยันการให้บริการและเบิกจ่ายชดเชย อุทธรณ์เป็นเอกสาร', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('259', '404', 'W', 'ALL', 'มีรหัสโครงการฟื้นฟูสมรรถภาพคนพิการ แต่เบิกอุปกรณ์ที่ไม่ได้ระบุว่าเฉพาะคนพิการ', 'ตรวจสอบรหัสอุปกรณ์ที่ขอเบิก ต้องเบิกรายการที่ระบุว่าเฉพาะคนพิการเท่านั้น ทำการแก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('260', '405', 'W', 'ALL', 'บันทึกเบิกค่า Lab HCV viral load (HCV RNA-Quantitative) หรือ APRI score/FIB-4score หรือ Fibro Scan หรือ Fibro maker panel เกินจำนวนครั้งที่กำหนด', 'ตรวจสอบการบันทึกรหัส Lab HCV viral load (HCV RNA-Quantitative) หรือ APRI score/FIB-4score หรือ Fibro Scan หรือ Fibro maker panel บันทึกให้ถูกต้อง ครบถ้วน กรณีเบิกเกินจำนวนที่กำหนดต่อปีงบประมาณไม่สามารถเบิกได้อีก', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('261', '406', 'W', 'ALL', 'รหัสโรคไม่ถูกต้องกรณีเบิก Lab รักษาโรคไวรัสตับอักเสบซีเรื้อรัง เพื่อสั่งใช้ยาบัญชียา จ2 (SOFVEL)', 'ตรวจสอบการบันทึกรหัสโรค บันทึกให้ถูกต้องตามเงื่อนไขการเบิก  Lab รักษาโรคไวรัสตับอักเสบซีเรื้อรัง เพื่อสั่งใช้ยาบัญชียา จ2 (SOFVEL) แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('262', '407', 'W', 'ALL', 'บันทึกเบิก Lab รักษาโรคไวรัสตับอักเสบซีเรื้อรัง เพื่อสั่งใช้ยาบัญชียา จ2 (SOFVEL) ไม่ถูกต้องตามโปรแกรมที่กำหนด', 'ตรวจสอบวันที่รับบริการ ข้อมูลบริการก่อนวันที่ 1 ตุลาคม 2564 เบิกผ่านโปรแกรมระบบบัญชียา จ2', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('263', '408', 'W', 'ALL', 'โครงการเด็กแรกเกิดเสียชีวิตก่อนลงทะเบียน ไม่ระบุประเภทและชนิดการจำหน่าย', 'ระบุประเภทและชนิดการจำหน่ายเป็นเสียชีวิต ( Dead) หรือ ส่งต่อ (Transfer) แล้วส่งใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('264', '409', 'W', 'ALL', 'โครงการเด็กแรกเกิดเสียชีวิตก่อนลงทะเบียน (รหัสโครงการพิเศษ Z39000) ไม่ระบุวันเดือนปีเกิดของผู้ป่วย', 'ระบุวันเดือนปีเกิดผู้ป่วยและต้องเป็นเด็กแรกเกิดมาแล้วมีชีวิตแล้วเสียชีวิตก่อนลงทะเบียนเลือกหน่วยบริการ', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('265', '410', 'W', 'ALL', 'โครงการเด็กแรกเกิดเสียชีวิตก่อนลงทะเบียน (รหัสโครงการพิเศษ Z39000) ไม่ระบุสัญชาติของผู้ป่วย', 'ต้องระบุสัญชาติของผู้ป่วย คือ สัญชาติไทย', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('266', '411', 'W', 'ALL', 'เด็กแรกเกิดสิทธิข้าราชการ/อปท. (รหัสโครงการพิเศษ Z38000) อายุมากกว่า 28 วัน', 'ตรวจสอบการบันทึกข้อมูล วันเดือน ปี เกิด และรหัสโครงการพิเศษ Z38000 อายุต้องไม่เกิน 28 วัน แก้ไขแล้วส่งเข้ามาใม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('267', '412', 'W', 'ALL', 'กรณีศูนย์สำรองเตียง (Z75REF) ไม่ระบุหน่วยบริการที่ส่งต่อ (Refer-in)', 'ให้บันทึกข้อมูลหน่วยบริการส่งต่อ (Refer-in) แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('268', '413', 'W', 'ALL', 'ศูนย์สำรองเตียง (Z75REF) เบิกได้เฉพาะกรณีผู้ป่วยในเท่านั้น', 'ตรวจสอบการบันทึกรหัสโครงการพิเศษ Z75REF  ศูนย์สำรองเตียงเบิกได้กรณีผู้ป่วยในเท่านั้น \nกรณีรักษาเป็นผู้ป่วยนอกเอารหัสโครงการพิเศษออก แล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง ( ยกเว้น รพ.ศรีสวรรค์ 12044 )', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('269', '414', 'W', 'ALL', 'บันทึกเบิก Telemedicine แต่เป็นข้อมูลบริการก่อน 1 ธ.ค. 63', 'ข้อมูลให้บริการ Telemedicine สามารถเบิกเข้ามาในระบบได้ต้องเป็นข้อมูลบริการตั้งแต่วันที่ 1 ธ.ค. 63 เป็นต้นไป', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('270', '415', 'W', 'ALL', 'บันทึกเบิก Telemedicine แต่ไม่ใช่หน่วยบริการที่กำหนด', 'การเบิกกรณีบริการ Telemedicine สามารถเบิกได้เฉพาะหน่วยบริการที่กำหนดเท่านั้น', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('271', '416', 'W', 'ALL', 'บันทึกเบิก Telemedicine ไม่ใช่สิทธิ UC หรือผู้พิการประกันสังคม', 'การเบิกกรณีบริการ Telemedicine สามารถเบิกได้เฉพาะสิทธิ UC หรือผู้พิการประกันสังคมเท่านั้น สิทธิประโยชน์อื่นไม่สามารถเบิกได้', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('272', '417', 'W', 'ALL', 'โครงการผู้ป่วยสิทธิประกันสังคมส่งเงินสมทบไม่ครบ 7 เดือน เข้ารับบริการคลอดระบุโรคไม่ถูกต้อง', 'ให้แก้ไขการให้รหัสโรคให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('273', '418', 'W', 'ALL', 'ไม่มีสิทธิเบิกกรณีฝากครรภ์', 'กรณีฝากครรภ์ใช้ได้เฉพาะสิทธิประกันสังคมส่งเงินสมทบไม่ครบ 7 เดือนเท่านั้น \n กรณีส่งเสริมป้องกันโรค ฝากครรภ์ ตรวจหลังคลอด วางแผนครอบครัว ส่งใน OPPP Individual Data', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('274', '419', 'W', 'ALL', 'ไม่ระบุเพศผู้ป่วย กรณีฝากครรภ์', 'ระบุเพศผู้ป่วยต้องเป็นเพศหญิง แล้วส่งใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('275', '420', 'W', 'ALL', 'รหัสโรคไม่ถูกต้องกรณีฝากครรภ์', 'ให้แก้ไขการให้รหัสโรคให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('276', '421', 'W', 'ALL', 'รหัสโรคไม่ถูกต้องกรณีหลังคลอด / ตรวจหลังคลอด', 'ให้แก้ไขการให้รหัสโรคให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('277', '422', 'W', 'ALL', 'ไม่ระบุเพศผู้ป่วย กรณี  Family planing', 'ระบุเพศผู้ป่วยต้องเป็นเพศหญิง แล้วส่งใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('278', '423', 'W', 'ALL', 'อายุไม่ถูกต้อง กรณี  Family planing', 'อายุตั้งแต่ 10 ปีขึ้นไปแต่ไม่เกิน 60 ปี', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('279', '424', 'W', 'ALL', 'รหัสโรคไม่ถูกต้อง  กรณี Family planing', 'ให้แก้ไขการให้รหัสโรคให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('280', '425', 'W', 'ALL', 'รหัสหัตถการกรณีวางแผนครอบครัวไม่ถูกต้อง', 'ตรวจสอบการบันทึกรหัสหัตถการให้ตรงตามประเภทการวางแผนครอบครัว แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('281', '426', 'W', 'ALL', 'ไม่มีสิทธิกรณีวางแผนครอบครัว', 'กรณีวางแผนครอบครัวใช้ได้เฉพาะสิทธิประกันสังคมและสิทธิข้าราชการเท่านั้น', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('282', '427', 'W', 'ALL', 'เบิกกรณีคุมกำเนิดในวัยรุ่น อายุไม่อยู่ในช่วง 8-20 ปี (ปีงบฯ 61)/', 'ตรวจสอบการบันทึกข้อมูล วัน เดือน ปี เกิด กรณีการคุมกำเนิดในวัยรุ่นอายุต้องอยู่ในช่วงตั้งแต่ 8 ปีขึ้นไปแต่ไม่ถึง 20 ปี บริบูรณ์ (ปีงบฯ 61)/ กรณีคุมกำเนิดต้องมีอายุมากกว่า 8 ปีขึ้นไป (ปีงบฯ 62) \nเบิกกรณีคุมกำเนิดในวัยรุ่น อายุน้อยกว่า 8 ปี (ปีงบฯ 62)', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('283', '428', 'W', 'ALL', 'เบิกกรณีคุมกำเนิดในวัยรุ่น มากกว่า 1 รายการ และมากกว่า 1 ครั้งต่อปีงบประมาณในสถานพยาบาลเดียวกัน', 'ตรวจสอบการเบิกกรณีคุมกำเนิดในวัยรุ่น สามารถเบิกได้ 1 รายการ และ 1 ครั้งต่อปีงบประมาณในสถานพยาบาลเดียวกัน', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('284', '429', 'W', 'ALL', 'เป็นการเบิกกรณีคุมกำเนิดในวัยรุ่น ที่รับบริการหรือจำหน่ายก่อน 1 ต.ค 57', 'ข้อมูลเบิกกรณีคุมกำเนิดในวัยรุ่น ที่ส่งเบิกผ่านโปรแกรม e-calim เฉพาะข้อมูลที่รับบริการหรือจำหน่ายตั้งแต่ 1 ต.ค 57  เป็นต้นไป', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('285', '430', 'W', 'ALL', 'หน่วยบริการและสถานบริการที่ขึ้นทะเบียนกับ สปสช. เขต กทม. ยกเว้น รพ. สมุทรสาคร ไม่สามารถเบิกกรณีคุมกำเนิดกึ่งถาวรในวัยรุ่น, ANC, PAP SMEAR, ยุติการตั้งครรภ์ที่ปลอดภัยและวางแผนครอบครัว ผ่านโปรแกรม e-claim ได้', 'หน่วยบริการและสถานบริการที่ขึ้นทะเบียนกับ สปสช. เขต กทม. ยกเว้น รพ. สมุทรสาคร เบิกกรณีคุมกำเนิดกึ่งถาวรในวัยรุ่น ANC, PAP SMEAR, ยุติการตั้งครรภ์ที่ปลอดภัย และวางแผนครอบครัว ผ่านโปรแกรม BPPDS', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('286', '431', 'W', 'ALL', 'ไม่ใช่หน่วยบริการที่อยู่ในระบบ UC ไม่สามารถเบิกกรณีคุมกำเนิดกึ่งถาวรในวัยรุ่นผ่านโปรแกรม e-claim ได้', 'หน่วยบริการที่ไม่อยู่ในระบบ UC ไม่สามารถเบิกกรณีคุมกำเนิดกึ่งถาวรในวัยรุ่นผ่านโปรแกรม e-claim ได้', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('287', '432', 'W', 'ALL', 'บันทึกข้อมูลเบิกไม่ตรงตามเงื่อนไขหน่วยบริการที่ขึ้นทะเบียนเป็นหน่วยบริการเฉพาะด้าน PCI', 'ตรวจสอบการบันทึกรหัสโรค รหัสหัตถการแก้ไขให้ถูกต้องตามการทำหัตถการ PCI แล้วส่งเข้ามาใหม่ กรณีไม่ใช่การทำ PCI ไม่สามารถเบิกชดเชยจาก สปสช.ได้', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('288', '433', 'W', 'ALL', 'ไม่ใช่หน่วยบริการในระบบหลักประกันสุขภาพแห่งชาติ ไม่สามารถเบิกกรณีวางแผนครอบครัวได้', 'ตรวจสอบรหัสหน่วยบริการแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีไม่ใช่หน่วยบริการในระบบหลักประกันสุขภาพแห่งชาติ ไม่สามารถเบิกกรณีใส่ห่วงอนามัย (FP001) และ ยาฝัง (FP002) ได้', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('289', '434', 'W', 'ALL', 'เบิกกรณีคุมกำเนิดในวัยรุ่น ใน 1 รายการ มากกว่า 1 ครั้งต่อปีงบประมาณ', 'ตรวจสอบการเบิกกรณีคุมกำเนิดในวัยรุ่น สามารถเบิกได้ 1 รายการ และ 1 ครั้งต่อปีงบประมาณเท่านั้น', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('290', '435', 'W', 'ALL', 'เลือก Project code SNAP การฟื้นฟูสมรรถภาพกึ่งเฉียบพลัน จำนวนวันนอนน้อยกว่า 4 วัน', 'ตรวจสอบการบันทึกวันรับบริการและวันจำหน่าย หรือการบันทึก Project code SNAP  จำนวนวันนอนต้อง 4  วันขึ้นไปจึงจะสามารถเบิกกรณีนี้ได้', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('291', '436', 'W', 'ALL', 'เลือก Project code SNAP การฟื้นฟูสมรรถภาพกึ่งเฉียบพลันแต่ไม่ใช่หน่วยบริการที่กำหนด', 'การบันทึก Project code SNAP กรณีการฟื้นฟูสมรรถภาพกึ่งเฉียบพลัน ในเขต 3,5,12 เบิกได้เฉพาะหน่วยบริการที่กำหนดเท่านั้น', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('292', '437', 'W', 'ALL', 'เลือก Project code SNAP การฟื้นฟูสมรรถภาพกึ่งเฉียบพลันรหัสโรค/รหัสหัตถการไม่ตรงตามเงื่อนไขที่กำหนด', 'การบันทึก Project code SNAP กรณีการฟื้นฟูสมรรถภาพกึ่งเฉียบพลัน เบิกได้ตามเงื่อนไขโรคและหัตถการที่กำหนดเท่านั้น กรณีให้บริการตรงตามเงื่อนไขแก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('293', '438', 'W', 'ALL', 'เลือกเงื่อนไขสิทธิประโยชน์ ไม่ตรงตามสิทธิที่พึงเบิกได้', 'ตรวจสอบสิทธิ และเลือกสิทธิประโยชน์ในการเบิกชดเชยค่าบริการให้ตรงตามสิทธิ  กรณีเบิกชดเชยไม่ตรงกับสิทธิหลักตรวจสอบรหัสโครงการพิเศษ เลือกให้สอดคล้องกับสิทธิและกรณีที่ขอเบิก หรือ บันทึกข้อมูลให้ถูกต้องตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('294', '439', 'W', 'ALL', 'กรณีที่เบิกไม่ตรงตามเงื่อนไขสิทธิประโยชน์ที่กำหนด', 'ตรวจสอบการเบิกกรณีดังต่อไปนี้ \n 1. การเบิกส่วนต่างค่าฟอกเลือด \n 2. ค่าคลอด ครรภ์ที่ 1-2 \n 3. ค่าทำฟันไม่เกิน 300 บาท/ครั้ง และไม่เกิน 900 บาท/ปี 5. ฆ่าตัวตายหรือจงใจให้ผู้อื่นทำร้าย(ฆ่าตัวตายแต่ไม่ตาย) \n6. การทำแท้งผิดกฏหมาย \n7. การเบิก Vescular acess ซ้ำภายใน 2 ปี \n เบิกได้เฉพาะสิทธิหลักประกันสังคมเท่านั้น สิทธิรองเป็นข้าราชการ/อปท.', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('295', '440', 'W', 'ALL', 'ใช้สิทธิ UC แต่ประเภทบัตรไม่ใช่บัตรประชาชน', 'ให้เลือกประเภทบัตรเป็น ” บัตรประชาชน” แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('296', '441', 'W', 'ALL', 'เลือก Project code SNAP การฟื้นฟูสมรรถภาพกึ่งเฉียบพลัน ข้อมูลการรับบริการไม่อยู่ในช่วงเวลาที่กำหนด', 'การบันทึก Project code SNAP กรณีการฟื้นฟูสมรรถภาพกึ่งเฉียบพลัน เบิกได้เฉพาะข้อมูลจำหน่ายตั้งแต่ 1 ตุลาคม 2559  ถึง 25 กันยายน 2562 กรณีให้บริการตรงตามเงื่อนไขแก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('297', '442', 'W', 'ALL', 'กรณีโรคเฉพาะที่ขอเบิกไม่เป็นไปตามเงื่อนไขอุบัติเหตุฉุกเฉิน ได้แก่ กรณีสลายนิ่ว และเลเซอร์จากเบาหวานขึ้นจอประสาทตา ไม่ควรเบิกเป็นเป็น AE', 'ตรวจสอบการบันทึกข้อมูลเบิกกรณี สลายนิ่วและเลเซอร์จากเบาหวานขึ้นจอประสาทตา ไม่เข้าเกณฑ์ AE ให้บันทึกเบิกตามเงื่อนไขที่กำหนด (ไม่บันทึกเป็นกรณี AE) แก้ไขแล้วส่งเข้ามาใม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('298', '443', 'W', 'ALL', 'เบิกยาละลายลิ่มเลือดในผู้ป่วย  STROKE  ไม่สอดคล้องกับปีงบประมาณ', 'ตรวจสอบราคากลางกรณีเบิกยาละลายลิ่มเลือดในผู้ป่วย STROKE ของแต่ละปีงบประมาณ   แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('299', '444', 'W', 'ALL', 'เบิกยาละลายลิ่มเลือดในผู้ป่วย  STROKE / STEMI แต่รหัส ICD-10 / ICD-9-CM ไม่สอดคล้องกับกรณีที่ขอเบิก', 'แก้ไขรหัส ICD-10 / ICD-9-CM ให้ถูกต้องตามที่กำหนด แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('300', '445', 'W', 'ALL', 'เลือกรหัสโครงการพิเศษ DMISRC แต่เป็นการให้บริการก่อน 1 ม.ค. 53', 'บันทึกรหัสโครงการพิเศษ DMISRC เฉพาะข้อมูลการให้บริการตั้งแต่ 1 ม.ค. 53  เป็นต้นไป', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('301', '446', 'W', 'ALL', 'เลือกรหัสโครงการพิเศษ  DMISHD แต่ไม่มีรหัสรายการ Vascular access', 'เลือกรหัสรายการ Vascular access (HD0001-HD0005) ที่ต้องการขอเบิก  รหัสใดรหัสหนึ่ง แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('302', '447', 'W', 'ALL', 'รหัส ICD10, ICD9  ไม่สอดคล้องกับการขอเบิกกรณี Vascular access ในผู้ป่วยไตวายเรื้อรังระยะสุดท้าย', 'ตรวจสอบการให้รหัสโรค  (ICD10) หรือรหัสหัตถการ (ICD9) แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('303', '448', 'W', 'ALL', 'เลือกรหัสรายการ Vascular access (HD0001 – HD0005) แต่ไม่ได้เลือกรหัสโครงการพิเศษ  DMISHD หรือเป็นการเข้ารับบริการก่อนวันที่ 1 ม.ค. 53', 'กรณีต้องการเบิก  Vascular  access  ( Shunt)  ให้เลือกรหัสโครงการพิเศษ DMISHD   / ตรวจสอบวันเข้ารับบริการตั้งแต่  1 ม.ค. 53  หากไม่ต้องการขอเบิกไม่ต้องเลือกรหัสโครงการ DMISHD  แต่ให้บันทึกข้อมูลให้ถูกต้องตามเงื่อนไขที่ต้องการขอเบิกแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('304', '449', 'W', 'ALL', 'เลือกรหัสโครงการพิเศษ  DMISHD แต่ผู้ป่วยไม่ได้ลงทะเบียนในระบบ DMIS กรณี CAPD', 'ตรวจสอบเลขประจำตัวประชาชน (PID) หรือวันที่เข้ารับบริการให้ถูกต้อง  หรือให้บันทึกขอเบิกในระบบปกติโดยไม่ต้องเลือกรหัสโครงการพิเศษ DMISHD', '1', '2025-12-22 10:20:34', '2025-12-22 10:20:34');
INSERT INTO `error_codes` VALUES ('305', '450', 'W', 'ALL', 'ข้อมูลเบิกชดเชยค่าบริการไม่ตรงตามเงื่อนไขกรณีเลเซอร์จากเบาหวานขึ้นจอประสาทตา', 'การเบิกชดเชยค่าบริการกรณีเลเซอร์จากเบาหวานขึ้นจอประสาทตาเริ่มกับข้อมูลให้บริการ (OP)/จำหน่าย (IP) ตั้งแต่ 1 มกราคม 2557 ข้อมูลก่อนหน้านี้ให้เบิกตามเงื่อนไข OP/IP ปกติ (ไม่ต้องเลือกรหัสโครงการพิเศษ DMIDML)', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('306', '451', 'W', 'ALL', 'เลือกรหัสโครงการพิเศษ DMIDML แต่รหัส ICD-10 / ICD-9-CM ไม่สอดคล้องกับกรณีที่ขอเบิก', 'แก้ไขรหัส ICD-10 / ICD-9-CM ให้ถูกต้องตามที่กำหนด แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('307', '452', 'W', 'ALL', 'บันทึกข้อมูลเบิกกรณีเลเซอร์จากเบาหวานขึ้นจอประสาทตาไม่ถูกต้อง ครบถ้วน', 'ตรวจสอบการบันทึกเบิกเลเซอร์จากเบาหวานขึ้นจอประสาทตา ต้องมีรหัสโครงการพิเศษ DMIDML และรหัสเบิก DMIDML ในเมนู บริการอื่นที่ยังไม่จัดหมวด แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('308', '453', 'W', 'ALL', 'ไม่ใช่หน่วยบริการที่ลงทะเบียนในระบบ DMIS กรณี CAPD', 'หน่วยบริการที่สามารถส่งข้อมูลเบิกชดเชย กรณี Vascular  access ได้ต้องเป็นหน่วยบริการที่ลงทะเบียน ในระบบ DMIS กรณี CAPD เท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('309', '454', 'W', 'ALL', 'รหัสโครงการพิเศษไม่สอดคล้องกับประเภทผู้ป่วย หรือกรณีที่ขอเบิก  หรือรหัสโครงการพิเศษไม่สอดคล้องกับปีงบประมาณ', 'ตรวจสอบ PID / รหัสโครงการพิเศษ / รายการอวัยวะเทียมที่ขอเบิก หรือรหัสโครงการพิเศษ  บันทึกข้อมูลให้สอดคล้องกับกรณี หรือปีงบประมาณที่ขอเบิก  แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('310', '455', 'W', 'ALL', 'รหัสโครงการ Z39000 และ Z75000 ไม่ผ่านการตรวจสอบสิทธิ', '1.  ตรวจสอบ PID/ อายุ  ณ วันที่เข้ารับบริการให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่ \n2.  กรณีเด็กแรกเกิดที่มี PID แล้ว ไม่ต้องบันทึกรหัสโครงการพิเศษ Z39000', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('311', '456', 'W', 'ALL', 'เลือกรหัสโครงการพิเศษ  Z75REF แต่ไม่ใช่หน่วยบริการสำรองเตียง', 'รหัสโครงการพิเศษ  Z75REF สำหรับหน่วยบริการที่เข้าร่วมเป็นหน่วยบริการสำรองเตียงเท่านั้น กรณีไมใช่ให้เอารหัสโครงการพิเศษ  ( Z75REF)  ออกแล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('312', '457', 'W', 'ALL', 'รหัส ICD10, ICD9  ไม่สอดคล้องกับการขอเบิกกรณี Leukemia,Lymphoma', 'แก้ไขรหัส ICD-10 / ICD-9-CM ให้ถูกต้องตามที่กำหนด แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('313', '458', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษสำหรับผู้ประกันตนสิทธิประกันสังคม ไม่สอดคล้องกับสิทธิประโยชน์ที่เลือก', 'กรณีใช้รหัสโครงการพิเศษสำหรับผู้ประกันตนสิทธิประกันสังคม ที่เบิกชดเชยจาก สปสช.ให้เลือกสิทธิประโยชน์เป็น UCS  สิทธิ UC', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('314', '459', 'W', 'ALL', 'ข้อมูลการรักษาผู้ป่วยกรณี Leukemia หรือ Lymphoma ไม่ตรงตามที่ได้ลงทะเบียนในระบบ', 'ตรวจสอบข้อมูลการรักษา( Leukemia หรือ Lymphoma ) ต้องตรงกับข้อมูลที่ได้ลงทะเบียนในระบบ ตลอดระยะเวลา 1  ปี', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('315', '460', 'W', 'ALL', 'ข้อมูลที่ส่งเบิกกรณี Leukemia/Lymphoma  ยังไม่ได้ทำการ Register ในระบบ', 'ทำการ Register กรณี Leukemia/Lymphoma   ในระบบ on line ให้เรียบร้อยแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('316', '461', 'W', 'ALL', 'ข้อมูลของหน่วยบริการที่ส่งเบิกไม่ใช่หน่วยบริการที่ผู้ป่วยลงทะเบียนกรณี  Leukemia/Lymphoma', 'หน่วยบริการที่สามารถส่งข้อมูลเบิกชดเชยกรณี Leukemia/Lymphoma  ได้ต้องเป็นหน่วยบริการที่ผู้ป่วยลงทะเบียนเท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('317', '462', 'W', 'ALL', 'ไม่ใช่หน่วยบริการในโครงการ กรณี Leukemia/Lymphoma', 'ไม่สามารถเบิกชดเชยค่าบริการตามเงื่อนไข Leukemia/Lymphoma ได้  ให้ส่งเบิกในระบบปกติ', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('318', '463', 'W', 'ALL', 'เกิดจากมีการให้รหัสหน่วยบริการ (Hcode) ไม่ถูกต้อง หรือ เป็นรหัสที่ไม่มีในฐานข้อมูลหน่วยบริการของ สปสช.', 'ตรวจสอบรหัสหน่วยบริการ (Hcode) ที่บันทึก แก้ไขให้ถูกต้อง กรณีที่บันทึกถูกต้องแล้ว แจ้งมาที่ eclaim@live.com เพื่อตรวจสอบและเพิ่มในฐานข้อมูลหหน่วยบริการของ สปสช.ต่อไป', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('319', '464', 'W', 'ALL', 'ไม่ใช่หน่วยบริการที่ขึ้นทะเบียนให้บริการ Laser ตา (รหัสโครงการพิเศษ DMIDML)', 'การบันทึกเบิกชดเชยค่าบริการกรณี Laser ตา ได้เฉพาะหน่วยบริการที่ขึ้นทะเบียนให้บริการกับ สปสช.เท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('320', '465', 'W', 'ALL', 'การเบิกกรณี Palliatve Care สามารถบันทึกเบิกได้เฉพาะกรณีผู้ป่วยนอก( OP ) และการรับ refer  ผู้ป่วยนอก ( OP Refer ) เท่านั้น', 'ตรวจสอบข้อมูลการรักษา  กรณีผู้ป่วยในไม่สามารถเบิกกรณี Palliative Care ได้', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('321', '466', 'W', 'ALL', 'รหัสโรค หรือ รหัสหัตถการไม่สอดคล้องกับกรณี Palliative Care', 'ตรวจสอบการบันทึกรหัสโรค/รหัสหัตถการ ต้องมีรหัส Z515 เป็นโรครอง แก้ไขให้ถูกต้องแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('322', '467', 'W', 'ALL', 'รหัสโรค หัตถการตรงตามเงื่อนไขการรักษานิ่วในทางเดินปัสสาวะแต่ไม่บันทึกรหัสโครงการพิเศษ DMISRC', 'ตรวจสอบการบันทึกข้อมูล กรณีการรักษานิ่วในทางเดินปัสสาวะให้บันทึกรหัสโครงการพิเศษ DMISRC แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('323', '468', 'W', 'ALL', 'เป็นหน่วยบริการสำรองเตียงแต่ไม่บันทึกรหัสโครงการพิเศษ Z75REF', 'ตรวจสอบการบันทึกข้อมูลกรณีเป็นหน่วยบริการสำรองเตียงให้บันทึกรหัสโครงการพิเศษ Z75REF แก้ไขแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('324', '469', 'W', 'ALL', 'ไม่ใช่หน่วยบริการที่เข้าร่วมกรณี STROKE/STEMI', 'ตรวจสอบการบันทึกข้อมูล กรณีไม่ได้เข้าร่วมในโครงการ STROKE หรือ STEMI ไม่สามารถบันทึกเบิกยา STEMI1 ,STEMI2 หรือ ยา STROKE1 Altephase ได้ ให้บันทึกเบิกตามเงื่อนไข OP/IP ปกติเท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('325', '470', 'W', 'ALL', 'กรณีเบิกค่าพาหนะรับส่งต่อผู้ป่วยนอกในจังหวัด (SPV001) แต่ไม่ได้บันทึกเบิกขอเบิกค่าพาหนะ', 'ให้บันทึกข้อมูลขอเบิกค่าพาหนะให้ครบถ้วน', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('326', '471', 'W', 'ALL', 'กรณีเบิกค่าพาหนะรับส่งต่อผู้ป่วยนอกในจังหวัด (SPV001)  แต่เป็นหน่วยบริการที่ไม่มีสิทธิเบิกกรณีนี้', '', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('327', '472', 'W', 'ALL', 'กรณีเบิกค่าพาหนะรับส่งต่อผู้ป่วยนอกในจังหวัด (SPV001)  แต่จังหวัดของหน่วยบริการที่รักษาและหน่วยบริการประจำไม่ใช่จังหวัดเดียวกัน', '', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('328', '473', 'W', 'ALL', 'เบิกค่าพาหนะรับส่งต่อ  ระยะทางเกิน 9,999  กิโลเมตร', 'ตรวจสอบระยะทางที่ต้องการขอเบิก  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('329', '474', 'W', 'ALL', 'ยาราคาแพงที่บันทึกเบิกไม่ได้ลงทะเบียนในระบบ OCPA หรือ ไม่ตรงกับรายการยาที่ลงทะเบียนในระบบ OCPA', 'ตรวจสอบรหัสยา บันทึกมาให้ถูกต้อง กรณีไม่ได้ลงทะเบียน Prio Authorize (OCPA) ไม่สามารถเบิกได้', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('330', '475', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับยาราคาแพงที่บันทึกเบิก', 'ตรวจสอบรหัสโรค หรือ รายการยาราคาแพงที่บันทึกเบิก ตรวจสอบแก้ไขให้ถูกต้อง แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('331', '476', 'W', 'ALL', 'รายการค่าห้องที่บันทึกเบิกไม่สอดคล้องกับประเภทผู้ป่วย', 'ตรวจสอบการบันทึกเบิกค่าห้อง กรณีผู้ป่วยนอกบันทึกเบิกได้เฉพาะรหัส  21301 และ 21501 เท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('332', '477', 'W', 'ALL', 'จำนวนวันที่บันทึกเบิกค่าห้อง ไม่สอดคล้องกับจำนวนวันที่นอน รพ. (LOS)', 'ตรวจสอบการบันทึกวันที่จำหน่าย หรือ จำนวนวันที่เบิกค่าห้อง แก้ไขให้ถูกต้อง สอดคล้อง แล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('333', '478', 'W', 'ALL', 'กรณีเบิกส่วนต่างค่าฟอกเลิอด (HD3995) ไม่มีรหัสหัตถการที่สอดคล้องกับข้อมูลเบิก', 'ตรวจสอบการบันทึกรหัสหัตถการ บันทึกถูกต้อง สอดคล้องกับรายการที่ขอเบิก', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('334', '479', 'W', 'ALL', 'ให้รหัสโรคไม่สอดคล้องกับการเบิกส่วนต่างค่าคลอดจากสิทธิข้าราชการ/อปท.', 'ตรวจสอบการบันทึกรหัสโรค บันทึกรหัสโรคคลอดให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('335', '480', 'W', 'ALL', 'รายการที่ขอเบิกชดเชยไม่สอดคล้องกับเงื่อนไขที่กำหนด', 'กรณีรหัสอุปกรณ์ 4506 AICD เบิกได้เฉพาะสถานพยาบาลที่กำหนดเท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('336', '481', 'W', 'ALL', 'ไม่ใช่สถานพยาบาลที่กำหนดให้เบิกชดเชยค่าบริการผ่านระบบโปรแกรม e-Claim', '1. ข้อมูลผู้ป่วยนอกสิทธิประกันสังคมกรณีอุบัติเหตุ/ฉุกเฉิน หรือข้อมูลผู้ป่วยนอก/ใน ผู้ประกันตนทุพลภาพ ที่รักษาในสถานพยาบาลเอกชน ส่งเบิกในระบบเดิมของประกันสังคม \n2. หน่วยบริการที่ขึ้นทะเบียนเฉพาะ HD ส่งเบิกในโปรแกรม HD และโปรแกรม eclaim โดยให้เบิกได้เฉพาะ Vascular Access เท่านั้น', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('337', '482', 'W', 'ALL', 'ข้อมูลเบิกชดเชยค่าบริการไม่ถูกต้องตามเงื่อนไขสิทธิประโยชน์ของผู้ประกันตนทุพลภาพ', 'กรณีคลอดบุตร หรือ ฆ่าตัวตาย สิทธิผู้ประกันตนทุพพลภาพ ไม่สามารถส่งข้อมูลเบิกชดเชยค่าบริการในระบบโปรแกรม e-Claim ได้', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('338', '483', 'W', 'ALL', 'กรณีอุบัติเหตุฉุกเฉินที่ขอเบิกไม่เป็นไปตามเงื่อนไขที่กำหนดให้บันทึกเบิกในระบบโปรแกรม e-Claim', 'หน่วยบริการที่บันทึกข้อมูลเบิกกรณีอุบัติเหตุฉุกเฉินต้องไม่ใช่สถานพยาบาลที่ผู้ประกันตนลงทะเบียน (Main Contractor) หรือ สถานพยาบาลเครือข่าย (Sub contractor)', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('339', '484', 'W', 'ALL', 'บันทึกข้อมูลเบิกการรักษากรณีอุบัติเหตุฉุกเฉินหลัง 72 ชม.(SSAE73) ไม่ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกข้อมูลกรณีอุบัติเหตุฉุกเฉินหลัง 72 ชม.(SSAE73) ให้บันทึกรหัสเบิก SSAE73 ในหน้าค่ารักษาพยาบาล ช่องบริการอื่นที่ไม่จัดหมวดด้วย แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('340', '485', 'W', 'ALL', 'จำนวนวันนอนไม่สอดคล้องกับกรณีที่ขอเบิกอุบัติเหตุฉุกเฉินหลัง 72 ชม.(SSAE73)', 'ตรวจสอบวันที่ admit/discharge กรณีการเบิกอุบัติเหตุฉุกเฉินหลัง 72 ชม.(SSAE73) จำนวนวันนอน(LOS) ต้องไม่น้อยกว่า 3 วัน', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('341', '486', 'W', 'ALL', 'สิทธิประกันสังคมบันทึกเบิกส่วนต่างกรณี HD จากสิทธิ อปท. ไม่ถูกต้อง ครบถ้วน', 'ตรวจสอบการบันทึกเบิกส่วนต่างกรณี HD จากสิทธิ อปท ต้องมีรหัสโครงการพิเศษ HD3995 และรหัสเบิก HD3995 ในเมนู บริการอื่นที่ยังไม่จัดหมวด แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('342', '487', 'W', 'ALL', 'บันทึกข้อมูลเบิกการรักษากรณีอุบัติเหตุฉุกเฉินหลัง 72 ชม.(SSAE73) ไม่ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกข้อมูลกรณีอุบัติเหตุฉุกเฉินหลัง 72 ชม.(SSAE73) ให้บันทึกรหัสเบิก SSAE73 ในหน้าค่ารักษาพยาบาล ช่องบริการอื่นที่ไม่จัดหมวดด้วย แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('343', '488', 'W', 'ALL', 'ไม่ใช่สถานพยาบาลของสำนักงานประกันสังคม', 'ตรวจสอบการตั้งค่าการใช้งาน แก้ไชให้ถูกต้อง หรือ ติดต่อสำนักงานประกันสังคมเพื่อดำเนินการสมัครเป็นสถานพยาบาลในระบบ', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('344', '489', 'W', 'ALL', 'ข้อมูลเบิกชดเชยค่าบริการไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'ข้อมูลสิทธิผู้ประกันตนทุพพลภาพ ไม่สามารถส่งข้อมูลเบิกชดเชยค่าบริการในระบบโปรแกรม e-Claim ได้', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('345', '490', 'W', 'ALL', 'บันทึกข้อมูลเบิกกรณีการฟอกโลหิต ในผู้ป่วยไตวายเฉียบพลันไม่ถูกต้อง ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกรหัสโรค รหัสหัตถการ และการเบิกกรณีการฟอกโลหิต OP หน้า F4 / IP รหัสเบิก IP007 ในหน้าค่ารักษาพยาบาล หมวดอวัยวะเทียมและอุปกรณ์บำบัดรักษา   บันทึกให้ถูกต้อง ครบถ้วน แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('346', '491', 'W', 'ALL', 'บันทึกข้อมูลเบิกกรณีการล้างไตทางช่องท้อง ในผู้ป่วยไตวายเฉียบพลันไม่ถูกต้อง ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกรหัสโรค รหัสหัตถการ และการเบิกกรณีการล้างไตทางช่องท้อง  OP หน้า F4 / IP รหัสเบิก IP008 ในหน้าค่ารักษาพยาบาล หมวดอวัยวะเทียมและอุปกรณ์บำบัดรักษาบันทึกให้ถูกต้อง ครบถ้วน แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('347', '492', 'W', 'ALL', 'บันทึกข้อมูลเบิกกรณีทำหมันไม่ถูกต้อง', 'ตรวจสอบการให้รหัสหัตถการและรหัสเบิกในหน้าค่ารักษาพยาบาล หมวดบริการอื่นที่ยังไม่จัดหมวด เลือกรหัสเบิกให้สอดคล้องกับเพศ', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('348', '493', 'W', 'ALL', 'บันทึกเบิกกรณีฟอกเลือด (HD) มากกว่า 2 ครั้ง/วัน', 'ตรวจสอบการบันทึก จำนวน ที่บันทึกเบิกในหน้า F4 กรณีการฟอกเลือดบันทึกเบิกได้ไม่เกิน 2 ครั้ง/วัน', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('349', '494', 'W', 'ALL', 'HN ไม่ตรงกับ HN ที่ลงทะเบียนยา PA', 'ตรวจสอบ HN ที่บันทึก และ HN ลงทะเบียนยา PA ในหน้าเวบ e-Claim  แก้ไขให้ถูกต้อง ตรงกัน แล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('350', '495', 'W', 'ALL', 'สถานพยาบาลหลักที่บันทึกไม่ตรงกับสถานพยาบาลหลักตามสิทธิของผู้ประกันตน', 'ตรวจสอบวันที่รับบริการ หรือสถานพยาบาลหลักที่บันทึกแก้ไขให้ตรงกับสถานพยาบาลหลักของผู้ประกันตน ณ วันที่รับบริการ แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('351', '496', 'W', 'ALL', 'ไม่ระบุ วัน เดือน ปี ที่ให้รหัสโรค และทำหัตถการ  หรือ วัน เดือน ปี ที่ระบุ ไม่อยู่ในช่วงเวลาที่ผู้ป่วย admit', 'บันทึก วัน เดือน ปี ที่ให้รหัสโรค และทำหัตถการ ให้ครบถ้วนทุกรหัส และตรวจสอบ วัน เดือน ปี ที่บันทึกต้องอยู่ในช่วงที่ผู้ป่วย admit  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('352', '497', 'W', 'ALL', 'รหัสแพทย์ไม่มี หรือ เลข ว.แพทย์ไม่ถูกต้อง', 'ตรวจสอบการบันทึกเลข ว.แพทย์ บันทึกให้ถูกต้องครบถ้วน แก้ไขหรือบันทึกให้ครบถ้สนแล้วส่งมาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('353', '498', 'W', 'ALL', 'บันทึกเบิกค่าห้องผู้ป่วยในฉุกเฉิน แต่ไม่มีข้อมูล อุบัติเหตุ หรือ ฉุกเฉิน', 'ตรวจสอบการบันทึกข้อมูล กรณีเบิกค่าห้องฉุกเฉิน ต้องมีข้อมูลอุบัติเหตุ หรือ ฉุกเฉินในหน้า F4 บันทึกให้ถูกต้อง ครบถ้วน แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('354', '499', 'W', 'ALL', 'ข้อมูลที่บันทึกเบิกไม่อยู่ในสิทธิประโยชน์ กรณีผู้ป่วยนอก', 'ตรวจสอบการบันทึกรหัสโรคหลัก โรครอง และหัตถการ บันทึกให้ถูกต้อง แล้วส่งเข้ามาใหม่ กรณีไม่อยู่ในสิทธิประโยชน์ไม่ต้องส่งเบิกในระบบโปรแกรม e-Claim', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('355', '500', 'W', 'ALL', 'บันทึกเบิกสิทธิประกันสังคมแต่อายุน้อยกว่า 15 ปี', 'ตรวจสอบการบันทึก วัน เดือน ปีเกิด และวันที่รับบริการ ในหน้าข้อมูลทั่วไป แก้ไขให้ถูกต้องแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('356', '501', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกกรณีให้ยาเคมีบำบัด หรือ รังสีรักษา ในผู้ป่วยโรคมะเร็ง', 'ตรวจสอบรหัสโรคกรณีให้ยาเคมีบำบัด หรือรังสีรักษา บันทึกรหัสโรคมะเร็งให้ถูกต้อง/สอดคล้องกับชนิดมะเร็งที่รักษา แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('357', '502', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณี เคมี/รังสี รักษามะเร็ง', 'ให้ตรวจสอบรหัสหัตถการกรณีเคมี/รังสี รักษามะเร็ง และแก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('358', '503', 'W', 'ALL', 'บันทึกเบิกไม่ถูกต้อง ครบถ้วนตามเงื่อนไขที่กำหนดกรณีการรักษามะเร็งตามโปรโตคอล', 'ตรวจสอบการบันทึกเบิกกรณีการรักษามะเร็งตามโปรโตคอล \n1. ข้อมูลที่เริ่มให้การรักษาก่อน 1 ม.ค 56 บันทึกเบิกให้ครบตาม Cycle ที่กำหนด ถึง 30 มิ.ย 56 \n2. ข้อมูลที่เริ่มให้การรักษาตั้งแต่วันที่ 1 ม.ค 56 บันทึกเบิกเป็น Visit แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('359', '504', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณีมะเร็งเต้านม', 'ให้ตรวจสอบรหัสหัตถการกรณีรักษามะเร็งเต้านม และแก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('360', '505', 'W', 'ALL', 'กรณี HBO chamber  เพื่อรักษา Hyperbaric Oxygen Therapy เบิกได้เฉพาะหน่วยบริการที่มีเครื่อง Chamber เท่านั้น', 'เบิกได้เฉพาะหน่วยบริการดังนี้ หน่วยบริการวชิระภูเก็ต,หน่วยบริการอาภากรเกียรติวงศ์, หน่วยบริการสมเด็จพระนางเจ้าสิริกิติ์,รพ.ภูมิพลอดุลยเดช,รพ.สมเด็จพระปิ่นเกล้า,รพ.ตราด', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('361', '506', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกกรณีรักษา Hyperbaric Oxygen Therapy', 'ตรวจสอบรหัสโรคให้สอดคล้องกับการรักษากรณี Hyperbaric Oxygen Therapyและแก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('362', '507', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณีรักษา Hyperbaric Oxygen Therapy', 'ตรวจสอบรหัสหัตถการให้สอดคล้องกับการรักษากรณี Hyperbaric Oxygen Therapyและแก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:20:35', '2025-12-22 10:20:35');
INSERT INTO `error_codes` VALUES ('363', '508', 'W', 'ALL', 'การให้ Methadone Maintenance Treatment จะต้องเป็นหน่วยบริการที่ผ่านการประเมินจากกระทรวงสาธารณสุข', 'เบิกได้เฉพาะหน่วยบริการที่ได้รับอนุญาตจากกระทรวงสาธารณสุข', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('364', '509', 'W', 'ALL', 'กรณีขอเบิกสารเมทาโดนจำนวนที่ขอเบิกต้องไม่เกินจำนวนวันของเดือนที่มารับบริการ', 'ตรวจสอบการบันทึกวัน เดือน ปี ที่ผู้ป่วยมารับบริการ โดยจำนวนวันที่ขอเบิกต้องไม่เกินจำนวนวันของเดือนนั้นๆ', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('365', '510', 'W', 'ALL', 'กรณีขอเบิก Hyperbaric  Oxygen Therapy ผู้ป่วยนอกจำนวนชั่วโมงที่ขอเบิกไม่สอดคล้องกับประเภทการเข้ารับบริการ  ผู้ป่วยในจำนวนชั่วโมงที่ขอเบิกไม่สอดคล้องกับจำนวนวันนอน (LOS)', 'ตรวจสอบจำนวนชั่วโมงที่ขอเบิก  และบันทึกให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('366', '511', 'W', 'ALL', 'ข้อมูลรักษาโรคมะเร็งปีงบประมาณ 58 ส่งได้ตั้งแต่วันที่ 1 ธค 57 เป็นต้นไป', 'ตรวจสอบรหัสโรค กรณีการรักษาโรคมะเร็งที่ให้บริการ/จำหน่ายตั้งแต่วันที่ 1 ต.ค 57 ให้ส่งข้อมูลเบิกชดเชยได้ตั้งแต่วันที่ 1 ธ.ค 57 เป็นต้นไป', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('367', '512', 'W', 'ALL', 'เบิก OPAE ไม่มีเงื่อนไขการเรียกเก็บ หรือ เลือกเงื่อนไขการเรียกเก็บไม่สอดคล้องกับสิทธิ', 'เบิก OPAE ได้เฉพาะ กรณี ดังนี้ \n1. รักษาข้ามจังหวัดกับหน่วยบริการประจำ กรณี A/E \n2. เลือกเงื่อนไขการเรียกก็บเป็น Normal ได้เฉพาะ กรณีสิทธิว่าง (PUC) หรือ สิทธิย่อยผู้พิการ(ท.74) / ทหารผ่านศึก (66,67,75,80,97,98),ทหารเกณฑ์สังกัดกรมแพทย์ทหารเรือ / ทหารอากาศ  รักษาข้ามสังกัด และผู้พิการประกันสังคม (D1) เท่านั้น\n 3. กรณีส่งต่อจากจังหวัดเดียวกับหน่วยบริการประจำทุกกรณีต้องเป็น OP Refer ยกเว้นกรณีลงทะเบียนโดยมติบอร์ด status 009/เบิกฟันเทียม \n4. เบิกกรณีคุมกำเนิดกึ่งถาวรในวัยรุ่น เลือกเงื่อนไขการเรียกเก็บเป็น N/A/E อย่างใดอย่างหนึ่ง', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('368', '513', 'W', 'ALL', 'ขอเบิกอุบัติเหตุฉุกเฉินแต่ไม่พบสิทธิหรือเป็นการให้บริการภายในจังหวัด หรือเป็นโรงพยาบาลที่ผู้ป่วยลงทะเบียนกรณีสิทธิประกันสังคม', 'ตรวจสอบ PID บันทึกให้ถูกต้อง แล้วส่งข้อมูลเข้ามาใหม่ หรือ หากเป็น AE ในจังหวัด หรือ สิทธิประกันสังคมรักษาที่โรงพยาบาลที่ลงทะเบียนไม่ต้องแก้ไข หรือแก้ไขเป็นไม่ใช้สิทธิ', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('369', '514', 'W', 'ALL', 'กรณีเบิกค่าพาหนะรับหรือส่งต่อ ไม่มีรหัสโรงพยาบาลรับหรือส่งต่อ หรือไม่มีสิทธิเบิก', 'ให้ตรวจสอบการว่ามีการบันทึกหน่วยบริการรับหรือส่งต่อหรือชนิดการจำหน่ายหรือตรวจสอบว่าสิทธิของผู้ป่วยตรงตามหลักเกณฑ์การเบิกชดเชยค่ารถ refer หรือไม่', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('370', '515', 'W', 'ALL', 'ไม่ระบุวัตถุประสงค์ในการรับ-ส่งต่อ', 'ให้บันทึกวัตถุประสงค์ในการรับ-ส่งต่อ   แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('371', '516', 'W', 'ALL', 'เบิกกรณีเหตุสมควรหน่วยบริการต้นสังกัดต้องเป็นผู้เบิกเท่านั้น', 'ให้ตรวจสอบการเบิกกรณีเหตุสมควรหน่วยบริการต้นสังกัดต้องเป็นผู้เบิกเท่านั้น', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('372', '517', 'W', 'ALL', 'กรณีที่ขอเบิกไม่เป็นไปตามเงื่อนไขอุบัติเหตุฉุกเฉิน', 'การขอเบิกกรณีนิ่ว หรือ ตาต้อกระจกไม่เข้าเกณฑ์ AE ให้บันทึกเบิกตามเงื่อนไขที่กำหนด (ไม่บันทึกเป็นกรณี AE)', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('373', '518', 'W', 'ALL', 'กรณีการรับส่งต่อ เลือกเงื่อนไขการเรียกเก็บไม่ถูกต้อง', 'กรณีรับส่งต่อจาก รพ.สงขลา (10745) หรือ รพ.หาดใหญ่ (10682) เลือกเงื่อนไขการเรียกเก็บเป็น OP Refer ข้ามจังหวัด', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('374', '519', 'W', 'ALL', 'ประเภทการจำหน่ายเป็น transfer ไม่ระบุสถานพยาบาลที่ส่งต่อ', 'ตรวจสอบการบันทึกข้อมูลการรับส่งต่อ กรณีมีการส่งต่อ ต้องระบุสถานพยาบาลที่ส่งต่อ บันทึกให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('375', '520', 'W', 'ALL', 'เป็นข้อมูลที่เข้าเกณฑ์กรณีการรับส่งต่อผู้ป่วยนอก ( OP Refer )', 'ให้บันทึกเบิกค่าใช้จ่ายเป็นกรณี OP Refer  แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:20:36', '2025-12-22 10:20:36');
INSERT INTO `error_codes` VALUES ('377', '521', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกกรณีรักษาผู้ป่วยเอดส์ที่มีโรคเยื่อหุ้มสมองอักเสบจากเชื้อรา   (Cryptococcal meningitis)', 'ตรวจสอบรหัสโรคกรณีการรักษาผู้ป่วยเอดส์ที่มีโรคเยื่อหุ้มสมองอักเสบจากเชื้อรา (Cryptococcal meningitis) แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่ \n– สิทธิ UC ต้องป็นผู้ป่วย HIV', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('378', '522', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกกรณีล้างไต/ฟอกเลือด ผู้ป่วยไตวายเฉียบพลัน', 'ให้ตรวจสอบรหัสโรคกรณีกรณีล้างไต/ฟอกเลือด ผู้ป่วยไตวายเฉียบพลัน และแก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('379', '523', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณีล้างไต/ฟอกเลือด ผู้ป่วยไตวายเฉียบพลัน', 'ให้ตรวจสอบรหัสหัตถการกรณีกรณีล้างไต/ฟอกเลือด ผู้ป่วยไตวายเฉียบพลัน และแก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('380', '524', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกเคมีบำบัด  กรณีมะเร็งตามโปรโตคอล หรือมะเร็งทั่วไป', 'ตรวจสอบรหัสโรคให้สอดคล้องกับการเบิก  กรณีมะเร็งตามโปรโตคอล หรือมะเร็งทั่วไป แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('381', '525', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกเคมีบำบัด กรณีมะเร็งตามโปรโตคอล', 'ตรวจสอบรหัสหัตถการให้สอดคล้องกับเบิก  กรณีมะเร็งตามโปรโตคอล  แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('382', '526', 'W', 'ALL', 'สิทธิประกันสังคม เบิกกรณีมะเร็ง ที่เข้ารับบริการก่อน 1 ก.ย 56', 'ตรวจสอบวันที่รับบริการ ข้อมูลรับบริการก่อน 1 ก.ย 56 ให้ส่งเบิกตามระบบเดิมของสิทธิประกันสังคม', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('383', '527', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกรังสีรักษา  กรณีมะเร็งตามโปรโตคอล', 'ตรวจสอบการให้รหัสโรค  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('384', '528', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกรังสี  กรณีรักษามะเร็งตามโปรโตคอล', 'ตรวจสอบการให้รหัสหัตถการ  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('385', '529', 'W', 'ALL', 'รายการที่ขอเบิกรังสีรักษา  กรณีมะเร็งตามโปรโตคอล  เป็นการให้บริการก่อน 1 ม.ค. 53', 'ตรวจสอบวันที่เข้ารับบริการให้ถูกต้อง  หากเป็นการเข้ารับบริการก่อน 1 ม.ค 53 ให้เบิกเป็นกรณีการรักษาโรคมะเร็งทั่วไป', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('386', '530', 'W', 'ALL', 'มีการขอเบิกร่วมกันทั้งกรณีโรคมะเร็งทั่วไป และโรคมะเร็งตามโปรโตคอล', 'ตรวจสอบการขอเบิกเป็นกรณีโรคมะเร็งทั่วไปหรือมะเร็งในกลุ่มที่กำหนดโปรโตคอล บันทึกเบิกให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('387', '531', 'W', 'ALL', 'ขอเบิกกรณีมะเร็งทั่วไป แต่ให้รหัสโรคเป็นมะเร็งตามโปรโตคอลที่กำหนดให้รักษาและเบิกเป็นโปรโตคอลเท่านั้น', 'ให้ตรวจสอบการให้รหัสโรค  หรือตรวจสอบว่าเป็นการขอเบิกกรณีโรคมะเร็งทั่วไปหรือมะเร็งตามโปรโตคอล แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('388', '532', 'W', 'ALL', 'เบิกกรณีมะเร็งตามโปรโตคอล  แต่บันทึกรหัสการเบิกจ่ายมากกว่า 1 กลุ่มโรค', 'ตรวจสอบรหัสรายการที่ขอเบิกมะเร็งตามโปรโตคอล สามารถเบิกได้ 1 กลุ่มโรคต่อการรักษาในแต่ละครั้ง แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('389', '533', 'W', 'ALL', 'รายการที่ขอเบิกเคมีบำบัด  กรณีมะเร็งตามโปรโตคอล  เป็นการให้บริการก่อน 1 ม.ค. 53', 'ตรวจสอบวันที่เข้ารับบริการให้ถูกต้อง  หากเป็นการเข้ารับบริการก่อน 1 ม.ค 53 ให้เบิกเป็นกรณีการรักษาโรคมะเร็งทั่วไป', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('390', '534', 'W', 'ALL', 'รายการที่ขอเบิกเคมีบำบัด หรือ รังสีรักษา กรณีมะเร็งตามโปรโตคอล  เป็นการให้บริการตั้งแต่ 1 มิ.ย 53 เป็นต้นไป', 'ตรวจสอบรายการที่ต้องการเบิกหากเป็นการเข้ารับบริการตั้งแต่วันที่ 1 มิ.ย 53 เป็นต้นไป กรณีเคมีบำบัดให้เลือกรหัสเบิกที่ระบุ a,b  หรือ หากเป็นกรณีรังสีรักษาให้บันทึกรหัสเบิกให้ถูกต้อง   แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('391', '535', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกยา จ.2 (ATG,IVIG)', 'การใช้ยา จ.2 (ATG,IVIG) ต้องเป็นไปตามเงื่อนไขที่กำหนด  ตรวจสอบการให้รหัสโรค บันทึกให้ตรงตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('392', '536', 'W', 'ALL', 'เด็กอายุน้อยกว่า 15 ปี ให้เบิกเป็นกรณีมะเร็งทั่วไป (ข้อมูลปีงบฯ 61 เป็นข้อมูลบริการ ถึง 31 มี.ค.61)', 'ตรวจสอบวันเดือนปีเกิด และ การบันทึกเบิกในหน้ามะเร็งกรณีอายุน้อยกว่า 15 ปี ให้บันทึกเบิกเป็นมะเร็งทั่วไป', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('393', '537', 'W', 'ALL', 'เบิกชดเชยเกินจำนวน cycle /เม็ด ที่กำหนดในการรักษาตามโปรโตคอล', 'ตรวจสอบวันที่รับบริการ / การบันทึกจำนวนเม็ดยา ต้องไม่เกินจำนวนวันในรอบปีหรือวันที่รับบริการไม่เกินที่กำหนดในแต่ละ cycle', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('394', '538', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับการเบิกกรณีวินิจฉัยราคาแพงและหัตถการหัวใจผู้ป่วยนอก', 'ให้ตรวจสอบรหัสหัตถการกรณีวินิจฉัยราคาแพงและหัตถการหัวใจผู้ป่วยนอก และแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('395', '539', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกกรณีวินิจฉัยราคาแพงและหัตถการหัวใจผู้ป่วยนอก', 'ให้ตรวจสอบรหัสโรคกรณีวินิจฉัยราคาแพง  Endoscope retrograde cholangio pancreatography (ERCP)    แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('396', '540', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกกรณี CMV Retinitis  ในผู้ติดเชื้อ HIV', 'ให้ตรวจสอบรหัสโรคกรณีCMV Retinitis  ในผู้ติดเชื้อ HIV และแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('397', '541', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) ไม่ระบุหน่วยบริการหลัก', 'บันทึกรหัสหน่วยบริการหลักให้ถูกต้องครบถ้วน แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('398', '542', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer)  ไม่ระบุเลขที่ใบส่งต่อของต้นสังกัด', 'บันทึกเลขที่ใบส่งต่อของต้นสังกัดให้ถูกต้องครบถ้วน แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('399', '543', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) ไม่ระบุหน่วยบริการที่ส่งต่อ', 'บันทึกหน่วยบริการที่ส่งต่อ  แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('400', '544', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) ในจังหวัด ไม่ใช่หน่วยบริการที่กำหนด', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) ในจังหวัด บันทึกได้เฉพาะ รพ.สงขลานครินทร์เท่านั้น', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('401', '545', 'W', 'ALL', 'กรณีที่ขอเบิก ไม่เข้าเกณฑ์กรณีส่งต่อผู้ป่วยนอก (OP Refer)', 'ให้ตรวจสอบการบันทึก  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('402', '546', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) แต่เลือกเงื่อนไขการเรียกเก็บ', 'ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('403', '547', 'W', 'ALL', 'รหัสหน่วยบริการหลักเป็นรหัสเดียวกับหน่วยบริการที่ให้การรักษา', 'ตรวจสอบการบันทึก  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('404', '548', 'W', 'ALL', 'จากการตรวจสอบสิทธิของ สปสช. ไม่เข้าเกณฑ์การเบิกกรณีส่งต่อผู้ป่วยนอก (OP Refer)', 'ตรวจสอบการขอเบิก  ให้ไปตามเงื่อนไขที่กำหนด หรือบันทึกขอเบิกในโปรแกรม eclaim ปกติ', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('405', '549', 'W', 'ALL', 'กรณีที่ขอเบิก หรือ รายการยาที่ขอเบิก เข้าเกณฑ์ค่าใช้จ่ายสูง ผู้ป่วยนอก', 'กรณีเข้าเกณฑ์ค่าใช้จ่ายสูงผู้ป่วยนอก ให้บันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือหน้ามะเร็ง ( F5 ) และบันทึกรหัสยา,รหัสรังสีรักษา หรือ รหัสกรมบัญชีกลางในหน้า F8 ให้ถูกต้องครบถ้วน และจำนวนที่ขอเบิกในหน้า F4,F5 และ F8 ต้องเท่ากันเสมอ', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('406', '550', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก  (OP Refer)  ไม่ระบุการใช้สิทธิ UC', 'ตรวจสอบการบันทึก  กรณีที่ต้องการเบิกชดเชยค่าบริการ  การใช้สิทธิ เลือก ใช้สิทธิ UC', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('407', '551', 'W', 'ALL', 'รหัสหัตถการไม่สอดคล้องตามเงื่อนไขการจ่ายชดเชยกรณีการสลายนิ่ว', 'แก้ไขรหัสหัตถการให้ตรงตามเงื่อนไขการจ่ายชดเชยกรณีการสลายนิ่วให้ถูกต้อง แล้วส่งข้อมูลเข้ามาอีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('408', '552', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องตามเงื่อนไขการจ่ายชดเชยกรณีการสลายนิ่ว', 'แก้ไขรหัสโรคให้ตรงตามเงื่อนไขการจ่ายชดเชยกรณีการสลายนิ่วให้ถูกต้อง แล้วส่งข้อมูลเข้ามาอีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('409', '553', 'W', 'ALL', 'บันทึกข้อมูลไม่ครบถ้วนตามเงื่อนไขการเบิกชดเชยค่าใช้จ่ายกรณีการสลายนิ่ว', 'บันทึกรหัสโครงการพิเศษ DMISRC แล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('410', '554', 'W', 'ALL', 'บันทึกข้อมูลรหัสโรค  รหัสหัตถการ รหัสกรมบัญชีกลาง หรือ รหัสยา 24 หลัก ไม่ถูกต้อง / ครบถ้วน ตามเงื่อนไขที่กำหนด', 'ตรวจสอบการ \n-บันทึกรหัสโรค  รหัสหัตถการ รหัสกรมบัญชีกลาง หรือ รหัสยา 24 หลัก บันทึกข้อมูลให้ถูกต้อง ครบถ้วน แล้วส่งเข้ามาใหม่อีกครั้ง \n-กรณีที่มีการบันทึกเบิกค่าใช้จ่ายสูงในหน้า F4,F5 บันทึกรหัสกรมบัญชีกลาง หรือ รหัสยาในหน้า F8 ให้ครบถ้วน\n-กรณีพบว่ารหัสยา 24 หลักของหน่วยบริการไม่มี/ไม่ตรงกับฐาน e-Claim ติดต่อแจ้ง จนท. เพื่อตรวจสอบ', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('411', '555', 'W', 'ALL', 'ค่าใช้จ่ายรวม กับค่าใช้จ่ายราย Item มียอดไม่เท่ากัน', 'เนื่องจากเกิดความคลาดเคลื่อนในการนำเข้าข้อมูล ขอให้กดปุ่ม “รายการ” ในแต่ละ Item หน้าค่ารักษาพยาบาล แล้วกดบันทึกอีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('412', '556', 'W', 'ALL', 'บันทึกเบิกจำนวนยามะเร็งและจำนวนเงินไม่ถูกต้องสอดคล้องกัน', 'ตรวจสอบจำนวนเม็ดยาและจำนวนเงินที่ขอเบิกบันทึกให้ครบถ้วนถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('413', '557', 'W', 'ALL', 'บันทึกรหัสโครงการพิเศษ DMLP54 แต่ไม่บันทึก Protocol ที่กำหนด', 'ตรวจสอบการบันทึกข้อมูลกรณีการรักษา Acute leukemia ต้องบันทึกเบิกตามโปรโตคอลที่กำหนด บันทึกให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('414', '558', 'W', 'ALL', 'บันทึกเบิกมะเร็งตามโปรโตคอลไม่ถูกต้อง  ครบถ้วนตามเงื่อนไขที่กำหนด', 'บันทึกเบิกให้ครบถ้วนตามโปรโตคอลที่กำหนด \n1. ข้อมูลที่บันทึกเบิกเป็น cycle เดิมบันทึกเบิกให้ครบ cycle ก่อนจึงจะเริ่มตามโปรโตคอลใหม่ได้ \n2. ข้อมูลที่เริ่มการรักษาตั้งแต่วันที่ 1 ม.ค 56 ให้บันทึกเบิกเป็น Visit\nแก้ไขการบันทึกเบิกแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('415', '559', 'W', 'ALL', 'ข้อมูลเบิกกรณี HD จำนวนที่ขอเบิกไม่สอดคล้องกับจำนวนวันนอน (LOS)', 'ตรวจสอบการบันทึกจำนวนที่ขอเบิกกรณี HD หรือวันที่ admit /discharge แก้ไข/บันทึกให้ถูกต้อง สอดคล้องกับจำนวนวันนอน (LOS) แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('416', '560', 'W', 'ALL', 'รหัสโรคไม่สอดคล้องกับการเบิกอุปกรณ์เพดานเทียม', 'ตรวจสอบรหัสโรค กรณีเบิกเพดานเทียมบันทึกรหัสโรคให้สอดคล้องกับข้อบ่งชี้ แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('417', '561', 'W', 'ALL', 'ไม่ใช่หน่วยบริการที่ขึ้นทะเบียนให้บริการ Cleft lip Cleft palate', 'การบันทึกเบิกชดเชยค่าบริการกรณี Cleft palate ได้เฉพาะหน่วยบริการที่ขึ้นทะเบียนให้บริการกับ สปสช.เท่านั้น', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('418', '562', 'W', 'ALL', 'ยาที่บันทึกเบิกไม่พบใน Drug Catalog ของหน่วยบริการ', 'นำเข้า Drug Catalog ของหน่วยบริการ ที่หน้าเวบdrug.nhso.go.th/DrugCode เมื่อข้อมูลยาผ่านการตรวจสอบแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('419', '563', 'W', 'ALL', 'ข้อมูลการเบิกกรณีรักษาโรคมะเร็งไม่พบในระบบ CaPR Registry', 'ตรวจสอบรหัสโรค กรณีการรักษามะเร็งต้องดำเนินการลงทะเบียนผู้ป่วยมะเร็ง (Cancer Payment Register : CaPR) หน้าเวบ e-Claim ก่อน แล้วจึงส่งข้อมูลเบิกในโปรแกรม e-Claim กรณีผู้ป่วยรายเก่า ติดต่อ 0 2141 4200', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('420', '564', 'W', 'ALL', 'ประเภทยาในบัญชียาหลัก (ED) หรือยานอกบัญชียาหลัก(NED)  ที่บันทึกส่งไม่ตรงกับ Drug Catalog ที่ส่ง สปสช. เฉพาะสิทธิ UC หรือรูปแบบประเภทยาไม่ตรงตามที่ สปสช.กำหนด(ทุกสิทธิ)', 'ตรวจสอบประเภทยา ในบัญชียาหลัก (ED) หรือยานอกบัญชียาหลัก(NED) ใน file  Drug Catalog ที่ส่ง สปสช. คอลัมน์ ISED APROVED แก้ไขให้ถูกต้องตรงกันแล้วส่งเข้ามาอีกครั้ง หรือตรวจสอบรูปแบบประเภทยาให้ถูกต้องตรงตามที่ สปสช.กำหนด', '1', '2025-12-22 10:24:23', '2025-12-22 10:24:23');
INSERT INTO `error_codes` VALUES ('421', '565', 'W', 'ALL', 'บันทึกเบิกยา NED ผู้ป่วยนอกหรือ บันทึกเบิกยา NED Add on ผู้ป่วยใน  ไม่ระบุเหตุผลการใช้ยา EA-EF เฉพาะสิทธิ OFC และ LGO', 'ตรวจสอบการบันทึกข้อมูลยา กรณีใช้ยานอกบัญชียาหลักแห่งชาติ (NED) ของผู้ป่วยนอก หรือ กรณีใช้ยานอกบัญชียาหลักแห่งชาติ (NED) Add on ผู้ป่วยใน ระบุเหตุผล  EA-EF บันทึกให้ครบถ้วนแล้วส่งข้อมูลเข้ามาอีกครั้ง ยกเว้น ยา PA ที่มีการลงทะเบียนขอให้ยา PA', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('422', '566', 'W', 'ALL', 'ให้รหัสโรครองไม่ถูกต้อง กรณีการให้ยาเคมีบำบัด หรือรังสีรักษา หรือไม่ได้บันทึกยาในกลุ่มมะเร็ง หรือรหัสรังสีรักษา', 'ตรวจสอบรหัสโรครอง กรณีการรักษาโรคมะเร็งด้วยยาเคมีบำบัดต้องมีรหัสโรค Z511 รังสีรักษา Z510 หรือตรวจสอบการบันทึกยามะเร็งกรณีเป็นการให้ยาเคมีบำบัด ตรวจสอบการบันทึกรหัสรังสีรักษา (RTX) กรณีรักษาด้วยรังสี บันทึกให้ถูกต้องครบถ้วนแล้วส่งข้อมูลเข้ามาอีกครั้ง', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('423', '567', 'W', 'ALL', 'บันทึกรหัสรังสีรักษาไม่สอดคล้องกับชนิดของโรคมะเร็ง', 'ตรวจสอบรหัสโรค หรือ รหัสรังสีรักษา กรณีรักษาโรคมะเร็งทั่วไปเลือกรหัสรังสีรักษาที่กำหนด RTX216 เท่านั้น(ไม่ใช่รหัสเบิกของมะเร็งโปรโตคอล)', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('424', '568', 'W', 'ALL', 'เบิกมะเร็งโปรโตคอลไม่ถูกต้อง คือต้องเป็นราย visit ตามระเบียบประกันสังคม', 'เบิกมะเร็งโปรโตคอลต้องเป็นราย visit ตามระเบียบประกันสังคม', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('425', '569', 'W', 'ALL', 'กรณีสิทธิข้าราชการ/อปท. หน่วยบริการเอกชนไม่สามารถเบิกกับ สปสช.ได้', 'สิทธิข้าราชการ/อปท. หน่วยบริการเอกชนไม่สามารถเบิกกับ สปสช.ได้', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('426', '570', 'W', 'ALL', 'Workingcode/Hospdrugcode เป็นค่าว่าง', 'ให้ตรวจสอบ Workingcode/Hospdrugcode หากพบเป็นค่าว่างให้แก้ไขและส่งมาใหม่อีกครั้ง', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('427', '571', 'W', 'ALL', 'สิทธิประกันสังคม เบิกกรณีเมทาโดน', 'การเบิกเมทาโดน ให้ส่งระบบเดิมของประกันสังคม', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('428', '572', 'W', 'ALL', 'สิทธิประกันสังคม เบิกกรณีไตวายเฉียบพลัน, Instrument, Stereotactic Radiosurgery, Cryptococcal meningitis, กรณีหมันชาย/หมันหญิง,มะเร็งอื่นนอกเหนือจากมะเร็ง 10 ชนิด ที่เข้ารับบริการก่อน 1 ม.ค.58', 'ตรวจสอบวันที่เข้ารับบริการ การเบิกกรณีไตวายเฉียบพลัน, Instrument, Stereotactic Radiosurgery, Cryptococcal meningitis, กรณีหมันชาย/หมันหญิง,มะเร็งอื่นนอกเหนือจากมะเร็ง 10 ชนิด OP ที่วันที่เข้ารับบริการ และ IP วันที่ Admit ตั้งแต่ 1ม.ค.58 เป็นต้นไป', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('429', '573', 'W', 'ALL', 'วันที่รับบริการเป็นวันที่ก่อนวันที่ประกาศใช้รายการยา (ฟิลด์ Dateeffective ในไฟล์ Drugcatalog ของ รพ.)', 'ตรวจสอบวันที่รับบริการต้องเป็นวันเดียวกันหรือหลังวันที่ประกาศใช้รายการยา (ฟิลด์ Dateeffective ในไฟล์ Drugcatalog ของ รพ.)', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('430', '574', 'W', 'ALL', 'ข้อมูลประเภทยาและเวชภัณฑ์ (ฟิลด์ PRODUCTCAT ในไฟล์ Drugcatalog ของ รพ.) ไม่ใช่ 1-5', 'ข้อมูลประเภทยาและเวชภัณฑ์ (ฟิลด์ PRODUCTCAT ในไฟล์ Drugcatalog ของ รพ.) ต้องมีค่า 1-5 เท่านั้น', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('431', '575', 'W', 'ALL', 'ไม่ใช่หน่วยบริการที่สามารถให้บริการอุปกรณ์รองเท้าสำหรับผู้ป่วยเบาหวานที่มีความเสี่ยงเพื่อป้องกันภาวะแทรกซ้อนและการตัดเท้า', 'การเบิกรองเท้าเบาหวาน รหัส 8612, 8813, 8814 ต้องเป็นหน่วยบริการที่ผ่านการประเมินรับรองเท่านั้น กรณีขอการรับรองให้ประสานไปที่ สปสช.เขต เพื่อตรวจประเมินรับรอง โดยเริ่มกับข้อมูลให้บริการตั้งแต่วันที่ 1 ม.ค 59 เป็นต้นไป', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('432', '576', 'W', 'ALL', 'รหัสอุปกรณ์รองเท้าสำหรับผู้ป่วยเบาหวานที่บันทึกเบิก ไม่อยู่ในรายการอุปกรณ์ที่ผ่านการรับรองของหน่วยบริการ', 'ตรวจสอบอุปกรณ์รองเท้าสำหรับผู้ป่วยเบาหวานที่บันทึกเบิกต้องเป็นรหัสที่หน่วยบริการผ่านการประเมินรับรองเท่านั้น กรณีขอการรับรองให้ประสานไปที่ สปสช.เขต เพื่อตรวจประเมินรับรอง โดยเริ่มกับข้อมูลให้บริการตั้งแต่วันที่ 1 ม.ค 59 เป็นต้นไป', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('433', '577', 'W', 'ALL', 'บันทึกรหัสรังสีรักษาทั้งกรณีมะเร็งโปรโตคอลและมะเร็งทั่วไป', 'ตรวจสอบรหัสโรค หรือ รหัสรังสีรักษา บันทึกเบิกให้สอดคล้องกับการรักษาของโรคมะเร็งในครั้งนั้น  กรณีรักษาโรคมะเร็งทั่วไปเลือกรหัสรังสีรักษาที่กำหนด RTX216 เท่านั้น (ไม่ใช่รหัสเบิกของมะเร็งโปรโตคอล)', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('434', '578', 'W', 'ALL', 'บันทึกรหัสเบิกการจัดส่งยาทางไปรษณีย์แต่ไม่มีรายการยาหรือการเบิกค่าเวชภัณฑ์ที่ไม่ใช่ยา', 'ตรวจสอบกรณีการบันทึกรหัสเบิกการส่งยาทางไปรษณีย์ (DRUGP) ต้องมีการบันทึกข้อมูลยา หรือค่าใช้จ่ายเวชภัณฑ์ที่ไม่ใช่ยา (หมวด 5) ให้ครบถ้วน แล้วส่งเข้ามาใหม่อีกครั้ง กรณีไม่มีการจัดส่งยาหรือเวชภัณฑ์ไม่ต้องส่งข้อมูลเข้ามาในระบบ', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('435', '579', 'W', 'ALL', 'บนทันทึกเบิกกรณีให้บริการผู้ป่วยมะเร็งที่บ้าน (Home Chemotherapy ) ไม่พบรหัสยามะเร็ง', 'ตรวจสอบการบันทึกค่ายา กรณีให้บริการผู้ป่วยมะเร็งที่บ้านต้องบันทึกรายการยาให้ครบถ้วนทุกราย โดยไม่บันทึกเป็นยอดรวม แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('436', '580', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) มีการเบิกกรณีล้างไต/ฟอกเลือดในผู้ป่วยไตวายเฉียบพลัน  แต่ไม่มีการบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือ ไม่มีการบันทึกรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางที่เกี่ยวข้องในหน้า F8', 'ตรวจสอบและบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) และบันทึกรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางที่เกี่ยวข้องในหน้า F8 ให้ถูกต้องแล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('437', '581', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) มีการเบิกกรณีรักษาโรคเยื้อหุ้มสมองอักเสบจากเชื่อรา (Cryptococcal meningitis) แต่ไม่มีการบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือ ไม่มีการบันทึกเบิกยา Cryto ในหน้า F8', 'ตรวจสอบและบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) และบันทึกรายการยารักษาโรค Cryptococcal meningitis ในหน้า F8 ให้ถูกต้องและส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('438', '582', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) มีการเบิกกรณี CMV Retinitis ในผู้ติดเช้า HIV แต่ไม่มีการบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือ ไม่มีการบันทึกเบิกยา glanciclovir หรือ รหัสหัตถการในหน้า F8', 'ตรวจสอบและบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) และบันทึกรายการยา glanciclovir หรือรหัสหัตถการในหน้า F8 ให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('439', '583', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) มีการเบิกกรณีการให้สารเมทาโดน แต่ไม่มีการบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือ ไม่มีการบันทึกเบิกยาเมทาโดน ในหน้า F8', 'ตรวจสอบและบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) และบันทึกรายการยาเมทาโดนในหน้า F8 ให้ถูกต้องและส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('440', '584', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) มีการเบิกกรณีรักษา Hyperbaric Oxygen Therapy แต่ไม่มีการบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือ ไม่มีการบันทึกรหัสหัตถการในหน้า F8', 'ตรวจสอบและบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) และบันทึกรหัสหัตถการในหน้า F8  ให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('441', '585', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) เบิกมะเร็งทั่วไปรังสีรักษา แต่ไม่มีการให้รหัสโรครองรังสีรักษา หรือการบันทึกเบิกรหัสรังสีรักษาในหน้า F5 หรือรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางที่เกี่ยวข้องในหน้า F8', 'ตรวจสอบและบันทึกรหัสโรครอง Z510 และรหัสรังสีรักษา RTX216 ในหน้า F5 และรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางที่เกี่ยวข้องในหน้า F8', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('442', '586', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) มีการเบิกกรณีมะเร็งโปรโตคอลรักษาโดยยาเคมีบำบัด แต่ไม่มีการบันทึกเบิกยามะเร็งและรหัสหัตถการในหน้า F8', 'ตรวจสอบและบันทึกยารายการมะร็งและรหัสหัตถการ ในหน้า F8 กรณีมะเร็งโปรโตคอลรักษาโดยยาเคมีบำบัด ให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('443', '587', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer) เบิกมะเร็งโปรโตคอลรังสีรักษา แต่ไม่มีการให้รหัสโรครองรังสีรักษา หรือการบันทึกเบิกรหัสรังสีรักษาในหน้า F5 หรือรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางที่เกี่ยวข้องในหน้า F8', 'ตรวจสอบและบันทึกรหัสโรครอง Z510 และรหัสรังสีรักษาในหน้า F5 และรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางที่เกี่ยวข้องในหน้า F8', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('444', '588', 'W', 'ALL', 'กรณีส่งต่อผู้ป่วยนอก (OP Refer)ข้อมูลรับบริการก่อนปีงบประมาณ 2558 มีการเบิกกรณีการตรวจวินิจฉัยราคาแพงและหัตถการโรคหัวใจ แต่ไม่มีการบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) หรือ ไม่มีการบันทึกรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางตามที่กำหนด ในหน้า F8', 'ข้อมูลการรับบริการก่อนปีงบประมาณ 2558 กรณีเบิกการตรวจวินิจฉัยราคาแพงและหัตถการโรคหัวใจ ให้ตรวจสอบและบันทึกเบิกในหน้าค่าใช้จ่ายสูง ( F4 ) และบันทึกรหัสรายการอัตราค่าบริการสาธารณสุขของกรมบัญชีกลางตามที่กำหนดในหน้า F8 โดยจำนวนเงินที่ขอเบิกในหน้า F4 และ F8 ต้องเท่ากันเสมอ แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('445', '589', 'W', 'ALL', 'เบิกกรณี OP Refer แต่สถานะสิทธิการรักษาเป็นลงทะเบียนตามมติบอร์ด ไม่มีการยอมรับการลงทะเบียน', 'ตรวจสอบสถานะสิทธิการรักษาเป็นลงทะเบียนตามมติบอร์ด ไม่มีการยอมรับการลงทะเบียน ไม่สามารถเบิกกรณี OP Refer ได้', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('446', '591', 'W', 'ALL', 'กรณีที่ลงทะเบียนมะเร็งใน CaPR แต่บันทึกเบิกรหัส RTX ไม่สัมพันธ์กับประเภทของมะเร็งที่ลงทะเบียนไว้', 'ตรวจสอบการเบิกรหัสรังสีรักษาให้ตรงกับประเภทของมะเร็งที่ลงทะเบียนใน CaPR', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('447', '592', 'W', 'ALL', 'บันทึกเบิกกรณี Vascular Access แต่ไม่มีรายชื่อในทะเบียนผู้ป่วย HD', 'ตรวจสอบการบันทึกเลขบัตรประชาชน แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีบันทึกเลขบัตรประชาชนถูกต้องแล้ว ให้ดำเนินการลงทะเบียนผู้ป่วย HD ก่อนส่งข้อมูลเบิก (เบิกได้ตั้งแต่วันที่ได้รับการอนุมัติ)', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('448', '593', 'W', 'ALL', 'วันที่ทำหัตถการ Vascular Access ก่อนวันที่ลงทะเบียนผู้ป่วย HD', 'ตรวจสอบวันที่บันทึกข้อมูลเบิกกรณี Vascular Access วันที่รับบริการต้องเป็นวันที่ลงทะเบียน หรือหลังวันที่ลงทะเบียน HD', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('449', '594', 'W', 'ALL', 'เบิกรหัสรายการ Vascular access (HD0001 – HD0005)รหัสรายการเดียวกันมากกว่าจำนวนครั้งที่กำหนดในปีงบประมาณ', 'ตรวจสอบการบันทึกจำนวนครั้งในการขอเบิกรหัสรายการ Vascular Access ให้ถูกต้องตามเงื่อนไขที่กำหนด แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('450', '595', 'W', 'ALL', 'หน่วยบริการบันทึกขอเบิกรหัสรายการ Vascular access ไม่ตรงกับที่ลงทะเบียนในระบบ DMIS_HD', 'ตรวจสอบการบันทึกขอเบิกรหัสรายการ Vascular access   ให้ถูกต้องตรงกับที่หน่วยบริการได้ลงทะเบียนไว้ในระบบ DMIS_HD แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่  หน่วยบริการเอกชนต้องลงทะเบียนในระบบ DMIS_HD ก่อนให้บริการ', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('451', '596', 'W', 'ALL', 'กรณีที่เบิกไม่ตรงตามเงื่อนไขที่ลงทะเบียนเป็นหน่วยบริการสำรองเตียง ( Z75REF)', 'ตรวจสอบการบันทึกข้อมูลเบิก บันทึกเบิกได้ตามเงื่อนไขที่ลงทะเบียนเป็นหน่วยบริการสำรองเตียงเท่านั้น แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('452', '597', 'W', 'ALL', 'หน่วยบริการรับส่งต่อบันทึกเบิกได้เฉพาะสิทธิในระบบหลักประกันสุขภาพเท่านั้น', 'ตรวจสอบสิทธิผู้ป่วย กรณีเป็นหน่วยบริการรับส่งต่อสามารถบันทึกเบิกในระบบโปรแกรม e-Claim ได้เฉพาะสิทธิในระบบหลักประกันสุขภาพแห่งชาติ เท่านั้น', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('453', '598', 'W', 'ALL', 'กรณีที่บันทึกเบิกไม่ตรงตามเงื่อนไขของหน่วยบริการรับส่งต่อ', 'ตรวจสอบการบันทึกเงื่อนไขการเรียกเก็บ (F1 กรณี OP) หรืออาการแรกรับ (F4 กรณี IP) ต้องเป็นการรับส่งต่อหรือ AE เท่านั้น แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('454', '599', 'W', 'ALL', 'การเบิกกรณี Palliatve Care สามารถบันทึกเบิกได้เฉพาะหน่วยบริการต้นสังกัดเท่านั้น', 'การจ่ายชดเชยกรณี Palliatve Care สามารถเบิกได้เฉพาะหน่วยบริการต้นสังกัดเท่านั้น หากไม่ใช่ไม่สามารถเบิกกรณีนี้ได้', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('455', '600', 'C', 'ALL', 'กรณีฝากครรภ์ครั้งแรกบันทึกผลการตรวจทางห้องปฏิบัติการ (Lab) ไม่ครบถ้วน', 'ต้องบันทึกข้อมูลผลการตรวจทางห้องปฏิบัติการ (Lab) ให้ครบถ้วน', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('456', '601', 'C', 'ALL', 'กรณีฝากครรภ์ครั้งแรกไม่บันทึก ว/ด/ป ครั้งสุดท้ายของการมีประจำเดือนในช่อง LMP', 'ต้องบันทึกข้อมูล ว/ด/ป ครั้งสุดท้ายของการมีประจำเดือนในช่อง LMP ให้ถูกต้องครบถ้วน', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('457', '602', 'C', 'ALL', 'กรณีฝากครรภ์ครั้งแรกอายุครรภ์ไม่เกิน 12 สัปดาห์  วันที่เข้ารับบริการก่อนวันสุดท้ายของการมีประจำเดือน', 'ให้ตรวจสอบวันที่เข้ารับบริการ เทียบกับวันสุดท้ายของการมีประจำเดือนต้องไม่เกิน 12 สัปดาห์ตามเงื่อนไขการจ่ายชดเชยค่าบริการ', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('458', '603', 'C', 'ALL', 'กรณีฝากครรภ์ครั้งแรก พบว่าอายุครรภ์มากกว่า 12 สัปดาห์  ( เทียบจากวันเข้ารับบริการกับวันสุดท้ายของการมีประจำเดือน)', 'กรณีฝากครรภ์ครั้งแรกอายุครรภ์ต้องไม่เกิน 12 สัปดาห์ตามเงื่อนไข', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('459', '604', 'C', 'ALL', 'ไม่บันทึกข้อมูล ว/ด/ป ที่คลอดบุตร', 'ให้บันทึก ว/ด/ป ที่คลอดบุตรให้ถูกต้องครบถ้วน', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('460', '605', 'C', 'ALL', 'กรณีตรวจหลังคลอด  พบว่าวันเข้ารับบริการตรวจหลังคลอดก่อนวันคลอดบุตร', 'ให้ตรวจสอบวันที่เข้ารับบริการ ต้องไม่ก่อนวันคลอดบุตร', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('461', '606', 'C', 'ALL', 'กรณีตรวจหลังคลอด พบว่าวันเข้าบริการตรวจหลังคลอด หลังวันคลอดบุตรมากกว่า 12 สัปดาห์   ( เทียบจากวันคลอดบุตร)', 'ให้ตรวจสอบวันที่เข้ารับบริการ และวันคลอดบุตรต้องไม่เกิน 12 สัปดาห์ตามเงื่อนไขการจ่ายชดเชยค่าบริการ', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('462', '607', 'C', 'ALL', 'กรณีส่งเสริมป้องกันโรคเลือกรายการที่ขอเบิกไม่สอดคล้องกับสิทธิ', 'เลือกรายการที่ขอเบิกให้ถูกต้อง  แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('463', '608', 'C', 'ALL', 'กรณีส่งเสริมป้องกันโรค รายการที่ขอเบิกเป็นการให้บริการไม่สอดคล้องกับปีงบประมาณ', 'ให้ตรวจสอบรายการที่ขอเบิก   หรือวันที่เข้ารับบริการ แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่ หรือ กรณีข้อมูลให้บริการตั้งแต่ปีงบ 55 ถึงปัจจุบันให้ส่งผ่าน OPPP Individual Data', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('464', '609', 'C', 'ALL', 'เบิกกรณีส่งเสริมป้องกันโรค  แต่เลือกเงื่อนไขการเรียกเก็บเข้ามา', 'กรณีส่งเสริมป้องกันโรค  ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('465', '610', 'C', 'ALL', 'รหัสโรค / รหัสหัตถการแพทย์แผนไทย บันทึกในหน้าผู้ป่วยในเท่านั้น', 'ตรวจสอบรหัสโรค/รหัสหัตถการที่ให้ กรณีรหัสโรค/รหัสหัตถการที่กำหนดในแพทย์แผนไทย บันทึกเบิกเป็นผู้ป่วยในเท่านั้น', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('466', '611', 'C', 'ALL', 'เบิกกรณี Palliative Care บันทึกรหัสโรครอง(Sdx) ไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกรหัสโรคโรครอง (Sdx) กรณีดูแลผู้ป่วยระยะท้าย (Palliative Care)  Z515 ต้องเป็นโรคร่วม (Comorbility) เท่านั้น  แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('467', '612', 'C', 'ALL', 'บันทึกรหัสโรคหลักและรหัสหัตถการไม่ถูกต้องกรณีเบิก Methadone', 'กรณีเบิก Methadone ตามสิทธิประโยชน์ที่ สปสช.กำหนด ได้เฉพาะโรค Pdx = F11.2 \nICD9=9425 เท่านั้น ตรวจสอบและแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ หากไม่ตรงตามนี้ไม่สามารถเบิกกรณีนี้ได้', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('468', '613', 'C', 'ALL', 'เบิกกรณี Palliative Care ร่วมกับค่าใช้จ่ายสูง', 'ตรวจสอบการบันทึกข้อมูลกรณีการเยี่ยมบ้านในผู้ป่วยระยะท้ายไม่สามารถเบิกค่าใช้จ่ายสูง (HC)ได้', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('469', '614', 'C', 'ALL', 'เบิกกรณี Palliative Care บันทึกวันที่เยี่ยมบ้านก่อนเงื่อนไขที่กำหนด', 'ตรวจสอบวันที่เริ่มเยี่ยมบ้าน ดังนี้ \n1. ข้อมูลปี 60 เยี่ยมก่อนวันที่ 1 ก.ค 59 ไม่สามารถบันทึกเบิกกรณีนี้ได้ \n2. ข้อมูลปี 61 เยี่ยมก่อนวันที่ 1 เม.ย 60 ไม่สามารถบันทึกเบิกกรณีนี้ได้', '1', '2025-12-22 10:25:12', '2025-12-22 10:25:12');
INSERT INTO `error_codes` VALUES ('470', '615', 'C', 'ALL', 'เบิกกรณี Palliative Care ในผู้ป่วยที่เสียชีวิตแล้ว', 'ตรวจสอบสิทธิ กรณีเสียชีวิตแล้วไม่สามารถบันทึกเบิกได้ หรือ ตรวจสอบวันที่ให้บริการแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('471', '616', 'C', 'ALL', 'รหัสโรคไม่สอดคล้องกับประเภทการยุติการตั้งครรภ์', 'ตรวจสอบรหัสเบิกกรณียุติการตั้งครรภ์และรหัสโรค แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('472', '617', 'C', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับประเภทการยุติการตั้งครรภ์', 'ตรวจสอบรหัสเบิกกรณียุติการตั้งครรภ์และรหัสหัตถการ แก้ไขให้ถูกต้องแล้วส่งเข้ามมาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('473', '618', 'C', 'ALL', 'บันทึกรหัสเบิกยุติการตั้งครรภ์ อายุน้อยกว่า 8 ปี', 'ตรวจสอบวัน เดือน ปี เกิด แก้ไขให้ถูกต้อง แล้วส่งเข้ามาใหม่ กรณีอายุไม่ถึง 8 ปี ไม่สามารถเบิกในรหัสยุติการตั้งครรภ์ได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('474', '619', 'C', 'ALL', 'เป็นหน่วยบริการปฐมภูมิ บันทึกรหัสเบิกยุติการตั้งครรภ์ หรือบันทึกรหัสบริการคุมกำเนิดกึ่งถาวร', 'หน่วยบริการปฐมภูมิไม่สามารถเบิก กรณียุติการตั้งครรภ์รหัส AB001,AB002,AB003 หรือบันทึกรหัสบริการคุมกำเนิดกึ่งถาวร (FP001,FP002)ได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('475', '620', 'C', 'ALL', 'ข้อมูลรับบริการ/จำหน่าย ก่อน วันที่ 1 ตุลาคม 2560 บันทึกเบิกกรณียุติการตั้งครรภ์', 'ตรวจสอบวันรับบริการ หรือ วันจำหน่าย แก้ไขให้ถูกต้อง แล้วส่งเข้ามาใหม่อีกครั้ง หากรับบริการ/จำหน่ายก่อน 1 ตุลาคม 2560 ไม่สามารถเบิกการยุติการตั้งครรภ์ได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('476', '621', 'C', 'ALL', 'การเบิกค่าตรวจสุขภาพประจำปี ข้อมูลเพศหรืออายุ ไม่สอดคล้องกับรหัสเบิกจ่าย (สิทธิ อปท./สิทธิ สปสช.)', 'ตรวจสอบข้อมูลเพศหรืออายุ ให้สอดคล้องกับรหัสเบิกจ่าย', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('477', '622', 'C', 'ALL', 'การเบิกค่าตรวจสุขภาพประจำปี ไม่ใช่สิทธิเจ้าตัว (สิทธิ อปท./สิทธิ สปสช.)', 'เบิกค่าตรวจสุขภาพประจำปี สิทธิ อปท.เบิกได้เฉพาะสิทธิเจ้าตัว', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('478', '623', 'C', 'ALL', 'การเบิกค่าตรวจสุขภาพประจำปี ครบตามอัตราที่กำหนดแล้ว (สิทธิ อปท./สิทธิ สปสช.)', 'ตรวจสอบการเบิกค่าตรวจสุขภาพประจำปี เบิกได้ไม่เกินอัตราที่กำหนด', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('479', '625', 'C', 'ALL', 'รหัสโรค/รหัสหัตถการไม่ตรงตามกลุ่ม One Day Surgery ที่กำหนด', 'ตรวจสอบรหัสหัตถการ (ICD9) แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีไม่ใช่กลุ่ม One Day Surgery ที่กำหนด บันทึกเบิกในหน้าผู้ป่วยนอก หรือ ผู้ป่วยใน (IPD) ปกติ', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('480', '626', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่ผ่านเกณฑ์การประเมิน One Day Surgery', 'บันทึกเบิกในหน้าผู้ป่วยนอก หรือ ผู้ป่วยใน (IPD) ปกติ', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('481', '627', 'C', 'ALL', 'บันทึกเป็นกรณี  One Day Surgery จำนวนวันนอนน้อยกว่า 2 ชั่วโมง หรือมากกว่า 24 ชั่วโมง', 'ตรวจสอบการบันทึก วันเวลา admit หรือ discharge  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีวันนอนน้อยกว่า 2 ชั่วโมง หรือมากกว่า 24 ชั่วโมง บันทึกเบิกในหน้าผู้ป่วยนอก หรือ ผู้ป่วยใน (IPD) ปกติ', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('482', '628', 'C', 'ALL', 'บันทึกเป็นกรณี One Day Surgery แต่ผู้ป่วยมีภาวะแทรกซ้อน', 'ตรวจสอบการบันทึกรหัสโรค รหัสหัตถการ แก้ไขแล้วส่งเข้ามาใหม่ กรณีมีภาวะแทรกซ้อน บันทึกเบิกในหน้าผู้ป่วยนอก หรือ ผู้ป่วยใน (IPD) ปกติ', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('483', '629', 'C', 'ALL', 'บันทึกเป็นกรณี One Day Surgery ประเภทการจำหน่ายไม่ใช่ 1 Improve', 'ตรวจสอบการบันทึกประเภทการจำหน่ายแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีประเภทการจำหน่ายไม่ใช่ 1 Improve  บันทึกเบิกในหน้าผู้ป่วยนอก หรือ ผู้ป่วยใน (IPD) ปกติ', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('484', '630', 'C', 'ALL', 'ไม่ใช่กลุ่มเป้าหมายผู้รับบริการ (อายุต่ำกว่า 35 ปี) บริการคัดกรองเบาหวาน/ความดันโลหิตสูงและปัจจัยเสี่ยงต่อการเกิดโรคหัวใจและหลอดเลือด', 'ตรวจสอบอายุของผู้รับบริการเฉพาะประชาชนไทย สิทธิ์ UC  ที่มีอายุ 35 ปีขึ้นไป', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('485', '631', 'C', 'ALL', 'ไม่ใช่ข้อมูลที่ให้บันทึกเบิกในโปรแกรม e-Claim สำหรับหน่วยบริการเขต กทม./รัฐสังกัด สป.สธ.', 'หน่วยบริการในเขต 13 ให้บันทึกเบิกในโปรแกรม BPPDS', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('486', '632', 'C', 'ALL', 'เคยได้รับการวินิจฉัยเบาหวาน/ความดันโลหิตสูง /ความเสียงโรคหัวใจ', 'ตรวจสอบการบันทึกเบิกบริการคัดกรองเบาหวาน/ความดันโลหิตสูงและปัจจัยเสี่ยงต่อการเกิดโรคหัวใจและหลอดเลือด ต้องเป็นผู้ที่ไม่เคยได้รับการวินิจฉัยเบาหวาน/ความดันโลหิตสูง /ความเสียงโรคหัวใจ มาก่อน', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('487', '633', 'C', 'ALL', 'บันทึกเบิกกรณี.ฝากครรภ์เกินจำนวนครั้งที่กำหนด', 'การรับบริการและเบิกกรณีฝากครรภ์ไม่เกิน 5 ครั้ง/คน/ปีงบประมาณ', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('488', '634', 'C', 'ALL', 'กรณีการฝากครรภ์บันทึกเบิกการตรวจอัลตราซาวด์มากกว่า 1 ครั้ง/การตั้งครรภ์', 'ตรวจสอบการบันทึกรหัสหัตถการการทำอัลตราซาวด์ กรณีการฝากครรภ์เบิกได้ 1 ครั้ง/การตั้งครรภ์ ตัดรหัสหัตถการที่เกี่ยวข้องออกเพื่อรับค่าใช้จ่ายอื่นตามเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('489', '635', 'C', 'ALL', 'บันทึกเบิกกรณีบริการตรวจสุขภาพช่องปากและขัดทำความสะอาดฟันแต่ไม่ใช่หญิงตั้งครรภ์', 'การเบิกกรณีบริการตรวจสุขภาพช่องปากและขัดทำความสะอาดฟัน เบิกได้ในหญิงตั้งครรภ์เท่านั้น ตรวจสอบรหัสหัตถการ แก้ไขหรือตัดออกเพื่อรับค่าบริการกรณีอื่นๆ ตามเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('490', '636', 'C', 'ALL', 'บันทึกเบิกกรณีในการขัดและทำความสะอาดฟันไม่พบหัตถการที่กำหนด', 'ตรวจสอบการบันทึกรหัสหัตถการบันทึก หรือแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('491', '637', 'C', 'ALL', 'บันทึกข้อมูลเบิกกรณีฝากครรภ์หรือกรณีคัดกรองมะเร็งปากมดลูก ไม่ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกเพศเบิกกรณีฝากครรภ์/คัดกรองมะเร็งปากมดลูกต้องเป็นเพศหญิงเท่านั้น แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('492', '638', 'C', 'ALL', 'กรณีตรวจคัดกรองมะเร็งปากมดลูกอายุน้อยกว่า 15 ปี หรือมากกว่า 60 ปี', 'ตรวจสอบวัน เดือน ปี เกิด แก้ไขให้ถูกต้อง แล้วส่งเข้ามาใหม่ กรณีอายุไม่ตรงตามเงื่อนไขที่กำหนดในแต่ละปีงบประมาณไม่สามารถเบิกกรณีตรวจคัดกรองมะเร็งปากมดลูก ได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('493', '639', 'C', 'ALL', 'รหัสโรค/รหัสหัตถการไม่ถูกต้อง กรณีตรวจคัดกรอง/ยืนยันมะเร็งปากมดลูก', 'แก้ไขการบันทึกรหัสโรค/รหัสหัตถการให้ถูกต้องแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('494', '640', 'C', 'ALL', 'เบิกกรณีตรวจคัดกรอง/ยืนยันมะเร็งปากมดลูกมากกว่าจำนวนครั้งที่กำหนด', 'ตรวจสอบข้อมูลเบิกกรณี.ณีกรณีตรวจคัดกรอง/ยืนยันมะเร็งปากมดลูก สามารถเบิกได้ 1 ครั้ง/คน/ 5 ปีงบประมาณเท่านั้น', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('495', '641', 'C', 'ALL', 'กรณีตรวจคัดกรองมะเร็งปากมดลูก (Pap smear) ไม่บันทึกผลการตรวจเซลล์วิทยา', 'บันทึกผลการตรวจเซลล์วิทยา แล้วส่งขอรับค่าบริการใหม่อีกครั้ง แล้วส่งขอรับค่าบริการใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('496', '642', 'C', 'ALL', 'บันทึกข้อมูลตรวจคัดกรองมะเร็งไม่ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกเบิกกรณีตรวจคัดกรองมะเร็ง แก้ไขให้ถูกต้อง ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('497', '643', 'C', 'ALL', 'บันทึกเบิกกรณีการตรวจทางพยาธิวิทยา Liquid based cytology  แต่ไม่พบการตรวจคัดกรองมะเร็งปากมดลูกด้วยวิธี HPV DNA Test', 'ตรวจสอบการบันทึกรหัสโรค/รหัสหัตถการ กรณีมีการเบิกการตรวจทางพยาธิวิทยา Liquid based cytology ต้องมีการตรวจคัดกรองมะเร็งปากมดลูกด้วยวิธี HPV DNA Test ด้วย แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง กรณีไม่ได้ตรวจคัดกรองมะเร็งปากมดลูกด้วยวิธี HPV DNA Test ไม่สามารถเบิกการตรวจทางพยาธิวิทยา Liquid based cytology ได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('498', '644', 'C', 'ALL', 'อายุไม่สอดคล้องกับเงื่อนไขที่กำหนดกรณีการเบิกทันตกรรมป้องกันในเด็กวัยเรียน', 'ตรวจสอบการบันทึก วัน เดือน ปีเกิดของผู้ป่วย แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง กรณีอายุน้อยกว่า 4 ปี หรือ มากกว่า 12 ปี ไม่สามารถเบิกทันตกรรมป้องกันในเด็กวัยเรียนได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('499', '645', 'C', 'ALL', 'หน่วยบริการบันทึกเบิกผ่านโปรแกรมตามที่กำหนดไม่ถูก กรณีบริการทันตกรรมป้องกันในเด็กวัยเรียน อายุ 4 – 12 ปี', 'ตรวจสอบข้อมูลเบิกกรณีบริการทันตกรรมป้องกันในเด็กวัยเรียน อายุ 4 – 12 ปี บันทึกส่งเบิกในโปรแกรมตามที่กำหนด (ไม่ต้องแก้ไขข้อมูลที่ติด C นี้)', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('500', '646', 'C', 'ALL', 'อายุไม่ตรงตามเงื่อนไขที่กำหนด กรณีการเบิกบริการเคลือบหลุมร่องฟัน (ฟันถาวร)', 'ตรวจสอบการบันทึกวัน เดือน ปีเกิด แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง กรณีอายุน้อยกว่า 6 ปี หรือมากกว่า 12 ปีไม่สามารถการเบิกเคลือบหลุมร่องฟัน (ฟันถาวร) ได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('501', '647', 'C', 'ALL', 'อายุไม่ตรงตามเงื่อนไขที่กำหนด กรณีเบิกบริการเคลือบฟลูออไรด์เฉพาะที่ สำหรับเด็ก', 'ตรวจสอบการบันทึกวัน เดือน ปีเกิด แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้งอายุ กรณีอายุน้อยกว่า 4 ปี หรือมากกว่า 12 ปีเบิกบริการเคลือบฟลูออไรด์เฉพาะที่ สำหรับเด็กไม่ได้ \nน้อยกว่า 4 ปี และมากกว่า 12 ปีเบิกบริการเคลือบฟลูออไรด์เฉพาะที่ สำหรับเด็ก', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('502', '648', 'C', 'ALL', 'บันทึกเบิกกรณีเคลือบหลุมร่องฟัน(ฟันถาวร)ไม่ได้ระบุรหัสซี่ฟันตามที่กำหนด', 'บันทึกรหัสซี่ที่กำหนด แก้ไขแล้วเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('503', '649', 'C', 'ALL', 'การตรวจยืนยันภาวะพร่องไทรอยด์ฮอร์โมน (TSH) ผิดปกติ อายุ 0-1 ปี เบิกมากกว่า 6 ครั้ง', 'ตรวจสอบการบันทึกข้อมูลเบิก กรณีอายุ 0-1 ปี เบิกได้ไม่เกิน 6 ครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('504', '650', 'C', 'ALL', 'การตรวจยืนยันภาวะพร่องไทรอยด์ฮอร์โมน (TSH) ผิดปกติ อายุ 2 ปี เบิกมากกว่า 2 ครั้ง', 'ตรวจสอบการบันทึกข้อมูลเบิก กรณีอายุ 2 ปี เบิกได้ไม่เกิน 2 ครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('505', '651', 'C', 'ALL', 'การตรวจยืนยันภาวะพร่องไทรอยด์ฮอร์โมน (TSH) ผิดปกติ อายุ 3 ปี เบิกมากกว่า 2 ครั้ง', 'ตรวจสอบการบันทึกข้อมูลเบิก กรณีอายุ 3 ปี เบิกได้ไม่เกิน 2 ครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('506', '652', 'C', 'ALL', 'การตรวจยืนยันภาวะพร่องไทรอยด์ฮอร์โมน (TSH) ผิดปกติ อายุ 4 ปี เบิกมากกว่า 2 ครั้ง', 'ตรวจสอบการบันทึกข้อมูลเบิก กรณีอายุ 4 ปี เบิกได้ไม่เกิน 2 ครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('507', '653', 'C', 'ALL', 'การตรวจยืนยันภาวะพร่องไทรอยด์ฮอร์โมน (TSH) ผิดปกติ อายุเกิน 4 ปี', 'ตรวจสอบการบันทึกข้อมูลเบิก กรณีมากกว่าอายุ 4 ปี เบิกได้ไม่เกิน 2 ครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('508', '654', 'C', 'ALL', 'รหัสโรคไม่ถูกต้องกรณีเบิก FISH  (fluorescence in situ hybridization ) หรือ DISH test  (Dual –Color in situ hybridization  )  สำหรับการตรวจยืนยัน in situ hybridization เพื่อประกอบการสั่งใช้ยา trastuzumab', 'ตรวจสอบรหัส ICD10 แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('509', '655', 'C', 'ALL', 'มีการเบิก FISH  (fluorescence in situ hybridization ) และ DISH (Dual –Color in situ hybridization )  สำหรับการตรวจยืนยัน in situ hybridization เพื่อประกอบการสั่งใช้ยา trastuzumab ในครั้งเดียวกัน', 'มีการเบิกทั้ง FISH (fluorescence in situ hybridization ) และ  DISH (Dual –Color in situ hybridization )  ไม่สามารถเบิกได้พร้อมกัน ตรวจสอบรายการและบันทึกเพียงรายการเดียว', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('510', '656', 'C', 'ALL', 'เบิก FISH (fluorescence in situ hybridization ) หรือ (DISH test ) สำหรับการตรวจยืนยัน in situ hybridization เพื่อประกอบการสั่งใช้ยา trastuzumab  ในช่วงวันรับบริการตั้งแต่ 15 เมย.ถึง 30กย.62 ไม่สามารถเบิกได้', 'การเบิก FISH (fluorescence in situ hybridization ) หรือ (DISH test ) ช่วงวันรับบริการตั้งแต่ 15 เมย.ถึง 30 กย.62 ได้รับการจ่ายชดเชยจากระบบ จ.2 แล้ว ไม่สามารถเบิกได้อีก', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('511', '657', 'C', 'ALL', 'รหัสโรคไม่ถูกต้องกรณีเบิกการตรวจยีน  mutation     สำหรับค่าตรวจทางห้องปฏิบัติการ กรณีการสั่งใช้ยา Imatinib', 'ตรวจสอบรหัส ICD10 แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('512', '658', 'C', 'ALL', 'มีการเบิกการตรวจยีน mutation สำหรับค่าตรวจทางห้องปฏิบัติการกรณีการสั่งใช้ยา Imatinib ซ้ำซ้อน', 'เบิกการตรวจยีน  mutation     สำหรับค่าตรวจทางห้องปฏิบัติการกรณีการสั่งใช้ยา Imatinib จ่ายครบตามเงื่อนไขที่กำหนดแล้ว (จ่าย 1 ครั้ง /ปีปฎิทิน ตามวันที่บริการ)', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('513', '659', 'C', 'ALL', 'มีการเบิกการตรวจยีน mutation สำหรับค่าตรวจทางห้องปฏิบัติการกรณีการสั่งใช้ยา Imatinib) ในช่วงวันรับบริการตั้งแต่ 1 มค.ถึง 30 กย.62 ไม่สามารถเบิกได้', 'การเบิกการตรวจยีน  mutation สำหรับค่าตรวจทางห้องปฏิบัติการกรณีการสั่งใช้ยา Imatinib) ช่วงวันรับบริการตั้งแต่ 1 มค.ถึง 30 กย .62 ได้รับการจ่ายชดเชยจากระบบ จ.2 แล้ว ไม่สามารถเบิกได้อีก', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('514', '660', 'C', 'ALL', 'กรณีตรวจยืนยันมะเร็งลำไส้ใหญ่ (CA Colon) ปี 2562 สิทธิ UC', '1. เป็นข้อมูลกรณีตรวจยืนยันมะเร็งลำไส้ใหญ่ (CA Colon) ปี 2562  ที่มีวันรับบริการตั้งแต่วันที่ 1 มค.61 – 25 กย. 62 \n2. มีหน่วยบริการเข้าร่วมโครงการ (ตามไฟล์แนบ)', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('515', '661', 'C', 'ALL', 'กรณีผ่าตัดเปลี่ยนหัวใจ กรณี มีภาวะแทรกซ้อนหลังผ่าตัด (Rejection)', 'กรณีที่ heart transplantมี rejection แยกเป็น 2 กรณี \n1. ในกรณีที่ทำผ่าตัด heart transplant แล้วมีการ rejection หรือ failure ใน admission เดียวกันกับการผ่าตัด DRG V5 \n2.  ในกรณีที่มา admit ใหม่เพื่อรักษา heart rejection หรือ failure DRG V5', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('516', '662', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่กำหนด กรณีการเบิก FISH  (fluorescence in situ hybridization ) หรือ DISH (Dual –Color in situ hybridization )  สำหรับการตรวจยืนยัน in situ hybridization เพื่อประกอบการสั่งใช้ยา trastuzumab', 'การเบิก FISH  (fluorescence in situ hybridization ) หรือ DISH (Dual –Color in situ hybridization )  สำหรับการตรวจยืนยัน in situ hybridization เพื่อประกอบการสั่งใช้ยา trastuzumab  จะต้องเป็นหน่วยบริการตามที่กำหนดเท่านั้น', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('517', '663', 'C', 'ALL', 'บันทึกรหัสหัตถการไม่ถูกต้อง กรณีบริการฝากครรภ์ และการตรวจอัลตราซาวด์', 'ตรวจสอบการบันทึกรหัสหัตถการกรณีบริการฝากครรภ์ และการตรวจอัลตราซาวด์ แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนดแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('518', '664', 'C', 'ALL', 'ระบุผลตรวจไม่ถูกต้อง กรณีบริการตรวจคัดกรองมะเร็งปากมดลูกด้วยวิธี HPV DNA Test', 'ตรวจสอบการบันทึกผลตรวจคัดกรองมะเร็งปากมดลูกวิธี HPV DNA Test กรณี ไม่เท่ากับ HPV Type Non 16/18 ไม่สามารถเบิกกรณีนี้ได้ \nส่งตรวจทางพยาธิวิทยา Liquid based cytology โดยระบุผลตรวจคัดกรองมะเร็งปากมดลูกด้วยวิธี HPV DNA Test ไม่เท่ากับ HPV Type Non 16/18', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('519', '665', 'C', 'ALL', 'หน่วยบริการไม่อยู่ในกลุ่มที่กำหนด กรณีเบิก HPV DNA Test และ LIQUID TEST', 'การเบิก HPV DNA และ LIQUID TEST ต้องเป็นหน่วยบริการที่ที่มีศักยภาพในการตรวจ เท่านั้น', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('520', '666', 'C', 'ALL', 'รหัสหัตถการไม่ถูกต้อง กรณีเบิกบริการทันตกรรมป้องกันในเด็กวัยเรียน อายุ 4 – 12 ปี', 'ตรวจสอบการบันทึกรหัสหัตถการ กรณีการเบิกบริการเคลือบฟลูออไรด์เฉพาะที่ แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนดแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('521', '667', 'C', 'ALL', 'รหัสหัตถการไม่ถูกต้อง กรณีเบิกบริการทันตกรรมป้องกันในเด็กวัยเรียน อายุ 4 – 12 ปี', 'ตรวจสอบการบันทึกรหัสหัตถการ กรณีการเบิกบริการเคลือบหลุมร่องฟัน(ฟันถาวร)  แก้ไขให้ถูกต้องตามเงื่อนไขที่กำหนดแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('522', '668', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่กำหนด กรณีการเบิกการตรวจยีน  mutation สำหรับค่าตรวจทางห้องปฏิบัติการกรณีการสั่งใช้ยา Imatinib', 'การเบิกการตรวจยีน mutation สำหรับค่าตรวจทางห้องปฏิบัติการกรณีการสั่งใช้ยา Imatinib จะต้องเป็นหน่วยบริการตามที่กำหนดเท่านั้น', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('523', '669', 'C', 'ALL', 'เบิก FISH  (fluorescence in situ hybridization ) หรือ DISH (Dual –Color in situ hybridization ) สำหรับการตรวจยืนยัน in situ hybridization เพื่อประกอบการสั่งใช้ยา trastuzumab มากกว่า 2 ข้าง/คน/ชีวิต', 'การเบิก FISH (fluorescence in situ hybridization ) หรือ DISH (Dual –Color in situ hybridization ) เบิกได้ 2 ข้าง/คน/ชีวิต เท่านั้น', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('524', '670', 'C', 'ALL', 'เบิกกรณี paliative care ไม่บันทึกวันที่เยี่ยมบ้าน หรือเบิกกรณี ANC ไม่มีวันที่ประจำเดือนมาครั้งสุดท้าย', 'ตรวจสอบการบันทึกข้อมูลหน้า F6 บันทึกวันที่เยี่ยมบ้าน หรือ วันที่ประจำเดือนมาครั้งสุดท้าย ตามเงื่อนไขที่ขอเบิกให้ครบถ้วนแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('525', '671', 'C', 'ALL', 'กรมวิทยาศาสตร์เบิก HPV DNA Test ไม่ระบุหน่วยบริการที่ส่งต่อ', 'การเบิก HPV DNA Test  ของกรมวิทยาศตร์ต้องระบุหน่วยบริการที่รับส่งต่อมา บันทึกให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('526', '672', 'C', 'ALL', 'บันทึกข้อมูลให้บริการกรณีส่งเสริมป้องกันโรค ก่อนวันที่กำหนดให้เบิกจ่าย', 'ตรวจสอบเงื่อนไขการเบิกจ่ายกรณีส่งเสริมป้องกันโรคตามแนวทางที่ สปสช.กำหนด ในคู่มือแนวทางปฏิบัติในการขอรับค่าใช้จ่ายฯ ประจำปีงบประมาณ แก้ไขเข้ามาใหม่ หรือ ยกเลิกการเบิกจ่ายกรณีไม่ตรงตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('527', '673', 'C', 'ALL', 'วันที่ส่งตรวจ Liquid base cytology ก่อนวันที่ตรวจคัดกรอง HPV DNA', 'ตรวจสอบวันที่บันทึกข้อมูลเบิกกรณี Liquid base cytology ต้องตรวจหลังการตรวจคัดกรอง HPV DNA แก้ไขให้ถูกต้องแล้วส่งมาใหม่ กรณีไม่เป็นไปตามเงื่อนไขนี้ไม่สามารถเบิกได้', '1', '2025-12-22 10:25:13', '2025-12-22 10:25:13');
INSERT INTO `error_codes` VALUES ('528', '674', 'C', 'ALL', 'หน่วยบริการที่ตรวจ HPV DNA Test เป็นหน่วยบริการเดียวกับหน่วยบริการที่ส่งต่อ (Hrefer in)', 'ตรวจสอบการบันทึกหน่วยบริการที่ส่งต่อ (Hrefer in) ต้องไม่ใช่หน่วยบริการที่ตรวจ HPV DNA Test แก้ไขให้ถูกต้อง แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('529', '675', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่มีศักยภาพการให้บริการฝงเข็ม หรือบริการฝังเข็มร่วมกับกระตุ้นไฟฟา', 'กรณีไม่ใช่หน่วยบริการที่มีศักยภาพไม่สามารถเบิกได้ หากประสงค์เข้าร่วมบริการติดต่อ สปสช.เขตตามพื้นที่ของหน่วยบริการ', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('530', '676', 'C', 'ALL', 'รหัสโรค หรือ รหัสหัตถการไม่ถูกต้อง กรณีบริการฝังเข็ม', 'ตรวจสอบรหัสโรค หรือรหัสหัตถการ บันทึกให้ถูกต้องตามการให้บริการและเงื่อนไขที่กำหนด แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('531', '677', 'C', 'ALL', 'เบิกบริการฝังเข็ม ไม่ได้บันทึกค่า Barthel ADL Index', 'ตรวจสอบการบันทึกข้อมูล กรณีเบิกบริการฝังเข็มต้องบันทึกค่า Barthel ADL Index เข้ามาด้วย บันทึกให้ครบถ้วนแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('532', '678', 'C', 'ALL', 'เบิก on top ค่าบริการฝังเข็มของ แต่ให้บริการไม่ครบ  20 ครั้งในหน่วยบริการเดียวกัน', 'การเบิก on top ค่าบริการฝังเข็มของผู้ป่วยแต่ละราย สามารถเบิกได้เมื่อให้บริการครบ 20 ครั้งในหน่วยบริการเดียวกัน หากให้บริการไม่ครบตามจำนวนที่กำหนดไม่สามารถเบิกได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('533', '679', 'C', 'ALL', 'บันทึกรหัสโครงการพิเศษ CANCER แต่ไม่ใช่ผู้ป่วยมะเร็ง', 'ตรวจสอบการบันทึกข้อมูลกรณีบันทึกรหัสโครงการพิเศษ CANCER และมีการเบิกยาเคมีบำบัดหรือรังสีรักษา ต้องเป็นการรักษาโรคมะเร็งเท่านั้น แก้ไขรหัสโรคให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('534', '680', 'C', 'ALL', 'บันทึกเบิกกรณีการรักษาโรคมะเร็งรับบริการที่ไหนก็ได้ที่พร้อม แต่เป็นข้อมูลบริการก่อนวันที่ 1 ม.ค. 64', 'กรณีการรักษาโรคมะเร็งก่อนวันที่ 1 ม.ค. 64 ให้บันทึกเบิกตามเงื่อนไขเดิม โดยไม่ต้องบันทึกรหัสโครงการพิเศษ CANCER แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('535', '681', 'C', 'ALL', 'บันทึกรหัสโครงการพิเศษ CANCER หรือ R9OPFS แต่ไม่มีรายการ Free Schudule', 'ตรวจสอบการบันทึกข้อมูลกรณีเบิกการรักษาโรคมะเร็งรับบริการที่ไหนก็ได้ที่พร้อม หรือบริการในเขต 9 นครราชสีมา (รหัสโครงการพิเศษ CANCER หรือ R9OPFS) ต้องบันทึกเบิกค่าใช้จ่ายตามรายการ Free Schedule แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('536', '682', 'C', 'ALL', 'บันทึกรหัสโครงการพิเศษ CANCER แต่ไม่ใช่หน่วยบริการที่มีศักยภาพในการรักษาโรคมะเร็ง', 'กรณีการรักษาโรคมะเร็งและบันทึกรหัสโครงการพิเศษ CANCER จะต้องเป็นหน่วยบริการที่ผ่านการประเมินศักยภาพตามที่ สปสช.กำหนดเท่านั้น หากไม่ใช่การรักษาโรคมะเร็งไม่ต้องบันทึกรหัสโครงการพิเศษ CANCER แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('537', '683', 'C', 'ALL', 'บันทึกรหัสโครงการพิเศษ CANCER และเงื่อนไขการเรียกเก็บเป็น OP Refer', 'กรณีเบิกการรักษาโรคมะเร็งรับบริการที่ไหนก็ได้ที่พร้อม (รหัสโครงการพิเศษ CANCER) ไม่ต้องบันทึกเงื่อนไขการเรียกเป็น OP Refer (เลือกเงื่อนไขการเรียกเก็บเป็น A E หรือ N ) แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('538', '684', 'C', 'ALL', 'เบิกยา Opioid แต่เป็นบริการข้ามจังหวัดกับหน่วยบริการประจำของผู้ป่วย', 'การเบิกยา Opioid เบิกได้เฉพาะกรณีให้บริการภายใน CUP หรือในจังหวัดเดียวกับหน่วยบริการประจำเท่านั้น กรณีข้ามจังหวัดไม่สามารถเบิกได้ แก้ไขให้ถูกต้องโดยเอารายการยา Opioid ออก บันทึกเบิกตามเงื่อนไขที่ให้บริการแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('539', '685', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่มีศักยภาพจัดบริการตรวจทางห้องปฏิบัติการนอกหน่วยบริการ', 'ไม่ใช่หน่วยบริการที่มีศักยภาพจัดบริการตรวจทางห้องปฏิบัติการนอกหน่วยบริการ ไม่สามารถเบิกค่าบริการเก็บสิ่งส่งตรวจได้ เอารหัสเบิก SpecC ในหน้าค่ารักษาพยาบาล หมวดค่าบริการอื่นๆ ที่ยังไม่จัดหมวดออก แล้วส่งเบิกตามเงื่อนไขอื่นๆ ส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('540', '686', 'C', 'ALL', 'เบิกค่าบริการเก็บสิ่งส่งตรวจ แต่ไม่ใช่ผู้ป่วย NCDs', 'ตรวจสอบการบันทึกรหัสโรค กรณีเบิกค่าบริการเก็บสิ่งส่งตรวจจะต้องเป็นผู้ป่วย NCDs เท่านั้น แก้ไขข้อมูลให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('541', '687', 'C', 'ALL', 'ไม่ใช่หน่วยบริการขึ้นทะเบียนหน่วยร่วมให้บริการในระบบหลักประกันสุขภาพแห่งชาติ', '่ไม่ใช่หน่วยบริการขึ้นทะเบียนหน่วยร่วมให้บริการในระบบหลักประกันสุขภาพแห่งชาติ ไม่สามารถเบิกค่าฉีดยา พ่นยา ค่าทำแผล ใส่สายกระเพาะปัสสาวะ หรือ สายสวนปัสสาวะได้ หากต้องการเบิกค่าจ่ายอื่นๆ ตัดรายการ….ออก ส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('542', '688', 'C', 'ALL', 'เบิกค่าบริการเยี่ยมบ้านมากกว่า 1 ครั้งต่อวันในผู้ป่วยรายเดียวกัน', 'การเบิกค่าบริการเยี่ยมบ้านเบิกได้ 1 ครั้ง/คน/วันเท่านั้น หากต้องการเบิกค่าจ่ายอื่นๆ ตัดรายการเยี่ยมบ้านออก ส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('543', '689', 'C', 'ALL', 'เบิกค่าบริการเยี่ยมบ้าน แต่ไม่ใช่หน่วยบริการเดิมที่ออกเยี่ยมบ้านในผู้ป่วยรายนี้', 'การเบิกค่าบริการเยี่ยมบ้าน จะต้องเป็นการออกเยี่ยมของหน่วยบริการเดิมเท่านั้น หน่วยบริการอื่นไม่สามารถเบิกซ้ำซ้อนกับหน่วยบริการเดิมได้ หากต้องการเบิกค่าจ่ายอื่นๆ ตัดรายการเยี่ยมบ้านออก ส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('544', '690', 'C', 'ALL', 'มีการเบิกบริการการเยี่ยมบ้านมากกว่า 10 รายต่อวัน', 'ตรวจสอบการบันทึกข้อมูลเบิก แก้ไขมาให้ถูกต้อง กรณีเยี่ยมมากกว่า 10 รายต่อวันจริง ให้อุทธรณ์มาเป็นรายกรณี', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('545', '691', 'C', 'ALL', 'มีการเบิกบริการการเยี่ยมบ้านต่างประเภทการเยี่ยมในรายเดียวกัน', 'ตรวจสอบประเภทกลุ่มที่เยี่ยมบ้าน แก้ไขมาใหถูกต้องตามกลุ่มของผู้ป่วย แล้วส่งเข้ามาใหม่อีกครั้ง (ไม่สามารถเบิกต่างกลุ่มในผู้ป่วยรายเดียวกันได้)', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('546', '692', 'C', 'ALL', 'เบิกยา opioids แต่ไม่ใช่หน่วยบริการที่มีศักยภาพฯ ตามที่ สปสช.กำหนด', 'ตรวจสอบการบันทึกข้อมูล กรณีเบิกยา opioids ต้องเป็นหน่วยบริการที่มีศักยภาพฯ ตามที่ สปสช.กำหนด กรณีไม่อยู่ในรายชื่อไม่สามารถเบิกได้ หากต้องการเบิกกรณีอื่นๆให้เอารายการยาออกแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('547', '693', 'C', 'ALL', 'หน่วยบริการ HD บันทึกเบิกกรณีการทำเส้น (Vascular access) ไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'หน่วยบริการ HD บันทึกเบิกกรณีการทำเส้น (Vascular access) ต้องบันทึกรหัสโครงการพิเศษ DMISHD ด้วยทุกครั้ง แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('548', '694', 'C', 'ALL', 'บันทึกข้อมูลการเบิกจ่ายกรณีบริการของคลินิกการพยาบาลและการผดุงครรภ์ไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'การบันทึกเบิกกรณีบริการของคลินิกการพยาบาลและการผดุงครรภ์ ต้องบันทึกรหัสโครงการพิเศษ NurseC ด้วยทุกครั้ง แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('549', '695', 'C', 'ALL', 'เบิกรายการ T1DM , GDM และ PDM มาใน visit เดียวกัน', 'รหัสรายการขอเบิกกรณี T1DM , GDM และ PDM ไม่สามารถเบิกรวมในรายการเดียวกันได้ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('550', '696', 'C', 'ALL', 'อายุไม่สอดคล้องกับเงื่อนไขที่กำหนดกรณีบริการแว่นตาสำหรับเด็กที่มีสายตาผิดปกติ', 'ตรวจสอบการบันทึก วัน เดือน ปีเกิดของผู้ป่วย แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง กรณีอายุน้อยกว่า 3 ปี หรือ มากกว่า 12 ปี ไม่สามารถเบิกกรณีบริการแว่นตาสำหรับเด็กที่มีสายตาผิดปกติได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('551', '701', 'C', 'ALL', 'สิทธิประกันสังคมเบิกกรณี รักษาโรคสมองด้วยวิธี STEREOTATIC RADIOSURGERY แต่รหัสโรคและรหัสหัตถการ ไม่สัมพันธ์ และไม่บันทึก SRTSSS ในบริการอื่นๆ ที่ไม่ได้จัดหมวด', '', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('552', '702', 'C', 'ALL', 'สิทธิประกันสังคม เบิกกรณีทำหมัน แต่ รพ.ที่รักษา ไม่ใช่ สถานพยาบาลที่ตามบัตรรับรองสิทธิฯ (Main Contractor) หรือ สถานพยาบาลเครือข่าย (Sub contractor)', '2.  ในกรณีที่มา admit ใหม่เพื่อรักษา heart rejection หรือ failure DRG V5', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('553', '703', 'C', 'ALL', 'สิทธิประกันสังคม บันทึกข้อมูลเบิกกรณีมะเร็งไม่ถูกต้อง ครบถ้วนตามเงื่อนไขที่กำหนด', 'กรณีเบิกมะเร็งโปรโตคอล ตรวจสอบการบันทึกรหัสเบิกหน้า F5 ให้ถูกต้อง ครบถ้วน \nกรณีเบิกมะเร็งอื่นนอกเหนือจากมะเร็ง 10 ชนิด ตรวจสอบการบันทึกเบิกจำนวนเงิน หน้า F5 (กรณีผู้ป่วยนอก) หรือ หน้า  F4 (กรณีผู้ป่วยใน) บันทึกให้ถูกต้อง ครบถ้วน แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('554', '704', 'C', 'ALL', 'กรณีสิทธิประกันสังคม ส่งเบิกไม่ตรงตามเงื่อนไขที่กำหนดให้ส่งเบิกผ่านโปรแกรมของ สปสช.', 'ตรวจสอบข้อมูลการเบิกต้องตรงตามเงื่อนไขที่สำนักงานประกันสังคมกำหนดให้ส่งเบิกผ่านโปรแกรม E-Claim หรือแก้ไขข้อมูลที่ขอเบิกให้ครบถ้วนตามเงื่อนไขที่กำหนด', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('555', '705', 'C', 'ALL', 'กรณีสิทธิประกันสังคม เบิกรายการอุปกรณ์ที่มีมากกว่า 1 ระดับ เบิกระดับอื่น แต่ไม่เบิกระดับแรก', 'ตรวจสอบการบันทึกเบิกรายการอุปกรณ์ให้ถูกต้อง กรณีรายการอุปกรณ์ที่มีมากกว่า 1 ระดับ ต้องเบิกระดับแรกด้วยจึงจะสามารถเบิกระดับอื่นได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('556', '706', 'C', 'ALL', 'มะเร็งโปรโตคอลแต่บันทึกเบิกเป็นกรณีมะเร็งทั่วไป', 'ตรวจสอบการให้รหัสโรค เบิกกรณีมะเร็งทั่วไป ต้องเป็นมะเร็งที่ไม่กำหนดโปรโตคอลเท่านั้น แก้ไขรหัสโรค หรือการเบิกให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('557', '707', 'C', 'ALL', 'เบิกยา  rt-PA รหัสโรค หรือ รหัสหัตถการ ไม่ถูกต้อง', 'ตรวจสอบการบันทึกรหัสโรค หรือรหัสหัตถการกรณีเบิกยา rt-PA ในผู้ป่วย  Stroke หรือ STEMI แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('558', '708', 'C', 'ALL', 'เบิกยา Streptokinase หรือ TNK-tPA  รหัสโรค หรือ รหัสหัตถการ ไม่ถูกต้อง', 'ตรวจสอบการบันทึกรหัสโรค หรือรหัสหัตถการกรณีเบิกยา Streptokinase หรือ TNK-tPA ในผู้ป่วย STEMI แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('559', '709', 'C', 'ALL', 'บันทึกเบิกยาละลายลิ่มเลือดมากกว่า 1 รายการ', 'ตรวจสอบการบันทึกเบิกยา Streptokinase หรือ rt-PA หรือ TNK-tPA ในผู้ป่วย Stroke/STEMI สามารถเบิกได้ 1 รายการเท่านั้น แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('560', '710', 'C', 'ALL', 'บันทึกเบิกยาละลายลิ่มเลือด (Stroke/STEMI) ที่ให้บริการก่อน 15 ก.ค 59', 'ตรวจสอบวันรับบริการ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ ส่งเบิกในโปรแกรม e-Claim ได้เฉพาะข้อมูลรับบริการตั้งแต่วันที่ 15 ก.ค 59 เป็นต้นไปเท่านั้น', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('561', '711', 'C', 'ALL', 'สถานพยาบาลที่รักษาไม่ตรงกับสถานพยาบาลในฐานสำนักงานประกันสังคม', 'กรณี สสจ.หรือ สสอ.ไม่สามารถบันทึกเบิกผ่านโปรแกรม e-Claim ได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('562', '712', 'C', 'ALL', 'บันทึกรหัสเบิกการตรวจร่างการ แต่รหัส ICD10 ไม่ตรงตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกรหัสเบิกกรณีตรวจสุขภาพในบริการอื่นที่ไม่จัดหมวด แก้ไขรหัสโรคหลัก (Pdx) .ให้ถูกต้อง แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('563', '713', 'C', 'ALL', 'บันทึกข้อมูลเบิกกรณีการตรวจร่างกายไม่ครบถ้วนตามเงื่อนไขที่กำหนด', 'ตรวจสอบกรณีเบิกการตรวจร่างกาย ต้องบันทึกรหัสโครงการพิเศษ SSSCHU และรหัสเบิก CUD001-CUD005 ในหน้าค่ารักษาพยาบาล หมวดบริการอื่นที่ยังไม่จัดหมวด แก้ไขให้ครบถ้วนแล้วส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('564', '714', 'C', 'ALL', 'บันทึกเบิกกรณีตรวจร่างกายไม่ตรงตามช่วงอายุที่กำหนด', 'ตรวจสอบสิทธิประโยชน์กรณีตรวจร่างกายสามารถเบิกได้ตามรายการและช่วงอายุที่กำหนดเท่านั้น', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('565', '715', 'C', 'ALL', 'จำนวนครั้งในการเบิกกรณีตรวจร่างกายมากกว่าสิทธิประโยชน์ที่กำหนด', 'ตรวจสอบรายการตรวจร่างกายที่บันทึกเบิก สามารถเบิกได้ตามจำนวนครั้งที่กำหนดต่อปีตามสิทธิประโยชน์ที่กำหนดเท่านั้น', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('566', '716', 'C', 'ALL', 'สถานพยาบาลที่บันทึกเบิกกรณีการตรวจร่างกายไม่ใช่สถานพยาบาลหลัก( Main Contractor)', 'การตรวจร่างกายบันทึกเบิกได้เฉพาะสถานพยาบาลหลัก (Main Contractor) เท่านั้น', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('567', '717', 'C', 'ALL', 'บันทึกเบิกสิทธิทุพพลภาพ ไม่ใช่สถานพยาบาลของรัฐ', 'สถานพยาบาลเอกชน ไม่สามารถบันทึกเบิกกรณีทุพพลภาพผ่านระบบโปรแกรม e-Claim', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('568', '718', 'C', 'ALL', 'ข้อมูลสิทธิทุพพลภาพ ที่ให้บริการ/จำหน่ายก่อน 1 ม.ค 61', 'ตรวจสอบวันที่รับบริการ/จำหน่าย แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่ กรณีให้บริการ/จำหน่ายก่อน 1 ม.ค 61 ส่งเบิกตามระบบเดิม', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('569', '719', 'C', 'ALL', 'ข้อมูลการเบิกของ รพ.จุฬาภรณ์ บันทึกข้อมูลเบิกไม่ตรงตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกรหัสโรคและรหัสหัตถการ แก้ไขให้ครบถ้วน ถูกต้องแล้วส่งเข้ามาอีกครั้ง กรณีทำหัตถการไม่ตรงตามเงื่อนไขที่ให้บันทึกผ่านโปรแกรมของ สปสช. ขอให้ส่งเบิกในระบบเดิม', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('570', '720', 'C', 'ALL', 'เบิกกรณีการรักษามะเร็งนอกโปรโตคอล แต่เป็นข้อมูลรับบริการก่อนวันที่ 11 กรกฎาคม 2560', 'ข้อมูลที่รักษาก่อนวันที่ 11 กรกฎาคม 2560 ไม่สามารถเบิกกรณีการรักษามะเร็งนอกโปรโตคอลได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('571', '721', 'C', 'ALL', 'หน่วยบริการ หรือสถานพยาบาลขอยกเลิกข้อมูล', 'แจ้งเพื่อทราบ', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('572', '722', 'C', 'ALL', 'กรณีรักษานอกโปรโตคอล ไม่สามารถบันทึกรหัสยาในโปรโตคอลได้', 'ตรวจสอบการบันทึกข้อมูลเบิกกรณีการรักษาโรคมะเร็งที่กำหนดโปรโตคอล หากรักษานอกโปรโตคอลให้บันทึกเป็นรหัส Non Protocol แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('573', '723', 'C', 'ALL', 'บันทึกเบิกกรณีรักษาโรคมะเร็งตามโปรโตคอล ไม่ตรงตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกข้อมูลเบิกกรณีการรักษาโรคมะเร็งตามโปรโตคอล ข้อมูลรักษาตั้งแต่วันที่ 11 พ.ย. 62 ให้บันทึกตามเงื่อนไขโปรโตคอล 20 ชนิด Update โปรแกรม e-Claim Version 2.10 เป็นต้นไป แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('574', '724', 'C', 'ALL', 'บันทึกเบิกกรณีรักษาโรคมะเร็งนอกโปรโตคอล (Non Protocol) รหัสโรคไม่ตรงตามเงื่อนไขที่กำหนด', 'ตรวจสอบการบันทึกรหัสโรค กรณีเบิก Non Protocol รหัสโรคต้องเป็นมะเร็งในกลุ่มโปรโตคอล แก้ไขให้ถูกต้องแล้วส่งเข้าใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('575', '725', 'C', 'ALL', 'สถานพยาบาลที่บันทึกเบิกไม่ตรงกับสถานพยาบาลที่รักษากรณีการตรวจคัดกรองโควิท 19', 'กรณีการตรวจคัดกรองโควิทต่างด้าว สิทธิประกันสังคม สถานพยาบาลที่ตรวจต้องเป็นสถานพยาบาลที่บันทึกเบิกเท่านั้น', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('576', '726', 'C', 'ALL', 'ไม่ใช่สถานพยาบาลที่กำหนดให้เบิกกรณี Home Isolation หรือ community Isolation ผ่านโปรแกรม e-Claim ของ สปสช.', 'กรณี Home Isolation หรือ community Isolation บันทึกเบิกผ่านโปรแกรม e-claim เฉพาะศูนย์บริการสาธารณสุข คลินิคชุมชนอบอุ่น และ รพสต.เท่านั้น สถานพยาบาลอื่นเบิกผ่านโปรแกรม สกส.', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('577', '727', 'C', 'ALL', 'ข้อมูลบริการ HI / CI ของ รพสต. สิทธิประกันสังคม ไม่สามารถเบิกผ่านโปรแกรม e-Claim ได้', 'ข้อมูลบริการ HI /CI ของ รพสต. ให้ รพ.แม่ข่าย เบิกกับสำนักงานประกันสังคม', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('578', '750', 'C', 'ALL', 'บันทึกประเภทการให้บริการ (OPTYPE) ไม่สอดคล้องกับรูปแบบเครือข่ายของหน่วยบริการ (Model)', 'ตรวจสอบการบันทึกประเภทการให้บริการ (OPTYPE) ต้องสอดคล้องกับรูปแบบเครือข่ายของหน่วยบริการ (Model) เช่น OPTYPE=9 จะต้องเป็นหน่วยบริการ Model 5 เท่านั้น', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('579', '751', 'C', 'ALL', 'บันทึกรายการแพทย์แผนไทย แต่ไม่ใช่หน่วยบริการที่รับการส่งต่อเฉพาะด้านแพทย์แผนไทย หรือเบิกรายการแพทย์แผนไทย ร่วมกับบริการอื่นๆ', 'ตรวจสอบศักภาพหน่วยบริการ หากไม่ใช่หน่วยบริการที่รับการส่งต่อเฉพาะด้านแพทย์แผนไทย หรือเบิกรายการแพทย์แผนไทย ร่วมกับบริการอื่นๆ ไม่สามารถเบิกได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('580', '752', 'C', 'ALL', 'เป็นหน่วยบริการที่ไม่สามารถเบิกกรณีสิทธิผู้มีปัญหาสถานะและสิทธิ (Stateless) ได้', 'กรณีไม่ใช่หน่วยบริการตามที่กองเศรษฐกิจฯ กำหนดให้เบิกกรณีผู้มีปัญหาและสิทธิ (Stateless) ไม่สามารถเบิกผ่านโปรแกรม eclaim ได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('581', '753', 'C', 'ALL', 'ผู้มีปัญหาสถานะและสิทธิ (Stateless) ข้อมูลรับบริการไม่อยู่ในช่วงที่สามารถเบิกผ่านระบบของ สปสช. ได้', 'ข้อมูล OP รับบริการก่อน 1 มกราคม 2565 หรือข้อมูล IP จำหน่ายก่อน 1 มกราคม 2565 ส่งข้อมูลเบิกผ่านระบบของกระทรวงสาธารณสุข', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('582', '754', 'C', 'ALL', 'ผู้มีปัญหาสถานะและสิทธิ (Stateless) ส่งเบิกไฟล์ไม่ถูกต้อง', 'ข้อมูลที่ส่งตั้งแต่วันที่ 1 กค. 2565 แก้ไขเลือกสิทธิประโยชน์เป็น STP ส่งเบิกมาในไฟล์ STP เท่านั้นไม่สามารถส่งเบิกในไฟล์ UCS ได้', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('583', '800', 'C', 'ALL', 'รหัสโรครองใช้ไม่ได้ (ผิดหลักการให้ ICD10)', 'ตรวจสอบการให้รหัสการวินิจฉัยโรคหลักให้ถูกต้องตามหลักเกณฑ์การให้รหัสแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('584', '801', 'C', 'ALL', 'รหัสโรคไม่สอดคล้องกับเพศ(โรคที่เป็นเฉพาะเพศ เช่น มะเร็งรังไข่)', 'ตรวจสอบรหัสโรคหรือเพศผู้ป่วย แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('585', '802', 'C', 'ALL', 'รหัสโรครอง ( Sdx.) ไม่สอดคล้องกับอายุ', 'ตรวจสอบการวินิจฉัยและวันเดือน ปี เกิด หรืออายุ ให้สอดคล้องกับการวินิจฉัย', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('586', '803', 'C', 'ALL', 'รหัสการวินิจฉัยอื่นซ้ำกับโรคหลัก', 'ตรวจสอบรหัสการวินิจฉัยโรคหลักและโรครอง แก้ไขไม่ให้มีรหัสซ้ำซ้อน แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('587', '804', 'C', 'ALL', 'รหัสหัตถการใช้ไม่ได้ ( ผิดหลักการให้ ICD9 )', 'ตรวจสอบการให้รหัสหัตถการ  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('588', '806', 'C', 'ALL', 'รหัสหัตถการไม่สอดคล้องกับเพศ', 'ตรวจสอบหัสหัตถการหรือเพศผู้ป่วย แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('589', '807', 'C', 'ALL', 'รหัสหัตถการ 9672 ต้องมีระยะเวลาการ admit ไม่น้อยกว่า 96 ชม.', 'ตรวจสอบวันที่/เวลา การเข้ารับบริการ-จำหน่าย  ต้องไม่น้อยกว่า 96 ชม. แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('590', '808', 'C', 'ALL', 'รหัสโรค Anaemia in neoplasms ไม่มีหัตถการให้เลือด', 'ตรวจสอบการให้รหัสโรค กรณีให้รหัส D630 ต้องมีหัตถการให้เลือด หากไม่มีการให้เลือด ให้เลือกประเภทโรครองเป็น Other', '1', '2025-12-22 10:25:14', '2025-12-22 10:25:14');
INSERT INTO `error_codes` VALUES ('591', '809', 'C', 'ALL', 'ให้รหัสโรคเกร็ดเลือดต่ำ ร่วมกับรหัสโรค Dengue hemorrhagic fever  ไม่มีรหัสหัตถการให้เกร็ดเลือด', 'ตรวจสอบการให้รหัสโรค กรณีให้รหัส Pdx = A91หากไม่มีรหัสหัตถการให้เกร็ดเลือด 99.05 ไม่สามารถให้รหัสโรครอง Sdx = D69.- ได้', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('592', '810', 'C', 'ALL', 'ให้รหัสประเภทโรคเบาหวานไม่สอดคล้องกับอายุ', 'ตรวจสอบการให้รหัสโรคเบาหวานกรณีอายุตั้งแต่ 50 ปีขึ้นไป ไม่สามารถให้รหัส Pdx or Sdx = E10.-ได้ แก้ไขรหัสโรคเบาหวานให้เหมาะสมกับอายุแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('593', '811', 'C', 'ALL', 'ให้รหัส Hyperglycemia ร่วมกับรหัสโรคเบาหวาน', 'ตรวจสอบการให้รหัสโรค กรณีโรคเบาหวาน ไม่สามารถให้ร่วมกับรหัส Hyperglycemia (R739) ได้ แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('594', '812', 'C', 'ALL', 'ให้รหัสโรคไตวายเฉียบพลันร่วมกับรหัสโรคไตวายเรื้อรัง', 'ตรวจสอบการให้รหัสโรค โรคไตวายเฉียบพลัน N17-ไม่สามารถให้ร่วมกับโรคไตวายเรื้อรัง N185 ได้ แก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('595', '813', 'C', 'ALL', 'ให้รหัสหัตถการไม่สอดคล้องกับกรณีการคลอดปกติ', 'ตรวจสอบการให้รหัสโรคหรือรหัสหัตถการ กรณีการคลอดปกติ (O80.0) ไม่สามารถให้ร่วมกับหัตถการ 86.22 ได้ แก้ไขรหัสโรค หรือรหัสหัตถการให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('596', '814', 'C', 'ALL', 'ให้รหัสโรคไม่สัมพันธ์กับกรณีผู้บริจาคไต', 'ตรวจสอบการให้รหัสโรคให้สัมพันธ์กับกรณีผู้บริจาคไต (Z524)', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('597', '815', 'C', 'ALL', 'ผู้ป่วยฟอกเลือดล้างไต มีการเรียกเก็บค่าบริการพยาบาลซ้ำซ้อนกับระบบ HD', 'ตรวจสอบการเบิกกรณีผู้ป่วยฟอกเลือดล้างไต HD ให้เบิกค่ารักษาที่เกี่ยวข้องกับ HD ในโปรแกรมที่กำหนด (HD/DMISHD) เท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('598', '816', 'C', 'ALL', 'บันทึกรหัสโรคไม่ถูกต้องกรณีการเบิกวัคซีนพิษสุนัขบ้า', 'ตรวจสอบการบันทึกรหัสโรค (ICD10) กรณีการเบิกวัคซีนพิษสุนัขบ้า แก้ไขให้ถูกต้อง แล้วส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('599', '817', 'C', 'ALL', 'บันทึกเบิกกรณี CRRT (Continuous Renal Replacement Theraphy) รหัสโรค รหัสหัตถการไม่ตรงตามเงื่อนไขที่กำหนด', 'กรณีเบิกรหัส CRRT1, CRRT2 หรือ 71642, 71643  ต้องเป็นผู้ป่วยไตวายเฉียบพลันที่อยู่ในภาวะวิกฤติเท่านั้น หากไม่ใช่ไม่สามารถเบิก 2 รหัสนี้ได้ ตรวจสอบรหัสโรค และรหัสหัตถการ แก้ไขมาให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('600', '818', 'C', 'ALL', 'บันทึกเบิกกรณี CRRT (Continuous Renal Replacement Theraphy) มากกว่าจำนวนที่กำหนด', 'กรณีเบิกรหัส CRRT1 หรือ 71642 เบิกได้ 1 วันต่อการเข้ารับบริการ   แก้ไขมาให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('601', '819', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่มีศักยภาพ กรณีบริการบำบัดทดแทนไตแบบต่อเนื่อง (CRRT) สำหรับผู้ป่วยไตวายเฉียบพลันที่อยู่ในภาวะวิกฤต', 'กรณีที่หน่วยบริการให้การรักษาจริงให้ส่งเอกสารอุทธรณ์ มาที่ สปสช. เพื่อยืนยัน', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('602', '820', 'C', 'ALL', 'บันทึกเบิกกรณี CRRT (Continuous Renal Replacement Theraphy) รหัส CRRT1 และ CRRT2 รวมกันเกินจำนวนวันนอน (LOS)', 'ตรวจสอบการบันทึกรหัส CRRT1 และ CRRT2 รวมกัน จำนวนที่เบิกต้องไม่เกินวันนอน (LOS) แก้ไขมาให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('603', '831', 'C', 'ALL', 'HN ตรงกับรายที่เคยส่งแล้ว แต่วันเดือนปีเกิดไม่ตรงกัน', 'ตรวจสอบ HN หรือวันเดือนปีเกิด แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('604', '832', 'C', 'ALL', 'เป็นสิทธิที่ไม่สามารถบันทึกเบิกผ่านระบบโปรแกรม (e-claim) ของ สปสช. ได้', 'เบิกตามเงื่อนไขที่กำหนด ตามสิทธิของผู้ป่วย', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('605', '833', 'C', 'ALL', 'มีสิทธิเบิกส่วนต่าง แต่ไม่บันทึกรหัสโครงการพิเศษ', 'กรณีมีสิทธิเบิกส่วนต่าง ต้องบันทึกรหัสโครงการพิเศษให้ถูกต้องตามประเภทที่ขอเบิก แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('606', '834', 'C', 'ALL', 'กรณีเบิกส่วนต่างค่าทำฟันของสิทธิประกันสังคมจากสิทธิข้าราชการ ไม่สามารถเบิกในระบบเบิกจ่ายตรงได้', 'การเบิกส่วนต่างค่าทำฟันของสิทธิประกันสังคม จากสิทธิข้าราชการให้สำรองจ่ายแล้วเบิกจากหน่วยงานต้นสังกัด', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('607', '835', 'C', 'ALL', 'ผู้มีสิทธิถูกระงับสิทธิเบิกจ่ายตรงโดยกรมบัญชีกลาง ไม่สามารถส่งเบิกในระบบเบิกจ่ายได้', 'ไม่สามารถส่งเบิกได้ ผู้มีสิทธิต้องสำรองจ่ายและนำใบเสร็จเบิกจากหน่วยงานต้นสังกัด กรณีต้องการแก้ไขข้อมูลที่ติด C เลือกเป็นไม่ใช้สิทธิแล้วส่งเข้าระบบอีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('608', '840', 'C', 'ALL', 'การตรวจคัดกรอง Covid19 เชิงรุกไม่ระบุเลขที่หนังสือที่ได้รับการอนุมัติจากคณะกรรมการโรคติดต่อจังหวัด', 'ตรวจสอบการบันทึกข้อมูลหน้า F1 กรณีการตรวจคัดกรอง Covid19 เชิงรุก กรุณาบันทึกเลขที่หนังสือที่ได้รับการอนุมัติจากคณะกรรมการโรคติดต่อจังหวัด ในช่องเลขที่ใบ “เลขที่ใบรับส่งต่อ” และบันทึกรับจาก สสจ.ที่อนุมัติ แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('609', '841', 'C', 'ALL', 'สถานะหน่วยบริการที่ไม่สามารถเบิกค่าดูแลผู้สัมผัสใกล้ชิดเสียงสูงในสถานกักกันโรค (High Risk closed contract) ได้', 'การเบิกค่าดูแลผู้สัมผัสใกล้ชิดเสียงสูงในสถานกักกันโรค (High Risk closed contract) รหัสโครงการพิเศษ HOSPIQ ต้องเป็นหน่วยรับส่งต่อทั่วไป และรับส่งต่อเฉพาะด้านโควิท ของ สปสช.เท่นนั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('610', '842', 'C', 'ALL', 'เบิกค่าดูแลผู้สัมผัสใกล้ชิดเสียงสูงในสถานกักกันโรค (High Risk closed contract) HOSIQ  แต่เป็นผู้ป่วย Covid19', 'ตรวจสอบรหัสโรค กรณีมีการติดเชื้อ Covid10 (U071) ให้บันทึกเป็นกรณีการรักษาโดยไม่ต้องบันทึกรหัสโครงการพิเศษ HOSPIQ และไม่เบิกค่าห้องรหัส COVR04 แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('611', '850', 'C', 'ALL', 'กรณีอุบัติเหตุ แต่ไม่มีวันที่และเวลาเกิดอุบัติเหตุ', 'บันทึกวันที่และเวลาที่เกิดอุบัติเหตุให้ถูกต้อง  แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('612', '851', 'C', 'ALL', 'วันที่เกิดอุบัติเหตุก่อน admit 28 วันขึ้นไป หรือหลังวัน Admit', 'ตรวจสอบและบันทึกวันที่และเวลาที่เกิดอุบัติเหตุให้ถูกต้อง  แล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('613', '852', 'C', 'ALL', 'กรณีผู้ป่วยนอกเบิกค่ารักษาพยาบาลในรหัส 58001 และ 58020 ภายในวันเดียวกัน', 'ตรวจสอบการบันทึกเบิก รหัส 58001 และ 58020 ในวันเดียวกันสามารถเบิกได้เพียงรหัสเดียว แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('614', '853', 'C', 'ALL', 'กรณีผู้ป่วยนอกเบิกค่ารักษาพยาบาลในรหัส 58101,58102,58130,58131 และ 58201 ภายในวันเดียวกัน', 'ตรวจสอบการบันทึกเบิก รหัส 58101,58102,58130,58131 และ 58201 ในวันเดียวกันสามารถเบิกได้เพียงรหัสเดียว แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('615', '854', 'C', 'ALL', 'รหัสเบิก 6207 และ 2011 เบิกได้เฉพาะผู้ป่วยในเท่านั้น', 'ตรวจสอบการบันทึกรหัสเบิก 6207 และ 2011 เบิกได้เฉพาะผู้ป่วยในเท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('616', '855', 'C', 'ALL', 'เบิกรหัส 6207 ร่วมกับรหัส 6206', 'ตรวจสอบการบันทึกรหัสเบิก 6207 และ 6206 ไม่สามารถเบิกพร้อมกันใน visit เดียวกันได้ แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('617', '856', 'C', 'ALL', 'เบิกรหัส 6207 ร่วมกับการบันทึกรหัส project code KTLGOD', 'ตรวจสอบการบันทึกรหัสเบิก 6207 ค่าเตรียมและผ่าตัดนำไตออกจากจากผู้บริจาคที่เสียชีวิต ไม่สามารถเบิกร่วมกับ project code KTLGOD ซึ่งใช้กรณีผู้บริจาคมีชีวิตได้ แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('618', '857', 'C', 'ALL', 'เบิกรหัส 6206  หรือ 6207  ร่วมกับรหัส 5601', 'ตรวจสอบการบันทึกรหัสเบิก 6206 หรือ 6207 ไม่สามารถเบิกร่วมกับรหัส 5601 ใน visit เดียวกันได้ แก้ไขแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('619', '858', 'C', 'ALL', 'ข้อมูลการปลูกถ่ายอวัยวะ รับบริการก่อน 1 ตุลาคม 2559', 'ตรวจสอบวันรับบริการ กรณีการปลูกถ่ายอวัยวะก่อน 1 ตุลาคม 2559 ไม่สามารถบันทึกเบิกได้ (อุทธรณ์เป็นเอกสารเป็นรายๆ)', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('620', '888', 'C', 'ALL', 'กรณีขออุทรณ์ไม่พบข้อมูลอ้างอิงในฐานของ สปสช.', 'ให้ติดต่อ สปสช. ส่วนกลาง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('621', '889', 'C', 'ALL', 'เป็นข้อมูลที่ไม่สามารถอุทธรณ์ได้เนื่องจากอยู่ระหว่างการปิด Global Budget ของ สปสช.', 'ตรวจสอบข้อมูลที่ต้องการอุทธรณ์ต้องเป็นข้อมูลที่ได้รับการตอบกลับจาก สปสช. เป็นกรณี Appeal nhso แล้ว ดาวน์โหลดผ่านเมนู Appeal ส่งเข้ามาอีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('622', '890', 'C', 'ALL', 'ผู้ป่วยสิทธิว่าง (PUC) ไม่สามารถบันทึกเบิกได้', 'ข้อมูลการรักษาผู้ป่วยสิทธิว่าง (PUC) ของ รพ.กรุงเทพ หาดใหญ่ ไม่สามารถบันทึกเบิกผ่านระบบ e-Claim ได้', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('623', '891', 'C', 'ALL', 'ข้อมูลการตรวจวินิจฉัยราคาแพงและหัตถการโรคหัวใจปีงบประมาณ 2558 เบิกในระบบ OP/IP ปกติ', 'ตรวจสอบการบันทึกข้อมูลกรณีการตรวจวินิจฉัยราคาแพงและหัตถการโรคหัวใจ ข้อมูลรับบริการ/จำหน่ายตั้งแต่วันที่ 1 ต.ค 57 ให้บันทึกเบิกเป็นกรณี OP/IP ปกติ โดยไม่ต้องบันทึกเบิกในหน้า F4', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('624', '892', 'C', 'ALL', 'การอุทธรณ์ (Appeal) ข้อมูล OP Refer กรณีเปลี่ยนเงื่อนไขการเรียกเก็บ ไม่ถูกต้องตามเงื่อนไขที่กำหนด', 'การอุทธรณ์ (Appeal) ข้อมูล OP Refer กรณีเปลี่ยนเงื่อนไขการเรียกเก็บ แก้ไขข้อมูล OP Refer ก่อน โดยขยับวันที่รับบริการไม่ให้ตรงกับข้อมูลที่จะส่งเบิกใหม่ และเลือกไม่ใช้สิทธิ เมื่อข้อมูล OP Refer ที่ Appeal ผ่านแล้วจึงบันทึกข้อมูลที่ต้องการเบิกเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('625', '893', 'C', 'ALL', 'กรณีอุทธรณ์ (Apeal) หน่วยบริการที่รักษาไม่ตรงกับข้อมูลเดิม', 'ตรวจสอบการตั้งค่าหน่วยบริการ กรณีการอุทธรณ์ (Appeal) หน่วยบริการที่รักษาต้องเป็นหน่วยบริการเดิมกับข้อมูลตั้งต้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('626', '894', 'C', 'ALL', 'โครงสร้างข้อมูลอุทธรณ์ไม่ถูกต้อง', 'ตรวจสอบข้อมูลการอุทธรณ์ ต้องเป็นไฟล์ appeal เท่านั้น ดำเนินการแก้ไขแล้วส่งเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('627', '895', 'C', 'ALL', 'ไม่ใช่ผู้มีสัญชาติไทย ไม่สามารถเบิกกรณีส่งเสริมป้องกันโรคจากกองทุนหลักประกันสุขภาพแห่งชาติได้', 'ตรวจสอบเลขบัตรประชาชน หากเป็นผู้มีสัญชาติไทยแก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง หากไม่ใช่ผู้มีสัญชาติไทย ไม่สามารถเบิกได้', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('628', '896', 'C', 'ALL', 'ผู้มีปัญหาสถานะและสิทธิ STP ไม่สามารถเบิกกรณีส่งเสริมป้องกันโรคจากกองทุนหลักประกันสุขภาพแห่งชาติได้', 'ส่งข้อมูลเบิกผ่านระบบของกระทรวงสาธารณสุข', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('629', '897', 'C', 'ALL', 'เลือกสิทธิประโยชน์ที่ขอเบิกไม่ถูกต้อง กรณีสิทธิอื่นที่ขอกรณีส่งเสริมป้องกันโรคจากกองทุนหลักประกันสุขภาพแห่งชาติ', 'สิทธิอื่นที่ขอเบิกกรณีส่งเสริมป้องกันโรคจากกองทุนหลักประกันสุขภาพแห่งชาติให้เลือกสิทธิประโยชน์ เป็น UC แก้ไขให้ถูกต้องแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('630', '898', 'C', 'ALL', 'สิทธิหลักประกันสังคม ไม่สามารถเบิกจากสิทธิร่วมได้', 'เป็นผู้มีสิทธิหลักประกันสังคม ไม่สามารถเบิกจากสิทธิร่วมอื่นได้', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('631', '899', 'C', 'ALL', 'สิทธิหลักประกันสังคม เบิกส่วนต่างจากสิทธิร่วมไม่ตรงตามสิทธิประโยชน์ที่กำหนด', 'ผู้มีสิทธิประกันสังคม จะเบิกส่วนต่างจากสิทธิข้าราชการ หรือ อปท.ได้ตามเงื่อนไขที่กำหนดเท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('632', '900', 'C', 'ALL', 'เป็นผู้มีสิทธิข้าราชการร่วมกับสิทธิ อปท ไม่สามารถเบิกจากสิทธิ อปท.ได้', 'กรณีมีสิทธิร่วมข้าราชการและ อปท. ต้องใช้สิทธิเบิกจากสิทธิข้าราชการกรมบัญชีกลางเท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('633', '901', 'C', 'ALL', 'เลือกสิทธิประโยชน์ที่ขอเบิกไม่ถูกต้อง กรณีสิทธิอื่นที่ขอการคัดกรอง Covid19 จากกองทุนหลักประกันสุขภาพแห่งชาติ', 'กรณีสิทธิอื่นที่ขอเบิกการคัดกรอง Covid19 ให้เลือกสิทธิประโยชน์เป็น UCS', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('634', '902', 'C', 'ALL', 'เลขบัตรประชาชนที่บันทึกเบิก มีสถานะเสียชีวิตแล้ว', 'ตรวจสอบการบันทึกเลขบัตรประชาชน แก้ไขมาให้ถูกต้อง กรณีเสียชีวิตหลังรับบริการส่งเวชระเบียนยืนยันการให้บริการมาที่ สปสช.', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('635', '911', 'C', 'ALL', 'เป็นข้อมูลผู้ป่วยนอกที่ไม่เข้าเกณฑ์เบิกจ่ายที่ส่วนกลาง หรือกรณีขอเบิก OPHC / อุปกรณ์อวัยวะเทียม มีจำนวนเงินรวม แต่ไม่ระบุรายการที่ขอเบิก', 'หากเป็นการให้บริการภายในจังหวัด ไม่ต้องส่งข้อมูลเข้ามาเนื่องจากไม่เข้าเกณฑ์การเบิกจ่ายที่ส่วนกลาง ยกเว้นกรณีดังต่อไปนี้ \n๏  หากเป็นการเบิกกรณี OPHC ไม่ต้องเลือกเงื่อนไขการเรียกเก็บให้ระบุกรณีที่ขอเบิกเช่น  Cryptococcal meningitis หรือ CA breast มาให้ครบถ้วนและถูกต้อง \n๏ หากเป็นการขอเบิกอุปกรณ์/อวัยวะเทียม ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ แต่ให้ระบุรายการที่ขอเบิกมาให้ครบถ้วนและถูกต้อง \n๏  หากเป็นกรณีสิทธิว่าง ให้ระบุเงื่อนไขการเรียกเก็บว่าเป็น Normal, Accident หรือ Emergency แล้วแต่กรณี  \n๏  หากเป็นกรณี STROKE / STEMI  ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ บันทึกรัหสโรค รหัสหัตถการให้ครบถ้วนตามเงื่อนไขที่กำหนด \n๏  หากเป็นกรณีส่งเสริมป้องกันโรค บันทึกข้อมูลหน้าส่งเสริมป้องกันโรคให้ครบถ้วน ตามเงื่อนไขที่กำหนด  ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ ยกเว้นกรณีสิทธิว่างเลือกเงื่อนไขการเรียกเก็บตามจริง \n๏ หากเป็นการขอเบิกกรณีคุมกำเนิดกึ่งถาวรในวัยรุ่น ไม่ต้องเลือกเงื่อนไขการเรียกเก็บ แต่ให้ระบุรายการที่ขอเบิกมาให้ครบถ้วนและถูกต้อง  \n๏ หากสถานะเป็นลงทะเบียนตามมติบอร์ด status card 009 และ รพ.ที่รักษา = รพ.หลัก เบิกกรณี OPAE ได้', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('636', '912', 'C', 'ALL', 'ถูกระงับการจ่ายโดยกรมบัญชีกลาง', 'ติดต่อกรมบัญชีกลาง สปสช.จะแก้ไขข้อมูลตามที่กรมบัญชีกลางแจ้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('637', '913', 'C', 'ALL', 'ถูกระงับการจ่าย จากการ Audit', 'แก้ไขข้อมูลตามผลการ audit เมื่อได้รับการอนุมัติแล้วส่งข้อมูลเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('638', '914', 'C', 'ALL', 'บันทึกเบิกในหมวด 7 ค่าตรวจวินิจฉัยทางเทคนิคการแพทย์และพยาธิวิทยา ไม่ถูกต้องตามหลักเกณฑ์ที่กำหนด', 'การบันทึกเบิกในหมวด 7 ค่าตรวจวินิจฉัยทางเทคนิคการแพทย์และพยาธิวิทยา ต้องจัดทำรายการ Lab catalog และบันทึกเบิกในโปรแกรม e-Claim ด้วยรายการ Lab ที่มีรหัส TMLT ที่ผ่านการตรวจสอบจากเวบ Lab catalog แล้วเท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('639', '921', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่ให้บริการผ่าตัดเปลี่ยนไต', 'กรณีที่หน่วยบริการให้การรักษาจริงให้ส่งเอกสารอุทธรณ์ มาที่ สปสช. เพื่อยืนยัน', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('640', '931', 'C', 'ALL', 'เบิกกรณี ER คุณภาพ ไม่บันทึกเงื่อนไขการเรียกเก็บ', 'การเบิกกรณี ER คุณภาพ ต้องบันทึกเงื่อนไขการเรียกเก็บเป็น N/A/E/OPrefer แก้ไขข้อมูลให้ถูกต้อง แล้วส่งใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('641', '932', 'C', 'ALL', 'เบิกกรณี ER คุณภาพ เวลาเข้ารับบริการเป็นในเวลาราชการ', 'การเบิกกรณี ER คุณภาพ เบิกได้เฉพาะนอกเวลาราชการ วันหยุดเสาร์-อาทิตย์ หรือวันหยุดราชการประจำปี หรือวันหยุดพิเศษอื่น ๆ ที่กำหนดเพิ่มเติมให้เป็นวันหยุดราชการนอกเหนือจากวันหยุดราชการประจำปี', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('642', '933', 'C', 'ALL', 'ไม่ใช่หน่วยบริการที่เข้าร่วมดำเนินการตามโครงการ ER คุณภาพ', 'ปีงบประมาณ 2563 เบิกได้เฉพาะหน่วยบริการนำร่อง เท่านั้น หน่วยบริการอื่นๆ จะได้รับการจ่ายชดเชยตามระบบปกติ', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('643', '934', 'C', 'ALL', 'เบิกกรณี ER คุณภาพ ไม่ใช่สิทธิ UC', 'การเบิกกรณี ER คุณภาพ เบิกได้เฉพาะสิทธิ UC เท่านั้น สิทธอื่น ไม่สามารถเบิกได้ การแก้ไขให้เลือกเป็นไม่ใช้สิทธิ UUC=2 เพื่อไม่ให้มีข้อมูลติด C ค้างในระบบ', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('644', '935', 'C', 'ALL', 'เบิกกรณี ER คุณภาพ ไม่ใช่ประเภทผู้ป่วยนอก', 'การเบิกกรณี ER คุณภาพ จ่ายชดเชยเพิ่มเติมเฉพาะกรณีผู้ป่วยนอกเท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('645', '936', 'C', 'ALL', 'เลือกเงื่อนไขการเรียกเก็บเป็น “ย้ายหน่วยเกิดสิทธิทันที” แต่ไม่ใช่ผู้ป่วยเปลี่ยนหน่วยบริการได้สิทธิทันที', 'ตรวจสอบการเลือกเงื่อนไขการเรียกเก็บในหน้า F1 กรณีไม่ใช่ผู้ป่วยเปลี่ยนหน่วยบริการ สามารถเบิกได้เป็นกรณี AE หรือ OP Refer ตามเงื่อนไขที่กำหนดเดิม แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('646', '939', 'C', 'ALL', 'เลือกเงื่อนไขการเรียกเก็บเป็น  “ย้ายหน่วยเกิดสิทธิทันที”  ไม่บันทึกรายการ Free Schedule (FS) หรือรายการ FS ที่บันทึกไม่อยู่ในรายการที่กำหนด', 'ตรวจสอบการบันทึกค่ารักษาพยาบาลหน้า F8 กรณีผู้ป่วยย้ายหน่วยบริการ (เงือนไขการเรียกเก็บ =  “ย้ายหน่วยเกิดสิทธิทันที” ) ต้องบันทึกเบิกค่าใช้จ่ายเป็นรายการ Free Schedule (FS)  แก้ไขให้ถูกต้องแล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('647', '940', 'C', 'ALL', 'เลือกเงื่อนไขการเรียกเก็บไม่ถูกต้อง กรณีผู้ป่วยเปลี่ยนหน่วยบริการได้สิทธิทันที', 'ผลการตรวจสอบสิทธิเป็นกรณีผู้ป่วยเปลี่ยนหน่วยบริการได้สิทธิทันที แก้ไขเงื่อนไขการเรียกเก็บเป็น  “ย้ายหน่วยเกิดสิทธิทันที”  และบันทึกค่ารักษาพยาบาลหน้า F8 เป็นรายการ Free Schedule (FS)  แล้วส่งเข้ามาใหม่อีกครั้ง', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('648', '997', 'C', 'ALL', 'สิทธิประกันสังคม เบิกกรณีไตวายเฉียบพลัน, Instrument, Stereotactic Radiosurgery, Cryptococcal meningitis, กรณีหมันชาย/หมันหญิง ที่ส่งข้อมูลล่าช้าเกินระยะเวลา ที่ สปส.กำหนด', 'ตรวจสอบข้อมูลที่ส่งต้องเป็นไปตามระยะเวลาที่สิทธิ ประกันสังคมกำหนด เบิกกรณีไตวายเฉียบพลัน, Instrument, Stereotactic Radiosurgery, Cryptococcal meningitis, กรณีหมันชาย/หมันหญิง ที่ส่งข้อมูลล่าช้าเกินระยะเวลา คือ ส่งข้อมูลได้ภายใน 2 ปี นับจากวันที่รับบริการ(OP),หรือนับจากวัน D/C ยกเว้นมะเร็งโปรโตคอล', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('649', '998', 'C', 'ALL', 'ส่งข้อมูลเกินกำหนด', 'ตรวจสอบข้อมูลที่ส่ง ต้องเป็นไปตามระยะเวลาที่กำหนดของแต่ละสิทธิ ข้อมูลในแต่ละปีงบประมาณ สามารถส่งได้ถึง 30 ก.ย ของปีงบประมาณถัดไปเท่านั้น', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('650', '999', 'C', 'ALL', 'ไม่พบข้อมูลในฐานการตรวจสอบสิทธิของ สปสช. / สนบท.', '1. ตรวจสอบความถูกต้องของ PID \n2. ตรวจสอบสิทธิผ่านหน้าเวบ สปสช. หากพบข้อมูลในฐานของ สปสช. แล้ว ให้ส่งข้อมูลเข้ามาใหม่', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('651', 'AP1', 'E', 'ALL', 'เป็นข้อมูลเดิมกรณีขอ EAppeal, ซึ่งข้อมูลนี้จะไม่ถูกออก Statement แต่จะนำข้อมูลใหม่ไปออกแทน', 'เป็นการแจ้งเพื่อทราบ', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('652', 'EA1', 'E', 'ALL', 'เป็นข้อมูลเดิมกรณีขอ EAppeal, ซึ่งข้อมูลนี้จะไม่ถูกออก Statement แต่จะนำข้อมูลใหม่ไปออกแทน', 'เป็นการแจ้งเพื่อทราบ', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('653', 'C01', 'C', 'SSS', 'ไม่มีสิทธิประกันสังคม', 'ตรวจสอบเลขบัตรประชาชน', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('654', 'C02', 'C', 'SSS', 'วันที่รักษาไม่มีสิทธิประกันสังคม', 'ตรวจสอบวันที่รักษากับวันมีสิทธิ', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('655', 'C03', 'C', 'SSS', 'สถานพยาบาลไม่อยู่โครงการประกันสังคม', 'ติดต่อ สปส.', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('656', 'C04', 'C', 'SSS', 'ส่งเบิกค่ารักษาซ้ำซ้อนใน รพ.เดียวกัน', 'ตรวจสอบการส่งซ้ำ', '1', '2025-12-22 10:25:15', '2025-12-22 10:25:15');
INSERT INTO `error_codes` VALUES ('657', 'C05', 'C', 'SSS', 'ส่งเบิกค่ารักษาซ้ำซ้อนในต่าง รพ.', 'ตรวจสอบการส่งซ้ำ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('658', 'C06', 'E', 'SSS', 'Authcode ไม่ถูกต้อง', 'ตรวจสอบรหัสอนุมัติ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('659', 'C07', 'E', 'SSS', 'รหัสสถานพยาบาลหลักไม่ถูกต้อง (Hmain)', 'ตรวจสอบรหัส Hmain', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('660', 'C08', 'E', 'SSS', 'Hcode ใน Invoice No. เดียวกันไม่ตรงกันใน BillTran, BillDisp, OPServices', 'Hcode ต้องตรงกันทุก file', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('661', 'H01', 'C', 'SSS', 'Authorization Code ของยาแฟคเตอร์ไม่ถูกต้อง', 'ตรวจสอบ Authcode', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('662', 'H02', 'C', 'SSS', 'Hcode ไม่ตรงกับตัวรับยาแฟคเตอร์', 'ตรวจสอบ Hcode กับ PID', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('663', 'H03', 'C', 'SSS', 'PID ไม่ตรงกับตัวรับยาแฟคเตอร์', 'ตรวจสอบ PID กับ Hcode', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('664', 'H04', 'C', 'SSS', 'HN ไม่ตรงกับตัวรับยาแฟคเตอร์', 'ตรวจสอบ HN', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('665', 'H05', 'C', 'SSS', 'ใช้ตัวรับยาแฟคเตอร์ที่ยกเลิกไปแล้ว', 'ใช้ตัวรับยาใหม่', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('666', 'H07', 'C', 'SSS', 'ใช้ยาแฟคเตอร์ไม่ตรง Type กับตัวรับยา', 'Hemophilia A ใช้ Factor 8, B ใช้ Factor 9', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('667', 'H08', 'C', 'SSS', 'ราคาที่ผู้ป่วยแจ้งในตัวรับยาไม่ตรงกับราคาที่ รพ. เบิก', 'ตรวจสอบราคา', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('668', 'H09', 'C', 'SSS', 'ราคายาต่อหน่วยไม่ตรงกับราคาที่ให้เบิก', 'Factor 8: 500 IU ≤ 6,000 บาท, Factor 9: 500 IU ≤ 6,300 บาท', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('669', 'H10', 'C', 'SSS', 'IU ที่ผู้ป่วยแจ้งในตัวรับยาไม่ตรงกับที่ รพ. เบิก', 'ตรวจสอบจำนวน IU', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('670', 'H12', 'C', 'SSS', 'มีรายการเบิกอื่นใน Invoice No. เดียวกับการเบิกยาแฟคเตอร์', 'แยก InvNo สำหรับยา Factor', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('671', 'H13', 'C', 'SSS', 'ใช้ตัวรับยาซ้ำกับที่เบิกไปแล้ว', 'ตรวจสอบการใช้ตัวรับยาซ้ำ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('672', 'R01', 'C', 'SSS', 'Dispense ID ซ้ำกับที่เคยส่งมาแล้ว', 'ตรวจสอบการส่งซ้ำ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('673', 'R02', 'E', 'SSS', 'รายการยาใน DispensedItems ไม่เท่ากับ Dispensing.Itemcnt', 'จำนวนรายการยาต้องตรงกัน', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('674', 'R03', 'E', 'SSS', 'Dispense ID ใน DispensedItems Link ไม่ได้กับ Dispensing', 'ตรวจสอบ DispenseID', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('675', 'R04', 'E', 'SSS', 'ยอดเบิกของ Dispensing และ DispensedItems ไม่ตรงกัน', 'ตรวจสอบยอดเงิน', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('676', 'R05', 'E', 'SSS', 'Dispense ID ซ้ำในไฟล์เดียวกัน', 'แก้ไข DispenseID ให้ไม่ซ้ำ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('677', 'R12', 'E', 'SSS', 'Reimburser ไม่ถูกต้อง', 'ใช้รหัส HP, P0, P1 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('678', 'R13', 'E', 'SSS', 'BenefitPlan ไม่ถูกต้อง', 'ตรวจสอบรหัสแผนผลประโยชน์', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('679', 'R14', 'E', 'SSS', 'DispeStat ไม่ถูกต้อง', 'ใช้รหัส 0, 1, 2, 3 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('680', 'R15', 'E', 'SSS', 'MultiDisp ไม่ถูกต้อง', 'ตรวจสอบรูปแบบการแบ่งจ่ายยา', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('681', 'R16', 'E', 'SSS', 'SupplyFor ไม่ถูกต้อง', 'ระบุระยะเวลาที่ผู้ป่วยใช้ยา', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('682', 'R17', 'E', 'SSS', 'PrdCat ไม่ถูกต้อง', 'ใช้รหัส 1-7 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('683', 'R18', 'E', 'SSS', 'PrdSeCode ไม่ถูกต้อง', 'ใช้รหัส 0-9 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('684', 'R19', 'E', 'SSS', 'Claimcont ไม่ถูกต้อง', 'ใช้รหัส OD, NR, PA, AU, ST, IN เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('685', 'R20', 'E', 'SSS', 'ClaimCat ไม่ถูกต้อง', 'ตรวจสอบรหัสประเภทการเบิก', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('686', 'R21', 'E', 'SSS', 'เลขที่ ว.แพทย์ไม่ถูกต้องตามรูปแบบที่กำหนด', 'รูปแบบ: Annnnn (A=วิชาชีพ, n=เลขที่)', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('687', 'R22', 'E', 'SSS', 'ขาดข้อมูลขนาดบรรจุ', 'ระบุ PackSize สำหรับยา (PrdCat 1-5)', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('688', 'R23', 'E', 'SSS', 'ขาดชื่อ Dose, Form, Strength', 'ระบุข้อมูลยาใน Sigtext', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('689', 'R24', 'E', 'SSS', 'ขาดข้อมูลวิธีการใช้ยา', 'ระบุวิธีใช้ยาใน Sigtext', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('690', 'R31', 'C', 'SSS', 'ใน BillTran มีการเบิกค่ายา แต่ขาดข้อมูลยาใน BillDisp', 'ส่งข้อมูล BillDisp ด้วย', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('691', 'R32', 'C', 'SSS', 'มีข้อมูลยาใน BillDisp แต่ไม่มีการเบิกค่ายาใน BillTran', 'ตรวจสอบความสอดคล้อง', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('692', 'R33', 'C', 'SSS', 'ยอดเบิกยาใน BillTran ไม่เท่ากับ Dispensing', 'ตรวจสอบยอดเงินยา', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('693', 'R34', 'E', 'SSS', 'HN ในข้อมูลยาไม่ตรงกับ HN ใน BillTran', 'HN ต้องตรงกันทั้ง BillTran และ BillDisp', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('694', 'R35', 'E', 'SSS', 'Pid ในข้อมูลยาไม่ตรงกับ Pid ใน BillTran', 'PID ต้องตรงกันทั้ง BillTran และ BillDisp', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('695', 'R41', 'C', 'SSS', 'จำนวนเงินที่ขอเบิกไม่ถูกต้อง', 'ChargeAmt = ClaimAmt + Paid + Other', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('696', 'R42', 'E', 'SSS', 'Charge Amount ไม่ถูกต้อง (Quantity x Unit Price)', 'ChargeAmt = Quantity × UnitPrice', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('697', 'R43', 'E', 'SSS', 'Reimb Amount ไม่ถูกต้อง (Quantity x Reimb Price)', 'ReimbAmt = Quantity × ReimbPrice', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('698', 'R51', 'W', 'SSS', 'รหัสยา TMT ไม่พบในบัญชีรายการยาและรหัสยามาตรฐานไทย', 'ตรวจสอบรหัส TMT', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('699', 'R61', 'C', 'SSS', 'เป็นรายการลบหรือแก้ไขแต่ไม่พบเลขที่ใบสั่งยาเดิม', 'ตรวจสอบ DispID เดิม', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('700', 'S01', 'C', 'SSS', 'SvID ซ้ำกับที่เคยเบิกมาแล้ว', 'ตรวจสอบการส่งซ้ำ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('701', 'S02', 'E', 'SSS', 'SvID ซ้ำกันในไฟล์เดียวกัน', 'แก้ไข SvID ให้ไม่ซ้ำ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('702', 'S03', 'E', 'SSS', 'Class ไม่ถูกต้อง', 'ใช้รหัส OP, EC, LB, XR, IV, ZZ เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('703', 'S04', 'E', 'SSS', 'CareAccount ไม่ถูกต้อง', 'ใช้รหัส 1, 2, 3, 9 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('704', 'S05', 'E', 'SSS', 'TypeServ ไม่ถูกต้อง', 'ใช้รหัส 01-08 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('705', 'S06', 'E', 'SSS', 'TypeIn ไม่ถูกต้อง', 'ใช้รหัส 1, 2, 3, 4, 9 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('706', 'S07', 'E', 'SSS', 'TypeOut ไม่ถูกต้อง', 'ใช้รหัส 1, 2, 3, 4, 5, 9 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('707', 'S08', 'E', 'SSS', 'Clinic ไม่ถูกต้อง', 'ใช้รหัส 01-12, 99 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('708', 'S09', 'E', 'SSS', 'CodeSet ของ OPServices ไม่ถูกต้อง', 'ใช้รหัส IN, LC, TT เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('709', 'S10', 'E', 'SSS', 'CodeSet ของ OPDx ไม่ถูกต้อง', 'ใช้รหัส IT, SN, TT เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('710', 'S11', 'E', 'SSS', 'Completion ไม่ถูกต้อง', 'ใช้ค่า Y หรือ N เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('711', 'S12', 'E', 'SSS', 'ClaimCat ไม่ถูกต้อง', 'ตรวจสอบรหัสประเภทการเบิก', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('712', 'S13', 'E', 'SSS', 'SL ไม่ถูกต้อง', 'ใช้รหัส 1-9 เท่านั้น', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('713', 'S14', 'E', 'SSS', 'วันนัดครั้งต่อไป DTAppoint ไม่ถูกต้อง', 'วันนัดต้องมากกว่าวันรักษา', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('714', 'S15', 'E', 'SSS', 'เลขที่ใบประกอบวิชาชีพ SvPID ไม่ถูกต้อง', 'รูปแบบ: Annnnn', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('715', 'S17', 'E', 'SSS', 'วันเวลาเริ่มต้นและสิ้นสุดการให้บริการไม่สัมพันธ์กัน', 'EndDT ต้องมากกว่า BegDT', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('716', 'S18', 'E', 'SSS', 'รหัสการวินิจฉัยไม่ถูกต้องหรือไม่สัมพันธ์กับ Codeset', 'ตรวจสอบรหัส ICD-10', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('717', 'S19', 'E', 'SSS', 'รหัสการให้บริการไม่ถูกต้องหรือไม่สัมพันธ์กับ Codeset', 'ตรวจสอบรหัส ICD-9-CM หรือ ICD-10-TM', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('718', 'S20', 'E', 'SSS', 'ค่า SvCharge ไม่ถูกต้องกรณีหมวด I', 'SvCharge = Sum(BillItems.ChargeAmt) หมวด I', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('719', 'S21', 'E', 'SSS', 'ค่าธรรมเนียมบุคลากรทางการแพทย์ไม่ถูกต้อง กรณีหมวดค่าหัตถการ', 'ตรวจสอบค่าหัตถการหมวด B', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('720', 'S31', 'E', 'SSS', 'InvNo. ไม่พบใน BillTran', 'ตรวจสอบความสัมพันธ์', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('721', 'S32', 'E', 'SSS', 'HN ไม่ตรงกับ Hn ใน BillTran', 'HN ต้องตรงกัน', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('722', 'S33', 'E', 'SSS', 'PID ไม่ตรงกับ PID ใน BillTran', 'PID ต้องตรงกัน', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('723', 'S34', 'E', 'SSS', 'SvID ใน OPDx ไม่พบใน OPServices', 'ตรวจสอบ SvID', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('724', 'S35', 'C', 'SSS', 'รายการตรวจรักษาทุกรายการต้องมีรหัสวินิจฉัยเสมอ', 'เพิ่ม OPDx เมื่อ Class = EC', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('725', 'S36', 'E', 'SSS', 'ไม่พบรายการ Service ใน BillItems', 'เพิ่มรายการใน BillItems', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('726', 'S40', 'E', 'SSS', 'ถ้า OPServices.Class = EC ฟิลด์ที่ใช้สำหรับหัตถการต้องเป็นค่าว่าง', 'ล้างข้อมูลหัตถการ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('727', 'S41', 'E', 'SSS', 'ใส่ Class ใน OPServices เป็นหัตถการ ต้องใส่รหัสหัตถการที่ OPServices', 'ระบุรหัสหัตถการ', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('728', 'S42', 'E', 'SSS', 'ใส่ Class ใน OPServices เป็นการวินิจฉัย LCcode ต้องใส่ที่ OPDx', 'ย้าย LCcode ไปที่ OPDx', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('729', 'T01', 'C', 'SSS', 'InvNo ซ้ำกันในไฟล์เดียวกัน', 'ตรวจสอบและแก้ไข InvNo ให้ไม่ซ้ำกัน', '1', '2025-12-22 10:25:16', '2025-12-22 10:25:16');
INSERT INTO `error_codes` VALUES ('730', 'T02', 'C', 'SSS', 'InvNo ซ้ำกับที่เคยเบิกแล้ว', 'ตรวจสอบการส่งซ้ำ หากเป็นรายการเดิมไม่ต้องส่งใหม่', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('731', 'T03', 'E', 'SSS', 'ไม่ระบุ HN ในรายการ', 'บันทึก HN ในฟิลด์ BillTran.HN', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('732', 'T04', 'E', 'SSS', 'ไม่ระบุ Station', 'บันทึก Station ในฟิลด์ BillTran.Station', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('733', 'T05', 'E', 'SSS', 'วันที่รักษาไม่ถูกต้อง (เช่น เป็นวันที่ในอนาคต)', 'ตรวจสอบและแก้ไขวันที่รักษา (BillTran.Dttran)', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('734', 'T06', 'E', 'SSS', 'รหัสสิทธิประกันสุขภาพหลักไม่ถูกต้อง (PayPlan)', 'ใช้รหัส 00, 80, 81, 86 เท่านั้น', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('735', 'T07', 'E', 'SSS', 'Tflag ไม่ถูกต้อง', 'ใช้ค่า A, E, D เท่านั้น', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('736', 'T08', 'E', 'SSS', 'รหัสสิทธิที่ร่วมจ่ายไม่ถูกต้อง (OtherPayPlan)', 'ตรวจสอบรหัส RT, PI, EM, RF, SH, ZZ', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('737', 'T09', 'E', 'SSS', 'รหัสหมวด (BillMuad) ไม่ถูกต้อง', 'ใช้รหัสหมวด 1-9, A-I เท่านั้น', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('738', 'T10', 'E', 'SSS', 'รหัสประเภทบัญชีการเบิก (ClaimCat) ไม่ถูกต้อง', 'ตรวจสอบรหัส OP1, RRT, P01-P03, REF, EM1-EM2, OPF, OPR', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('739', 'T11', 'E', 'SSS', 'LCcode ไม่ถูกต้อง', 'ระบุ LCcode ให้ครบทุกรายการ', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('740', 'T12', 'E', 'SSS', 'STDCode ไม่ถูกต้อง', 'แก้ไข T15 ก่อน', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('741', 'T13', 'E', 'SSS', 'QTY ไม่ถูกต้อง', 'จำนวนต้องตรงกับ DispensedItems.Quantity', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('742', 'T14', 'E', 'SSS', 'UP ไม่ถูกต้อง', 'ราคาต่อหน่วยต้องตรงกับ DispensedItems.UnitPrice', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('743', 'T15', 'C', 'SSS', 'SVRefID ไม่ถูกต้อง กรณีหมวด 3 และ 5', 'ตรวจสอบความสัมพันธ์กับ DispensedItems', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('744', 'T16', 'C', 'SSS', 'SVRefID ไม่ถูกต้อง กรณีเป็นหมวด I', 'ระบุ SvRefID ที่อ้างอิงไปยัง OPServices.SVID', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('745', 'T17', 'C', 'SSS', 'SVRefID ไม่ถูกต้อง กรณีเป็นหมวด B', 'ระบุ SvRefID ที่อ้างอิงไปยัง OPServices.SVID', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('746', 'T31', 'C', 'SSS', 'ไม่มีรายการ BillItems ของ BillTran นี้', 'เพิ่มรายการ BillItems อย่างน้อย 1 รายการ', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('747', 'T32', 'C', 'SSS', 'ผลรวมของ Paid + ClaimAmt + OtherPay ไม่เท่ากับยอดเงินเรียกเก็บค่ารักษา', 'ตรวจสอบการคำนวณ Amount = ClaimAmount + Paid + Otherpay', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('748', 'T33', 'C', 'SSS', 'Amount ของ InvNo นี้ไม่ตรงกับยอดรวมใน BillItems', 'BillTran.Amount = sum(BillItems.ChargeAmt)', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('749', 'T41', 'E', 'SSS', 'รายการ BillItems นี้ไม่มี BillTran กำกับมาด้วย', 'ตรวจสอบความสมบูรณ์ของข้อมูล', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('750', 'T42', 'E', 'SSS', 'SvDate ไม่สัมพันธ์กับ Dttran', 'วันที่รับบริการและวันที่คิดเงินห่างกันไม่เกิน 24 ชม.', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('751', 'T43', 'E', 'SSS', 'ราคาที่เรียกเก็บ ChargeAmt ไม่เท่ากับ UP x Qty', 'ChargeAmt = Qty × UP (ปัดเศษได้ไม่เกิน 1 บาท)', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('752', 'T44', 'E', 'SSS', 'ยอดเงินที่ขอเบิก ClaimAmount ไม่เท่ากับ ClaimUP x Qty', 'ClaimAmount = Qty × ClaimUP (ปัดเศษได้ไม่เกิน 1 บาท)', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('753', 'T45', 'C', 'SSS', 'BillTran.ClaimAmt ไม่เท่ากับ Sum(BillItems.ClaimAmt)', 'ตรวจสอบการรวมยอด ClaimAmount', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('754', 'T61', 'C', 'SSS', 'เป็นรายการลบหรือแก้ไขที่ไม่พบ Inv No. เดิม', 'ตรวจสอบว่า InvNo เดิมมีในระบบหรือไม่', '1', '2025-12-22 10:25:17', '2025-12-22 10:25:17');
INSERT INTO `error_codes` VALUES ('755', '756', 'C', 'UCS', 'กรณีส่งเสริมป้องกันโรค (F6) อายุไม่อยู่ในช่วงที่กำหนด', 'ตรวจสอบเงื่อนไขการเบิกจ่ายกรณีส่งเสริมป้องกันโรคตามแนวทางที่ สปสช.กำหนด ในคู่มือแนวทางปฏิบัติในการขอรับค่าใช้จ่ายฯ ประจำปีงบประมาณ แก้ไขเข้ามาใหม่ หรือ ยกเลิกการเบิกจ่ายกรณีไม่ตรงตามเงื่อนไขที่กำหนด', '1', '2025-12-30 13:49:09', '2025-12-30 13:49:09');
INSERT INTO `error_codes` VALUES ('756', '762', 'C', 'ALL', 'เลขที่บัตรประชาชน (HN) เดิมซ้ำกับข้อมูลที่เคยตรวจผ่านแล้ว', 'ตรวจสอบเลขประจำตัวประชาชน (PID) และรหัสโรงพยาบาล (HN) ของผู้ป่วยว่าซ้ำซ้อนหรือไม่\r\nหากข้อมูลผิด: ให้แก้ไขให้ถูกต้องแล้วส่งข้อมูลใหม่\r\nหากข้อมูลซ้ำจริง: ไม่ต้องแก้ไข เป็นเพียงการแจ้งเตือนเพื่อทราบ ', '1', '2026-02-17 09:38:10', '2026-02-17 09:45:27');
INSERT INTO `error_codes` VALUES ('757', '825', 'C', 'ALL', ' ET Tube (ท่อช่วยหายใจ) ที่เบิกได้จำกัดเพียง 2 ชิ้นต่อครั้ง', 'แนวทางแก้ไข: ตรวจสอบข้อมูลผู้ป่วยและทำหนังสืออุทธรณ์ชี้แจงความจำเป็นทางการแพทย์\r\nเอกสารที่ต้องใช้: เวชระเบียนหลักฐานการรับบริการ ', '1', '2026-02-17 09:45:17', '2026-02-17 09:45:53');

-- ----------------------------
-- Table structure for error_resolution_history
-- ----------------------------
DROP TABLE IF EXISTS `error_resolution_history`;
CREATE TABLE `error_resolution_history` (
  `history_id` int(11) NOT NULL AUTO_INCREMENT,
  `claim_error_id` int(11) NOT NULL,
  `action_type` enum('detected','assigned','in_progress','resolved','resubmitted','cancelled') NOT NULL,
  `action_by` int(11) DEFAULT NULL COMMENT 'ผู้ดำเนินการ (user_id)',
  `action_note` text DEFAULT NULL COMMENT 'บันทึกการดำเนินการ',
  `previous_status` enum('pending','in_progress','resolved','cancelled') DEFAULT NULL,
  `new_status` enum('pending','in_progress','resolved','cancelled') DEFAULT NULL,
  `action_at` datetime NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`history_id`),
  KEY `idx_claim_error_id` (`claim_error_id`),
  KEY `idx_action_type` (`action_type`),
  KEY `idx_action_at` (`action_at`),
  KEY `fk_error_history_user` (`action_by`),
  CONSTRAINT `fk_error_history_claim_error` FOREIGN KEY (`claim_error_id`) REFERENCES `claim_errors` (`claim_error_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_error_history_user` FOREIGN KEY (`action_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of error_resolution_history
-- ----------------------------

-- ----------------------------
-- Table structure for error_statistics
-- ----------------------------
DROP TABLE IF EXISTS `error_statistics`;
CREATE TABLE `error_statistics` (
  `stat_id` int(11) NOT NULL AUTO_INCREMENT,
  `insurance_type` varchar(10) NOT NULL COMMENT 'UCS, OFC, LGO, SSS',
  `claim_type` enum('IP','OP','IPCS','OPCS','IPLGO','OPLGO') DEFAULT NULL,
  `period_month` char(7) NOT NULL COMMENT 'รูปแบบ YYYY-MM',
  `total_errors` int(11) DEFAULT 0 COMMENT 'จำนวน Error ทั้งหมด',
  `errors_c_type` int(11) DEFAULT 0 COMMENT 'จำนวน C Error',
  `errors_e_type` int(11) DEFAULT 0 COMMENT 'จำนวน E Error',
  `errors_w_type` int(11) DEFAULT 0 COMMENT 'จำนวน W Error',
  `resolved_errors` int(11) DEFAULT 0 COMMENT 'จำนวนที่แก้แล้ว',
  `pending_errors` int(11) DEFAULT 0 COMMENT 'จำนวนที่ยังรอแก้',
  `in_progress_errors` int(11) DEFAULT 0 COMMENT 'จำนวนที่กำลังแก้',
  `cancelled_errors` int(11) DEFAULT 0 COMMENT 'จำนวนที่ยกเลิก',
  `avg_resolution_days` decimal(10,2) DEFAULT NULL COMMENT 'เฉลี่ยวันในการแก้ไข',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`stat_id`),
  UNIQUE KEY `uk_insurance_period` (`insurance_type`,`claim_type`,`period_month`),
  KEY `idx_period` (`period_month`),
  KEY `idx_insurance_type` (`insurance_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of error_statistics
-- ----------------------------

-- ----------------------------
-- Table structure for finance_allocations
-- ----------------------------
DROP TABLE IF EXISTS `finance_allocations`;
CREATE TABLE `finance_allocations` (
  `allocation_id` int(11) NOT NULL AUTO_INCREMENT,
  `receipt_id` int(11) NOT NULL COMMENT 'อ้างอิง finance_receipts',
  `ar_id` int(11) NOT NULL COMMENT 'อ้างอิง accounts_receivable',
  `allocated_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดเงินที่จัดสรร',
  `allocation_type` enum('full','partial','average') NOT NULL DEFAULT 'full' COMMENT 'ประเภท: full=จ่ายเต็ม, partial=จ่ายบางส่วน, average=หารเฉลี่ย',
  `remark` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`allocation_id`),
  KEY `idx_receipt_id` (`receipt_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_allocation_type` (`allocation_type`),
  CONSTRAINT `fk_allocation_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_allocation_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `finance_receipts` (`receipt_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางจัดสรรเงินให้ลูกหนี้';

-- ----------------------------
-- Records of finance_allocations
-- ----------------------------

-- ----------------------------
-- Table structure for finance_payment_history
-- ----------------------------
DROP TABLE IF EXISTS `finance_payment_history`;
CREATE TABLE `finance_payment_history` (
  `payment_history_id` int(11) NOT NULL AUTO_INCREMENT,
  `receipt_id` int(11) NOT NULL,
  `ar_id` int(11) NOT NULL,
  `payment_amount` decimal(15,2) NOT NULL,
  `payment_date` date NOT NULL,
  `payment_method` varchar(50) DEFAULT NULL COMMENT 'วิธีการชำระ',
  `reference_no` varchar(100) DEFAULT NULL COMMENT 'เลขที่อ้างอิง',
  `remark` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`payment_history_id`),
  KEY `idx_receipt_id` (`receipt_id`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_payment_date` (`payment_date`),
  KEY `fk_payment_history_created_by` (`created_by`),
  CONSTRAINT `fk_payment_history_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_payment_history_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_payment_history_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `finance_receipts` (`receipt_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางประวัติการรับชำระเงิน';

-- ----------------------------
-- Records of finance_payment_history
-- ----------------------------

-- ----------------------------
-- Table structure for finance_receipts
-- ----------------------------
DROP TABLE IF EXISTS `finance_receipts`;
CREATE TABLE `finance_receipts` (
  `receipt_id` int(11) NOT NULL AUTO_INCREMENT,
  `receipt_no` varchar(50) NOT NULL COMMENT 'เลขที่ใบเสร็จรับเงิน',
  `receipt_date` date NOT NULL COMMENT 'วันที่รับเงิน',
  `payer_type` enum('UC','OFC','LGO','SSS','BKK') NOT NULL COMMENT 'แหล่งจ่ายเงิน: UC=สปสช, OFC=กรมบัญชีกลาง, LGO=อปท, SSS=ประกันสังคม, BKK=กทม',
  `statement_import_id` int(11) DEFAULT NULL COMMENT 'อ้างอิงจาก statement_import_logs',
  `document_no` varchar(50) DEFAULT NULL COMMENT 'เลขที่เอกสาร Statement',
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดเงินที่ได้รับทั้งหมด',
  `allocated_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดเงินที่จัดสรรแล้ว',
  `balance_amount` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดเงินคงเหลือ',
  `status` enum('draft','confirmed','posted') NOT NULL DEFAULT 'draft' COMMENT 'สถานะ: draft=ร่าง, confirmed=ยืนยันแล้ว, posted=บันทึกบัญชีแล้ว',
  `remark` text DEFAULT NULL COMMENT 'หมายเหตุ',
  `created_by` int(11) DEFAULT NULL,
  `confirmed_by` int(11) DEFAULT NULL,
  `posted_by` int(11) DEFAULT NULL COMMENT 'ผู้บันทึกเข้าบัญชี',
  `created_at` datetime DEFAULT current_timestamp(),
  `confirmed_at` datetime DEFAULT NULL,
  `posted_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`receipt_id`),
  UNIQUE KEY `idx_receipt_no` (`receipt_no`),
  KEY `idx_payer_type` (`payer_type`),
  KEY `idx_receipt_date` (`receipt_date`),
  KEY `idx_status` (`status`),
  KEY `fk_receipt_statement` (`statement_import_id`),
  KEY `fk_receipt_created_by` (`created_by`),
  KEY `fk_receipt_confirmed_by` (`confirmed_by`),
  KEY `fk_receipt_posted_by` (`posted_by`),
  CONSTRAINT `fk_receipt_confirmed_by` FOREIGN KEY (`confirmed_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_posted_by` FOREIGN KEY (`posted_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_receipt_statement` FOREIGN KEY (`statement_import_id`) REFERENCES `statement_import_logs` (`statement_import_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางบันทึกการรับเงินจากหน่วยงาน';

-- ----------------------------
-- Records of finance_receipts
-- ----------------------------

-- ----------------------------
-- Table structure for fund_codes
-- ----------------------------
DROP TABLE IF EXISTS `fund_codes`;
CREATE TABLE `fund_codes` (
  `fund_code` varchar(50) NOT NULL,
  `fund_name` varchar(200) NOT NULL,
  `payer_code` varchar(10) DEFAULT NULL,
  `fund_category` varchar(50) DEFAULT NULL COMMENT 'Main, Sub, Special',
  `description` text DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`fund_code`),
  KEY `fund_codes_ibfk_1` (`payer_code`),
  CONSTRAINT `fund_codes_ibfk_1` FOREIGN KEY (`payer_code`) REFERENCES `payer_codes` (`payer_code`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางรหัสกองทุน';

-- ----------------------------
-- Records of fund_codes
-- ----------------------------
INSERT INTO `fund_codes` VALUES ('AE01', 'สิทธิว่าง (IPPUC) รวมเด็กแรกเกิด', 'UC', 'Main', 'Accident & Emergency - สิทธิว่าง IPPUC', '1', '2026-01-06 15:41:15', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE02', 'สิทธิว่าง ผู้ใหญ่ (อายุเกิน 28 วัน) เสียชีวิตก่อนลงทะเบียนเลือกหน่วยบริการประจำ (Z75000)', 'UC', 'Main', 'AE สิทธิว่างผู้ใหญ่', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE03', 'สิทธิว่าง เด็กแรกเกิด (อายุ <= 28 วัน) เสียชีวิตก่อนลงทะเบียนเลือกหน่วยบริการประจำ (Z39000)', 'UC', 'Main', 'AE สิทธิว่างเด็กแรกเกิด', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE04', 'อุบัติเหตุ ฉุกเฉิน (OPAE)', 'UC', 'Main', 'อุบัติเหตุและบริการฉุกเฉิน - Accident & Emergency', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('AE05', 'ประกันสังคมส่งเงินสมทบไม่ครบ ๓ เดือน (Z34003)', 'UC', 'Main', 'ประกันสังคมส่งเงินสมทบไม่ครบ 3 เดือน', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE06', 'ประกันสังคมส่งเงินสมทบไม่ครบ 7 เดือนเข้ารับการบริการฝากครรภ์', 'UC', 'Main', 'ประกันสังคมส่งเงินสมทบไม่ครบ 7 เดือน', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE07', 'ศูนย์ประสานการส่งต่อผู้ป่วย', 'UC', 'Main', 'ศูนย์ประสานการส่งต่อผู้ป่วย', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE08', 'คำพิพากษ์ในการส่งต่อ', 'UC', 'Main', 'คำพิพากษ์ในการส่งต่อผู้ป่วย', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('AE09', 'อมือร้างครกำรับการรักทรษณสำ กรณี ER ตรภพพมี ปรรบช้อง 2563', 'UC', 'Main', 'AE09 - Emergency Room Extra 2020', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('ANC', 'ตรวจครรภ์ แรงบริการประกัศ', 'UC', 'Main', 'Antenatal Care - บริการฝากครรภ์และตรวจครรภ์', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('ANC_DENT', 'บริการทันตกรรมหญิงตั้งครรภ์สำเร็จมีอายุครรภ์ก่วง 12 สัปดาห์ เจ็จฉับประกัศ', 'UC', 'Sub', 'Antenatal Dental - ทันตกรรมสำหรับหญิงตั้งครรภ์', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('ANC_ULTRA', 'บริการทรวงมีจริงยารท เจ็จฉับประกัศ', 'UC', 'Sub', 'Antenatal Ultrasound - อัลตราซาวด์สำหรับหญิงตั้งครรภ์', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('CARREF', 'คำพิพากษาในการส่งต่อ', 'UC', 'Sub', 'Car Referral - การส่งต่อด้วยรถพยาบาล', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('CATARACT', 'ผ่าตัดต้อกระจก', 'UC', 'Sub', 'Cataract Surgery - ผ่าตัดต้อกระจก', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('CATINST', 'อุปกรณ์ และอวัยวะเทียมในการบำบัดรักษาโรค (Instrument)', 'UC', 'Sub', 'Cataract Instrument - อุปกรณ์ต้อกระจก', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('CHANGE_RIGHT', 'เปลี่ยนสิทธิ์', 'UC', 'Sub', 'กรณีเปลี่ยนสิทธิ์การรักษา', '1', '2026-01-06 15:59:25', '2026-01-06 15:59:25');
INSERT INTO `fund_codes` VALUES ('CHANGE_RIGHT_DRUG_OTHER', 'เปลี่ยนสิทธิ์ ยาอื่นๆ', 'UC', 'Sub', 'กรณีเปลี่ยนสิทธิ์ ยาและอื่นๆ', '1', '2026-01-06 15:59:25', '2026-01-06 15:59:25');
INSERT INTO `fund_codes` VALUES ('CLOPIDOGREL_DRUG', 'กองคม์ตรถข่รอธเด้อ Clopidogrel', 'UC', 'Sub', 'Clopidogrel Drug - ยา Clopidogrel', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('COVID', 'COVID-19', 'UC', 'Special', 'บริการเกี่ยวกับ COVID-19', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DENTURE', 'อุปกรณ์ และอวัยวะเทียมในการบำบัดรักษาโรค (Instrument)', 'UC', 'Sub', 'Denture - ฟันปลอม/ทันตกรรม', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM01', 'กรณีทำ Shunt ในผู้ป่วยไตวายเรื้อรัง (DMISHD)', 'UC', 'Main', 'ทำ Shunt ผู้ป่วยไตวาย', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM02', 'กรณีผ่าตัดหัวใจ (DMISOH)', 'UC', 'Main', 'ผ่าตัดหัวใจ', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM03', 'อื้มสวยเสียงใส Q35670 (เฉพาะข้อมูลก่อนปี 53)', 'UC', 'Main', 'โครงการอื้มสวยเสียงใส', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM04', 'ยาละลายลิ่มเลือด (STEMI1, STEMI2, STROK1)', 'UC', 'Main', 'ยาละลายลิ่มเลือด STEMI/STROKE', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM05', 'นิ่วในระบบทางเดินปัสสาวะ (DMISRC)', 'UC', 'Main', 'นิ่วในระบบปัสสาวะ', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM06', 'มะเร็งเม็ดเลือดขาวชนิดเฉียบพลัน (DMLP54)', 'UC', 'Main', 'มะเร็งเม็ดเลือดขาวเฉียบพลัน', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM07', 'มะเร็งต่อมน้ำเหลืองและมะเร็งเม็ดเลือดขาวชนิดเรื้อรัง (DMLL54)', 'UC', 'Main', 'มะเร็งต่อมน้ำเหลืองและมะเร็งเม็ดเลือดขาว', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM08', 'ยามอรพินให้ในผู้ป่วยมะเร็งระยะสุดท้าย(Palliative Care)', 'UC', 'Main', 'ยามอรฟินผู้ป่วยระยะสุดท้าย', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('DM09', 'ผ่าตัดต้อกระจก', 'UC', 'Main', 'Disease Management 09 - ผ่าตัดต้อกระจก', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM12', 'กองทุน PALLIATIVE-CARE', 'UC', 'Main', 'Disease Management 12 - Palliative Care', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM14', 'บริการทรวงมีจริงยารท เจ็จฉับประกัศ', 'UC', 'Main', 'Disease Management 14 - โปรแกรมจัดการโรคที่ 14', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM15', 'บริการทรวงอัจริยารวงแผลรั้งบ้าบ่อยด่วด (เคมัรสคีเพล็จธระธนรวง)', 'UC', 'Main', 'Disease Management 15 - HPV DNA Screening', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM19', 'บริการกากรับริดกองคม์เทือมกรั้มีสมกมามาแต่การจินเค็จปรรรคจมร์ (CDM)', 'UC', 'Main', 'Disease Management 19 - CDM', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM20', 'บริการทรวงมองตอ้งมีมื้อสุจสดาร (Hepatitis C Virus, HCV)', 'UC', 'Main', 'Disease Management 20 - Hepatitis C', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DM22', 'การคล่องตารการประกัศ (PRT)', 'UC', 'Main', 'Disease Management 22 - โปรแกรมจัดการโรคที่ 22', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DMISRC-R', 'นิ่วในระบบทางเดินปัสสาวะ ในเขต', 'UC', 'Sub', 'นิ่วในระบบปัสสาวะ ในเขตบริการ', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('DMS', 'Drug Medical Supply', 'UC', 'Sub', 'เวชภัณฑ์และยา', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('DM_CDM', 'บริการกากรับริดกองคม์เทือมกรั้มีสมกมามาแต่การจินเค็จปรรรคจมร์ (CDM)', 'UC', 'Sub', 'DM CDM - Chronic Disease Management', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('FPNHSO', 'การวางแผนครอบครัว', 'UC', 'Main', 'Family Planning NHSO - วางแผนครอบครัว สปสช.', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HC01', 'เคมีบำบัด/รังสีรักษา ในการรักษาโรคมะเร็งทั่วไป', 'UC', 'Main', 'เคมีบำบัด/รังสีรักษามะเร็ง', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC02', 'การรักษาโรคมะเร็งตามไม่ประกาศไตคอด', 'UC', 'Main', 'รักษาโรคมะเร็งไม่ประกาศไตคอด', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC03', 'Peritoneal/haemo dialysis ในผู้ป่วยไตวายเรื้อรังพลัน', 'UC', 'Main', 'ล้างไตทางช่องท้อง/ล้างเลือด', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC04', 'การให้ยารักษา Crytococcal meningitis ในผู้ติดเชื้อ HIV', 'UC', 'Main', 'รักษา Crytococcal meningitis HIV', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC05', 'การให้ยารักษา Cytomegalovirus Retinitis ในผู้ติดเชื้อ HIV', 'UC', 'Main', 'รักษา CMV Retinitis HIV', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC06', 'การรักษา Decompression Sickness ด้วย Hyperbaric Oxygen Therapy', 'UC', 'Main', 'Decompression Sickness ด้วย Hyperbaric Oxygen', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC07', 'การให้ Methadone Maintenance Treatment', 'UC', 'Main', 'Methadone Maintenance Treatment', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC08', 'การตรวจวินิจฉัยรายคานแพงและทัศนการหัวใจ', 'UC', 'Main', 'ตรวจวินิจฉัยรายคานแพงและหัวใจ', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC09', 'อุปกรณ์ และอวัยวะเทียม ในการบำบัดรักษาโรค (Instrument)', 'UC', 'Main', 'อุปกรณ์และอวัยวะเทียม', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC10', 'พื้นเพิยมพระราชทาน (เฉพาะปี51)', 'UC', 'Main', 'พื้นเพิยมพระราชทาน', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC13', 'กองคม์ตรถข่รอธเด้อ Clopidogrel', 'UC', 'Main', 'Health Care 13 - Clopidogrel Program', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HC15', 'กรณีบริการการรักทรษณสะะบบทางไกล (Telehealth/Telemedicine)', 'UC', 'Main', 'Health Care 15 - Telemedicine', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HC16', 'บริการส่งเสริมป้องกัน 16 บริการ', 'UC', 'Main', 'Health Promotion 16 Services', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HC22', 'บริการส่งเสริมป้องกัน 22 บริการ', 'UC', 'Main', 'Health Promotion 22 Services', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('HERB', 'บริการเทพยากระเทียบทั่ว อายสมเทพมี้จข่องคารพรรมพกรรวันนี้', 'UC', 'Sub', 'Herbal Medicine - สมุนไพร/ยาแผนไทย', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HERB_FS', 'กองทุนสมุนไพร', 'UC', 'Sub', 'กองทุนสมุนไพร/ยาแผนไทย Fund Scheme', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('HOMECARE', 'Home Care', 'UC', 'Sub', 'บริการดูแลผู้ป่วยที่บ้าน', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('HOMEWARD', 'Home Ward', 'UC', 'Sub', 'บริการผู้ป่วยใน Home Ward', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HPV_DNA', 'บริการทรวงอัจริยารวงแผลรั้งบ้าบ่อยด่วด (เคมัรสคีเพล็จธระธนรวง)', 'UC', 'Sub', 'HPV DNA Test - ตรวจ HPV DNA', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HPV_DNA_LAB', 'บริการทรวงอัจริยารวงแผลรั้งบ้าบ่อยด่วด (เคมัรสพีเพล็จธระธนรวง)', 'UC', 'Sub', 'HPV DNA Lab - ตรวจ HPV DNA ทางห้องแล็บ', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('HPV_LAB', 'บริการทรวงอัจริยารวงแผลรั้งบ้าบ่อยด่วด (เคมัรสพีเพล็จธระธนรวง)', 'UC', 'Sub', 'HPV Lab - ห้องปฏิบัติการ HPV', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('INST', 'อุปกรณ์และอวัยวะเทียมในการบำบัดรักษาโรค (Instrument)', 'UC', 'Sub', 'Instrument - อุปกรณ์เครื่องมือแพทย์', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('IP01', 'IPD ทั่วไป', 'UC', 'Main', 'ผู้ป่วยใน ทั่วไป (Inpatient General)', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('IP02', 'IPD ผ่าตัด', 'UC', 'Main', 'ผู้ป่วยใน ผ่าตัด (Inpatient Surgery)', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('IP03', 'มาตรา ๗ กรณีให้สุมควร', 'UC', 'Main', 'มาตรา 7 กรณีให้สุมควร', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('IP04', 'IPD ห้องพิเศษ', 'UC', 'Main', 'ผู้ป่วยใน ห้องพิเศษ', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('IP05', 'ในกรณีผู้ป่วยใน สิทธิอื่นๆ', 'UC', 'Main', 'ผู้ป่วยในสิทธิอื่นๆ', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('IPAEC', 'IPD ผ่าตัด AE', 'UC', 'Sub', 'ผู้ป่วยใน ผ่าตัด Accident & Emergency', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('IPDOUTRGR', 'IPD นอกเขต', 'UC', 'Sub', 'ผู้ป่วยใน นอกเขตบริการ', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('IPINRGR', 'IPD ทั่วไป ในเขต', 'UC', 'Sub', 'ผู้ป่วยใน ทั่วไป ในเขตบริการ', '1', '2025-12-04 18:14:01', '2026-01-06 15:34:12');
INSERT INTO `fund_codes` VALUES ('IPNB-FIX', 'IPD New Born - Fix', 'UC', 'Sub', 'ผู้ป่วยใน ทารกแรกเกิด - แก้ไข', '1', '2026-01-06 15:59:25', '2026-01-06 15:59:25');
INSERT INTO `fund_codes` VALUES ('IP_SCREENING', 'IPD Screening', 'UC', 'Sub', 'ผู้ป่วยใน - คัดกรอง', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('LAB', 'ค่าห้องแล็บ', 'UC', 'Sub', 'ค่าบริการตรวจทางห้องปฏิบัติการ', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('LAB_HEPC', 'บริการทรวงมองตอ้งมีมื้อสุจสดาร (Hepatitis C Virus, HCV)', 'UC', 'Sub', 'Lab HCV - ตรวจทางห้องแล็บ Hepatitis C', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('MAT01', 'ฝากครรภ์', 'UC', 'Main', 'ฝากครรภ์', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('MAT02', 'คลอดปกติ', 'UC', 'Main', 'คลอดปกติ', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('MAT03', 'คลอดผ่าตัด', 'UC', 'Main', 'คลอดผ่าตัด (C-Section)', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('NHSO_SPECIAL', 'โครงการพิเศษ สปสช.', 'UC', 'Special', 'โครงการพิเศษต่างๆ ของ สปสช.', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('ONTOP-ER-EXT', 'อมือร้างครกำรับการรักทรษณสำ กรณี ER ตรภพพมี ปรรบช้อง 2563', 'UC', 'Sub', 'On Top ER Extension - เพิ่มเติม ER', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('OP01', 'ผู้ป่วยนอกที่ไม่เข้าเกณฑ์จ่ายตรงเช่นเขย', 'UC', 'Main', 'ผู้ป่วยนอกทั่วไป', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('OP02', 'OPD ผ่าตัด', 'UC', 'Main', 'บริการผู้ป่วยนอก ผ่าตัดเล็ก', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('OP03', 'OPD ทันตกรรม', 'UC', 'Main', 'บริการทันตกรรม', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('OP04', 'OPD กายภาพบำบัด', 'UC', 'Main', 'บริการกายภาพบำบัด', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('OPAE', 'OPD ฉุกเฉิน', 'UC', 'Sub', 'OPD Accident & Emergency', '1', '2025-12-04 18:14:01', '2026-01-06 15:34:12');
INSERT INTO `fund_codes` VALUES ('OPDOUTRGR', 'OPD ทั่วไป นอกเขต', 'UC', 'Sub', 'ผู้ป่วยนอก นอกเขตบริการ (Out of Region)', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('OPDREHAB', 'OPD ฟื้นฟู', 'UC', 'Sub', 'กายภาพบำบัด/ฟื้นฟูสมรรถภาพ OPD', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('OPDRGR', 'OPD ทั่วไป ในเขต', 'UC', 'Sub', 'ผู้ป่วยนอก ในเขตบริการ (Regional)', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('OPDTOOL', 'OPD ทันตกรรม', 'UC', 'Sub', 'บริการทันตกรรม OPD', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('OPHC', 'ตารท้า Methadone Maintenance Treatment', 'UC', 'Sub', 'Opiate Health Care - Methadone Program', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('PALLIATIVE', 'Palliative Care', 'UC', 'Sub', 'ดูแลผู้ป่วยระยะสุดท้าย', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('PALLIATIVE-CARE', 'กองทุน PALLIATIVE-CARE', 'UC', 'Sub', 'Palliative Care - ดูแลผู้ป่วยระยะสุดท้าย', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('PAPSMEAR', 'ตรวจคมศพนี้เมือง สัจริยารวงแผลรั้งบ้าบ่อยด่วด (Pap Smear/VIA)', 'UC', 'Main', 'Pap Smear - ตรวจคัดกรองมะเร็งปากมดลูก', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('PLUS', 'กองทุน PLUS', 'UC', 'Sub', 'กองทุนส่งเสริมสุขภาพเพิ่มเติม', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('PP01', 'วางแผนครอบครัว (Family Planning)', 'UC', 'Main', 'บริการวางแผนครอบครัว', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('PP02', 'ฝากครรภ์', 'UC', 'Main', 'บริการฝากครรภ์', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('PP03', 'ตรวจหลังคลอด', 'UC', 'Main', 'บริการตรวจหลังคลอด', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('PP04', 'คัดกรองโรค', 'UC', 'Main', 'คัดกรองโรคเรื้อรัง', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('PPS', 'ประกันสังคม (ชื่อเดิม)', 'SSS', 'Main', 'ประกันสังคม บทความ 33', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('PP_ANC_PNC', 'การตรวงมีจริงอุจสูงด (PNC)', 'UC', 'Sub', 'PP ANC PNC - Primary Prevention ANC PNC', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('PP_ANC_PRT', 'การคล่องตารการประกัศ (PRT)', 'UC', 'Sub', 'PP ANC PRT - Primary Prevention ANC PRT', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('PP_CA_ORAL_SCREENIN', 'บริการอัจริยารวงอัรเค็ครำพรจปริงรัมแผลรั้งบ้อจอ้กอ (CA Oral Screening)', 'UC', 'Sub', 'PP CA Oral Screening - คัดกรองมะเร็งช่องปาก', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('PP_DENT_FLUORIDE', 'บริการทอันมมมพองมีจริง (ตมพครื่อง)', 'UC', 'Sub', 'PP Dental Fluoride - ทาฟลูออไรด์', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('REFER', 'ส่งต่อ', 'UC', 'Main', 'ส่งต่อผู้ป่วย', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('REP', 'เลขที่อ้างอิงข้อมูล', 'UC', 'Sub', 'เลขที่อ้างอิงข้อมูล (REP)', '1', '2026-01-06 15:45:35', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('RH01', 'พื้นฟูสมรรถภาพคนพิการ (Z73600)(เฉพาะปี51)', 'UC', 'Main', 'ฟื้นฟูสมรรถภาพคนพิการ', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('SSS', 'ประกันสังคม', 'SSS', 'Main', null, '1', '2025-12-04 18:14:01', '2025-12-04 18:14:01');
INSERT INTO `fund_codes` VALUES ('SSS_ACC', 'ประกันสังคม อุบัติเหตุ', 'SSS', 'Main', 'ประกันสังคม อุบัติเหตุ', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('SSS_IP', 'ประกันสังคม IPD', 'SSS', 'Main', 'ประกันสังคม ผู้ป่วยใน', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('SSS_MAT', 'ประกันสังคม คลอด', 'SSS', 'Main', 'ประกันสังคม คลอดบุตร', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('SSS_OP', 'ประกันสังคม OPD', 'SSS', 'Main', 'ประกันสังคม ผู้ป่วยนอก', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('STROKE-DRUG', 'ยาละลายลิ่มเลือด (STROK1)', 'UC', 'Sub', 'ยาละลายลิ่มเลือด สำหรับโรคหลอดเลือดสมอง', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('TELEMED', 'กรณีบริการการรักทรษณสะะบบทางไกล (Telehealth/Telemedicine)', 'UC', 'Sub', 'Telemedicine - การรักษาทางไกล', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('TRAUMA', 'อุบัติเหตุฉุกเฉิน', 'UC', 'Main', 'อุบัติเหตุฉุกเฉิน', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('VAC_COVID', 'วัคซีน COVID', 'UC', 'Special', 'ฉีดวัคซีน COVID-19', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('VM01', 'ยาบัญชี จ(2)', 'UC', 'Main', 'ยาบัญชียาเสพติดให้โทษ จ(2)', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('W18', 'ยอดเรียนคืน > 50000', 'UC', 'Sub', 'ยอดเรียนคืนเกิน 50,000 บาท', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('W19', 'ยอดเรียนคืน > 20000', 'UC', 'Sub', 'ยอดเรียนคืนเกิน 20,000 บาท', '1', '2026-01-06 15:45:34', '2026-01-06 15:45:34');
INSERT INTO `fund_codes` VALUES ('WALKIN', 'รายการ FS กรณีบริษัท์สมาชิกคงเจ้า/หายตลเงินคงเจ้า (Walk-in)', 'UC', 'Sub', 'Walk-in Fund Scheme บริการ 16/22', '1', '2026-01-06 15:59:24', '2026-01-06 15:59:24');
INSERT INTO `fund_codes` VALUES ('WALKIN_DRUG_OTHER_ONE-ID', 'Walk-in ยาอื่นๆ One-ID', 'UC', 'Sub', 'Walk-in ยาและบริการอื่นๆ', '1', '2026-01-06 15:59:25', '2026-01-06 15:59:25');
INSERT INTO `fund_codes` VALUES ('WALKIN_ONE-ID', 'Walk-in One-ID', 'UC', 'Sub', 'บริการ Walk-in One Stop Service', '1', '2025-12-04 18:14:01', '2026-01-06 15:45:35');
INSERT INTO `fund_codes` VALUES ('XRAY', 'ค่าเอ็กซเรย์', 'UC', 'Sub', 'ค่าบริการเอ็กซเรย์', '1', '2026-01-06 15:34:12', '2026-01-06 15:45:35');

-- ----------------------------
-- Table structure for journal_entries
-- ----------------------------
DROP TABLE IF EXISTS `journal_entries`;
CREATE TABLE `journal_entries` (
  `journal_id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_no` varchar(50) NOT NULL COMMENT 'เลขที่รายการ',
  `journal_date` date NOT NULL COMMENT 'วันที่รายการ',
  `description` text DEFAULT NULL COMMENT 'รายละเอียด',
  `total_debit` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดรวมเดบิต',
  `total_credit` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดรวมเครดิต',
  `status` enum('draft','posted','cancelled') DEFAULT 'draft' COMMENT 'สถานะ: draft=ร่าง, posted=บันทึกแล้ว, cancelled=ยกเลิก',
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'ประเภทอ้างอิง: receipt, payment, adjustment',
  `reference_id` int(11) DEFAULT NULL COMMENT 'ID อ้างอิง',
  `created_by` int(11) DEFAULT NULL,
  `posted_by` int(11) DEFAULT NULL COMMENT 'ผู้บันทึกบัญชี',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `posted_at` timestamp NULL DEFAULT NULL COMMENT 'วันที่บันทึกบัญชี',
  PRIMARY KEY (`journal_id`),
  UNIQUE KEY `journal_no` (`journal_no`),
  KEY `idx_journal_date` (`journal_date`),
  KEY `idx_status` (`status`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  KEY `fk_journal_created_by` (`created_by`),
  KEY `fk_journal_posted_by` (`posted_by`),
  CONSTRAINT `fk_journal_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_journal_posted_by` FOREIGN KEY (`posted_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='บันทึกรายการบัญชี';

-- ----------------------------
-- Records of journal_entries
-- ----------------------------

-- ----------------------------
-- Table structure for journal_entry_details
-- ----------------------------
DROP TABLE IF EXISTS `journal_entry_details`;
CREATE TABLE `journal_entry_details` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `journal_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL COMMENT 'รหัสบัญชี (coa_id)',
  `debit` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดเดบิต',
  `credit` decimal(15,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดเครดิต',
  `description` text DEFAULT NULL COMMENT 'รายละเอียด',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`detail_id`),
  KEY `idx_journal_id` (`journal_id`),
  KEY `idx_account_id` (`account_id`),
  KEY `idx_debit_credit` (`debit`,`credit`),
  CONSTRAINT `fk_journal_detail_account` FOREIGN KEY (`account_id`) REFERENCES `chart_of_accounts` (`coa_id`) ON UPDATE CASCADE,
  CONSTRAINT `fk_journal_detail_journal` FOREIGN KEY (`journal_id`) REFERENCES `journal_entries` (`journal_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='รายละเอียดบันทึกรายการบัญชี';

-- ----------------------------
-- Records of journal_entry_details
-- ----------------------------

-- ----------------------------
-- Table structure for nhso_rep_downloads
-- ----------------------------
DROP TABLE IF EXISTS `nhso_rep_downloads`;
CREATE TABLE `nhso_rep_downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL COMMENT 'ชื่อไฟล์ REP',
  `download_url` text NOT NULL COMMENT 'URL สำหรับดาวน์โหลด',
  `file_type` varchar(10) NOT NULL COMMENT 'ประเภท: OFC, LGO, UCS',
  `patient_type` varchar(10) NOT NULL COMMENT 'OPD หรือ IPD',
  `hcode` varchar(10) DEFAULT NULL COMMENT 'รหัสหน่วยบริการ',
  `month` varchar(2) DEFAULT NULL COMMENT 'เดือน',
  `year` varchar(4) DEFAULT NULL COMMENT 'ปี พ.ศ.',
  `updated_at_nhso` datetime DEFAULT NULL COMMENT 'วันที่อัพเดทใน สปสช',
  `file_size` bigint(20) DEFAULT NULL COMMENT 'ขนาดไฟล์',
  `is_downloaded` tinyint(1) DEFAULT 0 COMMENT '0=ยังไม่โหลด, 1=โหลดแล้ว',
  `downloaded_at` datetime DEFAULT NULL COMMENT 'วันที่ดาวน์โหลด',
  `downloaded_by` int(11) DEFAULT NULL COMMENT 'ผู้ดาวน์โหลด',
  `local_filepath` varchar(255) DEFAULT NULL COMMENT 'ที่อยู่ไฟล์ในเครื่อง',
  `is_imported` tinyint(1) DEFAULT 0 COMMENT '0=ยังไม่ import, 1=import แล้ว',
  `imported_at` datetime DEFAULT NULL COMMENT 'วันที่ import',
  `import_id` int(11) DEFAULT NULL COMMENT 'รหัส import_id จากตาราง rep_import_logs',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_filename` (`filename`),
  KEY `idx_file_type` (`file_type`),
  KEY `idx_is_downloaded` (`is_downloaded`),
  KEY `idx_is_imported` (`is_imported`),
  KEY `idx_month_year` (`month`,`year`),
  KEY `fk_downloaded_by` (`downloaded_by`),
  CONSTRAINT `fk_downloaded_by` FOREIGN KEY (`downloaded_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางเก็บข้อมูล REP จาก สปสช';

-- ----------------------------
-- Records of nhso_rep_downloads
-- ----------------------------

-- ----------------------------
-- Table structure for nhso_sessions
-- ----------------------------
DROP TABLE IF EXISTS `nhso_sessions`;
CREATE TABLE `nhso_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT 'user_id ของผู้ใช้ในระบบ',
  `nhso_username` varchar(100) NOT NULL COMMENT 'username สปสช',
  `session_data` text DEFAULT NULL COMMENT 'session cookies (encrypted)',
  `csrf_token` varchar(255) DEFAULT NULL COMMENT 'CSRF token',
  `is_active` tinyint(1) DEFAULT 1 COMMENT '0=หมดอายุ, 1=ใช้งานได้',
  `last_used` datetime DEFAULT NULL COMMENT 'ใช้งานล่าสุด',
  `expires_at` datetime DEFAULT NULL COMMENT 'หมดอายุเมื่อ',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_is_active` (`is_active`),
  CONSTRAINT `fk_nhso_sessions_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางเก็บ Session สำหรับเชื่อมต่อ สปสช';

-- ----------------------------
-- Records of nhso_sessions
-- ----------------------------

-- ----------------------------
-- Table structure for notifications
-- ----------------------------
DROP TABLE IF EXISTS `notifications`;
CREATE TABLE `notifications` (
  `notification_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) DEFAULT NULL COMMENT 'ผู้รับแจ้งเตือน (NULL = ทุกคนในแผนก)',
  `role` varchar(50) DEFAULT NULL COMMENT 'แผนกที่จะได้รับแจ้งเตือน (accounting, finance, admin)',
  `title` varchar(255) NOT NULL COMMENT 'หัวข้อแจ้งเตือน',
  `message` text NOT NULL COMMENT 'ข้อความแจ้งเตือน',
  `type` enum('info','warning','success','error','pending_action') NOT NULL DEFAULT 'info' COMMENT 'ประเภทแจ้งเตือน',
  `reference_type` varchar(50) DEFAULT NULL COMMENT 'ประเภทอ้างอิง (receipt, ar, statement)',
  `reference_id` int(11) DEFAULT NULL COMMENT 'ID อ้างอิง',
  `action_url` varchar(255) DEFAULT NULL COMMENT 'URL สำหรับดำเนินการ',
  `is_read` tinyint(1) NOT NULL DEFAULT 0 COMMENT '0=ยังไม่อ่าน, 1=อ่านแล้ว',
  `read_at` datetime DEFAULT NULL COMMENT 'วันที่อ่าน',
  `read_by` int(11) DEFAULT NULL COMMENT 'ผู้อ่าน',
  `created_by` int(11) DEFAULT NULL COMMENT 'ผู้สร้างแจ้งเตือน',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`notification_id`),
  KEY `idx_user_read` (`user_id`,`is_read`),
  KEY `idx_role_read` (`role`,`is_read`),
  KEY `idx_reference` (`reference_type`,`reference_id`),
  KEY `idx_created_at` (`created_at`),
  KEY `fk_notification_read_by` (`read_by`),
  KEY `fk_notification_created_by` (`created_by`),
  CONSTRAINT `fk_notification_created_by` FOREIGN KEY (`created_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_notification_read_by` FOREIGN KEY (`read_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL,
  CONSTRAINT `fk_notification_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางแจ้งเตือนในระบบ';

-- ----------------------------
-- Records of notifications
-- ----------------------------

-- ----------------------------
-- Table structure for payers
-- ----------------------------
DROP TABLE IF EXISTS `payers`;
CREATE TABLE `payers` (
  `payer_id` int(11) NOT NULL AUTO_INCREMENT,
  `payer_code` varchar(10) NOT NULL COMMENT 'รหัสแหล่งจ่าย: UCS, OFC, LGO, SSS, BKK',
  `payer_name` varchar(100) NOT NULL COMMENT 'ชื่อแหล่งจ่าย',
  `payer_full_name` varchar(200) DEFAULT NULL COMMENT 'ชื่อเต็ม',
  `payment_method` enum('direct','average') DEFAULT 'direct' COMMENT 'วิธีการจ่าย: direct=ตรงตาม statement, average=หารเฉลี่ย',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`payer_id`),
  UNIQUE KEY `idx_payer_code` (`payer_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางแหล่งจ่ายเงิน';

-- ----------------------------
-- Records of payers
-- ----------------------------
INSERT INTO `payers` VALUES ('1', 'UCS', 'สปสช', 'สำนักงานหลักประกันสุขภาพแห่งชาติ', 'direct', '1', '2025-12-18 16:03:20', '2025-12-18 16:03:20');
INSERT INTO `payers` VALUES ('2', 'OFC', 'กรมบัญชีกลาง', 'กรมบัญชีกลาง กระทรวงการคลัง', 'direct', '1', '2025-12-18 16:03:20', '2025-12-18 16:03:20');
INSERT INTO `payers` VALUES ('3', 'LGO', 'อปท', 'องค์กรปกครองส่วนท้องถิ่น', 'direct', '1', '2025-12-18 16:03:20', '2025-12-18 16:03:20');
INSERT INTO `payers` VALUES ('4', 'SSS', 'ประกันสังคม', 'สำนักงานประกันสังคม', 'average', '1', '2025-12-18 16:03:20', '2025-12-18 16:03:20');
INSERT INTO `payers` VALUES ('5', 'BKK', 'กทม', 'กรุงเทพมหานคร', 'direct', '1', '2025-12-18 16:03:20', '2025-12-18 16:03:20');

-- ----------------------------
-- Table structure for payer_codes
-- ----------------------------
DROP TABLE IF EXISTS `payer_codes`;
CREATE TABLE `payer_codes` (
  `payer_id` int(11) NOT NULL AUTO_INCREMENT,
  `payer_code` varchar(10) NOT NULL,
  `payer_name` varchar(100) NOT NULL,
  `payer_type` varchar(50) NOT NULL COMMENT 'Government, LocalGov, SocialSecurity, etc.',
  `description` text DEFAULT NULL,
  `payment_method` enum('average','direct') DEFAULT 'direct' COMMENT 'วิธีการจ่าย: direct=ตรงตาม statement, average=หารเฉลี่ย',
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`payer_id`),
  KEY `idx_payer_code` (`payer_code`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางรหัสหน่วยจ่าย';

-- ----------------------------
-- Records of payer_codes
-- ----------------------------
INSERT INTO `payer_codes` VALUES ('1', 'BKK', 'อปท. กรุงเทพมหานคร(BKK)', 'LocalGov', 'องค์การบริหารส่วนจังหวัดกรุงเทพมหานคร', 'direct', '1', '2025-12-04 18:13:24', '2025-12-18 16:21:44');
INSERT INTO `payer_codes` VALUES ('2', 'LGO', 'อปท. (LGO)', 'LocalGov', 'องค์การบริหารส่วนท้องถิ่นทั่วไป', 'direct', '1', '2025-12-04 18:13:24', '2025-12-18 16:19:59');
INSERT INTO `payer_codes` VALUES ('3', 'OFC', 'กรมบัญชีกลาง (OFC)', 'Government', 'ข้าราชการและพนักงานรัฐวิสาหกิจ', 'direct', '1', '2025-12-04 18:13:24', '2025-12-18 16:20:04');
INSERT INTO `payer_codes` VALUES ('4', 'SSS', 'ประกันสังคม (SSS)', 'SocialSecurity', 'กองทุนประกันสังคม', 'average', '1', '2025-12-04 18:13:24', '2025-12-18 16:20:33');
INSERT INTO `payer_codes` VALUES ('5', 'UC', 'สปสช. (UC)', 'Government', 'หลักประกันสุขภาพถ้วนหน้า', 'direct', '1', '2025-12-04 18:13:24', '2025-12-18 16:20:15');

-- ----------------------------
-- Table structure for payments
-- ----------------------------
DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_number` varchar(50) NOT NULL,
  `rep_number` varchar(50) DEFAULT NULL,
  `payment_method` enum('cash','transfer','check') DEFAULT 'transfer',
  `statement_number` varchar(50) DEFAULT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `bank_name` varchar(100) DEFAULT NULL,
  `status` enum('pending','approved','cancelled') DEFAULT 'pending',
  `pdf_file` varchar(255) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `approved_by` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `approved_at` timestamp NULL DEFAULT NULL,
  `received_by` int(11) DEFAULT NULL,
  `confirmed_by` int(11) DEFAULT NULL,
  `payer_code` int(10) DEFAULT NULL,
  `payer_name` varchar(100) DEFAULT NULL,
  `total_amount` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`payment_id`),
  UNIQUE KEY `payment_number` (`payment_number`),
  KEY `created_by` (`created_by`),
  KEY `approved_by` (`approved_by`),
  KEY `idx_payment_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of payments
-- ----------------------------

-- ----------------------------
-- Table structure for payment_allocations
-- ----------------------------
DROP TABLE IF EXISTS `payment_allocations`;
CREATE TABLE `payment_allocations` (
  `allocation_id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_id` int(11) NOT NULL,
  `ar_id` int(11) NOT NULL,
  `allocated_amount` decimal(15,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`allocation_id`),
  KEY `payment_id` (`payment_id`),
  KEY `ar_id` (`ar_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of payment_allocations
-- ----------------------------

-- ----------------------------
-- Table structure for payment_details
-- ----------------------------
DROP TABLE IF EXISTS `payment_details`;
CREATE TABLE `payment_details` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `payment_id` int(11) NOT NULL COMMENT 'รหัสการรับเงิน',
  `ar_id` int(11) NOT NULL COMMENT 'รหัสลูกหนี้',
  `paid_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'จำนวนเงินที่รับ',
  `remark` varchar(500) DEFAULT NULL COMMENT 'หมายเหตุ',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`detail_id`),
  KEY `idx_payment_id` (`payment_id`),
  KEY `idx_ar_id` (`ar_id`),
  CONSTRAINT `fk_payment_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางรายละเอียดการรับเงิน';

-- ----------------------------
-- Records of payment_details
-- ----------------------------

-- ----------------------------
-- Table structure for receipt_workflow
-- ----------------------------
DROP TABLE IF EXISTS `receipt_workflow`;
CREATE TABLE `receipt_workflow` (
  `workflow_id` int(11) NOT NULL AUTO_INCREMENT,
  `receipt_id` int(11) NOT NULL,
  `status` enum('allocated','confirmed','posted','rejected') NOT NULL COMMENT 'สถานะ: allocated=จัดสรรแล้ว, confirmed=ยืนยันแล้ว, posted=บันทึกบัญชีแล้ว, rejected=ปฏิเสธ',
  `action_by` int(11) NOT NULL COMMENT 'ผู้ดำเนินการ',
  `action_date` datetime NOT NULL DEFAULT current_timestamp(),
  `remark` text DEFAULT NULL COMMENT 'หมายเหตุ',
  `previous_status` varchar(50) DEFAULT NULL COMMENT 'สถานะก่อนหน้า',
  PRIMARY KEY (`workflow_id`),
  KEY `idx_receipt_status` (`receipt_id`,`status`),
  KEY `idx_action_date` (`action_date`),
  KEY `fk_workflow_user` (`action_by`),
  CONSTRAINT `fk_workflow_receipt` FOREIGN KEY (`receipt_id`) REFERENCES `finance_receipts` (`receipt_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_workflow_user` FOREIGN KEY (`action_by`) REFERENCES `users` (`user_id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางติดตาม Workflow ใบเสร็จ';

-- ----------------------------
-- Records of receipt_workflow
-- ----------------------------

-- ----------------------------
-- Table structure for rep_import_details
-- ----------------------------
DROP TABLE IF EXISTS `rep_import_details`;
CREATE TABLE `rep_import_details` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `import_id` int(11) NOT NULL COMMENT 'รหัสการนำเข้า',
  `rep_no` varchar(50) DEFAULT '' COMMENT 'เลข REP สำหรับอ้างอิงรับโอน',
  `seq_no` varchar(50) DEFAULT '' COMMENT 'SEQ NO จากไฟล์ REP',
  `hn` varchar(20) DEFAULT '' COMMENT 'HN',
  `vn` varchar(20) DEFAULT '' COMMENT 'VN',
  `an` varchar(20) DEFAULT '' COMMENT 'AN',
  `patient_name` varchar(200) DEFAULT '' COMMENT 'ชื่อผู้ป่วย',
  `pid` varchar(13) DEFAULT '' COMMENT 'เลขบัตรประชาชน',
  `service_date` datetime DEFAULT NULL,
  `claim_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'ยอดเบิก',
  `approved_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'ยอดอนุมัติ',
  `reject_amount` decimal(10,2) DEFAULT 0.00 COMMENT 'ยอดตัด',
  `reject_reason` text DEFAULT NULL COMMENT 'เหตุผลตัด',
  `error_code` varchar(50) DEFAULT '' COMMENT 'Error Code จาก สปสช (Column N)',
  `fund_main` varchar(100) DEFAULT '' COMMENT 'กองทุนหลักที่ได้รับชดเชย (Column O)',
  `fund_sub` varchar(200) DEFAULT '' COMMENT 'กองทุนย่อยที่ได้รับชดเชย (Column P)',
  `ar_id` int(11) DEFAULT NULL COMMENT 'รหัสลูกหนี้ที่จับคู่ได้',
  `match_status` enum('matched','not_found','duplicate','amount_diff') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT 'not_found' COMMENT 'สถานะการจับคู่',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`detail_id`),
  KEY `idx_import_id` (`import_id`),
  KEY `idx_hn` (`hn`),
  KEY `idx_vn` (`vn`),
  KEY `idx_an` (`an`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_match_status` (`match_status`),
  KEY `idx_rep_no` (`rep_no`),
  KEY `idx_seq_no` (`seq_no`),
  KEY `idx_error_code` (`error_code`),
  KEY `idx_fund_main` (`fund_main`),
  KEY `idx_fund_sub` (`fund_sub`),
  KEY `idx_pid` (`pid`),
  KEY `idx_fund_composite` (`fund_main`,`fund_sub`),
  KEY `idx_import_status` (`import_id`,`match_status`),
  KEY `idx_fund` (`fund_main`,`fund_sub`),
  CONSTRAINT `fk_rep_detail_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_rep_detail_import` FOREIGN KEY (`import_id`) REFERENCES `rep_import_logs` (`import_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางรายละเอียดข้อมูลจาก REP';

-- ----------------------------
-- Records of rep_import_details
-- ----------------------------

-- ----------------------------
-- Table structure for rep_import_logs
-- ----------------------------
DROP TABLE IF EXISTS `rep_import_logs`;
CREATE TABLE `rep_import_logs` (
  `import_id` int(11) NOT NULL AUTO_INCREMENT,
  `import_file` varchar(255) NOT NULL COMMENT 'ชื่อไฟล์ที่นำเข้า',
  `file_type` varchar(20) DEFAULT '' COMMENT 'ประเภทไฟล์: UC, BKK, LGO, CS, SSS_OPD, SSS_IPD',
  `rep_number` varchar(50) DEFAULT '' COMMENT 'เลข REP หลักของงวดนี้',
  `import_date` date NOT NULL COMMENT 'วันที่นำเข้า',
  `patient_type` varchar(20) DEFAULT '',
  `payer_code` varchar(20) DEFAULT '' COMMENT 'รหัสหน่วยงานประกัน',
  `payer_name` varchar(200) DEFAULT '' COMMENT 'ชื่อหน่วยงานประกัน',
  `total_records` int(11) DEFAULT 0 COMMENT 'จำนวนรายการทั้งหมด',
  `matched_records` int(11) DEFAULT 0 COMMENT 'จำนวนที่ตรง',
  `unmatched_records` int(11) DEFAULT 0 COMMENT 'จำนวนที่ไม่ตรง',
  `error_records` int(11) DEFAULT 0 COMMENT 'จำนวนรายการที่มี Error Code',
  `total_amount` decimal(12,2) DEFAULT 0.00 COMMENT 'ยอดรวมจาก REP',
  `import_status` enum('processing','completed','failed') DEFAULT 'processing' COMMENT 'สถานะการนำเข้า',
  `imported_by` int(11) DEFAULT NULL COMMENT 'ผู้นำเข้า (user_id)',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`import_id`),
  KEY `idx_import_date` (`import_date`),
  KEY `idx_payer_code` (`payer_code`),
  KEY `idx_import_status` (`import_status`),
  KEY `fk_rep_import_user` (`imported_by`),
  KEY `idx_file_type` (`file_type`),
  KEY `idx_created_at` (`created_at`),
  CONSTRAINT `fk_rep_import_user` FOREIGN KEY (`imported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางประวัติการนำเข้าไฟล์ REP';

-- ----------------------------
-- Records of rep_import_logs
-- ----------------------------

-- ----------------------------
-- Table structure for sss_auto_download_log
-- ----------------------------
DROP TABLE IF EXISTS `sss_auto_download_log`;
CREATE TABLE `sss_auto_download_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `run_at` datetime NOT NULL COMMENT 'วันเวลาที่รัน',
  `total_files` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนไฟล์ทั้งหมดที่พบ',
  `downloaded_files` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนไฟล์ที่ดาวน์โหลดสำเร็จ',
  `skipped_files` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนไฟล์ที่ข้าม (ดาวน์โหลดแล้ว)',
  `failed_files` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนไฟล์ที่ล้มเหลว',
  `imported_files` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนไฟล์ที่ Import สำเร็จ',
  `import_failed_files` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนไฟล์ที่ Import ล้มเหลว',
  `status` varchar(20) NOT NULL COMMENT 'สถานะการรัน (success, partial, failed)',
  `error_message` text DEFAULT NULL COMMENT 'ข้อความ error (ถ้ามี)',
  `duration_seconds` int(11) DEFAULT NULL COMMENT 'เวลาที่ใช้ (วินาที)',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_run_at` (`run_at`),
  KEY `idx_status` (`status`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='เก็บ Log การดาวน์โหลดอัตโนมัติ';

-- ----------------------------
-- Records of sss_auto_download_log
-- ----------------------------

-- ----------------------------
-- Table structure for sss_rep_downloads
-- ----------------------------
DROP TABLE IF EXISTS `sss_rep_downloads`;
CREATE TABLE `sss_rep_downloads` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `filename` varchar(255) NOT NULL,
  `download_url` text DEFAULT NULL,
  `file_type` varchar(20) DEFAULT NULL COMMENT 'SSS_OPD, SSS_IPD',
  `patient_type` varchar(10) DEFAULT NULL COMMENT 'OPD, IPD',
  `hcode` varchar(10) DEFAULT NULL,
  `session_code` varchar(50) DEFAULT NULL COMMENT 'รหัส Session จากไฟล์',
  `rep_no` varchar(50) DEFAULT NULL,
  `updated_at_sss` varchar(50) DEFAULT NULL,
  `is_downloaded` tinyint(1) DEFAULT 0,
  `downloaded_at` datetime DEFAULT NULL,
  `downloaded_by` int(11) DEFAULT NULL,
  `local_filepath` varchar(500) DEFAULT NULL,
  `file_size` int(11) DEFAULT NULL,
  `is_imported` tinyint(1) DEFAULT 0,
  `imported_at` datetime DEFAULT NULL,
  `import_id` int(11) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_filename` (`filename`),
  KEY `downloaded_by` (`downloaded_by`),
  KEY `import_id` (`import_id`),
  CONSTRAINT `sss_rep_downloads_ibfk_1` FOREIGN KEY (`downloaded_by`) REFERENCES `users` (`user_id`),
  CONSTRAINT `sss_rep_downloads_ibfk_2` FOREIGN KEY (`import_id`) REFERENCES `rep_import_logs` (`import_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Records of sss_rep_downloads
-- ----------------------------

-- ----------------------------
-- Table structure for sss_sessions
-- ----------------------------
DROP TABLE IF EXISTS `sss_sessions`;
CREATE TABLE `sss_sessions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL COMMENT 'User ID ที่ login',
  `session_id` varchar(64) NOT NULL COMMENT 'Session ID (MD5)',
  `hcode` varchar(10) NOT NULL COMMENT 'รหัสโรงพยาบาล',
  `username` varchar(50) NOT NULL COMMENT 'Username ที่ใช้ login',
  `is_active` tinyint(1) NOT NULL DEFAULT 1 COMMENT '1=Active, 0=Inactive',
  `created_at` datetime NOT NULL COMMENT 'วันเวลาที่ login',
  `expired_at` datetime DEFAULT NULL COMMENT 'วันเวลาที่หมดอายุ (ถ้ามี)',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_is_active` (`is_active`),
  KEY `idx_created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci COMMENT='เก็บ Session การ Login เข้าระบบ SSS';

-- ----------------------------
-- Records of sss_sessions
-- ----------------------------

-- ----------------------------
-- Table structure for sss_sessions1
-- ----------------------------
DROP TABLE IF EXISTS `sss_sessions1`;
CREATE TABLE `sss_sessions1` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `sss_username` varchar(100) DEFAULT NULL,
  `sss_hcode` varchar(10) DEFAULT NULL,
  `session_data` text DEFAULT NULL,
  `last_used` datetime DEFAULT NULL,
  `expires_at` datetime DEFAULT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `sss_sessions1_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3 COLLATE=utf8mb3_general_ci;

-- ----------------------------
-- Records of sss_sessions1
-- ----------------------------

-- ----------------------------
-- Table structure for statement_details
-- ----------------------------
DROP TABLE IF EXISTS `statement_details`;
CREATE TABLE `statement_details` (
  `statement_detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `statement_import_id` int(11) NOT NULL COMMENT 'อ้างอิง statement import log',
  `rep_no` varchar(50) DEFAULT '' COMMENT 'เลขที่ REP ที่เกี่ยวข้อง',
  `hn` varchar(20) DEFAULT '' COMMENT 'HN',
  `an` varchar(20) DEFAULT '' COMMENT 'AN',
  `vn` varchar(20) DEFAULT '' COMMENT 'VN',
  `pid` varchar(13) DEFAULT '' COMMENT 'เลขบัตรประชาชน',
  `patient_name` varchar(255) DEFAULT '' COMMENT 'ชื่อผู้ป่วย',
  `service_date` datetime DEFAULT NULL COMMENT 'วันที่รับบริการ',
  `date_admit` date DEFAULT NULL,
  `date_discharge` date DEFAULT NULL,
  `claim_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดเบิก',
  `approved_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดอนุมัติ/ชดเชย',
  `adjusted_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดปรับลด',
  `adjrw` decimal(10,4) DEFAULT 0.0000 COMMENT 'ADJRW (สำหรับ UC)',
  `ar_id` int(11) DEFAULT NULL COMMENT 'อ้างอิงลูกหนี้ (ถ้าจับคู่ได้)',
  `match_status` enum('matched','not_matched','pending','duplicate','manual_matched') DEFAULT 'pending' COMMENT 'สถานะการจับคู่',
  `matched_by` int(11) DEFAULT NULL COMMENT 'ผู้จับคู่ (user_id)',
  `matched_at` datetime DEFAULT NULL COMMENT 'วันที่จับคู่',
  `match_note` text DEFAULT NULL COMMENT 'หมายเหตุการจับคู่',
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`statement_detail_id`),
  KEY `idx_statement_import` (`statement_import_id`),
  KEY `idx_rep_no` (`rep_no`),
  KEY `idx_hn` (`hn`),
  KEY `idx_an` (`an`),
  KEY `idx_vn` (`vn`),
  KEY `idx_service_date` (`service_date`),
  KEY `idx_ar_id` (`ar_id`),
  KEY `idx_match_status` (`match_status`),
  KEY `fk_statement_matched_by` (`matched_by`),
  CONSTRAINT `fk_statement_import` FOREIGN KEY (`statement_import_id`) REFERENCES `statement_import_logs` (`statement_import_id`) ON DELETE CASCADE,
  CONSTRAINT `fk_statement_matched_by` FOREIGN KEY (`matched_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `statement_details_ibfk_2` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- Records of statement_details
-- ----------------------------

-- ----------------------------
-- Table structure for statement_import_logs
-- ----------------------------
DROP TABLE IF EXISTS `statement_import_logs`;
CREATE TABLE `statement_import_logs` (
  `statement_import_id` int(11) NOT NULL AUTO_INCREMENT,
  `statement_type` varchar(20) NOT NULL COMMENT 'ประเภท: SSS_IP, SSS_OP, UC_IP, UC_OP, OFC_OP, OFC_IP, LGO_OP, LGO_IP, BKK_OP, BKK_IP',
  `file_name` varchar(255) NOT NULL COMMENT 'ชื่อไฟล์',
  `period` varchar(20) DEFAULT NULL COMMENT 'งวดที่นำเข้า',
  `document_no` varchar(50) DEFAULT NULL COMMENT 'เลขที่เอกสาร Statement',
  `total_records` int(11) DEFAULT 0 COMMENT 'จำนวนรายการทั้งหมด',
  `matched_records` int(11) DEFAULT 0 COMMENT 'จำนวนที่จับคู่สำเร็จ',
  `unmatched_records` int(11) DEFAULT 0 COMMENT 'จำนวนที่ไม่สามารถจับคู่',
  `total_amount` decimal(15,2) DEFAULT 0.00 COMMENT 'ยอดชดเชยรวม',
  `imported_by` int(11) DEFAULT NULL COMMENT 'ผู้นำเข้า (user_id)',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`statement_import_id`),
  KEY `idx_statement_type` (`statement_type`),
  KEY `idx_period` (`period`),
  KEY `idx_created_at` (`created_at`),
  KEY `fk_statement_imported_by` (`imported_by`),
  CONSTRAINT `fk_statement_imported_by` FOREIGN KEY (`imported_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางบันทึกประวัติการนำเข้า Statement';

-- ----------------------------
-- Records of statement_import_logs
-- ----------------------------

-- ----------------------------
-- Table structure for submissions
-- ----------------------------
DROP TABLE IF EXISTS `submissions`;
CREATE TABLE `submissions` (
  `submission_id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_number` varchar(50) NOT NULL COMMENT 'เลขที่การส่ง',
  `submission_date` date NOT NULL COMMENT 'วันที่ส่ง',
  `submission_channel` enum('online','document','both') DEFAULT 'online' COMMENT 'ช่องทางการส่ง',
  `item_count` int(11) NOT NULL DEFAULT 0 COMMENT 'จำนวนรายการ',
  `total_amount` decimal(12,2) NOT NULL DEFAULT 0.00 COMMENT 'ยอดรวม',
  `status` enum('pending','approved','rejected','partial') DEFAULT 'pending' COMMENT 'สถานะ',
  `submitted_by` int(11) DEFAULT NULL COMMENT 'ผู้ส่ง (user_id)',
  `approved_by` int(11) DEFAULT NULL COMMENT 'ผู้อนุมัติ (user_id)',
  `approved_at` datetime DEFAULT NULL COMMENT 'วันที่อนุมัติ',
  `remark` text DEFAULT NULL COMMENT 'หมายเหตุ',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`submission_id`),
  UNIQUE KEY `submission_number` (`submission_number`),
  KEY `idx_submission_date` (`submission_date`),
  KEY `idx_submission_number` (`submission_number`),
  KEY `idx_status` (`status`),
  KEY `fk_submission_submitted_by` (`submitted_by`),
  KEY `fk_submission_approved_by` (`approved_by`),
  CONSTRAINT `fk_submission_approved_by` FOREIGN KEY (`approved_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_submission_submitted_by` FOREIGN KEY (`submitted_by`) REFERENCES `users` (`user_id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางรายการส่งลูกหนี้';

-- ----------------------------
-- Records of submissions
-- ----------------------------

-- ----------------------------
-- Table structure for submission_details
-- ----------------------------
DROP TABLE IF EXISTS `submission_details`;
CREATE TABLE `submission_details` (
  `detail_id` int(11) NOT NULL AUTO_INCREMENT,
  `submission_id` int(11) NOT NULL COMMENT 'รหัสการส่ง',
  `ar_id` int(11) NOT NULL COMMENT 'รหัสลูกหนี้',
  `amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'จำนวนเงิน',
  `status` enum('pending','approved','rejected') DEFAULT 'pending',
  `reject_reason` text DEFAULT NULL COMMENT 'เหตุผลที่ปฏิเสธ',
  `created_at` datetime DEFAULT current_timestamp(),
  PRIMARY KEY (`detail_id`),
  KEY `idx_submission_id` (`submission_id`),
  KEY `idx_ar_id` (`ar_id`),
  CONSTRAINT `fk_sub_detail_ar` FOREIGN KEY (`ar_id`) REFERENCES `accounts_receivable` (`ar_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_sub_detail_submission` FOREIGN KEY (`submission_id`) REFERENCES `submissions` (`submission_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci COMMENT='ตารางรายละเอียดการส่งลูกหนี้';

-- ----------------------------
-- Records of submission_details
-- ----------------------------

-- ----------------------------
-- Table structure for users
-- ----------------------------
DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` enum('admin','insurance','finance','accounting') NOT NULL,
  `is_active` tinyint(1) DEFAULT 1,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- ----------------------------
-- View structure for v_ar_current_balance
-- ----------------------------
DROP VIEW IF EXISTS `v_ar_current_balance`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_ar_current_balance` AS select `ar`.`ar_id` AS `ar_id`,`ar`.`ar_number` AS `ar_number`,`ar`.`hn` AS `hn`,`ar`.`vn` AS `vn`,`ar`.`an` AS `an`,`ar`.`patient_name` AS `patient_name`,`ar`.`service_date` AS `service_date`,`ar`.`discharge_date` AS `discharge_date`,`ar`.`total_amount` AS `total_amount`,`ar`.`ar_amount` AS `original_ar_amount`,coalesce(`ar`.`original_ar_amount`,`ar`.`ar_amount`) AS `base_ar_amount`,coalesce(sum(`apt`.`amount`),0) AS `total_paid`,coalesce(`ar`.`original_ar_amount`,`ar`.`ar_amount`) - coalesce(sum(`apt`.`amount`),0) AS `current_balance`,`ar`.`payment_source` AS `payment_source`,`ar`.`status` AS `status`,`ar`.`submission_status` AS `submission_status`,`ar`.`recorded_at` AS `recorded_at`,`ar`.`coa_id` AS `coa_id` from (`accounts_receivable` `ar` left join `ar_payment_transactions` `apt` on(`ar`.`ar_id` = `apt`.`ar_id`)) group by `ar`.`ar_id`,`ar`.`ar_number`,`ar`.`hn`,`ar`.`vn`,`ar`.`an`,`ar`.`patient_name`,`ar`.`service_date`,`ar`.`discharge_date`,`ar`.`total_amount`,`ar`.`ar_amount`,`ar`.`original_ar_amount`,`ar`.`payment_source`,`ar`.`status`,`ar`.`submission_status`,`ar`.`recorded_at`,`ar`.`coa_id` ;

-- ----------------------------
-- View structure for v_ar_master
-- ----------------------------
DROP VIEW IF EXISTS `v_ar_master`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_ar_master` AS select `ar`.`ar_id` AS `ar_id`,`ar`.`ar_number` AS `ar_number`,`ar`.`hn` AS `hn`,`ar`.`vn` AS `vn`,`ar`.`an` AS `an`,`ar`.`patient_name` AS `patient_name`,`ar`.`service_date` AS `service_date`,`ar`.`discharge_date` AS `discharge_date`,`ar`.`total_amount` AS `total_amount`,`ar`.`ar_amount` AS `ar_amount`,`ar`.`balance` AS `balance`,`ar`.`status` AS `status`,`ar`.`submission_status` AS `submission_status`,`ar`.`recorded_at` AS `recorded_at`,`coa`.`account_code` AS `account_code`,`coa`.`account_name` AS `account_name`,`coa`.`payer_code` AS `payer_code`,`coa`.`payer_name` AS `payer_name`,ifnull(sum(`cd`.`approved_amount`),0) AS `total_approved`,ifnull(sum(`pd`.`paid_amount`),0) AS `total_paid`,`ar`.`ar_amount` - ifnull(sum(`cd`.`approved_amount`),0) AS `claim_diff`,`ar`.`balance` - ifnull(sum(`pd`.`paid_amount`),0) AS `payment_diff` from (((`accounts_receivable` `ar` join `chart_of_accounts` `coa` on(`ar`.`coa_id` = `coa`.`coa_id`)) left join `claim_details` `cd` on(`ar`.`ar_id` = `cd`.`ar_id` and `cd`.`status` = 'approved')) left join `payment_details` `pd` on(`ar`.`ar_id` = `pd`.`ar_id`)) where `ar`.`submission_status` = 'recorded' group by `ar`.`ar_id` ;

-- ----------------------------
-- View structure for v_claim_errors_detail
-- ----------------------------
DROP VIEW IF EXISTS `v_claim_errors_detail`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_claim_errors_detail` AS select `ce`.`claim_error_id` AS `claim_error_id`,`ce`.`ar_id` AS `ar_id`,`ar`.`ar_number` AS `ar_number`,`ar`.`hn` AS `hn`,`ar`.`vn` AS `vn`,`ar`.`an` AS `an`,`ar`.`cid` AS `cid`,`ar`.`patient_name` AS `patient_name`,`ar`.`service_date` AS `service_date`,`ar`.`pttype` AS `pttype`,`ce`.`error_code` AS `error_code`,`ce`.`error_type` AS `error_type`,`ce`.`insurance_type` AS `insurance_type`,`ce`.`claim_type` AS `claim_type`,`ce`.`error_message` AS `error_message`,`ce`.`status` AS `error_status`,`ce`.`detected_at` AS `detected_at`,`ce`.`resolved_at` AS `resolved_at`,`ce`.`resubmitted` AS `resubmitted`,`ce`.`resubmit_date` AS `resubmit_date`,`ec`.`error_description` AS `error_description`,`ec`.`solution_guideline` AS `solution_guideline`,case when `ce`.`status` = 'resolved' and `ce`.`resolved_at` is not null then to_days(`ce`.`resolved_at`) - to_days(`ce`.`detected_at`) when `ce`.`status` <> 'resolved' then to_days(curdate()) - to_days(cast(`ce`.`detected_at` as date)) else NULL end AS `days_since_detection`,`u`.`full_name` AS `resolved_by_name` from (((`claim_errors` `ce` join `accounts_receivable` `ar` on(`ce`.`ar_id` = `ar`.`ar_id`)) left join `error_codes` `ec` on(`ce`.`error_code` = `ec`.`error_code` and (`ec`.`insurance_type` = `ce`.`insurance_type` or `ec`.`insurance_type` = 'ALL'))) left join `users` `u` on(`ce`.`resolved_by` = `u`.`user_id`)) ;

-- ----------------------------
-- View structure for v_duplicate_ar_patients
-- ----------------------------
DROP VIEW IF EXISTS `v_duplicate_ar_patients`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_duplicate_ar_patients` AS select coalesce(`ar`.`vn`,`ar`.`an`) AS `visit_key`,`ar`.`hn` AS `hn`,`ar`.`vn` AS `vn`,`ar`.`an` AS `an`,`ar`.`service_date` AS `service_date`,count(distinct `ar`.`ar_id`) AS `ar_count`,count(distinct `ar`.`coa_id`) AS `coa_count`,group_concat(concat('AR:',`ar`.`ar_number`,' | COA:',`coa`.`account_code`,' | Source:',`ar`.`payment_source`,' | Amount:',`ar`.`ar_amount`) order by `ar`.`ar_id` ASC separator '\n') AS `ar_details`,group_concat(distinct `ar`.`payment_source` order by `ar`.`payment_source` ASC separator ',') AS `payment_sources` from (`accounts_receivable` `ar` join `chart_of_accounts` `coa` on(`ar`.`coa_id` = `coa`.`coa_id`)) where `ar`.`status` <> 'cancelled' group by coalesce(`ar`.`vn`,`ar`.`an`),`ar`.`hn`,`ar`.`vn`,`ar`.`an`,`ar`.`service_date` having count(distinct `ar`.`ar_id`) > 1 ;

-- ----------------------------
-- View structure for v_error_summary_by_insurance
-- ----------------------------
DROP VIEW IF EXISTS `v_error_summary_by_insurance`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_error_summary_by_insurance` AS select `ce`.`insurance_type` AS `insurance_type`,`ce`.`claim_type` AS `claim_type`,count(distinct `ce`.`claim_error_id`) AS `total_errors`,sum(case when `ce`.`error_type` = 'C' then 1 else 0 end) AS `errors_c_type`,sum(case when `ce`.`error_type` = 'E' then 1 else 0 end) AS `errors_e_type`,sum(case when `ce`.`error_type` = 'W' then 1 else 0 end) AS `errors_w_type`,sum(case when `ce`.`status` = 'resolved' then 1 else 0 end) AS `resolved_count`,sum(case when `ce`.`status` = 'pending' then 1 else 0 end) AS `pending_count`,sum(case when `ce`.`status` = 'in_progress' then 1 else 0 end) AS `in_progress_count`,sum(case when `ce`.`status` = 'cancelled' then 1 else 0 end) AS `cancelled_count`,round(avg(case when `ce`.`status` = 'resolved' and `ce`.`resolved_at` is not null then to_days(`ce`.`resolved_at`) - to_days(`ce`.`detected_at`) else NULL end),2) AS `avg_resolution_days` from `claim_errors` `ce` group by `ce`.`insurance_type`,`ce`.`claim_type` ;

-- ----------------------------
-- View structure for v_rep_errors
-- ----------------------------
DROP VIEW IF EXISTS `v_rep_errors`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_rep_errors` AS select `rid`.`import_id` AS `import_id`,`ril`.`import_file` AS `import_file`,`ril`.`payer_code` AS `payer_code`,`rid`.`error_code` AS `error_code`,count(0) AS `error_count`,group_concat(distinct `rid`.`fund_main` order by `rid`.`fund_main` ASC separator ', ') AS `affected_funds` from (`rep_import_details` `rid` join `rep_import_logs` `ril` on(`rid`.`import_id` = `ril`.`import_id`)) where `rid`.`error_code` is not null group by `rid`.`import_id`,`ril`.`import_file`,`ril`.`payer_code`,`rid`.`error_code` ;

-- ----------------------------
-- View structure for v_rep_import_summary
-- ----------------------------
DROP VIEW IF EXISTS `v_rep_import_summary`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_rep_import_summary` AS select `ril`.`import_id` AS `import_id`,`ril`.`import_file` AS `import_file`,`ril`.`file_type` AS `file_type`,`ril`.`patient_type` AS `patient_type`,`ril`.`payer_code` AS `payer_code`,`pc`.`payer_name` AS `payer_name`,`ril`.`total_records` AS `total_records`,`ril`.`matched_records` AS `matched_records`,`ril`.`unmatched_records` AS `unmatched_records`,`ril`.`error_records` AS `error_records`,`ril`.`created_at` AS `created_at`,`u`.`full_name` AS `imported_by_name`,round(`ril`.`matched_records` * 100.0 / nullif(`ril`.`total_records`,0),2) AS `match_percentage`,round(`ril`.`error_records` * 100.0 / nullif(`ril`.`total_records`,0),2) AS `error_percentage`,(select count(distinct `rep_import_details`.`fund_main`) from `rep_import_details` where `rep_import_details`.`import_id` = `ril`.`import_id`) AS `distinct_funds`,(select group_concat(distinct `rep_import_details`.`error_code` order by `rep_import_details`.`error_code` ASC separator ', ') from `rep_import_details` where `rep_import_details`.`import_id` = `ril`.`import_id` and `rep_import_details`.`error_code` is not null) AS `error_codes_found` from ((`rep_import_logs` `ril` left join `payer_codes` `pc` on(`ril`.`payer_code` collate utf8mb4_unicode_ci = `pc`.`payer_code`)) left join `users` `u` on(`ril`.`imported_by` = `u`.`user_id`)) ;

-- ----------------------------
-- View structure for v_statement_duplicate_matches
-- ----------------------------
DROP VIEW IF EXISTS `v_statement_duplicate_matches`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_statement_duplicate_matches` AS select `sd`.`statement_detail_id` AS `statement_detail_id`,`sd`.`statement_import_id` AS `statement_import_id`,`sil`.`statement_type` AS `statement_type`,`sil`.`period` AS `period`,`sd`.`hn` AS `hn`,`sd`.`vn` AS `vn`,`sd`.`an` AS `an`,`sd`.`service_date` AS `service_date`,`sd`.`approved_amount` AS `approved_amount`,`sd`.`match_status` AS `match_status`,count(`ar`.`ar_id`) AS `matching_ar_count`,group_concat(concat('AR:',`ar`.`ar_number`,' | COA:',`coa`.`account_code`,' | Source:',`ar`.`payment_source`,' | Status:',`ar`.`status`) order by `ar`.`ar_id` ASC separator '\n') AS `matching_ars` from (((`statement_details` `sd` join `statement_import_logs` `sil` on(`sd`.`statement_import_id` = `sil`.`statement_import_id`)) left join `accounts_receivable` `ar` on((`sd`.`vn` is not null and `sd`.`vn` <> '' and `ar`.`vn` = `sd`.`vn` or `sd`.`an` is not null and `sd`.`an` <> '' and `ar`.`an` = `sd`.`an`) and `ar`.`hn` = `sd`.`hn` and cast(`ar`.`service_date` as date) = cast(`sd`.`service_date` as date) and `ar`.`status` <> 'cancelled')) left join `chart_of_accounts` `coa` on(`ar`.`coa_id` = `coa`.`coa_id`)) where `sd`.`match_status` in ('pending','matched') group by `sd`.`statement_detail_id` having count(`ar`.`ar_id`) > 1 ;

-- ----------------------------
-- View structure for v_statement_import_summary
-- ----------------------------
DROP VIEW IF EXISTS `v_statement_import_summary`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_statement_import_summary` AS select `sil`.`statement_import_id` AS `statement_import_id`,`sil`.`statement_type` AS `statement_type`,`sil`.`file_name` AS `file_name`,`sil`.`period` AS `period`,`sil`.`document_no` AS `document_no`,`sil`.`total_records` AS `total_records`,`sil`.`matched_records` AS `matched_records`,`sil`.`unmatched_records` AS `unmatched_records`,`sil`.`total_amount` AS `total_amount`,`sil`.`created_at` AS `created_at`,`u`.`full_name` AS `imported_by_name`,round(`sil`.`matched_records` * 100.0 / nullif(`sil`.`total_records`,0),2) AS `match_percentage`,count(distinct `sd`.`ar_id`) AS `unique_ar_matched`,sum(case when `sd`.`match_status` = 'duplicate' then 1 else 0 end) AS `duplicate_count` from ((`statement_import_logs` `sil` left join `users` `u` on(`sil`.`imported_by` = `u`.`user_id`)) left join `statement_details` `sd` on(`sil`.`statement_import_id` = `sd`.`statement_import_id`)) group by `sil`.`statement_import_id` ;

-- ----------------------------
-- View structure for v_statement_unmatched
-- ----------------------------
DROP VIEW IF EXISTS `v_statement_unmatched`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_statement_unmatched` AS select `sd`.`statement_detail_id` AS `statement_detail_id`,`sil`.`statement_type` AS `statement_type`,`sil`.`period` AS `period`,`sd`.`hn` AS `hn`,`sd`.`vn` AS `vn`,`sd`.`an` AS `an`,`sd`.`pid` AS `pid`,`sd`.`patient_name` AS `patient_name`,`sd`.`service_date` AS `service_date`,`sd`.`date_admit` AS `date_admit`,`sd`.`date_discharge` AS `date_discharge`,`sd`.`approved_amount` AS `approved_amount`,`sd`.`match_status` AS `match_status`,`sil`.`created_at` AS `import_date` from (`statement_details` `sd` join `statement_import_logs` `sil` on(`sd`.`statement_import_id` = `sil`.`statement_import_id`)) where `sd`.`match_status` = 'unmatched' order by `sil`.`created_at` desc,`sd`.`approved_amount` desc ;

-- ----------------------------
-- View structure for v_top_error_codes
-- ----------------------------
DROP VIEW IF EXISTS `v_top_error_codes`;
CREATE ALGORITHM=UNDEFINED DEFINER=CURRENT_USER SQL SECURITY DEFINER VIEW `v_top_error_codes` AS select `ce`.`error_code` AS `error_code`,`ec`.`error_description` AS `error_description`,`ce`.`insurance_type` AS `insurance_type`,count(0) AS `error_count`,sum(case when `ce`.`status` = 'resolved' then 1 else 0 end) AS `resolved_count`,round(sum(case when `ce`.`status` = 'resolved' then 1 else 0 end) * 100.0 / count(0),2) AS `resolution_rate` from (`claim_errors` `ce` left join `error_codes` `ec` on(`ce`.`error_code` = `ec`.`error_code` and (`ec`.`insurance_type` = `ce`.`insurance_type` or `ec`.`insurance_type` = 'ALL'))) group by `ce`.`error_code`,`ec`.`error_description`,`ce`.`insurance_type` order by count(0) desc limit 10 ;

-- ----------------------------
-- Procedure structure for sp_change_payment_source
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_change_payment_source`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_change_payment_source`(
    IN p_ar_id INT,
    IN p_new_payment_source VARCHAR(50),
    IN p_new_note TEXT,
    IN p_reason TEXT,
    IN p_user_id INT,
    OUT p_result VARCHAR(200)
)
BEGIN
    DECLARE v_old_payment_source VARCHAR(50);
    DECLARE v_old_note TEXT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Transaction failed';
    END;
    
    START TRANSACTION;
    
    -- ดึงค่าเดิม
    SELECT payment_source, payment_source_note 
    INTO v_old_payment_source, v_old_note
    FROM accounts_receivable
    WHERE ar_id = p_ar_id;
    
    -- อัพเดท payment_source
    UPDATE accounts_receivable
    SET 
        payment_source = p_new_payment_source,
        payment_source_note = p_new_note,
        updated_by = p_user_id
    WHERE ar_id = p_ar_id;
    
    -- บันทึกประวัติ
    INSERT INTO ar_payment_source_history (
        ar_id,
        old_payment_source,
        new_payment_source,
        old_note,
        new_note,
        reason,
        changed_by
    ) VALUES (
        p_ar_id,
        v_old_payment_source,
        p_new_payment_source,
        v_old_note,
        p_new_note,
        p_reason,
        p_user_id
    );
    
    COMMIT;
    SET p_result = 'SUCCESS';
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_get_accounting_report
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_accounting_report`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_get_accounting_report`(
    IN p_start_date DATE,
    IN p_end_date DATE,
    IN p_patient_type VARCHAR(10)
)
BEGIN
    -- ดึงข้อมูลลูกหนี้ยกมา (ก่อนวันที่เริ่มต้น)
    SELECT 
        'FORWARD' as report_section,
        coa.coa_id,
        coa.account_code,
        coa.account_name,
        COALESCE(NULLIF(coa.pttype, ''), ar.pttype) AS pttype,
        (SELECT coa2.pttype_name 
         FROM chart_of_accounts coa2
         WHERE coa2.pttype = COALESCE(NULLIF(coa.pttype, ''), ar.pttype)
           AND coa2.pttype_name <> '' 
         LIMIT 1) AS pttype_name,
        COUNT(ar.ar_id) as record_count,
        SUM(COALESCE(ar.original_ar_amount, ar.ar_amount)) as total_original,
        SUM(COALESCE((
            SELECT SUM(apt.amount)
            FROM ar_payment_transactions apt
            WHERE apt.ar_id = ar.ar_id
                AND DATE(apt.transaction_date) < p_start_date
        ), 0)) as total_paid_before,
        SUM(fn_get_ar_balance_at_date(ar.ar_id, DATE_SUB(p_start_date, INTERVAL 1 DAY))) as forward_amount
    FROM accounts_receivable ar
    INNER JOIN chart_of_accounts coa ON ar.coa_id = coa.coa_id
    WHERE (CASE 
            WHEN p_patient_type = 'IPD' THEN ar.discharge_date
            ELSE ar.service_date
           END) < p_start_date
        AND ar.status IN ('approved', 'adjusted')
        AND ar.submission_status = 'recorded'
        AND coa.patient_type = p_patient_type
        AND fn_get_ar_balance_at_date(ar.ar_id, DATE_SUB(p_start_date, INTERVAL 1 DAY)) > 0
    GROUP BY coa.coa_id, coa.account_code, coa.account_name, 
             COALESCE(NULLIF(coa.pttype, ''), ar.pttype), coa.pttype_name
    
    UNION ALL
    
    -- ดึงข้อมูลในช่วงเวลาที่เลือก
    SELECT 
        'CURRENT' as report_section,
        coa.coa_id,
        coa.account_code,
        coa.account_name,
        COALESCE(NULLIF(coa.pttype, ''), ar.pttype) AS pttype,
        (SELECT coa2.pttype_name 
         FROM chart_of_accounts coa2
         WHERE coa2.pttype = COALESCE(NULLIF(coa.pttype, ''), ar.pttype)
           AND coa2.pttype_name <> '' 
         LIMIT 1) AS pttype_name,
        COUNT(ar.ar_id) as record_count,
        SUM(ar.total_amount) as total_amount,
        SUM(COALESCE(ar.original_ar_amount, ar.ar_amount)) as total_ar,
        SUM(COALESCE((
            SELECT SUM(apt.amount)
            FROM ar_payment_transactions apt
            WHERE apt.ar_id = ar.ar_id
                AND DATE(apt.transaction_date) BETWEEN p_start_date AND p_end_date
        ), 0)) as paid_in_period
    FROM accounts_receivable ar
    INNER JOIN chart_of_accounts coa ON ar.coa_id = coa.coa_id
    WHERE (CASE 
            WHEN p_patient_type = 'IPD' THEN ar.discharge_date
            ELSE ar.service_date
           END) BETWEEN p_start_date AND p_end_date
        AND ar.status IN ('approved', 'adjusted')
        AND ar.submission_status = 'recorded'
        AND coa.patient_type = p_patient_type
    GROUP BY coa.coa_id, coa.account_code, coa.account_name, 
             COALESCE(NULLIF(coa.pttype, ''), ar.pttype), coa.pttype_name
    
    ORDER BY account_code, pttype;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_get_import_stats
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_get_import_stats`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_get_import_stats`(
    IN p_import_id INT
)
BEGIN
    -- Summary
    SELECT 
        'Summary' as section,
        total_records,
        matched_records,
        unmatched_records,
        error_records,
        match_percentage,
        error_percentage
    FROM v_rep_import_summary
    WHERE import_id = p_import_id;
    
    -- Funds Distribution
    SELECT 
        'Funds' as section,
        fund_main,
        COUNT(*) as count,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
    FROM rep_import_details
    WHERE import_id = p_import_id
    GROUP BY fund_main
    ORDER BY count DESC;
    
    -- Error Distribution
    SELECT 
        'Errors' as section,
        error_code,
        COUNT(*) as count
    FROM rep_import_details
    WHERE import_id = p_import_id
      AND error_code IS NOT NULL
    GROUP BY error_code
    ORDER BY count DESC;
    
    -- Match Status
    SELECT 
        'MatchStatus' as section,
        match_status,
        COUNT(*) as count,
        ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) as percentage
    FROM rep_import_details
    WHERE import_id = p_import_id
    GROUP BY match_status;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_log_claim_error
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_log_claim_error`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_log_claim_error`(
    IN p_ar_id INT,
    IN p_error_code VARCHAR(10),
    IN p_error_type ENUM('C','E','W'),
    IN p_insurance_type VARCHAR(10),
    IN p_claim_type ENUM('IP','OP','IPCS','OPCS','IPLGO','OPLGO'),
    IN p_error_message TEXT,
    IN p_detected_at DATETIME
)
BEGIN
    DECLARE v_claim_error_id INT;
    
    -- Insert Error
    INSERT INTO claim_errors (
        ar_id,
        error_code,
        error_type,
        insurance_type,
        claim_type,
        error_message,
        status,
        detected_at
    ) VALUES (
        p_ar_id,
        p_error_code,
        p_error_type,
        p_insurance_type,
        p_claim_type,
        p_error_message,
        'pending',
        p_detected_at
    );
    
    SET v_claim_error_id = LAST_INSERT_ID();
    
    -- บันทึก History
    INSERT INTO error_resolution_history (
        claim_error_id,
        action_type,
        new_status,
        action_note,
        action_at
    ) VALUES (
        v_claim_error_id,
        'detected',
        'pending',
        CONCAT('Error detected: ', p_error_code),
        p_detected_at
    );
    
    SELECT v_claim_error_id as claim_error_id;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_manual_match_statement
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_manual_match_statement`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_manual_match_statement`(
    IN p_statement_detail_id INT,
    IN p_ar_id INT,
    IN p_user_id INT,
    IN p_match_note TEXT,
    OUT p_result VARCHAR(200)
)
BEGIN
    DECLARE v_ar_payment_source VARCHAR(50);
    DECLARE v_approved_amount DECIMAL(15,2);
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SET p_result = 'ERROR: Transaction failed';
    END;
    
    START TRANSACTION;
    
    -- ตรวจสอบว่า AR นี้ payment_source เป็น claim หรือไม่
    SELECT payment_source INTO v_ar_payment_source
    FROM accounts_receivable
    WHERE ar_id = p_ar_id;
    
    IF v_ar_payment_source NOT IN ('claim_rep', 'claim_statement') THEN
        SET p_result = 'ERROR: AR payment source is not claim type';
        ROLLBACK;
    ELSE
        -- ดึงยอด approved_amount จาก statement
        SELECT approved_amount INTO v_approved_amount
        FROM statement_details
        WHERE statement_detail_id = p_statement_detail_id;
        
        -- อัพเดท statement_details
        UPDATE statement_details
        SET 
            ar_id = p_ar_id,
            match_status = 'manual_matched',
            matched_by = p_user_id,
            matched_at = NOW(),
            match_note = p_match_note
        WHERE statement_detail_id = p_statement_detail_id;
        
        -- อัพเดท accounts_receivable
        UPDATE accounts_receivable
        SET 
            statement_approved_amount = COALESCE(statement_approved_amount, 0) + v_approved_amount,
            total_approved_amount = COALESCE(rep_approved_amount, 0) + 
                                   COALESCE(statement_approved_amount, 0) + v_approved_amount,
            statement_matched_at = NOW(),
            updated_by = p_user_id,
            payment_source = 'claim_statement'
        WHERE ar_id = p_ar_id;
        
        COMMIT;
        SET p_result = 'SUCCESS';
    END IF;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_rematch_statement
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_rematch_statement`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_rematch_statement`(
    IN p_statement_import_id INT
)
BEGIN
    DECLARE v_matched INT DEFAULT 0;
    DECLARE v_unmatched INT DEFAULT 0;
    DECLARE done INT DEFAULT FALSE;
    
    -- Variables for statement detail
    DECLARE v_detail_id INT;
    DECLARE v_hn VARCHAR(20);
    DECLARE v_vn VARCHAR(20);
    DECLARE v_an VARCHAR(20);
    DECLARE v_pid VARCHAR(13);
    DECLARE v_approved DECIMAL(15,2);
    DECLARE v_service_date DATE;
    DECLARE v_statement_type VARCHAR(20);
    
    -- Cursor
    DECLARE cur CURSOR FOR 
        SELECT sd.statement_detail_id, sd.hn, sd.vn, sd.an, sd.pid, 
               sd.approved_amount, sd.date_service, sil.statement_type
        FROM statement_details sd
        JOIN statement_import_logs sil ON sd.statement_import_id = sil.statement_import_id
        WHERE sd.statement_import_id = p_statement_import_id
        AND sd.match_status = 'unmatched';
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_detail_id, v_hn, v_vn, v_an, v_pid, 
                       v_approved, v_service_date, v_statement_type;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- พยายามจับคู่
        SET @ar_id = NULL;
        
        -- กำหนด payer_code จาก statement_type
        SET @payer_code = CASE 
            WHEN v_statement_type LIKE 'SSS%' THEN 'SSS'
            WHEN v_statement_type LIKE 'UC%' THEN 'UC'
            WHEN v_statement_type LIKE 'OFC%' THEN 'OFC'
            WHEN v_statement_type LIKE 'LGO%' THEN 'LGO'
            WHEN v_statement_type LIKE 'BKK%' THEN 'BKK'
            ELSE NULL
        END;
        
        -- จับคู่ตาม HN, VN, AN หรือ PID
        SELECT ar.ar_id INTO @ar_id
        FROM accounts_receivable ar
        LEFT JOIN chart_of_accounts coa ON ar.coa_id = coa.coa_id
        WHERE (ar.hn = v_hn OR ar.vn = v_vn OR ar.an = v_an OR ar.cid = v_pid)
        AND (@payer_code IS NULL OR coa.payer_code = @payer_code)
        AND ar.status IN ('pending', 'approved')
        ORDER BY ar.service_date DESC
        LIMIT 1;
        
        IF @ar_id IS NOT NULL THEN
            -- อัพเดทลูกหนี้
            UPDATE accounts_receivable 
            SET paid_amount = paid_amount + v_approved,
                balance = total_amount - (paid_amount + v_approved),
                statement_approved_amount = statement_approved_amount + v_approved,
                total_approved_amount = rep_approved_amount + statement_approved_amount + v_approved,
                statement_matched_at = NOW(),
                status = CASE 
                    WHEN (paid_amount + v_approved) >= total_amount THEN 'paid'
                    ELSE status 
                END
            WHERE ar_id = @ar_id;
            
            -- อัพเดท statement detail
            UPDATE statement_details 
            SET ar_id = @ar_id,
                match_status = 'matched',
                match_note = 'Matched by sp_rematch_statement'
            WHERE statement_detail_id = v_detail_id;
            
            SET v_matched = v_matched + 1;
        ELSE
            SET v_unmatched = v_unmatched + 1;
        END IF;
        
    END LOOP;
    
    CLOSE cur;
    
    -- อัพเดท summary
    UPDATE statement_import_logs 
    SET matched_records = v_matched,
        unmatched_records = v_unmatched
    WHERE statement_import_id = p_statement_import_id;
    
    -- Return result
    SELECT v_matched AS matched, v_unmatched AS unmatched;
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_resolve_claim_error
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_resolve_claim_error`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_resolve_claim_error`(
    IN p_claim_error_id INT,
    IN p_resolved_by INT,
    IN p_resolution_note TEXT,
    IN p_resubmitted TINYINT
)
BEGIN
    DECLARE v_previous_status VARCHAR(20);

    -- Get previous status
    SELECT status
    INTO v_previous_status
    FROM claim_errors
    WHERE claim_error_id = p_claim_error_id;

    -- Update Error
    UPDATE claim_errors
    SET
        status = 'resolved',
        resolved_at = NOW(),
        resolved_by = p_resolved_by,
        resolution_note = p_resolution_note,
        resubmitted = p_resubmitted,
        resubmit_date = CASE
            WHEN p_resubmitted = 1 THEN NOW()
            ELSE NULL
        END
    WHERE claim_error_id = p_claim_error_id;

    -- Log History
    INSERT INTO error_resolution_history (
        claim_error_id,
        action_type,
        action_by,
        previous_status,
        new_status,
        action_note,
        action_at
    ) VALUES (
        p_claim_error_id,
        'resolved',
        p_resolved_by,
        v_previous_status,
        'resolved',
        p_resolution_note,
        NOW()
    );
END
;;
DELIMITER ;

-- ----------------------------
-- Procedure structure for sp_update_error_statistics
-- ----------------------------
DROP PROCEDURE IF EXISTS `sp_update_error_statistics`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER PROCEDURE `sp_update_error_statistics`(
    IN p_period_month CHAR(7)
)
BEGIN
    -- ลบข้อมูลเดิมของเดือนนี้
    DELETE FROM error_statistics WHERE period_month = p_period_month;
    
    -- Insert ข้อมูลใหม่
    INSERT INTO error_statistics (
        insurance_type,
        claim_type,
        period_month,
        total_errors,
        errors_c_type,
        errors_e_type,
        errors_w_type,
        resolved_errors,
        pending_errors,
        in_progress_errors,
        cancelled_errors,
        avg_resolution_days
    )
    SELECT 
        insurance_type,
        claim_type,
        p_period_month,
        COUNT(*) as total_errors,
        SUM(CASE WHEN error_type = 'C' THEN 1 ELSE 0 END) as errors_c_type,
        SUM(CASE WHEN error_type = 'E' THEN 1 ELSE 0 END) as errors_e_type,
        SUM(CASE WHEN error_type = 'W' THEN 1 ELSE 0 END) as errors_w_type,
        SUM(CASE WHEN status = 'resolved' THEN 1 ELSE 0 END) as resolved_errors,
        SUM(CASE WHEN status = 'pending' THEN 1 ELSE 0 END) as pending_errors,
        SUM(CASE WHEN status = 'in_progress' THEN 1 ELSE 0 END) as in_progress_errors,
        SUM(CASE WHEN status = 'cancelled' THEN 1 ELSE 0 END) as cancelled_errors,
        AVG(CASE 
            WHEN status = 'resolved' AND resolved_at IS NOT NULL 
            THEN DATEDIFF(resolved_at, detected_at)
            ELSE NULL 
        END) as avg_resolution_days
    FROM claim_errors
    WHERE DATE_FORMAT(detected_at, '%Y-%m') = p_period_month
    GROUP BY insurance_type, claim_type;
END
;;
DELIMITER ;

-- ----------------------------
-- Function structure for fn_get_ar_balance_at_date
-- ----------------------------
DROP FUNCTION IF EXISTS `fn_get_ar_balance_at_date`;
DELIMITER ;;
CREATE DEFINER=CURRENT_USER FUNCTION `fn_get_ar_balance_at_date`(p_ar_id INT,
    p_date DATE
) RETURNS decimal(15,2)
    READS SQL DATA
    DETERMINISTIC
BEGIN
    DECLARE v_original_amount DECIMAL(15,2);
    DECLARE v_paid_amount DECIMAL(15,2);
    
    -- ดึงยอดต้นฉบับ
    SELECT COALESCE(original_ar_amount, ar_amount) 
    INTO v_original_amount
    FROM accounts_receivable
    WHERE ar_id = p_ar_id;
    
    -- คำนวณยอดที่ชำระ ณ วันที่กำหนด
    SELECT COALESCE(SUM(amount), 0)
    INTO v_paid_amount
    FROM ar_payment_transactions
    WHERE ar_id = p_ar_id
        AND DATE(transaction_date) <= p_date;
    
    RETURN v_original_amount - v_paid_amount;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_ar_payment_source_update`;
DELIMITER ;;
CREATE TRIGGER `trg_ar_payment_source_update` AFTER UPDATE ON `accounts_receivable` FOR EACH ROW BEGIN
    -- บันทึกเฉพาะกรณีที่มีการเปลี่ยน payment_source
    IF OLD.payment_source != NEW.payment_source 
       OR (OLD.payment_source_note IS NULL AND NEW.payment_source_note IS NOT NULL)
       OR (OLD.payment_source_note IS NOT NULL AND NEW.payment_source_note IS NULL)
       OR (OLD.payment_source_note != NEW.payment_source_note) THEN
        
        INSERT INTO `ar_payment_source_history` (
            `ar_id`,
            `old_payment_source`,
            `new_payment_source`,
            `old_note`,
            `new_note`,
            `reason`,
            `changed_by`
        ) VALUES (
            NEW.ar_id,
            OLD.payment_source,
            NEW.payment_source,
            OLD.payment_source_note,
            NEW.payment_source_note,
            'Auto-logged by trigger',
            NEW.updated_by
        );
    END IF;
END
;;
DELIMITER ;
DROP TRIGGER IF EXISTS `trg_after_claim_error_insert`;
DELIMITER ;;
CREATE TRIGGER `trg_after_claim_error_insert` AFTER INSERT ON `claim_errors` FOR EACH ROW BEGIN
    -- อัพเดทสถานะ AR ถ้ามี Error ประเภท C
    IF NEW.error_type = 'C' THEN
        UPDATE accounts_receivable 
        SET submission_status = 'draft'
        WHERE ar_id = NEW.ar_id;
    END IF;
END
;;
DELIMITER ;

