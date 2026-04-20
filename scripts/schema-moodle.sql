-- ============================================================
-- Schema unificado aiassignment para Moodle
-- Base de datos : moodle
-- Prefijo       : mdl_
-- Ejecutar      : mysql -u root -p5211 moodle < schema-moodle.sql
-- ============================================================

USE moodle;

-- ------------------------------------------------------------
-- 1. mdl_aiassignment  (problems)
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mdl_aiassignment` (
  `id`            INT(10)      NOT NULL AUTO_INCREMENT,
  `course`        INT(10)      NOT NULL DEFAULT 0        COMMENT 'FK → mdl_course.id',
  `teacher_id`    INT(10)      NOT NULL DEFAULT 0        COMMENT 'FK → mdl_user.id',
  `name`          VARCHAR(255) NOT NULL                  COMMENT 'Problem title',
  `intro`         LONGTEXT                               COMMENT 'Moodle intro HTML',
  `introformat`   SMALLINT(4)  NOT NULL DEFAULT 0,
  `description`   LONGTEXT                               COMMENT 'Extended description',
  `type`          VARCHAR(20)  NOT NULL DEFAULT 'math'   COMMENT 'math | programming',
  `solution`      LONGTEXT     NOT NULL                  COMMENT 'Reference solution',
  `documentation` LONGTEXT,
  `test_cases`    LONGTEXT,
  `grade`         INT(10)      NOT NULL DEFAULT 100,
  `maxattempts`   SMALLINT(6)  NOT NULL DEFAULT 0        COMMENT '0 = unlimited',
  `timecreated`   INT(10)      NOT NULL DEFAULT 0,
  `timemodified`  INT(10)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_course`         (`course`),
  KEY `idx_teacher`        (`teacher_id`),
  KEY `idx_course_teacher` (`course`, `teacher_id`),
  KEY `idx_type`           (`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 2. mdl_aiassignment_submissions
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mdl_aiassignment_submissions` (
  `id`           INT(10)        NOT NULL AUTO_INCREMENT,
  `assignment`   INT(10)        NOT NULL DEFAULT 0  COMMENT 'FK → mdl_aiassignment.id',
  `userid`       INT(10)        NOT NULL DEFAULT 0  COMMENT 'FK → mdl_user.id (student)',
  `answer`       LONGTEXT       NOT NULL,
  `status`       VARCHAR(20)    NOT NULL DEFAULT 'pending' COMMENT 'pending | evaluated | flagged',
  `score`        DECIMAL(5,2)                       COMMENT '0.00 - 100.00',
  `feedback`     LONGTEXT,
  `attempt`      SMALLINT(6)    NOT NULL DEFAULT 1,
  `evaluated_at` INT(10)                            COMMENT 'Unix ts when AI evaluated',
  `timecreated`  INT(10)        NOT NULL DEFAULT 0,
  `timemodified` INT(10)        NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_assignment`        (`assignment`),
  KEY `idx_userid`            (`userid`),
  KEY `idx_assignment_userid` (`assignment`, `userid`),
  KEY `idx_status`            (`status`),
  KEY `idx_evaluated_at`      (`evaluated_at`),
  CONSTRAINT `fk_sub_assignment` FOREIGN KEY (`assignment`) REFERENCES `mdl_aiassignment` (`id`) ON DELETE CASCADE,
  CONSTRAINT `fk_sub_user`       FOREIGN KEY (`userid`)     REFERENCES `mdl_user`          (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- 3. mdl_aiassignment_evaluations
-- ------------------------------------------------------------
CREATE TABLE IF NOT EXISTS `mdl_aiassignment_evaluations` (
  `id`               INT(10)      NOT NULL AUTO_INCREMENT,
  `submission`       INT(10)      NOT NULL DEFAULT 0  COMMENT 'FK → mdl_aiassignment_submissions.id',
  `similarity_score` DECIMAL(5,2)                     COMMENT '0.00 - 100.00 plagiarism',
  `ai_feedback`      LONGTEXT                         COMMENT 'Human-readable AI feedback',
  `ai_analysis`      LONGTEXT                         COMMENT 'Raw AI JSON analysis',
  `timecreated`      INT(10)      NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`),
  KEY `idx_submission`       (`submission`),
  KEY `idx_similarity_score` (`similarity_score`),
  CONSTRAINT `fk_eval_submission` FOREIGN KEY (`submission`) REFERENCES `mdl_aiassignment_submissions` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
