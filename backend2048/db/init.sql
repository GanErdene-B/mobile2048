CREATE EXTENSION IF NOT EXISTS "pgcrypto";

CREATE TABLE users (
  user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  username VARCHAR(100),
  device_id VARCHAR(255),
  created_at TIMESTAMP DEFAULT now()
);
