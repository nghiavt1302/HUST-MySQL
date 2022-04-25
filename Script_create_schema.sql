-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema educationdata
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema educationdata
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `educationdata` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `educationdata` ;

-- -----------------------------------------------------
-- Table `educationdata`.`category`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`category` (
  `id` INT NOT NULL,
  `name` VARCHAR(300) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `category` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`language`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`language` (
  `id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `language` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`level`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`level` (
  `id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `level` (`name` ASC) VISIBLE)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`course`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`course` (
  `id` INT NOT NULL,
  `lessons` INT NOT NULL,
  `description` VARCHAR(300) NOT NULL,
  `term_by_months` INT NOT NULL,
  `language_id` INT NOT NULL,
  `level_id` INT NOT NULL,
  `category_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `course_category_idx` (`category_id` ASC) VISIBLE,
  INDEX `course_language_idx` (`language_id` ASC) VISIBLE,
  INDEX `course_level_idx` (`level_id` ASC) VISIBLE,
  INDEX `course_details` (`category_id` ASC, `language_id` ASC, `level_id` ASC) VISIBLE,
  CONSTRAINT `course_category`
    FOREIGN KEY (`category_id`)
    REFERENCES `educationdata`.`category` (`id`),
  CONSTRAINT `course_language`
    FOREIGN KEY (`language_id`)
    REFERENCES `educationdata`.`language` (`id`),
  CONSTRAINT `course_level`
    FOREIGN KEY (`level_id`)
    REFERENCES `educationdata`.`level` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`teacher`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`teacher` (
  `id` INT NOT NULL,
  `description` VARCHAR(300) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`class`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`class` (
  `id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  `start_date` DATE NOT NULL,
  `price` INT NOT NULL,
  `teacher_id` INT NOT NULL,
  `course_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `class_course` (`course_id` ASC) VISIBLE,
  INDEX `group_teacher` (`teacher_id` ASC) VISIBLE,
  CONSTRAINT `class_course`
    FOREIGN KEY (`course_id`)
    REFERENCES `educationdata`.`course` (`id`),
  CONSTRAINT `group_teacher`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `educationdata`.`teacher` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`student` (
  `id` INT NOT NULL,
  `state` VARCHAR(30) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `email` VARCHAR(50) NOT NULL,
  `phone` VARCHAR(15) NOT NULL,
  `rank` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`class_student`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`class_student` (
  `id` INT NOT NULL,
  `class_id` INT NOT NULL,
  `student_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `group_student_group` (`class_id` ASC) VISIBLE,
  INDEX `group_student_student` (`student_id` ASC) VISIBLE,
  CONSTRAINT `group_student_group`
    FOREIGN KEY (`class_id`)
    REFERENCES `educationdata`.`class` (`id`),
  CONSTRAINT `group_student_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `educationdata`.`student` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`weekday`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`weekday` (
  `id` INT NOT NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`class_weekday`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`class_weekday` (
  `class_id` INT NOT NULL,
  `weekday_id` INT NOT NULL,
  `hours` VARCHAR(50) NOT NULL,
  PRIMARY KEY (`class_id`, `weekday_id`),
  INDEX `group_day_day` (`weekday_id` ASC) VISIBLE,
  CONSTRAINT `group_day_day`
    FOREIGN KEY (`weekday_id`)
    REFERENCES `educationdata`.`weekday` (`id`),
  CONSTRAINT `group_day_group`
    FOREIGN KEY (`class_id`)
    REFERENCES `educationdata`.`class` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`student_account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`student_account` (
  `id` INT NOT NULL,
  `student_id` INT NOT NULL,
  `is_active` BIT(1) NOT NULL,
  `login` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `student_user_account_student` (`student_id` ASC) VISIBLE,
  CONSTRAINT `student_user_account_student`
    FOREIGN KEY (`student_id`)
    REFERENCES `educationdata`.`student` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `educationdata`.`teacher_account`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `educationdata`.`teacher_account` (
  `id` INT NOT NULL,
  `teacher_id` INT NOT NULL,
  `is_active` BIT(1) NOT NULL,
  `login` VARCHAR(100) NOT NULL,
  `password` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `teacher_user_account_teacher` (`teacher_id` ASC) VISIBLE,
  CONSTRAINT `teacher_user_account_teacher`
    FOREIGN KEY (`teacher_id`)
    REFERENCES `educationdata`.`teacher` (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
