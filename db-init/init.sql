
-- --- DIESEL FUNCTIONS
CREATE OR REPLACE FUNCTION diesel_manage_updated_at(_tbl regclass) RETURNS VOID AS
$$
BEGIN
    EXECUTE format('CREATE TRIGGER set_updated_at BEFORE UPDATE ON %s
                    FOR EACH ROW EXECUTE PROCEDURE diesel_set_updated_at()', _tbl);
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION diesel_set_updated_at() RETURNS trigger AS
$$
BEGIN
    IF (
        NEW IS DISTINCT FROM OLD AND
        NEW.updated_at IS NOT DISTINCT FROM OLD.updated_at
    ) THEN
        NEW.updated_at := current_timestamp;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
-- ---

CREATE TABLE roles (
  id SERIAL PRIMARY KEY,
  name VARCHAR(10) NOT NULL
);
-- CREATE PUBLICATION roles_pub FOR TABLE roles;

INSERT INTO roles (name) VALUES ('admin'), ('coord'), ('thera'), ('user');

-- ---

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  depends_on INTEGER NOT NULL,
  role_id INTEGER NOT NULL DEFAULT 4,
  user_token VARCHAR(60),
  active BOOLEAN NOT NULL DEFAULT TRUE,
  created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_users_depends_on FOREIGN KEY (depends_on) REFERENCES users(id) ON DELETE CASCADE,
  CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);
CREATE PUBLICATION users_pub FOR TABLE users;

SELECT diesel_manage_updated_at('users');
INSERT INTO users (user_token, depends_on, role_id) VALUES
  ('admin_user',  1, 1),
  ('coord1_user', 1, 2),
  ('coord2_user', 1, 2),
  ('thera1_user', 2, 3),
  ('thera2_user', 2, 3),
  ('thera3_user', 3, 3),
  ('user1_user',  3, default),
  ('user2_user',  4, default),
  ('user3_user',  5, default),
  ('user4_user',  3, default),
  ('user5_user',  4, 4)
  ;

-- ---
