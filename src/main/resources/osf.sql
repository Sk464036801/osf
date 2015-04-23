
create database osf;
use osf;

CREATE TABLE IF NOT EXISTS `osf`.`osf_users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_name` VARCHAR(50) NULL,
  `user_email` VARCHAR(100) NOT NULL,
  `user_pwd` VARCHAR(100) NOT NULL,
  `user_registered_date` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `user_status` INT NULL,
  `user_activationKey` VARCHAR(24) NULL,
  `user_avatar` VARCHAR(100) null,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_posts` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `post_author` INT NOT NULL COMMENT '作者ID',
  `post_ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `post_content` LONGTEXT NOT NULL,
  `post_title` TEXT NOT NULL,
  `post_excerpt` TEXT NULL COMMENT '摘要',
  `post_status` INT NOT NULL DEFAULT 0,
  `comment_status` INT NOT NULL DEFAULT 0,
  `post_pwd` VARCHAR(60) NULL,
  `post_lastts` TIMESTAMP NOT NULL DEFAULT current_timestamp on update CURRENT_TIMESTAMP,
  `comment_count` INT NOT NULL DEFAULT 0,
  `like_count` INT NOT NULL DEFAULT 0,
  `share_count` INT NOT NULL DEFAULT 0,
  `post_url` VARCHAR(45) NULL,
  `post_tags` TEXT NULL,
  `post_album` INT NOT NULL DEFAULT 0,
  `post_cover` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_osf_users_post_author_idx` (`post_author` ASC),
  CONSTRAINT `fk_osf_users_post_author`
    FOREIGN KEY (`post_author`)
    REFERENCES `osf`.`osf_users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_comments` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `comment_object_type` INT NOT NULL COMMENT 'post, album,...',
  `comment_object_id` INT NOT NULL,
  `comment_author` INT NOT NULL,
  `comment_author_email` VARCHAR(100) NOT NULL,
  `comment_ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `comment_content` TEXT NOT NULL,
  `comment_parent` INT NOT NULL DEFAULT 0,
  `comment_parent_email` VARCHAR(100) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_osf_comments_comment_author_idx` (`comment_author` ASC),
  CONSTRAINT `fk_osf_comments_comment_author`
    FOREIGN KEY (`comment_author`)
    REFERENCES `osf`.`osf_users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_events` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `object_type` INT NOT NULL,
  `object_id` INT NOT NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `user_id` INT NOT NULL,
  `user_name` VARCHAR(50) NULL,
  `user_avatar` VARCHAR(100) NULL,
  `like_count` INT NOT NULL,
  `share_count` INT NOT NULL,
  `comment_count` INT NOT NULL,
  `title` TEXT NULL,
  `summary` TEXT NULL,
  `content` TEXT NULL,
  `tags` TEXT NULL,
  `following_user_id` INT NULL,
  `following_user_name` VARCHAR(50) NULL,
  `follower_user_id` INT NULL,
  `follower_user_name` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_followings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `user_name` VARCHAR(50) NULL,
  `following_user_id` INT NOT NULL,
  `following_user_name` VARCHAR(50) NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `osf`.`osf_followers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `user_name` VARCHAR(50) NULL,
  `follower_user_id` INT NOT NULL,
  `follower_user_name` VARCHAR(50) NULL,
  `ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_albums` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `user_id` INT NOT NULL,
  `create_ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  `album_title` TEXT NULL,
  `album_desc` TEXT NULL COMMENT '描述',
  `last_add_ts` DATETIME NOT NULL DEFAULT current_timestamp,
  `photos_count` INT NOT NULL DEFAULT 0,
  `status` INT NOT NULL DEFAULT 0,
  `cover` VARCHAR(45) NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_osf_albums_album_author_idx` (`user_id` ASC),
  CONSTRAINT `fk_osf_albums_album_author`
    FOREIGN KEY (`user_id`)
    REFERENCES `osf`.`osf_users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_photos` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `key` VARCHAR(45) NOT NULL,
  `album_id` INT NOT NULL,
  `ts` TIMESTAMP NULL DEFAULT current_timestamp,
  `desc` VARCHAR(50) NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_tags` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tag` VARCHAR(30) NOT NULL,
  `add_ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


CREATE TABLE IF NOT EXISTS `osf`.`osf_relations` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `object_type` INT NOT NULL,
  `object_id` INT NOT NULL,
  `tag_id` INT NOT NULL,
  `add_ts` TIMESTAMP NOT NULL DEFAULT current_timestamp,
  PRIMARY KEY (`id`),
  INDEX `fk_tag_id_idx` (`tag_id` ASC),
  CONSTRAINT `fk_tag_id`
    FOREIGN KEY (`tag_id`)
    REFERENCES `osf`.`osf_tags` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


