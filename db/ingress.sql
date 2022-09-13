--
-- PostgreSQL database dump
--

-- Dumped from database version 14.4
-- Dumped by pg_dump version 14.4

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: ingress; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE ingress WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE = 'English_Zambia.1252';


ALTER DATABASE ingress OWNER TO postgres;

\connect ingress

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: setup; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA setup;


ALTER SCHEMA setup OWNER TO postgres;

--
-- Name: uuid_generate_v4(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.uuid_generate_v4() RETURNS uuid
    LANGUAGE c STRICT
    AS '$libdir/uuid-ossp', 'uuid_generate_v4';


ALTER FUNCTION public.uuid_generate_v4() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: incomes; Type: TABLE; Schema: setup; Owner: postgres
--

CREATE TABLE setup.incomes (
    id integer NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    label_id smallint NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    date timestamp without time zone NOT NULL,
    total numeric DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT incomes_created_at_check CHECK ((created_at >= '1900-01-01 00:00:00'::timestamp without time zone)),
    CONSTRAINT incomes_deleted_at_check CHECK ((deleted_at >= '1900-01-01 00:00:00'::timestamp without time zone)),
    CONSTRAINT incomes_description_check CHECK ((length(description) <= 100)),
    CONSTRAINT incomes_total_check CHECK ((total >= (0)::numeric)),
    CONSTRAINT incomes_updated_at_check CHECK ((updated_at >= '1900-01-01 00:00:00'::timestamp without time zone))
);


ALTER TABLE setup.incomes OWNER TO postgres;

--
-- Name: incomes_create(timestamp without time zone, uuid, text, numeric); Type: FUNCTION; Schema: setup; Owner: postgres
--

CREATE FUNCTION setup.incomes_create(p_date timestamp without time zone, p_label_uuid uuid, p_description text, p_total numeric) RETURNS SETOF setup.incomes
    LANGUAGE plpgsql
    AS $$
DECLARE 
v_new_uuid uuid = uuid_generate_v4();  
BEGIN
  -- insert
  INSERT INTO setup.incomes(uuid, date, label_id, description, total)
  SELECT v_new_uuid, p_date, id, p_description, p_total
  FROM setup.labels 
  WHERE uuid = p_label_uuid;
  
  -- return
  RETURN QUERY
  SELECT * FROM setup.incomes WHERE uuid = v_new_uuid; 
END
$$;


ALTER FUNCTION setup.incomes_create(p_date timestamp without time zone, p_label_uuid uuid, p_description text, p_total numeric) OWNER TO postgres;

--
-- Name: labels_get_all(integer, integer, text, text, text); Type: FUNCTION; Schema: setup; Owner: postgres
--

CREATE FUNCTION setup.labels_get_all(p_offset integer, p_limit integer, p_filter text, p_sort_column text, p_sort_direction text DEFAULT 'ASC'::text) RETURNS TABLE(uuid uuid, name text)
    LANGUAGE plpgsql STABLE
    AS $_$
  BEGIN
    IF UPPER(p_sort_direction) IN ('ASC', 'DESC', 'ASCENDING', 'DESCENDING') THEN
      RETURN QUERY EXECUTE format(
        'SELECT l.uuid, l.name
		FROM setup.labels AS l
        WHERE (LOWER(l.name) LIKE LOWER(''%%'' || %1$L || ''%%''))
        ORDER BY l.%4$I %5$s
        LIMIT %2$s OFFSET (%3$s - 1) * %2$s;'
      ,p_filter, p_limit, p_offset, p_sort_column, p_sort_direction);
    ELSE
    RAISE EXCEPTION 'Unexpected value for parameter p_sort_direction. Allowed: ASC, DESC, ASCENDING, DESCENDING. Default: ASC';
    END IF;
  END 
$_$;


ALTER FUNCTION setup.labels_get_all(p_offset integer, p_limit integer, p_filter text, p_sort_column text, p_sort_direction text) OWNER TO postgres;

--
-- Name: labels_get_one_by_uuid(uuid); Type: FUNCTION; Schema: setup; Owner: postgres
--

CREATE FUNCTION setup.labels_get_one_by_uuid(p_uuid uuid) RETURNS TABLE(uuid uuid, name text)
    LANGUAGE sql STABLE
    AS $$
  SELECT l.uuid, l.name
  FROM setup.labels AS l 
  WHERE uuid = p_uuid;
$$;


ALTER FUNCTION setup.labels_get_one_by_uuid(p_uuid uuid) OWNER TO postgres;

--
-- Name: incomes_id_seq; Type: SEQUENCE; Schema: setup; Owner: postgres
--

CREATE SEQUENCE setup.incomes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE setup.incomes_id_seq OWNER TO postgres;

--
-- Name: incomes_id_seq; Type: SEQUENCE OWNED BY; Schema: setup; Owner: postgres
--

ALTER SEQUENCE setup.incomes_id_seq OWNED BY setup.incomes.id;


--
-- Name: label_types; Type: TABLE; Schema: setup; Owner: postgres
--

CREATE TABLE setup.label_types (
    id integer NOT NULL,
    name text NOT NULL,
    CONSTRAINT label_types_id_check CHECK ((id > 0)),
    CONSTRAINT label_types_name_check CHECK ((length(name) <= 80))
);


ALTER TABLE setup.label_types OWNER TO postgres;

--
-- Name: labels; Type: TABLE; Schema: setup; Owner: postgres
--

CREATE TABLE setup.labels (
    id integer NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    name text DEFAULT ''::text NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    label_type_id integer NOT NULL,
    CONSTRAINT labels_created_at_check CHECK ((created_at >= '1900-01-01 00:00:00'::timestamp without time zone)),
    CONSTRAINT labels_deleted_at_check CHECK ((deleted_at >= '1900-01-01 00:00:00'::timestamp without time zone)),
    CONSTRAINT labels_name_check CHECK ((length(name) <= 100)),
    CONSTRAINT labels_updated_at_check CHECK ((updated_at >= '1900-01-01 00:00:00'::timestamp without time zone))
);


ALTER TABLE setup.labels OWNER TO postgres;

--
-- Name: labels_id_seq; Type: SEQUENCE; Schema: setup; Owner: postgres
--

CREATE SEQUENCE setup.labels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE setup.labels_id_seq OWNER TO postgres;

--
-- Name: labels_id_seq; Type: SEQUENCE OWNED BY; Schema: setup; Owner: postgres
--

ALTER SEQUENCE setup.labels_id_seq OWNED BY setup.labels.id;


--
-- Name: outcomes; Type: TABLE; Schema: setup; Owner: postgres
--

CREATE TABLE setup.outcomes (
    id integer NOT NULL,
    uuid uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    label_id smallint NOT NULL,
    description text DEFAULT ''::text NOT NULL,
    date timestamp without time zone NOT NULL,
    total numeric DEFAULT 0 NOT NULL,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone,
    deleted_at timestamp without time zone,
    CONSTRAINT outcomes_created_at_check CHECK ((created_at >= '1900-01-01 00:00:00'::timestamp without time zone)),
    CONSTRAINT outcomes_deleted_at_check CHECK ((deleted_at >= '1900-01-01 00:00:00'::timestamp without time zone)),
    CONSTRAINT outcomes_description_check CHECK ((length(description) <= 100)),
    CONSTRAINT outcomes_total_check CHECK ((total >= (0)::numeric)),
    CONSTRAINT outcomes_updated_at_check CHECK ((updated_at >= '1900-01-01 00:00:00'::timestamp without time zone))
);


ALTER TABLE setup.outcomes OWNER TO postgres;

--
-- Name: outcomes_id_seq; Type: SEQUENCE; Schema: setup; Owner: postgres
--

CREATE SEQUENCE setup.outcomes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE setup.outcomes_id_seq OWNER TO postgres;

--
-- Name: outcomes_id_seq; Type: SEQUENCE OWNED BY; Schema: setup; Owner: postgres
--

ALTER SEQUENCE setup.outcomes_id_seq OWNED BY setup.outcomes.id;


--
-- Name: incomes id; Type: DEFAULT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.incomes ALTER COLUMN id SET DEFAULT nextval('setup.incomes_id_seq'::regclass);


--
-- Name: labels id; Type: DEFAULT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.labels ALTER COLUMN id SET DEFAULT nextval('setup.labels_id_seq'::regclass);


--
-- Name: outcomes id; Type: DEFAULT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.outcomes ALTER COLUMN id SET DEFAULT nextval('setup.outcomes_id_seq'::regclass);


--
-- Data for Name: incomes; Type: TABLE DATA; Schema: setup; Owner: postgres
--

COPY setup.incomes (id, uuid, label_id, description, date, total, created_at, updated_at, deleted_at) FROM stdin;
1	5c7d3c18-e081-4d15-af4c-126ce2ba5205	763	salida	2022-09-08 00:00:00	500.2	2022-09-05 15:40:44.287143	\N	\N
\.


--
-- Data for Name: label_types; Type: TABLE DATA; Schema: setup; Owner: postgres
--

COPY setup.label_types (id, name) FROM stdin;
1	incomes
2	outcomes
\.


--
-- Data for Name: labels; Type: TABLE DATA; Schema: setup; Owner: postgres
--

COPY setup.labels (id, uuid, name, created_at, updated_at, deleted_at, label_type_id) FROM stdin;
542	c394ddca-edad-4ecb-a044-e4ae2150572c	ALQUILER	2022-09-05 14:51:45.381129	\N	\N	1
543	789ae70a-f7c6-4a21-99ff-827de9f35802	FACULTAD	2022-09-05 14:51:45.381129	\N	\N	1
545	52b0ed49-8bb5-46f2-bc58-7515e3eeb58d	DEUDA TARJETA	2022-09-05 14:51:45.381129	\N	\N	1
546	6a93b822-4fff-42fe-bac3-30d9c8a40583	INTERNET	2022-09-05 14:51:45.381129	\N	\N	1
547	df4da814-116c-485b-a9db-6903dc7204cd	COMIDA	2022-09-05 14:51:45.381129	\N	\N	1
549	dbc60dde-711a-45d5-857d-a3b28294a574	VERDULERIA	2022-09-05 14:51:45.381129	\N	\N	1
550	fa74a9e9-7f57-401c-8903-4687c20dae00	SODERIA	2022-09-05 14:51:45.381129	\N	\N	1
551	c1c974f6-8f71-4373-930e-ea6d6044b704	BAZAR	2022-09-05 14:51:45.381129	\N	\N	1
552	3c0a140d-1a15-481d-b0a3-e07ee113b040	SUPERMERCADO	2022-09-05 14:51:45.381129	\N	\N	1
553	bd6e43ba-fdba-4d39-9794-5df00bcad688	TARJETA SUBE	2022-09-05 14:51:45.381129	\N	\N	1
555	374696e3-7977-4ae6-8414-0db279a61e02	CARNICERIA	2022-09-05 14:51:45.381129	\N	\N	1
556	81f4eb84-ebcf-4e7c-b106-12b8ddfd21b8	ALIMENTO GATO	2022-09-05 14:51:45.381129	\N	\N	1
557	9e552fb6-6c9a-421c-bd02-0fa324e2a4b8	FARMACIA	2022-09-05 14:51:45.381129	\N	\N	1
558	a0f2e5b4-7c74-4a9b-bb70-303052cfec93	MUEBLES	2022-09-05 14:51:45.381129	\N	\N	1
563	bd1c2b57-b357-4d5f-9591-88ee362c6d71	HERRAMIENTAS	2022-09-05 14:51:45.381129	\N	\N	1
564	cd0b1bc8-1035-46a4-96cc-5b3177be3dec	FERRETERIA	2022-09-05 14:51:45.381129	\N	\N	1
565	d257c695-e78a-421d-8a4c-58dd67f592db	SALIDA	2022-09-05 14:51:45.381129	\N	\N	1
569	f0d28846-7a54-4600-9b5e-2003b8230885	VIANDA	2022-09-05 14:51:45.381129	\N	\N	1
571	9c688e59-eb74-4f4f-a209-77805c0f7234	INSUMOS	2022-09-05 14:51:45.381129	\N	\N	1
573	2b902487-cb3e-4479-9083-f4cb59281120	NAFTA	2022-09-05 14:51:45.381129	\N	\N	1
575	c36f2076-bcf0-4146-99e9-4bea155e1120	MERCADOLIBRE	2022-09-05 14:51:45.381129	\N	\N	1
580	a96abf17-72cf-462a-a472-bd46db7dbb47	VETERINARIO	2022-09-05 14:51:45.381129	\N	\N	1
581	a1c0f315-8ddc-47e5-9cb0-8c57c6c7379c	PASAJES	2022-09-05 14:51:45.381129	\N	\N	1
582	42082d07-0314-4f9d-9272-8c0ee216a140	VARIOS	2022-09-05 14:51:45.381129	\N	\N	1
583	299f4fba-018a-409c-9bde-72ced9e986a6	DIETETICA	2022-09-05 14:51:45.381129	\N	\N	1
586	964ab485-792b-4d7d-970c-c599b5a51ecc	FIAMBRERIA	2022-09-05 14:51:45.381129	\N	\N	1
588	c086d171-b8b9-49db-9b19-afc3abe9b4dc	PANADERIA	2022-09-05 14:51:45.381129	\N	\N	1
591	587f1ff3-7181-4a10-a1aa-01cf368e0235	DONACION	2022-09-05 14:51:45.381129	\N	\N	1
600	0194284f-0db7-477f-aa79-fb82a291e412	FIAMBRERIA	2022-09-05 14:51:45.381129	\N	\N	1
610	62ea4e84-c719-4929-b956-a68b25df7b20	IMPUESTOS	2022-09-05 14:51:45.381129	\N	\N	1
614	f9b59115-ff8a-4f17-8ad0-ee465f04419e	INSUMOS 	2022-09-05 14:51:45.381129	\N	\N	1
615	53be3985-e285-469e-9a48-8f364caae651	ALCOHOL	2022-09-05 14:51:45.381129	\N	\N	1
619	0c2728de-c084-44ec-8536-68366503e218	GIMNACIO	2022-09-05 14:51:45.381129	\N	\N	1
629	6fdfdc19-d9d1-4866-9c5c-3ed656bec879	SUPERMERADO	2022-09-05 14:51:45.381129	\N	\N	1
633	7ae00f57-06b5-4a87-a7c8-9d5cf61112b5	VERDULERIA	2022-09-05 14:51:45.381129	\N	\N	1
637	cbadb5b7-8e64-448e-9928-577e63986a4b	POLLERIA	2022-09-05 14:51:45.381129	\N	\N	1
645	4d3e77f9-ff55-4874-95b1-7d48e0edca5d	ART. LIMPIEZA	2022-09-05 14:51:45.381129	\N	\N	1
651	baee6234-c68b-4a36-a396-d0f5ffa57f28	PELUQUERIA	2022-09-05 14:51:45.381129	\N	\N	1
659	dfdf42fd-39c8-49e5-88fb-33a6ecfdc09e	ROPA	2022-09-05 14:51:45.381129	\N	\N	1
676	dac9fdeb-9138-4cc3-b3f9-bc1528f342c8	GAS	2022-09-05 14:51:45.381129	\N	\N	1
684	07277390-1cc0-45a8-90ee-68a17ec52b62	SUPER	2022-09-05 14:51:45.381129	\N	\N	1
693	c1570059-e62b-4867-b631-cc0d57af1943	HELADERIA	2022-09-05 14:51:45.381129	\N	\N	1
699	52974596-9573-438f-8aa9-aed872273222	REGALO	2022-09-05 14:51:45.381129	\N	\N	1
708	1d27eb63-b112-433f-a5e3-909c407c1ba6	INSUMOS MOTO	2022-09-05 14:51:45.381129	\N	\N	1
709	dff86bc8-6bd5-4dc2-8d34-e1e2067d61af	TRAMITE	2022-09-05 14:51:45.381129	\N	\N	1
721	066b725d-c423-48e7-97cc-526c85ce4043	MERIENDA	2022-09-05 14:51:45.381129	\N	\N	1
732	7467d052-d818-426b-94da-f25ba134cf9c	MILAS	2022-09-05 14:51:45.381129	\N	\N	1
745	3e4d26d3-4e62-40c5-b2ac-fb76384d117d	INDUMENTARIA	2022-09-05 14:51:45.381129	\N	\N	1
747	cf0e1958-03c4-4a2f-8d02-3d527e4b6e7d	MUEBLES CASA COKI	2022-09-05 14:51:45.381129	\N	\N	1
749	5288243d-d396-4a8e-a8ef-1208bcded3f9	LIMOSNA	2022-09-05 14:51:45.381129	\N	\N	1
758	a84bd783-8810-48de-9438-16654c5917ba	REPARACIONES	2022-09-05 14:51:45.381129	\N	\N	1
761	d729a03d-82ee-4758-a517-71526569ccc1	REMIS	2022-09-05 14:51:45.381129	\N	\N	1
763	5f7be418-43c6-456a-8ef8-bf0341ea70da	ALIMENTO	2022-09-05 14:51:45.381129	\N	\N	1
765	6d4fa006-07a3-4f16-b1b4-b25917c11947	PANADERIA	2022-09-05 14:51:45.381129	\N	\N	1
770	8f748dfc-2106-496d-b8d8-563638c51fd5	FARMACIA 	2022-09-05 14:51:45.381129	\N	\N	1
772	fe09c19a-ef25-45c2-a1c3-739ae81cc6c1	VERDULERIA 	2022-09-05 14:51:45.381129	\N	\N	1
773	791ca202-2049-47c1-bcb7-d789008471a1	CAFETERIA	2022-09-05 14:51:45.381129	\N	\N	1
775	7c5cc56f-2608-42b4-82e9-39bb46fd180f	GYM	2022-09-05 14:51:45.381129	\N	\N	1
786	a0c7637a-90c5-4a7e-90cd-597ce0efd2cc	LAVADERO MOTO	2022-09-05 14:51:45.381129	\N	\N	1
788	84ceeec1-1494-4fbc-b231-a6e9359e2b15	MUEBLE	2022-09-05 14:51:45.381129	\N	\N	1
789	37d46e0b-0693-4ecb-b38e-f16c2adb04d3	KIOSCO	2022-09-05 14:51:45.381129	\N	\N	1
793	6d5cf39d-e518-4f37-8a9d-a529e4e90f4d	TARIFERO	2022-09-05 14:51:45.381129	\N	\N	1
795	ab2ca51f-bbc1-41ef-96aa-caf80e772693	SUBE	2022-09-05 14:51:45.381129	\N	\N	1
824	374ebd3b-1fde-42bb-9199-b6a394fd92e6	ART. DEPTO	2022-09-05 14:51:45.381129	\N	\N	1
866	c29b641f-a330-48f8-aba9-99d48da4a6e4	INSUMO MOTO	2022-09-05 14:51:45.381129	\N	\N	1
886	363eea22-f75d-4773-bd32-5775e7f81891	INSUMOS INFORMATICOS  	2022-09-05 14:51:45.381129	\N	\N	1
890	ef3cc396-abca-4d9f-9bfb-3b4ab691d100	MEDICINA	2022-09-05 14:51:45.381129	\N	\N	1
895	8fca70a2-9194-498c-8838-9675483eaafa	PADEL	2022-09-05 14:51:45.381129	\N	\N	1
896	c47c76a6-1838-4cdf-85dc-7ea97f3d28ab	CENA	2022-09-05 14:51:45.381129	\N	\N	1
900	ed3eb637-f253-4469-9341-9527f80cfc14	OCULISTA	2022-09-05 14:51:45.381129	\N	\N	1
901	143a743c-9fae-4f50-b296-6e2c1c5c2895	OPTICA	2022-09-05 14:51:45.381129	\N	\N	1
914	79f5848f-a5a8-4e1e-bf9f-85becf42f64d	VINOTECA	2022-09-05 14:51:45.381129	\N	\N	1
931	50f0043f-553d-4c9f-b3c5-25f6c8102dd8	COSAS DE DEPORTE	2022-09-05 14:51:45.381129	\N	\N	1
949	c81f5e47-75dd-40d6-b840-52174fb33ec8	COLABORACION PADRES	2022-09-05 14:51:45.381129	\N	\N	1
961	c07f20ac-b8de-4d74-9872-20d6c8f2b4b1	VIAJE	2022-09-05 14:51:45.381129	\N	\N	1
979	a46ec952-ea54-456c-b107-8ebcf4096201	CARNICERIA	2022-09-05 14:51:45.381129	\N	\N	1
998	2f34d65d-2859-4f6c-9fcb-0583732ed578	BEBIDA	2022-09-05 14:51:45.381129	\N	\N	1
1004	cfa9a3a2-2eee-4e73-a0ba-7096832a1a70	YPF	2022-09-05 14:51:45.381129	\N	\N	1
1006	0ac3cf2b-f27d-4b38-9e5c-a929e8d55862	FARNACIA	2022-09-05 14:51:45.381129	\N	\N	1
1013	307f64fa-99f2-4543-887d-b465525667bd	NETFLIX	2022-09-05 14:51:45.381129	\N	\N	1
1014	d13be230-528c-4d60-91f2-2634b9000861	COLABORACION	2022-09-05 14:51:45.381129	\N	\N	1
1022	765b02dc-0eb1-4e33-bb5d-e9f9ca8fe20b	CELULAR	2022-09-05 14:51:45.381129	\N	\N	1
1027	10af66e4-22bb-42a6-9998-c6dafc885a52	ALMUERZO	2022-09-05 14:51:45.381129	\N	\N	1
1032	7aa0ec05-8483-45d1-b706-97be8148a23f	CARNICERIA 	2022-09-05 14:51:45.381129	\N	\N	1
1033	7e1cadc0-6cbd-4318-883f-5373e211110c	COLABORACION CARIDAD	2022-09-05 14:51:45.381129	\N	\N	1
1047	2ad3cd8c-992b-4303-ba90-5fd1f031f548	VIVERO	2022-09-05 14:51:45.381129	\N	\N	1
1050	57dd6f9c-ea05-43af-9af1-5a38b78cf037	SUPERMARCADO	2022-09-05 14:51:45.381129	\N	\N	1
1054	d83ccd25-645a-4e86-a67c-c224f4a09c15	SODA	2022-09-05 14:51:45.381129	\N	\N	1
1062	856a71bb-6c56-4cd8-b085-c2765fcdc0b4	DESAYUNO	2022-09-05 14:51:45.381129	\N	\N	1
\.


--
-- Data for Name: outcomes; Type: TABLE DATA; Schema: setup; Owner: postgres
--

COPY setup.outcomes (id, uuid, label_id, description, date, total, created_at, updated_at, deleted_at) FROM stdin;
\.


--
-- Name: incomes_id_seq; Type: SEQUENCE SET; Schema: setup; Owner: postgres
--

SELECT pg_catalog.setval('setup.incomes_id_seq', 1, true);


--
-- Name: labels_id_seq; Type: SEQUENCE SET; Schema: setup; Owner: postgres
--

SELECT pg_catalog.setval('setup.labels_id_seq', 1, false);


--
-- Name: outcomes_id_seq; Type: SEQUENCE SET; Schema: setup; Owner: postgres
--

SELECT pg_catalog.setval('setup.outcomes_id_seq', 1, false);


--
-- Name: incomes incomes_pkey; Type: CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.incomes
    ADD CONSTRAINT incomes_pkey PRIMARY KEY (id);


--
-- Name: label_types label_types_name_key; Type: CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.label_types
    ADD CONSTRAINT label_types_name_key UNIQUE (name);


--
-- Name: label_types label_types_pkey; Type: CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.label_types
    ADD CONSTRAINT label_types_pkey PRIMARY KEY (id);


--
-- Name: labels labels_pkey; Type: CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.labels
    ADD CONSTRAINT labels_pkey PRIMARY KEY (id);


--
-- Name: outcomes outcomes_pkey; Type: CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.outcomes
    ADD CONSTRAINT outcomes_pkey PRIMARY KEY (id);


--
-- Name: incomes incomes-labels-fk; Type: FK CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.incomes
    ADD CONSTRAINT "incomes-labels-fk" FOREIGN KEY (label_id) REFERENCES setup.labels(id);


--
-- Name: outcomes outcomes-labels-fk; Type: FK CONSTRAINT; Schema: setup; Owner: postgres
--

ALTER TABLE ONLY setup.outcomes
    ADD CONSTRAINT "outcomes-labels-fk" FOREIGN KEY (label_id) REFERENCES setup.labels(id);


--
-- PostgreSQL database dump complete
--

