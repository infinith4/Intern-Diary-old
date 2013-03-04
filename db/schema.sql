CREATE TABLE user (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    name VARBINARY(32) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY (name)
);

CREATE TABLE entry (
    id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id BIGINT UNSIGNED NOT NULL,
    title VARBINARY(512) NOT NULL,
    content BLOB,
    result_content BLOB,
    main_content BLOB,
    image VARBINARY(512),
    created_on DATETIME NOT NULL DEFAULT 0,
    updated_on DATETIME NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
);
