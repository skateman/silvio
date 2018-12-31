-- +micrate Up
CREATE TABLE clients (
    id bigint NOT NULL,
    name character varying,
    token character varying,
    address character varying,
    network_id bigint,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE SEQUENCE clients_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY clients ALTER COLUMN id SET DEFAULT nextval('clients_id_seq'::regclass);
ALTER TABLE ONLY clients ADD CONSTRAINT clients_pkey PRIMARY KEY (id);
CREATE INDEX index_clients_on_network_id ON clients USING btree (network_id);
CREATE UNIQUE INDEX index_clients_on_token ON clients USING btree (token);
ALTER TABLE ONLY clients ADD CONSTRAINT fk_clients_network_id FOREIGN KEY (network_id) REFERENCES networks(id) ON DELETE CASCADE;

-- +micrate Down
DROP TABLE "clients";
DROP SEQUENCE "clients_id_seq";
