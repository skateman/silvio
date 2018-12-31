-- +micrate Up
CREATE TABLE networks (
    id bigint NOT NULL,
    name character varying,
    address character varying,
    netmask character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);

CREATE SEQUENCE networks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

ALTER TABLE ONLY networks ALTER COLUMN id SET DEFAULT nextval('networks_id_seq'::regclass);
ALTER TABLE ONLY networks ADD CONSTRAINT networks_pkey PRIMARY KEY (id);


-- +micrate Down
DROP TABLE "networks";
DROP SEQUENCE "networks_id_seq";
