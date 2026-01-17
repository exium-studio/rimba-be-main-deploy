--
-- PostgreSQL database dump
--

\restrict ccTjMF15zOjQb8yUnuLJFtjUvjnIGPq38WOlpBxKlwNb9uX06ilxQ4sAflemHq6

-- Dumped from database version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.11 (Ubuntu 16.11-0ubuntu0.24.04.1)

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
-- Name: citext; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;


--
-- Name: EXTENSION citext; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';


--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: monev_contract_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.monev_contract_type AS ENUM (
    'Swakelola 1',
    'Swakelola 2',
    'Swakelola 3',
    'Kontraktual'
);


ALTER TYPE public.monev_contract_type OWNER TO postgres;

--
-- Name: topic_type_enum; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.topic_type_enum AS ENUM (
    'Pengetahuan',
    'Pelatihan'
);


ALTER TYPE public.topic_type_enum OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: activity_logs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.activity_logs (
    id bigint NOT NULL,
    user_id bigint,
    module text NOT NULL,
    key text NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT activity_logs_key_check CHECK ((key = ANY (ARRAY['create'::text, 'update'::text, 'delete'::text, 'restore'::text]))),
    CONSTRAINT activity_logs_module_check CHECK ((module = ANY (ARRAY['profile'::text, 'kmis'::text, 'cms'::text, 'monev'::text, 'master_data'::text])))
);


ALTER TABLE public.activity_logs OWNER TO postgres;

--
-- Name: COLUMN activity_logs.key; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.activity_logs.key IS 'create | update | delete | restore';


--
-- Name: activity_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.activity_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.activity_logs_id_seq OWNER TO postgres;

--
-- Name: activity_logs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.activity_logs_id_seq OWNED BY public.activity_logs.id;


--
-- Name: cms_animal_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_animal_categories (
    id bigint NOT NULL,
    name jsonb NOT NULL,
    description jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_animal_categories OWNER TO postgres;

--
-- Name: cms_animal_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_animal_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_animal_categories_id_seq OWNER TO postgres;

--
-- Name: cms_animal_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_animal_categories_id_seq OWNED BY public.cms_animal_categories.id;


--
-- Name: cms_animal_composition; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_animal_composition (
    id bigint NOT NULL,
    cms_animal_category_id bigint NOT NULL,
    species_image_ids jsonb,
    name jsonb NOT NULL,
    description jsonb,
    total integer NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT cms_animal_composition_total_check CHECK ((total >= 0))
);


ALTER TABLE public.cms_animal_composition OWNER TO postgres;

--
-- Name: cms_animal_composition_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_animal_composition_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_animal_composition_id_seq OWNER TO postgres;

--
-- Name: cms_animal_composition_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_animal_composition_id_seq OWNED BY public.cms_animal_composition.id;


--
-- Name: cms_contents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_contents (
    id bigint NOT NULL,
    content_file_ids jsonb,
    type character varying(40) NOT NULL,
    content text,
    "order" integer DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT cms_contents_order_check CHECK (("order" >= 0))
);


ALTER TABLE public.cms_contents OWNER TO postgres;

--
-- Name: cms_contents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_contents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_contents_id_seq OWNER TO postgres;

--
-- Name: cms_contents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_contents_id_seq OWNED BY public.cms_contents.id;


--
-- Name: cms_events; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_events (
    id bigint NOT NULL,
    cms_event_category_id bigint,
    thumbnail_ids jsonb,
    title jsonb NOT NULL,
    description jsonb,
    event_content jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_events OWNER TO postgres;

--
-- Name: cms_events_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_events_categories (
    id bigint NOT NULL,
    name jsonb NOT NULL,
    description jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_events_categories OWNER TO postgres;

--
-- Name: cms_events_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_events_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_events_categories_id_seq OWNER TO postgres;

--
-- Name: cms_events_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_events_categories_id_seq OWNED BY public.cms_events_categories.id;


--
-- Name: cms_events_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_events_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_events_id_seq OWNER TO postgres;

--
-- Name: cms_events_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_events_id_seq OWNED BY public.cms_events.id;


--
-- Name: cms_faqs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_faqs (
    id bigint NOT NULL,
    question jsonb DEFAULT '[]'::jsonb NOT NULL,
    answer jsonb DEFAULT '[]'::jsonb NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_faqs OWNER TO postgres;

--
-- Name: cms_faqs_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_faqs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_faqs_id_seq OWNER TO postgres;

--
-- Name: cms_faqs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_faqs_id_seq OWNED BY public.cms_faqs.id;


--
-- Name: cms_legal_docs_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_legal_docs_categories (
    id bigint NOT NULL,
    name jsonb NOT NULL,
    description jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_legal_docs_categories OWNER TO postgres;

--
-- Name: cms_legal_docs_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_legal_docs_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_legal_docs_categories_id_seq OWNER TO postgres;

--
-- Name: cms_legal_docs_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_legal_docs_categories_id_seq OWNED BY public.cms_legal_docs_categories.id;


--
-- Name: cms_legal_documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_legal_documents (
    id bigint NOT NULL,
    document_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    title jsonb NOT NULL,
    description jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    cms_legal_docs_categories_id bigint
);


ALTER TABLE public.cms_legal_documents OWNER TO postgres;

--
-- Name: cms_legal_documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_legal_documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_legal_documents_id_seq OWNER TO postgres;

--
-- Name: cms_legal_documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_legal_documents_id_seq OWNED BY public.cms_legal_documents.id;


--
-- Name: cms_news; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_news (
    id bigint NOT NULL,
    cms_news_category_id bigint,
    thumbnail_ids jsonb,
    title jsonb NOT NULL,
    slug jsonb NOT NULL,
    description jsonb,
    news_content jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_news OWNER TO postgres;

--
-- Name: cms_news_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cms_news_categories (
    id bigint NOT NULL,
    name jsonb NOT NULL,
    description jsonb,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.cms_news_categories OWNER TO postgres;

--
-- Name: cms_news_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_news_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_news_categories_id_seq OWNER TO postgres;

--
-- Name: cms_news_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_news_categories_id_seq OWNED BY public.cms_news_categories.id;


--
-- Name: cms_news_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cms_news_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cms_news_id_seq OWNER TO postgres;

--
-- Name: cms_news_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cms_news_id_seq OWNED BY public.cms_news.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id bigint NOT NULL,
    uploaded_by bigint NOT NULL,
    verified_by bigint,
    file_id character varying(255) NOT NULL,
    file_name character varying(255) NOT NULL,
    file_path character varying(255) NOT NULL,
    file_url text NOT NULL,
    file_mime_type character varying(255) NOT NULL,
    file_size character varying(255) NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: kmis_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_categories (
    id bigint NOT NULL,
    category_cover_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    title character varying(150) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kmis_categories OWNER TO postgres;

--
-- Name: kmis_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_categories_id_seq OWNER TO postgres;

--
-- Name: kmis_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_categories_id_seq OWNED BY public.kmis_categories.id;


--
-- Name: kmis_learning_attempts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_learning_attempts (
    id bigint NOT NULL,
    attempt_by bigint NOT NULL,
    kmis_topic_id bigint NOT NULL,
    quiz_attempt_status smallint DEFAULT 1 NOT NULL,
    quiz_assessment_status boolean DEFAULT false NOT NULL,
    total_material integer DEFAULT 0 NOT NULL,
    completed_quiz integer DEFAULT 0,
    quiz_started timestamp without time zone,
    quiz_finished timestamp without time zone,
    quiz_duration integer,
    questions_answered integer,
    correct_count integer DEFAULT 0 NOT NULL,
    wrong_count integer DEFAULT 0 NOT NULL,
    empty_count integer DEFAULT 0 NOT NULL,
    score_total double precision DEFAULT 0 NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    feedback integer,
    certificate_ids jsonb DEFAULT '[]'::jsonb,
    completed_material_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    learning_started timestamp without time zone,
    feedback_comment text,
    CONSTRAINT kmis_learning_attempts_completed_quiz_check CHECK ((completed_quiz >= 0)),
    CONSTRAINT kmis_learning_attempts_correct_count_check CHECK ((correct_count >= 0)),
    CONSTRAINT kmis_learning_attempts_empty_count_check CHECK ((empty_count >= 0)),
    CONSTRAINT kmis_learning_attempts_feedback_check CHECK ((feedback = ANY (ARRAY[0, 1, 2, 3, 4, 5]))),
    CONSTRAINT kmis_learning_attempts_questions_answered_check CHECK (((questions_answered IS NULL) OR (questions_answered >= 0))),
    CONSTRAINT kmis_learning_attempts_quiz_attempt_status_check CHECK ((quiz_attempt_status = ANY (ARRAY[1, 2, 3]))),
    CONSTRAINT kmis_learning_attempts_quiz_duration_check CHECK (((quiz_duration IS NULL) OR (quiz_duration >= 0))),
    CONSTRAINT kmis_learning_attempts_score_total_check CHECK ((score_total >= (0)::double precision)),
    CONSTRAINT kmis_learning_attempts_total_material_check CHECK ((total_material >= 0)),
    CONSTRAINT kmis_learning_attempts_wrong_count_check CHECK ((wrong_count >= 0))
);


ALTER TABLE public.kmis_learning_attempts OWNER TO postgres;

--
-- Name: kmis_learning_attempts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_learning_attempts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_learning_attempts_id_seq OWNER TO postgres;

--
-- Name: kmis_learning_attempts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_learning_attempts_id_seq OWNED BY public.kmis_learning_attempts.id;


--
-- Name: kmis_materials; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_materials (
    id bigint NOT NULL,
    kmis_topic_id bigint,
    created_by bigint NOT NULL,
    uploaded_by bigint NOT NULL,
    materials_file_ids jsonb,
    materials_cover_ids jsonb,
    title character varying(180) NOT NULL,
    material_types character varying(20) NOT NULL,
    material_data text,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kmis_materials OWNER TO postgres;

--
-- Name: kmis_materials_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_materials_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_materials_id_seq OWNER TO postgres;

--
-- Name: kmis_materials_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_materials_id_seq OWNED BY public.kmis_materials.id;


--
-- Name: kmis_quiz; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_quiz (
    id bigint NOT NULL,
    kmis_topic_id bigint NOT NULL,
    question text NOT NULL,
    answer_a text,
    answer_b text,
    answer_c text,
    answer_d text,
    correct_option character(1) NOT NULL,
    explanation text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    created_by bigint NOT NULL,
    CONSTRAINT kmis_quiz_correct_option_check CHECK ((correct_option = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])))
);


ALTER TABLE public.kmis_quiz OWNER TO postgres;

--
-- Name: kmis_quiz_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_quiz_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_quiz_id_seq OWNER TO postgres;

--
-- Name: kmis_quiz_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_quiz_id_seq OWNED BY public.kmis_quiz.id;


--
-- Name: kmis_quiz_responses; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_quiz_responses (
    id bigint NOT NULL,
    kmis_learning_attempt_id bigint NOT NULL,
    kmis_quiz_id bigint NOT NULL,
    is_marker boolean DEFAULT false NOT NULL,
    is_correct boolean DEFAULT false NOT NULL,
    answered_at timestamp without time zone DEFAULT now() NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    selected_option character(1)
);


ALTER TABLE public.kmis_quiz_responses OWNER TO postgres;

--
-- Name: kmis_quiz_responses_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_quiz_responses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_quiz_responses_id_seq OWNER TO postgres;

--
-- Name: kmis_quiz_responses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_quiz_responses_id_seq OWNED BY public.kmis_quiz_responses.id;


--
-- Name: kmis_topic_views; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_topic_views (
    id bigint NOT NULL,
    kmis_topic_id bigint NOT NULL,
    viewer_ip inet NOT NULL,
    viewer_region text,
    view_date date DEFAULT CURRENT_DATE NOT NULL,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.kmis_topic_views OWNER TO postgres;

--
-- Name: kmis_topic_views_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_topic_views_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_topic_views_id_seq OWNER TO postgres;

--
-- Name: kmis_topic_views_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_topic_views_id_seq OWNED BY public.kmis_topic_views.id;


--
-- Name: kmis_topics; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kmis_topics (
    id bigint NOT NULL,
    kmis_categories_id bigint NOT NULL,
    topic_cover_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    title character varying(150) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    total_quiz integer DEFAULT 0,
    quiz_duration integer,
    material_order_ids jsonb DEFAULT '[]'::jsonb,
    total_views integer,
    topic_type public.topic_type_enum DEFAULT 'Pelatihan'::public.topic_type_enum NOT NULL,
    user_pic jsonb DEFAULT '[]'::jsonb,
    CONSTRAINT kmis_topics_total_quiz_check CHECK (((total_quiz IS NULL) OR (total_quiz >= 0))),
    CONSTRAINT kmis_topics_total_views_check CHECK ((total_views >= 0))
);


ALTER TABLE public.kmis_topics OWNER TO postgres;

--
-- Name: kmis_topics_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.kmis_topics_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.kmis_topics_id_seq OWNER TO postgres;

--
-- Name: kmis_topics_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.kmis_topics_id_seq OWNED BY public.kmis_topics.id;


--
-- Name: modules; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.modules (
    id bigint NOT NULL,
    name character varying(120) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.modules OWNER TO postgres;

--
-- Name: modules_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.modules_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.modules_id_seq OWNER TO postgres;

--
-- Name: modules_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.modules_id_seq OWNED BY public.modules.id;


--
-- Name: monev_activity_calendar; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_activity_calendar (
    id bigint NOT NULL,
    created_by bigint NOT NULL,
    monev_activity_category_id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    location character varying(200) NOT NULL,
    started_date date NOT NULL,
    finished_date date,
    started_time character varying(10),
    finished_time character varying(10),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monev_activity_calendar OWNER TO postgres;

--
-- Name: monev_activity_calendar_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_activity_calendar_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_activity_calendar_id_seq OWNER TO postgres;

--
-- Name: monev_activity_calendar_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_activity_calendar_id_seq OWNED BY public.monev_activity_calendar.id;


--
-- Name: monev_activity_categories; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_activity_categories (
    id bigint NOT NULL,
    title character varying(150) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monev_activity_categories OWNER TO postgres;

--
-- Name: monev_activity_categories_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_activity_categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_activity_categories_id_seq OWNER TO postgres;

--
-- Name: monev_activity_categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_activity_categories_id_seq OWNED BY public.monev_activity_categories.id;


--
-- Name: monev_activity_packages; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_activity_packages (
    id bigint NOT NULL,
    created_by bigint NOT NULL,
    edited_by bigint,
    monev_pic_division_id bigint,
    contract_type public.monev_contract_type NOT NULL,
    mak character varying(50) NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    started_month integer NOT NULL,
    finished_month integer,
    unit_output character varying(80) NOT NULL,
    code_output character varying(80) NOT NULL,
    volume character varying(50) NOT NULL,
    pagu integer NOT NULL,
    partner character varying(150),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    started_year integer NOT NULL,
    finished_year integer NOT NULL,
    CONSTRAINT monev_activity_packages_pagu_check CHECK ((pagu >= 0))
);


ALTER TABLE public.monev_activity_packages OWNER TO postgres;

--
-- Name: monev_activity_packages_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_activity_packages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_activity_packages_id_seq OWNER TO postgres;

--
-- Name: monev_activity_packages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_activity_packages_id_seq OWNED BY public.monev_activity_packages.id;


--
-- Name: monev_dashboards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_dashboards (
    id bigint NOT NULL,
    framework_file_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    plan_file_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    description text,
    networth_hibah bigint,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    CONSTRAINT monev_dashboards_nonneg CHECK (((networth_hibah IS NULL) OR (networth_hibah >= 0)))
);


ALTER TABLE public.monev_dashboards OWNER TO postgres;

--
-- Name: monev_dashboards_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_dashboards_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_dashboards_id_seq OWNER TO postgres;

--
-- Name: monev_dashboards_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_dashboards_id_seq OWNED BY public.monev_dashboards.id;


--
-- Name: monev_monthly_realization_pending_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_monthly_realization_pending_updates (
    id bigint NOT NULL,
    monev_monthly_realization_id bigint NOT NULL,
    monev_activity_packages_id bigint NOT NULL,
    evidence_file_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    month smallint NOT NULL,
    budget_realization jsonb DEFAULT '[]'::jsonb NOT NULL,
    progress integer,
    description text,
    problem character varying(200),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    edited_by bigint,
    year integer NOT NULL
);


ALTER TABLE public.monev_monthly_realization_pending_updates OWNER TO postgres;

--
-- Name: monev_monthly_realization_pending_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_monthly_realization_pending_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_monthly_realization_pending_updates_id_seq OWNER TO postgres;

--
-- Name: monev_monthly_realization_pending_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_monthly_realization_pending_updates_id_seq OWNED BY public.monev_monthly_realization_pending_updates.id;


--
-- Name: monev_monthly_realizations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_monthly_realizations (
    id bigint NOT NULL,
    monev_activity_packages_id bigint NOT NULL,
    evidence_file_ids jsonb DEFAULT '[]'::jsonb,
    month smallint NOT NULL,
    budget_realization jsonb DEFAULT '[]'::jsonb,
    progress integer,
    description text,
    problem character varying(200),
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    validation_status integer,
    rejection_message text,
    validate_at timestamp without time zone,
    validate_by bigint,
    edited_by bigint,
    year integer NOT NULL
);


ALTER TABLE public.monev_monthly_realizations OWNER TO postgres;

--
-- Name: monev_monthly_realizations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_monthly_realizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_monthly_realizations_id_seq OWNER TO postgres;

--
-- Name: monev_monthly_realizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_monthly_realizations_id_seq OWNED BY public.monev_monthly_realizations.id;


--
-- Name: monev_pic_divisions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_pic_divisions (
    id bigint NOT NULL,
    user_pic jsonb DEFAULT '[]'::jsonb,
    title character varying(150) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monev_pic_divisions OWNER TO postgres;

--
-- Name: monev_pic_divisions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_pic_divisions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_pic_divisions_id_seq OWNER TO postgres;

--
-- Name: monev_pic_divisions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_pic_divisions_id_seq OWNED BY public.monev_pic_divisions.id;


--
-- Name: monev_share_reports; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_share_reports (
    id bigint NOT NULL,
    created_by bigint NOT NULL,
    report_file_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    name character varying(180) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.monev_share_reports OWNER TO postgres;

--
-- Name: monev_share_reports_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_share_reports_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_share_reports_id_seq OWNER TO postgres;

--
-- Name: monev_share_reports_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_share_reports_id_seq OWNED BY public.monev_share_reports.id;


--
-- Name: monev_target_pending_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_target_pending_updates (
    id bigint NOT NULL,
    monev_target_id bigint NOT NULL,
    monev_activity_packages_id bigint NOT NULL,
    month smallint,
    budget_target bigint,
    physical_target double precision,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    edited_by bigint,
    year integer NOT NULL,
    CONSTRAINT monev_target_pending_updates_budget_target_check CHECK (((budget_target IS NULL) OR (budget_target >= 0))),
    CONSTRAINT monev_target_pending_updates_physical_target_check CHECK (((physical_target IS NULL) OR (physical_target >= (0)::double precision))),
    CONSTRAINT monev_tpu_budget_target_nonneg CHECK (((budget_target IS NULL) OR (budget_target >= 0)))
);


ALTER TABLE public.monev_target_pending_updates OWNER TO postgres;

--
-- Name: monev_target_pending_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_target_pending_updates_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_target_pending_updates_id_seq OWNER TO postgres;

--
-- Name: monev_target_pending_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_target_pending_updates_id_seq OWNED BY public.monev_target_pending_updates.id;


--
-- Name: monev_targets; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.monev_targets (
    id bigint NOT NULL,
    monev_activity_packages_id bigint NOT NULL,
    month smallint NOT NULL,
    budget_target bigint,
    physical_target double precision,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    validation_status integer,
    rejection_message text,
    validate_at timestamp without time zone,
    validate_by bigint,
    edited_by bigint,
    year integer NOT NULL,
    CONSTRAINT monev_targets_budget_target_check CHECK (((budget_target IS NULL) OR (budget_target >= 0))),
    CONSTRAINT monev_targets_budget_target_nonneg CHECK (((budget_target IS NULL) OR (budget_target >= 0))),
    CONSTRAINT monev_targets_month_chk CHECK (((month >= 0) AND (month <= 11))),
    CONSTRAINT monev_targets_physical_target_check CHECK (((physical_target IS NULL) OR (physical_target >= (0)::double precision)))
);


ALTER TABLE public.monev_targets OWNER TO postgres;

--
-- Name: monev_targets_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.monev_targets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.monev_targets_id_seq OWNER TO postgres;

--
-- Name: monev_targets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.monev_targets_id_seq OWNED BY public.monev_targets.id;


--
-- Name: permissions; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.permissions (
    id bigint NOT NULL,
    module_id bigint NOT NULL,
    key text NOT NULL,
    name character varying(40) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.permissions OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.permissions_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.permissions_id_seq OWNER TO postgres;

--
-- Name: permissions_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.permissions_id_seq OWNED BY public.permissions.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id bigint NOT NULL,
    name character varying(255) NOT NULL,
    description text,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    updated_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    permission_ids jsonb DEFAULT '[]'::jsonb
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    role_id bigint NOT NULL,
    photo_profile_ids jsonb DEFAULT '[]'::jsonb NOT NULL,
    name character varying(150) NOT NULL,
    email public.citext NOT NULL,
    password text NOT NULL,
    phone_number character varying(30),
    profession character varying(100),
    gender smallint,
    birth_date date,
    address text,
    account_status smallint DEFAULT 1 NOT NULL,
    register_at timestamp without time zone DEFAULT now(),
    deactivate_at timestamp without time zone,
    last_login timestamp without time zone,
    deleted_at timestamp without time zone,
    created_at timestamp without time zone DEFAULT now() NOT NULL,
    updated_at timestamp without time zone DEFAULT now() NOT NULL,
    last_change_password timestamp without time zone,
    telegram_id text,
    CONSTRAINT users_account_status_check CHECK ((account_status = ANY (ARRAY[1, 2, 3]))),
    CONSTRAINT users_gender_check CHECK ((gender = ANY (ARRAY[0, 1]))),
    CONSTRAINT users_password_check CHECK ((char_length(password) >= 60))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: COLUMN users.account_status; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON COLUMN public.users.account_status IS '1=Not Activated, 2=Active, 3=Inactive';


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: activity_logs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs ALTER COLUMN id SET DEFAULT nextval('public.activity_logs_id_seq'::regclass);


--
-- Name: cms_animal_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_animal_categories ALTER COLUMN id SET DEFAULT nextval('public.cms_animal_categories_id_seq'::regclass);


--
-- Name: cms_animal_composition id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_animal_composition ALTER COLUMN id SET DEFAULT nextval('public.cms_animal_composition_id_seq'::regclass);


--
-- Name: cms_contents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_contents ALTER COLUMN id SET DEFAULT nextval('public.cms_contents_id_seq'::regclass);


--
-- Name: cms_events id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_events ALTER COLUMN id SET DEFAULT nextval('public.cms_events_id_seq'::regclass);


--
-- Name: cms_events_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_events_categories ALTER COLUMN id SET DEFAULT nextval('public.cms_events_categories_id_seq'::regclass);


--
-- Name: cms_faqs id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_faqs ALTER COLUMN id SET DEFAULT nextval('public.cms_faqs_id_seq'::regclass);


--
-- Name: cms_legal_docs_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_legal_docs_categories ALTER COLUMN id SET DEFAULT nextval('public.cms_legal_docs_categories_id_seq'::regclass);


--
-- Name: cms_legal_documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_legal_documents ALTER COLUMN id SET DEFAULT nextval('public.cms_legal_documents_id_seq'::regclass);


--
-- Name: cms_news id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_news ALTER COLUMN id SET DEFAULT nextval('public.cms_news_id_seq'::regclass);


--
-- Name: cms_news_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_news_categories ALTER COLUMN id SET DEFAULT nextval('public.cms_news_categories_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: kmis_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_categories ALTER COLUMN id SET DEFAULT nextval('public.kmis_categories_id_seq'::regclass);


--
-- Name: kmis_learning_attempts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_learning_attempts ALTER COLUMN id SET DEFAULT nextval('public.kmis_learning_attempts_id_seq'::regclass);


--
-- Name: kmis_materials id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_materials ALTER COLUMN id SET DEFAULT nextval('public.kmis_materials_id_seq'::regclass);


--
-- Name: kmis_quiz id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz ALTER COLUMN id SET DEFAULT nextval('public.kmis_quiz_id_seq'::regclass);


--
-- Name: kmis_quiz_responses id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz_responses ALTER COLUMN id SET DEFAULT nextval('public.kmis_quiz_responses_id_seq'::regclass);


--
-- Name: kmis_topic_views id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topic_views ALTER COLUMN id SET DEFAULT nextval('public.kmis_topic_views_id_seq'::regclass);


--
-- Name: kmis_topics id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topics ALTER COLUMN id SET DEFAULT nextval('public.kmis_topics_id_seq'::regclass);


--
-- Name: modules id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules ALTER COLUMN id SET DEFAULT nextval('public.modules_id_seq'::regclass);


--
-- Name: monev_activity_calendar id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_calendar ALTER COLUMN id SET DEFAULT nextval('public.monev_activity_calendar_id_seq'::regclass);


--
-- Name: monev_activity_categories id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_categories ALTER COLUMN id SET DEFAULT nextval('public.monev_activity_categories_id_seq'::regclass);


--
-- Name: monev_activity_packages id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_packages ALTER COLUMN id SET DEFAULT nextval('public.monev_activity_packages_id_seq'::regclass);


--
-- Name: monev_dashboards id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_dashboards ALTER COLUMN id SET DEFAULT nextval('public.monev_dashboards_id_seq'::regclass);


--
-- Name: monev_monthly_realization_pending_updates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realization_pending_updates ALTER COLUMN id SET DEFAULT nextval('public.monev_monthly_realization_pending_updates_id_seq'::regclass);


--
-- Name: monev_monthly_realizations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realizations ALTER COLUMN id SET DEFAULT nextval('public.monev_monthly_realizations_id_seq'::regclass);


--
-- Name: monev_pic_divisions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_pic_divisions ALTER COLUMN id SET DEFAULT nextval('public.monev_pic_divisions_id_seq'::regclass);


--
-- Name: monev_share_reports id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_share_reports ALTER COLUMN id SET DEFAULT nextval('public.monev_share_reports_id_seq'::regclass);


--
-- Name: monev_target_pending_updates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_target_pending_updates ALTER COLUMN id SET DEFAULT nextval('public.monev_target_pending_updates_id_seq'::regclass);


--
-- Name: monev_targets id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_targets ALTER COLUMN id SET DEFAULT nextval('public.monev_targets_id_seq'::regclass);


--
-- Name: permissions id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions ALTER COLUMN id SET DEFAULT nextval('public.permissions_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: activity_logs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.activity_logs (id, user_id, module, key, description, deleted_at, created_at, updated_at) FROM stdin;
1	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:04 WIB'.	\N	2025-10-31 22:04:25.674358	2025-10-31 22:04:25.674358
2	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:05 WIB'.	\N	2025-10-31 22:05:37.735851	2025-10-31 22:05:37.735851
3	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:05 WIB'.	\N	2025-10-31 22:05:45.284165	2025-10-31 22:05:45.284165
4	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:05 WIB'.	\N	2025-10-31 22:05:55.866043	2025-10-31 22:05:55.866043
5	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:07.784334	2025-10-31 22:06:07.784334
6	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:08.889714	2025-10-31 22:06:08.889714
7	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:09.947359	2025-10-31 22:06:09.947359
8	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:11.043596	2025-10-31 22:06:11.043596
9	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:12.189284	2025-10-31 22:06:12.189284
10	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:21.212317	2025-10-31 22:06:21.212317
11	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:22.40031	2025-10-31 22:06:22.40031
12	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:23.54511	2025-10-31 22:06:23.54511
13	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:24.88331	2025-10-31 22:06:24.88331
14	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:26.217509	2025-10-31 22:06:26.217509
15	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:06 WIB'.	\N	2025-10-31 22:06:40.254307	2025-10-31 22:06:40.254307
16	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:03.458317	2025-10-31 22:07:03.458317
17	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:14.660314	2025-10-31 22:07:14.660314
18	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:23.212278	2025-10-31 22:07:23.212278
19	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:33.584912	2025-10-31 22:07:33.584912
20	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:41.751432	2025-10-31 22:07:41.751432
21	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:49.713309	2025-10-31 22:07:49.713309
22	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:07 WIB'.	\N	2025-10-31 22:07:58.108308	2025-10-31 22:07:58.108308
23	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:04.65431	2025-10-31 22:08:04.65431
24	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:11.481502	2025-10-31 22:08:11.481502
25	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:20.563685	2025-10-31 22:08:20.563685
26	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:35.373465	2025-10-31 22:08:35.373465
27	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:41.975474	2025-10-31 22:08:41.975474
28	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:51.019066	2025-10-31 22:08:51.019066
29	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:08 WIB'.	\N	2025-10-31 22:08:59.992168	2025-10-31 22:08:59.992168
30	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:09 WIB'.	\N	2025-10-31 22:09:09.274541	2025-10-31 22:09:09.274541
31	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:10 WIB'.	\N	2025-10-31 22:10:46.559317	2025-10-31 22:10:46.559317
32	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:10 WIB'.	\N	2025-10-31 22:10:59.569317	2025-10-31 22:10:59.569317
33	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:11 WIB'.	\N	2025-10-31 22:11:05.076308	2025-10-31 22:11:05.076308
34	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:11 WIB'.	\N	2025-10-31 22:11:16.161773	2025-10-31 22:11:16.161773
35	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:11 WIB'.	\N	2025-10-31 22:11:21.034468	2025-10-31 22:11:21.034468
36	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:11 WIB'.	\N	2025-10-31 22:11:32.474986	2025-10-31 22:11:32.474986
37	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:11 WIB'.	\N	2025-10-31 22:11:42.801322	2025-10-31 22:11:42.801322
38	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:11 WIB'.	\N	2025-10-31 22:11:57.89332	2025-10-31 22:11:57.89332
39	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:12 WIB'.	\N	2025-10-31 22:12:05.968319	2025-10-31 22:12:05.968319
40	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:12 WIB'.	\N	2025-10-31 22:12:13.794317	2025-10-31 22:12:13.794317
41	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:12 WIB'.	\N	2025-10-31 22:12:25.19531	2025-10-31 22:12:25.19531
42	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:12 WIB'.	\N	2025-10-31 22:12:34.103016	2025-10-31 22:12:34.103016
43	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:12 WIB'.	\N	2025-10-31 22:12:42.403334	2025-10-31 22:12:42.403334
44	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:12 WIB'.	\N	2025-10-31 22:12:51.568315	2025-10-31 22:12:51.568315
45	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:13 WIB'.	\N	2025-10-31 22:13:00.728311	2025-10-31 22:13:00.728311
46	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:13 WIB'.	\N	2025-10-31 22:13:09.319339	2025-10-31 22:13:09.319339
47	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:13 WIB'.	\N	2025-10-31 22:13:19.577853	2025-10-31 22:13:19.577853
48	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:13 WIB'.	\N	2025-10-31 22:13:57.135267	2025-10-31 22:13:57.135267
49	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:13 WIB'.	\N	2025-10-31 22:13:58.175321	2025-10-31 22:13:58.175321
50	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:17 WIB'.	\N	2025-10-31 22:17:09.670305	2025-10-31 22:17:09.670305
51	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:17 WIB'.	\N	2025-10-31 22:17:16.539027	2025-10-31 22:17:16.539027
52	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:17 WIB'.	\N	2025-10-31 22:17:24.957253	2025-10-31 22:17:24.957253
53	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:17 WIB'.	\N	2025-10-31 22:17:34.103835	2025-10-31 22:17:34.103835
54	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:17 WIB'.	\N	2025-10-31 22:17:42.941306	2025-10-31 22:17:42.941306
55	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:18 WIB'.	\N	2025-10-31 22:18:20.456273	2025-10-31 22:18:20.456273
56	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:18 WIB'.	\N	2025-10-31 22:18:26.192818	2025-10-31 22:18:26.192818
57	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:18 WIB'.	\N	2025-10-31 22:18:39.928318	2025-10-31 22:18:39.928318
58	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:18 WIB'.	\N	2025-10-31 22:18:48.54554	2025-10-31 22:18:48.54554
59	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:18 WIB'.	\N	2025-10-31 22:18:57.393324	2025-10-31 22:18:57.393324
60	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:19 WIB'.	\N	2025-10-31 22:19:06.323316	2025-10-31 22:19:06.323316
61	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:20 WIB'.	\N	2025-10-31 22:20:55.850306	2025-10-31 22:20:55.850306
62	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:03.411511	2025-10-31 22:21:03.411511
63	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:11.175325	2025-10-31 22:21:11.175325
64	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:19.1097	2025-10-31 22:21:19.1097
65	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:33.167512	2025-10-31 22:21:33.167512
66	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:40.136316	2025-10-31 22:21:40.136316
67	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:48.430773	2025-10-31 22:21:48.430773
68	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:21 WIB'.	\N	2025-10-31 22:21:56.782812	2025-10-31 22:21:56.782812
69	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:05.270999	2025-10-31 22:22:05.270999
70	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:16.787579	2025-10-31 22:22:16.787579
71	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:24.676626	2025-10-31 22:22:24.676626
72	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:34.237305	2025-10-31 22:22:34.237305
73	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:43.486431	2025-10-31 22:22:43.486431
74	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:52.013307	2025-10-31 22:22:52.013307
75	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:22 WIB'.	\N	2025-10-31 22:22:59.724814	2025-10-31 22:22:59.724814
76	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:23 WIB'.	\N	2025-10-31 22:23:09.452962	2025-10-31 22:23:09.452962
77	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:23 WIB'.	\N	2025-10-31 22:23:22.103322	2025-10-31 22:23:22.103322
78	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:23 WIB'.	\N	2025-10-31 22:23:28.840502	2025-10-31 22:23:28.840502
79	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:23 WIB'.	\N	2025-10-31 22:23:39.786154	2025-10-31 22:23:39.786154
80	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:23 WIB'.	\N	2025-10-31 22:23:48.55332	2025-10-31 22:23:48.55332
81	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:23 WIB'.	\N	2025-10-31 22:23:54.087233	2025-10-31 22:23:54.087233
82	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:06.231354	2025-10-31 22:24:06.231354
83	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:16.354572	2025-10-31 22:24:16.354572
84	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:20.530311	2025-10-31 22:24:20.530311
85	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:29.021309	2025-10-31 22:24:29.021309
86	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:36.883612	2025-10-31 22:24:36.883612
87	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:44.244582	2025-10-31 22:24:44.244582
88	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:24 WIB'.	\N	2025-10-31 22:24:51.932327	2025-10-31 22:24:51.932327
89	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:25 WIB'.	\N	2025-10-31 22:25:03.038318	2025-10-31 22:25:03.038318
90	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:25 WIB'.	\N	2025-10-31 22:25:10.29931	2025-10-31 22:25:10.29931
91	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:25 WIB'.	\N	2025-10-31 22:25:30.472317	2025-10-31 22:25:30.472317
92	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:25 WIB'.	\N	2025-10-31 22:25:39.940448	2025-10-31 22:25:39.940448
93	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:25 WIB'.	\N	2025-10-31 22:25:51.564309	2025-10-31 22:25:51.564309
94	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:25 WIB'.	\N	2025-10-31 22:25:59.771039	2025-10-31 22:25:59.771039
95	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:26 WIB'.	\N	2025-10-31 22:26:15.506507	2025-10-31 22:26:15.506507
96	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:26 WIB'.	\N	2025-10-31 22:26:29.979314	2025-10-31 22:26:29.979314
97	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:26 WIB'.	\N	2025-10-31 22:26:39.729306	2025-10-31 22:26:39.729306
98	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:26 WIB'.	\N	2025-10-31 22:26:48.487317	2025-10-31 22:26:48.487317
99	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:26 WIB'.	\N	2025-10-31 22:26:53.076314	2025-10-31 22:26:53.076314
100	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:05.028316	2025-10-31 22:27:05.028316
101	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:13.016112	2025-10-31 22:27:13.016112
102	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:17.492725	2025-10-31 22:27:17.492725
103	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:28.109821	2025-10-31 22:27:28.109821
104	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:36.69463	2025-10-31 22:27:36.69463
105	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:41.180314	2025-10-31 22:27:41.180314
106	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:49.515911	2025-10-31 22:27:49.515911
107	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:27 WIB'.	\N	2025-10-31 22:27:56.973318	2025-10-31 22:27:56.973318
108	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:01.30563	2025-10-31 22:28:01.30563
109	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:11.924418	2025-10-31 22:28:11.924418
110	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:19.328243	2025-10-31 22:28:19.328243
111	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:26.501529	2025-10-31 22:28:26.501529
112	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:34.630308	2025-10-31 22:28:34.630308
113	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:45.414844	2025-10-31 22:28:45.414844
114	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:28 WIB'.	\N	2025-10-31 22:28:53.217387	2025-10-31 22:28:53.217387
115	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:29 WIB'.	\N	2025-10-31 22:29:01.062312	2025-10-31 22:29:01.062312
116	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:29 WIB'.	\N	2025-10-31 22:29:08.979557	2025-10-31 22:29:08.979557
117	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:29 WIB'.	\N	2025-10-31 22:29:32.390815	2025-10-31 22:29:32.390815
118	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:29 WIB'.	\N	2025-10-31 22:29:39.349316	2025-10-31 22:29:39.349316
119	1	cms	create	Menambahkan data 'List Konten' pada 'Sabtu, 1 November 2025 pukul 05:29 WIB'.	\N	2025-10-31 22:29:47.31711	2025-10-31 22:29:47.31711
120	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:38 WIB'.	\N	2025-11-01 02:38:53.682424	2025-11-01 02:38:53.682424
121	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:44 WIB'.	\N	2025-11-01 02:44:03.16568	2025-11-01 02:44:03.16568
122	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:44 WIB'.	\N	2025-11-01 02:44:24.882256	2025-11-01 02:44:24.882256
123	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:44 WIB'.	\N	2025-11-01 02:44:37.04506	2025-11-01 02:44:37.04506
124	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:44 WIB'.	\N	2025-11-01 02:44:58.139895	2025-11-01 02:44:58.139895
125	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:45 WIB'.	\N	2025-11-01 02:45:11.818785	2025-11-01 02:45:11.818785
126	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:45 WIB'.	\N	2025-11-01 02:45:27.875694	2025-11-01 02:45:27.875694
127	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:45 WIB'.	\N	2025-11-01 02:45:39.710733	2025-11-01 02:45:39.710733
128	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:45 WIB'.	\N	2025-11-01 02:45:44.329069	2025-11-01 02:45:44.329069
129	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:46 WIB'.	\N	2025-11-01 02:46:01.400309	2025-11-01 02:46:01.400309
130	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:46 WIB'.	\N	2025-11-01 02:46:47.630262	2025-11-01 02:46:47.630262
131	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:46 WIB'.	\N	2025-11-01 02:46:55.695854	2025-11-01 02:46:55.695854
132	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:46 WIB'.	\N	2025-11-01 02:46:59.633117	2025-11-01 02:46:59.633117
133	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:47 WIB'.	\N	2025-11-01 02:47:17.81144	2025-11-01 02:47:17.81144
134	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:48 WIB'.	\N	2025-11-01 02:48:04.498073	2025-11-01 02:48:04.498073
135	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:49 WIB'.	\N	2025-11-01 02:49:01.296383	2025-11-01 02:49:01.296383
136	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:49 WIB'.	\N	2025-11-01 02:49:15.795099	2025-11-01 02:49:15.795099
137	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:49 WIB'.	\N	2025-11-01 02:49:23.998428	2025-11-01 02:49:23.998428
138	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Sabtu, 1 November 2025 pukul 09:58 WIB'.	\N	2025-11-01 02:58:01.689084	2025-11-01 02:58:01.689084
139	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 09:59 WIB'.	\N	2025-11-01 02:59:10.87954	2025-11-01 02:59:10.87954
140	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 10:10 WIB'.	\N	2025-11-01 03:10:22.056565	2025-11-01 03:10:22.056565
141	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 1 November 2025 pukul 10:16 WIB'.	\N	2025-11-01 03:16:10.887282	2025-11-01 03:16:10.887282
142	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 10:18 WIB'.	\N	2025-11-01 03:18:02.959801	2025-11-01 03:18:02.959801
143	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 10:18 WIB'.	\N	2025-11-01 03:18:55.086281	2025-11-01 03:18:55.086281
144	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 1 November 2025 pukul 10:50 WIB'.	\N	2025-11-01 03:50:45.191184	2025-11-01 03:50:45.191184
145	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 1 November 2025 pukul 10:57 WIB'.	\N	2025-11-01 03:57:30.091644	2025-11-01 03:57:30.091644
146	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 1 November 2025 pukul 11:05 WIB'.	\N	2025-11-01 04:05:10.484312	2025-11-01 04:05:10.484312
147	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 1 November 2025 pukul 11:08 WIB'.	\N	2025-11-01 04:08:11.966889	2025-11-01 04:08:11.966889
148	1	master_data	create	Menambahkan data 'List Kategori Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:10 WIB'.	\N	2025-11-01 04:10:35.637589	2025-11-01 04:10:35.637589
149	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 11:10 WIB'.	\N	2025-11-01 04:10:40.383123	2025-11-01 04:10:40.383123
150	1	master_data	create	Menambahkan data 'List Kategori Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:11 WIB'.	\N	2025-11-01 04:11:04.988262	2025-11-01 04:11:04.988262
151	1	master_data	create	Menambahkan data 'List Kategori Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:11 WIB'.	\N	2025-11-01 04:11:30.697314	2025-11-01 04:11:30.697314
152	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 11:11 WIB'.	\N	2025-11-01 04:11:33.429238	2025-11-01 04:11:33.429238
153	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 1 November 2025 pukul 11:13 WIB'.	\N	2025-11-01 04:13:45.373122	2025-11-01 04:13:45.373122
154	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 1 November 2025 pukul 11:14 WIB'.	\N	2025-11-01 04:14:20.007379	2025-11-01 04:14:20.007379
155	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 11:16 WIB'.	\N	2025-11-01 04:16:56.977585	2025-11-01 04:16:56.977585
156	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:22 WIB'.	\N	2025-11-01 04:22:53.252334	2025-11-01 04:22:53.252334
157	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:27 WIB'.	\N	2025-11-01 04:27:51.245749	2025-11-01 04:27:51.245749
158	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:28 WIB'.	\N	2025-11-01 04:28:07.077588	2025-11-01 04:28:07.077588
159	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 1 November 2025 pukul 11:29 WIB'.	\N	2025-11-01 04:29:49.839314	2025-11-01 04:29:49.839314
160	1	master_data	create	Menambahkan data 'List Kategori Satwa' pada 'Sabtu, 1 November 2025 pukul 11:33 WIB'.	\N	2025-11-01 04:33:40.913	2025-11-01 04:33:40.913
161	1	cms	create	Menambahkan data 'List Komposisi Satwa' pada 'Sabtu, 1 November 2025 pukul 11:34 WIB'.	\N	2025-11-01 04:34:20.28915	2025-11-01 04:34:20.28915
162	1	master_data	create	Menambahkan data 'List Kategori Satwa' pada 'Sabtu, 1 November 2025 pukul 11:35 WIB'.	\N	2025-11-01 04:35:12.137163	2025-11-01 04:35:12.137163
163	1	cms	create	Menambahkan data 'List Komposisi Satwa' pada 'Sabtu, 1 November 2025 pukul 11:35 WIB'.	\N	2025-11-01 04:35:43.833118	2025-11-01 04:35:43.833118
164	1	cms	update	Memperbarui data 'List Komposisi Satwa' pada 'Sabtu, 1 November 2025 pukul 11:35 WIB'.	\N	2025-11-01 04:35:52.549319	2025-11-01 04:35:52.549319
165	1	master_data	create	Menambahkan data 'List Kategori Satwa' pada 'Sabtu, 1 November 2025 pukul 11:36 WIB'.	\N	2025-11-01 04:36:44.761314	2025-11-01 04:36:44.761314
166	1	cms	update	Memperbarui data 'List Komposisi Satwa' pada 'Sabtu, 1 November 2025 pukul 11:36 WIB'.	\N	2025-11-01 04:36:51.852969	2025-11-01 04:36:51.852969
167	1	master_data	create	Menambahkan data 'List Kategori Satwa' pada 'Sabtu, 1 November 2025 pukul 11:38 WIB'.	\N	2025-11-01 04:38:24.574376	2025-11-01 04:38:24.574376
168	1	cms	create	Menambahkan data 'List Komposisi Satwa' pada 'Sabtu, 1 November 2025 pukul 11:39 WIB'.	\N	2025-11-01 04:39:33.024962	2025-11-01 04:39:33.024962
169	1	monev	delete	Menghapus data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 13:40 WIB'.	\N	2025-11-01 06:40:19.220095	2025-11-01 06:40:19.220095
170	1	monev	delete	Menghapus data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 14:05 WIB'.	\N	2025-11-01 07:05:48.577305	2025-11-01 07:05:48.577305
171	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Sabtu, 1 November 2025 pukul 14:08 WIB'.	\N	2025-11-01 07:08:35.296775	2025-11-01 07:08:35.296775
172	1	monev	create	Menambahkan data 'List Laporan' pada 'Sabtu, 1 November 2025 pukul 15:38 WIB'.	\N	2025-11-01 08:38:33.331972	2025-11-01 08:38:33.331972
173	1	monev	delete	Menghapus data 'List Laporan' pada 'Sabtu, 1 November 2025 pukul 15:44 WIB'.	\N	2025-11-01 08:44:51.999886	2025-11-01 08:44:51.999886
174	1	monev	restore	Mengembalikan data 'List Laporan' pada 'Sabtu, 1 November 2025 pukul 15:44 WIB'.	\N	2025-11-01 08:44:55.81467	2025-11-01 08:44:55.81467
175	1	monev	update	Memperbarui data 'List Laporan' pada 'Sabtu, 1 November 2025 pukul 15:48 WIB'.	\N	2025-11-01 08:48:46.294092	2025-11-01 08:48:46.294092
176	1	monev	update	Memperbarui data 'List Laporan' pada 'Sabtu, 1 November 2025 pukul 15:48 WIB'.	\N	2025-11-01 08:48:55.885889	2025-11-01 08:48:55.885889
177	1	monev	update	Memperbarui data 'List Laporan' pada 'Sabtu, 1 November 2025 pukul 15:50 WIB'.	\N	2025-11-01 08:50:44.649376	2025-11-01 08:50:44.649376
178	1	master_data	create	Menambahkan data 'List Kategori Divisi PIC' pada 'Sabtu, 1 November 2025 pukul 16:26 WIB'.	\N	2025-11-01 09:26:52.132414	2025-11-01 09:26:52.132414
179	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Sabtu, 1 November 2025 pukul 16:30 WIB'.	\N	2025-11-01 09:30:13.806649	2025-11-01 09:30:13.806649
180	1	monev	update	Memperbarui data 'Target Kegiatan Bulan '4 2025' (update langsung oleh superadmin)' pada 'Sabtu, 1 November 2025 pukul 16:30 WIB'.	\N	2025-11-01 09:30:25.887134	2025-11-01 09:30:25.887134
181	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '4 2025' (update langsung oleh superadmin)' pada 'Sabtu, 1 November 2025 pukul 16:36 WIB'.	\N	2025-11-01 09:36:11.68998	2025-11-01 09:36:11.68998
182	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '4 2025' (update langsung oleh superadmin)' pada 'Sabtu, 1 November 2025 pukul 22:23 WIB'.	\N	2025-11-01 15:23:29.025344	2025-11-01 15:23:29.025344
183	1	kmis	delete	Menghapus data 'List Topik' pada 'Minggu, 2 November 2025 pukul 09:00 WIB'.	\N	2025-11-02 02:00:05.14054	2025-11-02 02:00:05.14054
184	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 09:05 WIB'.	\N	2025-11-02 02:05:24.575533	2025-11-02 02:05:24.575533
185	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 09:17 WIB'.	\N	2025-11-02 02:17:38.661675	2025-11-02 02:17:38.661675
186	1	master_data	create	Menambahkan data 'List Kategori Kegiatan' pada 'Minggu, 2 November 2025 pukul 09:26 WIB'.	\N	2025-11-02 02:26:27.168645	2025-11-02 02:26:27.168645
187	1	master_data	create	Menambahkan data 'List Kategori Kegiatan' pada 'Minggu, 2 November 2025 pukul 09:27 WIB'.	\N	2025-11-02 02:27:56.050257	2025-11-02 02:27:56.050257
188	1	master_data	create	Menambahkan data 'List Kategori Berita' pada 'Minggu, 2 November 2025 pukul 09:29 WIB'.	\N	2025-11-02 02:29:05.917939	2025-11-02 02:29:05.917939
189	1	cms	create	Menambahkan data 'List Berita' pada 'Minggu, 2 November 2025 pukul 09:37 WIB'.	\N	2025-11-02 02:37:37.173721	2025-11-02 02:37:37.173721
190	1	master_data	create	Menambahkan data 'List Kategori Berita' pada 'Minggu, 2 November 2025 pukul 09:41 WIB'.	\N	2025-11-02 02:41:16.989247	2025-11-02 02:41:16.989247
191	1	cms	create	Menambahkan data 'List Berita' pada 'Minggu, 2 November 2025 pukul 09:43 WIB'.	\N	2025-11-02 02:43:54.693966	2025-11-02 02:43:54.693966
192	1	master_data	create	Menambahkan data 'List Kategori Divisi PIC' pada 'Minggu, 2 November 2025 pukul 09:44 WIB'.	\N	2025-11-02 02:44:13.302326	2025-11-02 02:44:13.302326
193	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 09:47 WIB'.	\N	2025-11-02 02:47:34.74834	2025-11-02 02:47:34.74834
194	1	cms	create	Menambahkan data 'List FAQ' pada 'Minggu, 2 November 2025 pukul 09:51 WIB'.	\N	2025-11-02 02:51:17.68442	2025-11-02 02:51:17.68442
195	1	cms	create	Menambahkan data 'List FAQ' pada 'Minggu, 2 November 2025 pukul 09:54 WIB'.	\N	2025-11-02 02:54:23.067526	2025-11-02 02:54:23.067526
196	1	cms	create	Menambahkan data 'List FAQ' pada 'Minggu, 2 November 2025 pukul 09:57 WIB'.	\N	2025-11-02 02:57:11.621313	2025-11-02 02:57:11.621313
197	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 2 November 2025 pukul 09:59 WIB'.	\N	2025-11-02 02:59:54.340332	2025-11-02 02:59:54.340332
198	1	kmis	restore	Mengembalikan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 09:59 WIB'.	\N	2025-11-02 02:59:59.246318	2025-11-02 02:59:59.246318
199	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 10:00 WIB'.	\N	2025-11-02 03:00:45.141189	2025-11-02 03:00:45.141189
200	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 10:01 WIB'.	\N	2025-11-02 03:01:15.763131	2025-11-02 03:01:15.763131
201	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 10:01 WIB'.	\N	2025-11-02 03:01:35.47207	2025-11-02 03:01:35.47207
202	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 10:02 WIB'.	\N	2025-11-02 03:02:14.704459	2025-11-02 03:02:14.704459
203	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 10:03 WIB'.	\N	2025-11-02 03:03:06.318837	2025-11-02 03:03:06.318837
204	1	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 2 November 2025 pukul 10:10 WIB'.	\N	2025-11-02 03:10:39.904532	2025-11-02 03:10:39.904532
205	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:11 WIB'.	\N	2025-11-02 03:11:58.46431	2025-11-02 03:11:58.46431
206	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Minggu, 2 November 2025 pukul 10:12 WIB'.	\N	2025-11-02 03:12:37.777803	2025-11-02 03:12:37.777803
207	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Minggu, 2 November 2025 pukul 10:13 WIB'.	\N	2025-11-02 03:13:51.476633	2025-11-02 03:13:51.476633
208	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Minggu, 2 November 2025 pukul 10:15 WIB'.	\N	2025-11-02 03:15:38.454135	2025-11-02 03:15:38.454135
209	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Minggu, 2 November 2025 pukul 10:16 WIB'.	\N	2025-11-02 03:16:32.917323	2025-11-02 03:16:32.917323
210	36	kmis	create	Menyimpan jawaban: quizId=1, selected=C, correct=false, progress=1/2	\N	2025-11-02 03:16:40.289433	2025-11-02 03:16:40.289433
211	36	kmis	create	Revisi jawaban: topicId=1, quizId=1, selected=B, correct=false, progress=1/2	\N	2025-11-02 03:16:44.195307	2025-11-02 03:16:44.195307
212	36	kmis	create	Revisi jawaban: topicId=1, quizId=1, selected=C, correct=false, progress=1/2	\N	2025-11-02 03:16:45.673923	2025-11-02 03:16:45.673923
213	36	kmis	create	Menyimpan jawaban: quizId=2, selected=D, correct=false, progress=2/2	\N	2025-11-02 03:16:49.664307	2025-11-02 03:16:49.664307
214	36	kmis	create	Menyelesaikan kuis dengan attempt_id=1 (answered=2/2, correct=0, score=0)	\N	2025-11-02 03:16:53.961304	2025-11-02 03:16:53.961304
215	2	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 2 November 2025 pukul 10:24 WIB'.	\N	2025-11-02 03:24:51.018326	2025-11-02 03:24:51.018326
216	1	master_data	create	Menambahkan data 'List Kategori Divisi PIC' pada 'Minggu, 2 November 2025 pukul 10:39 WIB'.	\N	2025-11-02 03:39:19.51952	2025-11-02 03:39:19.51952
217	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:52 WIB'.	\N	2025-11-02 03:52:14.606954	2025-11-02 03:52:14.606954
218	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:52 WIB'.	\N	2025-11-02 03:52:49.634311	2025-11-02 03:52:49.634311
219	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:52 WIB'.	\N	2025-11-02 03:52:53.592263	2025-11-02 03:52:53.592263
220	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:56 WIB'.	\N	2025-11-02 03:56:26.351321	2025-11-02 03:56:26.351321
221	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:57 WIB'.	\N	2025-11-02 03:57:01.785311	2025-11-02 03:57:01.785311
222	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:57 WIB'.	\N	2025-11-02 03:57:07.398964	2025-11-02 03:57:07.398964
223	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:57 WIB'.	\N	2025-11-02 03:57:36.013311	2025-11-02 03:57:36.013311
224	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 10:57 WIB'.	\N	2025-11-02 03:57:58.18031	2025-11-02 03:57:58.18031
225	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 11:19 WIB'.	\N	2025-11-02 04:19:26.288103	2025-11-02 04:19:26.288103
226	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 2 November 2025 pukul 11:21 WIB'.	\N	2025-11-02 04:21:31.006927	2025-11-02 04:21:31.006927
227	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 2 November 2025 pukul 11:23 WIB'.	\N	2025-11-02 04:23:35.140405	2025-11-02 04:23:35.140405
228	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 2 November 2025 pukul 11:24 WIB'.	\N	2025-11-02 04:24:42.168271	2025-11-02 04:24:42.168271
229	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:53 WIB'.	\N	2025-11-02 06:53:25.406645	2025-11-02 06:53:25.406645
230	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:53 WIB'.	\N	2025-11-02 06:53:30.220127	2025-11-02 06:53:30.220127
231	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:53 WIB'.	\N	2025-11-02 06:53:44.987077	2025-11-02 06:53:44.987077
232	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:54 WIB'.	\N	2025-11-02 06:54:47.68796	2025-11-02 06:54:47.68796
233	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:54 WIB'.	\N	2025-11-02 06:54:54.816806	2025-11-02 06:54:54.816806
234	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:55 WIB'.	\N	2025-11-02 06:55:34.285835	2025-11-02 06:55:34.285835
235	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:55 WIB'.	\N	2025-11-02 06:55:41.501724	2025-11-02 06:55:41.501724
236	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:55 WIB'.	\N	2025-11-02 06:55:48.117135	2025-11-02 06:55:48.117135
237	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:56 WIB'.	\N	2025-11-02 06:56:32.836074	2025-11-02 06:56:32.836074
238	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:57 WIB'.	\N	2025-11-02 06:57:05.652509	2025-11-02 06:57:05.652509
239	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:57 WIB'.	\N	2025-11-02 06:57:24.412757	2025-11-02 06:57:24.412757
240	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 13:57 WIB'.	\N	2025-11-02 06:57:41.869854	2025-11-02 06:57:41.869854
241	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:03 WIB'.	\N	2025-11-02 07:03:10.149371	2025-11-02 07:03:10.149371
242	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:05 WIB'.	\N	2025-11-02 07:05:37.510505	2025-11-02 07:05:37.510505
243	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:07 WIB'.	\N	2025-11-02 07:07:10.176582	2025-11-02 07:07:10.176582
244	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:10 WIB'.	\N	2025-11-02 07:10:10.283612	2025-11-02 07:10:10.283612
245	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:11 WIB'.	\N	2025-11-02 07:11:26.787282	2025-11-02 07:11:26.787282
246	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:13 WIB'.	\N	2025-11-02 07:13:03.011351	2025-11-02 07:13:03.011351
247	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:14 WIB'.	\N	2025-11-02 07:14:05.383881	2025-11-02 07:14:05.383881
248	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 2 November 2025 pukul 14:15 WIB'.	\N	2025-11-02 07:15:28.027831	2025-11-02 07:15:28.027831
249	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 20:19 WIB'.	\N	2025-11-02 13:19:24.846349	2025-11-02 13:19:24.846349
250	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:22 WIB'.	\N	2025-11-02 13:22:07.959552	2025-11-02 13:22:07.959552
251	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 20:22 WIB'.	\N	2025-11-02 13:22:51.427688	2025-11-02 13:22:51.427688
252	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:24 WIB'.	\N	2025-11-02 13:24:05.772122	2025-11-02 13:24:05.772122
253	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 20:24 WIB'.	\N	2025-11-02 13:24:22.959273	2025-11-02 13:24:22.959273
254	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:25 WIB'.	\N	2025-11-02 13:25:19.091754	2025-11-02 13:25:19.091754
255	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 20:25 WIB'.	\N	2025-11-02 13:25:50.087331	2025-11-02 13:25:50.087331
256	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:26 WIB'.	\N	2025-11-02 13:26:39.640458	2025-11-02 13:26:39.640458
257	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:28 WIB'.	\N	2025-11-02 13:28:00.658149	2025-11-02 13:28:00.658149
258	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:28 WIB'.	\N	2025-11-02 13:28:55.944444	2025-11-02 13:28:55.944444
259	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 20:29 WIB'.	\N	2025-11-02 13:29:09.743316	2025-11-02 13:29:09.743316
260	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:34 WIB'.	\N	2025-11-02 13:34:30.234451	2025-11-02 13:34:30.234451
261	1	kmis	create	Menambahkan data 'List Kategori' pada 'Minggu, 2 November 2025 pukul 20:34 WIB'.	\N	2025-11-02 13:34:48.274789	2025-11-02 13:34:48.274789
262	1	kmis	create	Menambahkan data 'List Topik' pada 'Minggu, 2 November 2025 pukul 20:35 WIB'.	\N	2025-11-02 13:35:25.043019	2025-11-02 13:35:25.043019
263	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Minggu, 2 November 2025 pukul 21:40 WIB'.	\N	2025-11-02 14:40:28.313326	2025-11-02 14:40:28.313326
264	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Minggu, 2 November 2025 pukul 21:42 WIB'.	\N	2025-11-02 14:42:48.605792	2025-11-02 14:42:48.605792
265	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Minggu, 2 November 2025 pukul 21:45 WIB'.	\N	2025-11-02 14:45:13.391402	2025-11-02 14:45:13.391402
266	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Minggu, 2 November 2025 pukul 21:48 WIB'.	\N	2025-11-02 14:48:12.294696	2025-11-02 14:48:12.294696
267	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Minggu, 2 November 2025 pukul 21:50 WIB'.	\N	2025-11-02 14:50:05.212359	2025-11-02 14:50:05.212359
268	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Minggu, 2 November 2025 pukul 21:50 WIB'.	\N	2025-11-02 14:50:39.294309	2025-11-02 14:50:39.294309
269	1	monev	create	Menambahkan data 'List Laporan' pada 'Minggu, 2 November 2025 pukul 21:53 WIB'.	\N	2025-11-02 14:53:09.591328	2025-11-02 14:53:09.591328
270	1	monev	delete	Menghapus data 'List Laporan' pada 'Minggu, 2 November 2025 pukul 21:53 WIB'.	\N	2025-11-02 14:53:22.397319	2025-11-02 14:53:22.397319
271	1	monev	restore	Mengembalikan data 'List Laporan' pada 'Minggu, 2 November 2025 pukul 21:53 WIB'.	\N	2025-11-02 14:53:27.033313	2025-11-02 14:53:27.033313
272	1	monev	delete	Menghapus data 'List Laporan' pada 'Minggu, 2 November 2025 pukul 21:53 WIB'.	\N	2025-11-02 14:53:38.291309	2025-11-02 14:53:38.291309
273	1	master_data	update	Memperbarui data 'Assign Pengguna Divisi PIC' pada 'Minggu, 2 November 2025 pukul 23:10 WIB'.	\N	2025-11-02 16:10:48.39742	2025-11-02 16:10:48.39742
274	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Senin, 3 November 2025 pukul 07:37 WIB'.	\N	2025-11-03 00:37:21.812313	2025-11-03 00:37:21.812313
275	1	cms	restore	Mengembalikan data 'List Dokumen Hukum' pada 'Senin, 3 November 2025 pukul 07:37 WIB'.	\N	2025-11-03 00:37:37.160983	2025-11-03 00:37:37.160983
276	1	cms	delete	Menghapus data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 07:43 WIB'.	\N	2025-11-03 00:43:27.679308	2025-11-03 00:43:27.679308
277	1	cms	restore	Mengembalikan data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 07:43 WIB'.	\N	2025-11-03 00:43:36.956746	2025-11-03 00:43:36.956746
278	1	cms	delete	Menghapus data 'List Berita' pada 'Senin, 3 November 2025 pukul 07:43 WIB'.	\N	2025-11-03 00:43:52.943881	2025-11-03 00:43:52.943881
279	1	cms	restore	Mengembalikan data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 07:44 WIB'.	\N	2025-11-03 00:44:02.244438	2025-11-03 00:44:02.244438
280	1	master_data	create	Menambahkan data 'List Kategori Divisi PIC' pada 'Senin, 3 November 2025 pukul 07:52 WIB'.	\N	2025-11-03 00:52:24.714607	2025-11-03 00:52:24.714607
281	1	master_data	update	Memperbarui data 'Assign Pengguna Divisi PIC' pada 'Senin, 3 November 2025 pukul 08:00 WIB'.	\N	2025-11-03 01:00:25.729304	2025-11-03 01:00:25.729304
282	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Senin, 3 November 2025 pukul 08:05 WIB'.	\N	2025-11-03 01:05:23.799555	2025-11-03 01:05:23.799555
283	1	master_data	update	Memperbarui data 'Assign Pengguna Divisi PIC' pada 'Senin, 3 November 2025 pukul 08:09 WIB'.	\N	2025-11-03 01:09:30.933259	2025-11-03 01:09:30.933259
284	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:34 WIB'.	\N	2025-11-03 01:34:50.232038	2025-11-03 01:34:50.232038
285	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:35 WIB'.	\N	2025-11-03 01:35:01.845743	2025-11-03 01:35:01.845743
286	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:35 WIB'.	\N	2025-11-03 01:35:20.190481	2025-11-03 01:35:20.190481
287	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:36 WIB'.	\N	2025-11-03 01:36:20.146983	2025-11-03 01:36:20.146983
288	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:36 WIB'.	\N	2025-11-03 01:36:42.675312	2025-11-03 01:36:42.675312
289	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:41 WIB'.	\N	2025-11-03 01:41:15.902584	2025-11-03 01:41:15.902584
290	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:42 WIB'.	\N	2025-11-03 01:42:10.406583	2025-11-03 01:42:10.406583
291	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:45 WIB'.	\N	2025-11-03 01:45:40.250497	2025-11-03 01:45:40.250497
292	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:46 WIB'.	\N	2025-11-03 01:46:41.741522	2025-11-03 01:46:41.741522
293	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:46 WIB'.	\N	2025-11-03 01:46:52.897356	2025-11-03 01:46:52.897356
294	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:46 WIB'.	\N	2025-11-03 01:46:59.445312	2025-11-03 01:46:59.445312
295	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Senin, 3 November 2025 pukul 08:57 WIB'.	\N	2025-11-03 01:57:09.026233	2025-11-03 01:57:09.026233
296	1	cms	update	Memperbarui data 'List Dokumen Hukum' pada 'Senin, 3 November 2025 pukul 08:58 WIB'.	\N	2025-11-03 01:58:07.590778	2025-11-03 01:58:07.590778
297	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 08:59 WIB'.	\N	2025-11-03 01:59:16.393196	2025-11-03 01:59:16.393196
298	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 09:06 WIB'.	\N	2025-11-03 02:06:35.011262	2025-11-03 02:06:35.011262
299	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 10:45 WIB'.	\N	2025-11-03 03:45:23.881395	2025-11-03 03:45:23.881395
300	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 10:45 WIB'.	\N	2025-11-03 03:45:38.004319	2025-11-03 03:45:38.004319
301	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 10:47 WIB'.	\N	2025-11-03 03:47:28.52832	2025-11-03 03:47:28.52832
302	1	master_data	update	Memperbarui data 'List Kategori Divisi PIC' pada 'Senin, 3 November 2025 pukul 12:39 WIB'.	\N	2025-11-03 05:39:40.788946	2025-11-03 05:39:40.788946
303	1	master_data	update	Memperbarui data 'List Kategori Divisi PIC' pada 'Senin, 3 November 2025 pukul 12:39 WIB'.	\N	2025-11-03 05:39:49.72432	2025-11-03 05:39:49.72432
304	1	master_data	update	Memperbarui data 'List Kategori Divisi PIC' pada 'Senin, 3 November 2025 pukul 12:39 WIB'.	\N	2025-11-03 05:39:55.626822	2025-11-03 05:39:55.626822
305	1	master_data	update	Memperbarui data 'Assign Pengguna Divisi PIC' pada 'Senin, 3 November 2025 pukul 13:01 WIB'.	\N	2025-11-03 06:01:12.452802	2025-11-03 06:01:12.452802
306	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Senin, 3 November 2025 pukul 13:31 WIB'.	\N	2025-11-03 06:31:32.211588	2025-11-03 06:31:32.211588
307	1	master_data	delete	Menghapus data 'List Kategori Divisi PIC' pada 'Senin, 3 November 2025 pukul 14:37 WIB'.	\N	2025-11-03 07:37:30.926305	2025-11-03 07:37:30.926305
308	1	master_data	delete	Menghapus data 'List Kategori Divisi PIC' pada 'Senin, 3 November 2025 pukul 14:37 WIB'.	\N	2025-11-03 07:37:35.111315	2025-11-03 07:37:35.111315
309	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Senin, 3 November 2025 pukul 14:44 WIB'.	\N	2025-11-03 07:44:02.501636	2025-11-03 07:44:02.501636
310	39	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Senin, 3 November 2025 pukul 14:48 WIB'.	\N	2025-11-03 07:48:30.009722	2025-11-03 07:48:30.009722
311	39	monev	update	Memperbarui data 'Target Kegiatan Bulan '9 2025' (update langsung)' pada 'Senin, 3 November 2025 pukul 14:53 WIB'.	\N	2025-11-03 07:53:23.2062	2025-11-03 07:53:23.2062
312	39	monev	create	Menambahkan data 'Target Kegiatan Bulan '9 2025'  (pending update)' pada 'Senin, 3 November 2025 pukul 14:53 WIB'.	\N	2025-11-03 07:53:50.805464	2025-11-03 07:53:50.805464
313	39	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '9 2025' (update langsung)' pada 'Senin, 3 November 2025 pukul 15:02 WIB'.	\N	2025-11-03 08:02:05.73706	2025-11-03 08:02:05.73706
314	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 17:14 WIB'.	\N	2025-11-03 10:14:31.22833	2025-11-03 10:14:31.22833
315	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 3 November 2025 pukul 17:14 WIB'.	\N	2025-11-03 10:14:51.55726	2025-11-03 10:14:51.55726
316	39	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '9 2025' (pending update)' pada 'Senin, 3 November 2025 pukul 23:30 WIB'.	\N	2025-11-03 16:30:01.945067	2025-11-03 16:30:01.945067
317	1	monev	delete	Menghapus data 'List Laporan' pada 'Senin, 3 November 2025 pukul 23:36 WIB'.	\N	2025-11-03 16:36:48.312719	2025-11-03 16:36:48.312719
318	1	monev	update	Memperbarui data 'List Laporan' pada 'Senin, 3 November 2025 pukul 23:36 WIB'.	\N	2025-11-03 16:36:59.953698	2025-11-03 16:36:59.953698
319	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Senin, 3 November 2025 pukul 23:38 WIB'.	\N	2025-11-03 16:38:04.436475	2025-11-03 16:38:04.436475
320	1	monev	delete	Menghapus data 'Kegiatan Kalender' pada 'Senin, 3 November 2025 pukul 23:38 WIB'.	\N	2025-11-03 16:38:20.7676	2025-11-03 16:38:20.7676
321	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Senin, 3 November 2025 pukul 23:38 WIB'.	\N	2025-11-03 16:38:56.022395	2025-11-03 16:38:56.022395
322	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Senin, 3 November 2025 pukul 23:39 WIB'.	\N	2025-11-03 16:39:05.953439	2025-11-03 16:39:05.953439
323	1	master_data	restore	Mengembalikan data 'List Kategori Divisi PIC' pada 'Selasa, 4 November 2025 pukul 04:03 WIB'.	\N	2025-11-03 21:03:26.468568	2025-11-03 21:03:26.468568
324	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 04:04 WIB'.	\N	2025-11-03 21:04:28.534554	2025-11-03 21:04:28.534554
325	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 04:04 WIB'.	\N	2025-11-03 21:04:49.295979	2025-11-03 21:04:49.295979
326	1	master_data	delete	Menghapus data 'List Kategori Divisi PIC' pada 'Selasa, 4 November 2025 pukul 04:04 WIB'.	\N	2025-11-03 21:04:56.617055	2025-11-03 21:04:56.617055
327	1	master_data	restore	Mengembalikan data 'List Kategori Divisi PIC' pada 'Selasa, 4 November 2025 pukul 05:40 WIB'.	\N	2025-11-03 22:40:55.306676	2025-11-03 22:40:55.306676
328	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 05:41 WIB'.	\N	2025-11-03 22:41:38.489585	2025-11-03 22:41:38.489585
329	1	monev	update	Memperbarui data 'Target Kegiatan Bulan '9 2025' (update langsung oleh superadmin)' pada 'Selasa, 4 November 2025 pukul 05:49 WIB'.	\N	2025-11-03 22:49:16.134817	2025-11-03 22:49:16.134817
330	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '9 2025' (update langsung oleh superadmin)' pada 'Selasa, 4 November 2025 pukul 05:49 WIB'.	\N	2025-11-03 22:49:45.667232	2025-11-03 22:49:45.667232
331	1	master_data	update	Memperbarui data 'Assign Pengguna Divisi PIC' pada 'Selasa, 4 November 2025 pukul 06:05 WIB'.	\N	2025-11-03 23:05:06.325304	2025-11-03 23:05:06.325304
332	41	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '9 2025' (pending update)' pada 'Selasa, 4 November 2025 pukul 06:06 WIB'.	\N	2025-11-03 23:06:42.960312	2025-11-03 23:06:42.960312
333	41	monev	create	Menambahkan data 'Target Kegiatan Bulan 'Oktober 2025'  (pending update)' pada 'Selasa, 4 November 2025 pukul 06:08 WIB'.	\N	2025-11-03 23:08:00.161438	2025-11-03 23:08:00.161438
334	1	monev	update	Memperbarui data 'Verifikasi Target Bulan 'Oktober 2025' (APPROVED)' pada 'Selasa, 4 November 2025 pukul 06:19 WIB'.	\N	2025-11-03 23:19:14.094611	2025-11-03 23:19:14.094611
335	1	monev	update	Memperbarui data 'Verifikasi Realisasi Bulanan Kegiatan di Bulan 'Oktober 2025' (APPROVED)' pada 'Selasa, 4 November 2025 pukul 06:19 WIB'.	\N	2025-11-03 23:19:37.979836	2025-11-03 23:19:37.979836
336	41	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 06:27 WIB'.	\N	2025-11-03 23:27:56.543763	2025-11-03 23:27:56.543763
337	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Selasa, 4 November 2025 pukul 06:57 WIB'.	\N	2025-11-03 23:57:43.193719	2025-11-03 23:57:43.193719
338	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Selasa, 4 November 2025 pukul 06:59 WIB'.	\N	2025-11-03 23:59:41.453773	2025-11-03 23:59:41.453773
339	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Selasa, 4 November 2025 pukul 07:00 WIB'.	\N	2025-11-04 00:00:49.210155	2025-11-04 00:00:49.210155
340	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 07:13 WIB'.	\N	2025-11-04 00:13:17.158644	2025-11-04 00:13:17.158644
341	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 07:13 WIB'.	\N	2025-11-04 00:13:20.36725	2025-11-04 00:13:20.36725
342	36	profile	update	Memperbarui data 'Data Diri' pada 'Selasa, 4 November 2025 pukul 08:20 WIB'.	\N	2025-11-04 01:20:36.009065	2025-11-04 01:20:36.009065
343	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Selasa, 4 November 2025 pukul 10:22 WIB'.	\N	2025-11-04 03:22:35.70652	2025-11-04 03:22:35.70652
344	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Selasa, 4 November 2025 pukul 10:22 WIB'.	\N	2025-11-04 03:22:49.299372	2025-11-04 03:22:49.299372
345	1	kmis	create	Menambahkan data 'List Topik' pada 'Selasa, 4 November 2025 pukul 10:31 WIB'.	\N	2025-11-04 03:31:53.909169	2025-11-04 03:31:53.909169
346	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 4 November 2025 pukul 10:35 WIB'.	\N	2025-11-04 03:35:18.337586	2025-11-04 03:35:18.337586
347	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 4 November 2025 pukul 10:43 WIB'.	\N	2025-11-04 03:43:55.395899	2025-11-04 03:43:55.395899
348	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 4 November 2025 pukul 10:44 WIB'.	\N	2025-11-04 03:44:55.627316	2025-11-04 03:44:55.627316
349	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 4 November 2025 pukul 10:46 WIB'.	\N	2025-11-04 03:46:36.005053	2025-11-04 03:46:36.005053
350	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 10:47 WIB'.	\N	2025-11-04 03:47:00.443889	2025-11-04 03:47:00.443889
351	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Selasa, 4 November 2025 pukul 10:49 WIB'.	\N	2025-11-04 03:49:20.27978	2025-11-04 03:49:20.27978
352	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 10:55 WIB'.	\N	2025-11-04 03:55:36.357639	2025-11-04 03:55:36.357639
353	1	master_data	update	Memperbarui data 'List Kategori Satwa' pada 'Selasa, 4 November 2025 pukul 11:28 WIB'.	\N	2025-11-04 04:28:57.433968	2025-11-04 04:28:57.433968
354	1	master_data	update	Memperbarui data 'List Kategori Satwa' pada 'Selasa, 4 November 2025 pukul 11:29 WIB'.	\N	2025-11-04 04:29:05.210004	2025-11-04 04:29:05.210004
355	1	master_data	update	Memperbarui data 'List Kategori Satwa' pada 'Selasa, 4 November 2025 pukul 11:29 WIB'.	\N	2025-11-04 04:29:23.188308	2025-11-04 04:29:23.188308
356	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 12:57 WIB'.	\N	2025-11-04 05:57:58.922022	2025-11-04 05:57:58.922022
357	41	monev	update	Memperbarui data 'Target Kegiatan Bulan 'Januari 2025' (update langsung)' pada 'Selasa, 4 November 2025 pukul 12:59 WIB'.	\N	2025-11-04 05:59:10.654831	2025-11-04 05:59:10.654831
358	41	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (pending update)' pada 'Selasa, 4 November 2025 pukul 12:59 WIB'.	\N	2025-11-04 05:59:32.463188	2025-11-04 05:59:32.463188
359	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Selasa, 4 November 2025 pukul 13:19 WIB'.	\N	2025-11-04 06:19:34.950694	2025-11-04 06:19:34.950694
360	1	monev	update	Memperbarui data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 13:40 WIB'.	\N	2025-11-04 06:40:23.601076	2025-11-04 06:40:23.601076
361	1	monev	update	Memperbarui data 'Verifikasi Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (APPROVED)' pada 'Selasa, 4 November 2025 pukul 13:41 WIB'.	\N	2025-11-04 06:41:05.864531	2025-11-04 06:41:05.864531
362	41	monev	create	Menambahkan data 'Target Kegiatan Bulan 'Januari 2025'  (pending update)' pada 'Selasa, 4 November 2025 pukul 13:41 WIB'.	\N	2025-11-04 06:41:54.415225	2025-11-04 06:41:54.415225
363	1	monev	update	Memperbarui data 'Verifikasi Target Bulan 'Januari 2025' (APPROVED)' pada 'Selasa, 4 November 2025 pukul 13:42 WIB'.	\N	2025-11-04 06:42:13.517418	2025-11-04 06:42:13.517418
364	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Selasa, 4 November 2025 pukul 13:42 WIB'.	\N	2025-11-04 06:42:19.564557	2025-11-04 06:42:19.564557
365	1	master_data	delete	Menghapus data 'List Kategori Divisi PIC' pada 'Selasa, 4 November 2025 pukul 13:47 WIB'.	\N	2025-11-04 06:47:07.602886	2025-11-04 06:47:07.602886
366	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 14:41 WIB'.	\N	2025-11-04 07:41:28.228308	2025-11-04 07:41:28.228308
367	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 14:41 WIB'.	\N	2025-11-04 07:41:59.867311	2025-11-04 07:41:59.867311
368	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 14:42 WIB'.	\N	2025-11-04 07:42:08.929656	2025-11-04 07:42:08.929656
369	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 14:42 WIB'.	\N	2025-11-04 07:42:18.7597	2025-11-04 07:42:18.7597
370	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 4 November 2025 pukul 14:42 WIB'.	\N	2025-11-04 07:42:26.856309	2025-11-04 07:42:26.856309
371	36	kmis	create	Menyimpan jawaban: quizId=3, selected=A, correct=true, progress=1/2	\N	2025-11-04 07:42:32.085384	2025-11-04 07:42:32.085384
372	36	kmis	create	Menyimpan jawaban: quizId=4, selected=C, correct=false, progress=2/2	\N	2025-11-04 07:42:34.393166	2025-11-04 07:42:34.393166
373	36	kmis	create	Menyelesaikan kuis dengan attempt_id=2 (answered=2/2, correct=1, score=50)	\N	2025-11-04 07:42:36.890309	2025-11-04 07:42:36.890309
374	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Selasa, 4 November 2025 pukul 20:25 WIB'.	\N	2025-11-04 13:25:58.823903	2025-11-04 13:25:58.823903
375	1	master_data	restore	Mengembalikan data 'List Kategori Divisi PIC' pada 'Rabu, 5 November 2025 pukul 05:16 WIB'.	\N	2025-11-04 22:16:10.039331	2025-11-04 22:16:10.039331
376	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Rabu, 5 November 2025 pukul 05:16 WIB'.	\N	2025-11-04 22:16:56.254755	2025-11-04 22:16:56.254755
377	41	monev	update	Memperbarui data 'Target Kegiatan Bulan 'Maret 2025' (update langsung)' pada 'Rabu, 5 November 2025 pukul 05:18 WIB'.	\N	2025-11-04 22:18:03.938653	2025-11-04 22:18:03.938653
378	41	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '2 2025' (pending update)' pada 'Rabu, 5 November 2025 pukul 05:26 WIB'.	\N	2025-11-04 22:26:46.766167	2025-11-04 22:26:46.766167
379	41	monev	create	Menambahkan data 'Target Kegiatan Bulan 'Maret 2025'  (pending update)' pada 'Rabu, 5 November 2025 pukul 05:27 WIB'.	\N	2025-11-04 22:27:10.139306	2025-11-04 22:27:10.139306
380	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Rabu, 5 November 2025 pukul 09:37 WIB'.	\N	2025-11-05 02:37:56.53397	2025-11-05 02:37:56.53397
381	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Rabu, 5 November 2025 pukul 09:43 WIB'.	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364
382	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Rabu, 5 November 2025 pukul 09:49 WIB'.	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154
383	39	monev	update	Memperbarui data 'Target Kegiatan Bulan 'Januari 2025' (update langsung)' pada 'Rabu, 5 November 2025 pukul 09:53 WIB'.	\N	2025-11-05 02:53:06.549751	2025-11-05 02:53:06.549751
384	39	monev	create	Menambahkan data 'Target Kegiatan Bulan 'Januari 2025'  (pending update)' pada 'Rabu, 5 November 2025 pukul 09:53 WIB'.	\N	2025-11-05 02:53:42.136557	2025-11-05 02:53:42.136557
385	1	monev	update	Memperbarui data 'Verifikasi Target Bulan 'Januari 2025' (APPROVED)' pada 'Rabu, 5 November 2025 pukul 09:54 WIB'.	\N	2025-11-05 02:54:26.923264	2025-11-05 02:54:26.923264
386	39	monev	create	Menambahkan data 'Target Kegiatan Bulan 'Januari 2025'  (pending update)' pada 'Rabu, 5 November 2025 pukul 09:55 WIB'.	\N	2025-11-05 02:55:05.78578	2025-11-05 02:55:05.78578
387	1	monev	update	Memperbarui data 'Verifikasi Target Bulan 'Januari 2025' (REJECTED)' pada 'Rabu, 5 November 2025 pukul 09:55 WIB'.	\N	2025-11-05 02:55:31.229148	2025-11-05 02:55:31.229148
388	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 09:58 WIB'.	\N	2025-11-05 02:58:49.746317	2025-11-05 02:58:49.746317
389	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 09:59 WIB'.	\N	2025-11-05 02:59:33.03786	2025-11-05 02:59:33.03786
390	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 10:00 WIB'.	\N	2025-11-05 03:00:23.812313	2025-11-05 03:00:23.812313
391	1	monev	update	Memperbarui data 'Kegiatan Kalender' pada 'Rabu, 5 November 2025 pukul 10:01 WIB'.	\N	2025-11-05 03:01:31.704314	2025-11-05 03:01:31.704314
392	1	master_data	create	Menambahkan data 'List Kategori Aktivitas Kegiatan' pada 'Rabu, 5 November 2025 pukul 10:01 WIB'.	\N	2025-11-05 03:01:50.985464	2025-11-05 03:01:50.985464
393	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Rabu, 5 November 2025 pukul 10:03 WIB'.	\N	2025-11-05 03:03:04.564183	2025-11-05 03:03:04.564183
394	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Rabu, 5 November 2025 pukul 10:04 WIB'.	\N	2025-11-05 03:04:01.820314	2025-11-05 03:04:01.820314
395	1	monev	delete	Menghapus data 'Kegiatan Kalender' pada 'Rabu, 5 November 2025 pukul 10:05 WIB'.	\N	2025-11-05 03:05:42.428891	2025-11-05 03:05:42.428891
396	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Rabu, 5 November 2025 pukul 10:11 WIB'.	\N	2025-11-05 03:11:14.633501	2025-11-05 03:11:14.633501
397	1	monev	create	Menambahkan data 'List Aktivitas Paket Kegiatan' pada 'Rabu, 5 November 2025 pukul 10:13 WIB'.	\N	2025-11-05 03:13:35.385911	2025-11-05 03:13:35.385911
398	41	monev	update	Memperbarui data 'Target Kegiatan Bulan 'Januari 2025' (update langsung)' pada 'Rabu, 5 November 2025 pukul 10:14 WIB'.	\N	2025-11-05 03:14:14.827975	2025-11-05 03:14:14.827975
399	41	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (pending update)' pada 'Rabu, 5 November 2025 pukul 10:17 WIB'.	\N	2025-11-05 03:17:07.531166	2025-11-05 03:17:07.531166
400	1	monev	update	Memperbarui data 'Verifikasi Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (APPROVED)' pada 'Rabu, 5 November 2025 pukul 10:17 WIB'.	\N	2025-11-05 03:17:29.851937	2025-11-05 03:17:29.851937
401	41	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (pending update)' pada 'Rabu, 5 November 2025 pukul 10:17 WIB'.	\N	2025-11-05 03:17:57.341443	2025-11-05 03:17:57.341443
402	1	monev	update	Memperbarui data 'Verifikasi Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (APPROVED)' pada 'Rabu, 5 November 2025 pukul 10:33 WIB'.	\N	2025-11-05 03:33:29.712261	2025-11-05 03:33:29.712261
403	41	monev	create	Menambahkan data 'Realisasi Bulanan Kegiatan di Bulan '0 2025' (pending update)' pada 'Rabu, 5 November 2025 pukul 10:34 WIB'.	\N	2025-11-05 03:34:11.826833	2025-11-05 03:34:11.826833
404	1	monev	update	Memperbarui data 'Verifikasi Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (APPROVED)' pada 'Rabu, 5 November 2025 pukul 10:34 WIB'.	\N	2025-11-05 03:34:32.12451	2025-11-05 03:34:32.12451
405	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:46 WIB'.	\N	2025-11-05 03:46:58.380839	2025-11-05 03:46:58.380839
406	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:51 WIB'.	\N	2025-11-05 03:51:20.52884	2025-11-05 03:51:20.52884
407	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:55 WIB'.	\N	2025-11-05 03:55:27.269848	2025-11-05 03:55:27.269848
408	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:55 WIB'.	\N	2025-11-05 03:55:32.812262	2025-11-05 03:55:32.812262
409	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:56 WIB'.	\N	2025-11-05 03:56:38.664937	2025-11-05 03:56:38.664937
410	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:56 WIB'.	\N	2025-11-05 03:56:53.13444	2025-11-05 03:56:53.13444
411	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:56 WIB'.	\N	2025-11-05 03:56:59.849309	2025-11-05 03:56:59.849309
412	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:57 WIB'.	\N	2025-11-05 03:57:09.253834	2025-11-05 03:57:09.253834
413	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 10:58 WIB'.	\N	2025-11-05 03:58:16.933311	2025-11-05 03:58:16.933311
414	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 11:23 WIB'.	\N	2025-11-05 04:23:25.132504	2025-11-05 04:23:25.132504
415	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Rabu, 5 November 2025 pukul 11:26 WIB'.	\N	2025-11-05 04:26:22.692206	2025-11-05 04:26:22.692206
416	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 11:40 WIB'.	\N	2025-11-05 04:40:49.047638	2025-11-05 04:40:49.047638
417	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 11:41 WIB'.	\N	2025-11-05 04:41:12.537447	2025-11-05 04:41:12.537447
418	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 11:42 WIB'.	\N	2025-11-05 04:42:22.057661	2025-11-05 04:42:22.057661
419	1	monev	update	Memperbarui data 'Realisasi Bulanan Kegiatan di Bulan 'Januari 2025' (update langsung oleh superadmin)' pada 'Rabu, 5 November 2025 pukul 11:44 WIB'.	\N	2025-11-05 04:44:12.646768	2025-11-05 04:44:12.646768
420	1	master_data	update	Memperbarui data 'List Kategori Satwa' pada 'Rabu, 5 November 2025 pukul 11:49 WIB'.	\N	2025-11-05 04:49:24.671311	2025-11-05 04:49:24.671311
421	1	monev	delete	Menghapus data 'List Aktivitas Paket Kegiatan' pada 'Kamis, 6 November 2025 pukul 05:54 WIB'.	\N	2025-11-05 22:53:59.686969	2025-11-05 22:53:59.686969
422	1	master_data	delete	Menghapus data 'List Kategori Divisi PIC' pada 'Kamis, 6 November 2025 pukul 05:54 WIB'.	\N	2025-11-05 22:54:07.395447	2025-11-05 22:54:07.395447
423	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 9 November 2025 pukul 21:48 WIB'.	\N	2025-11-09 14:48:43.33884	2025-11-09 14:48:43.33884
424	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 9 November 2025 pukul 21:49 WIB'.	\N	2025-11-09 14:49:04.14332	2025-11-09 14:49:04.14332
425	3	profile	update	Memperbarui data 'Data Diri' pada 'Kamis, 13 November 2025 pukul 09:17 WIB'.	\N	2025-11-13 02:17:30.435155	2025-11-13 02:17:30.435155
426	3	profile	update	Memperbarui data 'Data Diri' pada 'Kamis, 13 November 2025 pukul 09:17 WIB'.	\N	2025-11-13 02:17:40.317724	2025-11-13 02:17:40.317724
427	3	profile	update	Memperbarui data 'Data Diri' pada 'Kamis, 13 November 2025 pukul 09:17 WIB'.	\N	2025-11-13 02:17:58.83331	2025-11-13 02:17:58.83331
428	1	kmis	create	Menambahkan data 'Akun Pengajar' pada 'Kamis, 13 November 2025 pukul 09:18 WIB'.	\N	2025-11-13 02:18:49.220929	2025-11-13 02:18:49.220929
429	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 13 November 2025 pukul 11:34 WIB'.	\N	2025-11-13 04:34:35.836219	2025-11-13 04:34:35.836219
430	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Kamis, 13 November 2025 pukul 11:34 WIB'.	\N	2025-11-13 04:34:55.638241	2025-11-13 04:34:55.638241
431	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 13 November 2025 pukul 11:37 WIB'.	\N	2025-11-13 04:37:33.147127	2025-11-13 04:37:33.147127
432	42	kmis	update	Memperbarui data 'List Materi' pada 'Kamis, 13 November 2025 pukul 11:38 WIB'.	\N	2025-11-13 04:38:03.619506	2025-11-13 04:38:03.619506
433	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Kamis, 13 November 2025 pukul 14:28 WIB'.	\N	2025-11-13 07:28:09.891723	2025-11-13 07:28:09.891723
434	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Kamis, 13 November 2025 pukul 23:34 WIB'.	\N	2025-11-13 16:34:52.321207	2025-11-13 16:34:52.321207
435	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Kamis, 13 November 2025 pukul 23:35 WIB'.	\N	2025-11-13 16:35:00.950309	2025-11-13 16:35:00.950309
436	1	cms	update	Memperbarui data 'List Komposisi Satwa' pada 'Senin, 17 November 2025 pukul 08:00 WIB'.	\N	2025-11-17 01:00:44.035241	2025-11-17 01:00:44.035241
437	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 17 November 2025 pukul 08:01 WIB'.	\N	2025-11-17 01:01:34.548885	2025-11-17 01:01:34.548885
438	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 17 November 2025 pukul 13:49 WIB'.	\N	2025-11-17 06:49:26.602344	2025-11-17 06:49:26.602344
439	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 17 November 2025 pukul 14:01 WIB'.	\N	2025-11-17 07:01:27.941043	2025-11-17 07:01:27.941043
440	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 17 November 2025 pukul 14:03 WIB'.	\N	2025-11-17 07:03:12.344516	2025-11-17 07:03:12.344516
441	43	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 17 November 2025 pukul 14:06 WIB'.	\N	2025-11-17 07:06:00.661009	2025-11-17 07:06:00.661009
442	43	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 17 November 2025 pukul 14:06 WIB'.	\N	2025-11-17 07:06:20.053342	2025-11-17 07:06:20.053342
443	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 17 November 2025 pukul 19:39 WIB'.	\N	2025-11-17 12:39:00.110847	2025-11-17 12:39:00.110847
444	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 17 November 2025 pukul 19:39 WIB'.	\N	2025-11-17 12:39:06.0469	2025-11-17 12:39:06.0469
445	42	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Selasa, 18 November 2025 pukul 14:00 WIB'.	\N	2025-11-18 07:00:27.699478	2025-11-18 07:00:27.699478
446	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Rabu, 19 November 2025 pukul 01:46 WIB'.	\N	2025-11-18 18:46:16.697769	2025-11-18 18:46:16.697769
447	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Rabu, 19 November 2025 pukul 01:46 WIB'.	\N	2025-11-18 18:46:48.904907	2025-11-18 18:46:48.904907
448	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Rabu, 19 November 2025 pukul 01:47 WIB'.	\N	2025-11-18 18:47:17.774998	2025-11-18 18:47:17.774998
449	1	kmis	create	Menambahkan data 'List Kategori' pada 'Rabu, 19 November 2025 pukul 02:45 WIB'.	\N	2025-11-18 19:45:44.505727	2025-11-18 19:45:44.505727
450	1	kmis	create	Menambahkan data 'List Topik' pada 'Rabu, 19 November 2025 pukul 03:05 WIB'.	\N	2025-11-18 20:05:10.748324	2025-11-18 20:05:10.748324
451	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 13:27 WIB'.	\N	2025-11-19 06:27:17.556807	2025-11-19 06:27:17.556807
452	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 13:29 WIB'.	\N	2025-11-19 06:29:18.843328	2025-11-19 06:29:18.843328
453	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 13:36 WIB'.	\N	2025-11-19 06:36:36.66136	2025-11-19 06:36:36.66136
454	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 13:46 WIB'.	\N	2025-11-19 06:46:08.913799	2025-11-19 06:46:08.913799
455	42	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 14:36 WIB'.	\N	2025-11-19 07:36:36.116086	2025-11-19 07:36:36.116086
456	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 14:56 WIB'.	\N	2025-11-19 07:56:04.237339	2025-11-19 07:56:04.237339
457	1	kmis	delete	Menghapus data 'List Soal Pertanyaan' pada 'Rabu, 19 November 2025 pukul 14:57 WIB'.	\N	2025-11-19 07:57:29.377312	2025-11-19 07:57:29.377312
458	1	kmis	restore	Mengembalikan data 'List Soal Pertanyaan' pada 'Rabu, 19 November 2025 pukul 15:32 WIB'.	\N	2025-11-19 08:32:22.599545	2025-11-19 08:32:22.599545
459	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 15:46 WIB'.	\N	2025-11-19 08:46:17.914322	2025-11-19 08:46:17.914322
460	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 15:47 WIB'.	\N	2025-11-19 08:47:57.598686	2025-11-19 08:47:57.598686
461	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 15:48 WIB'.	\N	2025-11-19 08:48:20.295315	2025-11-19 08:48:20.295315
462	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 15:52 WIB'.	\N	2025-11-19 08:52:11.198255	2025-11-19 08:52:11.198255
463	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:11 WIB'.	\N	2025-11-19 09:11:55.363313	2025-11-19 09:11:55.363313
464	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:20 WIB'.	\N	2025-11-19 09:20:38.076918	2025-11-19 09:20:38.076918
465	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:40 WIB'.	\N	2025-11-19 09:40:34.258736	2025-11-19 09:40:34.258736
466	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:43 WIB'.	\N	2025-11-19 09:43:49.634317	2025-11-19 09:43:49.634317
467	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:54 WIB'.	\N	2025-11-19 09:54:32.432174	2025-11-19 09:54:32.432174
468	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:54 WIB'.	\N	2025-11-19 09:54:36.071304	2025-11-19 09:54:36.071304
469	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:54 WIB'.	\N	2025-11-19 09:54:38.264004	2025-11-19 09:54:38.264004
470	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:54 WIB'.	\N	2025-11-19 09:54:40.919927	2025-11-19 09:54:40.919927
471	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:54 WIB'.	\N	2025-11-19 09:54:47.806594	2025-11-19 09:54:47.806594
472	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:54 WIB'.	\N	2025-11-19 09:54:51.648651	2025-11-19 09:54:51.648651
473	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:55 WIB'.	\N	2025-11-19 09:55:10.071686	2025-11-19 09:55:10.071686
474	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:55 WIB'.	\N	2025-11-19 09:55:30.749313	2025-11-19 09:55:30.749313
475	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Rabu, 19 November 2025 pukul 16:57 WIB'.	\N	2025-11-19 09:57:13.779305	2025-11-19 09:57:13.779305
476	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Rabu, 19 November 2025 pukul 16:57 WIB'.	\N	2025-11-19 09:57:29.954443	2025-11-19 09:57:29.954443
477	1	kmis	delete	Menghapus data 'List Materi' pada 'Rabu, 19 November 2025 pukul 17:03 WIB'.	\N	2025-11-19 10:03:49.760247	2025-11-19 10:03:49.760247
478	1	kmis	restore	Mengembalikan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 06:53 WIB'.	\N	2025-11-19 23:53:05.700211	2025-11-19 23:53:05.700211
479	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Kamis, 20 November 2025 pukul 06:53 WIB'.	\N	2025-11-19 23:53:20.275751	2025-11-19 23:53:20.275751
480	1	kmis	delete	Menghapus data 'List Materi' pada 'Kamis, 20 November 2025 pukul 06:53 WIB'.	\N	2025-11-19 23:53:28.172315	2025-11-19 23:53:28.172315
481	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 08:53 WIB'.	\N	2025-11-20 01:53:01.952253	2025-11-20 01:53:01.952253
482	42	kmis	delete	Menghapus data 'List Materi' pada 'Kamis, 20 November 2025 pukul 08:53 WIB'.	\N	2025-11-20 01:53:41.52831	2025-11-20 01:53:41.52831
483	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 09:03 WIB'.	\N	2025-11-20 02:03:19.497577	2025-11-20 02:03:19.497577
484	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 09:12 WIB'.	\N	2025-11-20 02:12:36.732352	2025-11-20 02:12:36.732352
485	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Kamis, 20 November 2025 pukul 10:34 WIB'.	\N	2025-11-20 03:34:55.004325	2025-11-20 03:34:55.004325
486	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Kamis, 20 November 2025 pukul 10:35 WIB'.	\N	2025-11-20 03:35:14.40738	2025-11-20 03:35:14.40738
487	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 11:37 WIB'.	\N	2025-11-20 04:37:50.796726	2025-11-20 04:37:50.796726
488	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 11:39 WIB'.	\N	2025-11-20 04:39:11.118572	2025-11-20 04:39:11.118572
489	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 11:39 WIB'.	\N	2025-11-20 04:39:21.875714	2025-11-20 04:39:21.875714
490	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Kamis, 20 November 2025 pukul 11:50 WIB'.	\N	2025-11-20 04:50:53.804705	2025-11-20 04:50:53.804705
491	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 13:18 WIB'.	\N	2025-11-20 06:18:28.045174	2025-11-20 06:18:28.045174
492	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 13:18 WIB'.	\N	2025-11-20 06:18:58.571884	2025-11-20 06:18:58.571884
493	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 14:40 WIB'.	\N	2025-11-20 07:40:00.42659	2025-11-20 07:40:00.42659
494	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Kamis, 20 November 2025 pukul 14:41 WIB'.	\N	2025-11-20 07:41:06.972318	2025-11-20 07:41:06.972318
495	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 15:07 WIB'.	\N	2025-11-20 08:07:31.083332	2025-11-20 08:07:31.083332
496	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 20 November 2025 pukul 15:11 WIB'.	\N	2025-11-20 08:11:15.634527	2025-11-20 08:11:15.634527
497	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 20:28 WIB'.	\N	2025-11-20 13:28:42.867596	2025-11-20 13:28:42.867596
498	42	kmis	update	Memperbarui data 'List Materi' pada 'Kamis, 20 November 2025 pukul 20:29 WIB'.	\N	2025-11-20 13:29:09.247829	2025-11-20 13:29:09.247829
499	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 20:34 WIB'.	\N	2025-11-20 13:34:56.962324	2025-11-20 13:34:56.962324
500	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 20:39 WIB'.	\N	2025-11-20 13:38:59.055646	2025-11-20 13:38:59.055646
501	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 20:49 WIB'.	\N	2025-11-20 13:49:15.675207	2025-11-20 13:49:15.675207
502	42	kmis	create	Menambahkan data 'List Materi' pada 'Kamis, 20 November 2025 pukul 20:53 WIB'.	\N	2025-11-20 13:53:19.499318	2025-11-20 13:53:19.499318
503	1	kmis	update	Memperbarui data 'List Topik' pada 'Jumat, 21 November 2025 pukul 12:59 WIB'.	\N	2025-11-21 05:59:41.366015	2025-11-21 05:59:41.366015
504	1	kmis	update	Memperbarui data 'List Topik' pada 'Jumat, 21 November 2025 pukul 12:59 WIB'.	\N	2025-11-21 05:59:47.711539	2025-11-21 05:59:47.711539
505	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 13:56 WIB'.	\N	2025-11-21 06:56:50.290013	2025-11-21 06:56:50.290013
506	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 13:56 WIB'.	\N	2025-11-21 06:56:54.229236	2025-11-21 06:56:54.229236
507	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 13:57 WIB'.	\N	2025-11-21 06:57:46.245166	2025-11-21 06:57:46.245166
508	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 13:57 WIB'.	\N	2025-11-21 06:57:52.113761	2025-11-21 06:57:52.113761
509	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 14:00 WIB'.	\N	2025-11-21 07:00:14.082564	2025-11-21 07:00:14.082564
510	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 15:02 WIB'.	\N	2025-11-21 08:02:27.481003	2025-11-21 08:02:27.481003
511	1	kmis	update	Memperbarui data 'List Topik' pada 'Jumat, 21 November 2025 pukul 15:06 WIB'.	\N	2025-11-21 08:06:41.273032	2025-11-21 08:06:41.273032
512	1	kmis	create	Menambahkan data 'List Topik' pada 'Jumat, 21 November 2025 pukul 15:12 WIB'.	\N	2025-11-21 08:12:52.737841	2025-11-21 08:12:52.737841
513	1	kmis	update	Memperbarui data 'List Topik' pada 'Jumat, 21 November 2025 pukul 15:13 WIB'.	\N	2025-11-21 08:13:08.36131	2025-11-21 08:13:08.36131
514	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 15:38 WIB'.	\N	2025-11-21 08:38:33.102538	2025-11-21 08:38:33.102538
515	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 16:03 WIB'.	\N	2025-11-21 09:03:24.792865	2025-11-21 09:03:24.792865
516	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 16:03 WIB'.	\N	2025-11-21 09:03:40.14434	2025-11-21 09:03:40.14434
517	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Jumat, 21 November 2025 pukul 16:12 WIB'.	\N	2025-11-21 09:12:31.498911	2025-11-21 09:12:31.498911
518	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 21 November 2025 pukul 16:35 WIB'.	\N	2025-11-21 09:35:54.108427	2025-11-21 09:35:54.108427
519	1	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 21 November 2025 pukul 19:07 WIB'.	\N	2025-11-21 12:07:33.693889	2025-11-21 12:07:33.693889
520	1	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 21 November 2025 pukul 19:07 WIB'.	\N	2025-11-21 12:07:47.012483	2025-11-21 12:07:47.012483
521	1	kmis	update	Memperbarui data 'Akun Pengajar' pada 'Sabtu, 22 November 2025 pukul 13:47 WIB'.	\N	2025-11-22 06:47:29.14317	2025-11-22 06:47:29.14317
522	1	kmis	update	Memperbarui data 'Akun Pengajar' pada 'Minggu, 23 November 2025 pukul 15:11 WIB'.	\N	2025-11-23 08:11:18.084441	2025-11-23 08:11:18.084441
523	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:11 WIB'.	\N	2025-11-23 08:11:27.386353	2025-11-23 08:11:27.386353
524	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:11 WIB'.	\N	2025-11-23 08:11:55.816135	2025-11-23 08:11:55.816135
525	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:12 WIB'.	\N	2025-11-23 08:12:39.662643	2025-11-23 08:12:39.662643
526	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:14 WIB'.	\N	2025-11-23 08:14:06.846538	2025-11-23 08:14:06.846538
527	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:14 WIB'.	\N	2025-11-23 08:14:13.907209	2025-11-23 08:14:13.907209
528	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:14 WIB'.	\N	2025-11-23 08:14:57.461138	2025-11-23 08:14:57.461138
529	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:15 WIB'.	\N	2025-11-23 08:15:04.025576	2025-11-23 08:15:04.025576
530	1	kmis	update	Memperbarui data 'List Topik' pada 'Minggu, 23 November 2025 pukul 15:15 WIB'.	\N	2025-11-23 08:15:09.276891	2025-11-23 08:15:09.276891
531	1	kmis	delete	Menghapus data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:45 WIB'.	\N	2025-11-24 08:45:17.582356	2025-11-24 08:45:17.582356
532	1	kmis	restore	Mengembalikan data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:45 WIB'.	\N	2025-11-24 08:45:39.336105	2025-11-24 08:45:39.336105
533	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:46 WIB'.	\N	2025-11-24 08:46:41.686975	2025-11-24 08:46:41.686975
534	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:46 WIB'.	\N	2025-11-24 08:46:48.078858	2025-11-24 08:46:48.078858
535	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:46 WIB'.	\N	2025-11-24 08:46:54.583246	2025-11-24 08:46:54.583246
536	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:47 WIB'.	\N	2025-11-24 08:47:00.676408	2025-11-24 08:47:00.676408
537	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:47 WIB'.	\N	2025-11-24 08:47:47.75359	2025-11-24 08:47:47.75359
538	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:48 WIB'.	\N	2025-11-24 08:48:04.840307	2025-11-24 08:48:04.840307
539	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:48 WIB'.	\N	2025-11-24 08:48:12.561186	2025-11-24 08:48:12.561186
540	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:48 WIB'.	\N	2025-11-24 08:48:30.544798	2025-11-24 08:48:30.544798
541	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:48 WIB'.	\N	2025-11-24 08:48:41.525199	2025-11-24 08:48:41.525199
542	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:48 WIB'.	\N	2025-11-24 08:48:49.458257	2025-11-24 08:48:49.458257
543	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:48 WIB'.	\N	2025-11-24 08:48:56.126962	2025-11-24 08:48:56.126962
544	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:49 WIB'.	\N	2025-11-24 08:49:04.735808	2025-11-24 08:49:04.735808
545	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:49 WIB'.	\N	2025-11-24 08:49:15.447953	2025-11-24 08:49:15.447953
546	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:54 WIB'.	\N	2025-11-24 08:54:43.076441	2025-11-24 08:54:43.076441
547	1	kmis	delete	Menghapus data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:55 WIB'.	\N	2025-11-24 08:55:16.470164	2025-11-24 08:55:16.470164
548	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 24 November 2025 pukul 15:55 WIB'.	\N	2025-11-24 08:55:39.792953	2025-11-24 08:55:39.792953
549	2	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 25 November 2025 pukul 14:30 WIB'.	\N	2025-11-25 07:30:37.786888	2025-11-25 07:30:37.786888
550	2	kmis	update	Memperbarui data 'List Materi' pada 'Selasa, 25 November 2025 pukul 14:39 WIB'.	\N	2025-11-25 07:39:24.062911	2025-11-25 07:39:24.062911
551	2	kmis	delete	Menghapus data 'List Materi' pada 'Selasa, 25 November 2025 pukul 14:41 WIB'.	\N	2025-11-25 07:41:42.300619	2025-11-25 07:41:42.300619
552	44	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 25 November 2025 pukul 14:46 WIB'.	\N	2025-11-25 07:46:29.784809	2025-11-25 07:46:29.784809
553	44	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 25 November 2025 pukul 14:47 WIB'.	\N	2025-11-25 07:47:23.037167	2025-11-25 07:47:23.037167
554	44	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 25 November 2025 pukul 14:47 WIB'.	\N	2025-11-25 07:47:28.303169	2025-11-25 07:47:28.303169
555	44	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 25 November 2025 pukul 14:51 WIB'.	\N	2025-11-25 07:51:26.928642	2025-11-25 07:51:26.928642
556	42	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 25 November 2025 pukul 14:53 WIB'.	\N	2025-11-25 07:53:43.094184	2025-11-25 07:53:43.094184
557	42	kmis	update	Memperbarui data 'List Materi' pada 'Selasa, 25 November 2025 pukul 14:56 WIB'.	\N	2025-11-25 07:56:49.155038	2025-11-25 07:56:49.155038
558	42	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 25 November 2025 pukul 15:00 WIB'.	\N	2025-11-25 08:00:51.385171	2025-11-25 08:00:51.385171
559	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:16 WIB'.	\N	2025-11-26 07:16:18.360518	2025-11-26 07:16:18.360518
560	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:28 WIB'.	\N	2025-11-26 07:28:27.43418	2025-11-26 07:28:27.43418
561	42	kmis	update	Memperbarui data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:28 WIB'.	\N	2025-11-26 07:28:50.71445	2025-11-26 07:28:50.71445
562	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:31 WIB'.	\N	2025-11-26 07:31:47.189122	2025-11-26 07:31:47.189122
563	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:34 WIB'.	\N	2025-11-26 07:34:48.256951	2025-11-26 07:34:48.256951
564	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:35 WIB'.	\N	2025-11-26 07:35:49.799957	2025-11-26 07:35:49.799957
565	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:38 WIB'.	\N	2025-11-26 07:38:14.325721	2025-11-26 07:38:14.325721
566	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:41 WIB'.	\N	2025-11-26 07:41:06.62578	2025-11-26 07:41:06.62578
567	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:48 WIB'.	\N	2025-11-26 07:48:49.931477	2025-11-26 07:48:49.931477
568	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:51 WIB'.	\N	2025-11-26 07:51:02.343176	2025-11-26 07:51:02.343176
569	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:53 WIB'.	\N	2025-11-26 07:53:44.062178	2025-11-26 07:53:44.062178
570	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:55 WIB'.	\N	2025-11-26 07:55:25.40218	2025-11-26 07:55:25.40218
571	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 14:58 WIB'.	\N	2025-11-26 07:58:00.392564	2025-11-26 07:58:00.392564
572	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:01 WIB'.	\N	2025-11-26 08:01:55.627176	2025-11-26 08:01:55.627176
573	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:04 WIB'.	\N	2025-11-26 08:04:53.248114	2025-11-26 08:04:53.248114
574	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:08 WIB'.	\N	2025-11-26 08:08:13.828679	2025-11-26 08:08:13.828679
575	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:12 WIB'.	\N	2025-11-26 08:12:47.984793	2025-11-26 08:12:47.984793
576	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:22 WIB'.	\N	2025-11-26 08:22:32.058182	2025-11-26 08:22:32.058182
577	42	kmis	create	Menambahkan data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:26 WIB'.	\N	2025-11-26 08:26:53.338173	2025-11-26 08:26:53.338173
578	42	kmis	update	Memperbarui data 'List Materi' pada 'Rabu, 26 November 2025 pukul 15:27 WIB'.	\N	2025-11-26 08:27:22.680564	2025-11-26 08:27:22.680564
579	1	kmis	update	Memperbarui data 'List Materi' pada 'Rabu, 26 November 2025 pukul 22:59 WIB'.	\N	2025-11-26 15:59:19.955268	2025-11-26 15:59:19.955268
580	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:03 WIB'.	\N	2025-11-26 16:03:48.850413	2025-11-26 16:03:48.850413
581	1	kmis	update	Memperbarui data 'List Materi' pada 'Rabu, 26 November 2025 pukul 23:06 WIB'.	\N	2025-11-26 16:06:28.081427	2025-11-26 16:06:28.081427
582	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:07 WIB'.	\N	2025-11-26 16:07:37.900078	2025-11-26 16:07:37.900078
583	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:08 WIB'.	\N	2025-11-26 16:08:01.809542	2025-11-26 16:08:01.809542
584	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:08 WIB'.	\N	2025-11-26 16:08:24.862105	2025-11-26 16:08:24.862105
585	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:08 WIB'.	\N	2025-11-26 16:08:50.833561	2025-11-26 16:08:50.833561
586	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:09 WIB'.	\N	2025-11-26 16:09:31.205197	2025-11-26 16:09:31.205197
587	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:12 WIB'.	\N	2025-11-26 16:12:17.419173	2025-11-26 16:12:17.419173
588	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:13 WIB'.	\N	2025-11-26 16:13:00.716369	2025-11-26 16:13:00.716369
589	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:13 WIB'.	\N	2025-11-26 16:13:27.649715	2025-11-26 16:13:27.649715
590	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:13 WIB'.	\N	2025-11-26 16:13:46.973586	2025-11-26 16:13:46.973586
591	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:14 WIB'.	\N	2025-11-26 16:14:13.287492	2025-11-26 16:14:13.287492
592	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:15 WIB'.	\N	2025-11-26 16:15:08.774099	2025-11-26 16:15:08.774099
593	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:15 WIB'.	\N	2025-11-26 16:15:32.236105	2025-11-26 16:15:32.236105
594	1	kmis	update	Memperbarui data 'List Topik' pada 'Rabu, 26 November 2025 pukul 23:15 WIB'.	\N	2025-11-26 16:15:41.433002	2025-11-26 16:15:41.433002
595	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 10:27 WIB'.	\N	2025-11-27 03:27:43.365464	2025-11-27 03:27:43.365464
596	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 10:37 WIB'.	\N	2025-11-27 03:37:46.050003	2025-11-27 03:37:46.050003
597	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:35 WIB'.	\N	2025-11-27 06:35:28.180433	2025-11-27 06:35:28.180433
598	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:35 WIB'.	\N	2025-11-27 06:35:37.068174	2025-11-27 06:35:37.068174
599	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:35 WIB'.	\N	2025-11-27 06:35:59.19225	2025-11-27 06:35:59.19225
600	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:07.144523	2025-11-27 06:36:07.144523
601	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:19.970166	2025-11-27 06:36:19.970166
602	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:28.010485	2025-11-27 06:36:28.010485
603	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:35.691255	2025-11-27 06:36:35.691255
604	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:44.310369	2025-11-27 06:36:44.310369
605	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:51.392756	2025-11-27 06:36:51.392756
606	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:36 WIB'.	\N	2025-11-27 06:36:57.719158	2025-11-27 06:36:57.719158
607	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:37 WIB'.	\N	2025-11-27 06:37:05.141796	2025-11-27 06:37:05.141796
608	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:37 WIB'.	\N	2025-11-27 06:37:18.4349	2025-11-27 06:37:18.4349
609	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:37 WIB'.	\N	2025-11-27 06:37:26.000902	2025-11-27 06:37:26.000902
610	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 13:52 WIB'.	\N	2025-11-27 06:52:53.807128	2025-11-27 06:52:53.807128
611	1	monev	update	Memperbarui data 'Target Kegiatan Bulan '7 2025' (update langsung oleh superadmin)' pada 'Kamis, 27 November 2025 pukul 14:29 WIB'.	\N	2025-11-27 07:29:01.192954	2025-11-27 07:29:01.192954
612	1	master_data	create	Menambahkan data 'List Kategori Divisi PIC' pada 'Kamis, 27 November 2025 pukul 14:32 WIB'.	\N	2025-11-27 07:32:11.042092	2025-11-27 07:32:11.042092
613	1	kmis	update	Memperbarui data 'List Topik' pada 'Kamis, 27 November 2025 pukul 14:33 WIB'.	\N	2025-11-27 07:33:38.175673	2025-11-27 07:33:38.175673
614	1	monev	create	Menambahkan data 'Kegiatan Kalender' pada 'Kamis, 27 November 2025 pukul 14:37 WIB'.	\N	2025-11-27 07:37:08.866624	2025-11-27 07:37:08.866624
615	1	master_data	create	Menambahkan data 'Dashboard Monev' pada 'Kamis, 27 November 2025 pukul 14:38 WIB'.	\N	2025-11-27 07:38:45.125715	2025-11-27 07:38:45.125715
616	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 15 Desember 2025 pukul 10:28 WIB'.	\N	2025-12-15 03:28:33.370968	2025-12-15 03:28:33.370968
621	1	kmis	update	Memperbarui data 'List Materi' pada 'Jumat, 19 Desember 2025 pukul 11:20 WIB'.	\N	2025-12-19 04:20:20.572739	2025-12-19 04:20:20.572739
626	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:01 WIB'.	\N	2025-12-19 15:01:19.982248	2025-12-19 15:01:19.982248
631	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:04 WIB'.	\N	2025-12-19 15:04:44.196339	2025-12-19 15:04:44.196339
636	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:20 WIB'.	\N	2025-12-19 15:20:39.739383	2025-12-19 15:20:39.739383
643	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 23:17 WIB'.	\N	2025-12-19 16:17:34.959922	2025-12-19 16:17:34.959922
648	1	cms	create	Menambahkan data 'List Berita' pada 'Jumat, 19 Desember 2025 pukul 23:28 WIB'.	\N	2025-12-19 16:28:57.022699	2025-12-19 16:28:57.022699
653	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:16 WIB'.	\N	2025-12-20 01:16:51.405234	2025-12-20 01:16:51.405234
658	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 20 Desember 2025 pukul 08:32 WIB'.	\N	2025-12-20 01:32:26.291924	2025-12-20 01:32:26.291924
663	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 08:35 WIB'.	\N	2025-12-20 01:35:08.260992	2025-12-20 01:35:08.260992
669	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 08:59 WIB'.	\N	2025-12-20 01:59:16.898314	2025-12-20 01:59:16.898314
674	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:22 WIB'.	\N	2025-12-20 02:22:02.219831	2025-12-20 02:22:02.219831
679	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:02.329475	2025-12-20 02:23:02.329475
684	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:42.598595	2025-12-20 02:23:42.598595
687	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:24 WIB'.	\N	2025-12-20 02:24:04.825448	2025-12-20 02:24:04.825448
693	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:27 WIB'.	\N	2025-12-20 02:27:33.683351	2025-12-20 02:27:33.683351
698	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:30 WIB'.	\N	2025-12-20 02:30:45.170428	2025-12-20 02:30:45.170428
703	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:36 WIB'.	\N	2025-12-20 02:36:39.989621	2025-12-20 02:36:39.989621
708	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:39 WIB'.	\N	2025-12-20 02:39:40.199677	2025-12-20 02:39:40.199677
713	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:08 WIB'.	\N	2025-12-20 03:08:12.329776	2025-12-20 03:08:12.329776
718	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:32 WIB'.	\N	2025-12-20 03:32:25.892417	2025-12-20 03:32:25.892417
723	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:55 WIB'.	\N	2025-12-20 03:55:12.505076	2025-12-20 03:55:12.505076
729	1	cms	update	Memperbarui data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:24 WIB'.	\N	2025-12-21 11:24:02.97179	2025-12-21 11:24:02.97179
737	1	cms	update	Memperbarui data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 20:43 WIB'.	\N	2025-12-21 13:43:21.885965	2025-12-21 13:43:21.885965
743	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:09 WIB'.	\N	2025-12-21 16:09:00.879616	2025-12-21 16:09:00.879616
748	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Minggu, 21 Desember 2025 pukul 23:18 WIB'.	\N	2025-12-21 16:18:26.29544	2025-12-21 16:18:26.29544
753	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:44 WIB'.	\N	2025-12-21 16:44:54.955369	2025-12-21 16:44:54.955369
758	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:51 WIB'.	\N	2025-12-21 16:51:50.198244	2025-12-21 16:51:50.198244
763	1	kmis	create	Menambahkan data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 11:08 WIB'.	\N	2025-12-22 04:08:56.279128	2025-12-22 04:08:56.279128
782	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:08 WIB'.	\N	2025-12-22 07:08:20.853727	2025-12-22 07:08:20.853727
788	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:11 WIB'.	\N	2025-12-22 07:11:53.869961	2025-12-22 07:11:53.869961
793	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:12 WIB'.	\N	2025-12-22 07:12:53.499686	2025-12-22 07:12:53.499686
800	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:15 WIB'.	\N	2025-12-22 07:15:04.553464	2025-12-22 07:15:04.553464
805	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:52 WIB'.	\N	2025-12-22 07:52:21.82625	2025-12-22 07:52:21.82625
810	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:54 WIB'.	\N	2025-12-22 07:54:16.009243	2025-12-22 07:54:16.009243
815	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:56 WIB'.	\N	2025-12-22 07:56:34.019897	2025-12-22 07:56:34.019897
821	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:01 WIB'.	\N	2025-12-22 08:01:46.165532	2025-12-22 08:01:46.165532
826	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:23 WIB'.	\N	2025-12-22 08:23:42.459777	2025-12-22 08:23:42.459777
830	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:26 WIB'.	\N	2025-12-22 08:26:29.403324	2025-12-22 08:26:29.403324
834	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:28 WIB'.	\N	2025-12-22 08:28:35.746213	2025-12-22 08:28:35.746213
838	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:02 WIB'.	\N	2025-12-22 09:02:48.26665	2025-12-22 09:02:48.26665
842	1	kmis	create	Menambahkan data 'Import Soal Pertanyaan (5)' pada 'Senin, 22 Desember 2025 pukul 16:22 WIB'.	\N	2025-12-22 09:22:35.510686	2025-12-22 09:22:35.510686
846	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:30 WIB'.	\N	2025-12-22 09:30:06.638169	2025-12-22 09:30:06.638169
850	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:30 WIB'.	\N	2025-12-22 09:30:49.006739	2025-12-22 09:30:49.006739
854	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:31 WIB'.	\N	2025-12-22 09:31:47.835272	2025-12-22 09:31:47.835272
858	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:18.675797	2025-12-22 09:32:18.675797
862	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:54.972376	2025-12-22 09:32:54.972376
865	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 16:34 WIB'.	\N	2025-12-22 09:34:00.519305	2025-12-22 09:34:00.519305
869	1	kmis	create	Menambahkan data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:43 WIB'.	\N	2025-12-22 14:43:56.137377	2025-12-22 14:43:56.137377
871	1	kmis	delete	Menghapus data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 21:50 WIB'.	\N	2025-12-22 14:50:15.581715	2025-12-22 14:50:15.581715
872	1	kmis	delete	Menghapus data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 21:53 WIB'.	\N	2025-12-22 14:53:41.732989	2025-12-22 14:53:41.732989
617	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 15 Desember 2025 pukul 10:30 WIB'.	\N	2025-12-15 03:30:35.137066	2025-12-15 03:30:35.137066
622	1	cms	update	Memperbarui data 'List Dokumen Hukum' pada 'Jumat, 19 Desember 2025 pukul 21:45 WIB'.	\N	2025-12-19 14:45:24.420716	2025-12-19 14:45:24.420716
627	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:02 WIB'.	\N	2025-12-19 15:02:26.680576	2025-12-19 15:02:26.680576
632	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:05 WIB'.	\N	2025-12-19 15:05:11.372635	2025-12-19 15:05:11.372635
637	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:21 WIB'.	\N	2025-12-19 15:21:17.369523	2025-12-19 15:21:17.369523
644	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 23:18 WIB'.	\N	2025-12-19 16:18:14.249312	2025-12-19 16:18:14.249312
649	3	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Sabtu, 20 Desember 2025 pukul 05:13 WIB'.	\N	2025-12-19 22:13:13.714602	2025-12-19 22:13:13.714602
654	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:20 WIB'.	\N	2025-12-20 01:20:06.749389	2025-12-20 01:20:06.749389
659	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:33 WIB'.	\N	2025-12-20 01:33:16.768238	2025-12-20 01:33:16.768238
664	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Sabtu, 20 Desember 2025 pukul 08:37 WIB'.	\N	2025-12-20 01:37:26.387679	2025-12-20 01:37:26.387679
666	1	cms	delete	Menghapus data 'List Kegiatan' pada 'Sabtu, 20 Desember 2025 pukul 08:37 WIB'.	\N	2025-12-20 01:37:44.60671	2025-12-20 01:37:44.60671
670	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 09:01 WIB'.	\N	2025-12-20 02:01:53.291375	2025-12-20 02:01:53.291375
675	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:22 WIB'.	\N	2025-12-20 02:22:14.904759	2025-12-20 02:22:14.904759
680	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:09.633099	2025-12-20 02:23:09.633099
683	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:35.375571	2025-12-20 02:23:35.375571
688	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:24 WIB'.	\N	2025-12-20 02:24:12.56184	2025-12-20 02:24:12.56184
689	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:24 WIB'.	\N	2025-12-20 02:24:19.741659	2025-12-20 02:24:19.741659
694	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:28 WIB'.	\N	2025-12-20 02:28:37.717645	2025-12-20 02:28:37.717645
699	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:31 WIB'.	\N	2025-12-20 02:31:20.398766	2025-12-20 02:31:20.398766
704	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:37 WIB'.	\N	2025-12-20 02:37:37.962355	2025-12-20 02:37:37.962355
709	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:41 WIB'.	\N	2025-12-20 02:41:09.403077	2025-12-20 02:41:09.403077
714	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:22 WIB'.	\N	2025-12-20 03:22:18.804215	2025-12-20 03:22:18.804215
719	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:38 WIB'.	\N	2025-12-20 03:38:36.015206	2025-12-20 03:38:36.015206
724	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:56 WIB'.	\N	2025-12-20 03:56:22.058657	2025-12-20 03:56:22.058657
730	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:24 WIB'.	\N	2025-12-21 11:24:09.587916	2025-12-21 11:24:09.587916
739	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:07 WIB'.	\N	2025-12-21 16:07:17.031227	2025-12-21 16:07:17.031227
744	1	cms	delete	Menghapus data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:09 WIB'.	\N	2025-12-21 16:09:05.991432	2025-12-21 16:09:05.991432
749	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Minggu, 21 Desember 2025 pukul 23:19 WIB'.	\N	2025-12-21 16:19:33.985653	2025-12-21 16:19:33.985653
754	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:46 WIB'.	\N	2025-12-21 16:46:01.867299	2025-12-21 16:46:01.867299
759	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:52 WIB'.	\N	2025-12-21 16:52:54.883685	2025-12-21 16:52:54.883685
764	1	kmis	create	Menambahkan data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 11:14 WIB'.	\N	2025-12-22 04:14:05.355962	2025-12-22 04:14:05.355962
783	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:10 WIB'.	\N	2025-12-22 07:10:28.088986	2025-12-22 07:10:28.088986
789	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:12 WIB'.	\N	2025-12-22 07:12:02.287807	2025-12-22 07:12:02.287807
794	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:13 WIB'.	\N	2025-12-22 07:13:11.086789	2025-12-22 07:13:11.086789
801	1	kmis	delete	Menghapus data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:49 WIB'.	\N	2025-12-22 07:49:40.125216	2025-12-22 07:49:40.125216
806	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:52 WIB'.	\N	2025-12-22 07:52:32.973609	2025-12-22 07:52:32.973609
811	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:54 WIB'.	\N	2025-12-22 07:54:36.419237	2025-12-22 07:54:36.419237
816	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:57 WIB'.	\N	2025-12-22 07:57:21.369631	2025-12-22 07:57:21.369631
822	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:02 WIB'.	\N	2025-12-22 08:02:35.565206	2025-12-22 08:02:35.565206
827	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:24 WIB'.	\N	2025-12-22 08:24:41.639136	2025-12-22 08:24:41.639136
831	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:26 WIB'.	\N	2025-12-22 08:26:55.266407	2025-12-22 08:26:55.266407
835	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:29 WIB'.	\N	2025-12-22 08:29:00.461608	2025-12-22 08:29:00.461608
839	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 16:08 WIB'.	\N	2025-12-22 09:08:28.104769	2025-12-22 09:08:28.104769
843	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:28 WIB'.	\N	2025-12-22 09:28:20.363695	2025-12-22 09:28:20.363695
847	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:30 WIB'.	\N	2025-12-22 09:30:19.685246	2025-12-22 09:30:19.685246
851	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:31 WIB'.	\N	2025-12-22 09:31:04.048887	2025-12-22 09:31:04.048887
855	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:31 WIB'.	\N	2025-12-22 09:31:54.71529	2025-12-22 09:31:54.71529
859	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:26.314323	2025-12-22 09:32:26.314323
863	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:33 WIB'.	\N	2025-12-22 09:33:03.473358	2025-12-22 09:33:03.473358
866	1	kmis	create	Menambahkan data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 16:40 WIB'.	\N	2025-12-22 09:40:25.560584	2025-12-22 09:40:25.560584
870	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 21:47 WIB'.	\N	2025-12-22 14:47:01.525484	2025-12-22 14:47:01.525484
618	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 15 Desember 2025 pukul 10:34 WIB'.	\N	2025-12-15 03:34:01.289863	2025-12-15 03:34:01.289863
623	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 21:53 WIB'.	\N	2025-12-19 14:53:19.770201	2025-12-19 14:53:19.770201
628	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:02 WIB'.	\N	2025-12-19 15:02:53.162424	2025-12-19 15:02:53.162424
633	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:15 WIB'.	\N	2025-12-19 15:15:58.015686	2025-12-19 15:15:58.015686
638	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:22 WIB'.	\N	2025-12-19 15:22:37.670699	2025-12-19 15:22:37.670699
645	1	cms	delete	Menghapus data 'List Berita' pada 'Jumat, 19 Desember 2025 pukul 23:26 WIB'.	\N	2025-12-19 16:26:31.787255	2025-12-19 16:26:31.787255
650	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 07:58 WIB'.	\N	2025-12-20 00:58:08.751507	2025-12-20 00:58:08.751507
655	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:26 WIB'.	\N	2025-12-20 01:26:44.616817	2025-12-20 01:26:44.616817
660	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 20 Desember 2025 pukul 08:33 WIB'.	\N	2025-12-20 01:33:42.819543	2025-12-20 01:33:42.819543
665	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 20 Desember 2025 pukul 08:37 WIB'.	\N	2025-12-20 01:37:36.249581	2025-12-20 01:37:36.249581
671	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 09:03 WIB'.	\N	2025-12-20 02:03:13.915427	2025-12-20 02:03:13.915427
676	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:22 WIB'.	\N	2025-12-20 02:22:23.308093	2025-12-20 02:22:23.308093
682	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:28.526389	2025-12-20 02:23:28.526389
690	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:24 WIB'.	\N	2025-12-20 02:24:27.035942	2025-12-20 02:24:27.035942
695	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:29 WIB'.	\N	2025-12-20 02:29:07.171785	2025-12-20 02:29:07.171785
700	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:31 WIB'.	\N	2025-12-20 02:31:51.903857	2025-12-20 02:31:51.903857
705	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:38 WIB'.	\N	2025-12-20 02:38:07.182521	2025-12-20 02:38:07.182521
710	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:41 WIB'.	\N	2025-12-20 02:41:39.391137	2025-12-20 02:41:39.391137
715	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:25 WIB'.	\N	2025-12-20 03:25:41.668705	2025-12-20 03:25:41.668705
720	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:51 WIB'.	\N	2025-12-20 03:51:12.932404	2025-12-20 03:51:12.932404
725	1	cms	update	Memperbarui data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 17:52 WIB'.	\N	2025-12-21 10:52:04.70755	2025-12-21 10:52:04.70755
727	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 17:52 WIB'.	\N	2025-12-21 10:52:15.253792	2025-12-21 10:52:15.253792
731	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:57 WIB'.	\N	2025-12-21 11:57:23.340715	2025-12-21 11:57:23.340715
733	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:57 WIB'.	\N	2025-12-21 11:57:53.479111	2025-12-21 11:57:53.479111
735	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:58 WIB'.	\N	2025-12-21 11:58:06.383175	2025-12-21 11:58:06.383175
740	1	cms	delete	Menghapus data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:07 WIB'.	\N	2025-12-21 16:07:24.267116	2025-12-21 16:07:24.267116
745	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:11 WIB'.	\N	2025-12-21 16:11:49.656606	2025-12-21 16:11:49.656606
750	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Minggu, 21 Desember 2025 pukul 23:24 WIB'.	\N	2025-12-21 16:24:53.866201	2025-12-21 16:24:53.866201
755	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:47 WIB'.	\N	2025-12-21 16:47:24.569786	2025-12-21 16:47:24.569786
760	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:56 WIB'.	\N	2025-12-21 16:56:49.453011	2025-12-21 16:56:49.453011
765	1	kmis	create	Menambahkan data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 11:19 WIB'.	\N	2025-12-22 04:19:29.048602	2025-12-22 04:19:29.048602
784	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:10 WIB'.	\N	2025-12-22 07:10:45.574735	2025-12-22 07:10:45.574735
787	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:11 WIB'.	\N	2025-12-22 07:11:34.578237	2025-12-22 07:11:34.578237
790	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:12 WIB'.	\N	2025-12-22 07:12:18.238853	2025-12-22 07:12:18.238853
795	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:13 WIB'.	\N	2025-12-22 07:13:38.724165	2025-12-22 07:13:38.724165
796	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:13 WIB'.	\N	2025-12-22 07:13:56.869021	2025-12-22 07:13:56.869021
798	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:14 WIB'.	\N	2025-12-22 07:14:44.525403	2025-12-22 07:14:44.525403
802	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:50 WIB'.	\N	2025-12-22 07:50:58.81475	2025-12-22 07:50:58.81475
807	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:53 WIB'.	\N	2025-12-22 07:53:09.447792	2025-12-22 07:53:09.447792
812	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:55 WIB'.	\N	2025-12-22 07:55:00.720824	2025-12-22 07:55:00.720824
817	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:59 WIB'.	\N	2025-12-22 07:59:31.089024	2025-12-22 07:59:31.089024
823	1	kmis	delete	Menghapus data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:04 WIB'.	\N	2025-12-22 08:04:04.644925	2025-12-22 08:04:04.644925
828	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:25 WIB'.	\N	2025-12-22 08:25:08.734891	2025-12-22 08:25:08.734891
832	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:27 WIB'.	\N	2025-12-22 08:27:15.688747	2025-12-22 08:27:15.688747
836	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:29 WIB'.	\N	2025-12-22 08:29:17.717914	2025-12-22 08:29:17.717914
840	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:09 WIB'.	\N	2025-12-22 09:09:01.088608	2025-12-22 09:09:01.088608
844	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:29 WIB'.	\N	2025-12-22 09:29:30.449076	2025-12-22 09:29:30.449076
848	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:30 WIB'.	\N	2025-12-22 09:30:30.852879	2025-12-22 09:30:30.852879
852	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:31 WIB'.	\N	2025-12-22 09:31:13.001528	2025-12-22 09:31:13.001528
856	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:03.243543	2025-12-22 09:32:03.243543
860	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:35.721817	2025-12-22 09:32:35.721817
867	1	kmis	delete	Menghapus data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:35 WIB'.	\N	2025-12-22 14:35:22.03345	2025-12-22 14:35:22.03345
619	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 15 Desember 2025 pukul 10:44 WIB'.	\N	2025-12-15 03:44:01.526879	2025-12-15 03:44:01.526879
624	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 21:56 WIB'.	\N	2025-12-19 14:56:38.400049	2025-12-19 14:56:38.400049
629	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:03 WIB'.	\N	2025-12-19 15:03:37.33325	2025-12-19 15:03:37.33325
634	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:18 WIB'.	\N	2025-12-19 15:18:34.47069	2025-12-19 15:18:34.47069
639	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:23 WIB'.	\N	2025-12-19 15:23:02.245928	2025-12-19 15:23:02.245928
641	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:23 WIB'.	\N	2025-12-19 15:23:43.879	2025-12-19 15:23:43.879
646	1	cms	create	Menambahkan data 'List Berita' pada 'Jumat, 19 Desember 2025 pukul 23:26 WIB'.	\N	2025-12-19 16:26:42.24479	2025-12-19 16:26:42.24479
651	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:05 WIB'.	\N	2025-12-20 01:05:37.757477	2025-12-20 01:05:37.757477
656	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:31 WIB'.	\N	2025-12-20 01:31:13.772775	2025-12-20 01:31:13.772775
661	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 08:34 WIB'.	\N	2025-12-20 01:34:32.113747	2025-12-20 01:34:32.113747
667	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:39 WIB'.	\N	2025-12-20 01:39:18.079829	2025-12-20 01:39:18.079829
672	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 09:04 WIB'.	\N	2025-12-20 02:04:39.119123	2025-12-20 02:04:39.119123
677	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:22 WIB'.	\N	2025-12-20 02:22:32.697197	2025-12-20 02:22:32.697197
681	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:20.554427	2025-12-20 02:23:20.554427
685	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:51.551271	2025-12-20 02:23:51.551271
691	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:24 WIB'.	\N	2025-12-20 02:24:37.51596	2025-12-20 02:24:37.51596
696	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:29 WIB'.	\N	2025-12-20 02:29:46.267094	2025-12-20 02:29:46.267094
701	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:32 WIB'.	\N	2025-12-20 02:32:23.357271	2025-12-20 02:32:23.357271
706	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:38 WIB'.	\N	2025-12-20 02:38:37.222339	2025-12-20 02:38:37.222339
711	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:42 WIB'.	\N	2025-12-20 02:42:06.68081	2025-12-20 02:42:06.68081
716	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:27 WIB'.	\N	2025-12-20 03:27:37.752511	2025-12-20 03:27:37.752511
721	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:52 WIB'.	\N	2025-12-20 03:52:09.86133	2025-12-20 03:52:09.86133
726	1	cms	restore	Mengembalikan data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 17:52 WIB'.	\N	2025-12-21 10:52:09.884542	2025-12-21 10:52:09.884542
732	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:57 WIB'.	\N	2025-12-21 11:57:27.463633	2025-12-21 11:57:27.463633
734	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:57 WIB'.	\N	2025-12-21 11:57:56.235245	2025-12-21 11:57:56.235245
741	1	cms	update	Memperbarui data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:08 WIB'.	\N	2025-12-21 16:08:13.791844	2025-12-21 16:08:13.791844
746	1	cms	delete	Menghapus data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:11 WIB'.	\N	2025-12-21 16:11:57.515822	2025-12-21 16:11:57.515822
751	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:42 WIB'.	\N	2025-12-21 16:42:53.541158	2025-12-21 16:42:53.541158
756	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:48 WIB'.	\N	2025-12-21 16:48:33.868984	2025-12-21 16:48:33.868984
761	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:59 WIB'.	\N	2025-12-21 16:59:13.364618	2025-12-21 16:59:13.364618
766	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 11:37 WIB'.	\N	2025-12-22 04:37:11.304476	2025-12-22 04:37:11.304476
785	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:11 WIB'.	\N	2025-12-22 07:11:08.611029	2025-12-22 07:11:08.611029
791	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:12 WIB'.	\N	2025-12-22 07:12:31.131292	2025-12-22 07:12:31.131292
797	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:14 WIB'.	\N	2025-12-22 07:14:12.439708	2025-12-22 07:14:12.439708
803	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:51 WIB'.	\N	2025-12-22 07:51:07.763974	2025-12-22 07:51:07.763974
808	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:53 WIB'.	\N	2025-12-22 07:53:27.242054	2025-12-22 07:53:27.242054
813	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:55 WIB'.	\N	2025-12-22 07:55:45.45633	2025-12-22 07:55:45.45633
818	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:00 WIB'.	\N	2025-12-22 08:00:38.101809	2025-12-22 08:00:38.101809
819	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:01 WIB'.	\N	2025-12-22 08:01:09.228831	2025-12-22 08:01:09.228831
824	1	kmis	update	Memperbarui data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 15:04 WIB'.	\N	2025-12-22 08:04:31.508249	2025-12-22 08:04:31.508249
829	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:26 WIB'.	\N	2025-12-22 08:26:03.767752	2025-12-22 08:26:03.767752
833	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:27 WIB'.	\N	2025-12-22 08:27:35.386512	2025-12-22 08:27:35.386512
837	1	kmis	create	Menambahkan data 'Import Soal Pertanyaan (20)' pada 'Senin, 22 Desember 2025 pukul 15:59 WIB'.	\N	2025-12-22 08:59:32.301912	2025-12-22 08:59:32.301912
841	1	kmis	create	Menambahkan data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 16:21 WIB'.	\N	2025-12-22 09:21:33.205075	2025-12-22 09:21:33.205075
845	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:29 WIB'.	\N	2025-12-22 09:29:40.795304	2025-12-22 09:29:40.795304
849	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:30 WIB'.	\N	2025-12-22 09:30:40.77128	2025-12-22 09:30:40.77128
853	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:31 WIB'.	\N	2025-12-22 09:31:22.077809	2025-12-22 09:31:22.077809
857	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:10.522319	2025-12-22 09:32:10.522319
861	1	kmis	update	Memperbarui data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 16:32 WIB'.	\N	2025-12-22 09:32:44.608046	2025-12-22 09:32:44.608046
864	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 16:33 WIB'.	\N	2025-12-22 09:33:53.693306	2025-12-22 09:33:53.693306
868	1	kmis	create	Menambahkan data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:36 WIB'.	\N	2025-12-22 14:36:28.418823	2025-12-22 14:36:28.418823
620	1	kmis	restore	Mengembalikan data 'List Topik' pada 'Kamis, 18 Desember 2025 pukul 11:31 WIB'.	\N	2025-12-18 04:31:11.723355	2025-12-18 04:31:11.723355
625	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 21:57 WIB'.	\N	2025-12-19 14:57:41.815282	2025-12-19 14:57:41.815282
630	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:04 WIB'.	\N	2025-12-19 15:04:10.000839	2025-12-19 15:04:10.000839
635	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:19 WIB'.	\N	2025-12-19 15:19:44.417488	2025-12-19 15:19:44.417488
640	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:23 WIB'.	\N	2025-12-19 15:23:26.61477	2025-12-19 15:23:26.61477
642	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Jumat, 19 Desember 2025 pukul 22:24 WIB'.	\N	2025-12-19 15:24:06.246726	2025-12-19 15:24:06.246726
647	1	cms	delete	Menghapus data 'List Berita' pada 'Jumat, 19 Desember 2025 pukul 23:28 WIB'.	\N	2025-12-19 16:28:53.644083	2025-12-19 16:28:53.644083
652	1	cms	create	Menambahkan data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:11 WIB'.	\N	2025-12-20 01:11:05.199631	2025-12-20 01:11:05.199631
657	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Sabtu, 20 Desember 2025 pukul 08:32 WIB'.	\N	2025-12-20 01:32:20.245554	2025-12-20 01:32:20.245554
662	1	cms	update	Memperbarui data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 08:35 WIB'.	\N	2025-12-20 01:35:01.094075	2025-12-20 01:35:01.094075
668	1	cms	delete	Menghapus data 'List Berita' pada 'Sabtu, 20 Desember 2025 pukul 08:39 WIB'.	\N	2025-12-20 01:39:27.819957	2025-12-20 01:39:27.819957
673	1	cms	create	Menambahkan data 'List Dokumen Hukum' pada 'Sabtu, 20 Desember 2025 pukul 09:08 WIB'.	\N	2025-12-20 02:08:02.50502	2025-12-20 02:08:02.50502
678	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:22 WIB'.	\N	2025-12-20 02:22:48.640094	2025-12-20 02:22:48.640094
686	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:23 WIB'.	\N	2025-12-20 02:23:58.006794	2025-12-20 02:23:58.006794
692	1	kmis	create	Menambahkan data 'List Kategori' pada 'Sabtu, 20 Desember 2025 pukul 09:24 WIB'.	\N	2025-12-20 02:24:46.618401	2025-12-20 02:24:46.618401
697	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:30 WIB'.	\N	2025-12-20 02:30:13.212255	2025-12-20 02:30:13.212255
702	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:32 WIB'.	\N	2025-12-20 02:32:51.725269	2025-12-20 02:32:51.725269
707	1	kmis	create	Menambahkan data 'List Topik' pada 'Sabtu, 20 Desember 2025 pukul 09:39 WIB'.	\N	2025-12-20 02:39:11.542714	2025-12-20 02:39:11.542714
712	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:04 WIB'.	\N	2025-12-20 03:04:43.630327	2025-12-20 03:04:43.630327
717	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:31 WIB'.	\N	2025-12-20 03:31:12.065003	2025-12-20 03:31:12.065003
722	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 20 Desember 2025 pukul 10:53 WIB'.	\N	2025-12-20 03:53:02.317915	2025-12-20 03:53:02.317915
728	1	cms	restore	Mengembalikan data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 18:23 WIB'.	\N	2025-12-21 11:23:29.480596	2025-12-21 11:23:29.480596
736	1	cms	restore	Mengembalikan data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 20:42 WIB'.	\N	2025-12-21 13:42:58.207226	2025-12-21 13:42:58.207226
738	1	cms	delete	Menghapus data 'List Dokumen Hukum' pada 'Minggu, 21 Desember 2025 pukul 20:43 WIB'.	\N	2025-12-21 13:43:27.267277	2025-12-21 13:43:27.267277
742	1	cms	delete	Menghapus data 'List Berita' pada 'Minggu, 21 Desember 2025 pukul 23:08 WIB'.	\N	2025-12-21 16:08:19.192137	2025-12-21 16:08:19.192137
747	1	cms	create	Menambahkan data 'List Kegiatan' pada 'Minggu, 21 Desember 2025 pukul 23:16 WIB'.	\N	2025-12-21 16:16:04.106095	2025-12-21 16:16:04.106095
752	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:43 WIB'.	\N	2025-12-21 16:43:58.259705	2025-12-21 16:43:58.259705
757	42	kmis	create	Menambahkan data 'List Materi' pada 'Minggu, 21 Desember 2025 pukul 23:50 WIB'.	\N	2025-12-21 16:50:11.535802	2025-12-21 16:50:11.535802
762	1	master_data	update	Memperbarui data 'List Kategori Berita' pada 'Senin, 22 Desember 2025 pukul 10:19 WIB'.	\N	2025-12-22 03:19:28.287482	2025-12-22 03:19:28.287482
767	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:03 WIB'.	\N	2025-12-22 07:03:38.238311	2025-12-22 07:03:38.238311
768	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:04 WIB'.	\N	2025-12-22 07:04:08.631875	2025-12-22 07:04:08.631875
769	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:04 WIB'.	\N	2025-12-22 07:04:20.48301	2025-12-22 07:04:20.48301
770	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:04 WIB'.	\N	2025-12-22 07:04:32.371271	2025-12-22 07:04:32.371271
771	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:04 WIB'.	\N	2025-12-22 07:04:49.59897	2025-12-22 07:04:49.59897
772	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:05 WIB'.	\N	2025-12-22 07:05:08.9643	2025-12-22 07:05:08.9643
773	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:05 WIB'.	\N	2025-12-22 07:05:15.542495	2025-12-22 07:05:15.542495
774	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:05 WIB'.	\N	2025-12-22 07:05:39.615557	2025-12-22 07:05:39.615557
775	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:05 WIB'.	\N	2025-12-22 07:05:46.689528	2025-12-22 07:05:46.689528
776	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:06 WIB'.	\N	2025-12-22 07:06:03.863233	2025-12-22 07:06:03.863233
777	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:06 WIB'.	\N	2025-12-22 07:06:23.445355	2025-12-22 07:06:23.445355
778	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:06 WIB'.	\N	2025-12-22 07:06:39.060315	2025-12-22 07:06:39.060315
779	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:06 WIB'.	\N	2025-12-22 07:06:48.460048	2025-12-22 07:06:48.460048
780	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:06 WIB'.	\N	2025-12-22 07:06:58.980708	2025-12-22 07:06:58.980708
781	1	kmis	update	Memperbarui data 'List Kategori' pada 'Senin, 22 Desember 2025 pukul 14:07 WIB'.	\N	2025-12-22 07:07:23.016674	2025-12-22 07:07:23.016674
786	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:11 WIB'.	\N	2025-12-22 07:11:21.798839	2025-12-22 07:11:21.798839
792	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:12 WIB'.	\N	2025-12-22 07:12:38.128029	2025-12-22 07:12:38.128029
799	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:14 WIB'.	\N	2025-12-22 07:14:58.637993	2025-12-22 07:14:58.637993
804	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:51 WIB'.	\N	2025-12-22 07:51:20.403897	2025-12-22 07:51:20.403897
809	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:53 WIB'.	\N	2025-12-22 07:53:52.723694	2025-12-22 07:53:52.723694
814	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 14:56 WIB'.	\N	2025-12-22 07:56:08.244801	2025-12-22 07:56:08.244801
820	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:01 WIB'.	\N	2025-12-22 08:01:27.736627	2025-12-22 08:01:27.736627
825	1	kmis	update	Memperbarui data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 15:23 WIB'.	\N	2025-12-22 08:23:14.68572	2025-12-22 08:23:14.68572
873	1	kmis	create	Menambahkan data 'List Topik' pada 'Senin, 22 Desember 2025 pukul 21:54 WIB'.	\N	2025-12-22 14:54:19.325001	2025-12-22 14:54:19.325001
874	1	kmis	delete	Menghapus data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:54 WIB'.	\N	2025-12-22 14:54:34.481601	2025-12-22 14:54:34.481601
875	1	kmis	delete	Menghapus data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:54 WIB'.	\N	2025-12-22 14:54:38.626754	2025-12-22 14:54:38.626754
876	1	kmis	create	Menambahkan data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:55 WIB'.	\N	2025-12-22 14:55:45.288122	2025-12-22 14:55:45.288122
877	1	kmis	delete	Menghapus data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 21:56 WIB'.	\N	2025-12-22 14:56:04.615608	2025-12-22 14:56:04.615608
878	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Senin, 22 Desember 2025 pukul 21:57 WIB'.	\N	2025-12-22 14:57:26.109638	2025-12-22 14:57:26.109638
879	3	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 21:57 WIB'.	\N	2025-12-22 14:57:48.784473	2025-12-22 14:57:48.784473
880	1	kmis	create	Menambahkan data 'List Materi' pada 'Senin, 22 Desember 2025 pukul 21:59 WIB'.	\N	2025-12-22 14:59:13.259205	2025-12-22 14:59:13.259205
881	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 21:59 WIB'.	\N	2025-12-22 14:59:18.638979	2025-12-22 14:59:18.638979
882	3	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 22:08 WIB'.	\N	2025-12-22 15:08:10.835456	2025-12-22 15:08:10.835456
883	3	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 22:08 WIB'.	\N	2025-12-22 15:08:16.535425	2025-12-22 15:08:16.535425
884	3	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 22:12 WIB'.	\N	2025-12-22 15:12:58.854782	2025-12-22 15:12:58.854782
885	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 23:16 WIB'.	\N	2025-12-22 16:16:07.698998	2025-12-22 16:16:07.698998
886	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 23:20 WIB'.	\N	2025-12-22 16:20:39.546932	2025-12-22 16:20:39.546932
887	36	kmis	create	Menyimpan jawaban: quizId=31, selected=B, correct=false, progress=1/1	\N	2025-12-22 16:23:44.722306	2025-12-22 16:23:44.722306
888	36	kmis	create	Revisi jawaban: topicId=37, quizId=31, selected=C, correct=false, progress=1/1	\N	2025-12-22 16:23:48.640234	2025-12-22 16:23:48.640234
889	36	kmis	create	Revisi jawaban: topicId=37, quizId=31, selected=D, correct=true, progress=1/1	\N	2025-12-22 16:23:49.619337	2025-12-22 16:23:49.619337
890	36	kmis	create	Revisi jawaban: topicId=37, quizId=31, selected=A, correct=false, progress=1/1	\N	2025-12-22 16:23:50.955977	2025-12-22 16:23:50.955977
891	36	kmis	create	Revisi jawaban: topicId=37, quizId=31, selected=C, correct=false, progress=1/1	\N	2025-12-22 16:23:52.295681	2025-12-22 16:23:52.295681
892	36	kmis	create	Menyelesaikan kuis dengan attempt_id=17 (answered=1/1, correct=0, score=0)	\N	2025-12-22 16:23:55.006352	2025-12-22 16:23:55.006352
893	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 23:25 WIB'.	\N	2025-12-22 16:25:10.088702	2025-12-22 16:25:10.088702
894	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 23:25 WIB'.	\N	2025-12-22 16:25:12.243223	2025-12-22 16:25:12.243223
895	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 23:25 WIB'.	\N	2025-12-22 16:25:13.604258	2025-12-22 16:25:13.604258
896	36	kmis	create	Menyimpan jawaban: quizId=27, selected=, correct=false, progress=1/5	\N	2025-12-22 16:25:51.759507	2025-12-22 16:25:51.759507
897	36	kmis	create	Menyimpan jawaban: quizId=28, selected=A, correct=true, progress=2/5	\N	2025-12-22 16:26:01.913042	2025-12-22 16:26:01.913042
898	36	kmis	create	Revisi jawaban: topicId=21, quizId=27, selected=B, correct=false, progress=2/5	\N	2025-12-22 16:26:08.938376	2025-12-22 16:26:08.938376
899	36	kmis	create	Revisi jawaban: topicId=21, quizId=27, selected=B, correct=false, progress=2/5	\N	2025-12-22 16:26:12.080283	2025-12-22 16:26:12.080283
900	36	kmis	create	Menyimpan jawaban: quizId=26, selected=C, correct=false, progress=3/5	\N	2025-12-22 16:26:49.894916	2025-12-22 16:26:49.894916
901	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Senin, 22 Desember 2025 pukul 23:55 WIB'.	\N	2025-12-22 16:55:46.752573	2025-12-22 16:55:46.752573
902	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:10 WIB'.	\N	2025-12-22 17:10:53.755175	2025-12-22 17:10:53.755175
903	1	kmis	update	Memperbarui data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:11 WIB'.	\N	2025-12-22 17:11:30.041966	2025-12-22 17:11:30.041966
904	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:12 WIB'.	\N	2025-12-22 17:12:14.761602	2025-12-22 17:12:14.761602
905	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 00:44 WIB'.	\N	2025-12-22 17:44:17.655698	2025-12-22 17:44:17.655698
906	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Selasa, 23 Desember 2025 pukul 00:45 WIB'.	\N	2025-12-22 17:45:10.725209	2025-12-22 17:45:10.725209
907	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 00:46 WIB'.	\N	2025-12-22 17:46:14.781964	2025-12-22 17:46:14.781964
908	1	kmis	delete	Menghapus data 'List Soal Pertanyaan' pada 'Selasa, 23 Desember 2025 pukul 00:46 WIB'.	\N	2025-12-22 17:46:37.191875	2025-12-22 17:46:37.191875
909	1	kmis	delete	Menghapus data 'List Topik' pada 'Selasa, 23 Desember 2025 pukul 00:50 WIB'.	\N	2025-12-22 17:50:08.099681	2025-12-22 17:50:08.099681
910	1	kmis	create	Menambahkan data 'List Topik' pada 'Selasa, 23 Desember 2025 pukul 00:50 WIB'.	\N	2025-12-22 17:50:54.450117	2025-12-22 17:50:54.450117
911	1	kmis	create	Menambahkan data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:51 WIB'.	\N	2025-12-22 17:51:42.184948	2025-12-22 17:51:42.184948
912	1	kmis	create	Menambahkan data 'List Soal Pertanyaan' pada 'Selasa, 23 Desember 2025 pukul 00:52 WIB'.	\N	2025-12-22 17:52:50.699373	2025-12-22 17:52:50.699373
913	36	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 00:53 WIB'.	\N	2025-12-22 17:53:01.242692	2025-12-22 17:53:01.242692
914	36	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 00:53 WIB'.	\N	2025-12-22 17:53:21.941467	2025-12-22 17:53:21.941467
915	36	kmis	create	Menyimpan jawaban: quizId=33, selected=D, correct=false, progress=1/1	\N	2025-12-22 17:53:26.575713	2025-12-22 17:53:26.575713
916	36	kmis	create	Menyelesaikan kuis dengan attempt_id=20 (answered=1/1, correct=0, score=0)	\N	2025-12-22 17:53:28.584167	2025-12-22 17:53:28.584167
917	1	kmis	delete	Menghapus data 'List Soal Pertanyaan' pada 'Selasa, 23 Desember 2025 pukul 00:53 WIB'.	\N	2025-12-22 17:53:48.584823	2025-12-22 17:53:48.584823
918	1	kmis	delete	Menghapus data 'List Soal Pertanyaan' pada 'Selasa, 23 Desember 2025 pukul 00:53 WIB'.	\N	2025-12-22 17:53:52.414773	2025-12-22 17:53:52.414773
919	1	kmis	delete	Menghapus data 'List Topik' pada 'Selasa, 23 Desember 2025 pukul 00:54 WIB'.	\N	2025-12-22 17:54:05.772264	2025-12-22 17:54:05.772264
920	1	kmis	delete	Menghapus data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:54 WIB'.	\N	2025-12-22 17:54:16.66654	2025-12-22 17:54:16.66654
921	1	kmis	delete	Menghapus data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:54 WIB'.	\N	2025-12-22 17:54:21.908832	2025-12-22 17:54:21.908832
922	1	kmis	delete	Menghapus data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:54 WIB'.	\N	2025-12-22 17:54:25.532543	2025-12-22 17:54:25.532543
923	1	kmis	delete	Menghapus data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:54 WIB'.	\N	2025-12-22 17:54:43.491439	2025-12-22 17:54:43.491439
924	1	kmis	delete	Menghapus data 'List Materi' pada 'Selasa, 23 Desember 2025 pukul 00:54 WIB'.	\N	2025-12-22 17:54:47.250601	2025-12-22 17:54:47.250601
925	1	kmis	update	Memperbarui data 'List Topik' pada 'Selasa, 23 Desember 2025 pukul 00:55 WIB'.	\N	2025-12-22 17:55:12.27111	2025-12-22 17:55:12.27111
926	36	kmis	create	Menyelesaikan kuis dengan attempt_id=15 (answered=3/5, correct=1, score=20)	\N	2025-12-23 01:45:01.57977	2025-12-23 01:45:01.57977
927	36	kmis	create	Menyimpan jawaban: quizId=6, selected=B, correct=true, progress=1/20	\N	2025-12-23 01:48:45.377966	2025-12-23 01:48:45.377966
928	36	kmis	create	Revisi jawaban: topicId=36, quizId=6, selected=C, correct=false, progress=1/20	\N	2025-12-23 01:48:47.703296	2025-12-23 01:48:47.703296
929	36	kmis	create	Revisi jawaban: topicId=36, quizId=6, selected=A, correct=false, progress=1/20	\N	2025-12-23 01:48:50.331781	2025-12-23 01:48:50.331781
930	36	kmis	create	Menyimpan jawaban: quizId=7, selected=B, correct=true, progress=2/20	\N	2025-12-23 01:48:57.022273	2025-12-23 01:48:57.022273
931	36	kmis	create	Menyimpan jawaban: quizId=8, selected=C, correct=false, progress=3/20	\N	2025-12-23 01:48:59.843628	2025-12-23 01:48:59.843628
932	36	kmis	create	Menyimpan jawaban: quizId=9, selected=C, correct=true, progress=4/20	\N	2025-12-23 01:49:03.189106	2025-12-23 01:49:03.189106
933	36	kmis	create	Menyimpan jawaban: quizId=10, selected=B, correct=false, progress=5/20	\N	2025-12-23 01:49:07.937176	2025-12-23 01:49:07.937176
934	36	kmis	create	Menyimpan jawaban: quizId=11, selected=A, correct=false, progress=6/20	\N	2025-12-23 01:49:12.264945	2025-12-23 01:49:12.264945
935	36	kmis	create	Menyimpan jawaban: quizId=12, selected=A, correct=false, progress=7/20	\N	2025-12-23 01:49:15.580326	2025-12-23 01:49:15.580326
936	36	kmis	create	Menyimpan jawaban: quizId=13, selected=A, correct=false, progress=8/20	\N	2025-12-23 01:49:18.219268	2025-12-23 01:49:18.219268
937	36	kmis	create	Menyimpan jawaban: quizId=14, selected=A, correct=false, progress=9/20	\N	2025-12-23 01:49:21.285913	2025-12-23 01:49:21.285913
938	36	kmis	create	Menyimpan jawaban: quizId=15, selected=A, correct=false, progress=10/20	\N	2025-12-23 01:49:25.043718	2025-12-23 01:49:25.043718
939	36	kmis	create	Menyimpan jawaban: quizId=16, selected=C, correct=true, progress=11/20	\N	2025-12-23 01:49:31.441174	2025-12-23 01:49:31.441174
940	36	kmis	create	Menyimpan jawaban: quizId=17, selected=B, correct=true, progress=12/20	\N	2025-12-23 01:49:34.242645	2025-12-23 01:49:34.242645
941	36	kmis	create	Menyimpan jawaban: quizId=18, selected=B, correct=false, progress=13/20	\N	2025-12-23 01:49:38.41504	2025-12-23 01:49:38.41504
942	36	kmis	create	Menyimpan jawaban: quizId=19, selected=B, correct=true, progress=14/20	\N	2025-12-23 01:49:42.65846	2025-12-23 01:49:42.65846
943	36	kmis	create	Menyimpan jawaban: quizId=20, selected=B, correct=true, progress=15/20	\N	2025-12-23 01:51:46.315323	2025-12-23 01:51:46.315323
944	36	kmis	create	Menyimpan jawaban: quizId=21, selected=B, correct=true, progress=16/20	\N	2025-12-23 01:51:49.093402	2025-12-23 01:51:49.093402
945	36	kmis	create	Menyimpan jawaban: quizId=22, selected=B, correct=true, progress=17/20	\N	2025-12-23 01:51:52.302062	2025-12-23 01:51:52.302062
946	36	kmis	create	Menyimpan jawaban: quizId=23, selected=B, correct=true, progress=18/20	\N	2025-12-23 01:51:54.653879	2025-12-23 01:51:54.653879
947	36	kmis	create	Menyimpan jawaban: quizId=24, selected=B, correct=false, progress=19/20	\N	2025-12-23 01:51:58.23631	2025-12-23 01:51:58.23631
948	36	kmis	create	Menyimpan jawaban: quizId=25, selected=, correct=false, progress=20/20	\N	2025-12-23 01:52:03.193687	2025-12-23 01:52:03.193687
949	36	kmis	create	Menyelesaikan kuis dengan attempt_id=14 (answered=20/20, correct=9, score=45)	\N	2025-12-23 01:52:18.170366	2025-12-23 01:52:18.170366
950	47	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 09:43 WIB'.	\N	2025-12-23 02:43:44.356903	2025-12-23 02:43:44.356903
951	47	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 09:44 WIB'.	\N	2025-12-23 02:44:02.708361	2025-12-23 02:44:02.708361
952	47	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 09:44 WIB'.	\N	2025-12-23 02:44:05.491153	2025-12-23 02:44:05.491153
953	47	kmis	update	Memperbarui data 'Pembelajaran Materi & Quiz' pada 'Selasa, 23 Desember 2025 pukul 09:44 WIB'.	\N	2025-12-23 02:44:08.297695	2025-12-23 02:44:08.297695
954	47	kmis	create	Menyimpan jawaban: quizId=6, selected=C, correct=false, progress=1/20	\N	2025-12-23 02:44:14.141603	2025-12-23 02:44:14.141603
955	47	kmis	create	Menyimpan jawaban: quizId=7, selected=, correct=false, progress=2/20	\N	2025-12-23 02:44:19.87549	2025-12-23 02:44:19.87549
956	47	kmis	create	Menyimpan jawaban: quizId=8, selected=D, correct=false, progress=3/20	\N	2025-12-23 02:44:24.136891	2025-12-23 02:44:24.136891
957	47	kmis	create	Menyimpan jawaban: quizId=9, selected=C, correct=true, progress=4/20	\N	2025-12-23 02:44:26.737785	2025-12-23 02:44:26.737785
958	47	kmis	create	Menyimpan jawaban: quizId=10, selected=A, correct=false, progress=5/20	\N	2025-12-23 02:44:28.817375	2025-12-23 02:44:28.817375
959	47	kmis	create	Menyimpan jawaban: quizId=11, selected=B, correct=false, progress=6/20	\N	2025-12-23 02:44:33.578424	2025-12-23 02:44:33.578424
960	47	kmis	create	Menyimpan jawaban: quizId=12, selected=D, correct=false, progress=7/20	\N	2025-12-23 02:44:35.977864	2025-12-23 02:44:35.977864
961	47	kmis	create	Menyimpan jawaban: quizId=13, selected=C, correct=false, progress=8/20	\N	2025-12-23 02:44:38.020543	2025-12-23 02:44:38.020543
962	47	kmis	create	Menyimpan jawaban: quizId=14, selected=B, correct=true, progress=9/20	\N	2025-12-23 02:44:40.115173	2025-12-23 02:44:40.115173
963	47	kmis	create	Menyimpan jawaban: quizId=15, selected=C, correct=false, progress=10/20	\N	2025-12-23 02:44:42.695173	2025-12-23 02:44:42.695173
964	47	kmis	create	Menyimpan jawaban: quizId=16, selected=A, correct=false, progress=11/20	\N	2025-12-23 02:44:45.476934	2025-12-23 02:44:45.476934
965	47	kmis	create	Menyimpan jawaban: quizId=17, selected=D, correct=false, progress=12/20	\N	2025-12-23 02:44:48.013896	2025-12-23 02:44:48.013896
966	47	kmis	create	Menyimpan jawaban: quizId=18, selected=D, correct=false, progress=13/20	\N	2025-12-23 02:44:50.480138	2025-12-23 02:44:50.480138
967	47	kmis	create	Menyimpan jawaban: quizId=19, selected=D, correct=false, progress=14/20	\N	2025-12-23 02:44:54.436628	2025-12-23 02:44:54.436628
968	47	kmis	create	Menyimpan jawaban: quizId=20, selected=A, correct=false, progress=15/20	\N	2025-12-23 02:44:58.162668	2025-12-23 02:44:58.162668
969	47	kmis	create	Menyimpan jawaban: quizId=21, selected=D, correct=false, progress=16/20	\N	2025-12-23 02:45:00.677716	2025-12-23 02:45:00.677716
970	47	kmis	create	Revisi jawaban: topicId=36, quizId=21, selected=B, correct=true, progress=16/20	\N	2025-12-23 02:45:02.496885	2025-12-23 02:45:02.496885
971	47	kmis	create	Menyimpan jawaban: quizId=22, selected=D, correct=false, progress=17/20	\N	2025-12-23 02:45:06.140075	2025-12-23 02:45:06.140075
972	47	kmis	create	Revisi jawaban: topicId=36, quizId=7, selected=A, correct=false, progress=17/20	\N	2025-12-23 02:46:40.529401	2025-12-23 02:46:40.529401
973	47	kmis	create	Menyimpan jawaban: quizId=23, selected=D, correct=false, progress=18/20	\N	2025-12-23 02:46:45.784336	2025-12-23 02:46:45.784336
974	47	kmis	create	Menyimpan jawaban: quizId=24, selected=B, correct=false, progress=19/20	\N	2025-12-23 02:46:49.472372	2025-12-23 02:46:49.472372
975	47	kmis	create	Menyimpan jawaban: quizId=25, selected=D, correct=false, progress=20/20	\N	2025-12-23 02:46:52.479285	2025-12-23 02:46:52.479285
976	47	kmis	create	Revisi jawaban: topicId=36, quizId=7, selected=A, correct=false, progress=20/20	\N	2025-12-23 02:46:57.879417	2025-12-23 02:46:57.879417
977	47	kmis	create	Revisi jawaban: topicId=36, quizId=7, selected=D, correct=false, progress=20/20	\N	2025-12-23 02:46:59.493265	2025-12-23 02:46:59.493265
978	47	kmis	create	Menyelesaikan kuis dengan attempt_id=21 (answered=20/20, correct=3, score=15)	\N	2025-12-23 02:47:06.644437	2025-12-23 02:47:06.644437
979	47	profile	update	Memperbarui data 'Data Diri' pada 'Selasa, 23 Desember 2025 pukul 14:25 WIB'.	\N	2025-12-23 07:25:45.165193	2025-12-23 07:25:45.165193
980	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 17:14 WIB'.	\N	2026-01-03 10:14:24.907015	2026-01-03 10:14:24.907015
981	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 17:16 WIB'.	\N	2026-01-03 10:16:38.470144	2026-01-03 10:16:38.470144
982	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 17:34 WIB'.	\N	2026-01-03 10:34:26.208526	2026-01-03 10:34:26.208526
983	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 17:36 WIB'.	\N	2026-01-03 10:36:36.154124	2026-01-03 10:36:36.154124
984	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 17:42 WIB'.	\N	2026-01-03 10:42:19.877252	2026-01-03 10:42:19.877252
985	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 17:46 WIB'.	\N	2026-01-03 10:46:33.801323	2026-01-03 10:46:33.801323
986	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 18:03 WIB'.	\N	2026-01-03 11:03:06.760691	2026-01-03 11:03:06.760691
987	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 18:07 WIB'.	\N	2026-01-03 11:07:16.217518	2026-01-03 11:07:16.217518
988	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 18:14 WIB'.	\N	2026-01-03 11:14:53.938205	2026-01-03 11:14:53.938205
989	42	kmis	create	Menambahkan data 'List Materi' pada 'Sabtu, 3 Januari 2026 pukul 18:20 WIB'.	\N	2026-01-03 11:20:27.153523	2026-01-03 11:20:27.153523
990	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:32 WIB'.	\N	2026-01-09 02:32:59.50246	2026-01-09 02:32:59.50246
991	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:03.045277	2026-01-09 02:33:03.045277
992	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:06.271799	2026-01-09 02:33:06.271799
993	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:11.257992	2026-01-09 02:33:11.257992
994	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:14.819691	2026-01-09 02:33:14.819691
995	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:17.905003	2026-01-09 02:33:17.905003
996	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:21.108374	2026-01-09 02:33:21.108374
997	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:24.096547	2026-01-09 02:33:24.096547
998	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:27.223352	2026-01-09 02:33:27.223352
999	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:30.221819	2026-01-09 02:33:30.221819
1000	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:41.130639	2026-01-09 02:33:41.130639
1001	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:45.165787	2026-01-09 02:33:45.165787
1002	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:50.035716	2026-01-09 02:33:50.035716
1003	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:33 WIB'.	\N	2026-01-09 02:33:56.149994	2026-01-09 02:33:56.149994
1004	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:00.739492	2026-01-09 02:34:00.739492
1005	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:05.152627	2026-01-09 02:34:05.152627
1006	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:10.215433	2026-01-09 02:34:10.215433
1007	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:13.678037	2026-01-09 02:34:13.678037
1008	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:18.082698	2026-01-09 02:34:18.082698
1009	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:24.794092	2026-01-09 02:34:24.794092
1010	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:29.561279	2026-01-09 02:34:29.561279
1011	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:33.975218	2026-01-09 02:34:33.975218
1012	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:38.752399	2026-01-09 02:34:38.752399
1013	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:42.846006	2026-01-09 02:34:42.846006
1014	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:46.16768	2026-01-09 02:34:46.16768
1015	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:50.116851	2026-01-09 02:34:50.116851
1016	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:53.68546	2026-01-09 02:34:53.68546
1017	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:34 WIB'.	\N	2026-01-09 02:34:56.824879	2026-01-09 02:34:56.824879
1018	42	kmis	delete	Menghapus data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:35 WIB'.	\N	2026-01-09 02:35:02.076116	2026-01-09 02:35:02.076116
1019	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 09:44 WIB'.	\N	2026-01-09 02:44:19.13615	2026-01-09 02:44:19.13615
1020	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:23 WIB'.	\N	2026-01-09 04:23:12.443111	2026-01-09 04:23:12.443111
1021	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:25 WIB'.	\N	2026-01-09 04:25:08.529862	2026-01-09 04:25:08.529862
1022	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:27 WIB'.	\N	2026-01-09 04:27:41.541979	2026-01-09 04:27:41.541979
1023	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:28 WIB'.	\N	2026-01-09 04:28:39.252889	2026-01-09 04:28:39.252889
1024	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:29 WIB'.	\N	2026-01-09 04:29:48.450641	2026-01-09 04:29:48.450641
1025	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:32 WIB'.	\N	2026-01-09 04:32:01.558355	2026-01-09 04:32:01.558355
1026	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:32 WIB'.	\N	2026-01-09 04:32:46.747708	2026-01-09 04:32:46.747708
1027	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:33 WIB'.	\N	2026-01-09 04:33:46.314681	2026-01-09 04:33:46.314681
1028	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:37 WIB'.	\N	2026-01-09 04:37:03.215083	2026-01-09 04:37:03.215083
1029	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:55 WIB'.	\N	2026-01-09 04:55:50.247133	2026-01-09 04:55:50.247133
1030	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:56 WIB'.	\N	2026-01-09 04:56:31.52449	2026-01-09 04:56:31.52449
1031	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:57 WIB'.	\N	2026-01-09 04:57:41.476025	2026-01-09 04:57:41.476025
1032	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:58 WIB'.	\N	2026-01-09 04:58:11.485799	2026-01-09 04:58:11.485799
1033	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 11:59 WIB'.	\N	2026-01-09 04:59:26.212588	2026-01-09 04:59:26.212588
1034	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 12:00 WIB'.	\N	2026-01-09 05:00:06.251548	2026-01-09 05:00:06.251548
1035	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 12:00 WIB'.	\N	2026-01-09 05:00:42.410612	2026-01-09 05:00:42.410612
1036	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 12:01 WIB'.	\N	2026-01-09 05:01:18.551517	2026-01-09 05:01:18.551517
1037	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 12:02 WIB'.	\N	2026-01-09 05:02:49.146391	2026-01-09 05:02:49.146391
1038	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:17 WIB'.	\N	2026-01-09 06:17:01.387293	2026-01-09 06:17:01.387293
1039	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:19 WIB'.	\N	2026-01-09 06:19:44.996733	2026-01-09 06:19:44.996733
1040	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:21 WIB'.	\N	2026-01-09 06:21:57.093862	2026-01-09 06:21:57.093862
1041	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:22 WIB'.	\N	2026-01-09 06:22:59.372077	2026-01-09 06:22:59.372077
1042	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:24 WIB'.	\N	2026-01-09 06:24:43.990797	2026-01-09 06:24:43.990797
1043	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:25 WIB'.	\N	2026-01-09 06:25:42.529355	2026-01-09 06:25:42.529355
1044	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:33 WIB'.	\N	2026-01-09 06:33:46.231339	2026-01-09 06:33:46.231339
1045	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:35 WIB'.	\N	2026-01-09 06:35:03.140856	2026-01-09 06:35:03.140856
1046	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:36 WIB'.	\N	2026-01-09 06:36:24.579387	2026-01-09 06:36:24.579387
1047	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:39 WIB'.	\N	2026-01-09 06:39:00.809363	2026-01-09 06:39:00.809363
1048	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:39 WIB'.	\N	2026-01-09 06:39:50.066192	2026-01-09 06:39:50.066192
1049	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:41 WIB'.	\N	2026-01-09 06:41:55.62551	2026-01-09 06:41:55.62551
1050	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:43 WIB'.	\N	2026-01-09 06:43:06.838515	2026-01-09 06:43:06.838515
1051	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:45 WIB'.	\N	2026-01-09 06:45:47.534765	2026-01-09 06:45:47.534765
1052	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:47 WIB'.	\N	2026-01-09 06:47:27.106678	2026-01-09 06:47:27.106678
1053	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:55 WIB'.	\N	2026-01-09 06:55:31.216164	2026-01-09 06:55:31.216164
1054	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:56 WIB'.	\N	2026-01-09 06:56:30.383703	2026-01-09 06:56:30.383703
1055	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:58 WIB'.	\N	2026-01-09 06:58:14.900607	2026-01-09 06:58:14.900607
1056	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 13:59 WIB'.	\N	2026-01-09 06:59:20.305437	2026-01-09 06:59:20.305437
1057	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:08 WIB'.	\N	2026-01-09 07:08:19.330557	2026-01-09 07:08:19.330557
1058	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:08 WIB'.	\N	2026-01-09 07:08:56.568701	2026-01-09 07:08:56.568701
1059	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:11 WIB'.	\N	2026-01-09 07:11:24.136146	2026-01-09 07:11:24.136146
1060	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:17 WIB'.	\N	2026-01-09 07:17:16.597767	2026-01-09 07:17:16.597767
1061	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:38 WIB'.	\N	2026-01-09 07:38:24.89321	2026-01-09 07:38:24.89321
1062	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:40 WIB'.	\N	2026-01-09 07:40:48.673548	2026-01-09 07:40:48.673548
1063	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:51 WIB'.	\N	2026-01-09 07:51:14.215474	2026-01-09 07:51:14.215474
1064	42	kmis	create	Menambahkan data 'List Materi' pada 'Jumat, 9 Januari 2026 pukul 14:53 WIB'.	\N	2026-01-09 07:53:37.146282	2026-01-09 07:53:37.146282
1065	1	master_data	delete	Menghapus data 'List Kategori Kegiatan' pada 'Jumat, 9 Januari 2026 pukul 14:54 WIB'.	\N	2026-01-09 07:54:32.773311	2026-01-09 07:54:32.773311
1066	1	kmis	update	Memperbarui data 'List Topik' pada 'Jumat, 9 Januari 2026 pukul 14:55 WIB'.	\N	2026-01-09 07:55:38.848027	2026-01-09 07:55:38.848027
1067	1	kmis	create	Menambahkan data 'List Kategori' pada 'Jumat, 9 Januari 2026 pukul 14:57 WIB'.	\N	2026-01-09 07:57:39.984243	2026-01-09 07:57:39.984243
1068	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 11 Januari 2026 pukul 20:48 WIB'.	\N	2026-01-11 13:48:30.438054	2026-01-11 13:48:30.438054
1069	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 11 Januari 2026 pukul 22:10 WIB'.	\N	2026-01-11 15:10:19.077123	2026-01-11 15:10:19.077123
1070	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Minggu, 11 Januari 2026 pukul 22:10 WIB'.	\N	2026-01-11 15:10:36.820042	2026-01-11 15:10:36.820042
1071	1	master_data	create	Menambahkan data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:38 WIB'.	\N	2026-01-11 15:38:30.031859	2026-01-11 15:38:30.031859
1072	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:40 WIB'.	\N	2026-01-11 15:40:00.033172	2026-01-11 15:40:00.033172
1073	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:40 WIB'.	\N	2026-01-11 15:40:19.131137	2026-01-11 15:40:19.131137
1074	1	master_data	delete	Menghapus data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:40 WIB'.	\N	2026-01-11 15:40:23.499581	2026-01-11 15:40:23.499581
1075	1	master_data	restore	Mengembalikan data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:40 WIB'.	\N	2026-01-11 15:40:28.042508	2026-01-11 15:40:28.042508
1076	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:40 WIB'.	\N	2026-01-11 15:40:45.537962	2026-01-11 15:40:45.537962
1077	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Minggu, 11 Januari 2026 pukul 22:40 WIB'.	\N	2026-01-11 15:40:54.9784	2026-01-11 15:40:54.9784
1078	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 12 Januari 2026 pukul 07:11 WIB'.	\N	2026-01-12 00:11:28.916254	2026-01-12 00:11:28.916254
1079	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Senin, 12 Januari 2026 pukul 07:12 WIB'.	\N	2026-01-12 00:12:54.617419	2026-01-12 00:12:54.617419
1080	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Senin, 12 Januari 2026 pukul 07:34 WIB'.	\N	2026-01-12 00:34:38.138945	2026-01-12 00:34:38.138945
1081	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Senin, 12 Januari 2026 pukul 07:34 WIB'.	\N	2026-01-12 00:34:49.73289	2026-01-12 00:34:49.73289
1082	1	master_data	update	Memperbarui data 'List kategori dokumen hukum' pada 'Senin, 12 Januari 2026 pukul 12:51 WIB'.	\N	2026-01-12 05:51:58.270345	2026-01-12 05:51:58.270345
1083	1	cms	update	Memperbarui data 'List Kegiatan' pada 'Rabu, 14 Januari 2026 pukul 17:19 WIB'.	\N	2026-01-14 10:19:52.920703	2026-01-14 10:19:52.920703
1084	43	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Kamis, 15 Januari 2026 pukul 11:53 WIB'.	\N	2026-01-15 04:53:26.322969	2026-01-15 04:53:26.322969
1085	43	kmis	create	Menambahkan data 'Pembelajaran Materi & Quiz' pada 'Kamis, 15 Januari 2026 pukul 11:54 WIB'.	\N	2026-01-15 04:54:18.211377	2026-01-15 04:54:18.211377
\.


--
-- Data for Name: cms_animal_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_animal_categories (id, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	{"en": "Wildlife", "id": "Satwa Liar"}	{"en": "Wildlife", "id": "Satwa Liar"}	\N	2025-11-01 04:33:40.913	2025-11-01 04:33:40.913
4	{"en": "Primate", "id": "Primata"}	{"en": "Omnivore", "id": "Omnivora"}	\N	2025-11-01 04:38:24.574376	2025-11-04 04:28:57.433968
3	{"en": "Tiger", "id": "Harimau"}	{"en": "Carnivores", "id": "Karnivora"}	\N	2025-11-01 04:36:44.761314	2025-11-04 04:29:05.210004
2	{"en": "Bird", "id": "Burung"}	{"en": "Herbivores", "id": "Herbivora"}	\N	2025-11-01 04:35:12.137163	2025-11-05 04:49:24.671311
\.


--
-- Data for Name: cms_animal_composition; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_animal_composition (id, cms_animal_category_id, species_image_ids, name, description, total, deleted_at, created_at, updated_at) FROM stdin;
2	2	[52]	{"en": "Bird", "id": "Burung"}	{"en": "Bird", "id": "Burung"}	100	\N	2025-11-01 04:35:43.833118	2025-11-01 04:35:52.549319
3	4	[53]	{"en": "Orang Utan", "id": "Orang Utan"}	{"en": "Orang Utan", "id": "Orang Utan"}	20	\N	2025-11-01 04:39:33.024962	2025-11-01 04:39:33.024962
1	3	[51]	{"en": "Sumatran Tiger", "id": "Harimau Sumatra"}	{"en": "Description Tiger", "id": "Harimau Deskripsi"}	50	\N	2025-11-01 04:34:20.28915	2025-11-17 01:00:44.035241
\.


--
-- Data for Name: cms_contents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_contents (id, content_file_ids, type, content, "order", deleted_at, created_at, updated_at) FROM stdin;
2	\N	Text	{"id":"Program Koridor Ekosistem","en":"Ecosystem Corridor Program"}	2	\N	2025-10-31 22:05:37.735851	2025-10-31 22:05:37.735851
31	\N	TextArray	[{"id":"Kampar","en":"Kampar"},{"id":"Kuantan Singingi","en":"Kuantan Singingi"},{"id":"Indagri Hulu","en":"Indagri Hulu"},{"id":"Indagri Hilir","en":"Indagri Hilir"}]	31	\N	2025-10-31 22:10:46.559317	2025-11-03 01:42:10.406583
16	\N	Text	{"id":"Proyek RIMBA?","en":"RIMBA project?"}	16	\N	2025-10-31 22:07:03.458317	2025-11-17 01:01:34.548885
35	\N	TextArray	[{"id":"Tebo","en":"Tebo"},{"id":"Tanjung Jabung Barat","en":"West Tanjung Jabung"},{"id":"Tanjung Jabung Timur","en":"East Tanjung Jabung"},{"id":"Muaro Jambi","en":"Muaro Jambi"},{"id":"Kota Jambi","en":"Jambi City"},{"id":"Batang Hari","en":"Batang Hari"},{"id":"Bungo","en":"Bungo"},{"id":"Merangin","en":"Merangin"},{"id":"Sarolangun","en":"Sarolangun"},{"id":"Kerinci","en":"Kerinci"},{"id":"Kota Sungai Penuh","en":"Sungai Penuh City"}]	35	\N	2025-10-31 22:11:21.034468	2025-11-03 01:45:40.250497
17	\N	Text	{"id":"Proyek RIMBA adalah kerjasama antara Pemerintah Indonesia dengan Global Environment Facility (GEF) melalui United Nations Environment Programme (UNEP) dengan Executing Agency Direktorat Jenderal Tata Ruang Kementerian ATR/BPN.","en":"The RIMBA project is a collaboration between the Indonesian Government and the Global Environment Facility (GEF) through the United Nations Environment Programme (UNEP) with the Executing Agency of the Directorate General of Spatial Planning, Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN)."}	17	\N	2025-10-31 22:07:14.660314	2025-10-31 22:07:14.660314
18	\N	Text	{"id":"USD 9.053.638 atau setara dengan Rp 135.804.570.000","en":"USD 9.053.638 or equivalent to Rp 135.804.570.000"}	18	\N	2025-10-31 22:07:23.212278	2025-10-31 22:07:23.212278
19	\N	Text	{"id":"Besaran Nilai Hibah","en":"Grant Value"}	19	\N	2025-10-31 22:07:33.584912	2025-10-31 22:07:33.584912
20	\N	Text	{"id":"PCA/2021/4031 antara UNEP dan Kementerian ATR/BPN","en":"PCA/2021/4031 between UNEP and Ministry of ATR/BPN"}	20	\N	2025-10-31 22:07:41.751432	2025-10-31 22:07:41.751432
21	\N	Text	{"id":"Project Cooperation Agreement (PCA)","en":"Project Cooperation Agreement (PCA)"}	21	\N	2025-10-31 22:07:49.713309	2025-10-31 22:07:49.713309
22	\N	Text	{"id":"Tahun 2024 sampai 2028","en":"Year 2024 to 2028"}	22	\N	2025-10-31 22:07:58.108308	2025-10-31 22:07:58.108308
23	\N	Text	{"id":"Periode Implementasi Proyek","en":"Project Implementation Period"}	23	\N	2025-10-31 22:08:04.65431	2025-10-31 22:08:04.65431
24	\N	Text	{"id":"Rangkaian Kegiatan Kami di Koridor Ekosistem RIMBA","en":"Our RIMBA Ecosystem Corridor Activities"}	24	\N	2025-10-31 22:08:11.481502	2025-10-31 22:08:11.481502
25	\N	Text	{"id":"Meningkatkan Kualitas Hidup dan Pemberdayaan Masyarakat Melalui Inisiatif-Inisiatif Unggul dan Berkelanjutan","en":"Increasing Quality of Life and Community Empowerment Through Innovative and Sustainable Initiatives"}	25	\N	2025-10-31 22:08:20.563685	2025-10-31 22:08:20.563685
26	\N	Text	{"id":"Lokasi Kami","en":"Our Location"}	26	\N	2025-10-31 22:08:35.373465	2025-10-31 22:08:35.373465
30	\N	Text	{"id":"Riau","en":"Riau"}	30	\N	2025-10-31 22:09:09.274541	2025-10-31 22:09:09.274541
32	\N	Text	{"id":"Sumatra Barat","en":"Sumatra Barat"}	32	\N	2025-10-31 22:10:59.569317	2025-10-31 22:10:59.569317
34	\N	Text	{"id":"Jambi","en":"Jambi"}	34	\N	2025-10-31 22:11:16.161773	2025-10-31 22:11:16.161773
36	\N	Text	{"id":"Dampak Nyata Program Koridor RIMBA untuk Lingkungan","en":"Real Impact of RIMBA Ecosystem Corridor for Environment"}	36	\N	2025-10-31 22:11:32.474986	2025-10-31 22:11:32.474986
37	\N	Text	{"id":"Melindungi 3,8 juta hektar bentang alam di Riau, Jambi, dan Sumatera Barat, menjadi koridor Gajah, Harimau, dan berbagai jenis burung, sekaligus menjaga fungsi ekosistem penting.","en":"Protecting 3.8 million hectares of nature in Riau, Jambi, and Sumatra Barat, becoming a corridor for elephants, tigers, and various bird species, while preserving important ecosystem functions."}	37	\N	2025-10-31 22:11:42.801322	2025-10-31 22:11:42.801322
38	\N	Text	{"id":"50+","en":"50+"}	38	\N	2025-10-31 22:11:57.89332	2025-10-31 22:11:57.89332
39	\N	Text	{"id":"Desa & komunitas lokal terlibat dalam proyek konservasi","en":"Villages and local communities involved in conservation projects"}	39	\N	2025-10-31 22:12:05.968319	2025-10-31 22:12:05.968319
40	\N	Text	{"id":"15,000+ ha","en":"15,000+ ha"}	40	\N	2025-10-31 22:12:13.794317	2025-10-31 22:12:13.794317
41	\N	Text	{"id":"Hutan primer & sekunder direhabilitasi, meningkatkan kualitas ekosistem","en":"Primary and secondary forests are rehabilitated, enhancing ecosystem quality"}	41	\N	2025-10-31 22:12:25.19531	2025-10-31 22:12:25.19531
27	\N	Text	{"id":"Lokasi Kami","en":"Our Location"}	27	\N	2025-10-31 22:08:41.975474	2025-11-03 01:36:42.675312
33	\N	TextArray	[{"id":"Lima Puluh Kota","en":"Lima Puluh City"},{"id":"Tanah Datar","en":"Tanah Datar"},{"id":"Sijunjung","en":"Sijunjung"},{"id":"Solok","en":"Solok"},{"id":"Kota Solok","en":"Solok City"},{"id":"Dharmasraya","en":"Dharmasraya"},{"id":"Solok Selatan","en":"South Solok"},{"id":"Pesisir Selatan","en":"South Pesisir"}]	33	\N	2025-10-31 22:11:05.076308	2025-11-03 01:41:15.902584
42	\N	Text	{"id":"500+","en":"500+"}	42	\N	2025-10-31 22:12:34.103016	2025-10-31 22:12:34.103016
43	\N	Text	{"id":"Satwa liar dipantau & dilindungi (Gajah, Harimau, Burung, dll.)","en":"Wildlife is monitored and protected (elephants, tigers, birds, etc.)"}	43	\N	2025-10-31 22:12:42.403334	2025-10-31 22:12:42.403334
44	\N	Text	{"id":"1200+","en":"1200+"}	44	\N	2025-10-31 22:12:51.568315	2025-10-31 22:12:51.568315
45	\N	Text	{"id":"Individu mendapatkan manfaat langsung dari program pemberdayaan masyarakat","en":"Individuals receive direct benefits from the community empowerment program"}	45	\N	2025-10-31 22:13:00.728311	2025-10-31 22:13:00.728311
46	\N	Text	{"id":"Komposisi Satwa","en":"Animal Composition"}	46	\N	2025-10-31 22:13:09.319339	2025-10-31 22:13:09.319339
47	\N	Text	{"id":"Persentase Penyelesaian Program RIMBA","en":"RIMBA Program Completion Percentage"}	47	\N	2025-10-31 22:13:19.577853	2025-10-31 22:13:19.577853
69	\N	Text	{"id":"Melestarikan Keanekaragaman Hayati","en":"Preserving Diversity of Life"}	69	\N	2025-10-31 22:22:05.270999	2025-10-31 22:22:05.270999
50	\N	Text	{"id":"Dokumen Hukum","en":"Legal Document"}	50	\N	2025-10-31 22:17:09.670305	2025-10-31 22:17:09.670305
5	[190]	Image	https://rimba.webgis.app/cms/storage/documents/1%20(1).jpg	5	\N	2025-10-31 22:06:07.784334	2025-12-19 14:56:38.400049
8	[192]	Image	https://rimba.webgis.app/cms/storage/documents/4%20(1).jpg	8	\N	2025-10-31 22:06:11.043596	2025-12-19 15:01:19.982248
9	[193]	Image	https://rimba.webgis.app/cms/storage/documents/5%20(1).jpg	9	\N	2025-10-31 22:06:12.189284	2025-12-19 15:02:26.680576
10	[194]	Image	https://rimba.webgis.app/cms/storage/documents/6%20(1).jpg	10	\N	2025-10-31 22:06:21.212317	2025-12-19 15:02:53.162424
1	[359]	Image	https://rimba.webgis.app/cms/storage/documents/Silokek--3.jpg	1	\N	2025-10-31 22:04:25.674358	2026-01-14 10:19:52.920703
12	[196]	Image	https://rimba.webgis.app/cms/storage/documents/8%20(1).jpg	12	\N	2025-10-31 22:06:23.54511	2025-12-19 15:04:10.000839
13	[197]	Image	https://rimba.webgis.app/cms/storage/documents/gambut-2%20(1).jpg	13	\N	2025-10-31 22:06:24.88331	2025-12-19 15:04:44.196339
14	[198]	Image	https://rimba.webgis.app/cms/storage/documents/kopi-2%20(1).jpg	14	\N	2025-10-31 22:06:26.217509	2025-12-19 15:05:11.372635
11	[231]	Image	https://rimba.webgis.app/cms/storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	11	\N	2025-10-31 22:06:22.40031	2025-12-20 01:33:42.819543
51	\N	Text	{"id":"Menyajikan informasi hukum yang jelas, akurat, dan mudah dipahami untuk semua pemangku kepentingan.","en":"Presenting clear, accurate, and easy-to-understand legal information for all stakeholders."}	51	\N	2025-10-31 22:17:16.539027	2025-10-31 22:17:16.539027
52	\N	Text	{"id":"Berita dan Catatan Lapangan","en":"News and Field Notes"}	52	\N	2025-10-31 22:17:24.957253	2025-10-31 22:17:24.957253
53	\N	Text	{"id":"Mitra","en":"Partners"}	53	\N	2025-10-31 22:17:34.103835	2025-10-31 22:17:34.103835
54	\N	Text	{"id":"Proyek RIMBA mendapatkan persetujuan GEF Executive Director pada 13 Februari 2020 dengan nilai dana sebesar USD 9.431.763, dengan durasi proyek selama 72 bulan. Perjanjian kerjasama proyek (Project Cooperation Agreement) ditandatangani oleh Dirjen Tata Ruang dari Kementrian Agraria dan Tata Ruang (ATR) dan United Nations Environment Programme (UNEP) pada 30 Juni 2022.","en":"The RIMBA project received approval from the GEF Executive Director on February 13, 2020, with a funding value of USD 9,431,763 and a project duration of 72 months. The Project Cooperation Agreement was signed by the Director General of Spatial Planning of the Ministry of Agrarian Affairs and Spatial Planning (ATR) and the United Nations Environment Programme (UNEP) on June 30, 2022."}	54	\N	2025-10-31 22:17:42.941306	2025-10-31 22:17:42.941306
71	\N	Text	{"id":"Perlindungan Alam","en":"Preserving Nature"}	71	\N	2025-10-31 22:22:24.676626	2025-11-03 03:45:38.004319
57	\N	Text	{"id":"Kementerian Agraria dan Tata Ruang Badan Pertanahan Nasional","en":"Ministry of Agrarian Affairs and Spatial Planning National Land Administration"}	57	\N	2025-10-31 22:18:39.928318	2025-10-31 22:18:39.928318
58	\N	Text	{"id":"info@rimba.com","en":"info@rimba.com"}	58	\N	2025-10-31 22:18:48.54554	2025-10-31 22:18:48.54554
59	\N	Text	{"id":"021-777-788","en":"021-777-788"}	59	\N	2025-10-31 22:18:57.393324	2025-10-31 22:18:57.393324
60	\N	Text	{"id":"Jl. Sisingamangaraja No. 2, Kebayoran Baru, Jakarta 12110","en":"Jl. Sisingamangaraja No. 2, Kebayoran Baru, Jakarta 12110"}	60	\N	2025-10-31 22:19:06.323316	2025-10-31 22:19:06.323316
61	\N	Link	https://facebook.com	61	\N	2025-10-31 22:20:55.850306	2025-10-31 22:20:55.850306
62	\N	Link	https://instagram.com	62	\N	2025-10-31 22:21:03.411511	2025-10-31 22:21:03.411511
63	\N	Link	https://x.com	63	\N	2025-10-31 22:21:11.175325	2025-10-31 22:21:11.175325
66	\N	Text	{"id":"Program Koridor RIMBA","en":"RIMBA Ecosystem Corridor Program"}	66	\N	2025-10-31 22:21:40.136316	2025-10-31 22:21:40.136316
67	\N	Text	{"id":"Tujuan Program","en":"Program Objectives"}	67	\N	2025-10-31 22:21:48.430773	2025-10-31 22:21:48.430773
65	\N	Text	{"id":"Dokumen dan Informasi Hukum","en":"Legal Documents and Informations"}	65	\N	2025-10-31 22:21:33.167512	2025-11-21 08:02:27.481003
70	\N	Text	{"id":"Meningkatkan fungsi koridor ekosistem untuk menjaga keberlangsungan satwa dan habitatnya.","en":"Increasing the function of the ecosystem corridor to preserve the survival of wildlife and their habitats."}	70	\N	2025-10-31 22:22:16.787579	2025-10-31 22:22:16.787579
72	\N	Text	{"id":"Meningkatkan cadangan karbon melalui perlindungan dan pemulihan ekosistem.","en":"Increasing carbon storage by preserving and recovering ecosystems."}	72	\N	2025-10-31 22:22:34.237305	2025-10-31 22:22:34.237305
73	\N	Text	{"id":"Tata Ruang Berkelanjutan","en":"Sustainable Spatial Planning"}	73	\N	2025-10-31 22:22:43.486431	2025-10-31 22:22:43.486431
74	\N	Text	{"id":"Menjadikan rencana tata ruang sebagai instrumen pembangunan ekonomi hijau.","en":"Making spatial planning a tool for sustainable economic development."}	74	\N	2025-10-31 22:22:52.013307	2025-10-31 22:22:52.013307
75	\N	Text	{"id":"Manajemen Lanskap","en":"Land Management"}	75	\N	2025-10-31 22:22:59.724814	2025-10-31 22:22:59.724814
76	\N	Text	{"id":"Mengembangkan tata kelola bentang alam yang kolaboratif dan menyeluruh.","en":"Developing collaborative and comprehensive land management."}	76	\N	2025-10-31 22:23:09.452962	2025-10-31 22:23:09.452962
77	\N	Text	{"id":"Strategi Untuk Mencapai Tujuan","en":"Strategies to Achieve Objectives"}	77	\N	2025-10-31 22:23:22.103322	2025-10-31 22:23:22.103322
64	\N	Link	https://youtube.com	64	\N	2025-10-31 22:21:19.1097	2025-11-03 03:47:28.52832
79	\N	Text	{"id":"Penguatan Kelembagaan","en":"Strengthening Institutions"}	79	\N	2025-10-31 22:23:39.786154	2025-10-31 22:23:39.786154
80	\N	Text	{"id":"Membentuk kerangka kelembagaan yang berkelanjutan dan efektif untuk pengelolaan sumber daya alam dalam mendukung ekonomi hijau.","en":"Building a sustainable and effective framework for managing natural resources to support green economy."}	80	\N	2025-10-31 22:23:48.55332	2025-10-31 22:23:48.55332
68	\N	Text	{"id":"Program Koridor Ekosistem RIMBA membantu Pemerintah Indonesia dalam menerapkan transisi ekonomi hijau dengan emisi rendah karbon serta melaksanakan peta jalan penyelamatan ekosistem di tiga provinsi: Riau, Jambi, dan Sumatera Barat.","en":"The RIMBA Ecosystem Corridor Program assists the Indonesian Government in implementing a green economy transition with low carbon emissions and implementing an ecosystem rescue roadmap in three provinces: Riau, Jambi, and West Sumatra."}	68	\N	2025-10-31 22:21:56.782812	2025-11-17 07:03:12.344516
82	\N	Text	{"id":"Demonstrasi Ekonomi Hijau","en":"Green Economy Demonstration"}	82	\N	2025-10-31 22:24:06.231354	2025-10-31 22:24:06.231354
83	\N	Text	{"id":"Menerapkan praktik ekonomi hijau di tingkat tapak sebagai contoh nyata transformasi ekonomi berkelanjutan yang inklusif dan adaptif.","en":"Implementing green economy practices at the grassroots level as a concrete example of sustainable transformation that is inclusive and adaptable."}	83	\N	2025-10-31 22:24:16.354572	2025-10-31 22:24:16.354572
85	\N	Text	{"id":"Monitoring & Pembelajaran","en":"Monitoring & Learning"}	85	\N	2025-10-31 22:24:29.021309	2025-10-31 22:24:29.021309
86	\N	Text	{"id":"Mengembangkan sistem pemantauan dan evaluasi berbasis data serta berbagi pembelajaran untuk meningkatkan efektivitas program berkelanjutan.","en":"Developing monitoring and evaluation systems based on data and sharing learning to improve the effectiveness of sustainable programs."}	86	\N	2025-10-31 22:24:36.883612	2025-10-31 22:24:36.883612
87	\N	Text	{"id":"Progress Perjalanan Program","en":"Program Journey Progress"}	87	\N	2025-10-31 22:24:44.244582	2025-10-31 22:24:44.244582
88	\N	Text	{"id":"Kesepakatan Dibangun","en":"Agreement Built"}	88	\N	2025-10-31 22:24:51.932327	2025-10-31 22:24:51.932327
90	\N	Text	{"id":"Fase Persiapan (Juli 2021 - Mei 2023)","en":"Preparation Phase (July 2021 - May 2023)"}	90	\N	2025-10-31 22:25:10.29931	2025-10-31 22:25:10.29931
78	[211]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	78	\N	2025-10-31 22:23:28.840502	2025-12-19 15:19:44.417488
81	[212]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa%20(1).png	81	\N	2025-10-31 22:23:54.087233	2025-12-19 15:20:39.739383
84	[213]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa%20(1)(1).png	84	\N	2025-10-31 22:24:20.530311	2025-12-19 15:21:17.369523
99	[214]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_cogt7kcogt7kcogt%20(1).png	99	\N	2025-10-31 22:26:53.076314	2025-12-19 15:22:37.670699
91	\N	TextArray	[{"id":"Project Management Unit (PMU) RIMBA dibentuk pada 2022.","en":"Project Management Unit (PMU) RIMBA established in 2022."},{"id":"Review baseline dan Inception Workshop","en":"Review baseline and Inception Workshop"},{"id":"Project Implementation Unit (PIU) RIMBA dibentuk pada 2023.","en":"Project Implementation Unit (PIU) RIMBA established in 2023."}]	91	\N	2025-10-31 22:25:30.472317	2025-10-31 22:25:30.472317
92	\N	Text	{"id":"Januari - Juni 2024 Pengadaan","en":"January - June 2024 Procurement"}	92	\N	2025-10-31 22:25:39.940448	2025-10-31 22:25:39.940448
93	\N	TextArray	[{"id":"Proses kontraktual (bidding) dan swakelola kerja asma dengan universitas serta NGO.","en":"Kontraktual (bidding) and swakelola kerja asma with universities and NGOs."}]	93	\N	2025-10-31 22:25:51.564309	2025-10-31 22:25:51.564309
94	\N	Text	{"id":"Juli-Desember 2024","en":"July-December 2024"}	94	\N	2025-10-31 22:25:59.771039	2025-10-31 22:25:59.771039
95	\N	TextArray	[{"id":"Focus Group Discussion (FGD) dengan multi-stakeholders.","en":"Focus Group Discussion (FGD) with multi-stakeholders."},{"id":"Menyusun rencana tata ruang khususnya KSN.","en":"Drafting specific spatial planning such as KSN."},{"id":"Menyusun roadmap kelembagaan dan kajia pendukung untuk pemantapan Program Koridor RIMBA.","en":"Drafting institutional and supporting roadmap for implementation of the RIMBA Corridor Program."}]	95	\N	2025-10-31 22:26:15.506507	2025-10-31 22:26:15.506507
96	\N	Text	{"id":"Fase Implementasi","en":"Implementation Phase"}	96	\N	2025-10-31 22:26:29.979314	2025-10-31 22:26:29.979314
97	\N	TextArray	[{"id":"Pelaksanaan program utama dan demonstrasi ekonomi hijau di Kawasan Koridor RIMBA.","en":"Main program implementation and green economy demonstration at the RIMBA Corridor."}]	97	\N	2025-10-31 22:26:39.729306	2025-10-31 22:26:39.729306
98	\N	Text	{"id":"Indicator Capaian Program","en":"Program Achievement Indicator"}	98	\N	2025-10-31 22:26:48.487317	2025-10-31 22:26:48.487317
100	\N	Text	{"id":"Peningkatan Tutupan Hutan","en":"Forest Closure Increase"}	100	\N	2025-10-31 22:27:05.028316	2025-10-31 22:27:05.028316
101	\N	Text	{"id":"Tutupan hutan meningkat hingga 14%, memperkuat ekosistem dan menjaga keberlanjutan lingkungan.","en":"Forest closure increased to 14%, strengthening ecosystem and ensuring sustainable environment."}	101	\N	2025-10-31 22:27:13.016112	2025-10-31 22:27:13.016112
103	\N	Text	{"id":"Pengurangan Emisi Gas RUmah Kaca","en":"Decrease in Gas Emissions from Glass Houses"}	103	\N	2025-10-31 22:27:28.109821	2025-10-31 22:27:28.109821
104	\N	Text	{"id":"Kawasan RIMBA berhasil menurunkan emisi hingga 2%, berkontribusi pada mitigasi perubahan iklim.","en":"RIMBA corridor successfully reduced emissions to 2%, contributing to climate mitigation."}	104	\N	2025-10-31 22:27:36.69463	2025-10-31 22:27:36.69463
106	\N	Text	{"id":"Pekerjaan Berbasis Ekonomi Hijau","en":"Green Economy Based Jobs"}	106	\N	2025-10-31 22:27:49.515911	2025-10-31 22:27:49.515911
107	\N	Text	{"id":"Sebanyak 700 keluarga memperoleh pekerjaan baru yang ramah lingkungan dan berkelanjutan.","en":"700 families received new jobs that are environmentally friendly and sustainable."}	107	\N	2025-10-31 22:27:56.973318	2025-10-31 22:27:56.973318
109	\N	Text	{"id":"Konektivitas Habitat Hutan","en":"Habitat Connectivity"}	109	\N	2025-10-31 22:28:11.924418	2025-10-31 22:28:11.924418
110	\N	Text	{"id":"Konektivitas habitat meningkat hingga 30%, mendukung kelestarian keanekaragaman hayati.","en":"Habitat connectivity increased to 30%, supporting biodiversity conservation."}	110	\N	2025-10-31 22:28:19.328243	2025-10-31 22:28:19.328243
111	\N	Text	{"id":"Struktur Organisasi","en":"Organization Structure"}	111	\N	2025-10-31 22:28:26.501529	2025-10-31 22:28:26.501529
113	\N	Text	{"id":"Kegiatan","en":"Activities"}	113	\N	2025-10-31 22:28:45.414844	2025-10-31 22:28:45.414844
114	\N	Text	{"id":"Berita dan Catatan Lapangan","en":"News and Field Notes"}	114	\N	2025-10-31 22:28:53.217387	2025-10-31 22:28:53.217387
115	\N	Text	{"id":"Mitra","en":"Partners"}	115	\N	2025-10-31 22:29:01.062312	2025-10-31 22:29:01.062312
116	\N	Text	{"id":"Portal Ilmu, Gerbang Kesuksesan","en":"Portal of Knowledge, Gateway to Success"}	116	\N	2025-10-31 22:29:08.979557	2025-10-31 22:29:08.979557
117	\N	Text	{"id":"Tempat belajar online yang seru dan mudah diakses. Yuk, belajar bareng dan jadi versi terbaik dari diri kamu!","en":"Fun and easy-to-access online learning platform. Learn together and become the best version of yourself!"}	117	\N	2025-10-31 22:29:32.390815	2025-10-31 22:29:32.390815
118	\N	Text	{"id":"Semua Topik","en":"All Topic"}	118	\N	2025-10-31 22:29:39.349316	2025-11-21 09:35:54.108427
119	\N	Text	{"id":"Mau belajar hal baru atau tingkatkan skill? Cari kursus favoritmu dan mulai petualangan belajar hari ini.","en":"Want to learn something new or upgrade your skills? Find your favorite course and start your learning adventure today."}	119	\N	2025-10-31 22:29:47.31711	2025-10-31 22:29:47.31711
89	\N	TextArray	[{"id":"Project Cooperation Agreement (PCA) antara Kementerian ATR/BPN dan UNEP-GEF disepakati pada Juni 2021.","en":"Project Cooperation Agreement (PCA) between Ministry of ATR/BPN and UNEP-GEF agreed on June 2021."}]	89	\N	2025-10-31 22:25:03.038318	2025-11-02 03:11:58.46431
3	\N	Text	{"id":"Mewujudkan ekonomi hijau di koridor ekosisstem Riau, Jambi dan Sumatera Barat","en":"Creating a green economy in the Riau, Jambi, and Sumatera Barat Ecosystem Corridor"}	3	\N	2025-10-31 22:05:45.284165	2025-11-01 02:49:23.998428
4	\N	Text	{"id":"Merupakan kawasan yang berfungsi lindung di bentang alam Riau, Jambi, dan Sumatera Barat (RIMBA). Kawasan seluas 3,8 juta hektar ini dikelola melalui mempertahankan, melestarikan, dan meningkatkan fungsi koridor ekosistem yang menghubungkan sembilan kawasan lindung. Kawasan ini berfungsi sebagai koridor satwa Gajah, Harimau, dan beragam jenis burung.","en":"This protected area spans the Riau, Jambi, and West Sumatra (RIMBA) landscape. This 3.8 million-hectare area is managed by maintaining, preserving, and enhancing the ecosystem corridors connecting nine protected areas. These areas serve as habitats for elephants, tigers, and various bird species."}	4	\N	2025-10-31 22:05:55.866043	2025-11-03 01:34:50.232038
15	\N	Text	{"id":"Nilai Strategis Proyek RIMBA","en":"RIMBA Project Strategic Value"}	15	\N	2025-10-31 22:06:40.254307	2025-12-20 01:32:26.291924
6	[191]	Image	https://rimba.webgis.app/cms/storage/documents/galeri-2%20(1)%20(1).jpg	6	\N	2025-10-31 22:06:08.889714	2025-12-19 14:57:41.815282
102	[215]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_7wxlck7wxlck7wxl%20(1).png	102	\N	2025-10-31 22:27:17.492725	2025-12-19 15:23:02.245928
105	[216]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_voevcfvoevcfvoev%20(1).png	105	\N	2025-10-31 22:27:41.180314	2025-12-19 15:23:26.61477
108	[217]	Image	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_rrb493rrb493rrb4%20(1).png	108	\N	2025-10-31 22:28:01.30563	2025-12-19 15:23:43.879
112	[218]	Image	https://rimba.webgis.app/cms/storage/documents/organizational-structure%20(1).png	112	\N	2025-10-31 22:28:34.630308	2025-12-19 15:24:06.246726
7	[187]	Image	https://rimba.webgis.app/cms/storage/documents/portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup%20(2).jpg	7	\N	2025-10-31 22:06:09.947359	2025-12-15 03:44:01.526879
55	[199, 200, 201, 202, 203, 204]	ImageArray	["https://rimba.webgis.app/cms/storage/documents/1.png","https://rimba.webgis.app/cms/storage/documents/3.png","https://rimba.webgis.app/cms/storage/documents/UGM.png","https://rimba.webgis.app/cms/storage/documents/9.png","https://rimba.webgis.app/cms/storage/documents/7.png","https://rimba.webgis.app/cms/storage/documents/5.png"]	55	\N	2025-10-31 22:18:20.456273	2025-12-19 15:15:58.015686
56	[205, 206, 207, 208, 209, 210]	ImageArray	["https://rimba.webgis.app/cms/storage/documents/Univ%20Andalas.png","https://rimba.webgis.app/cms/storage/documents/2.png","https://rimba.webgis.app/cms/storage/documents/10.png","https://rimba.webgis.app/cms/storage/documents/8.png","https://rimba.webgis.app/cms/storage/documents/6.png","https://rimba.webgis.app/cms/storage/documents/4.png"]	56	\N	2025-10-31 22:18:26.192818	2025-12-19 15:18:34.47069
29	\N	Text	{"id":"9 Area Unit Pengelolaan","en":"9 Management Unit Areas"}	29	\N	2025-10-31 22:08:59.992168	2026-01-11 15:10:19.077123
28	\N	Text	{"id":"3.8 Juta Ha (Area Kuning)","en":"3.8 Million Ha (Yellow Area)"}	28	\N	2025-10-31 22:08:51.019066	2026-01-11 15:10:36.820042
\.


--
-- Data for Name: cms_events; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_events (id, cms_event_category_id, thumbnail_ids, title, description, event_content, deleted_at, created_at, updated_at) FROM stdin;
2	2	[219]	{"en": "Checking Water Depth in Forest Areas to Maintain Ecosystem Balance", "id": "Pengecekan Kedalaman Air di Kawasan Rimba untuk Menjaga Keseimbangan Ekosistem"}	{"en": "Water depth checks in the Rimba area are conducted to monitor hydrological conditions and maintain ecosystem balance. Through measurements using tools such as water level meters and echosounders, the team obtains critical data on water level fluctuations, sedimentation, and aquatic environmental quality. These observations form the basis for sustainable water resource management and habitat conservation efforts in the Rimba forest area.", "id": "Kegiatan pengecekan kedalaman air di kawasan Rimba dilakukan untuk memantau kondisi hidrologi dan menjaga keseimbangan ekosistem. Melalui pengukuran menggunakan alat seperti water level meter dan echosounder, tim memperoleh data penting tentang fluktuasi permukaan air, sedimentasi, dan kualitas lingkungan perairan. Hasil pengamatan ini menjadi dasar dalam pengelolaan sumber daya air secara berkelanjutan serta upaya konservasi habitat di kawasan hutan Rimba."}	{"en": "<p data-start=\\"160\\" data-end=\\"469\\">Amid the lush vegetation and tranquil river flows of the Rimba area lies an essential activity often overlooked by many: <strong data-start=\\"281\\" data-end=\\"307\\">water depth monitoring</strong>. This task is not merely a technical measurement&mdash;it is a vital part of understanding nature&rsquo;s dynamics and ensuring the sustainability of the forest ecosystem.</p>\\n<h4 data-start=\\"471\\" data-end=\\"505\\"><strong data-start=\\"476\\" data-end=\\"503\\">Why Water Depth Matters</strong></h4>\\n<p data-start=\\"506\\" data-end=\\"851\\">Water depth plays a crucial role in determining the <strong data-start=\\"558\\" data-end=\\"590\\">health of aquatic ecosystems</strong>. Variations in depth can indicate sedimentation, erosion, or other ecological disturbances. By regularly monitoring water depth, researchers can identify potential threats to wildlife habitats, water quality, and the overall hydrological balance of the area.</p>\\n<h4 data-start=\\"853\\" data-end=\\"891\\"><strong data-start=\\"858\\" data-end=\\"889\\">Methods and Technology Used</strong></h4>\\n<p data-start=\\"892\\" data-end=\\"1247\\">Field teams typically conduct measurements using instruments such as <strong data-start=\\"961\\" data-end=\\"983\\">water level meters</strong>, <strong data-start=\\"985\\" data-end=\\"1001\\">echosounders</strong>, or <strong data-start=\\"1006\\" data-end=\\"1028\\">ultrasonic sensors</strong>, which provide precise depth readings. In several monitoring points, <strong data-start=\\"1098\\" data-end=\\"1115\\">water samples</strong> are also collected to assess turbidity, pH levels, and mineral content&mdash;factors that significantly influence aquatic biodiversity.</p>\\n<p data-start=\\"1249\\" data-end=\\"1449\\">The collected data are then integrated into the <strong data-start=\\"1297\\" data-end=\\"1351\\">Knowledge Management and Information System (KMIS)</strong>, allowing real-time monitoring and supporting sustainable water resource management strategies.</p>\\n<h4 data-start=\\"1451\\" data-end=\\"1494\\"><strong data-start=\\"1456\\" data-end=\\"1492\\">Findings and Conservation Impact</strong></h4>\\n<p data-start=\\"1495\\" data-end=\\"1836\\">Results from recent observations revealed that certain areas experience depth fluctuations due to extreme rainfall and land-use changes around the region. This information is invaluable for conservation teams to <strong data-start=\\"1707\\" data-end=\\"1833\\">develop flood mitigation strategies, restore watershed areas, and protect species dependent on stable aquatic environments</strong>.</p>\\n<h4 data-start=\\"1838\\" data-end=\\"1886\\"><strong data-start=\\"1843\\" data-end=\\"1884\\">Preserving the Lifeline of the Forest</strong></h4>\\n<p data-start=\\"1887\\" data-end=\\"2187\\">Water is the lifeblood of Rimba. Through water depth monitoring, humans seek to understand how nature operates and how to coexist harmoniously with it. Though it may seem like a simple task, behind every recorded measurement lies a powerful message: <strong data-start=\\"2137\\" data-end=\\"2184\\">to protect nature is to protect life itself</strong>.</p>", "id": "<p data-start=\\"169\\" data-end=\\"523\\">Di tengah rimbunnya vegetasi dan aliran sungai yang menenangkan di kawasan Rimba, terdapat satu kegiatan penting yang sering luput dari perhatian banyak orang: <strong data-start=\\"329\\" data-end=\\"357\\">pengecekan kedalaman air</strong>. Aktivitas ini bukan sekadar pengukuran teknis, tetapi merupakan bagian dari upaya besar dalam memahami dinamika alam dan memastikan keberlanjutan ekosistem hutan.</p>\\n<h4 data-start=\\"525\\" data-end=\\"564\\">Mengapa Kedalaman Air Penting?</h4>\\n<p data-start=\\"565\\" data-end=\\"938\\">Kedalaman air berperan penting dalam menentukan <strong data-start=\\"613\\" data-end=\\"645\\">kesehatan ekosistem perairan</strong>. Perubahan kedalaman dapat menjadi indikator adanya sedimentasi, erosi, atau gangguan ekologis lainnya. Dengan memantau kedalaman air secara berkala, para peneliti dapat mengidentifikasi potensi ancaman terhadap habitat satwa liar, kualitas air, serta keseimbangan sistem hidrologi kawasan.</p>\\n<h4 data-start=\\"940\\" data-end=\\"984\\"><strong data-start=\\"945\\" data-end=\\"984\\">Proses dan Teknologi yang Digunakan</strong></h4>\\n<p data-start=\\"985\\" data-end=\\"1340\\">Tim lapangan biasanya melakukan pengecekan menggunakan alat seperti <strong data-start=\\"1053\\" data-end=\\"1074\\">water level meter</strong>, <strong data-start=\\"1076\\" data-end=\\"1091\\">echosounder</strong>, atau <strong data-start=\\"1098\\" data-end=\\"1119\\">sensor ultrasonik</strong> yang dapat mengukur kedalaman dengan presisi tinggi. Di beberapa titik, dilakukan pula <strong data-start=\\"1207\\" data-end=\\"1233\\">pengambilan sampel air</strong> untuk mengetahui kadar kekeruhan, pH, dan kandungan mineral yang bisa memengaruhi biodiversitas akuatik.</p>\\n<p data-start=\\"1342\\" data-end=\\"1596\\">Data yang dikumpulkan kemudian diintegrasikan ke dalam sistem <strong data-start=\\"1404\\" data-end=\\"1458\\">Knowledge Management and Information System (KMIS)</strong>, yang berfungsi untuk memantau perubahan secara real-time serta mendukung perencanaan pengelolaan sumber daya air secara berkelanjutan.</p>\\n<h4 data-start=\\"1598\\" data-end=\\"1643\\"><strong data-start=\\"1603\\" data-end=\\"1643\\">Hasil dan Dampak terhadap Konservasi</strong></h4>\\n<p data-start=\\"1644\\" data-end=\\"2008\\">Dari hasil pengecekan, ditemukan bahwa beberapa area memiliki fluktuasi kedalaman akibat curah hujan ekstrem dan perubahan tata guna lahan di sekitar kawasan. Informasi ini sangat berharga bagi tim konservasi dalam <strong data-start=\\"1859\\" data-end=\\"2005\\">mengatur strategi mitigasi banjir, restorasi daerah tangkapan air, serta menjaga habitat spesies yang bergantung pada kestabilan ekosistem air</strong>.</p>\\n<h4 data-start=\\"2010\\" data-end=\\"2049\\"><strong data-start=\\"2015\\" data-end=\\"2049\\">Menjaga Denyut Kehidupan Rimba</strong></h4>\\n<p data-start=\\"2050\\" data-end=\\"2395\\">Air adalah nadi kehidupan Rimba. Melalui kegiatan pengecekan kedalaman air, manusia berupaya memahami bagaimana alam bekerja dan bagaimana kita bisa hidup selaras dengannya. Pekerjaan ini memang tampak sederhana, tetapi di balik setiap angka yang tercatat, tersimpan pesan penting: <strong data-start=\\"2332\\" data-end=\\"2392\\">bahwa menjaga alam berarti menjaga kehidupan itu sendiri</strong>.</p>"}	\N	2025-11-03 02:06:35.011262	2025-12-19 16:17:34.959922
1	1	[220]	{"en": "Forest Observation Study in the Forest Corridor", "id": "Kajian Observasi Hutan di Koridor Kawasan Rimba"}	{"en": "Studying ecosystems and the potential for carbon trading", "id": "Mempelajari ekosistem dan potensi perdagangan karbon"}	{"en": "<h4 data-start=\\"179\\" data-end=\\"209\\"><strong data-start=\\"184\\" data-end=\\"208\\">Activity Description</strong>:</h4>\\n<p data-start=\\"210\\" data-end=\\"563\\">The Forest Observation Study in the Rimba Corridor Area aims to map and observe the condition of the forest ecosystem in the corridor area, including its flora, fauna, and environmental factors that affect the sustainability of the ecosystem. This activity involves several key stages, from field data collection to the analysis of the forest ecosystem.</p>", "id": "<h4 data-start=\\"197\\" data-end=\\"226\\"><strong data-start=\\"202\\" data-end=\\"225\\">Deskripsi Aktivitas</strong>:</h4>\\n<p data-start=\\"227\\" data-end=\\"632\\">Aktivitas Kajian Observasi Hutan di Koridor Kawasan Rimba bertujuan untuk melakukan pemetaan dan pengamatan terhadap kondisi ekosistem hutan yang ada di kawasan rimba, termasuk flora, fauna, dan faktor-faktor lingkungan yang memengaruhi keberlanjutan ekosistem tersebut. Kegiatan ini mencakup beberapa tahapan penting yang mendalam, dari pengumpulan data lapangan hingga analisis ekosistem hutan yang ada.</p>"}	\N	2025-11-01 04:22:53.252334	2025-12-19 16:18:14.249312
5	3	[276]	{"en": "GREEN INVESTMENT SCHEME REFINEMENT: Promoting Ecosystem Services and Sustainable Tourism in the RIMBA Corridor", "id": "PENAJAMAN SKEMA INVESTASI HIJAU: Mendorong Jasa Ekosistem dan Pariwisata Berkelanjutan di Koridor RIMBA"}	{"en": "This article examines the refinement of green investment schemes designed to optimize the potential of ecosystem services and sustainable tourism development along the RIMBA Corridor in Sumatra. By prioritizing environmentally friendly financing, this initiative aims to generate economic value from forest conservation while ensuring long-term benefits for local communities through responsible ecotourism. The primary focus is to build business models that are not only financially profitable but also strengthen ecological resilience and safeguard the integrity of wildlife habitats in the heart of Sumatra.", "id": "Artikel ini mengulas upaya penajaman skema investasi hijau yang dirancang untuk mengoptimalkan potensi jasa ekosistem dan pengembangan pariwisata berkelanjutan di sepanjang Koridor RIMBA, Sumatra. Dengan memprioritaskan pembiayaan yang ramah lingkungan, inisiatif ini bertujuan untuk menciptakan nilai ekonomi dari pelestarian hutan sekaligus memastikan manfaat jangka panjang bagi masyarakat lokal melalui ekowisata yang bertanggung jawab. Fokus utamanya adalah membangun model bisnis yang tidak hanya menguntungkan secara finansial, tetapi juga memperkuat ketahanan ekologi dan menjaga keutuhan habitat satwa liar di jantung Sumatra."}	{"en": "<h4 dir=\\"ltr\\">Accelerating Green Investment: Ministry of ATR/BPN Refines Ecosystem Services and Tourism Schemes in the RIMBA Corridor</h4>\\n<p dir=\\"ltr\\">On Friday, November 14, 2025, the Directorate General of Spatial Planning at the Ministry of ATR/BPN held its 4th Focus Group Discussion (FGD). The meeting focused on sharpening the business processes and investment schemes for a green economy within the RIMBA Ecosystem Corridor (Riau, Jambi, and West Sumatra).</p>\\n<p dir=\\"ltr\\">Key Pillars of Green Economy Investment:</p>\\n<p dir=\\"ltr\\">1. Sustainable Tourism Sector</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Focus: Community empowerment and integrated nature conservation.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Strategic Target: The Ministry of Tourism is committed to supporting Silokek Geopark in West Sumatra to achieve UNESCO Global Geopark (UGGp) status through multi-sectoral collaboration.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">2. Environmental Services (Water) Sector</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Innovation: Developing investment opportunities for bottled drinking water (AMDK) based on ecosystem services.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Viability: Financial assessments (IRR and NPV) are available at the pre-Feasibility Study (pre-FS) level, aligned with Bappenas&rsquo; Green Economy Index.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Mitigation: Implementation of the PES (Payment for Environmental Services) scheme to protect water catchment areas and prevent environmental pollution.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">3. Cultural Heritage Sector</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Potential: Development of the Muaro Jambi National Cultural Heritage Area (KCBN), which houses 115 archaeological remains.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Concept: Integrating sustainable tourism that respects the \\"four pillars of life\\": forests, settlements, rivers, and agriculture, guided by strict zoning and licensing systems.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">Inter-Sectoral Synergy: Attended by 27 Ministries/Agencies and regional governments, this forum ensures the RIMBA project effectively boosts national carbon reserves and biodiversity. All stakeholders' input will be synthesized into the RIMBA Project Executive Summary to guide future green investments.</p>", "id": "<h4 dir=\\"ltr\\">Akselerasi Investasi Ekonomi Hijau: Kemen ATR/BPN Tajamkan Skema Jasa Ekosistem dan Pariwisata di Koridor RIMBA</h4>\\n<p dir=\\"ltr\\">Direktorat Jenderal Tata Ruang Kementerian ATR/BPN menyelenggarakan Focus Group Discussion (FGD) ke-4 pada Jumat, 14 November 2025. Pertemuan ini bertujuan menajamkan substansi proses bisnis dan skema investasi ekonomi hijau di Kawasan Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat), dengan fokus pada sektor jasa ekosistem dan pariwisata.</p>\\n<p dir=\\"ltr\\">Pilar Utama Investasi Ekonomi Hijau:</p>\\n<p dir=\\"ltr\\">1. Sektor Pariwisata Berkelanjutan</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Fokus: Pemberdayaan masyarakat dan integrasi konservasi alam.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Target Strategis: Kementerian Pariwisata berkomitmen mendorong Geopark Silokek di Sumatera Barat untuk meraih status UNESCO Global Geopark (UGGp) melalui kolaborasi multisektor.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">2. Sektor Jasa Lingkungan (Air)</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Inovasi: Pengembangan peluang investasi Air Minum dalam Kemasan (AMDK) berbasis jasa ekosistem.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Kelayakan: Kajian finansial (Internal Rate of Return/IRR dan Net Present Value/NPV) telah tersedia pada tingkat pra-FS dengan mengacu pada Indeks Ekonomi Hijau Bappenas.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Mitigasi: Penerapan skema PES (Payment for Environmental Services) untuk memastikan pelestarian daerah tangkapan air dan mencegah pencemaran.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">3. Sektor Kebudayaan &amp; Warisan Sejarah</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Potensi: Pengembangan Kawasan Cagar Budaya Nasional (KCBN) Muaro Jambi yang memiliki 115 situs purbakala.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Konsep: Integrasi pariwisata berkelanjutan yang menghormati empat pilar kehidupan lokal: hutan, perkampungan, sungai, dan pertanian melalui sistem zonasi yang ketat.<br><br></p>\\n</li>\\n</ul>\\n<h4 dir=\\"ltr\\"><strong id=\\"docs-internal-guid-a0cddf1a-7fff-ee33-dd3e-4fc560849de2\\">Sinergi Lintas Sektor: Kegiatan ini melibatkan 27 Kementerian/Lembaga serta pemerintah daerah untuk memastikan proyek RIMBA mampu meningkatkan cadangan karbon dan biodiversitas nasional. Seluruh masukan akan difinalisasi dalam Executive Summary proyek RIMBA sebagai panduan investasi hijau masa depan.</strong></h4>"}	\N	2025-12-21 16:18:26.29544	2025-12-21 16:18:26.29544
3	1	[234]	{"en": "for Pentest", "id": "Untuk Pentest"}	{"en": "For Pentest", "id": "Untuk Pentest"}	{"en": "<p>this is a example content <strong>JUST FOR PENTEST</strong></p>", "id": "<p>Ini adalah konten contoh untuk <strong>PENTEST SAJA</strong></p>"}	2025-12-20 01:37:44.60671	2025-12-20 01:37:26.387679	2025-12-20 01:37:36.249581
4	3	[275]	{"en": "Spatial Planning Key to FOLU Net Sink Success: Directorate General of Spatial Planning Emphasizes Carbon Reserve Protection at Carbon Digital Conference 2025", "id": "Tata Ruang Kunci Sukses FOLU Net Sink: Ditjen Tata Ruang Tekankan Perlindungan Cadangan Karbon di Carbon Digital Conference 2025"}	{"en": "At the 2025 Carbon Digital Conference, the Directorate General of Spatial Planning emphasized that strategic spatial planning is the primary key to achieving the FOLU Net Sink 2030 targets. Through a rigorous regional planning approach, the government highlighted the importance of protecting carbon stocks within the forestry and land-use sectors to minimize emissions and maintain ecosystem integrity. The integration of digital data into spatial planning is expected to mitigate environmentally harmful land conversion, creating a balance between infrastructure development and ambitious national climate commitments.", "id": "Dalam gelaran Carbon Digital Conference 2025, Direktorat Jenderal Tata Ruang menegaskan bahwa penataan ruang yang strategis merupakan kunci utama dalam mencapai target FOLU Net Sink 2030. Melalui pendekatan perencanaan wilayah yang ketat, pemerintah menekankan pentingnya perlindungan cadangan karbon di sektor kehutanan dan penggunaan lahan guna meminimalisir emisi serta menjaga integritas ekosistem. Integrasi data digital dalam tata ruang diharapkan mampu memitigasi konversi lahan yang merugikan lingkungan, sehingga tercipta keseimbangan antara pembangunan infrastruktur dan komitmen iklim nasional yang ambisius."}	{"en": "<h4 dir=\\"ltr\\">Spatial Planning as a Key Instrument for Green Economy Transition: Ministry of ATR/BPN's Commitment at CDC 2025</h4>\\n<p dir=\\"ltr\\">At the Carbon Digital Conference (CDC) 2025 held at the Bandung Institute of Technology (ITB), the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) reaffirmed the vital role of spatial planning as the foundation for Indonesia's transition to a low-carbon economy.</p>\\n<p dir=\\"ltr\\">1. Digitalization and Investment Certainty Director General of Spatial Planning, Suyus Windayana, alongside Secretary of the Directorate General, Reny Windyawati, emphasized that the effectiveness of spatial control is now bolstered by a digital ecosystem. Strengthening instruments such as KKPR (Space Utilization Activity Compatibility) and utilizing digital platforms&mdash;such as RTR Online, RDTR Realtime, GISTARU KKPR, and RTR Builder&mdash;are crucial for fostering transparency and providing certainty for green investors.</p>\\n<p dir=\\"ltr\\">2. Governance Challenges and Ecological Solutions The Ministry highlighted several significant challenges, including:</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Ecological pressure and land-use conversion in high-carbon value areas.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Weak peatland management outside of designated forest zones.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Limitations in data and spatial utilization monitoring. In response, spatial governance is being steered toward a more adaptive and collaborative approach.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">3. Contribution to FOLU Net Sink 2030 In support of the FOLU Net Sink 2030 targets, the Other Land Use (OLU) sector is recognized for its immense carbon potential through:</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Strengthening agroforestry systems.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Restoring peatland ecosystems.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Sustainable management of agricultural and plantation lands.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">4. RIMBA Ecosystem Corridor: A Model of Transformation The RIMBA Ecosystem Corridor was presented as concrete evidence of successful spatial planning and green economy integration. Spanning 3.8 million hectares, the area has the capacity to store over 2.84 billion tons of CO₂e. Utilizing real-time spatial data innovation and green financing schemes, this corridor proves that spatial planning can effectively bridge ecosystem protection with inclusive economic growth.</p>\\n<p>&nbsp;</p>", "id": "<h4 dir=\\"ltr\\">Tata Ruang Sebagai Instrumen Kunci Transisi Ekonomi Hijau: Komitmen Kementerian ATR/BPN pada CDC 2025</h4>\\n<p dir=\\"ltr\\">Dalam penyelenggaraan Carbon Digital Conference (CDC) 2025 di Institut Teknologi Bandung (ITB), Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) menegaskan peran vital penataan ruang sebagai fondasi transisi menuju ekonomi rendah karbon di Indonesia.</p>\\n<p dir=\\"ltr\\">1. Digitalisasi dan Kepastian Investasi Dirjen Tata Ruang, Suyus Windayana, bersama Sesditjen Reny Windyawati, menekankan bahwa efektivitas pengendalian ruang kini didukung oleh ekosistem digital. Penguatan instrumen seperti KKPR (Kesesuaian Kegiatan Pemanfaatan Ruang) serta pemanfaatan platform digital&mdash;seperti RTR Online, RDTR Realtime, GISTARU KKPR, dan RTR Builder&mdash;menjadi kunci untuk menciptakan transparansi dan kepastian bagi para investor hijau.</p>\\n<p dir=\\"ltr\\">2. Tantangan Tata Kelola dan Solusi Ekologis Kementerian menyoroti beberapa tantangan besar, di antaranya:</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Tekanan ekologis dan alih fungsi lahan di area bernilai karbon tinggi.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Lemahnya pengelolaan gambut di luar kawasan hutan.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Keterbatasan data serta monitoring pemanfaatan ruang. Menjawab tantangan tersebut, tata kelola ruang diarahkan agar lebih adaptif melalui pendekatan kolaboratif.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">3. Kontribusi Terhadap FOLU Net Sink 2030 Dalam mendukung target FOLU Net Sink 2030, sektor Other Land Use (OLU) dinilai memiliki potensi karbon yang besar melalui:</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Penguatan sistem agroforestri.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Restorasi ekosistem gambut.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Pengelolaan berkelanjutan pada lahan pertanian dan perkebunan.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">4. Koridor Ekosistem RIMBA: Model Transformasi Nyata Koridor Ekosistem RIMBA dipaparkan sebagai bukti keberhasilan integrasi tata ruang dan ekonomi hijau. Dengan luas 3,8 juta hektare, kawasan ini mampu menyimpan lebih dari 2,84 miliar ton CO₂e. Melalui inovasi data spasial real-time dan skema pembiayaan hijau, koridor ini membuktikan bahwa tata ruang mampu menjembatani perlindungan ekosistem dengan pertumbuhan ekonomi inklusif.</p>\\n<p>&nbsp;</p>"}	\N	2025-12-21 16:16:04.106095	2025-12-21 16:16:04.106095
7	3	[278]	{"en": "Ministry of ATR/BPN Disseminates Green Economy Learning and Low-Carbon Innovation in Riau", "id": "Kementerian ATR/BPN Diseminasi Pembelajaran Ekonomi Hijau dan Inovasi Rendah Karbon di Riau"}	{"en": "The Ministry of ATR/BPN, through the Directorate General of Spatial Planning, conducted a dissemination session on green economy learning and low-carbon innovation in Riau Province as part of the RIMBA Project to bolster sustainability across the Sumatran ecosystem corridor. By engaging academia, the business sector, and civil society, the forum aimed to refine training modules by integrating on-the-ground best practices, local wisdom, and a strategic balance between conservation and community welfare. These efforts will serve as a foundation for the upcoming Training of Trainers (ToT) program in 2026, which is designed to cultivate local champions capable of effectively implementing green economy initiatives throughout Riau, Jambi, and West Sumatra.", "id": "Kementerian ATR/BPN melalui Direktorat Jenderal Tata Ruang mengadakan kegiatan diseminasi pembelajaran ekonomi hijau dan inovasi rendah karbon di Provinsi Riau sebagai bagian dari Proyek RIMBA untuk memperkuat keberlanjutan di koridor ekosistem Sumatera. Forum yang melibatkan akademisi, pelaku bisnis, dan masyarakat sipil ini bertujuan menyempurnakan modul pelatihan dengan mengintegrasikan praktik terbaik di tingkat tapak, kearifan lokal, serta keseimbangan antara konservasi dan kesejahteraan masyarakat. Hasil dari pertemuan ini nantinya akan menjadi fondasi bagi program Training of Trainers (ToT) pada tahun 2026 guna mencetak penggerak lokal (local champions) yang mampu mengimplementasikan ekonomi hijau secara efektif di wilayah Riau, Jambi, dan Sumatera Barat."}	{"en": "<h4 data-path-to-node=\\"10\\"><strong data-path-to-node=\\"10\\" data-index-in-node=\\"0\\">Green Economy Dissemination in Riau: RIMBA Project Prepares Local Champions for Low-Carbon Transformation</strong></h4>\\n<p data-path-to-node=\\"11\\">The Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN), through the Directorate General of Spatial Planning, successfully conducted the \\"Dissemination of Green Economy Learning through Low-Carbon Technological Innovation\\" in Riau Province on November 5&ndash;7, 2025. This event is a core component of the <strong data-path-to-node=\\"11\\" data-index-in-node=\\"330\\">RIMBA Project</strong>, aimed at strengthening the implementation of the green economy across the strategic ecosystem corridors of Riau, Jambi, and West Sumatra.</p>\\n<p data-path-to-node=\\"12\\"><strong data-path-to-node=\\"12\\" data-index-in-node=\\"0\\">Key Highlights of the Event:</strong></p>\\n<ul data-path-to-node=\\"13\\">\\n<li>\\n<p data-path-to-node=\\"13,0,0\\"><strong data-path-to-node=\\"13,0,0\\" data-index-in-node=\\"0\\">Refinement of Learning Modules:</strong> The forum gathered vital input from stakeholders, including academics, business leaders, and civil society organizations, to refine green economy modules. The goal is to ensure the material includes practical examples and remains applicable at the grassroots level.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,1,0\\"><strong data-path-to-node=\\"13,1,0\\" data-index-in-node=\\"0\\">Balancing Ecology and Economy:</strong> Discussions emphasized the necessity of an approach that harmonizes nature conservation with community welfare enhancement, while deeply respecting local wisdom.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,2,0\\"><strong data-path-to-node=\\"13,2,0\\" data-index-in-node=\\"0\\">Green Technology Implementation:</strong> Participants highlighted the importance of inter-sectoral collaboration and the use of low-carbon technology to sustain the ecological functions of the RIMBA corridor.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,3,0\\"><strong data-path-to-node=\\"13,3,0\\" data-index-in-node=\\"0\\">Preparation for 2026 Training:</strong> The outcomes of this dissemination will serve as the foundation for the <em data-path-to-node=\\"13,3,0\\" data-index-in-node=\\"103\\">Training of Trainers</em> (ToT) program scheduled for 2026. This initiative is designed to empower \\"local champions\\" who will spearhead the green economy transformation within the RIMBA region.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"14\\">Through this dissemination, the RIMBA Project continues to ensure that spatial planning not only protects biodiversity but also fosters sustainable and inclusive economic growth for the future.</p>", "id": "<h4 data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Diseminasi Ekonomi Hijau di Riau: Proyek RIMBA Siapkan Penggerak Lokal untuk Transformasi Rendah Karbon</strong></h4>\\n<p data-path-to-node=\\"4\\">Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN), melalui Direktorat Jenderal Tata Ruang, sukses menyelenggarakan kegiatan \\"Diseminasi Pembelajaran Ekonomi Hijau melalui Inovasi Teknologi Rendah Karbon\\" di Provinsi Riau pada 5&ndash;7 November 2025. Acara ini merupakan bagian dari komitmen berkelanjutan <strong data-path-to-node=\\"4\\" data-index-in-node=\\"321\\">Proyek RIMBA</strong> untuk memperkuat implementasi ekonomi hijau di koridor ekosistem strategis yang menghubungkan Riau, Jambi, dan Sumatera Barat.</p>\\n<p data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">Poin-Poin Utama Kegiatan:</strong></p>\\n<ul data-path-to-node=\\"6\\">\\n<li>\\n<p data-path-to-node=\\"6,0,0\\"><strong data-path-to-node=\\"6,0,0\\" data-index-in-node=\\"0\\">Penyempurnaan Modul Pembelajaran:</strong> Forum ini mengumpulkan masukan dari berbagai pemangku kepentingan&mdash;termasuk akademisi, pelaku bisnis, dan organisasi masyarakat sipil&mdash;untuk menajamkan substansi modul ekonomi hijau agar lebih aplikatif di tingkat tapak.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,1,0\\"><strong data-path-to-node=\\"6,1,0\\" data-index-in-node=\\"0\\">Keseimbangan Ekologi dan Ekonomi:</strong> Diskusi menekankan pentingnya pendekatan yang menyelaraskan konservasi alam dengan peningkatan kesejahteraan masyarakat melalui pengakuan kearifan lokal.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,2,0\\"><strong data-path-to-node=\\"6,2,0\\" data-index-in-node=\\"0\\">Penerapan Teknologi Hijau:</strong> Peserta menyoroti perlunya penguatan kolaborasi lintas sektor dan pemanfaatan teknologi rendah karbon untuk mendukung fungsi ekologis koridor RIMBA secara jangka panjang.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,3,0\\"><strong data-path-to-node=\\"6,3,0\\" data-index-in-node=\\"0\\">Persiapan Pelatihan 2026:</strong> Hasil dari diseminasi ini akan menjadi landasan utama bagi program <em data-path-to-node=\\"6,3,0\\" data-index-in-node=\\"93\\">Training of Trainers</em> (ToT) yang direncanakan pada tahun 2026. Program ini bertujuan untuk mencetak <em data-path-to-node=\\"6,3,0\\" data-index-in-node=\\"192\\">local champions</em> (penggerak lokal) yang akan memimpin transformasi ekonomi hijau di wilayah masing-masing.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"7\\">Melalui kegiatan ini, Proyek RIMBA terus berupaya memastikan bahwa pengelolaan tata ruang tidak hanya melindungi biodiversitas, tetapi juga mendorong pertumbuhan ekonomi yang berkelanjutan dan inklusif.</p>"}	\N	2025-12-21 16:24:53.866201	2025-12-21 16:24:53.866201
6	3	[277]	{"en": "Dissemination of Green Economy Learning in Jambi Strengthen Understanding, Strengthen Action, Accelerate Green Transformation RIMBA", "id": "Diseminasi Pembelajaran Ekonomi Hijau di Jambi Kuatkan Pemahaman, Perkuat Aksi, Percepat Transformasi Hijau RIMBA"}	{"en": "The dissemination of green economy learning in Jambi serves as a strategic step to strengthen understanding and drive concrete action in accelerating the green transformation across the RIMBA ecosystem corridor. This initiative focuses on integrating low-carbon innovations with community empowerment to create a harmonious balance between environmental preservation and inclusive economic growth. By equipping stakeholders with practical knowledge, the program aims to cultivate local champions capable of leading the transition toward a more sustainable and resilient future in the heart of Sumatra.", "id": "Kegiatan diseminasi pembelajaran ekonomi hijau di Jambi merupakan langkah strategis untuk memperkuat pemahaman dan aksi nyata dalam mempercepat transformasi hijau di seluruh koridor ekosistem RIMBA. Inisiatif ini berfokus pada pengintegrasian inovasi rendah karbon dengan pemberdayaan masyarakat guna menciptakan keseimbangan yang harmonis antara pelestarian lingkungan dan pertumbuhan ekonomi yang inklusif. Dengan membekali para pemangku kepentingan melalui pengetahuan praktis, program ini bertujuan untuk mencetak penggerak lokal yang mampu mengawal transisi menuju masa depan yang lebih berkelanjutan dan tangguh di jantung Sumatra."}	{"en": "<h4 dir=\\"ltr\\">Green Economy Dissemination in Jambi: RIMBA Project Strengthens Collaboration and Low-Carbon Innovation</h4>\\n<p dir=\\"ltr\\">The Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN), through the RIMBA Project, successfully hosted the \\"Dissemination of Green Economy Learning through Low-Carbon Technological Innovation\\" on November 12&ndash;14, 2025, in Jambi City. This event served as a strategic platform to align the vision for sustainable development in Sumatra.</p>\\n<p dir=\\"ltr\\">Key Highlights of the Dissemination:</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Green Economy Modules: A team from Gadjah Mada University (UGM) developed green economy modules ranging from basic to applied levels. These are designed as \\"living modules,\\" ensuring they are continuously updated based on successful field practices.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Strategic Corridor Delineation: Jambi features the most extensive ecosystem corridor delineation within the RIMBA project, as it encompasses vital movement paths for Sumatran tigers and elephants. The Bukit Batabuh Protection Forest was emphasized as a critical link for habitat connectivity.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Three Pillars of Transformation:<br><br></p>\\n</li>\\n<ol>\\n<li dir=\\"ltr\\" aria-level=\\"2\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Agriculture &amp; Forestry: Strengthening agroforestry and circular economy systems, including the integration of bio-CNG production from palm oil waste.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"2\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Energy &amp; Green Technology: Highlighting the urgency of transitioning to clean energy amidst the dominance of fossil fuels.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"2\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Community Empowerment: Engaging the younger generation through participatory planning and social media to drive green jobs, green investment, and green growth.<br><br></p>\\n</li>\\n</ol>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Empowering Local Champions: The event acted as a catalyst to identify and empower local leaders who will spearhead the green transformation at the grassroots level.<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">As part of a National Strategic Area (KSN) with a solid legal foundation, the RIMBA Project reaffirms that this corridor is not just a wildlife path, but a sustainable and inclusive workspace oriented toward a resilient future.</p>", "id": "<h4 dir=\\"ltr\\">Diseminasi Ekonomi Hijau di Jambi: Proyek RIMBA Perkuat Kolaborasi dan Inovasi Rendah Karbon</h4>\\n<p dir=\\"ltr\\">Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) melalui Proyek RIMBA sukses menggelar acara \\"Diseminasi Pembelajaran Ekonomi Hijau melalui Inovasi Teknologi Rendah Karbon\\" pada 12&ndash;14 November 2025 di Kota Jambi. Kegiatan ini menjadi wadah strategis untuk menyelaraskan visi pembangunan berkelanjutan di wilayah Sumatera.</p>\\n<p dir=\\"ltr\\">Poin-Poin Utama Diseminasi:</p>\\n<ul>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Pengembangan Modul Ekonomi Hijau: Tim akademisi dari Universitas Gadjah Mada (UGM) menyusun modul ekonomi hijau dari tingkat dasar hingga terapan. Modul ini bersifat living module, yang artinya akan terus diperbarui berdasarkan praktik baik di lapangan.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Delineasi Koridor Strategis: Jambi memiliki delineasi koridor ekosistem terluas karena menjadi jalur utama pergerakan satwa liar seperti gajah dan harimau. Fokus utama adalah menjaga Hutan Lindung Bukit Batabuh sebagai penghubung habitat yang krusial.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Fokus Tiga Pilar Transformasi:<br><br></p>\\n</li>\\n<ol>\\n<li dir=\\"ltr\\" aria-level=\\"2\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Pertanian &amp; Kehutanan: Penguatan sistem agroforestri dan ekonomi sirkular, termasuk pemanfaatan limbah sawit menjadi bio-CNG.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"2\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Energi &amp; Teknologi Hijau: Mendorong transisi ke energi bersih untuk mengurangi ketergantungan pada bahan bakar fosil.<br><br></p>\\n</li>\\n<li dir=\\"ltr\\" aria-level=\\"2\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Pemberdayaan Masyarakat: Melibatkan generasi muda melalui perencanaan partisipatif dan pemanfaatan media sosial guna menciptakan lapangan kerja hijau (green jobs).<br><br></p>\\n</li>\\n</ol>\\n<li dir=\\"ltr\\" aria-level=\\"1\\">\\n<p dir=\\"ltr\\" role=\\"presentation\\">Penjaringan Local Champions: Acara ini berhasil mengidentifikasi sosok-sosok penggerak lokal yang akan menjadi motor transformasi hijau di tapak (lapangan).<br><br></p>\\n</li>\\n</ul>\\n<p dir=\\"ltr\\">Dengan dasar legal yang kuat sebagai bagian dari Kawasan Strategis Nasional (KSN), Proyek RIMBA menegaskan bahwa koridor ini bukan sekadar jalur satwa, melainkan ruang kerja berkelanjutan yang inklusif dan berorientasi masa depan.<strong id=\\"docs-internal-guid-2383af53-7fff-508d-ff11-84e1ad9a6244\\"><br></strong></p>"}	\N	2025-12-21 16:19:33.985653	2026-01-12 00:12:54.617419
\.


--
-- Data for Name: cms_events_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_events_categories (id, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	{"en": "Study", "id": "Kajian"}	{"en": "Study", "id": "Kajian"}	\N	2025-11-01 04:10:35.637589	2025-11-01 04:10:35.637589
2	{"en": "Development", "id": "Pengembangan"}	{"en": "Development", "id": "Pengembangan"}	\N	2025-11-01 04:11:04.988262	2025-11-01 04:11:04.988262
3	{"en": "Socialization", "id": "Sosialisasi"}	{"en": "Socialization", "id": "Sosialisasi"}	\N	2025-11-01 04:11:30.697314	2025-11-01 04:11:30.697314
4	{"en": "Cooperation", "id": "Kerjasama"}	{"en": "Cooperation", "id": "Kerjasama"}	\N	2025-11-02 02:26:27.168645	2025-11-02 02:26:27.168645
5	{"en": "test", "id": "test"}	{"en": "test", "id": "test"}	2026-01-09 07:54:32.773311	2025-11-02 02:27:56.050257	2025-11-02 02:27:56.050257
\.


--
-- Data for Name: cms_faqs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_faqs (id, question, answer, deleted_at, created_at, updated_at) FROM stdin;
1	{"en": "What is the RIMBA Ecosystem Corridor Program?", "id": "Apa itu Program Koridor Ekosistem RIMBA?"}	{"en": "The RIMBA Ecosystem Corridor program is a collaboration between the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (Ministry of ATR/BPN) and the United Nations Environment Programme – Global Environment Facility (UNEP–GEF).", "id": "rogram Koridor Ekosistem RIMBA adalah kerja sama antara Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (Kementerian ATR/BPN) dengan United Nations Environment Programme – Global Environment Facility (UNEP–GEF)."}	\N	2025-11-02 02:51:17.68442	2025-11-02 02:51:17.68442
2	{"en": "How extensive and important is the RIMBA Program area?", "id": "Seberapa luas dan penting kawasan Program RIMBA?"}	{"en": "The RIMBA landscape spans three provinces (Riau, Jambi, and West Sumatra) and covers a total area of ​​over 3.8 million hectares, encompassing 19 districts and cities.", "id": "Bentang alam RIMBA mencakup wilayah di tiga provinsi (Riau, Jambi, dan Sumatera Barat) dengan total luas lebih dari 3,8 juta hektar yang meliputi 19 kabupaten/kota."}	\N	2025-11-02 02:54:23.067526	2025-11-02 02:54:23.067526
3	{"en": "What is the main objective (vision) that the RIMBA Ecosystem Corridor Program wants to achieve?", "id": "Apa tujuan utama (visi) yang ingin dicapai Program Koridor Ekosistem RIMBA?"}	{"en": "The main objective of the RIMBA Program is to strengthen forest ecosystem connectivity in the RIMBA landscape through investment in natural capital.", "id": "Tujuan utama Program RIMBA adalah untuk memperkuat konektivitas ekosistem hutan di bentang alam RIMBA melalui investasi pada modal alam."}	\N	2025-11-02 02:57:11.621313	2025-11-02 02:57:11.621313
\.


--
-- Data for Name: cms_legal_docs_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_legal_docs_categories (id, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	{"en": "Constitution", "id": "Undang Undang Test"}	{"en": "Legal basis of the constitution", "id": "Dasar hukum dari undang undang dasar"}	\N	2026-01-11 15:38:30.031859	2026-01-12 05:51:58.270345
\.


--
-- Data for Name: cms_legal_documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_legal_documents (id, document_ids, title, description, deleted_at, created_at, updated_at, cms_legal_docs_categories_id) FROM stdin;
6	[188]	{"en": "Presidential Regulation No. 13 of 2012", "id": "Peraturan Presiden No 13 Tahun 2012"}	{"en": "Presidential Regulation No. 13 of 2012", "id": "Peraturan Presiden No 13 Tahun 2012"}	\N	2025-11-03 01:57:09.026233	2025-12-19 14:45:24.420716	1
5	[47]	{"en": "APPENDIX IIB OF PP RI NO. 81 OF 2023", "id": "LAMPIRAN IIB PP RI NO 81 TAHUN 2023"}	{"en": "CONCERNING THE NATIONAL STRATEGIC SPATIAL PLAN FOR THE RAJA AMPAT BIODIVERSITY CONSERVATION AREA", "id": "TENTANG RENCANA TATA RUANG KAWASAN STRATEGIS NASIONAL KAWASAN KONSERVASI KEANEKARAGAMAN HAYATI RAJA AMPAT"}	2025-12-21 11:57:23.340715	2025-11-01 04:08:11.966889	2025-11-01 04:08:11.966889	1
4	[46]	{"en": "APPENDIX TO PP RI NO. 81 OF 2023", "id": "LAMPIRAN PP RI NO 81 TAHUN 2023"}	{"en": "CONCERNING THE NATIONAL STRATEGIC SPATIAL PLAN FOR THE RAJA AMPAT BIODIVERSITY CONSERVATION AREA", "id": "TENTANG  RENCANA TATA RUANG KAWASAN STRATEGIS NASIONAL KAWASAN KONSERVASI KEANEKARAGAMAN HAYATI RAJA AMPAT"}	2025-12-21 11:57:27.463633	2025-11-01 04:05:10.484312	2025-11-01 04:05:10.484312	1
3	[45]	{"en": "REGULATION OF THE MINISTER OF ATR/HEAD OF BPN OF THE REPUBLIC OF INDONESIA NO. 12 OF 2024 CONCERNING DETAILED SPATIAL PLAN FOR THE URBAN AREA OF KERTAJATI-KADIPATEN AND SURROUNDING SURFACES", "id": "PERATURAN MENTERI ATR/ KEPALA BPN REPUBLIK INDONESIA NO 12 TAHUN 2024 TENTANG RENCANA DETAIL TATA RUANG KAWASAN PERKOTAAN KERTAJATI-KADIPATEN DAN SEKITARNYA"}	{"en": "Determination of the Kertajati–Kadipaten RDTR (±10,124 ha) as a reference for the use and control of space, including the airport zone, and must be determined by the Regent.", "id": "Penetapan RDTR Kertajati–Kadipaten (±10.124 ha) sebagai acuan pemanfaatan dan pengendalian ruang, termasuk zona bandara, dan wajib ditetapkan Bupati."}	2025-12-21 11:57:53.479111	2025-11-01 03:57:30.091644	2025-11-01 03:57:30.091644	1
8	[236]	{"en": "Law No. 59 of 2024 concerning the National Long-Term Development Plan", "id": "UU No. 59 tahun 2024 tentang Rencana Pembangunan Jangka Panjang Nasional"}	{"en": "Law Number 59 of 2024 concerning the 2025-2045 National Long-Term Development Plan (RPJPN) is a strategic legal document that serves as the primary roadmap toward the \\"Golden Indonesia 2045\\" vision, aiming to transform Indonesia into a sovereign, advanced, and sustainable archipelagic nation by escaping the middle-income trap. Through eight transformation agendas covering social, economic, and governance sectors, this law mandates developmental synchronization between central and regional governments and serves as a compulsory reference for national and local leadership candidates in formulating their visions and missions to ensure developmental consistency over the next two decades.", "id": "Undang-Undang Nomor 59 Tahun 2024 tentang Rencana Pembangunan Jangka Panjang Nasional (RPJPN) 2025-2045 merupakan dokumen hukum strategis yang berfungsi sebagai peta jalan utama menuju visi Indonesia Emas 2045, yang bertujuan mentransformasikan Indonesia menjadi negara nusantara yang berdaulat, maju, dan berkelanjutan dengan keluar dari jebakan pendapatan menengah (middle-income trap). Melalui delapan agenda transformasi yang mencakup sektor sosial, ekonomi, dan tata kelola, UU ini mewajibkan adanya sinkronisasi pembangunan antara pemerintah pusat dan daerah serta menjadi acuan wajib bagi para calon pemimpin nasional maupun daerah dalam menyusun visi-misi mereka guna memastikan keberlanjutan pembangunan selama dua dekade ke depan."}	\N	2025-12-20 01:59:16.898314	2025-12-20 01:59:16.898314	1
9	[237]	{"en": "Government Regulation No. 13 of 2017 concerning amendments to Government Regulation No. 26 of 2008 concerning the National Spatial Plan", "id": "pp No. 13 Tahun 2017 tentang perubahan atas PP No. 26 Tahun 2008 tentang Rencana Tata Ruang Wilayah Nasional"}	{"en": "Government Regulation Number 13 of 2017 is a strategic regulation that amends Government Regulation Number 26 of 2008 concerning the National Spatial Plan (RTRWN) to align spatial planning policies with national development dynamics, including the integration of national strategic projects, the strengthening of food security, and natural disaster mitigation. Through this update, the government establishes a more rigorous framework for the national urban system, transportation infrastructure networks, and the protection of national strategic areas to achieve more efficient, sectorally synchronized, and sustainable spatial utilization for the period ending in 2028", "id": "Peraturan Pemerintah (PP) Nomor 13 Tahun 2017 merupakan regulasi strategis yang mengubah PP Nomor 26 Tahun 2008 tentang Rencana Tata Ruang Wilayah Nasional (RTRWN) dengan tujuan untuk menyelaraskan kebijakan tata ruang terhadap dinamika pembangunan nasional, termasuk integrasi proyek strategis nasional, penguatan ketahanan pangan, dan mitigasi bencana alam. Melalui pembaruan ini, pemerintah menetapkan kerangka kerja yang lebih ketat bagi sistem perkotaan nasional, jaringan infrastruktur transportasi, serta perlindungan kawasan strategis nasional demi mewujudkan pemanfaatan ruang yang lebih efisien, sinkron secara sektoral, dan berkelanjutan untuk jangka waktu hingga tahun 2028."}	\N	2025-12-20 02:01:53.291375	2025-12-20 02:01:53.291375	1
1	[43]	{"en": "PRESIDENTIAL REGULATION OF THE REPUBLIC OF INDONESIA NUMBER 13 OF 2012 CONCERNING SUMATERA ISLAND SPATIAL PLAN", "id": "PERATURAN PRESIDEN REPUBLIK INDONESIA NOMOR 13 TAHUN 2012 TENTANG RENCANA TATA RUANG PULAU SUMATERA"}	{"en": "Peraturan Presiden (Perpres) No. 13 Tahun 2012 tentang Rencana Tata Ruang Pulau Sumatera. Pedoman pemanfaatan ruang dan pembangunan berkelanjutan di Sumatera.", "id": "Peraturan Presiden (Perpres) No. 13 Tahun 2012 tentang Rencana Tata Ruang Pulau Sumatera. Pedoman pemanfaatan ruang dan pembangunan berkelanjutan di Sumatera."}	2025-12-21 11:58:06.383175	2025-11-01 03:16:10.887282	2025-11-03 00:37:37.160983	1
7	[274]	{"en": "FOR PENTEST", "id": "UNTUK PENTEST"}	{"en": "FOR PENTEST", "id": "UNTUK PENTEST"}	2025-12-21 13:43:27.267277	2025-12-20 01:34:32.113747	2025-12-21 13:43:21.885965	1
10	[238]	{"en": "Presidential Regulation No. 98 of 2021 on the Implementation of Carbon Economic Value for Target Achievement", "id": "Peraturan Presiden Nomor 98 Tahun 2021 Tentang Penyelenggaraan Nilai Ekonomi Karbon untuk Pencapaian Target"}	{"en": "Presidential Regulation Number 98 of 2021 on the Implementation of Carbon Economic Value (CEV) is the primary legal instrument regulating carbon pricing mechanisms in Indonesia to achieve Nationally Determined Contribution (NDC) targets and control greenhouse gas emissions within national development. This regulation introduces a comprehensive framework encompassing carbon trading, carbon levies, and result-based payments, while mandating transparent monitoring and reporting through the National Registry System to ensure a sustainable transition toward a low-carbon economy.", "id": "Peraturan Presiden (Perpres) Nomor 98 Tahun 2021 tentang Penyelenggaraan Nilai Ekonomi Karbon (NEK) merupakan instrumen hukum utama yang mengatur mekanisme harga karbon di Indonesia untuk mencapai target Nationally Determined Contribution (NDC) dan mengendalikan emisi gas rumah kaca dalam pembangunan nasional. Regulasi ini memperkenalkan kerangka kerja komprehensif yang mencakup perdagangan karbon, pungutan atas karbon, dan pembayaran berbasis kinerja, sekaligus mewajibkan sistem pemantauan serta pelaporan yang transparan melalui Sistem Registri Nasional untuk memastikan transisi menuju ekonomi rendah karbon yang berkelanjutan."}	\N	2025-12-20 02:03:13.915427	2025-12-20 02:03:13.915427	1
11	[239]	{"en": "Presidential Instruction No. 1 of 2023 concerning the mainstreaming of biodiversity and sustainable development", "id": "inpres No 1 Tahun 2023 tentang pengarusutamaan keanekaragaman hayati dan pembangunan berkelanjutan"}	{"en": "Presidential Instruction Number 1 of 2023 concerning the Mainstreaming of Biodiversity Conservation in Sustainable Development directs ministries, agencies, and local governments to integrate ecosystem and biodiversity protection into all national development policies to prevent systemic biodiversity loss. This regulation emphasizes the importance of balancing economic growth with environmental sustainability, including the protection of endangered species and the fair utilization of genetic resources, as an effort to strengthen Indonesia's ecosystem resilience amidst the challenges of global climate change.", "id": "Instruksi Presiden (Inpres) Nomor 1 Tahun 2023 tentang Pengarusutamaan Pelestarian Keanekaragaman Hayati dalam Pembangunan Berkelanjutan menginstruksikan kementerian, lembaga, dan pemerintah daerah untuk mengintegrasikan perlindungan ekosistem dan keanekaragaman hayati ke dalam setiap kebijakan pembangunan nasional guna mencegah kehilangan keanekaragaman hayati secara sistemik. Regulasi ini menekankan pentingnya keseimbangan antara pertumbuhan ekonomi dengan keberlanjutan lingkungan, termasuk perlindungan spesies terancam punah dan pemanfaatan sumber daya genetik secara adil, sebagai upaya memperkuat ketahanan ekosistem Indonesia di tengah tantangan perubahan iklim global"}	\N	2025-12-20 02:04:39.119123	2025-12-20 02:04:39.119123	1
12	[240]	{"en": "Indonesia Biodiversity Strategy and Action Plan (IBSAP) 2025–2045 Target 1 on Spatial Planning and Biodiversity, Bappenas", "id": "Indonesia Biodiversity Strategy and Action Plan (IBSAP) 2025 – 2045 Target 1 tentang Tata Ruang dan Biodiversity, Bappenas"}	{"en": "Presidential Instruction Number 1 of 2023 concerning the Mainstreaming of Biodiversity Conservation in Sustainable Development directs ministries, agencies, and local governments to integrate ecosystem and biodiversity protection into all national development policies to prevent systemic biodiversity loss. This regulation emphasizes the importance of balancing economic growth with environmental sustainability, including the protection of endangered species and the fair utilization of genetic resources, as an effort to strengthen Indonesia's ecosystem resilience amidst the challenges of global climate change.", "id": "Target 1 of the Indonesia Biodiversity Strategy and Action Plan (IBSAP) 2025–2045, formulated by Bappenas, focuses on biodiversity-sensitive spatial planning with the goal of ensuring that all areas of high conservation value are managed through inclusive spatial planning to halt the loss of critical ecosystems. This target emphasizes restoring ecological connectivity and protecting wildlife corridors outside formal conservation areas, ensuring that human development expansion does not sacrifice the genetic and species integrity that serves as the foundation for national climate resilience."}	\N	2025-12-20 02:08:02.50502	2025-12-20 02:08:02.50502	1
2	[44]	{"en": "REGULATION OF THE MINISTER OF ATR / HEAD OF BPN RI NO. 11 OF 2023 CONCERNING DATABASE AND PRESENTATION OF MAPS FOR NATIONAL STRATEGIC AREA SPATIAL PLANNING AND DETAILED SPATIAL PLANNING FOR STATE BORDER AREA", "id": "PERATURAN MENTERI ATR / KEPALA BPN RI NO 11 TAHUN 2023 TENTANG BASIS DATA DAN PENYAJIAN PETA RENCANA TATA RUANG KAWASAN STRATEGIS NASIONAL DAN RENCANA DETAIL TATA RUANG KAWASAN PERBATASAN NEGARA"}	{"en": "Regulation of the Minister of ATR/BPN No. 11 of 2023 concerning the Standardization of Databases and Map Presentation for the National Strategic Area Spatial Plan (RTR KSN) and the Detailed Spatial Plan for State Border Areas (RDTR KPN).", "id": "Peraturan Menteri ATR/BPN No. 11 Tahun 2023 tentang standarisasi Basis Data dan Penyajian Peta untuk Rencana Tata Ruang Kawasan Strategis Nasional (RTR KSN) dan Rencana Detail Tata Ruang Kawasan Perbatasan Negara (RDTR KPN)."}	2025-12-21 11:57:56.235245	2025-11-01 03:50:45.191184	2025-11-01 03:50:45.191184	1
\.


--
-- Data for Name: cms_news; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_news (id, cms_news_category_id, thumbnail_ids, title, slug, description, news_content, deleted_at, created_at, updated_at) FROM stdin;
2	2	[58]	{"en": "RIMBA Program Team Participates in GEF-8 Asia Pacific Regional Workshop", "id": "Tim Program RIMBA Berpartisipasi dalam GEF-8 Asia Pacific Regional Workshop"}	{"en": "rimba-program-team-participates-in-gef-8-asia-pacific-regional-workshop", "id": "tim-program-rimba-berpartisipasi-dalam-gef-8-asia-pacific-regional-workshop"}	{"en": "The RIMBA Program Team participated in the GEF-8 Asia Pacific Regional Workshop, which aimed to strengthen regional collaboration in conservation and sustainable development efforts.", "id": "Tim Program RIMBA turut berpartisipasi dalam GEF-8 Asia Pacific Regional Workshop, yang bertujuan untuk memperkuat kolaborasi regional dalam upaya konservasi dan pembangunan berkelanjutan."}	{"en": "<p>Bali, the RIMBA Program participated in an international event titled the <em><strong>Global Environment Facility (GEF)-8 Asia Pacific Regional Workshop</strong></em>. This event was organized by the GEF in collaboration with the Ministry of Environment and Forestry (KLHK), and took place in the Nusa Dua area of ​​Bali from January 10-12, 2023.</p>\\n<p>The event was opened by Deputy Minister of Environment and Forestry Alue Dohong, who, along with GEF CEO Carlos Manuel Rodriguez, had previously visited the exhibition booths of various GEF-funded programs, one of which was the RIMBA Program booth. At the RIMBA Program booth, Alue Dohong, Carlos Rodriguez, and their entourage were welcomed by the RIMBA Program Team Leader, Barano Siswa Sulistyawan, who provided an explanation of the RIMBA program.</p>\\n<p>Carlos Rodriguez assessed that strengthening the protection and preservation of biodiversity and ecosystems in the RIMBA corridor is crucial. If the RIMBA program is successfully implemented, it can be replicated in four other corridors on the island of Sumatra.</p>\\n<p>The GEF is an international funding agency that assists developing countries in addressing environmental issues. In Indonesia, the GEF funds numerous activities targeting issues such as biodiversity, habitat and protected animal conservation, ecosystem restoration, chemical and waste pollution reduction, clean energy, social forestry, fisheries management, climate change mitigation, and more.</p>\\n<p>The RIMBA program itself is one of the programs supported by the GEF through the United Nations Environment Programme (UNEP), with the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) acting as the National Executing Agency (NEA).</p>\\n<p>The RIMBA program is an effort to save Sumatra's ecosystem and serves as a model for realizing green economic development through low-carbon development, biodiversity conservation and forest restoration efforts, and promoting the economic value of environmental services.</p>\\n<p>The RIMBA program's working area is within the RIMBA corridor, which encompasses three provinces: Riau, Jambi, and West Sumatra, with a total area of ​​approximately 3.8 million hectares. The RIMBA Corridor naturally connects several National Strategic Areas (KSN) with high biodiversity value, namely Kerinci Seblat National Park (TN), Rimbang Baling National Park (TN), Bukit Batabuh National Park (TN), Bukti Tigapuluh National Park (TN), and Berbak National Park (TN).</p>\\n<p>From 2022 to early 2023, the Partnership for Governance Reform (KEMITRAAN) was entrusted with implementing the inception phase of the RIMBA program. During this phase, KEMITRAAN, together with the Directorate General of Spatial Planning, Ministry of ATR/BPN, conducted a series of program consolidation, coordination, and synchronization activities with various stakeholders, both at the central and regional levels. Furthermore, data updates and the formation of Project Management Unit (PMU) teams at the national level and Project Implementation Units (PIUs) at the regional level were also carried out. The program is planned to run until 2028.</p>\\n<p>\\"This activity has provided us with a lot of learning that we will later apply to the RIMBA Program. The RIMBA program will begin implementation this year (2023), and gaining knowledge at the start of the program is very helpful,\\" said Fransisca Weni Tyas, Directorate of Spatial Utilization Synchronization, Ministry of ATR/BPN, who also attended the activity.</p>\\n<p><em><strong>Source : https://www.kemitraan.or.id/publication/tim-program-rimba-berpartisipasi-dalam-gef-8-asia-pacific-regional-workshop</strong></em></p>", "id": "<p><strong>Bali</strong>, Program RIMBA berpartisipasi dalam kegiatan internasional bertajuk&nbsp;<strong><em>Global Environment Facility (GEF)-8 Asia Pasific Regional Workshop</em></strong>. Kegiatan ini diselenggarakan oleh GEF bekerjasama dengan Kementerian Lingkungan Hidup dan Kehutanan (KLHK), bertempat di kawasan Nusa Dua Bali pada tanggal 10-12 Januari 2023.&nbsp;</p>\\n<p>Kegiatan dibuka oleh Wakil Menteri LHK Alue Dohong yang sebelumnya, bersama dengan CEO GEF Carlos Manuel Rodriguez, telah mengunjungi stan pameran dari berbagai program yang didanai oleh GEF, salah satunya adalah stan Program RIMBA. Di stan Program RIMBA, Alue Dohong, Carlos Rodriguez, dan rombongan diterima oleh Team Leader Program RIMBA, Barano Siswa Sulistyawan yang memberikan penjelasan mengenai program RIMBA.</p>\\n<p>Carlos Rodriguez menilai, perlindungan dan pelestarian keanekaragaman hayati dan ekosistem yang ada di koridor RIMBA sangat penting untuk diperkuat. Jika program RIMBA berhasil dilaksanakan selanjutnya akan dapat direplikasikan di empat koridor lain yang ada di pulau Sumatera.</p>\\n<p>GEF merupakan lembaga pendanaan internasional yang membantu negara-negara berkembang dalam mengatasi permasalahan lingkungan. Di Indonesia, GEF mendanai banyak kegiatan yang menyasar pada isu-isu seperti: keanekaragaman hayati, konservasi habitat dan hewan dilindungi, restorasi ekosistem, pengurangan polusi dari bahan kimia dan limbah, energi bersih, perhutanan sosial, pengelolaan perikanan, mitigasi perubahan iklim, dan lain sebagainya.</p>\\n<p>Program RIMBA sendiri merupakan salah satu dari program yang didukung GEF melalui&nbsp;<em>United Nations Environment Programme</em>&nbsp;(UNEP) dengan Kementerian Agraria dan Tata Ruang / Badan Pertanahan Nasional (ATR/BPN) yang bertindak sebagai&nbsp;<em>National Executing Agency</em>&nbsp;(NEA).&nbsp;</p>\\n<p>Program RIMBA merupakan sebuah upaya penyelamatan ekosistem Sumatera dan menjadi model untuk dapat mewujudkan pengembangan ekonomi hijau melalui pembangunan rendah karbon, upaya konservasi keanekaragaman hayati &amp; restorasi hutan, serta mempromosikan nilai ekonomi jasa lingkungan.&nbsp;</p>\\n<p>Wilayah kerja Program RIMBA berada di area koridor RIMBA yang meliputi 3 provinsi, yaitu: Provinsi Riau, Jambi, dan Sumatera Barat, dengan luas total area sekitar 3,8 juta Ha. Koridor RIMBA merupakan penghubung alami beberapa Kawasan Strategis Nasional (KSN) yang memiliki nilai biodiversitas tinggi, yaitu kawasan Taman Nasional (TN) Kerinci Seblat, TN Rimbang Baling, TN Bukit Batabuh, TN Bukti Tigapuluh dan TN Berbak.&nbsp;</p>\\n<p>Pada tahun 2022 hingga awal 2023, Kemitraan bagi Pembaruan Tata Pemerintahan (KEMITRAAN) dipercaya untuk menjalankan fase<em>&nbsp;inception</em>&nbsp;program RIMBA. Dalam fase ini, KEMITRAAN bersama Ditjen Tata Ruang Kementerian ATR/BPN melakukan serangkaian kegiatan konsolidasi, koordinasi, dan sinkronisasi program dengan berbagai stakeholder, baik di pusat maupun di daerah. Selain itu, dilakukan juga pemutakhiran data dan pembentukan tim&nbsp;<em>Project Manajemen Unit</em>&nbsp;(PMU) di tingkat nasional, serta&nbsp;<em>Project Implementation Unit</em>&nbsp;(PIU) di daerah. Program direncanakan akan dilaksanakan hingga tahun 2028.&nbsp;</p>\\n<p>&ldquo;Kegiatan ini memberikan kami banyak pembelajaran untuk nantinya kami terapkan di Program RIMBA. Program RIMBA akan mulai implementasi di tahun ini (2023) dan mendapat pengetahuan di awal program sangat membantu&rdquo;, ujar Fransisca Weni Tyas, Direktorat Sinkronisasi Pemanfaatan Ruang, Kementerian ATR/BPN yang juga hadir dalam kegiatan ini.</p>\\n<p><em><strong>Sumber : https://www.kemitraan.or.id/publication/tim-program-rimba-berpartisipasi-dalam-gef-8-asia-pacific-regional-workshop</strong></em></p>"}	2025-12-19 16:26:31.787255	2025-11-02 02:43:54.693966	2025-11-03 00:44:02.244438
3	2	[221]	{"en": "RIMBA Program Team Participates in GEF-8 Asia Pacific Regional Workshop", "id": "Tim Program RIMBA Berpartisipasi dalam GEF-8 Asia Pacific Regional Workshop"}	{"en": "rimba-program-team-participates-in-gef-8-asia-pacific-regional-workshop", "id": "tim-program-rimba-berpartisipasi-dalam-gef-8-asia-pacific-regional-workshop"}	{"en": "The RIMBA Program Team participated in the GEF-8 Asia Pacific Regional Workshop, which aimed to strengthen regional collaboration in conservation and sustainable development efforts.", "id": "Tim Program RIMBA turut berpartisipasi dalam GEF-8 Asia Pacific Regional Workshop, yang bertujuan untuk memperkuat kolaborasi regional dalam upaya konservasi dan pembangunan berkelanjutan."}	{"en": "<p>Bali, the RIMBA Program participated in an international event titled the <em><strong>Global Environment Facility (GEF)-8 Asia Pacific Regional Workshop</strong></em>. This event was organized by the GEF in collaboration with the Ministry of Environment and Forestry (KLHK), and took place in the Nusa Dua area of ​​Bali from January 10-12, 2023.</p>\\n<p>The event was opened by Deputy Minister of Environment and Forestry Alue Dohong, who, along with GEF CEO Carlos Manuel Rodriguez, had previously visited the exhibition booths of various GEF-funded programs, one of which was the RIMBA Program booth. At the RIMBA Program booth, Alue Dohong, Carlos Rodriguez, and their entourage were welcomed by the RIMBA Program Team Leader, Barano Siswa Sulistyawan, who provided an explanation of the RIMBA program.</p>\\n<p>Carlos Rodriguez assessed that strengthening the protection and preservation of biodiversity and ecosystems in the RIMBA corridor is crucial. If the RIMBA program is successfully implemented, it can be replicated in four other corridors on the island of Sumatra.</p>\\n<p>The GEF is an international funding agency that assists developing countries in addressing environmental issues. In Indonesia, the GEF funds numerous activities targeting issues such as biodiversity, habitat and protected animal conservation, ecosystem restoration, chemical and waste pollution reduction, clean energy, social forestry, fisheries management, climate change mitigation, and more.</p>\\n<p>The RIMBA program itself is one of the programs supported by the GEF through the United Nations Environment Programme (UNEP), with the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) acting as the National Executing Agency (NEA).</p>\\n<p>The RIMBA program is an effort to save Sumatra's ecosystem and serves as a model for realizing green economic development through low-carbon development, biodiversity conservation and forest restoration efforts, and promoting the economic value of environmental services.</p>\\n<p>The RIMBA program's working area is within the RIMBA corridor, which encompasses three provinces: Riau, Jambi, and West Sumatra, with a total area of ​​approximately 3.8 million hectares. The RIMBA Corridor naturally connects several National Strategic Areas (KSN) with high biodiversity value, namely Kerinci Seblat National Park (TN), Rimbang Baling National Park (TN), Bukit Batabuh National Park (TN), Bukti Tigapuluh National Park (TN), and Berbak National Park (TN).</p>\\n<p>From 2022 to early 2023, the Partnership for Governance Reform (KEMITRAAN) was entrusted with implementing the inception phase of the RIMBA program. During this phase, KEMITRAAN, together with the Directorate General of Spatial Planning, Ministry of ATR/BPN, conducted a series of program consolidation, coordination, and synchronization activities with various stakeholders, both at the central and regional levels. Furthermore, data updates and the formation of Project Management Unit (PMU) teams at the national level and Project Implementation Units (PIUs) at the regional level were also carried out. The program is planned to run until 2028.</p>\\n<p>\\"This activity has provided us with a lot of learning that we will later apply to the RIMBA Program. The RIMBA program will begin implementation this year (2023), and gaining knowledge at the start of the program is very helpful,\\" said Fransisca Weni Tyas, Directorate of Spatial Utilization Synchronization, Ministry of ATR/BPN, who also attended the activity.</p>\\n<p><em><strong>Source : https://www.kemitraan.or.id/publication/tim-program-rimba-berpartisipasi-dalam-gef-8-asia-pacific-regional-workshop</strong></em></p>", "id": "<p><strong>Bali</strong>, Program RIMBA berpartisipasi dalam kegiatan internasional bertajuk&nbsp;<strong><em>Global Environment Facility (GEF)-8 Asia Pasific Regional Workshop</em></strong>. Kegiatan ini diselenggarakan oleh GEF bekerjasama dengan Kementerian Lingkungan Hidup dan Kehutanan (KLHK), bertempat di kawasan Nusa Dua Bali pada tanggal 10-12 Januari 2023.&nbsp;</p>\\n<p>Kegiatan dibuka oleh Wakil Menteri LHK Alue Dohong yang sebelumnya, bersama dengan CEO GEF Carlos Manuel Rodriguez, telah mengunjungi stan pameran dari berbagai program yang didanai oleh GEF, salah satunya adalah stan Program RIMBA. Di stan Program RIMBA, Alue Dohong, Carlos Rodriguez, dan rombongan diterima oleh Team Leader Program RIMBA, Barano Siswa Sulistyawan yang memberikan penjelasan mengenai program RIMBA.</p>\\n<p>Carlos Rodriguez menilai, perlindungan dan pelestarian keanekaragaman hayati dan ekosistem yang ada di koridor RIMBA sangat penting untuk diperkuat. Jika program RIMBA berhasil dilaksanakan selanjutnya akan dapat direplikasikan di empat koridor lain yang ada di pulau Sumatera.</p>\\n<p>GEF merupakan lembaga pendanaan internasional yang membantu negara-negara berkembang dalam mengatasi permasalahan lingkungan. Di Indonesia, GEF mendanai banyak kegiatan yang menyasar pada isu-isu seperti: keanekaragaman hayati, konservasi habitat dan hewan dilindungi, restorasi ekosistem, pengurangan polusi dari bahan kimia dan limbah, energi bersih, perhutanan sosial, pengelolaan perikanan, mitigasi perubahan iklim, dan lain sebagainya.</p>\\n<p>Program RIMBA sendiri merupakan salah satu dari program yang didukung GEF melalui&nbsp;<em>United Nations Environment Programme</em>&nbsp;(UNEP) dengan Kementerian Agraria dan Tata Ruang / Badan Pertanahan Nasional (ATR/BPN) yang bertindak sebagai&nbsp;<em>National Executing Agency</em>&nbsp;(NEA).&nbsp;</p>\\n<p>Program RIMBA merupakan sebuah upaya penyelamatan ekosistem Sumatera dan menjadi model untuk dapat mewujudkan pengembangan ekonomi hijau melalui pembangunan rendah karbon, upaya konservasi keanekaragaman hayati &amp; restorasi hutan, serta mempromosikan nilai ekonomi jasa lingkungan.&nbsp;</p>\\n<p>Wilayah kerja Program RIMBA berada di area koridor RIMBA yang meliputi 3 provinsi, yaitu: Provinsi Riau, Jambi, dan Sumatera Barat, dengan luas total area sekitar 3,8 juta Ha. Koridor RIMBA merupakan penghubung alami beberapa Kawasan Strategis Nasional (KSN) yang memiliki nilai biodiversitas tinggi, yaitu kawasan Taman Nasional (TN) Kerinci Seblat, TN Rimbang Baling, TN Bukit Batabuh, TN Bukti Tigapuluh dan TN Berbak.&nbsp;</p>\\n<p>Pada tahun 2022 hingga awal 2023, Kemitraan bagi Pembaruan Tata Pemerintahan (KEMITRAAN) dipercaya untuk menjalankan fase<em>&nbsp;inception</em>&nbsp;program RIMBA. Dalam fase ini, KEMITRAAN bersama Ditjen Tata Ruang Kementerian ATR/BPN melakukan serangkaian kegiatan konsolidasi, koordinasi, dan sinkronisasi program dengan berbagai stakeholder, baik di pusat maupun di daerah. Selain itu, dilakukan juga pemutakhiran data dan pembentukan tim&nbsp;<em>Project Manajemen Unit</em>&nbsp;(PMU) di tingkat nasional, serta&nbsp;<em>Project Implementation Unit</em>&nbsp;(PIU) di daerah. Program direncanakan akan dilaksanakan hingga tahun 2028.&nbsp;</p>\\n<p>&ldquo;Kegiatan ini memberikan kami banyak pembelajaran untuk nantinya kami terapkan di Program RIMBA. Program RIMBA akan mulai implementasi di tahun ini (2023) dan mendapat pengetahuan di awal program sangat membantu&rdquo;, ujar Fransisca Weni Tyas, Direktorat Sinkronisasi Pemanfaatan Ruang, Kementerian ATR/BPN yang juga hadir dalam kegiatan ini.</p>\\n<p><em><strong>Sumber : https://www.kemitraan.or.id/publication/tim-program-rimba-berpartisipasi-dalam-gef-8-asia-pacific-regional-workshop</strong></em></p>"}	\N	2025-12-19 16:26:42.24479	2025-12-19 16:26:42.24479
1	1	[57]	{"en": "Collaborating on the RIMBA project, the Ministry of ATR/BPN collaborates with three universities to promote green and inclusive spatial planning.", "id": "Kolaborasi proyek RIMBA, Kementerian ATR/BPN gandeng tiga universitas dorong tata ruang hijau dan inklusif"}	{"en": "collaborating-on-the-rimba-project-the-ministry-of-atr-bpn-collaborates-with-three-universities-to-promote-green-and-inclusive-spatial-planning", "id": "kolaborasi-proyek-rimba-kementerian-atr-bpn-gandeng-tiga-universitas-dorong-tata-ruang-hijau-dan-inklusif"}	{"en": "The Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) is collaborating with three universities to develop the RIMBA (Inclusive and Sustainable Space).", "id": "Kementerian ATR/BPN bekerja sama dengan tiga universitas untuk mengembangkan proyek RIMBA (Ruang Inklusif dan Berkelanjutan)."}	{"en": "<p>In an effort to strengthen sustainable spatial governance in the Sumatra region, the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN), through the Directorate General of Spatial Planning, signed a Cooperation Agreement (PKS) for the Type II Self-Managed RIMBA Project with three universities.</p>\\n<p>The three universities are Riau University, Andalas University, and Jambi University.</p>\\n<p>\\"This collaboration is crucial, especially in protecting the territories of indigenous communities located in the ecological corridors of Jambi, Riau, and West Sumatra. We must ensure that they are legally protected and accommodated in spatial planning policies,\\" said Director General of Spatial Planning Suyus Windayana in a meeting held in the Bromo Room, Directorate General of Spatial Planning Building, Jakarta, Tuesday (July 15, 2025).</p>\\n<p>The RIMBA Project is a strategic program implemented with the aim of supporting biodiversity conservation and strengthening environmentally sound spatial planning in three priority provinces: Riau, Jambi, and West Sumatra.</p>\\n<p>The Director General of Spatial Planning also expressed his appreciation for the support of various parties for RIMBA, including the active contributions of local governments and academics.</p>\\n<p>RIMBA emphasizes not only biodiversity conservation but also the integration of development and environmental preservation.</p>\\n<p>\\"Spatial planning must balance industrial and residential areas with green areas to ensure development remains sustainable and comfortable for all living things,\\" emphasized Suyus Windayana.</p>\\n<p>The collaboration outlined in the PKS covers three main focuses: design for connectivity and wildlife migration, peat ecosystem restoration strategies, and facilitation of participatory land use planning, including alternative solutions for unauthorized settlements.</p>\\n<p>The Director of Spatial Planning, Nuki Harniati, hopes this partnership with academics will produce applicable and relevant policy recommendations.</p>\\n<p>\\"We are very grateful for the support from our university colleagues. We hope this collaboration will produce beneficial outputs and strengthen the basis for future policies,\\" she said.</p>\\n<p>The PKS was signed by the Dean of the Faculty of Agriculture, Riau University, the Head of the Research and Community Service Institute of Andalas University, the Head of the Research and Community Service Institute of Jambi University, and the Director General of Spatial Planning.</p>\\n<p>Also present at the event were the Director of Communal Land Regulation, Institutional Relations, and Land Deed Officials (PPAT), Iskandar Syah; the Secretary of the Directorate General of Spatial Planning, Reny Windyawati; and the Team Leader of the RIMBA Project Management Unit (PMU), Barano Siswa Sulistiawan.</p>\\n<p><em><strong>Source : https://sumbar.antaranews.com/berita/695817/kolaborasi-proyek-rimba-kementerian-atrbpn-gandeng-tiga-universitas-dorong-tata-ruang-hijau-dan-inklusif</strong></em></p>", "id": "<p>Dalam upaya memperkuat tata kelola ruang yang berkelanjutan di wilayah Sumatra, Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) melalui Direktorat Jenderal (Ditjen) Tata Ruang menandatangani Perjanjian Kerja Sama (PKS) Proyek RIMBA Swakelola Tipe II dengan tiga perguruan tinggi.</p>\\n<p>Ketiga universitas itu meliputi Universitas Riau, Universitas Andalas dan Universitas Jambi.</p>\\n<p>\\"Kolaborasi ini sangat penting, terutama dalam menjaga wilayah masyarakat hukum adat yang berada di koridor ekologis Jambi, Riau, dan Sumatra Barat. Kita harus memastikan bahwa mereka terlindungi secara legal dan diakomodasi dalam kebijakan tata ruang,\\" ujar Direktur Jenderal (Dirjen) Tata Ruang Suyus Windayana dalam pertemuan yang berlangsung di Ruang Bromo, Gedung Ditjen Tata Ruang, Jakarta, Selasa (15/7/2025).</p>\\n<p>Proyek RIMBA merupakan program strategis yang dijalankan dengan tujuan untuk mendukung pelestarian keanekaragaman hayati dan memperkuat tata ruang yang berwawasan lingkungan di tiga provinsi prioritas, yakni Riau, Jambi, dan Sumatera Barat.</p>\\n<p>Dirjen Tata Ruang pun menyampaikan apresiasinya atas dukungan berbagai pihak terhadap RIMBA, termasuk kontribusi aktif dari pemerintah daerah dan kalangan akademisi.</p>\\n<p>RIMBA tidak hanya menekankan konservasi keanekaragaman hayati, tetapi juga integrasi antara pembangunan dan pelestarian lingkungan.</p>\\n<p>\\"Tata ruang harus menyeimbangkan kawasan industri dan permukiman dengan kawasan hijau agar pembangunan tetap berkelanjutan dan nyaman bagi seluruh makhluk hidup,\\" tegas Suyus Windayana.</p>\\n<p>Kerja sama yang dituangkan dalam PKS mencakup tiga fokus utama, yakni desain konektivitas dan migrasi satwa, strategi pemulihan ekosistem gambut, serta fasilitasi perencanaan penggunaan lahan secara partisipatif, termasuk solusi alternatif terhadap permukiman tidak berizin.</p>\\n<p>Direktur Perencanaan Tata Ruang Nuki Harniati, berharap kemitraan dengan akademisi ini dapat menghasilkan rekomendasi kebijakan yang aplikatif dan relevan.</p>\\n<p>\\"Kami sangat berterima kasih atas dukungan dari rekan-rekan universitas. Semoga kerja sama ini bisa memberikan output yang bermanfaat dan memperkuat dasar kebijakan ke depan,\\" ungkapnya.</p>\\n<p>Adapun penandatanganan PKS dilakukan oleh Dekan Fakultas Pertanian Universitas Riau, Ketua Lembaga Penelitian dan Pengabdian Masyarakat Universitas Andalas, Kepala Lembaga Penelitian dan Pengabdian Kepada Masyarakat Universitas Jambi, serta Dirjen Tata Ruang.</p>\\n<p>Hadir pula dalam kegiatan ini, Direktur Pengaturan Tanah Komunal, Hubungan Kelembagaan dan PPAT, Iskandar Syah, Sekretaris Direktorat Jenderal Tata Ruang, Reny Windyawati;/ serta Team Leader Project Management Unit (PMU) RIMBA, Barano Siswa Sulistiawan.</p>\\n<p><em><strong>Sumber : https://sumbar.antaranews.com/berita/695817/kolaborasi-proyek-rimba-kementerian-atrbpn-gandeng-tiga-universitas-dorong-tata-ruang-hijau-dan-inklusif</strong></em></p>"}	2025-12-19 16:28:53.644083	2025-11-02 02:37:37.173721	2025-11-02 04:23:35.140405
4	1	[222]	{"en": "Collaborating on the RIMBA project, the Ministry of ATR/BPN collaborates with three universities to promote green and inclusive spatial planning.", "id": "Kolaborasi proyek RIMBA, Kementerian ATR/BPN gandeng tiga universitas dorong tata ruang hijau dan inklusif"}	{"en": "collaborating-on-the-rimba-project-the-ministry-of-atr-bpn-collaborates-with-three-universities-to-promote-green-and-inclusive-spatial-planning", "id": "kolaborasi-proyek-rimba-kementerian-atr-bpn-gandeng-tiga-universitas-dorong-tata-ruang-hijau-dan-inklusif"}	{"en": "The Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) is collaborating with three universities to develop the RIMBA (Inclusive and Sustainable Space).", "id": "Kementerian ATR/BPN bekerja sama dengan tiga universitas untuk mengembangkan proyek RIMBA (Ruang Inklusif dan Berkelanjutan)."}	{"en": "<p>In an effort to strengthen sustainable spatial governance in the Sumatra region, the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN), through the Directorate General of Spatial Planning, signed a Cooperation Agreement (PKS) for the Type II Self-Managed RIMBA Project with three universities.</p>\\n<p>The three universities are Riau University, Andalas University, and Jambi University.</p>\\n<p>\\"This collaboration is crucial, especially in protecting the territories of indigenous communities located in the ecological corridors of Jambi, Riau, and West Sumatra. We must ensure that they are legally protected and accommodated in spatial planning policies,\\" said Director General of Spatial Planning Suyus Windayana in a meeting held in the Bromo Room, Directorate General of Spatial Planning Building, Jakarta, Tuesday (July 15, 2025).</p>\\n<p>The RIMBA Project is a strategic program implemented with the aim of supporting biodiversity conservation and strengthening environmentally sound spatial planning in three priority provinces: Riau, Jambi, and West Sumatra.</p>\\n<p>The Director General of Spatial Planning also expressed his appreciation for the support of various parties for RIMBA, including the active contributions of local governments and academics.</p>\\n<p>RIMBA emphasizes not only biodiversity conservation but also the integration of development and environmental preservation.</p>\\n<p>\\"Spatial planning must balance industrial and residential areas with green areas to ensure development remains sustainable and comfortable for all living things,\\" emphasized Suyus Windayana.</p>\\n<p>The collaboration outlined in the PKS covers three main focuses: design for connectivity and wildlife migration, peat ecosystem restoration strategies, and facilitation of participatory land use planning, including alternative solutions for unauthorized settlements.</p>\\n<p>The Director of Spatial Planning, Nuki Harniati, hopes this partnership with academics will produce applicable and relevant policy recommendations.</p>\\n<p>\\"We are very grateful for the support from our university colleagues. We hope this collaboration will produce beneficial outputs and strengthen the basis for future policies,\\" she said.</p>\\n<p>The PKS was signed by the Dean of the Faculty of Agriculture, Riau University, the Head of the Research and Community Service Institute of Andalas University, the Head of the Research and Community Service Institute of Jambi University, and the Director General of Spatial Planning.</p>\\n<p>Also present at the event were the Director of Communal Land Regulation, Institutional Relations, and Land Deed Officials (PPAT), Iskandar Syah; the Secretary of the Directorate General of Spatial Planning, Reny Windyawati; and the Team Leader of the RIMBA Project Management Unit (PMU), Barano Siswa Sulistiawan.</p>\\n<p><em><strong>Source : https://sumbar.antaranews.com/berita/695817/kolaborasi-proyek-rimba-kementerian-atrbpn-gandeng-tiga-universitas-dorong-tata-ruang-hijau-dan-inklusif</strong></em></p>", "id": "<p>Dalam upaya memperkuat tata kelola ruang yang berkelanjutan di wilayah Sumatra, Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) melalui Direktorat Jenderal (Ditjen) Tata Ruang menandatangani Perjanjian Kerja Sama (PKS) Proyek RIMBA Swakelola Tipe II dengan tiga perguruan tinggi.</p>\\n<p>Ketiga universitas itu meliputi Universitas Riau, Universitas Andalas dan Universitas Jambi.</p>\\n<p>\\"Kolaborasi ini sangat penting, terutama dalam menjaga wilayah masyarakat hukum adat yang berada di koridor ekologis Jambi, Riau, dan Sumatra Barat. Kita harus memastikan bahwa mereka terlindungi secara legal dan diakomodasi dalam kebijakan tata ruang,\\" ujar Direktur Jenderal (Dirjen) Tata Ruang Suyus Windayana dalam pertemuan yang berlangsung di Ruang Bromo, Gedung Ditjen Tata Ruang, Jakarta, Selasa (15/7/2025).</p>\\n<p>Proyek RIMBA merupakan program strategis yang dijalankan dengan tujuan untuk mendukung pelestarian keanekaragaman hayati dan memperkuat tata ruang yang berwawasan lingkungan di tiga provinsi prioritas, yakni Riau, Jambi, dan Sumatera Barat.</p>\\n<p>Dirjen Tata Ruang pun menyampaikan apresiasinya atas dukungan berbagai pihak terhadap RIMBA, termasuk kontribusi aktif dari pemerintah daerah dan kalangan akademisi.</p>\\n<p>RIMBA tidak hanya menekankan konservasi keanekaragaman hayati, tetapi juga integrasi antara pembangunan dan pelestarian lingkungan.</p>\\n<p>\\"Tata ruang harus menyeimbangkan kawasan industri dan permukiman dengan kawasan hijau agar pembangunan tetap berkelanjutan dan nyaman bagi seluruh makhluk hidup,\\" tegas Suyus Windayana.</p>\\n<p>Kerja sama yang dituangkan dalam PKS mencakup tiga fokus utama, yakni desain konektivitas dan migrasi satwa, strategi pemulihan ekosistem gambut, serta fasilitasi perencanaan penggunaan lahan secara partisipatif, termasuk solusi alternatif terhadap permukiman tidak berizin.</p>\\n<p>Direktur Perencanaan Tata Ruang Nuki Harniati, berharap kemitraan dengan akademisi ini dapat menghasilkan rekomendasi kebijakan yang aplikatif dan relevan.</p>\\n<p>\\"Kami sangat berterima kasih atas dukungan dari rekan-rekan universitas. Semoga kerja sama ini bisa memberikan output yang bermanfaat dan memperkuat dasar kebijakan ke depan,\\" ungkapnya.</p>\\n<p>Adapun penandatanganan PKS dilakukan oleh Dekan Fakultas Pertanian Universitas Riau, Ketua Lembaga Penelitian dan Pengabdian Masyarakat Universitas Andalas, Kepala Lembaga Penelitian dan Pengabdian Kepada Masyarakat Universitas Jambi, serta Dirjen Tata Ruang.</p>\\n<p>Hadir pula dalam kegiatan ini, Direktur Pengaturan Tanah Komunal, Hubungan Kelembagaan dan PPAT, Iskandar Syah, Sekretaris Direktorat Jenderal Tata Ruang, Reny Windyawati;/ serta Team Leader Project Management Unit (PMU) RIMBA, Barano Siswa Sulistiawan.</p>\\n<p><em><strong>Sumber : https://sumbar.antaranews.com/berita/695817/kolaborasi-proyek-rimba-kementerian-atrbpn-gandeng-tiga-universitas-dorong-tata-ruang-hijau-dan-inklusif</strong></em></p>"}	\N	2025-12-19 16:28:57.022699	2025-12-19 16:28:57.022699
6	2	[224]	{"en": "Rimba Ecosystem Corridor Preserves Local Cultural and Culinary Heritage in the Heart of Sumatra", "id": "Koridor Ekosistem Rimba Jaga Warisan Budaya dan Kuliner Lokal di Jantung Sumatra"}	{"en": "rimba-ecosystem-corridor-preserves-local-cultural-and-culinary-heritage-in-the-heart-of-sumatra", "id": "koridor-ekosistem-rimba-jaga-warisan-budaya-dan-kuliner-lokal-di-jantung-sumatra"}	{"en": "This article examines the vital role of the Rimba Ecosystem Corridor in the Heart of Sumatra in protecting biodiversity while preserving unique cultural heritage and local culinary riches. Through the synergy between nature conservation and community empowerment, this initiative strives to keep ancestral identities alive amidst the challenges of modernization, creating a harmonious balance between environmental protection and the sustainability of local traditions.", "id": "Artikel ini mengulas peran vital Koridor Ekosistem Rimba di Jantung Sumatra dalam melindungi keanekaragaman hayati sekaligus melestarikan warisan budaya dan kekayaan kuliner lokal yang unik. Melalui sinergi antara konservasi alam dan pemberdayaan masyarakat, inisiatif ini berupaya menjaga identitas leluhur agar tetap hidup di tengah tantangan modernisasi, menciptakan keseimbangan harmonis antara perlindungan lingkungan dan keberlanjutan tradisi masyarakat setempat."}	{"en": "<div id=\\"model-response-message-contentr_a233861099185b97\\" class=\\"markdown markdown-main-panel stronger enable-updated-hr-color\\" dir=\\"ltr\\" style=\\"text-align: justify;\\" aria-live=\\"polite\\" aria-busy=\\"false\\">\\n<p data-path-to-node=\\"0\\">&nbsp;</p>\\n<h2 style=\\"text-align: justify;\\" data-path-to-node=\\"2\\">The RIMBA Ecosystem Corridor: Integrating Local Wisdom and Green Economy</h2>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"3\\">The <strong data-path-to-node=\\"3\\" data-index-in-node=\\"4\\">Riau&ndash;Jambi&ndash;West Sumatra (RIMBA) Ecosystem Corridor</strong> has faced increasing environmental pressure in recent years. Established through Presidential Regulation (Perpres) No. 13 of 2012, the region faces significant challenges due to declining forest cover, habitat fragmentation, and the degradation of river ecosystem quality.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"4\\">As one of the five vital ecosystem corridors in Sumatra, RIMBA serves as a strategic link for the habitats of key wildlife, ranging from the Sumatran elephant to the Sumatran tiger, both of which rely on the preservation of the surrounding landscape. Amidst these threats, the development of a <strong data-path-to-node=\\"4\\" data-index-in-node=\\"294\\">green economy</strong> has become an approach championed by the government and development partners. This model seeks to balance biodiversity protection and carbon emission reduction with the improvement of the welfare of communities living around the corridor.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"5\\">RIMBA is not merely an ecological zone; it is a living space for indigenous communities who have long protected the forests and rivers through traditional laws. Local wisdom in this region is a vital force for preservation and community economic growth. Various traditional practices that continue today demonstrate that sustainability can be achieved when the community is involved as environmental guardians. Several villages within the corridor have even begun developing culture-based tourism, further strengthening the green economy.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"6\\">The Preserved Heritage of Silokek</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"7\\">One example of local wisdom in the RIMBA Corridor is found in <strong data-path-to-node=\\"7\\" data-index-in-node=\\"62\\">Silokek Tourism Village</strong>, Sijunjung Regency, West Sumatra. The village is inhabited by four main tribes: <em data-path-to-node=\\"7\\" data-index-in-node=\\"166\\">Patopang Bukik, Patopang Bough, Melayu Gadang,</em> and <em data-path-to-node=\\"7\\" data-index-in-node=\\"217\\">Melayu Ketek</em>. Silokek is located in a karst cliff area split by the Batang Kuantan River, which has historically served as a vital trade route connecting the interior with Sumatra&rsquo;s coastal regions.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"8\\">Most Silokek residents are farmers and master boatbuilders&mdash;skills passed down through generations that form part of their cultural identity. Beyond its natural wealth, Silokek is renowned for its traditional arts and rituals, such as <em data-path-to-node=\\"8\\" data-index-in-node=\\"234\\">randai</em>, traditional <em data-path-to-node=\\"8\\" data-index-in-node=\\"254\\">silat</em>, <em data-path-to-node=\\"8\\" data-index-in-node=\\"261\\">dendang</em>, and <em data-path-to-node=\\"8\\" data-index-in-node=\\"274\\">saluang</em>. The <strong data-path-to-node=\\"8\\" data-index-in-node=\\"287\\">Bakaua Adat</strong> ritual is a significant cultural event held after the harvest as a gesture of gratitude for the earth's bounty. Another tradition, <strong data-path-to-node=\\"8\\" data-index-in-node=\\"430\\">Maratik</strong>, is a processional ritual to seek protection from threats and diseases, reflecting how the community views nature as a space that must be protected both spiritually and socially.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"9\\">Tourism Thriving from Tradition</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"10\\">Not far from Silokek lies the <strong data-path-to-node=\\"10\\" data-index-in-node=\\"30\\">Sijunjung Traditional Village</strong>, a historic settlement dating back to the 14th-century Pagaruyung Kingdom. This area still maintains the traditional Minangkabau social structure, where the practices of mutual cooperation (<em data-path-to-node=\\"10\\" data-index-in-node=\\"250\\">gotong royong</em>) and the <em data-path-to-node=\\"10\\" data-index-in-node=\\"273\\">kongsi</em> system remain strong.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"11\\">One such practice is <strong data-path-to-node=\\"11\\" data-index-in-node=\\"21\\">Batoboh</strong>, a culture of collective labor for tilling land, harvesting, or building traditional houses (<em data-path-to-node=\\"11\\" data-index-in-node=\\"122\\">rumah gadang</em>). Other traditions include <strong data-path-to-node=\\"11\\" data-index-in-node=\\"162\\">Bakaul</strong> (gratitude for harvests) and <strong data-path-to-node=\\"11\\" data-index-in-node=\\"198\\">Mambantai Adaik</strong>, a communal buffalo slaughter held before or after Ramadan to symbolize unity and prosperity.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"12\\">Today, the Sijunjung Traditional Village has evolved into a culture-based tourism destination. <em data-path-to-node=\\"12\\" data-index-in-node=\\"95\\">Rumah gadang</em> houses are now utilized as homestays, opening new economic opportunities. Locals also produce handicrafts such as carvings, weaving, and traditional jewelry, while Micro, Small, and Medium Enterprises (MSMEs) focusing on Minangkabau cuisine have flourished.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"13\\">Traditional Practices for River Conservation: Lubuk Larangan</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"14\\">Beyond Sijunjung, the practice of <strong data-path-to-node=\\"14\\" data-index-in-node=\\"34\\">Lubuk Larangan</strong> plays a crucial role in environmental preservation across the RIMBA Corridor, including in Telogo Limo Village, Jambi. <em data-path-to-node=\\"14\\" data-index-in-node=\\"168\\">Lubuk Larangan</em> is a customary rule that prohibits fishing in specific sections of the river for a set period.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"15\\">This rule acts as a natural recovery mechanism. When a section of the river is \\"closed,\\" fish populations and water quality improve, providing long-term benefits. When the harvest season opens, the yield is significantly more abundant. Researchers of the RIMBA green economy scenario describe this as a highly effective form of community-based conservation.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"16\\">\\"Lubuk Larangan is the most effective natural regulation mechanism. When the river is protected, the ecosystem recovers, and the economic benefits return to the community during the grand harvest,\\" noted one researcher. Local leaders explain that it is not just a physical barrier, but a \\"social fence\\" that restricts exploitative behavior. Violations result in customary sanctions, ensuring community compliance.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"17\\">Revitalizing the Green Economy through Culture: Pasar Paduka</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"18\\">In Muaro Jambi Regency, an innovative culture-based economy has emerged through <strong data-path-to-node=\\"18\\" data-index-in-node=\\"80\\">Pasar Paduka</strong>, located within the Muaro Jambi Temple compounds. Designed to revive Jambi&rsquo;s traditional identity, the market is built using natural materials like bamboo, wood, and leaves to harmonize with the heritage site.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"19\\">The market uses a unique <strong data-path-to-node=\\"19\\" data-index-in-node=\\"25\\">cashless transaction system</strong> where visitors exchange money for special coins or use QRIS. It also strictly implements eco-friendly concepts, prohibiting single-use plastics. Food is served in containers made of leaves, bamboo, rattan, or coconut shells. This market has become a hub for traditional snacks, spices, handicrafts, and cultural performances.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"20\\">A Model for Other Regions</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"21\\">The diverse traditional practices in the RIMBA Corridor prove that green economic development is most effective when local communities are the primary actors. Traditions like <em data-path-to-node=\\"21\\" data-index-in-node=\\"175\\">Lubuk Larangan, Batoboh,</em> and <em data-path-to-node=\\"21\\" data-index-in-node=\\"204\\">Bakaul</em> are evidence that local wisdom can drive the economy without destroying the environment.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"22\\">The development models in Silokek, Sijunjung, and Muaro Jambi can serve as blueprints for other regions. Areas with strong traditional structures have the potential to develop ecotourism, customary-based river management, and cultural MSMEs. This approach aligns with government strategies to strengthen the green economy through community empowerment.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"23\\">With culture as its root, the RIMBA Corridor can serve as a national example of sustainable development, where society lives in harmony with nature while building long-term prosperity.</p>\\n</div>", "id": "<div id=\\"model-response-message-contentr_43f80e83d3aa58e1\\" class=\\"markdown markdown-main-panel stronger enable-updated-hr-color\\" dir=\\"ltr\\" aria-live=\\"polite\\" aria-busy=\\"false\\">\\n<p data-path-to-node=\\"0\\">&nbsp;</p>\\n<h2 style=\\"text-align: justify;\\" data-path-to-node=\\"2\\">Koridor Ekosistem RIMBA: Menyatukan Kearifan Lokal dan Ekonomi Hijau</h2>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Koridor Ekosistem Riau&ndash;Jambi&ndash;Sumatera Barat (RIMBA)</strong> menghadapi tekanan lingkungan yang kian meningkat dalam beberapa tahun terakhir. Kawasan yang ditetapkan melalui Peraturan Presiden (Perpres) Nomor 13 Tahun 2012 ini mengalami tantangan besar akibat penyusutan tutupan hutan, fragmentasi habitat, hingga penurunan kualitas ekosistem sungai.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"4\\">Sebagai salah satu dari lima koridor ekosistem vital di Sumatera, RIMBA memiliki fungsi strategis sebagai penghubung habitat satwa kunci, mulai dari gajah sumatera hingga harimau sumatera yang sangat bergantung pada kelestarian bentang alam sekitarnya. Di tengah ancaman tersebut, pembangunan <strong data-path-to-node=\\"4\\" data-index-in-node=\\"293\\">ekonomi hijau</strong> menjadi pendekatan yang terus didorong oleh pemerintah dan mitra pembangunan. Model ini berupaya menyeimbangkan perlindungan keanekaragaman hayati dan pengurangan emisi karbon dengan peningkatan kesejahteraan masyarakat di sekitar koridor.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"5\\">RIMBA bukan sekadar kawasan ekologis, melainkan ruang hidup bagi komunitas adat yang telah lama menjaga hutan dan sungai melalui hukum adat. Kearifan lokal di kawasan ini menjadi kekuatan penting untuk menjaga kelestarian sekaligus mendorong ekonomi masyarakat. Berbagai praktik adat yang masih berlangsung hingga kini membuktikan bahwa keberlanjutan dapat dicapai ketika masyarakat dilibatkan sebagai penjaga lingkungan. Sejumlah desa di dalam koridor bahkan mulai mengembangkan wisata berbasis budaya yang memperkuat fondasi ekonomi hijau.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"6\\">Warisan Adat Silokek yang Terjaga</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"7\\">Salah satu contoh penerapan kearifan lokal di Koridor RIMBA terlihat di <strong data-path-to-node=\\"7\\" data-index-in-node=\\"72\\">Desa Wisata Silokek</strong>, Kabupaten Sijunjung, Sumatera Barat. Desa ini dihuni oleh empat suku utama: <em data-path-to-node=\\"7\\" data-index-in-node=\\"169\\">Patopang Bukik, Patopang Bough, Melayu Gadang,</em> dan <em data-path-to-node=\\"7\\" data-index-in-node=\\"220\\">Melayu Ketek</em>. Silokek berada di kawasan tebing karst yang dibelah oleh Batang Kuantan, sungai yang sejak dahulu menjadi jalur perdagangan penting penghubung wilayah pedalaman dengan pesisir Sumatera.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"8\\">Sebagian besar masyarakat Silokek berprofesi sebagai petani dan ahli pembuat perahu&mdash;sebuah keahlian yang diwariskan turun-temurun dan menjadi identitas budaya lokal. Selain kekayaan alam, Silokek dikenal dengan ritual adatnya seperti <strong data-path-to-node=\\"8\\" data-index-in-node=\\"234\\">Bakaua Adat</strong>, bentuk syukur atas hasil panen, dan <strong data-path-to-node=\\"8\\" data-index-in-node=\\"283\\">Maratik</strong>, prosesi untuk memohon perlindungan dari ancaman dan penyakit. Tradisi ini menunjukkan cara masyarakat memandang alam sebagai ruang hidup yang harus dijaga secara spiritual dan sosial.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"9\\">Desa Wisata yang Tumbuh dari Tradisi</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"10\\">Tak jauh dari Silokek, terdapat <strong data-path-to-node=\\"10\\" data-index-in-node=\\"32\\">Perkampungan Adat Nagari Sijunjung</strong>, permukiman bersejarah peninggalan Kerajaan Pagaruyung sejak abad ke-14. Hingga kini, struktur adat Minangkabau seperti praktik gotong royong dan sistem <em data-path-to-node=\\"10\\" data-index-in-node=\\"220\\">kongsi</em> masih berjalan kuat.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"11\\">Salah satu praktiknya adalah <strong data-path-to-node=\\"11\\" data-index-in-node=\\"29\\">Batoboh</strong>, budaya bekerja bersama dalam mengolah lahan atau membangun rumah gadang. Ada pula tradisi <strong data-path-to-node=\\"11\\" data-index-in-node=\\"128\\">Bakaul</strong> dan <strong data-path-to-node=\\"11\\" data-index-in-node=\\"139\\">Mambantai Adaik</strong> (menyembelih kerbau bersama menjelang Ramadhan) yang menjadi simbol persatuan. Saat ini, perkampungan tersebut telah berkembang menjadi desa wisata. Rumah-rumah gadang kini dimanfaatkan sebagai <em data-path-to-node=\\"11\\" data-index-in-node=\\"349\\">homestay</em>, membuka peluang ekonomi baru melalui kerajinan tangan dan kuliner khas Minangkabau bagi wisatawan.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"12\\">Menjaga Sungai melalui Lubuk Larangan</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"13\\">Praktik kearifan lokal lain yang berperan penting dalam menjaga lingkungan adalah <strong data-path-to-node=\\"13\\" data-index-in-node=\\"82\\">Lubuk Larangan</strong>, yang diterapkan di desa-desa sepanjang Koridor RIMBA, termasuk di Desa Telogo Limo, Jambi. Lubuk Larangan adalah aturan adat yang melarang masyarakat menangkap ikan di area sungai tertentu dalam jangka waktu tertentu.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"14\\">Aturan ini berfungsi sebagai mekanisme pemulihan alami. Ketika sungai \\"ditutup\\", populasi ikan dan kualitas air membaik. Saat masa panen tiba, hasilnya jauh lebih melimpah. Peneliti menyebut praktik ini sebagai bentuk konservasi berbasis komunitas yang sangat efektif. Tokoh adat menjelaskan bahwa Lubuk Larangan bukan sekadar pagar fisik, melainkan \\"pagar sosial\\" yang membatasi perilaku eksploitatif melalui sanksi adat.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"15\\">Revitalisasi Ekonomi Hijau: Pasar Paduka</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"16\\">Di Kabupaten Muaro Jambi, inovasi ekonomi berbasis budaya muncul melalui <strong data-path-to-node=\\"16\\" data-index-in-node=\\"73\\">Pasar Paduka</strong> di kawasan percandian Muaro Jambi. Pasar ini didesain menggunakan bahan alami seperti bambu dan kayu untuk menghidupkan kembali identitas tradisional Jambi.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"17\\">Pasar ini menerapkan sistem <strong data-path-to-node=\\"17\\" data-index-in-node=\\"28\\">transaksi nontunai</strong> menggunakan koin khusus atau QRIS dan sangat ramah lingkungan karena melarang penggunaan plastik sekali pakai. Makanan disajikan dalam wadah daun, bambu, atau tempurung kelapa. Selain menjadi pusat kuliner tradisional, Pasar Paduka kini berkembang sebagai pusat kegiatan budaya dan pertunjukan musik tradisional.</p>\\n<h3 style=\\"text-align: justify;\\" data-path-to-node=\\"18\\">Model yang Dapat Direplikasi</h3>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"19\\">Beragam praktik adat di Koridor RIMBA menunjukkan bahwa pembangunan ekonomi hijau paling efektif ketika masyarakat lokal menjadi aktor utama. Tradisi seperti Lubuk Larangan, Batoboh, hingga pasar budaya adalah bukti bahwa kearifan lokal mampu menggerakkan ekonomi tanpa merusak lingkungan.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"20\\">Model di Silokek, Sijunjung, dan Muaro Jambi dapat menjadi rujukan bagi wilayah lain yang memiliki struktur adat kuat. Dengan menjadikan budaya sebagai akar, Koridor RIMBA dapat menjadi contoh nasional dalam membangun kesejahteraan yang berkelanjutan dan selaras dengan alam</p>\\n</div>"}	\N	2025-12-20 01:05:37.757477	2025-12-20 01:05:37.757477
5	2	[223]	{"en": "Ministry of ATR/BPN Disseminates Green Economy Learning and Low-Carbon Innovation in Riau", "id": "Kementerian ATR/BPN Diseminasi Pembelajaran Ekonomi Hijau dan Inovasi Rendah Karbon di Riau"}	{"en": "ministry-of-atr-bpn-disseminates-green-economy-learning-and-low-carbon-innovation-in-riau", "id": "kementerian-atr-bpn-diseminasi-pembelajaran-ekonomi-hijau-dan-inovasi-rendah-karbon-di-riau"}	{"en": "The Ministry of ATR/BPN, through the Directorate General of Spatial Planning, conducted a dissemination session on green economy learning and low-carbon innovation in Riau Province as part of the RIMBA Project to bolster sustainability across the Sumatran ecosystem corridor. By engaging academia, the business sector, and civil society, the forum aimed to refine training modules by integrating on-the-ground best practices, local wisdom, and a strategic balance between conservation and community welfare. These efforts will serve as a foundation for the upcoming Training of Trainers (ToT) program in 2026, which is designed to cultivate local champions capable of effectively implementing green economy initiatives throughout Riau, Jambi, and West Sumatra.", "id": "Kementerian ATR/BPN melalui Direktorat Jenderal Tata Ruang mengadakan kegiatan diseminasi pembelajaran ekonomi hijau dan inovasi rendah karbon di Provinsi Riau sebagai bagian dari Proyek RIMBA untuk memperkuat keberlanjutan di koridor ekosistem Sumatera. Forum yang melibatkan akademisi, pelaku bisnis, dan masyarakat sipil ini bertujuan menyempurnakan modul pelatihan dengan mengintegrasikan praktik terbaik di tingkat tapak, kearifan lokal, serta keseimbangan antara konservasi dan kesejahteraan masyarakat. Hasil dari pertemuan ini nantinya akan menjadi fondasi bagi program Training of Trainers (ToT) pada tahun 2026 guna mencetak penggerak lokal (local champions) yang mampu mengimplementasikan ekonomi hijau secara efektif di wilayah Riau, Jambi, dan Sumatera Barat."}	{"en": "<p>Riau &ndash; The Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN), through the Directorate General of Spatial Planning, held a Dissemination of Green Economy Learning through Low Carbon Technology Innovation in Riau Province on November 5&ndash;7, 2025. This activity is part of the RIMBA Project, which aims to strengthen the understanding and implementation of the green economy in the three provinces of the RIMBA ecosystem corridor: Riau, Jambi, and West Sumatra. In this forum, academics, businesses, and civil society provided important input for the refinement of the green economy learning module, including sharpening the substance of the material, incorporating elements of good practices and examples of green economy implementation at the local level. There is a need for an approach that balances conservation with improving community welfare. The discussion also highlighted the importance of recognizing local wisdom, strengthening cross-sector collaboration, and applying green technology to support the ecological functions of the RIMBA corridor. The results of this dissemination will be used to refine the modules and prepare for the Training of Trainers (ToT) planned for 2026, with the aim of producing local green economy champions in the RIMBA region.</p>", "id": "<p>Riau &ndash; Kementerian ATR/BPN melalui Direktorat Jenderal Tata Ruang telah melaksanakan Diseminasi Pembelajaran Ekonomi Hijau melalui Inovasi Teknologi Rendah Karbon di Provinsi Riau pada 5&ndash;7 November 2025. Kegiatan ini merupakan bagian dari Proyek RIMBA yang bertujuan untuk memperkuat pemahaman dan implementasi ekonomi hijau di tiga provinsi koridor ekosistem RIMBA: Riau, Jambi, dan Sumatera Barat. Dalam forum ini, para akademisi, bisnis, dan masyarakat sipil memberikan masukan penting bagi penyempurnaan modul pembelajaran ekonomi hijau, termasuk penajaman substansi materi, memasukkan unsur praktik baik dan contoh implementasi ekonomi hijau di tingkat tapak. Perlunya pendekatan yang menyeimbangkan konservasi dengan peningkatan kesejahteraan masyarakat. Diskusi juga menyoroti pentingnya pengakuan terhadap kearifan lokal, penguatan kolaborasi lintas pihak, dan penerapan teknologi hijau untuk mendukung fungsi ekologis koridor RIMBA. Hasil diseminasi ini akan menjadi sarana penyempurnaan modul dan persiapan pelatihan Training of Trainers (ToT) yang direncanakan pada tahun 2026, guna mencetak local champions ekonomi hijau di wilayah RIMBA.</p>"}	2025-12-21 16:11:57.515822	2025-12-20 00:58:08.751507	2025-12-21 16:11:49.656606
7	2	[225]	{"en": "From Zero Waste Coffee to Community Micro-Hydropower Plants, the RIMBA Corridor Leads Green Economic Innovation in Sumatra", "id": "Dari Kopi Zero Waste hingga PLTMH Komunitas, Koridor RIMBA Pimpin Inovasi Ekonomi Hijau di Sumatera"}	{"en": "from-zero-waste-coffee-to-community-micro-hydropower-plants-the-rimba-corridor-leads-green-economic-innovation-in-sumatra", "id": "dari-kopi-zero-waste-hingga-pltmh-komunitas-koridor-rimba-pimpin-inovasi-ekonomi-hijau-di-sumatera"}	{"en": "This article explores the transformative steps taken by the RIMBA Corridor in Sumatra in pioneering the green economy through zero-waste coffee practices and the provision of clean energy via community micro-hydro power plants. These initiatives demonstrate how the wise use of natural resources can drive rural economic independence while preserving forest integrity, setting a new standard for sustainable development rooted in local community empowerment at the heart of Sumatra's ecosystem.", "id": "Artikel ini mengeksplorasi langkah transformatif Koridor RIMBA di Sumatera dalam memelopori ekonomi hijau melalui praktik kopi nirlimbah (zero waste) dan penyediaan energi bersih lewat PLTMH komunitas. Inisiatif-inisiatif ini menunjukkan bagaimana pemanfaatan sumber daya alam secara bijak dapat mendorong kemandirian ekonomi desa sekaligus menjaga kelestarian hutan, menetapkan standar baru bagi pembangunan berkelanjutan yang berbasis pada pemberdayaan masyarakat lokal di jantung ekosistem Sumatra."}	{"en": "<div id=\\"model-response-message-contentr_a233861099185b97\\" class=\\"markdown markdown-main-panel stronger enable-updated-hr-color\\" dir=\\"ltr\\" style=\\"text-align: justify;\\" aria-live=\\"polite\\" aria-busy=\\"false\\">\\n<div class=\\"container\\">\\n<div id=\\"model-response-message-contentr_fb30f9bcc3a61988\\" class=\\"markdown markdown-main-panel stronger enable-updated-hr-color\\" dir=\\"ltr\\" aria-live=\\"polite\\" aria-busy=\\"false\\">\\n<h4 data-path-to-node=\\"13\\"><strong data-path-to-node=\\"13\\" data-index-in-node=\\"0\\">Building a Green Future: Community-Based Economic Transformation in the RIMBA Corridor</strong></h4>\\n<p data-path-to-node=\\"14\\">The Riau&ndash;Jambi&ndash;West Sumatra Ecosystem Corridor (RIMBA) is more than just a vast stretch of tropical rainforest; it is the last ecological stronghold connecting vital conservation areas in Sumatra. Spanning three provinces, this corridor serves as a massive carbon sink, a water source for millions, and a habitat for iconic wildlife like the Sumatran Tiger. However, a major challenge has always persisted: how to preserve the forest without stifling the local economy? The answer lies in the <strong data-path-to-node=\\"14\\" data-index-in-node=\\"493\\">Green Economy</strong>.</p>\\n<p data-path-to-node=\\"15\\"><strong data-path-to-node=\\"15\\" data-index-in-node=\\"0\\">Agricultural Innovation: Zero Waste Coffee and Agroforestry</strong> For years, monoculture systems like palm oil were the primary livelihood for farmers. However, these systems are vulnerable to price fluctuations and harmful to biodiversity. Through the RIMBA initiative, farmers in Tebo and Kerinci Regencies have begun shifting toward agroforestry.</p>\\n<p data-path-to-node=\\"16\\">The Khasta Farmers Group at the foot of Mount Kerinci is a shining example. They manage coffee plantations using circular economy principles. Coffee husk waste, which is usually discarded, is now processed into organic fertilizer (cascara). Furthermore, they employ intercropping&mdash;planting Hass avocados, strawberries, and vegetables alongside coffee trees. As a result, farmers enjoy multiple income streams, and their land is more resilient to climate change, as soil moisture is maintained by diverse tree cover.</p>\\n<p data-path-to-node=\\"17\\"><strong data-path-to-node=\\"17\\" data-index-in-node=\\"0\\">Ecotourism and Indigenous Wisdom</strong> The RIMBA area also maximizes its potential through responsible tourism. In Jambi, the Muaro Jambi Temple Complex has integrated green technology by providing electric bicycles for visitors to reduce carbon emissions within the historical site.</p>\\n<p data-path-to-node=\\"18\\">Meanwhile, in Rimbang Baling, the local tradition of \\"Lubuk Larangan\\" (Prohibited Pool) serves as a primary conservation tool. The community agrees not to fish in certain parts of the river until a designated time. This tradition has proven effective in keeping fish populations abundant and river ecosystems clean, which in turn attracts specialized ecotourists.</p>\\n<p data-path-to-node=\\"19\\"><strong data-path-to-node=\\"19\\" data-index-in-node=\\"0\\">Energy Independence and Environmental Services</strong> A milestone of the green economy in this corridor is the Micro-Hydro Power Plant (PLTMH) in Senamat Ulu Village. By utilizing natural river currents without large dams, residents have successfully powered hundreds of homes at a very low cost. The realization of these benefits encourages villagers to protect the upstream forests to ensure a stable water flow.</p>\\n<p data-path-to-node=\\"20\\">Additionally, the Payment for Ecosystem Services (PES) scheme has been introduced. Through voluntary carbon markets, villages like Sungai Telang receive financial compensation for successfully protecting their forests from deforestation. These funds are reinvested into village development and independent forest patrols.</p>\\n</div>\\n<!----><!----></div>\\n</div>", "id": "<div id=\\"model-response-message-contentr_43f80e83d3aa58e1\\" class=\\"markdown markdown-main-panel stronger enable-updated-hr-color\\" dir=\\"ltr\\" aria-live=\\"polite\\" aria-busy=\\"false\\">\\n<h4 style=\\"text-align: justify;\\" data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Membangun Masa Depan Hijau: Transformasi Ekonomi Berbasis Komunitas di Koridor RIMBA</strong></h4>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"4\\">Koridor Ekosistem Riau&ndash;Jambi&ndash;Sumatera Barat (RIMBA) bukan sekadar hamparan hutan tropis yang luas; ia adalah benteng ekologis terakhir yang menghubungkan berbagai kawasan konservasi penting di Sumatera. Dengan luas yang mencakup tiga provinsi, koridor ini berfungsi sebagai penyerap karbon raksasa, penyedia air bagi jutaan jiwa, dan habitat bagi satwa ikonik seperti Harimau Sumatera. Namun, tantangan besar selalu muncul: bagaimana menjaga hutan tetap lestari tanpa mematikan ekonomi masyarakat? Jawabannya terletak pada <strong data-path-to-node=\\"4\\" data-index-in-node=\\"523\\">Ekonomi Hijau</strong>.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">Inovasi Pertanian: Kopi Zero Waste dan Agroforestri</strong> Selama bertahun-tahun, sistem monokultur seperti sawit menjadi tumpuan utama petani. Namun, sistem ini rentan terhadap fluktuasi harga dan merusak biodiversitas. Melalui inisiatif RIMBA, petani di Kabupaten Tebo dan Kerinci mulai beralih ke agroforestri (wanatani).</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"6\\">Kelompok Tani Khasta di kaki Gunung Kerinci menjadi contoh gemilang. Mereka mengelola kebun kopi dengan prinsip <em data-path-to-node=\\"6\\" data-index-in-node=\\"112\\">circular economy</em>. Limbah kulit kopi yang biasanya dibuang, kini diolah menjadi pupuk organik (cascara). Tak hanya itu, mereka menggunakan sistem tumpang sari&mdash;menanam alpukat Hass, stroberi, dan sayuran di sela pohon kopi. Hasilnya, petani memiliki pendapatan berlapis dan lahan mereka jauh lebih tahan terhadap perubahan iklim karena kelembapan tanah terjaga oleh tutupan pohon yang beragam.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"7\\"><strong data-path-to-node=\\"7\\" data-index-in-node=\\"0\\">Ekowisata dan Kearifan Lokal</strong> Kawasan RIMBA juga memaksimalkan potensi wisata yang bertanggung jawab. Di Jambi, Kompleks Candi Muaro Jambi kini mengintegrasikan teknologi hijau dengan menyediakan sepeda listrik bagi pengunjung, guna menekan emisi karbon di area situs sejarah.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"8\\">Sementara itu, di Rimbang Baling, kearifan lokal \\"Lubuk Larangan\\" menjadi senjata utama konservasi. Masyarakat sepakat untuk tidak mengambil ikan di bagian sungai tertentu hingga waktu yang ditentukan. Tradisi ini terbukti ampuh menjaga populasi ikan tetap melimpah dan ekosistem sungai tetap bersih, yang pada akhirnya menarik wisatawan minat khusus untuk berkunjung.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"9\\"><strong data-path-to-node=\\"9\\" data-index-in-node=\\"0\\">Kemandirian Energi dan Imbal Jasa Lingkungan</strong> Salah satu tonggak keberhasilan ekonomi hijau di koridor ini adalah penggunaan Pembangkit Listrik Tenaga Mikro Hidro (PLTMH) di Desa Senamat Ulu. Dengan hanya memanfaatkan aliran alami sungai tanpa bendungan besar, warga berhasil menerangi ratusan rumah dengan biaya yang sangat murah. Kesadaran akan manfaat listrik ini mendorong warga untuk menjaga hutan di hulu agar debit air tetap stabil.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"10\\">Selain itu, skema <em data-path-to-node=\\"10\\" data-index-in-node=\\"18\\">Payment for Ecosystem Services</em> (PES) atau Imbal Jasa Lingkungan telah mulai diterapkan. Melalui pasar karbon sukarela, desa-desa seperti Sungai Telang mendapatkan kompensasi finansial karena berhasil menjaga hutan mereka dari penggundulan. Dana tersebut kemudian diputar kembali untuk pembangunan desa dan patroli hutan mandiri.</p>\\n</div>"}	\N	2025-12-20 01:11:05.199631	2025-12-20 01:11:05.199631
8	2	[226]	{"en": "When Technology, Industry, and Nature Meet at the Carbon Digital Conference 2025", "id": "Saat Teknologi, Industri, dan Alam Bertemu di Carbon Digital Conference 2025."}	{"en": "when-technology-industry-and-nature-meet-at-the-carbon-digital-conference-2025", "id": "saat-teknologi-industri-dan-alam-bertemu-di-carbon-digital-conference-2025."}	{"en": "This article explores the 2025 Carbon Digital Conference, which serves as a crucial meeting point for cutting-edge technological innovation, modern industrial strategy, and nature conservation efforts aimed at reducing global carbon emissions. The conference highlights how digital solutions, such as artificial intelligence and real-time data monitoring, are integrated to create a greener and more sustainable industrial ecosystem, proving that economic progress and environmental protection can go hand-in-hand through digital transformation.", "id": "Artikel ini mengulas perhelatan Carbon Digital Conference 2025 yang menjadi titik temu krusial antara inovasi teknologi mutakhir, strategi industri modern, dan upaya pelestarian alam dalam rangka menekan emisi karbon global. Konferensi ini menyoroti bagaimana solusi digital, seperti kecerdasan buatan dan pemantauan data real-time, diintegrasikan untuk menciptakan ekosistem industri yang lebih hijau dan berkelanjutan, membuktikan bahwa kemajuan ekonomi dan perlindungan lingkungan dapat berjalan beriringan melalui transformasi digital."}	{"en": "<h4 style=\\"text-align: justify;\\" data-path-to-node=\\"11\\"><strong data-path-to-node=\\"11\\" data-index-in-node=\\"0\\">Indonesia's Energy Transition: Navigating Towards a Low-Emission Economy via CCS and Global Collaboration</strong></h4>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"12\\">The <strong data-path-to-node=\\"12\\" data-index-in-node=\\"4\\">Carbon Digital Conference 2025</strong>, held at the Bandung Institute of Technology (ITB) on December 8-9, 2025, served as a pivotal moment for Indonesia. The forum gathered government officials, academics, and industry leaders to discuss energy transition strategies that do not compromise economic growth.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"13\\"><strong data-path-to-node=\\"13\\" data-index-in-node=\\"0\\">1. CCS Technology as a Strategic Pillar</strong> Tirta Nugraha Mursitama, Deputy at the Ministry of Investment and Downstreaming, emphasized that <strong data-path-to-node=\\"13\\" data-index-in-node=\\"137\\">Carbon Capture and Storage (CCS)</strong> technology is no longer an optional add-on but a necessity. The <strong data-path-to-node=\\"13\\" data-index-in-node=\\"234\\">Tangguh CCS project</strong> in West Papua stands as a testament to Indonesia's ambition to become a regional carbon storage hub for countries lacking similar geological capacities.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"14\\"><strong data-path-to-node=\\"14\\" data-index-in-node=\\"0\\">2. Industrial Challenges and Global Standards</strong> Heavy industries such as cement, steel, and fertilizer are under immense pressure to reduce their carbon footprints. The fertilizer industry, particularly ammonia producers, is now prioritizing the development of <strong data-path-to-node=\\"14\\" data-index-in-node=\\"259\\">\\"blue ammonia\\"</strong> to maintain market access to Japan and South Korea, both of which have stringent import emission regulations. Energy efficiency alone is no longer sufficient; carbon capture infrastructure is now key to keeping Indonesian products competitive globally.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"15\\"><strong data-path-to-node=\\"15\\" data-index-in-node=\\"0\\">3. Sustainable Infrastructure Innovation: \\"Eco Road RIMBA\\"</strong> The energy transition must also align with biodiversity conservation. In Sumatra's RIMBA Ecosystem Corridor, the <strong data-path-to-node=\\"15\\" data-index-in-node=\\"172\\">\\"Eco Road RIMBA\\"</strong> concept has emerged. This approach focuses on designing animal-friendly road infrastructure, such as vegetated bridges and wildlife tunnels, to prevent human-wildlife conflicts involving tigers and elephants. Satellite imagery and seed-sowing drones are being utilized to ensure that development maintains ecological balance.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"16\\"><strong data-path-to-node=\\"16\\" data-index-in-node=\\"0\\">4. International Perspectives and Collaboration</strong> Countries like South Korea, Japan, and Australia are also realigning their energy and climate policies. The common thread of the conference was the importance of multi-stakeholder collaboration. The transition to a low-emission economy requires a solid policy foundation, industrial technological readiness, and international support to ensure that the future of energy and nature move in harmony.</p>", "id": "<p style=\\"text-align: justify;\\" data-path-to-node=\\"0\\">&nbsp;</p>\\n<h4 style=\\"text-align: justify;\\" data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Transisi Energi Indonesia: Menuju Ekonomi Rendah Emisi Melalui CCS dan Kolaborasi Global</strong></h4>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"4\\"><strong data-path-to-node=\\"4\\" data-index-in-node=\\"0\\">Carbon Digital Conference 2025</strong> yang diselenggarakan di Institut Teknologi Bandung (ITB) pada 8-9 Desember 2025 menjadi momentum krusial bagi Indonesia. Forum ini mempertemukan pemerintah, akademisi, dan pelaku industri untuk membahas strategi transisi energi tanpa menghambat pertumbuhan ekonomi.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">1. Teknologi CCS sebagai Pilar Strategis</strong> Deputi Kementerian Investasi dan Hilirisasi, Tirta Nugraha Mursitama, menegaskan bahwa teknologi <em data-path-to-node=\\"5\\" data-index-in-node=\\"138\\">Carbon Capture and Storage</em> (CCS) bukan lagi opsi tambahan, melainkan keharusan. Proyek <strong data-path-to-node=\\"5\\" data-index-in-node=\\"225\\">Tangguh CCS</strong> di Papua Barat menjadi bukti nyata ambisi Indonesia untuk menjadi pusat penyimpanan karbon regional bagi negara-negara yang tidak memiliki kapasitas geologis serupa.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"6\\"><strong data-path-to-node=\\"6\\" data-index-in-node=\\"0\\">2. Tantangan Industri dan Standar Global</strong> Sektor industri berat seperti semen, baja, dan pupuk menghadapi tekanan besar untuk menurunkan jejak karbon. Industri pupuk, khususnya produsen amonia, kini berfokus pada pengembangan <em data-path-to-node=\\"6\\" data-index-in-node=\\"225\\">blue ammonia</em> untuk mempertahankan akses pasar ke Jepang dan Korea Selatan yang memiliki regulasi emisi impor yang ketat. Efisiensi energi saja dianggap tidak lagi cukup; infrastruktur penangkapan karbon menjadi kunci agar produk Indonesia tetap kompetitif di pasar global.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"7\\"><strong data-path-to-node=\\"7\\" data-index-in-node=\\"0\\">3. Inovasi Infrastruktur Berkelanjutan: \\"Eco Road RIMBA\\"</strong> Transisi energi juga harus sejalan dengan pelestarian keanekaragaman hayati. Di Koridor Ekosistem RIMBA (Sumatera), muncul konsep <strong data-path-to-node=\\"7\\" data-index-in-node=\\"187\\">\\"Eco Road RIMBA\\"</strong>. Pendekatan ini merancang infrastruktur jalan yang ramah satwa, seperti jembatan vegetasi dan terowongan lintas satwa, guna mencegah konflik manusia dengan harimau dan gajah. Teknologi citra satelit dan drone penebar benih digunakan untuk memastikan pembangunan tetap menjaga keseimbangan alam.</p>\\n<p style=\\"text-align: justify;\\" data-path-to-node=\\"8\\"><strong data-path-to-node=\\"8\\" data-index-in-node=\\"0\\">4. Perspektif Internasional dan Kolaborasi</strong> Negara-negara seperti Korea Selatan, Jepang, dan Australia juga mulai menyelaraskan kebijakan energi dan iklim mereka. Benang merah dari konferensi ini adalah pentingnya kolaborasi multipihak. Transisi menuju ekonomi rendah emisi membutuhkan pondasi kebijakan yang kuat, kesiapan teknologi industri, serta dukungan internasional agar masa depan energi dan alam dapat bergerak selaras.</p>"}	\N	2025-12-20 01:16:51.405234	2025-12-20 01:16:51.405234
9	2	[227]	{"en": "How RIMBA Ecosystem Corridor Helps Preserve Culture in Sumatra", "id": "Bagaimana Koridor Ekosistem RIMBA Membantu Melestarikan Budaya di Sumatera"}	{"en": "how-rimba-ecosystem-corridor-helps-preserve-culture-in-sumatra", "id": "bagaimana-koridor-ekosistem-rimba-membantu-melestarikan-budaya-di-sumatera"}	{"en": "This article discusses the strategic role of the RIMBA Ecosystem Corridor in Sumatra in safeguarding the cultural heritage of local communities that are deeply dependent on forest preservation. Through integrated landscape protection, this initiative not only saves biodiversity but also revitalizes traditional knowledge, indigenous practices, and the spiritual connection between communities and nature. It proves that forest protection is a primary key to ensuring local cultural identity remains preserved amidst the currents of modernization.", "id": "Artikel ini membahas peran strategis Koridor Ekosistem RIMBA di Sumatera dalam menjaga warisan budaya masyarakat lokal yang sangat bergantung pada kelestarian hutan. Melalui perlindungan bentang alam yang terintegrasi, inisiatif ini tidak hanya menyelamatkan keanekaragaman hayati, tetapi juga menghidupkan kembali pengetahuan tradisional, praktik adat, dan hubungan spiritual komunitas dengan alam. Hal ini membuktikan bahwa perlindungan hutan adalah kunci utama dalam memastikan identitas budaya lokal tetap lestari di tengah arus modernisasi."}	{"en": "<h4 data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Preserving the Heart of Minangkabau: The RIMBA Ecosystem Corridor and Desa Nagari Adat Sijunjung</strong></h4>\\n<p data-path-to-node=\\"4\\">President Prabowo Subianto&rsquo;s goal of 8 percent economic growth relies heavily on the synergy between culture, the economy, and the planet. Recognizing that local traditions can only thrive if their environment is protected, the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency initiated the <strong data-path-to-node=\\"4\\" data-index-in-node=\\"313\\">RIMBA Ecosystem Corridor</strong>. This project focuses on biodiversity and environmentally conscious spatial planning across Riau, Jambi, and West Sumatra.</p>\\n<p data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">A Living Museum: Desa Nagari Adat Sijunjung</strong> One of the crown jewels of this corridor is Desa Nagari Adat Sijunjung in West Sumatra. Surrounded by lush forests and situated between the Batang Sukam and Batang Kulampi rivers, the village is a testament to the power of sustainable spatial planning.</p>\\n<ul data-path-to-node=\\"6\\">\\n<li>\\n<p data-path-to-node=\\"6,0,0\\"><strong data-path-to-node=\\"6,0,0\\" data-index-in-node=\\"0\\">Architectural Heritage:</strong> The village features the longest row of traditional houses in Indonesia, with over 76 <em data-path-to-node=\\"6,0,0\\" data-index-in-node=\\"110\\">rumah gadang</em> dating back to the 16th and 17th centuries.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,1,0\\"><strong data-path-to-node=\\"6,1,0\\" data-index-in-node=\\"0\\">Community-Led Tourism:</strong> Locals have transformed 40 of these historic homes into homestays, allowing travelers to immerse themselves in the matrilineal Minangkabau culture.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,2,0\\"><strong data-path-to-node=\\"6,2,0\\" data-index-in-node=\\"0\\">Indigenous Tribes:</strong> The population consists of six main tribes: Chaniago Nan Sambilan Sapuluah Jo Pitopang, Piliang, Tobo, Panai, Malayu, and Malayu Tak Timbago.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"7\\"><strong data-path-to-node=\\"7\\" data-index-in-node=\\"0\\">Traditions and Culinary Wonders</strong> Visitors can witness ancestral practices such as <em data-path-to-node=\\"7\\" data-index-in-node=\\"81\\">bakaua</em>, <em data-path-to-node=\\"7\\" data-index-in-node=\\"89\\">silat</em> martial arts, and the <em data-path-to-node=\\"7\\" data-index-in-node=\\"117\\">Tanduak</em> Dance, which depicts a legendary buffalo fight. Other unique traditions include:</p>\\n<ul data-path-to-node=\\"8\\">\\n<li>\\n<p data-path-to-node=\\"8,0,0\\"><strong data-path-to-node=\\"8,0,0\\" data-index-in-node=\\"0\\">Marosok:</strong> A silent livestock transaction method where hands are covered by cloth to symbolize politeness and the \\"shame\\" of selling family heirlooms.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"8,1,0\\"><strong data-path-to-node=\\"8,1,0\\" data-index-in-node=\\"0\\">Batobo:</strong> A communal farming tradition where villagers work the fields while reciting <em data-path-to-node=\\"8,1,0\\" data-index-in-node=\\"84\\">pantun</em> (rhymes).</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"8,2,0\\"><strong data-path-to-node=\\"8,2,0\\" data-index-in-node=\\"0\\">Gastronomy &amp; Crafts:</strong> The village is famous for <em data-path-to-node=\\"8,2,0\\" data-index-in-node=\\"47\\">rendang belalang</em> (grasshopper rendang), <em data-path-to-node=\\"8,2,0\\" data-index-in-node=\\"87\\">galamai</em>, and exquisite <em data-path-to-node=\\"8,2,0\\" data-index-in-node=\\"110\\">songket</em> weaving.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"9\\"><strong data-path-to-node=\\"9\\" data-index-in-node=\\"0\\">The Role of Spatial Planning</strong> The RIMBA project serves as a bridge between conservation and an inclusive green economy. Officials from the Ministry emphasize that spatial planning is more than a technicality; it is a commitment to sustainability. By preventing destructive land conversion, the government ensures that every inch of land supports both nature and the community's welfare, providing clean water, renewable energy, and economic resilience.</p>", "id": "<h4 data-path-to-node=\\"12\\"><strong data-path-to-node=\\"12\\" data-index-in-node=\\"0\\">Menjaga Jantung Minangkabau: Koridor Ekosistem RIMBA dan Desa Nagari Adat Sijunjung</strong></h4>\\n<p data-path-to-node=\\"13\\">Target pertumbuhan ekonomi 8 persen yang dicanangkan Presiden Prabowo Subianto sangat bergantung pada sinergi antara budaya, ekonomi, dan kelestarian bumi. Menyadari bahwa tradisi lokal hanya bisa tumbuh jika lingkungannya terjaga, Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) menginisiasi proyek <strong data-path-to-node=\\"13\\" data-index-in-node=\\"323\\">Koridor Ekosistem RIMBA</strong>. Program ini berfokus pada keanekaragaman hayati dan tata ruang yang berwawasan lingkungan di Riau, Jambi, dan Sumatera Barat.</p>\\n<p data-path-to-node=\\"14\\"><strong data-path-to-node=\\"14\\" data-index-in-node=\\"0\\">Museum Hidup: Desa Nagari Adat Sijunjung</strong> Salah satu permata di koridor ini adalah Desa Nagari Adat Sijunjung di Sumatera Barat. Terletak di antara sungai Batang Sukam dan Batang Kulampi serta dikelilingi hutan lebat, desa ini menjadi bukti nyata keberhasilan tata ruang berkelanjutan.</p>\\n<ul data-path-to-node=\\"15\\">\\n<li>\\n<p data-path-to-node=\\"15,0,0\\"><strong data-path-to-node=\\"15,0,0\\" data-index-in-node=\\"0\\">Warisan Arsitektur:</strong> Desa ini memiliki deretan rumah adat terpanjang di Indonesia, dengan lebih dari 76 <em data-path-to-node=\\"15,0,0\\" data-index-in-node=\\"103\\">Rumah Gadang</em> yang berasal dari abad ke-16 dan ke-17.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"15,1,0\\"><strong data-path-to-node=\\"15,1,0\\" data-index-in-node=\\"0\\">Wisata Berbasis Masyarakat:</strong> Warga telah menyulap 40 rumah bersejarah tersebut menjadi <em data-path-to-node=\\"15,1,0\\" data-index-in-node=\\"86\\">homestay</em>, memungkinkan wisatawan untuk merasakan langsung budaya matrilineal Minangkabau.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"15,2,0\\"><strong data-path-to-node=\\"15,2,0\\" data-index-in-node=\\"0\\">Suku Adat:</strong> Penduduknya terdiri dari enam suku utama: Chaniago Nan Sambilan Sapuluah Jo Pitopang, Piliang, Tobo, Panai, Malayu, dan Malayu Tak Timbago.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"16\\"><strong data-path-to-node=\\"16\\" data-index-in-node=\\"0\\">Tradisi dan Kekayaan Kuliner</strong> Wisatawan dapat menyaksikan praktik leluhur seperti <em data-path-to-node=\\"16\\" data-index-in-node=\\"81\\">bakaua</em>, seni bela diri <em data-path-to-node=\\"16\\" data-index-in-node=\\"104\\">silat</em>, hingga Tari Tanduak yang menggambarkan adu kerbau legendaris. Tradisi unik lainnya meliputi:</p>\\n<ul data-path-to-node=\\"17\\">\\n<li>\\n<p data-path-to-node=\\"17,0,0\\"><strong data-path-to-node=\\"17,0,0\\" data-index-in-node=\\"0\\">Marosok:</strong> Tradisi transaksi ternak secara rahasia dengan tangan tertutup kain, melambangkan kesantunan dan rasa \\"malu\\" karena menjual hewan yang dianggap pusaka keluarga.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"17,1,0\\"><strong data-path-to-node=\\"17,1,0\\" data-index-in-node=\\"0\\">Batobo:</strong> Tradisi gotong royong bertani di sawah sambil melantunkan pantun.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"17,2,0\\"><strong data-path-to-node=\\"17,2,0\\" data-index-in-node=\\"0\\">Kuliner &amp; Kerajinan:</strong> Desa ini dikenal dengan <em data-path-to-node=\\"17,2,0\\" data-index-in-node=\\"45\\">rendang belalang</em>, <em data-path-to-node=\\"17,2,0\\" data-index-in-node=\\"63\\">galamai</em>, serta kerajinan tenun <em data-path-to-node=\\"17,2,0\\" data-index-in-node=\\"94\\">songket</em> yang indah.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"18\\"><strong data-path-to-node=\\"18\\" data-index-in-node=\\"0\\">Peran Vital Tata Ruang</strong> Proyek RIMBA berfungsi sebagai jembatan antara konservasi dan ekonomi hijau yang inklusif. Pejabat Kementerian ATR/BPN menegaskan bahwa tata ruang bukan sekadar dokumen teknis, melainkan komitmen bersama untuk mencegah alih fungsi lahan yang merusak. Dengan tata kelola yang tepat, pemerintah memastikan setiap jengkal tanah mendukung keberlanjutan alam sekaligus kesejahteraan masyarakat, mulai dari penyediaan air bersih hingga energi terbarukan.</p>"}	\N	2025-12-20 01:20:06.749389	2025-12-20 01:20:06.749389
13	1	[235]	{"en": "This is Tittle for Pentest", "id": "Ini Judul Untuk Pentest"}	{"en": "this-is-tittle-for-pentest", "id": "ini-judul-untuk-pentest"}	{"en": "This is Tittle for Pentest", "id": "Ini Judul Untuk Pentest"}	{"en": "<p>this is content for <strong>PENTEST</strong></p>", "id": "<p>Ini kontent untuk <strong>Pentest</strong></p>"}	2025-12-20 01:39:27.819957	2025-12-20 01:39:18.079829	2025-12-20 01:39:18.079829
11	2	[229]	{"en": "GREEN INVESTMENT SCHEME REFINEMENT: Promoting Ecosystem Services and Sustainable Tourism in the RIMBA Corridor", "id": "PENAJAMAN SKEMA INVESTASI HIJAU: Mendorong Jasa Ekosistem dan Pariwisata Berkelanjutan di Koridor RIMBA"}	{"en": "green-investment-scheme-refinement-promoting-ecosystem-services-and-sustainable-tourism-in-the-rimba-corridor", "id": "penajaman-skema-investasi-hijau-mendorong-jasa-ekosistem-dan-pariwisata-berkelanjutan-di-koridor-rimba"}	{"en": "This article examines the refinement of green investment schemes designed to optimize the potential of ecosystem services and sustainable tourism development along the RIMBA Corridor in Sumatra. By prioritizing environmentally friendly financing, this initiative aims to generate economic value from forest conservation while ensuring long-term benefits for local communities through responsible ecotourism. The primary focus is to build business models that are not only financially profitable but also strengthen ecological resilience and safeguard the integrity of wildlife habitats in the heart of Sumatra.", "id": "Artikel ini mengulas upaya penajaman skema investasi hijau yang dirancang untuk mengoptimalkan potensi jasa ekosistem dan pengembangan pariwisata berkelanjutan di sepanjang Koridor RIMBA, Sumatra. Dengan memprioritaskan pembiayaan yang ramah lingkungan, inisiatif ini bertujuan untuk menciptakan nilai ekonomi dari pelestarian hutan sekaligus memastikan manfaat jangka panjang bagi masyarakat lokal melalui ekowisata yang bertanggung jawab. Fokus utamanya adalah membangun model bisnis yang tidak hanya menguntungkan secara finansial, tetapi juga memperkuat ketahanan ekologi dan menjaga keutuhan habitat satwa liar di jantung Sumatra."}	{"en": "<h4 data-path-to-node=\\"15\\"><strong data-path-to-node=\\"15\\" data-index-in-node=\\"0\\">Accelerating Green Investment: Ministry of ATR/BPN Refines Ecosystem Services and Tourism Schemes in the RIMBA Corridor</strong></h4>\\n<p data-path-to-node=\\"16\\">On Friday, November 14, 2025, the Directorate General of Spatial Planning at the Ministry of ATR/BPN held its 4th Focus Group Discussion (FGD). The meeting focused on sharpening the business processes and investment schemes for a green economy within the RIMBA Ecosystem Corridor (Riau, Jambi, and West Sumatra).</p>\\n<p data-path-to-node=\\"17\\"><strong data-path-to-node=\\"17\\" data-index-in-node=\\"0\\">Key Pillars of Green Economy Investment:</strong></p>\\n<p data-path-to-node=\\"18\\"><strong data-path-to-node=\\"18\\" data-index-in-node=\\"0\\">1. Sustainable Tourism Sector</strong></p>\\n<ul data-path-to-node=\\"19\\">\\n<li>\\n<p data-path-to-node=\\"19,0,0\\"><strong data-path-to-node=\\"19,0,0\\" data-index-in-node=\\"0\\">Focus:</strong> Community empowerment and integrated nature conservation.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"19,1,0\\"><strong data-path-to-node=\\"19,1,0\\" data-index-in-node=\\"0\\">Strategic Target:</strong> The Ministry of Tourism is committed to supporting <strong data-path-to-node=\\"19,1,0\\" data-index-in-node=\\"69\\">Silokek Geopark</strong> in West Sumatra to achieve <em data-path-to-node=\\"19,1,0\\" data-index-in-node=\\"112\\">UNESCO Global Geopark</em> (UGGp) status through multi-sectoral collaboration.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"20\\"><strong data-path-to-node=\\"20\\" data-index-in-node=\\"0\\">2. Environmental Services (Water) Sector</strong></p>\\n<ul data-path-to-node=\\"21\\">\\n<li>\\n<p data-path-to-node=\\"21,0,0\\"><strong data-path-to-node=\\"21,0,0\\" data-index-in-node=\\"0\\">Innovation:</strong> Developing investment opportunities for bottled drinking water (AMDK) based on ecosystem services.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"21,1,0\\"><strong data-path-to-node=\\"21,1,0\\" data-index-in-node=\\"0\\">Viability:</strong> Financial assessments (IRR and NPV) are available at the pre-Feasibility Study (pre-FS) level, aligned with Bappenas&rsquo; Green Economy Index.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"21,2,0\\"><strong data-path-to-node=\\"21,2,0\\" data-index-in-node=\\"0\\">Mitigation:</strong> Implementation of the <strong data-path-to-node=\\"21,2,0\\" data-index-in-node=\\"34\\">PES (Payment for Environmental Services)</strong> scheme to protect water catchment areas and prevent environmental pollution.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"22\\"><strong data-path-to-node=\\"22\\" data-index-in-node=\\"0\\">3. Cultural Heritage Sector</strong></p>\\n<ul data-path-to-node=\\"23\\">\\n<li>\\n<p data-path-to-node=\\"23,0,0\\"><strong data-path-to-node=\\"23,0,0\\" data-index-in-node=\\"0\\">Potential:</strong> Development of the Muaro Jambi National Cultural Heritage Area (KCBN), which houses 115 archaeological remains.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"23,1,0\\"><strong data-path-to-node=\\"23,1,0\\" data-index-in-node=\\"0\\">Concept:</strong> Integrating sustainable tourism that respects the \\"four pillars of life\\": forests, settlements, rivers, and agriculture, guided by strict zoning and licensing systems.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"24\\"><strong data-path-to-node=\\"24\\" data-index-in-node=\\"0\\">Inter-Sectoral Synergy:</strong> Attended by 27 Ministries/Agencies and regional governments, this forum ensures the RIMBA project effectively boosts national carbon reserves and biodiversity. All stakeholders' input will be synthesized into the RIMBA Project Executive Summary to guide future green investments.</p>", "id": "<h4 data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Akselerasi Investasi Ekonomi Hijau: Kemen ATR/BPN Tajamkan Skema Jasa Ekosistem dan Pariwisata di Koridor RIMBA</strong></h4>\\n<p data-path-to-node=\\"4\\">Direktorat Jenderal Tata Ruang Kementerian ATR/BPN menyelenggarakan Focus Group Discussion (FGD) ke-4 pada Jumat, 14 November 2025. Pertemuan ini bertujuan menajamkan substansi proses bisnis dan skema investasi ekonomi hijau di Kawasan Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat), dengan fokus pada sektor jasa ekosistem dan pariwisata.</p>\\n<p data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">Pilar Utama Investasi Ekonomi Hijau:</strong></p>\\n<p data-path-to-node=\\"6\\"><strong data-path-to-node=\\"6\\" data-index-in-node=\\"0\\">1. Sektor Pariwisata Berkelanjutan</strong></p>\\n<ul data-path-to-node=\\"7\\">\\n<li>\\n<p data-path-to-node=\\"7,0,0\\"><strong data-path-to-node=\\"7,0,0\\" data-index-in-node=\\"0\\">Fokus:</strong> Pemberdayaan masyarakat dan integrasi konservasi alam.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"7,1,0\\"><strong data-path-to-node=\\"7,1,0\\" data-index-in-node=\\"0\\">Target Strategis:</strong> Kementerian Pariwisata berkomitmen mendorong <strong data-path-to-node=\\"7,1,0\\" data-index-in-node=\\"63\\">Geopark Silokek</strong> di Sumatera Barat untuk meraih status <em data-path-to-node=\\"7,1,0\\" data-index-in-node=\\"117\\">UNESCO Global Geopark</em> (UGGp) melalui kolaborasi multisektor.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"8\\"><strong data-path-to-node=\\"8\\" data-index-in-node=\\"0\\">2. Sektor Jasa Lingkungan (Air)</strong></p>\\n<ul data-path-to-node=\\"9\\">\\n<li>\\n<p data-path-to-node=\\"9,0,0\\"><strong data-path-to-node=\\"9,0,0\\" data-index-in-node=\\"0\\">Inovasi:</strong> Pengembangan peluang investasi Air Minum dalam Kemasan (AMDK) berbasis jasa ekosistem.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"9,1,0\\"><strong data-path-to-node=\\"9,1,0\\" data-index-in-node=\\"0\\">Kelayakan:</strong> Kajian finansial (<em data-path-to-node=\\"9,1,0\\" data-index-in-node=\\"29\\">Internal Rate of Return/IRR</em> dan <em data-path-to-node=\\"9,1,0\\" data-index-in-node=\\"61\\">Net Present Value/NPV</em>) telah tersedia pada tingkat pra-FS dengan mengacu pada Indeks Ekonomi Hijau Bappenas.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"9,2,0\\"><strong data-path-to-node=\\"9,2,0\\" data-index-in-node=\\"0\\">Mitigasi:</strong> Penerapan skema <strong data-path-to-node=\\"9,2,0\\" data-index-in-node=\\"26\\">PES (<em data-path-to-node=\\"9,2,0\\" data-index-in-node=\\"31\\">Payment for Environmental Services</em>)</strong> untuk memastikan pelestarian daerah tangkapan air dan mencegah pencemaran.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"10\\"><strong data-path-to-node=\\"10\\" data-index-in-node=\\"0\\">3. Sektor Kebudayaan &amp; Warisan Sejarah</strong></p>\\n<ul data-path-to-node=\\"11\\">\\n<li>\\n<p data-path-to-node=\\"11,0,0\\"><strong data-path-to-node=\\"11,0,0\\" data-index-in-node=\\"0\\">Potensi:</strong> Pengembangan Kawasan Cagar Budaya Nasional (KCBN) Muaro Jambi yang memiliki 115 situs purbakala.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"11,1,0\\"><strong data-path-to-node=\\"11,1,0\\" data-index-in-node=\\"0\\">Konsep:</strong> Integrasi pariwisata berkelanjutan yang menghormati empat pilar kehidupan lokal: hutan, perkampungan, sungai, dan pertanian melalui sistem zonasi yang ketat.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"12\\"><strong data-path-to-node=\\"12\\" data-index-in-node=\\"0\\">Sinergi Lintas Sektor:</strong> Kegiatan ini melibatkan 27 Kementerian/Lembaga serta pemerintah daerah untuk memastikan proyek RIMBA mampu meningkatkan cadangan karbon dan biodiversitas nasional. Seluruh masukan akan difinalisasi dalam <em data-path-to-node=\\"12\\" data-index-in-node=\\"227\\">Executive Summary</em> proyek RIMBA sebagai panduan investasi hijau masa depan.</p>"}	2025-12-21 16:08:19.192137	2025-12-20 01:31:13.772775	2025-12-21 16:08:13.791844
12	2	[230]	{"en": "Spatial Planning Key to FOLU Net Sink Success: Directorate General of Spatial Planning Emphasizes Carbon Reserve Protection at Carbon Digital Conference 2025", "id": "Tata Ruang Kunci Sukses FOLU Net Sink: Ditjen Tata Ruang Tekankan Perlindungan Cadangan Karbon di Carbon Digital Conference 2025"}	{"en": "spatial-planning-key-to-folu-net-sink-success-directorate-general-of-spatial-planning-emphasizes-carbon-reserve-protection-at-carbon-digital-conference-2025", "id": "tata-ruang-kunci-sukses-folu-net-sink-ditjen-tata-ruang-tekankan-perlindungan-cadangan-karbon-di-carbon-digital-conference-2025"}	{"en": "At the 2025 Carbon Digital Conference, the Directorate General of Spatial Planning emphasized that strategic spatial planning is the primary key to achieving the FOLU Net Sink 2030 targets. Through a rigorous regional planning approach, the government highlighted the importance of protecting carbon stocks within the forestry and land-use sectors to minimize emissions and maintain ecosystem integrity. The integration of digital data into spatial planning is expected to mitigate environmentally harmful land conversion, creating a balance between infrastructure development and ambitious national climate commitments.", "id": "Dalam gelaran Carbon Digital Conference 2025, Direktorat Jenderal Tata Ruang menegaskan bahwa penataan ruang yang strategis merupakan kunci utama dalam mencapai target FOLU Net Sink 2030. Melalui pendekatan perencanaan wilayah yang ketat, pemerintah menekankan pentingnya perlindungan cadangan karbon di sektor kehutanan dan penggunaan lahan guna meminimalisir emisi serta menjaga integritas ekosistem. Integrasi data digital dalam tata ruang diharapkan mampu memitigasi konversi lahan yang merugikan lingkungan, sehingga tercipta keseimbangan antara pembangunan infrastruktur dan komitmen iklim nasional yang ambisius."}	{"en": "<h4 data-path-to-node=\\"13\\"><strong data-path-to-node=\\"13\\" data-index-in-node=\\"0\\">Spatial Planning as a Key Instrument for Green Economy Transition: Ministry of ATR/BPN's Commitment at CDC 2025</strong></h4>\\n<p data-path-to-node=\\"14\\">At the <strong data-path-to-node=\\"14\\" data-index-in-node=\\"7\\">Carbon Digital Conference (CDC) 2025</strong> held at the Bandung Institute of Technology (ITB), the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) reaffirmed the vital role of spatial planning as the foundation for Indonesia's transition to a low-carbon economy.</p>\\n<p data-path-to-node=\\"15\\"><strong data-path-to-node=\\"15\\" data-index-in-node=\\"0\\">1. Digitalization and Investment Certainty</strong> Director General of Spatial Planning, Suyus Windayana, alongside Secretary of the Directorate General, Reny Windyawati, emphasized that the effectiveness of spatial control is now bolstered by a digital ecosystem. Strengthening instruments such as <strong data-path-to-node=\\"15\\" data-index-in-node=\\"291\\">KKPR (Space Utilization Activity Compatibility)</strong> and utilizing digital platforms&mdash;such as <em data-path-to-node=\\"15\\" data-index-in-node=\\"379\\">RTR Online</em>, <em data-path-to-node=\\"15\\" data-index-in-node=\\"391\\">RDTR Realtime</em>, <em data-path-to-node=\\"15\\" data-index-in-node=\\"406\\">GISTARU KKPR</em>, and <em data-path-to-node=\\"15\\" data-index-in-node=\\"424\\">RTR Builder</em>&mdash;are crucial for fostering transparency and providing certainty for green investors.</p>\\n<p data-path-to-node=\\"16\\"><strong data-path-to-node=\\"16\\" data-index-in-node=\\"0\\">2. Governance Challenges and Ecological Solutions</strong> The Ministry highlighted several significant challenges, including:</p>\\n<ul data-path-to-node=\\"17\\">\\n<li>\\n<p data-path-to-node=\\"17,0,0\\">Ecological pressure and land-use conversion in high-carbon value areas.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"17,1,0\\">Weak peatland management outside of designated forest zones.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"17,2,0\\">Limitations in data and spatial utilization monitoring. In response, spatial governance is being steered toward a more adaptive and collaborative approach.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"18\\"><strong data-path-to-node=\\"18\\" data-index-in-node=\\"0\\">3. Contribution to FOLU Net Sink 2030</strong> In support of the <strong data-path-to-node=\\"18\\" data-index-in-node=\\"56\\">FOLU Net Sink 2030</strong> targets, the <em data-path-to-node=\\"18\\" data-index-in-node=\\"88\\">Other Land Use</em> (OLU) sector is recognized for its immense carbon potential through:</p>\\n<ul data-path-to-node=\\"19\\">\\n<li>\\n<p data-path-to-node=\\"19,0,0\\">Strengthening agroforestry systems.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"19,1,0\\">Restoring peatland ecosystems.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"19,2,0\\">Sustainable management of agricultural and plantation lands.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"20\\"><strong data-path-to-node=\\"20\\" data-index-in-node=\\"0\\">4. RIMBA Ecosystem Corridor: A Model of Transformation</strong> The RIMBA Ecosystem Corridor was presented as concrete evidence of successful spatial planning and green economy integration. Spanning <strong data-path-to-node=\\"20\\" data-index-in-node=\\"190\\">3.8 million hectares</strong>, the area has the capacity to store over <strong data-path-to-node=\\"20\\" data-index-in-node=\\"252\\">2.84 billion tons of CO₂e</strong>. Utilizing real-time spatial data innovation and green financing schemes, this corridor proves that spatial planning can effectively bridge ecosystem protection with inclusive economic growth.</p>", "id": "<h4 data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Tata Ruang Sebagai Instrumen Kunci Transisi Ekonomi Hijau: Komitmen Kementerian ATR/BPN pada CDC 2025</strong></h4>\\n<p data-path-to-node=\\"4\\">Dalam penyelenggaraan <strong data-path-to-node=\\"4\\" data-index-in-node=\\"22\\">Carbon Digital Conference (CDC) 2025</strong> di Institut Teknologi Bandung (ITB), Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) menegaskan peran vital penataan ruang sebagai fondasi transisi menuju ekonomi rendah karbon di Indonesia.</p>\\n<p data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">1. Digitalisasi dan Kepastian Investasi</strong> Dirjen Tata Ruang, Suyus Windayana, bersama Sesditjen Reny Windyawati, menekankan bahwa efektivitas pengendalian ruang kini didukung oleh ekosistem digital. Penguatan instrumen seperti <strong data-path-to-node=\\"5\\" data-index-in-node=\\"225\\">KKPR (Kesesuaian Kegiatan Pemanfaatan Ruang)</strong> serta pemanfaatan platform digital&mdash;seperti <em data-path-to-node=\\"5\\" data-index-in-node=\\"313\\">RTR Online</em>, <em data-path-to-node=\\"5\\" data-index-in-node=\\"325\\">RDTR Realtime</em>, <em data-path-to-node=\\"5\\" data-index-in-node=\\"340\\">GISTARU KKPR</em>, dan <em data-path-to-node=\\"5\\" data-index-in-node=\\"358\\">RTR Builder</em>&mdash;menjadi kunci untuk menciptakan transparansi dan kepastian bagi para investor hijau.</p>\\n<p data-path-to-node=\\"6\\"><strong data-path-to-node=\\"6\\" data-index-in-node=\\"0\\">2. Tantangan Tata Kelola dan Solusi Ekologis</strong> Kementerian menyoroti beberapa tantangan besar, di antaranya:</p>\\n<ul data-path-to-node=\\"7\\">\\n<li>\\n<p data-path-to-node=\\"7,0,0\\">Tekanan ekologis dan alih fungsi lahan di area bernilai karbon tinggi.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"7,1,0\\">Lemahnya pengelolaan gambut di luar kawasan hutan.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"7,2,0\\">Keterbatasan data serta monitoring pemanfaatan ruang. Menjawab tantangan tersebut, tata kelola ruang diarahkan agar lebih adaptif melalui pendekatan kolaboratif.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"8\\"><strong data-path-to-node=\\"8\\" data-index-in-node=\\"0\\">3. Kontribusi Terhadap FOLU Net Sink 2030</strong> Dalam mendukung target <strong data-path-to-node=\\"8\\" data-index-in-node=\\"65\\">FOLU Net Sink 2030</strong>, sektor <em data-path-to-node=\\"8\\" data-index-in-node=\\"92\\">Other Land Use</em> (OLU) dinilai memiliki potensi karbon yang besar melalui:</p>\\n<ul data-path-to-node=\\"9\\">\\n<li>\\n<p data-path-to-node=\\"9,0,0\\">Penguatan sistem agroforestri.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"9,1,0\\">Restorasi ekosistem gambut.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"9,2,0\\">Pengelolaan berkelanjutan pada lahan pertanian dan perkebunan.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"10\\"><strong data-path-to-node=\\"10\\" data-index-in-node=\\"0\\">4. Koridor Ekosistem RIMBA: Model Transformasi Nyata</strong> Koridor Ekosistem RIMBA dipaparkan sebagai bukti keberhasilan integrasi tata ruang dan ekonomi hijau. Dengan luas <strong data-path-to-node=\\"10\\" data-index-in-node=\\"167\\">3,8 juta hektare</strong>, kawasan ini mampu menyimpan lebih dari <strong data-path-to-node=\\"10\\" data-index-in-node=\\"224\\">2,84 miliar ton CO₂e</strong>. Melalui inovasi data spasial <em data-path-to-node=\\"10\\" data-index-in-node=\\"275\\">real-time</em> dan skema pembiayaan hijau, koridor ini membuktikan bahwa tata ruang mampu menjembatani perlindungan ekosistem dengan pertumbuhan ekonomi inklusif.</p>"}	2025-12-21 16:07:24.267116	2025-12-20 01:33:16.768238	2025-12-21 16:07:17.031227
10	2	[228]	{"en": "Dissemination of Green Economy Learning in Jambi Strengthen Understanding, Strengthen Action, Accelerate Green Transformation RIMBA", "id": "Diseminasi Pembelajaran Ekonomi Hijau di Jambi Kuatkan Pemahaman, Perkuat Aksi, Percepat Transformasi Hijau RIMBA"}	{"en": "dissemination-of-green-economy-learning-in-jambi-strengthen-understanding-strengthen-action-accelerate-green-transformation-rimba", "id": "diseminasi-pembelajaran-ekonomi-hijau-di-jambi-kuatkan-pemahaman-perkuat-aksi-percepat-transformasi-hijau-rimba"}	{"en": "The dissemination of green economy learning in Jambi serves as a strategic step to strengthen understanding and drive concrete action in accelerating the green transformation across the RIMBA ecosystem corridor. This initiative focuses on integrating low-carbon innovations with community empowerment to create a harmonious balance between environmental preservation and inclusive economic growth. By equipping stakeholders with practical knowledge, the program aims to cultivate local champions capable of leading the transition toward a more sustainable and resilient future in the heart of Sumatra.", "id": "Kegiatan diseminasi pembelajaran ekonomi hijau di Jambi merupakan langkah strategis untuk memperkuat pemahaman dan aksi nyata dalam mempercepat transformasi hijau di seluruh koridor ekosistem RIMBA. Inisiatif ini berfokus pada pengintegrasian inovasi rendah karbon dengan pemberdayaan masyarakat guna menciptakan keseimbangan yang harmonis antara pelestarian lingkungan dan pertumbuhan ekonomi yang inklusif. Dengan membekali para pemangku kepentingan melalui pengetahuan praktis, program ini bertujuan untuk mencetak penggerak lokal yang mampu mengawal transisi menuju masa depan yang lebih berkelanjutan dan tangguh di jantung Sumatra."}	{"en": "<h4 data-path-to-node=\\"10\\"><strong data-path-to-node=\\"10\\" data-index-in-node=\\"0\\">Green Economy Dissemination in Jambi: RIMBA Project Strengthens Collaboration and Low-Carbon Innovation</strong></h4>\\n<p data-path-to-node=\\"11\\">The Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN), through the RIMBA Project, successfully hosted the \\"Dissemination of Green Economy Learning through Low-Carbon Technological Innovation\\" on November 12&ndash;14, 2025, in Jambi City. This event served as a strategic platform to align the vision for sustainable development in Sumatra.</p>\\n<p data-path-to-node=\\"12\\"><strong data-path-to-node=\\"12\\" data-index-in-node=\\"0\\">Key Highlights of the Dissemination:</strong></p>\\n<ul data-path-to-node=\\"13\\">\\n<li>\\n<p data-path-to-node=\\"13,0,0\\"><strong data-path-to-node=\\"13,0,0\\" data-index-in-node=\\"0\\">Green Economy Modules:</strong> A team from Gadjah Mada University (UGM) developed green economy modules ranging from basic to applied levels. These are designed as \\"living modules,\\" ensuring they are continuously updated based on successful field practices.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,1,0\\"><strong data-path-to-node=\\"13,1,0\\" data-index-in-node=\\"0\\">Strategic Corridor Delineation:</strong> Jambi features the most extensive ecosystem corridor delineation within the RIMBA project, as it encompasses vital movement paths for Sumatran tigers and elephants. The Bukit Batabuh Protection Forest was emphasized as a critical link for habitat connectivity.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,2,0\\"><strong data-path-to-node=\\"13,2,0\\" data-index-in-node=\\"0\\">Three Pillars of Transformation:</strong></p>\\n<ol start=\\"1\\" data-path-to-node=\\"13,2,1\\">\\n<li>\\n<p data-path-to-node=\\"13,2,1,0,0\\"><strong data-path-to-node=\\"13,2,1,0,0\\" data-index-in-node=\\"0\\">Agriculture &amp; Forestry:</strong> Strengthening agroforestry and circular economy systems, including the integration of bio-CNG production from palm oil waste.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,2,1,1,0\\"><strong data-path-to-node=\\"13,2,1,1,0\\" data-index-in-node=\\"0\\">Energy &amp; Green Technology:</strong> Highlighting the urgency of transitioning to clean energy amidst the dominance of fossil fuels.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,2,1,2,0\\"><strong data-path-to-node=\\"13,2,1,2,0\\" data-index-in-node=\\"0\\">Community Empowerment:</strong> Engaging the younger generation through participatory planning and social media to drive green jobs, green investment, and green growth.</p>\\n</li>\\n</ol>\\n</li>\\n<li>\\n<p data-path-to-node=\\"13,3,0\\"><strong data-path-to-node=\\"13,3,0\\" data-index-in-node=\\"0\\">Empowering Local Champions:</strong> The event acted as a catalyst to identify and empower local leaders who will spearhead the green transformation at the grassroots level.</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"14\\">As part of a National Strategic Area (KSN) with a solid legal foundation, the RIMBA Project reaffirms that this corridor is not just a wildlife path, but a sustainable and inclusive workspace oriented toward a resilient future.</p>", "id": "<h4 data-path-to-node=\\"3\\"><strong data-path-to-node=\\"3\\" data-index-in-node=\\"0\\">Diseminasi Ekonomi Hijau di Jambi: Proyek RIMBA Perkuat Kolaborasi dan Inovasi Rendah Karbon</strong></h4>\\n<p data-path-to-node=\\"4\\">Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) melalui Proyek RIMBA sukses menggelar acara \\"Diseminasi Pembelajaran Ekonomi Hijau melalui Inovasi Teknologi Rendah Karbon\\" pada 12&ndash;14 November 2025 di Kota Jambi. Kegiatan ini menjadi wadah strategis untuk menyelaraskan visi pembangunan berkelanjutan di wilayah Sumatera.</p>\\n<p data-path-to-node=\\"5\\"><strong data-path-to-node=\\"5\\" data-index-in-node=\\"0\\">Poin-Poin Utama Diseminasi:</strong></p>\\n<ul data-path-to-node=\\"6\\">\\n<li>\\n<p data-path-to-node=\\"6,0,0\\"><strong data-path-to-node=\\"6,0,0\\" data-index-in-node=\\"0\\">Pengembangan Modul Ekonomi Hijau:</strong> Tim akademisi dari Universitas Gadjah Mada (UGM) menyusun modul ekonomi hijau dari tingkat dasar hingga terapan. Modul ini bersifat <em data-path-to-node=\\"6,0,0\\" data-index-in-node=\\"166\\">living module</em>, yang artinya akan terus diperbarui berdasarkan praktik baik di lapangan.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,1,0\\"><strong data-path-to-node=\\"6,1,0\\" data-index-in-node=\\"0\\">Delineasi Koridor Strategis:</strong> Jambi memiliki delineasi koridor ekosistem terluas karena menjadi jalur utama pergerakan satwa liar seperti gajah dan harimau. Fokus utama adalah menjaga Hutan Lindung Bukit Batabuh sebagai penghubung habitat yang krusial.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,2,0\\"><strong data-path-to-node=\\"6,2,0\\" data-index-in-node=\\"0\\">Fokus Tiga Pilar Transformasi:</strong></p>\\n<ol start=\\"1\\" data-path-to-node=\\"6,2,1\\">\\n<li>\\n<p data-path-to-node=\\"6,2,1,0,0\\"><strong data-path-to-node=\\"6,2,1,0,0\\" data-index-in-node=\\"0\\">Pertanian &amp; Kehutanan:</strong> Penguatan sistem agroforestri dan ekonomi sirkular, termasuk pemanfaatan limbah sawit menjadi bio-CNG.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,2,1,1,0\\"><strong data-path-to-node=\\"6,2,1,1,0\\" data-index-in-node=\\"0\\">Energi &amp; Teknologi Hijau:</strong> Mendorong transisi ke energi bersih untuk mengurangi ketergantungan pada bahan bakar fosil.</p>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,2,1,2,0\\"><strong data-path-to-node=\\"6,2,1,2,0\\" data-index-in-node=\\"0\\">Pemberdayaan Masyarakat:</strong> Melibatkan generasi muda melalui perencanaan partisipatif dan pemanfaatan media sosial guna menciptakan lapangan kerja hijau (<em data-path-to-node=\\"6,2,1,2,0\\" data-index-in-node=\\"151\\">green jobs</em>).</p>\\n</li>\\n</ol>\\n</li>\\n<li>\\n<p data-path-to-node=\\"6,3,0\\"><strong data-path-to-node=\\"6,3,0\\" data-index-in-node=\\"0\\">Penjaringan Local Champions:</strong> Acara ini berhasil mengidentifikasi sosok-sosok penggerak lokal yang akan menjadi motor transformasi hijau di tapak (lapangan).</p>\\n</li>\\n</ul>\\n<p data-path-to-node=\\"7\\">Dengan dasar legal yang kuat sebagai bagian dari Kawasan Strategis Nasional (KSN), Proyek RIMBA menegaskan bahwa koridor ini bukan sekadar jalur satwa, melainkan ruang kerja berkelanjutan yang inklusif dan berorientasi masa depan.</p>"}	2025-12-21 16:09:05.991432	2025-12-20 01:26:44.616817	2025-12-21 16:09:00.879616
\.


--
-- Data for Name: cms_news_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cms_news_categories (id, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	{"en": "Cooperation", "id": "Kerjasama"}	{"en": "Cooperation", "id": "Kerjasama"}	\N	2025-11-02 02:29:05.917939	2025-11-02 02:29:05.917939
2	{"en": "Implementation", "id": "Pelaksanaan"}	{"en": "Implementation", "id": "Pelaksanaan"}	\N	2025-11-02 02:41:16.989247	2025-12-22 03:19:28.287482
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, uploaded_by, verified_by, file_id, file_name, file_path, file_url, file_mime_type, file_size, deleted_at, created_at, updated_at) FROM stdin;
1	1	1	07799156-19fd-46e0-933b-91a736c409d8	tralalero.png	storage/documents/tralalero.png	https://doc.rimbaexium.org/storage/documents/tralalero.png	image/png	83.62 kB	\N	2025-10-31 22:04:26.260192	2025-10-31 22:04:26.260192
2	1	1	95fcb578-9628-4c98-9819-04c102ba811d	tralalero(1).png	storage/documents/tralalero(1).png	https://doc.rimbaexium.org/storage/documents/tralalero(1).png	image/png	83.62 kB	\N	2025-10-31 22:06:07.833162	2025-10-31 22:06:07.833162
3	1	1	721a0fcb-06bb-45cc-9514-0677be2312fd	tralalero(2).png	storage/documents/tralalero(2).png	https://doc.rimbaexium.org/storage/documents/tralalero(2).png	image/png	83.62 kB	\N	2025-10-31 22:06:08.921868	2025-10-31 22:06:08.921868
4	1	1	08cabbb2-fc76-4a40-ad63-d0d622759de2	tralalero(3).png	storage/documents/tralalero(3).png	https://doc.rimbaexium.org/storage/documents/tralalero(3).png	image/png	83.62 kB	\N	2025-10-31 22:06:09.986183	2025-10-31 22:06:09.986183
5	1	1	63bdd6b6-373b-49b6-8379-ed49fff6ff1b	tralalero(4).png	storage/documents/tralalero(4).png	https://doc.rimbaexium.org/storage/documents/tralalero(4).png	image/png	83.62 kB	\N	2025-10-31 22:06:11.081671	2025-10-31 22:06:11.081671
6	1	1	9465bd98-05eb-4e14-9872-29ae72a25b25	tralalero(5).png	storage/documents/tralalero(5).png	https://doc.rimbaexium.org/storage/documents/tralalero(5).png	image/png	83.62 kB	\N	2025-10-31 22:06:12.207575	2025-10-31 22:06:12.207575
7	1	1	a29563cc-25b3-4fc7-bdb7-11ea21ae0b58	tralalero(6).png	storage/documents/tralalero(6).png	https://doc.rimbaexium.org/storage/documents/tralalero(6).png	image/png	83.62 kB	\N	2025-10-31 22:06:21.247318	2025-10-31 22:06:21.247318
8	1	1	4e62af6d-f9b3-4902-a192-ba3314155d7f	tralalero(7).png	storage/documents/tralalero(7).png	https://doc.rimbaexium.org/storage/documents/tralalero(7).png	image/png	83.62 kB	\N	2025-10-31 22:06:22.509155	2025-10-31 22:06:22.509155
9	1	1	214b2a3d-e689-4205-a1cb-d8b3738435e4	tralalero(8).png	storage/documents/tralalero(8).png	https://doc.rimbaexium.org/storage/documents/tralalero(8).png	image/png	83.62 kB	\N	2025-10-31 22:06:23.585828	2025-10-31 22:06:23.585828
10	1	1	8eb74b68-6bc8-4d19-a963-d02952994355	tralalero(9).png	storage/documents/tralalero(9).png	https://doc.rimbaexium.org/storage/documents/tralalero(9).png	image/png	83.62 kB	\N	2025-10-31 22:06:24.920569	2025-10-31 22:06:24.920569
11	1	1	56455814-95a4-4e58-9bd1-949f588bc91c	tralalero(10).png	storage/documents/tralalero(10).png	https://doc.rimbaexium.org/storage/documents/tralalero(10).png	image/png	83.62 kB	\N	2025-10-31 22:06:26.234324	2025-10-31 22:06:26.234324
13	1	1	e753b877-8079-4198-b7f1-1e0c4d9dba95	tralalero(12).png	storage/documents/tralalero(12).png	https://doc.rimbaexium.org/storage/documents/tralalero(12).png	image/png	83.62 kB	2025-11-02 06:53:25.409251	2025-10-31 22:18:20.662168	2025-10-31 22:18:20.662168
15	1	1	582d8f4a-74c3-464d-b25e-a9741ea602b4	tralalero(14).png	storage/documents/tralalero(14).png	https://doc.rimbaexium.org/storage/documents/tralalero(14).png	image/png	83.62 kB	2025-11-02 06:53:25.409251	2025-10-31 22:18:20.67033	2025-10-31 22:18:20.67033
16	1	1	5436e90d-b721-4176-a529-5e17571c565e	tralalero(15).png	storage/documents/tralalero(15).png	https://doc.rimbaexium.org/storage/documents/tralalero(15).png	image/png	83.62 kB	2025-11-02 06:53:30.221918	2025-10-31 22:18:20.671155	2025-10-31 22:18:20.671155
18	1	1	3f870e16-edb3-44d4-85f7-94cdaa4c2a08	tralalero(17).png	storage/documents/tralalero(17).png	https://doc.rimbaexium.org/storage/documents/tralalero(17).png	image/png	83.62 kB	2025-11-02 06:57:05.655212	2025-10-31 22:18:26.302354	2025-10-31 22:18:26.302354
19	1	1	cf0bc1a1-a058-4038-bb19-bdd1768a5976	tralalero(18).png	storage/documents/tralalero(18).png	https://doc.rimbaexium.org/storage/documents/tralalero(18).png	image/png	83.62 kB	2025-11-02 06:57:05.655212	2025-10-31 22:18:26.311871	2025-10-31 22:18:26.311871
20	1	1	90d26685-61ff-4b56-a4f4-8b69858bce38	tralalero(19).png	storage/documents/tralalero(19).png	https://doc.rimbaexium.org/storage/documents/tralalero(19).png	image/png	83.62 kB	2025-11-02 06:57:05.655212	2025-10-31 22:18:26.315482	2025-10-31 22:18:26.315482
25	1	1	7ede231a-3a1c-43c6-8c3c-87a56c67e3d5	tralalero(24).png	storage/documents/tralalero(24).png	https://doc.rimbaexium.org/storage/documents/tralalero(24).png	image/png	83.62 kB	2025-11-02 07:03:10.167316	2025-10-31 22:23:54.126403	2025-10-31 22:23:54.126403
26	1	1	23a1c69d-be18-470f-8de5-70a389868ff7	tralalero(25).png	storage/documents/tralalero(25).png	https://doc.rimbaexium.org/storage/documents/tralalero(25).png	image/png	83.62 kB	2025-11-02 07:05:37.514356	2025-10-31 22:24:20.565324	2025-10-31 22:24:20.565324
24	1	1	cad548f0-039c-45bf-ab2e-734245273dc6	tralalero(23).png	storage/documents/tralalero(23).png	https://doc.rimbaexium.org/storage/documents/tralalero(23).png	image/png	83.62 kB	2025-11-02 07:07:10.178836	2025-10-31 22:23:28.903321	2025-10-31 22:23:28.903321
27	1	1	b501ecf8-a8cf-4bda-97f1-48a0d36deda2	tralalero(26).png	storage/documents/tralalero(26).png	https://doc.rimbaexium.org/storage/documents/tralalero(26).png	image/png	83.62 kB	2025-11-02 07:10:10.285551	2025-10-31 22:26:53.123402	2025-10-31 22:26:53.123402
28	1	1	e7d61e90-4a0c-424f-bd84-1d56bea9d2ab	tralalero(27).png	storage/documents/tralalero(27).png	https://doc.rimbaexium.org/storage/documents/tralalero(27).png	image/png	83.62 kB	2025-11-02 07:11:26.789905	2025-10-31 22:27:17.528333	2025-10-31 22:27:17.528333
29	1	1	cd15671a-fd6f-4b33-8f97-ed22c3923c62	tralalero(28).png	storage/documents/tralalero(28).png	https://doc.rimbaexium.org/storage/documents/tralalero(28).png	image/png	83.62 kB	2025-11-02 07:13:03.02232	2025-10-31 22:27:41.215535	2025-10-31 22:27:41.215535
30	1	1	2ebb2877-ee12-4ca8-a46d-31d490577270	tralalero(29).png	storage/documents/tralalero(29).png	https://doc.rimbaexium.org/storage/documents/tralalero(29).png	image/png	83.62 kB	2025-11-02 07:14:05.387592	2025-10-31 22:28:01.341328	2025-10-31 22:28:01.341328
31	1	1	24c233d7-9b6e-4cf8-b40e-69d02aef269d	tralalero(30).png	storage/documents/tralalero(30).png	https://doc.rimbaexium.org/storage/documents/tralalero(30).png	image/png	83.62 kB	2025-11-02 07:15:28.03008	2025-10-31 22:28:34.678517	2025-10-31 22:28:34.678517
35	1	1	59fa5d6d-73b7-48f2-a2f3-274b3048c856	3.jpg	storage/documents/3.jpg	https://doc.rimbaexium.org/storage/documents/3.jpg	image/jpeg	546.21 kB	2025-12-15 03:34:01.292959	2025-11-01 02:44:37.132317	2025-11-01 02:44:37.132317
32	1	1	27c9c8f2-d736-48d5-ad82-d3a129dfef0d	hero-bg.jpg	storage/documents/hero-bg.jpg	https://doc.rimbaexium.org/storage/documents/hero-bg.jpg	image/jpeg	1.19 mB	2025-12-19 14:53:19.774089	2025-11-01 02:38:53.865332	2025-11-01 02:38:53.865332
33	1	1	337f389a-e382-4a88-a3d1-dada09f66c28	1.jpg	storage/documents/1.jpg	https://doc.rimbaexium.org/storage/documents/1.jpg	image/jpeg	784.24 kB	2025-12-19 14:56:38.405007	2025-11-01 02:44:03.301429	2025-11-01 02:44:03.301429
36	1	1	32fa207d-6365-4e37-bee2-d838cd2b3f9a	4.jpg	storage/documents/4.jpg	https://doc.rimbaexium.org/storage/documents/4.jpg	image/jpeg	930.27 kB	2025-12-19 15:01:19.98481	2025-11-01 02:44:58.18839	2025-11-01 02:44:58.18839
37	1	1	c068ea5f-d5f0-47cd-a1b4-c23289abae04	5.jpg	storage/documents/5.jpg	https://doc.rimbaexium.org/storage/documents/5.jpg	image/jpeg	794.74 kB	2025-12-19 15:02:26.687618	2025-11-01 02:45:11.861631	2025-11-01 02:45:11.861631
38	1	1	936af28d-8ab7-40a3-b90a-eaaaa13f0423	6.jpg	storage/documents/6.jpg	https://doc.rimbaexium.org/storage/documents/6.jpg	image/jpeg	412.19 kB	2025-12-19 15:02:53.169094	2025-11-01 02:45:27.95818	2025-11-01 02:45:27.95818
40	1	1	b30cb152-6af7-46c5-9d4f-fd9474d5fa50	8.jpg	storage/documents/8.jpg	https://doc.rimbaexium.org/storage/documents/8.jpg	image/jpeg	480.61 kB	2025-12-19 15:04:10.005139	2025-11-01 02:46:47.742075	2025-11-01 02:46:47.742075
237	1	1	0c54d593-6b11-471f-a4d2-47ba29b3aa8e	PP 13 TAHUN 2017.pdf	storage/documents/PP 13 TAHUN 2017.pdf	https://rimba.webgis.app/cms/storage/documents/PP%2013%20TAHUN%202017.pdf	application/pdf	4.85 mB	\N	2025-12-20 02:01:54.042541	2025-12-20 02:01:54.042541
43	1	1	72d48240-9419-467f-a9ab-66b08b8a09a7	rnGqssUGkWmOHOCzWGbetONGcb7wRyqYwyQpCzEi.pdf	storage/documents/rnGqssUGkWmOHOCzWGbetONGcb7wRyqYwyQpCzEi.pdf	https://doc.rimbaexium.org/storage/documents/rnGqssUGkWmOHOCzWGbetONGcb7wRyqYwyQpCzEi.pdf	application/pdf	1.02 mB	\N	2025-11-01 03:16:11.017321	2025-11-01 03:16:11.017321
44	1	1	93bf0d27-1382-440f-b22d-7a81c3b08a17	JHdfHK0WMiyp8cfMhcdyKC6F4FC7jJz8NmvMSr0N.pdf	storage/documents/JHdfHK0WMiyp8cfMhcdyKC6F4FC7jJz8NmvMSr0N.pdf	https://doc.rimbaexium.org/storage/documents/JHdfHK0WMiyp8cfMhcdyKC6F4FC7jJz8NmvMSr0N.pdf	application/pdf	6.85 mB	\N	2025-11-01 03:50:45.820256	2025-11-01 03:50:45.820256
45	1	1	22d57f12-9ac8-4af6-93c8-583545d88cd8	IL5LeFrGmrBp4w0K18a5OILNGp150sRYrhhKjayS_compressed.pdf	storage/documents/IL5LeFrGmrBp4w0K18a5OILNGp150sRYrhhKjayS_compressed.pdf	https://doc.rimbaexium.org/storage/documents/IL5LeFrGmrBp4w0K18a5OILNGp150sRYrhhKjayS_compressed.pdf	application/pdf	1.76 mB	\N	2025-11-01 03:57:30.21455	2025-11-01 03:57:30.21455
46	1	1	3782a2b9-c47c-485c-b74c-94026908025f	zKM9S97rov2McrPBnyokHcNldhrnvfDtjWM4SMx9.pdf	storage/documents/zKM9S97rov2McrPBnyokHcNldhrnvfDtjWM4SMx9.pdf	https://doc.rimbaexium.org/storage/documents/zKM9S97rov2McrPBnyokHcNldhrnvfDtjWM4SMx9.pdf	application/pdf	204.69 kB	\N	2025-11-01 04:05:10.561323	2025-11-01 04:05:10.561323
47	1	1	39ec47f0-a15c-4c5b-8175-1c22ee675a52	2Pw28jxsWncJUTJ7uKtuIk1exGIuQKRe29QBSpO6.pdf	storage/documents/2Pw28jxsWncJUTJ7uKtuIk1exGIuQKRe29QBSpO6.pdf	https://doc.rimbaexium.org/storage/documents/2Pw28jxsWncJUTJ7uKtuIk1exGIuQKRe29QBSpO6.pdf	application/pdf	440.83 kB	\N	2025-11-01 04:08:12.027963	2025-11-01 04:08:12.027963
51	1	1	dfd89dde-e152-4668-8ab7-f96356f3fec6	7(1).jpg	storage/documents/7(1).jpg	https://doc.rimbaexium.org/storage/documents/7(1).jpg	image/jpeg	949.16 kB	\N	2025-11-01 04:34:20.368317	2025-11-01 04:34:20.368317
52	1	1	6d0845c3-2ed1-431a-a4ff-39962d3a7ff5	9(1).jpg	storage/documents/9(1).jpg	https://doc.rimbaexium.org/storage/documents/9(1).jpg	image/jpeg	964.88 kB	\N	2025-11-01 04:35:43.8838	2025-11-01 04:35:43.8838
53	1	1	0edfb2d3-420a-43a5-9f91-75faa378b8cc	ez2UG9IjoQ.jpeg	storage/documents/ez2UG9IjoQ.jpeg	https://doc.rimbaexium.org/storage/documents/ez2UG9IjoQ.jpeg	image/jpeg	61.61 kB	\N	2025-11-01 04:39:33.063501	2025-11-01 04:39:33.063501
55	1	1	723f4084-84ee-4582-8759-d2fe9f2aa7ac	quiz-import-template.xls	storage/documents/quiz-import-template.xls	https://doc.rimbaexium.org/storage/documents/quiz-import-template.xls	application/vnd.ms-excel	26.50 kB	\N	2025-11-01 08:48:55.963448	2025-11-01 08:48:55.963448
54	1	1	a388c5ee-74c0-433b-8438-1ac1b83a6856	dummy-pdf_2.pdf	storage/documents/dummy-pdf_2.pdf	https://doc.rimbaexium.org/storage/documents/dummy-pdf_2.pdf	application/pdf	7.30 kB	2025-11-01 08:48:55.981914	2025-11-01 08:38:33.814133	2025-11-01 08:38:33.814133
57	1	1	f54771d1-dd9f-4807-ac3d-39674d7e65b7	IMG-20250717-WA0042.jpg	storage/documents/IMG-20250717-WA0042.jpg	https://doc.rimbaexium.org/storage/documents/IMG-20250717-WA0042.jpg	image/jpeg	106.17 kB	\N	2025-11-02 02:37:37.463112	2025-11-02 02:37:37.463112
58	1	1	4f4d6475-2c5d-4758-b62a-c71710c33fbb	1674794177.jpeg	storage/documents/1674794177.jpeg	https://doc.rimbaexium.org/storage/documents/1674794177.jpeg	image/jpeg	211.81 kB	\N	2025-11-02 02:43:54.785237	2025-11-02 02:43:54.785237
48	1	1	84bd57d7-248e-4c5b-8b33-d4e08215cb28	WhatsApp Image 2025-10-12 at 21.46.00_e13983ed.jpg	storage/documents/WhatsApp Image 2025-10-12 at 21.46.00_e13983ed.jpg	https://doc.rimbaexium.org/storage/documents/WhatsApp%20Image%202025-10-12%20at%2021.46.00_e13983ed.jpg	image/jpeg	26.46 kB	2025-11-02 02:59:54.440018	2025-11-01 04:14:20.050756	2025-11-01 04:14:20.050756
42	1	1	fb02aded-209a-4446-8430-730e06aa7f4a	10.jpg	storage/documents/10.jpg	https://doc.rimbaexium.org/storage/documents/10.jpg	image/jpeg	879.80 kB	2025-11-03 23:57:43.232284	2025-11-01 02:47:17.90609	2025-11-01 02:47:17.90609
34	1	1	78469d4e-858f-435b-9fa6-ebca2f251ae5	2.jpg	storage/documents/2.jpg	https://doc.rimbaexium.org/storage/documents/2.jpg	image/jpeg	993.50 kB	2025-11-03 23:59:41.460655	2025-11-01 02:44:24.942354	2025-11-01 02:44:24.942354
39	1	1	882e2b07-6278-4ed0-bd22-09ef91f02ceb	7.jpg	storage/documents/7.jpg	https://doc.rimbaexium.org/storage/documents/7.jpg	image/jpeg	949.16 kB	2025-11-04 00:00:49.215989	2025-11-01 02:45:44.366323	2025-11-01 02:45:44.366323
41	1	1	b4897994-3b43-4260-953e-aead715a751b	9.jpg	storage/documents/9.jpg	https://doc.rimbaexium.org/storage/documents/9.jpg	image/jpeg	964.88 kB	2025-11-17 06:49:26.65861	2025-11-01 02:46:59.67132	2025-11-01 02:46:59.67132
62	1	1	567c1125-7a29-44c1-8deb-d232be7c113f	Screenshot 2025-10-23 083629.png	storage/documents/Screenshot 2025-10-23 083629.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20083629.png	image/png	646.75 kB	2025-11-26 16:13:27.653086	2025-11-02 03:03:06.397351	2025-11-02 03:03:06.397351
61	1	1	d675e262-f4a1-4327-99ad-c8e599e42c09	Screenshot 2025-10-23 083443.png	storage/documents/Screenshot 2025-10-23 083443.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20083443.png	image/png	602.80 kB	2025-11-26 16:13:46.977535	2025-11-02 03:02:14.753646	2025-11-02 03:02:14.753646
63	1	1	a9761610-8ad4-4a09-ba88-20b38b1e2300	Bahan Paparan Project Rimba KSN 1_3 April 2024_removed.pdf	storage/documents/Bahan Paparan Project Rimba KSN 1_3 April 2024_removed.pdf	https://doc.rimbaexium.org/storage/documents/Bahan%20Paparan%20Project%20Rimba%20KSN%201_3%20April%202024_removed.pdf	application/pdf	2.43 mB	\N	2025-11-02 03:10:40.435613	2025-11-02 03:10:40.435613
64	36	1	230a9235-d3f9-40a0-b6ab-56fb489b6224	certificate-1.pdf	storage/documents/certificate-1.pdf	https://doc.rimbaexium.org/storage/documents/certificate-1.pdf	application/pdf	15.22 kB	\N	2025-11-02 03:16:54.187451	2025-11-02 03:16:54.187451
65	2	1	00aea89e-d2fa-434f-8c34-0e6275d94c27	Bahan Paparan Project Rimba KSN 1_3 April 2024_removed (1).pdf	storage/documents/Bahan Paparan Project Rimba KSN 1_3 April 2024_removed (1).pdf	https://doc.rimbaexium.org/storage/documents/Bahan%20Paparan%20Project%20Rimba%20KSN%201_3%20April%202024_removed%20(1).pdf	application/pdf	6.14 mB	\N	2025-11-02 03:24:51.27488	2025-11-02 03:24:51.27488
17	1	1	5a1003b3-7199-470b-8138-4a3a357b727e	tralalero(16).png	storage/documents/tralalero(16).png	https://doc.rimbaexium.org/storage/documents/tralalero(16).png	image/png	83.62 kB	2025-11-02 03:56:26.364613	2025-10-31 22:18:20.672373	2025-10-31 22:18:20.672373
12	1	1	e6d1594f-6db4-4493-b890-52119c19b96e	tralalero(11).png	storage/documents/tralalero(11).png	https://doc.rimbaexium.org/storage/documents/tralalero(11).png	image/png	83.62 kB	2025-11-02 03:57:01.78931	2025-10-31 22:18:20.653319	2025-10-31 22:18:20.653319
14	1	1	62750c97-525f-4d41-ad88-e1d7ad161017	tralalero(13).png	storage/documents/tralalero(13).png	https://doc.rimbaexium.org/storage/documents/tralalero(13).png	image/png	83.62 kB	2025-11-02 03:57:07.405308	2025-10-31 22:18:20.666449	2025-10-31 22:18:20.666449
50	1	1	60f8446d-1b3e-4ce0-8c2a-a8036c3d72d0	logo-ipsum-1.png	storage/documents/logo-ipsum-1.png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-1.png	image/png	4.37 kB	2025-11-02 06:53:44.99097	2025-11-01 04:27:51.289014	2025-11-01 04:27:51.289014
66	1	1	f4d26404-4cbb-4fc5-8e88-8e9e212b3bd6	logo-ipsum-2.png	storage/documents/logo-ipsum-2.png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-2.png	image/png	2.37 kB	2025-11-02 06:53:44.99097	2025-11-02 03:57:36.049344	2025-11-02 03:57:36.049344
242	1	1	1b4fed52-e046-4f03-af04-73c768c78286	2(3).png	storage/documents/2(3).png	https://rimba.webgis.app/cms/storage/documents/2(3).png	image/png	353.97 kB	\N	2025-12-20 02:28:37.781429	2025-12-20 02:28:37.781429
245	1	1	0cd09caa-a38a-46b7-b2b2-504c7a2e7b8f	5(3).png	storage/documents/5(3).png	https://rimba.webgis.app/cms/storage/documents/5(3).png	image/png	422.93 kB	\N	2025-12-20 02:30:13.249469	2025-12-20 02:30:13.249469
67	1	1	a2dffec6-03f1-4d40-8538-061d9392be1c	logo-ipsum-3.png	storage/documents/logo-ipsum-3.png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-3.png	image/png	3.25 kB	2025-11-02 06:53:44.99097	2025-11-02 03:57:58.216377	2025-11-02 03:57:58.216377
21	1	1	11663adf-60a9-44cd-bc47-be11c15c9eb2	tralalero(20).png	storage/documents/tralalero(20).png	https://doc.rimbaexium.org/storage/documents/tralalero(20).png	image/png	83.62 kB	2025-11-02 06:57:05.655212	2025-10-31 22:18:26.319822	2025-10-31 22:18:26.319822
22	1	1	4178c07d-76b0-42c7-bf00-57029d8b0eec	tralalero(21).png	storage/documents/tralalero(21).png	https://doc.rimbaexium.org/storage/documents/tralalero(21).png	image/png	83.62 kB	2025-11-02 06:57:05.655212	2025-10-31 22:18:26.3212	2025-10-31 22:18:26.3212
23	1	1	4471ad8b-1394-4f28-b409-f15050d78915	tralalero(22).png	storage/documents/tralalero(22).png	https://doc.rimbaexium.org/storage/documents/tralalero(22).png	image/png	83.62 kB	2025-11-02 06:57:05.655212	2025-10-31 22:18:26.322848	2025-10-31 22:18:26.322848
74	1	1	826374f3-ca66-4fe0-ba45-40f27ed5525f	logo-ipsum-1(2).png	storage/documents/logo-ipsum-1(2).png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-1(2).png	image/png	4.37 kB	2025-11-18 18:47:17.805865	2025-11-02 06:56:32.870428	2025-11-02 06:56:32.870428
75	1	1	6666aa89-5fe5-465c-9b79-3a16fc6e4d25	logo-ipsum-2(2).png	storage/documents/logo-ipsum-2(2).png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-2(2).png	image/png	2.37 kB	2025-11-18 18:47:17.805865	2025-11-02 06:57:24.43335	2025-11-02 06:57:24.43335
76	1	1	58eef7c6-3d7c-4a1b-a257-90ce952241d0	logo-ipsum-3(2).png	storage/documents/logo-ipsum-3(2).png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-3(2).png	image/png	3.25 kB	2025-11-18 18:47:17.805865	2025-11-02 06:57:41.893745	2025-11-02 06:57:41.893745
56	1	1	9018ce21-78cd-4be0-8a32-6a775e608a37	WhatsApp Image 2025-10-12 at 21.46.00_e13983ed(1).jpg	storage/documents/WhatsApp Image 2025-10-12 at 21.46.00_e13983ed(1).jpg	https://doc.rimbaexium.org/storage/documents/WhatsApp%20Image%202025-10-12%20at%2021.46.00_e13983ed(1).jpg	image/jpeg	26.46 kB	2025-11-02 14:42:48.611122	2025-11-01 09:36:11.767331	2025-11-01 09:36:11.767331
94	1	1	9e592986-503d-46ea-a0a1-b0b30e7e1375	pdf-sample_0.pdf	storage/documents/pdf-sample_0.pdf	https://doc.rimbaexium.org/storage/documents/pdf-sample_0.pdf	application/pdf	12.95 kB	\N	2025-11-03 01:57:09.518329	2025-11-03 01:57:09.518329
93	1	1	22625324-a3f3-4adb-bc40-a1625ce39456	file-sample_150kB.pdf	storage/documents/file-sample_150kB.pdf	https://doc.rimbaexium.org/storage/documents/file-sample_150kB.pdf	application/pdf	139.44 kB	2025-11-03 16:36:48.315613	2025-11-02 14:53:09.637901	2025-11-02 14:53:09.637901
98	1	1	78d01a75-e028-49c5-a74a-62c57843223d	tralalero(11).png	storage/documents/tralalero(11).png	https://doc.rimbaexium.org/storage/documents/tralalero(11).png	image/png	83.62 kB	2025-11-03 23:06:42.966337	2025-11-03 22:49:46.363315	2025-11-03 22:49:46.363315
99	41	1	61004eab-e8b1-474d-b455-2dac1efd0910	PDFKosongan.pdf	storage/documents/PDFKosongan.pdf	https://doc.rimbaexium.org/storage/documents/PDFKosongan.pdf	application/pdf	24.93 kB	2025-11-03 23:27:56.556911	2025-11-03 23:06:43.067756	2025-11-03 23:06:43.067756
97	39	1	8a2f8a72-7c5f-4aa6-b2a0-6042f7f548d1	Diskusi Pakar R1.pdf	storage/documents/Diskusi Pakar R1.pdf	https://doc.rimbaexium.org/storage/documents/Diskusi%20Pakar%20R1.pdf	application/pdf	2.56 mB	2025-11-04 00:13:17.170713	2025-11-03 08:02:06.332413	2025-11-03 08:02:06.332413
103	36	1	5b58e216-0073-406a-8586-23619e298c5f	waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer.jpg	storage/documents/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer.jpg	https://doc.rimbaexium.org/storage/documents/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer.jpg	image/jpeg	219.73 kB	\N	2025-11-04 01:20:36.51132	2025-11-04 01:20:36.51132
101	1	1	ea7da61a-3109-4435-9275-cf9753a0dbd1	galeri-2 (1).jpg	storage/documents/galeri-2 (1).jpg	https://doc.rimbaexium.org/storage/documents/galeri-2%20(1).jpg	image/jpeg	1.83 mB	2025-12-19 14:57:41.819551	2025-11-03 23:59:41.609319	2025-11-03 23:59:41.609319
100	1	1	a1d499bd-d9e0-4d70-9b70-18fbc499b9d5	kopi-2.jpg	storage/documents/kopi-2.jpg	https://doc.rimbaexium.org/storage/documents/kopi-2.jpg	image/jpeg	3.64 mB	2025-12-19 15:05:11.377074	2025-11-03 23:57:43.790327	2025-11-03 23:57:43.790327
79	1	1	2222e67f-34e6-4e7f-a3dd-0bc3e87e58ca	Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	image/png	1.59 mB	2025-12-19 15:19:44.423703	2025-11-02 07:07:10.290138	2025-11-02 07:07:10.290138
77	1	1	d072c179-c009-40b2-a351-71336513db94	Gemini_Generated_Image_aq8cqaq8cqaq8cqa.png	storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa.png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa.png	image/png	1.59 mB	2025-12-19 15:20:39.744086	2025-11-02 07:03:10.376271	2025-11-02 07:03:10.376271
78	1	1	332bbc75-713b-436d-a7ce-ee741fab0b9d	Gemini_Generated_Image_aq8cqaq8cqaq8cqa(1).png	storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(1).png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(1).png	image/png	1.59 mB	2025-12-19 15:21:17.37234	2025-11-02 07:05:37.635232	2025-11-02 07:05:37.635232
80	1	1	b30587bd-4d07-4b8a-a3ec-f9030e9d8a86	Gemini_Generated_Image_cogt7kcogt7kcogt.png	storage/documents/Gemini_Generated_Image_cogt7kcogt7kcogt.png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_cogt7kcogt7kcogt.png	image/png	1.34 mB	2025-12-19 15:22:37.67356	2025-11-02 07:10:10.392324	2025-11-02 07:10:10.392324
81	1	1	fa167b1f-74da-4743-aa38-5342049e1d0e	Gemini_Generated_Image_7wxlck7wxlck7wxl.png	storage/documents/Gemini_Generated_Image_7wxlck7wxlck7wxl.png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_7wxlck7wxlck7wxl.png	image/png	1.50 mB	2025-12-19 15:23:02.251872	2025-11-02 07:11:26.861337	2025-11-02 07:11:26.861337
82	1	1	b4a9f5f8-49d8-4a90-95dd-bc71f3ba7fd9	Gemini_Generated_Image_voevcfvoevcfvoev.png	storage/documents/Gemini_Generated_Image_voevcfvoevcfvoev.png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_voevcfvoevcfvoev.png	image/png	2.08 mB	2025-12-19 15:23:26.616716	2025-11-02 07:13:03.192858	2025-11-02 07:13:03.192858
83	1	1	6813ba3f-b168-4657-bad4-3d0401f4aa00	Gemini_Generated_Image_rrb493rrb493rrb4.png	storage/documents/Gemini_Generated_Image_rrb493rrb493rrb4.png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_rrb493rrb493rrb4.png	image/png	2.01 mB	2025-12-19 15:23:43.884028	2025-11-02 07:14:05.47373	2025-11-02 07:14:05.47373
84	1	1	3f5395f6-70ad-42dd-9b0e-425835ad92b3	organizational-structure.png	storage/documents/organizational-structure.png	https://doc.rimbaexium.org/storage/documents/organizational-structure.png	image/png	90.42 kB	2025-12-19 15:24:06.24832	2025-11-02 07:15:28.118515	2025-11-02 07:15:28.118515
96	1	1	b267a887-2ffe-4962-82ab-09c347d7863d	Vwv9JzxbpYnZKZ3fcYl02koPUi4EzfiK9SfwGImp.jpg	storage/documents/Vwv9JzxbpYnZKZ3fcYl02koPUi4EzfiK9SfwGImp.jpg	https://doc.rimbaexium.org/storage/documents/Vwv9JzxbpYnZKZ3fcYl02koPUi4EzfiK9SfwGImp.jpg	image/jpeg	770.71 kB	2025-12-19 16:17:34.963701	2025-11-03 02:06:35.12625	2025-11-03 02:06:35.12625
243	1	1	ce05ff33-4c13-43eb-9e38-8a90c17dd07b	3(3).png	storage/documents/3(3).png	https://rimba.webgis.app/cms/storage/documents/3(3).png	image/png	360.15 kB	\N	2025-12-20 02:29:07.205952	2025-12-20 02:29:07.205952
246	1	1	4c47faf3-4f61-45ea-9f88-49c64e865597	6(2).png	storage/documents/6(2).png	https://rimba.webgis.app/cms/storage/documents/6(2).png	image/png	378.27 kB	\N	2025-12-20 02:30:45.239048	2025-12-20 02:30:45.239048
104	1	1	e566bfb4-2058-4863-9b0a-47c80e484e9c	20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0.png	storage/documents/20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0.png	https://doc.rimbaexium.org/storage/documents/20251023_0645_Demo%20Test%20KMIS_simple_compose_01k874yptzet7806naj67p98s0.png	image/png	1.67 mB	\N	2025-11-04 03:31:54.188342	2025-11-04 03:31:54.188342
105	1	1	c9d40073-1daa-42cb-ab92-49c90aa0b844	20251104_1040_Program Ekosistem RIMBA_simple_compose_01k96f5ypkf7fbwbmq8f2hbakn.png	storage/documents/20251104_1040_Program Ekosistem RIMBA_simple_compose_01k96f5ypkf7fbwbmq8f2hbakn.png	https://doc.rimbaexium.org/storage/documents/20251104_1040_Program%20Ekosistem%20RIMBA_simple_compose_01k96f5ypkf7fbwbmq8f2hbakn.png	image/png	1.73 mB	\N	2025-11-04 03:43:55.554159	2025-11-04 03:43:55.554159
106	1	1	24aa5c61-c233-4ccf-aeae-5b6f983e1fa6	Bahan Paparan Project Rimba KSN 1_3 April 2024_removed(1).pdf	storage/documents/Bahan Paparan Project Rimba KSN 1_3 April 2024_removed(1).pdf	https://doc.rimbaexium.org/storage/documents/Bahan%20Paparan%20Project%20Rimba%20KSN%201_3%20April%202024_removed(1).pdf	application/pdf	2.43 mB	\N	2025-11-04 03:46:36.126344	2025-11-04 03:46:36.126344
102	1	1	33802d53-da7f-4e52-abce-a01038126151	8-RIMBAWeb.jpg	storage/documents/8-RIMBAWeb.jpg	https://doc.rimbaexium.org/storage/documents/8-RIMBAWeb.jpg	image/jpeg	628.14 kB	2025-11-20 04:37:50.80625	2025-11-04 00:00:49.344013	2025-11-04 00:00:49.344013
92	1	1	9ecfab78-7cd4-4889-9139-de4ec5dff88d	Screenshot 2025-10-23 085316.png	storage/documents/Screenshot 2025-10-23 085316.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20085316.png	image/png	409.36 kB	2025-11-26 16:07:37.903178	2025-11-02 13:35:25.504324	2025-11-02 13:35:25.504324
107	41	1	8d84ffe8-aacb-4888-a60a-53963cb2625c	bimbim_patapim.jpg	storage/documents/bimbim_patapim.jpg	https://doc.rimbaexium.org/storage/documents/bimbim_patapim.jpg	image/jpeg	134.00 kB	2025-11-04 06:42:19.573309	2025-11-04 05:59:34.089329	2025-11-04 05:59:34.089329
108	36	1	4bf2ffb3-c955-4122-a5b1-8c4306204f7f	certificate-2.pdf	storage/documents/certificate-2.pdf	https://doc.rimbaexium.org/storage/documents/certificate-2.pdf	application/pdf	15.19 kB	\N	2025-11-04 07:42:37.062477	2025-11-04 07:42:37.062477
111	41	1	7b87e887-cd54-4819-a0d9-9c84fc82e253	PDFKosongan(2).pdf	storage/documents/PDFKosongan(2).pdf	https://doc.rimbaexium.org/storage/documents/PDFKosongan(2).pdf	application/pdf	24.93 kB	2025-11-05 02:37:56.53767	2025-11-04 22:26:47.429451	2025-11-04 22:26:47.429451
112	1	1	0ac9477e-1cee-4ed4-832a-5323dceddf63	2025 02 12 Bahan Rapat Pembahasan Kecukupan Luas Kawasan Hutan dan Penutupan Hutan dalam Revisi RTRWN Pangan.pdf	storage/documents/2025 02 12 Bahan Rapat Pembahasan Kecukupan Luas Kawasan Hutan dan Penutupan Hutan dalam Revisi RTRWN Pangan.pdf	https://doc.rimbaexium.org/storage/documents/2025%2002%2012%20Bahan%20Rapat%20Pembahasan%20Kecukupan%20Luas%20Kawasan%20Hutan%20dan%20Penutupan%20Hutan%20dalam%20Revisi%20RTRWN%20Pangan.pdf	application/pdf	679.77 kB	\N	2025-11-05 02:58:49.919326	2025-11-05 02:58:49.919326
109	1	1	21c8ec8a-8373-4d70-94fc-9816675a6b4e	PDFKosongan.pdf	storage/documents/PDFKosongan.pdf	https://doc.rimbaexium.org/storage/documents/PDFKosongan.pdf	application/pdf	24.93 kB	2025-11-05 04:26:22.746879	2025-11-04 13:25:59.460433	2025-11-04 13:25:59.460433
114	1	1	49b096c9-98fd-4fbb-acb4-098f841f5af6	dummy-pdf_2.pdf	storage/documents/dummy-pdf_2.pdf	https://doc.rimbaexium.org/storage/documents/dummy-pdf_2.pdf	application/pdf	7.30 kB	2025-11-05 04:26:22.746879	2025-11-05 04:23:25.782703	2025-11-05 04:23:25.782703
116	1	1	e5d748ec-c057-4643-bc67-726476ba4379	svgtopng.zip	storage/documents/svgtopng.zip	https://doc.rimbaexium.org/storage/documents/svgtopng.zip	application/x-zip-compressed	22.00 b	2025-11-05 04:41:12.542281	2025-11-05 04:40:49.522388	2025-11-05 04:40:49.522388
117	1	1	d1f7600b-f259-42ec-a6f7-6503f0d657c6	compressed-images.zip	storage/documents/compressed-images.zip	https://doc.rimbaexium.org/storage/documents/compressed-images.zip	application/x-zip-compressed	22.00 b	2025-11-05 04:42:22.062046	2025-11-05 04:41:12.608083	2025-11-05 04:41:12.608083
113	41	1	4aad77e9-8a46-4558-8df6-559e45598371	PDFKosongan(2).pdf	storage/documents/PDFKosongan(2).pdf	https://doc.rimbaexium.org/storage/documents/PDFKosongan(2).pdf	application/pdf	24.93 kB	2025-11-05 22:53:59.693598	2025-11-05 03:17:07.605149	2025-11-05 03:17:07.605149
118	1	1	25efef7a-cee0-4a5a-b5a8-f4cd0d893854	Informasi paket kegiatan.zip	storage/documents/Informasi paket kegiatan.zip	https://doc.rimbaexium.org/storage/documents/Informasi%20paket%20kegiatan.zip	application/x-zip-compressed	2.53 kB	2025-11-05 22:53:59.693598	2025-11-05 04:42:22.133645	2025-11-05 04:42:22.133645
119	3	1	51f41a9e-86d4-4e37-888a-6907886f6285	Gemini_Generated_Image_peklwepeklwepekl.png	storage/documents/Gemini_Generated_Image_peklwepeklwepekl.png	https://doc.rimbaexium.org/storage/documents/Gemini_Generated_Image_peklwepeklwepekl.png	image/png	1.04 mB	\N	2025-11-13 02:17:30.942318	2025-11-13 02:17:30.942318
68	1	1	34c8c732-aa8a-4800-9852-32535bb103d7	logo-ipsum-1.png	storage/documents/logo-ipsum-1.png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-1.png	image/png	4.37 kB	2025-11-18 18:46:16.708426	2025-11-02 06:53:45.071138	2025-11-02 06:53:45.071138
69	1	1	2ea371b3-16a4-4d58-b747-1b383a59c6f2	logo-ipsum-3.png	storage/documents/logo-ipsum-3.png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-3.png	image/png	3.25 kB	2025-11-18 18:46:16.708426	2025-11-02 06:54:47.722919	2025-11-02 06:54:47.722919
70	1	1	02181ba3-0510-4682-aae5-467480a8cf6b	logo-ipsum-2.png	storage/documents/logo-ipsum-2.png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-2.png	image/png	2.37 kB	2025-11-18 18:46:16.708426	2025-11-02 06:54:54.845485	2025-11-02 06:54:54.845485
71	1	1	40a45d97-1a59-4a41-a5a0-aeb630e4326e	logo-ipsum-1(1).png	storage/documents/logo-ipsum-1(1).png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-1(1).png	image/png	4.37 kB	2025-11-18 18:46:16.708426	2025-11-02 06:55:34.324708	2025-11-02 06:55:34.324708
72	1	1	8922d8e1-27bb-4aee-9a0c-c6391f7ec471	logo-ipsum-2(1).png	storage/documents/logo-ipsum-2(1).png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-2(1).png	image/png	2.37 kB	2025-11-18 18:46:16.708426	2025-11-02 06:55:41.522818	2025-11-02 06:55:41.522818
73	1	1	84726d7e-9a6b-477f-b3f1-c452f68c361a	logo-ipsum-3(1).png	storage/documents/logo-ipsum-3(1).png	https://doc.rimbaexium.org/storage/documents/logo-ipsum-3(1).png	image/png	3.25 kB	2025-11-18 18:46:16.708426	2025-11-02 06:55:48.142326	2025-11-02 06:55:48.142326
121	1	1	a5e6fc22-a5c6-44cd-99b7-f7bb7b7c167f	1.png	storage/documents/1.png	https://doc.rimbaexium.org/storage/documents/1.png	image/png	106.88 kB	2025-12-19 15:15:58.019179	2025-11-18 18:46:17.188326	2025-11-18 18:46:17.188326
134	42	1	a32c09ed-3533-4afd-9abb-c9fbb918da9e	Final-12082025- Program_Induksi_Kegiatan_2025.pptx_compressed (1).pdf	storage/documents/Final-12082025- Program_Induksi_Kegiatan_2025.pptx_compressed (1).pdf	https://doc.rimbaexium.org/storage/documents/Final-12082025-%20Program_Induksi_Kegiatan_2025.pptx_compressed%20(1).pdf	application/pdf	4.69 mB	\N	2025-11-19 06:27:17.828359	2025-11-19 06:27:17.828359
135	42	1	8740e269-8b2c-49ad-a104-4f83a2523fdf	EXSUM BARU FINAL-09122024.pdf	storage/documents/EXSUM BARU FINAL-09122024.pdf	https://doc.rimbaexium.org/storage/documents/EXSUM%20BARU%20FINAL-09122024.pdf	application/pdf	3.96 mB	\N	2025-11-19 06:29:19.223152	2025-11-19 06:29:19.223152
136	42	1	6b808251-2f97-492f-a845-4cb5d74dc371	EXSUM Roadmap Ekonomi Hijau RIMBA.pdf	storage/documents/EXSUM Roadmap Ekonomi Hijau RIMBA.pdf	https://doc.rimbaexium.org/storage/documents/EXSUM%20Roadmap%20Ekonomi%20Hijau%20RIMBA.pdf	application/pdf	4.06 mB	\N	2025-11-20 02:03:20.385543	2025-11-20 02:03:20.385543
137	42	1	99bdcf1b-64f3-4399-af85-df5c0388a90f	EKSUM RTR KSN BUKIT BATABUH.pdf	storage/documents/EKSUM RTR KSN BUKIT BATABUH.pdf	https://doc.rimbaexium.org/storage/documents/EKSUM%20RTR%20KSN%20BUKIT%20BATABUH.pdf	application/pdf	21.59 mB	\N	2025-11-20 02:12:37.344359	2025-11-20 02:12:37.344359
138	1	1	4e5517de-7b86-4797-9b45-fc5bd391faed	dummy-pdf.pdf	storage/documents/dummy-pdf.pdf	https://doc.rimbaexium.org/storage/documents/dummy-pdf.pdf	application/pdf	1017.73 kB	\N	2025-11-20 03:34:55.203555	2025-11-20 03:34:55.203555
115	1	1	4a53cd55-f6ab-493d-8668-1980546d6109	dummy-pdf_2(1).pdf	storage/documents/dummy-pdf_2(1).pdf	https://doc.rimbaexium.org/storage/documents/dummy-pdf_2(1).pdf	application/pdf	7.30 kB	2025-11-20 03:34:55.224622	2025-11-05 04:26:22.726786	2025-11-05 04:26:22.726786
139	1	1	db65bfe8-6a69-4c0e-ae5b-a5103338c8fe	dummy-pdf(1).pdf	storage/documents/dummy-pdf(1).pdf	https://doc.rimbaexium.org/storage/documents/dummy-pdf(1).pdf	application/pdf	1017.73 kB	\N	2025-11-20 03:35:14.471678	2025-11-20 03:35:14.471678
110	1	1	d08a375b-d508-48e9-835d-a8ea781ccacf	PDFKosongan(1).pdf	storage/documents/PDFKosongan(1).pdf	https://doc.rimbaexium.org/storage/documents/PDFKosongan(1).pdf	application/pdf	24.93 kB	2025-11-20 03:35:14.489804	2025-11-04 13:25:59.512322	2025-11-04 13:25:59.512322
140	1	1	605b3ce7-1113-41dd-bfac-16649a3724a1	eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	https://doc.rimbaexium.org/storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	image/jpeg	463.83 kB	2025-11-20 04:39:11.127974	2025-11-20 04:37:51.025321	2025-11-20 04:37:51.025321
141	1	1	203d2598-2acd-4a5f-9ae2-ba8f88810405	hartono-subagio-GxUT5xSrV9Q-unsplash.jpg	storage/documents/hartono-subagio-GxUT5xSrV9Q-unsplash.jpg	https://doc.rimbaexium.org/storage/documents/hartono-subagio-GxUT5xSrV9Q-unsplash.jpg	image/jpeg	395.67 kB	2025-11-20 04:39:21.883068	2025-11-20 04:39:11.187324	2025-11-20 04:39:11.187324
143	42	1	0c0e5613-8ae1-4885-860f-fc25a83cb797	Final-12082025- Program_Induksi_Kegiatan_2025.pptx_compressed.pdf	storage/documents/Final-12082025- Program_Induksi_Kegiatan_2025.pptx_compressed.pdf	https://doc.rimbaexium.org/storage/documents/Final-12082025-%20Program_Induksi_Kegiatan_2025.pptx_compressed.pdf	application/pdf	4.69 mB	\N	2025-11-20 08:07:31.370318	2025-11-20 08:07:31.370318
144	42	1	a87c2497-c5aa-48ef-9db9-42539848b51d	03 LAPORAN AKHIR - KAJIAN PENINJAUAN KEMBALI DELINIASI DI KORIDOR RIMBA.pdf	storage/documents/03 LAPORAN AKHIR - KAJIAN PENINJAUAN KEMBALI DELINIASI DI KORIDOR RIMBA.pdf	https://doc.rimbaexium.org/storage/documents/03%20LAPORAN%20AKHIR%20-%20KAJIAN%20PENINJAUAN%20KEMBALI%20DELINIASI%20DI%20KORIDOR%20RIMBA.pdf	application/pdf	21.50 mB	\N	2025-11-20 13:28:43.834181	2025-11-20 13:28:43.834181
145	42	1	45eb4392-db84-4db1-829a-4bfd9f2c8291	Lap_Akhir_Paket_6b_PLUP-Rimba_YHR.pdf	storage/documents/Lap_Akhir_Paket_6b_PLUP-Rimba_YHR.pdf	https://doc.rimbaexium.org/storage/documents/Lap_Akhir_Paket_6b_PLUP-Rimba_YHR.pdf	application/pdf	19.76 mB	\N	2025-11-20 13:34:57.40212	2025-11-20 13:34:57.40212
146	42	1	bca07bb5-8299-430c-8069-3b0a16834b8b	08. Laporan_Akhir.pdf	storage/documents/08. Laporan_Akhir.pdf	https://doc.rimbaexium.org/storage/documents/08.%20Laporan_Akhir.pdf	application/pdf	22.14 mB	\N	2025-11-20 13:39:00.019624	2025-11-20 13:39:00.019624
147	42	1	c7b647b0-387b-42e7-b521-fa4580129c7e	03_LAPORAN AKHIR_KONSORSIUM RIMBA SUMATERA 2024.pdf	storage/documents/03_LAPORAN AKHIR_KONSORSIUM RIMBA SUMATERA 2024.pdf	https://doc.rimbaexium.org/storage/documents/03_LAPORAN%20AKHIR_KONSORSIUM%20RIMBA%20SUMATERA%202024.pdf	application/pdf	17.57 mB	\N	2025-11-20 13:49:16.199166	2025-11-20 13:49:16.199166
148	42	1	aba6d3a1-84f2-41a2-ab25-1657618c8041	Laporan Akhir GE Rimba_14-12_2024_update.pdf	storage/documents/Laporan Akhir GE Rimba_14-12_2024_update.pdf	https://doc.rimbaexium.org/storage/documents/Laporan%20Akhir%20GE%20Rimba_14-12_2024_update.pdf	application/pdf	15.29 mB	\N	2025-11-20 13:53:20.032343	2025-11-20 13:53:20.032343
150	1	1	56ec5a65-c023-4323-87e3-28cdb16a2b60	dummy-pdf(2).pdf	storage/documents/dummy-pdf(2).pdf	https://doc.rimbaexium.org/storage/documents/dummy-pdf(2).pdf	application/pdf	1017.73 kB	\N	2025-11-21 12:07:34.498235	2025-11-21 12:07:34.498235
151	1	1	0258a2e7-43e6-4e5c-a464-dd7251944071	aec89b5fbfcf861805057dd7e0e7d3f7(1).jpg	storage/documents/aec89b5fbfcf861805057dd7e0e7d3f7(1).jpg	https://doc.rimbaexium.org/storage/documents/aec89b5fbfcf861805057dd7e0e7d3f7(1).jpg	image/jpeg	39.52 kB	\N	2025-11-21 12:07:47.049181	2025-11-21 12:07:47.049181
142	1	1	6d2351dc-9eb3-4ca2-ab66-ce66d7eca15a	eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	https://doc.rimbaexium.org/storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	image/jpeg	463.83 kB	2025-12-19 15:03:37.337228	2025-11-20 04:39:21.944526	2025-11-20 04:39:21.944526
126	1	1	45f52dc2-3012-4be9-b3ca-a76ef948aec2	5.png	storage/documents/5.png	https://doc.rimbaexium.org/storage/documents/5.png	image/png	97.54 kB	2025-12-19 15:15:58.019179	2025-11-18 18:46:49.03007	2025-11-18 18:46:49.03007
127	1	1	62072769-3b45-4705-9f53-ab1d04d7b9c6	Univ Andalas.png	storage/documents/Univ Andalas.png	https://doc.rimbaexium.org/storage/documents/Univ%20Andalas.png	image/png	76.03 kB	2025-12-19 15:18:34.473771	2025-11-18 18:47:18.108851	2025-11-18 18:47:18.108851
153	2	1	ccb58a46-481a-4d1b-be79-696ef94c0d18	EXSUM Roadmap Ekonomi Hijau RIMBA Paket 1(1).pdf	storage/documents/EXSUM Roadmap Ekonomi Hijau RIMBA Paket 1(1).pdf	https://doc.rimbaexium.org/storage/documents/EXSUM%20Roadmap%20Ekonomi%20Hijau%20RIMBA%20Paket%201(1).pdf	application/pdf	4.06 mB	\N	2025-11-25 07:39:24.251476	2025-11-25 07:39:24.251476
152	2	1	8233dcce-b5da-4cb8-b331-464bfa3903d8	EXSUM Roadmap Ekonomi Hijau RIMBA Paket 1.pdf	storage/documents/EXSUM Roadmap Ekonomi Hijau RIMBA Paket 1.pdf	https://doc.rimbaexium.org/storage/documents/EXSUM%20Roadmap%20Ekonomi%20Hijau%20RIMBA%20Paket%201.pdf	application/pdf	4.06 mB	2025-11-25 07:39:24.29468	2025-11-25 07:30:38.582176	2025-11-25 07:30:38.582176
154	42	1	b5d2d3fc-1a5c-44cc-a491-4eb60d224996	03_LAPORAN AKHIR_KONSORSIUM RIMBA SUMATERA 2024(1).pdf	storage/documents/03_LAPORAN AKHIR_KONSORSIUM RIMBA SUMATERA 2024(1).pdf	https://doc.rimbaexium.org/storage/documents/03_LAPORAN%20AKHIR_KONSORSIUM%20RIMBA%20SUMATERA%202024(1).pdf	application/pdf	17.57 mB	\N	2025-11-25 07:53:43.86641	2025-11-25 07:53:43.86641
155	42	1	085b7181-52d5-4383-a4fe-b426920c0453	POSTER RTR KSN KAW TN BERBAK DAN BUKIT TIGA PULUH release paket 3.pdf	storage/documents/POSTER RTR KSN KAW TN BERBAK DAN BUKIT TIGA PULUH release paket 3.pdf	https://doc.rimbaexium.org/storage/documents/POSTER%20RTR%20KSN%20KAW%20TN%20BERBAK%20DAN%20BUKIT%20TIGA%20PULUH%20release%20paket%203.pdf	application/pdf	8.84 mB	\N	2025-11-25 08:00:51.666325	2025-11-25 08:00:51.666325
156	42	1	42df8eb9-b8ea-497b-898b-632be0784650	POSTER RTR KSN KAW TN BERBAK DAN BUKIT TIGA PULUH release.pdf	storage/documents/POSTER RTR KSN KAW TN BERBAK DAN BUKIT TIGA PULUH release.pdf	https://doc.rimbaexium.org/storage/documents/POSTER%20RTR%20KSN%20KAW%20TN%20BERBAK%20DAN%20BUKIT%20TIGA%20PULUH%20release.pdf	application/pdf	8.84 mB	\N	2025-11-26 07:16:20.067475	2025-11-26 07:16:20.067475
157	42	1	8a6eb1ac-7d49-433c-b99b-c5b2552af94b	3_WRI_Laporan Akhir Kajian Solusi Berbasis Alam.pdf	storage/documents/3_WRI_Laporan Akhir Kajian Solusi Berbasis Alam.pdf	https://doc.rimbaexium.org/storage/documents/3_WRI_Laporan%20Akhir%20Kajian%20Solusi%20Berbasis%20Alam.pdf	application/pdf	4.42 mB	\N	2025-11-26 07:28:27.843237	2025-11-26 07:28:27.843237
158	42	1	f83c27a8-05eb-4377-9d9f-3f9341bf8002	Laporan Akhir_RIMBA_December_2024.pdf	storage/documents/Laporan Akhir_RIMBA_December_2024.pdf	https://doc.rimbaexium.org/storage/documents/Laporan%20Akhir_RIMBA_December_2024.pdf	application/pdf	45.05 mB	\N	2025-11-26 07:31:48.276167	2025-11-26 07:31:48.276167
159	42	1	2c06f3c6-a8a8-4c24-bbd7-6530bb724359	05 Album Peta.pdf	storage/documents/05 Album Peta.pdf	https://doc.rimbaexium.org/storage/documents/05%20Album%20Peta.pdf	application/pdf	26.70 mB	\N	2025-11-26 07:34:48.695164	2025-11-26 07:34:48.695164
160	42	1	623bb24f-7a6c-4ce2-ad19-5720200f4b9d	Peninjauan RPHJP UPT KPH Singingi Beserta Kawasan Penyangga_Paket 6A (1).pdf	storage/documents/Peninjauan RPHJP UPT KPH Singingi Beserta Kawasan Penyangga_Paket 6A (1).pdf	https://doc.rimbaexium.org/storage/documents/Peninjauan%20RPHJP%20UPT%20KPH%20Singingi%20Beserta%20Kawasan%20Penyangga_Paket%206A%20(1).pdf	application/pdf	1.52 mB	\N	2025-11-26 07:35:49.85876	2025-11-26 07:35:49.85876
161	42	1	9502df3e-7381-43bc-918e-723c1e582c9a	Rekomendasi Revisi RPHJP UPT KPH Singingi_Paket 6A.pdf	storage/documents/Rekomendasi Revisi RPHJP UPT KPH Singingi_Paket 6A.pdf	https://doc.rimbaexium.org/storage/documents/Rekomendasi%20Revisi%20RPHJP%20UPT%20KPH%20Singingi_Paket%206A.pdf	application/pdf	1.17 mB	\N	2025-11-26 07:38:14.376631	2025-11-26 07:38:14.376631
162	42	1	eff999cc-0b31-48f7-9c93-47e4261bd75d	Executive Summary_Paket 6A.pdf	storage/documents/Executive Summary_Paket 6A.pdf	https://doc.rimbaexium.org/storage/documents/Executive%20Summary_Paket%206A.pdf	application/pdf	498.52 kB	\N	2025-11-26 07:41:06.736419	2025-11-26 07:41:06.736419
163	42	1	afc1d775-d370-46d5-953f-d8cc809f878d	Album peta Rimba Paket 8.pdf	storage/documents/Album peta Rimba Paket 8.pdf	https://doc.rimbaexium.org/storage/documents/Album%20peta%20Rimba%20Paket%208.pdf	application/pdf	26.27 mB	\N	2025-11-26 07:51:02.91425	2025-11-26 07:51:02.91425
164	42	1	40341575-5a68-43e0-b21b-45e6e51ac62a	LAPORAN OUTPUT 1 FASILITASI PLUP_KONSORSIUM RIMBA SUMATERA.pdf	storage/documents/LAPORAN OUTPUT 1 FASILITASI PLUP_KONSORSIUM RIMBA SUMATERA.pdf	https://doc.rimbaexium.org/storage/documents/LAPORAN%20OUTPUT%201%20FASILITASI%20PLUP_KONSORSIUM%20RIMBA%20SUMATERA.pdf	application/pdf	13.64 mB	\N	2025-11-26 07:53:44.247521	2025-11-26 07:53:44.247521
165	42	1	92ad0c8c-fe2d-4ce0-9973-c76e39f7d49c	LAPORAN OUTPUT 2 PENGUATAN MPA_KONSORSIUM RIMBA SUMATERA.pdf	storage/documents/LAPORAN OUTPUT 2 PENGUATAN MPA_KONSORSIUM RIMBA SUMATERA.pdf	https://doc.rimbaexium.org/storage/documents/LAPORAN%20OUTPUT%202%20PENGUATAN%20MPA_KONSORSIUM%20RIMBA%20SUMATERA.pdf	application/pdf	12.09 mB	\N	2025-11-26 07:55:25.690241	2025-11-26 07:55:25.690241
166	42	1	1dbce621-0390-448e-9609-cdceb341a2c6	1 Dokumen rencana tata guna lahan di 6 Desa.pdf	storage/documents/1 Dokumen rencana tata guna lahan di 6 Desa.pdf	https://doc.rimbaexium.org/storage/documents/1%20Dokumen%20rencana%20tata%20guna%20lahan%20di%206%20Desa.pdf	application/pdf	27.12 mB	\N	2025-11-26 07:58:01.096704	2025-11-26 07:58:01.096704
167	42	1	3cf07dcb-48c4-43d8-aabd-531ad2937af8	1.Poster KRIS _ PLUP & MPA.pdf	storage/documents/1.Poster KRIS _ PLUP & MPA.pdf	https://doc.rimbaexium.org/storage/documents/1.Poster%20KRIS%20_%20PLUP%20%26%20MPA.pdf	application/pdf	3.54 mB	\N	2025-11-26 08:01:55.776892	2025-11-26 08:01:55.776892
168	42	1	895b8df8-3eb2-4b01-8989-d0ba2ae5a738	PETA POLARUANG CLUSTER II.png	storage/documents/PETA POLARUANG CLUSTER II.png	https://doc.rimbaexium.org/storage/documents/PETA%20POLARUANG%20CLUSTER%20II.png	image/png	2.29 mB	\N	2025-11-26 08:04:53.378329	2025-11-26 08:04:53.378329
169	42	1	6d3bb884-6d55-4162-b0b5-e15c2b1a2bd4	Paket 12.pdf	storage/documents/Paket 12.pdf	https://doc.rimbaexium.org/storage/documents/Paket%2012.pdf	application/pdf	6.95 mB	\N	2025-11-26 08:08:14.068668	2025-11-26 08:08:14.068668
170	42	1	12baea40-5171-4747-8956-65b944095d4a	factsheet burung-page1.pdf	storage/documents/factsheet burung-page1.pdf	https://doc.rimbaexium.org/storage/documents/factsheet%20burung-page1.pdf	application/pdf	109.98 kB	\N	2025-11-26 08:12:48.044065	2025-11-26 08:12:48.044065
171	42	1	646e3891-b15a-4b36-b059-acb4d6d65303	Factsheet Gajah.pdf	storage/documents/Factsheet Gajah.pdf	https://doc.rimbaexium.org/storage/documents/Factsheet%20Gajah.pdf	application/pdf	38.28 mB	\N	2025-11-26 08:22:34.006174	2025-11-26 08:22:34.006174
172	42	1	9078af29-80b5-4863-b4e6-b9a764233788	Factsheet Harimau.pdf	storage/documents/Factsheet Harimau.pdf	https://doc.rimbaexium.org/storage/documents/Factsheet%20Harimau.pdf	application/pdf	2.25 mB	\N	2025-11-26 08:26:53.462986	2025-11-26 08:26:53.462986
173	1	1	6b70e5d0-bfa1-47d3-85c4-8ac69e08e11f	1(1).png	storage/documents/1(1).png	https://doc.rimbaexium.org/storage/documents/1(1).png	image/png	946.43 kB	\N	2025-11-26 16:07:38.221121	2025-11-26 16:07:38.221121
91	1	1	bc4d1841-33cb-4606-9abb-65a4806da892	Screenshot 2025-10-23 085144.png	storage/documents/Screenshot 2025-10-23 085144.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20085144.png	image/png	468.44 kB	2025-11-26 16:08:01.814033	2025-11-02 13:34:30.295347	2025-11-02 13:34:30.295347
174	1	1	3e98aadc-7908-4656-b72d-726adbb4915d	3(1).png	storage/documents/3(1).png	https://doc.rimbaexium.org/storage/documents/3(1).png	image/png	1.12 mB	\N	2025-11-26 16:08:01.951182	2025-11-26 16:08:01.951182
90	1	1	de12eda5-9762-4885-9e36-762042df41a0	Screenshot 2025-10-23 084915.png	storage/documents/Screenshot 2025-10-23 084915.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20084915.png	image/png	614.26 kB	2025-11-26 16:08:24.865009	2025-11-02 13:28:55.979657	2025-11-02 13:28:55.979657
175	1	1	2510c155-9e97-48f9-8d06-76e01ab04ad9	2(1).png	storage/documents/2(1).png	https://doc.rimbaexium.org/storage/documents/2(1).png	image/png	2.37 mB	\N	2025-11-26 16:08:25.135677	2025-11-26 16:08:25.135677
89	1	1	ea65d6c8-668a-439b-a62a-6660c3d737ed	Screenshot 2025-10-23 084617.png	storage/documents/Screenshot 2025-10-23 084617.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20084617.png	image/png	730.38 kB	2025-11-26 16:08:50.835871	2025-11-02 13:28:00.820347	2025-11-02 13:28:00.820347
176	1	1	2d700ec4-70b8-4fb5-9617-65c143ef6a29	5(1).png	storage/documents/5(1).png	https://doc.rimbaexium.org/storage/documents/5(1).png	image/png	2.98 mB	\N	2025-11-26 16:08:50.970632	2025-11-26 16:08:50.970632
87	1	1	46c6fb4a-fe64-4637-ba73-f33b35f89b42	Screenshot 2025-10-23 082544.png	storage/documents/Screenshot 2025-10-23 082544.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20082544.png	image/png	628.08 kB	2025-11-26 16:09:31.207604	2025-11-02 13:25:19.206574	2025-11-02 13:25:19.206574
177	1	1	7b1a34be-1127-42e2-b0a8-7094b3d6db7f	12.png	storage/documents/12.png	https://doc.rimbaexium.org/storage/documents/12.png	image/png	2.45 mB	\N	2025-11-26 16:09:31.281539	2025-11-26 16:09:31.281539
86	1	1	8de2a77d-4f2b-4930-b69a-4cf04946d622	Screenshot 2025-10-23 084104.png	storage/documents/Screenshot 2025-10-23 084104.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20084104.png	image/png	637.35 kB	2025-11-26 16:12:17.424351	2025-11-02 13:24:05.867466	2025-11-02 13:24:05.867466
178	1	1	666ccba7-0e8a-4512-b5c7-15524a1f20e2	plub.png	storage/documents/plub.png	https://doc.rimbaexium.org/storage/documents/plub.png	image/png	2.57 mB	\N	2025-11-26 16:12:17.535205	2025-11-26 16:12:17.535205
85	1	1	8502ce3f-33db-4931-be17-f677371b23d9	Screenshot 2025-10-23 083932.png	storage/documents/Screenshot 2025-10-23 083932.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20083932.png	image/png	674.85 kB	2025-11-26 16:13:00.729289	2025-11-02 13:22:08.707344	2025-11-02 13:22:08.707344
179	1	1	500c4213-ccfc-4821-b0ae-7656dc42932c	7(1).png	storage/documents/7(1).png	https://doc.rimbaexium.org/storage/documents/7(1).png	image/png	3.05 mB	\N	2025-11-26 16:13:00.861189	2025-11-26 16:13:00.861189
180	1	1	6975478e-5116-43d1-862a-4d262b45ed28	9(1).png	storage/documents/9(1).png	https://doc.rimbaexium.org/storage/documents/9(1).png	image/png	2.61 mB	\N	2025-11-26 16:13:27.775364	2025-11-26 16:13:27.775364
181	1	1	9daeadb2-4982-48c1-a93a-80d1b438651c	8(1).png	storage/documents/8(1).png	https://doc.rimbaexium.org/storage/documents/8(1).png	image/png	2.14 mB	\N	2025-11-26 16:13:47.059174	2025-11-26 16:13:47.059174
60	1	1	aa375bd9-b3b7-41e9-a09d-026a4325b8bd	Screenshot 2025-10-23 083146.png	storage/documents/Screenshot 2025-10-23 083146.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20083146.png	image/png	813.99 kB	2025-11-26 16:14:13.293605	2025-11-02 03:01:16.239834	2025-11-02 03:01:16.239834
182	1	1	dd140725-9b15-468e-a18a-86cf0d12e09d	10(1).png	storage/documents/10(1).png	https://doc.rimbaexium.org/storage/documents/10(1).png	image/png	3.67 mB	\N	2025-11-26 16:14:13.476184	2025-11-26 16:14:13.476184
59	1	1	c475eb7a-e310-4036-b780-e89de48ca39d	Screenshot 2025-10-23 082933.png	storage/documents/Screenshot 2025-10-23 082933.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20082933.png	image/png	713.91 kB	2025-11-26 16:15:08.785363	2025-11-02 02:59:54.55932	2025-11-02 02:59:54.55932
183	1	1	875671cd-86a5-4d02-a97f-99d5bc5b81b6	11.png	storage/documents/11.png	https://doc.rimbaexium.org/storage/documents/11.png	image/png	3.13 mB	\N	2025-11-26 16:15:08.883177	2025-11-26 16:15:08.883177
88	1	1	976bf112-727d-420c-aab9-ca78adffbed0	Screenshot 2025-10-23 084338.png	storage/documents/Screenshot 2025-10-23 084338.png	https://doc.rimbaexium.org/storage/documents/Screenshot%202025-10-23%20084338.png	image/png	643.38 kB	2025-11-27 03:27:43.373074	2025-11-02 13:26:39.711317	2025-11-02 13:26:39.711317
184	1	1	6c4b6689-a9c5-4f48-a1eb-acbdbeba4584	klebakara.png	storage/documents/klebakara.png	https://doc.rimbaexium.org/storage/documents/klebakara.png	image/png	423.34 kB	\N	2025-11-27 03:27:43.625759	2025-11-27 03:27:43.625759
133	1	1	f69a80a3-bb72-4dcd-a22f-38e47059d6c7	Materi induksi thumbnail.png	storage/documents/Materi induksi thumbnail.png	https://doc.rimbaexium.org/storage/documents/Materi%20induksi%20thumbnail.png	image/png	1.86 mB	2025-11-27 03:37:46.055746	2025-11-18 20:05:10.99674	2025-11-18 20:05:10.99674
185	1	1	bec52cf5-ebab-4e90-9ac0-6a2113e4faae	induksi.png	storage/documents/induksi.png	https://doc.rimbaexium.org/storage/documents/induksi.png	image/png	648.54 kB	\N	2025-11-27 03:37:47.88099	2025-11-27 03:37:47.88099
186	1	1	1a953fb7-71c9-43ad-94cc-9a08df739402	portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup (2).jpg	storage/documents/portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup (2).jpg	https://doc.rimbaexium.org/storage/documents/portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup%20(2).jpg	image/jpeg	1.73 mB	2025-12-15 03:44:01.531555	2025-12-15 03:34:02.094969	2025-12-15 03:34:02.094969
190	1	1	fdd263c0-d48d-4f2c-acec-45f6337e4dc7	1 (1).jpg	storage/documents/1 (1).jpg	https://rimba.webgis.app/cms/storage/documents/1%20(1).jpg	image/jpeg	784.24 kB	\N	2025-12-19 14:56:38.497042	2025-12-19 14:56:38.497042
95	1	1	532ddce1-b1f2-490b-b642-a97d6fd1e873	file-sample_150kB(1).pdf	storage/documents/file-sample_150kB(1).pdf	https://doc.rimbaexium.org/storage/documents/file-sample_150kB(1).pdf	application/pdf	139.44 kB	2025-12-19 14:45:24.428564	2025-11-03 01:58:07.636354	2025-11-03 01:58:07.636354
189	1	1	10c2efef-d6a8-49db-9a08-fb50209cd4ca	hero-bg (1).jpg	storage/documents/hero-bg (1).jpg	https://rimba.webgis.app/cms/storage/documents/hero-bg%20(1).jpg	image/jpeg	1.19 mB	2026-01-14 10:19:52.94155	2025-12-19 14:53:19.846369	2025-12-19 14:53:19.846369
191	1	1	43aea082-6d39-49fc-8ca0-b7e3c4ab4917	galeri-2 (1) (1).jpg	storage/documents/galeri-2 (1) (1).jpg	https://rimba.webgis.app/cms/storage/documents/galeri-2%20(1)%20(1).jpg	image/jpeg	1.83 mB	\N	2025-12-19 14:57:41.896872	2025-12-19 14:57:41.896872
188	1	1	d7ac2539-e381-4679-96f4-1f2f72268d9c	Peraturan Presiden No 13 Tahun 2012.pdf	storage/documents/Peraturan Presiden No 13 Tahun 2012.pdf	https://rimba.webgis.app/cms/storage/documents/Peraturan%20Presiden%20No%2013%20Tahun%202012.pdf	application/pdf	1.02 mB	\N	2025-12-19 14:45:25.036155	2025-12-19 14:45:25.036155
238	1	1	94ed36e7-47c0-4068-a28d-0c244a65222c	Perpres Nomor 98 Tahun 2021.pdf	storage/documents/Perpres Nomor 98 Tahun 2021.pdf	https://rimba.webgis.app/cms/storage/documents/Perpres%20Nomor%2098%20Tahun%202021.pdf	application/pdf	3.64 mB	\N	2025-12-20 02:03:14.016804	2025-12-20 02:03:14.016804
240	1	1	662070ec-dc77-45ac-9ef1-e70c99044b43	IBSAP-2025-2045.pdf	storage/documents/IBSAP-2025-2045.pdf	https://rimba.webgis.app/cms/storage/documents/IBSAP-2025-2045.pdf	application/pdf	1.28 mB	\N	2025-12-20 02:08:02.557748	2025-12-20 02:08:02.557748
195	1	1	f1b4da36-359f-478a-8987-22f123cc6509	eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	https://rimba.webgis.app/cms/storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	image/jpeg	463.83 kB	2025-12-20 01:33:42.821509	2025-12-19 15:03:37.404486	2025-12-19 15:03:37.404486
192	1	1	10c9e2b2-0240-4bb8-90b3-c7019274e942	4 (1).jpg	storage/documents/4 (1).jpg	https://rimba.webgis.app/cms/storage/documents/4%20(1).jpg	image/jpeg	930.27 kB	\N	2025-12-19 15:01:20.032084	2025-12-19 15:01:20.032084
193	1	1	56b83759-f560-4493-96f3-fe262b28f129	5 (1).jpg	storage/documents/5 (1).jpg	https://rimba.webgis.app/cms/storage/documents/5%20(1).jpg	image/jpeg	794.74 kB	\N	2025-12-19 15:02:26.782249	2025-12-19 15:02:26.782249
194	1	1	d771168e-3f3a-4bc5-8707-7b3525578ce4	6 (1).jpg	storage/documents/6 (1).jpg	https://rimba.webgis.app/cms/storage/documents/6%20(1).jpg	image/jpeg	412.19 kB	\N	2025-12-19 15:02:53.241206	2025-12-19 15:02:53.241206
196	1	1	6e739aa9-3ba7-49bf-9c7c-336ad1d73bbf	8 (1).jpg	storage/documents/8 (1).jpg	https://rimba.webgis.app/cms/storage/documents/8%20(1).jpg	image/jpeg	480.61 kB	\N	2025-12-19 15:04:10.062929	2025-12-19 15:04:10.062929
120	1	1	d2e27118-89e5-4473-9ed4-ff89cd60ca3e	gambut-2.jpg	storage/documents/gambut-2.jpg	https://doc.rimbaexium.org/storage/documents/gambut-2.jpg	image/jpeg	4.28 mB	2025-12-19 15:04:44.20127	2025-11-17 06:49:27.703324	2025-11-17 06:49:27.703324
197	1	1	3c736e32-ce43-4020-b35a-0ee9bff55b0c	gambut-2 (1).jpg	storage/documents/gambut-2 (1).jpg	https://rimba.webgis.app/cms/storage/documents/gambut-2%20(1).jpg	image/jpeg	4.28 mB	\N	2025-12-19 15:04:44.318595	2025-12-19 15:04:44.318595
198	1	1	eb763675-fdcb-4e0e-8885-c652eee7e481	kopi-2 (1).jpg	storage/documents/kopi-2 (1).jpg	https://rimba.webgis.app/cms/storage/documents/kopi-2%20(1).jpg	image/jpeg	3.64 mB	\N	2025-12-19 15:05:11.479528	2025-12-19 15:05:11.479528
122	1	1	3e4427c2-8d95-4d71-8d13-7e38fc8efc7c	3.png	storage/documents/3.png	https://doc.rimbaexium.org/storage/documents/3.png	image/png	85.00 kB	2025-12-19 15:15:58.019179	2025-11-18 18:46:49.003929	2025-11-18 18:46:49.003929
123	1	1	9b9f9938-d382-45b9-ad22-ead89734be17	UGM.png	storage/documents/UGM.png	https://doc.rimbaexium.org/storage/documents/UGM.png	image/png	83.70 kB	2025-12-19 15:15:58.019179	2025-11-18 18:46:49.01449	2025-11-18 18:46:49.01449
124	1	1	e64fe884-75a4-4f88-a065-d4309c5f1e3c	9.png	storage/documents/9.png	https://doc.rimbaexium.org/storage/documents/9.png	image/png	27.15 kB	2025-12-19 15:15:58.019179	2025-11-18 18:46:49.021053	2025-11-18 18:46:49.021053
125	1	1	0680a597-af58-4a7a-8ffa-ed2f27ef3166	7.png	storage/documents/7.png	https://doc.rimbaexium.org/storage/documents/7.png	image/png	54.17 kB	2025-12-19 15:15:58.019179	2025-11-18 18:46:49.027814	2025-11-18 18:46:49.027814
199	1	1	d8008a2b-1e9f-48f7-917f-9a99acbbefc2	1.png	storage/documents/1.png	https://rimba.webgis.app/cms/storage/documents/1.png	image/png	106.88 kB	\N	2025-12-19 15:15:58.083072	2025-12-19 15:15:58.083072
200	1	1	6aa48e7b-3b3c-4c3b-b7ed-84701d80350f	3.png	storage/documents/3.png	https://rimba.webgis.app/cms/storage/documents/3.png	image/png	85.00 kB	\N	2025-12-19 15:15:58.08535	2025-12-19 15:15:58.08535
201	1	1	c5a9037b-976e-465b-a3e2-d64972ed5d9c	UGM.png	storage/documents/UGM.png	https://rimba.webgis.app/cms/storage/documents/UGM.png	image/png	83.70 kB	\N	2025-12-19 15:15:58.086511	2025-12-19 15:15:58.086511
202	1	1	4ba33168-bea3-4bcc-92f7-10615586604e	9.png	storage/documents/9.png	https://rimba.webgis.app/cms/storage/documents/9.png	image/png	27.15 kB	\N	2025-12-19 15:15:58.087636	2025-12-19 15:15:58.087636
203	1	1	6e070ec4-becf-4353-a8a3-592d940eaedb	7.png	storage/documents/7.png	https://rimba.webgis.app/cms/storage/documents/7.png	image/png	54.17 kB	\N	2025-12-19 15:15:58.088735	2025-12-19 15:15:58.088735
204	1	1	e57a6c5f-0317-409a-bf53-dde667012d82	5.png	storage/documents/5.png	https://rimba.webgis.app/cms/storage/documents/5.png	image/png	97.54 kB	\N	2025-12-19 15:15:58.089848	2025-12-19 15:15:58.089848
128	1	1	795aef5a-5d3b-48dc-bebd-a153a9f8f3d4	2.png	storage/documents/2.png	https://doc.rimbaexium.org/storage/documents/2.png	image/png	51.66 kB	2025-12-19 15:18:34.473771	2025-11-18 18:47:18.119381	2025-11-18 18:47:18.119381
129	1	1	a078ac02-3d07-4de8-ba47-7d9762d38b38	10.png	storage/documents/10.png	https://doc.rimbaexium.org/storage/documents/10.png	image/png	51.73 kB	2025-12-19 15:18:34.473771	2025-11-18 18:47:18.121966	2025-11-18 18:47:18.121966
130	1	1	3b2f1ca3-96fc-4772-beb1-665aa022d6bd	8.png	storage/documents/8.png	https://doc.rimbaexium.org/storage/documents/8.png	image/png	116.29 kB	2025-12-19 15:18:34.473771	2025-11-18 18:47:18.124311	2025-11-18 18:47:18.124311
131	1	1	2cfac457-9142-49da-866b-a0cc97c58296	6.png	storage/documents/6.png	https://doc.rimbaexium.org/storage/documents/6.png	image/png	26.95 kB	2025-12-19 15:18:34.473771	2025-11-18 18:47:18.127308	2025-11-18 18:47:18.127308
132	1	1	66f310eb-90ba-4f5a-ac0d-e643b9582062	4.png	storage/documents/4.png	https://doc.rimbaexium.org/storage/documents/4.png	image/png	64.71 kB	2025-12-19 15:18:34.473771	2025-11-18 18:47:18.129698	2025-11-18 18:47:18.129698
205	1	1	1a4fc288-173a-4210-a812-6ee12ed5b9fb	Univ Andalas.png	storage/documents/Univ Andalas.png	https://rimba.webgis.app/cms/storage/documents/Univ%20Andalas.png	image/png	76.03 kB	\N	2025-12-19 15:18:34.520245	2025-12-19 15:18:34.520245
206	1	1	5a3e50e5-f89f-4226-a321-2f19d34d5908	2.png	storage/documents/2.png	https://rimba.webgis.app/cms/storage/documents/2.png	image/png	51.66 kB	\N	2025-12-19 15:18:34.522288	2025-12-19 15:18:34.522288
207	1	1	44022225-8cba-4097-b282-cedabb19af70	10.png	storage/documents/10.png	https://rimba.webgis.app/cms/storage/documents/10.png	image/png	51.73 kB	\N	2025-12-19 15:18:34.523312	2025-12-19 15:18:34.523312
208	1	1	4dce3d14-8040-4f19-af59-7a71f6a3d901	8.png	storage/documents/8.png	https://rimba.webgis.app/cms/storage/documents/8.png	image/png	116.29 kB	\N	2025-12-19 15:18:34.52794	2025-12-19 15:18:34.52794
209	1	1	73763904-fac6-43e1-a105-7d0da7c19b35	6.png	storage/documents/6.png	https://rimba.webgis.app/cms/storage/documents/6.png	image/png	26.95 kB	\N	2025-12-19 15:18:34.528955	2025-12-19 15:18:34.528955
210	1	1	61d7dd14-6bac-4f41-91bf-32e47a171045	4.png	storage/documents/4.png	https://rimba.webgis.app/cms/storage/documents/4.png	image/png	64.71 kB	\N	2025-12-19 15:18:34.529853	2025-12-19 15:18:34.529853
211	1	1	9a3c30ba-c5fa-4c83-83e7-16cbe2e25db5	Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa(2).png	image/png	1.59 mB	\N	2025-12-19 15:19:44.499645	2025-12-19 15:19:44.499645
212	1	1	41b49011-44c9-4c14-89c6-41b20d142303	Gemini_Generated_Image_aq8cqaq8cqaq8cqa (1).png	storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa (1).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa%20(1).png	image/png	1.59 mB	\N	2025-12-19 15:20:39.837269	2025-12-19 15:20:39.837269
239	1	1	ad3d7154-d6d0-44c0-aabf-056997a7c429	Inpres Nomor 1 Tahun 2023.pdf	storage/documents/Inpres Nomor 1 Tahun 2023.pdf	https://rimba.webgis.app/cms/storage/documents/Inpres%20Nomor%201%20Tahun%202023.pdf	application/pdf	1.24 mB	\N	2025-12-20 02:04:39.174579	2025-12-20 02:04:39.174579
241	1	1	003dab3f-60e0-4f72-9f6f-8f89014bc1f3	1(3).png	storage/documents/1(3).png	https://rimba.webgis.app/cms/storage/documents/1(3).png	image/png	399.79 kB	\N	2025-12-20 02:27:33.779326	2025-12-20 02:27:33.779326
244	1	1	f913be7c-c236-42a0-887d-6127967cbf79	4(2).png	storage/documents/4(2).png	https://rimba.webgis.app/cms/storage/documents/4(2).png	image/png	339.45 kB	\N	2025-12-20 02:29:46.305167	2025-12-20 02:29:46.305167
213	1	1	4f852868-c0b9-4ee4-a041-ea92ec45f764	Gemini_Generated_Image_aq8cqaq8cqaq8cqa (1)(1).png	storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa (1)(1).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_aq8cqaq8cqaq8cqa%20(1)(1).png	image/png	1.59 mB	\N	2025-12-19 15:21:17.425575	2025-12-19 15:21:17.425575
214	1	1	93ac556a-38b3-4af2-8dea-edef1a384be0	Gemini_Generated_Image_cogt7kcogt7kcogt (1).png	storage/documents/Gemini_Generated_Image_cogt7kcogt7kcogt (1).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_cogt7kcogt7kcogt%20(1).png	image/png	1.34 mB	\N	2025-12-19 15:22:37.72631	2025-12-19 15:22:37.72631
215	1	1	5f6e4041-aa83-4951-8ee3-e7cbfa877364	Gemini_Generated_Image_7wxlck7wxlck7wxl (1).png	storage/documents/Gemini_Generated_Image_7wxlck7wxlck7wxl (1).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_7wxlck7wxlck7wxl%20(1).png	image/png	1.50 mB	\N	2025-12-19 15:23:02.351377	2025-12-19 15:23:02.351377
216	1	1	d2275760-6173-4019-8cf6-ffd28077a9e4	Gemini_Generated_Image_voevcfvoevcfvoev (1).png	storage/documents/Gemini_Generated_Image_voevcfvoevcfvoev (1).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_voevcfvoevcfvoev%20(1).png	image/png	2.08 mB	\N	2025-12-19 15:23:26.718674	2025-12-19 15:23:26.718674
217	1	1	5c1926aa-d3e2-4706-8b6e-ad71a265f98c	Gemini_Generated_Image_rrb493rrb493rrb4 (1).png	storage/documents/Gemini_Generated_Image_rrb493rrb493rrb4 (1).png	https://rimba.webgis.app/cms/storage/documents/Gemini_Generated_Image_rrb493rrb493rrb4%20(1).png	image/png	2.01 mB	\N	2025-12-19 15:23:43.990705	2025-12-19 15:23:43.990705
218	1	1	ee1c67a7-dcc6-4479-913c-ac5e7f6829a8	organizational-structure (1).png	storage/documents/organizational-structure (1).png	https://rimba.webgis.app/cms/storage/documents/organizational-structure%20(1).png	image/png	90.42 kB	\N	2025-12-19 15:24:06.274019	2025-12-19 15:24:06.274019
219	1	1	ec7cf647-37d5-4c2f-a875-e8422562a5a8	Vwv9JzxbpYnZKZ3fcYl02koPUi4EzfiK9SfwGImp.jpg	storage/documents/Vwv9JzxbpYnZKZ3fcYl02koPUi4EzfiK9SfwGImp.jpg	https://rimba.webgis.app/cms/storage/documents/Vwv9JzxbpYnZKZ3fcYl02koPUi4EzfiK9SfwGImp.jpg	image/jpeg	770.71 kB	\N	2025-12-19 16:17:35.054443	2025-12-19 16:17:35.054443
49	1	1	d39f8911-2a42-4652-a411-2b3014d5e330	activity_1 (1).jpg	storage/documents/activity_1 (1).jpg	https://doc.rimbaexium.org/storage/documents/activity_1%20(1).jpg	image/jpeg	291.69 kB	2025-12-19 16:18:14.252011	2025-11-01 04:22:53.333484	2025-11-01 04:22:53.333484
220	1	1	e1e87055-e1ed-433a-968d-0d610458c88f	activity_1 (1) (1).jpg	storage/documents/activity_1 (1) (1).jpg	https://rimba.webgis.app/cms/storage/documents/activity_1%20(1)%20(1).jpg	image/jpeg	291.69 kB	\N	2025-12-19 16:18:14.308533	2025-12-19 16:18:14.308533
221	1	1	a2f87c01-2969-440c-bc3d-e06d6eff22f3	1674794177 (1).jpeg	storage/documents/1674794177 (1).jpeg	https://rimba.webgis.app/cms/storage/documents/1674794177%20(1).jpeg	image/jpeg	211.81 kB	\N	2025-12-19 16:26:42.314327	2025-12-19 16:26:42.314327
222	1	1	f8b935d4-192b-4212-888a-546ea6456f54	IMG-20250717-WA0042 (1).jpg	storage/documents/IMG-20250717-WA0042 (1).jpg	https://rimba.webgis.app/cms/storage/documents/IMG-20250717-WA0042%20(1).jpg	image/jpeg	106.17 kB	\N	2025-12-19 16:28:57.05747	2025-12-19 16:28:57.05747
223	1	1	afbb47db-3127-45e2-ae18-8174b3c350be	1(2).png	storage/documents/1(2).png	https://rimba.webgis.app/cms/storage/documents/1(2).png	image/png	2.64 mB	\N	2025-12-20 00:58:08.937292	2025-12-20 00:58:08.937292
224	1	1	b07357a1-5b08-4564-b9d3-4ea824d45427	4(1).png	storage/documents/4(1).png	https://rimba.webgis.app/cms/storage/documents/4(1).png	image/png	3.29 mB	\N	2025-12-20 01:05:37.871935	2025-12-20 01:05:37.871935
225	1	1	ce595fa6-d021-48cb-aaf6-632464edbf27	5(2).png	storage/documents/5(2).png	https://rimba.webgis.app/cms/storage/documents/5(2).png	image/png	2.94 mB	\N	2025-12-20 01:11:05.282634	2025-12-20 01:11:05.282634
226	1	1	f31a08f2-50e4-41e2-afd0-1265d87858be	6(1).png	storage/documents/6(1).png	https://rimba.webgis.app/cms/storage/documents/6(1).png	image/png	2.85 mB	\N	2025-12-20 01:16:51.527159	2025-12-20 01:16:51.527159
227	1	1	2cecbc83-f321-4df1-b9b0-753808d00b52	7(2).png	storage/documents/7(2).png	https://rimba.webgis.app/cms/storage/documents/7(2).png	image/png	3.82 mB	\N	2025-12-20 01:20:06.870703	2025-12-20 01:20:06.870703
228	1	1	ce9a6805-ab79-4258-b529-9fb7035cfdec	2(2).png	storage/documents/2(2).png	https://rimba.webgis.app/cms/storage/documents/2(2).png	image/png	2.79 mB	\N	2025-12-20 01:26:45.176944	2025-12-20 01:26:45.176944
229	1	1	21030994-4bdf-4380-a4ba-6059f06edbf9	WhatsApp Image 2025-12-20 at 08.30.39.jpeg	storage/documents/WhatsApp Image 2025-12-20 at 08.30.39.jpeg	https://rimba.webgis.app/cms/storage/documents/WhatsApp%20Image%202025-12-20%20at%2008.30.39.jpeg	image/jpeg	427.51 kB	\N	2025-12-20 01:31:13.808791	2025-12-20 01:31:13.808791
232	1	1	b00ef20c-0764-4e1c-9097-f95623b53c64	Peraturan Presiden No 13 Tahun 2012(1).pdf	storage/documents/Peraturan Presiden No 13 Tahun 2012(1).pdf	https://rimba.webgis.app/cms/storage/documents/Peraturan%20Presiden%20No%2013%20Tahun%202012(1).pdf	application/pdf	1.02 mB	2025-12-20 01:35:01.098493	2025-12-20 01:34:32.149251	2025-12-20 01:34:32.149251
187	1	1	b59f96ae-c260-45b9-9f5d-84194824bdfa	portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup (2).jpg	storage/documents/portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup (2).jpg	https://doc.rimbaexium.org/storage/documents/portrait-young-bengal-tiger-closeup-head-bengal-tiger-male-bengal-tiger-closeup%20(2).jpg	image/jpeg	1.73 mB	2025-12-20 01:33:10.405786	2025-12-15 03:44:02.040833	2025-12-15 03:44:02.040833
230	1	1	b82241a6-5256-4111-aa0e-68cbc340037c	3(2).png	storage/documents/3(2).png	https://rimba.webgis.app/cms/storage/documents/3(2).png	image/png	2.82 mB	\N	2025-12-20 01:33:16.836376	2025-12-20 01:33:16.836376
231	1	1	567e2d48-363c-4407-a9f6-a75b9d77750e	eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	https://rimba.webgis.app/cms/storage/documents/eka-kurniawan-muchiar-OWKUUpfHxiU-unsplash.jpg	image/jpeg	463.83 kB	\N	2025-12-20 01:33:42.869109	2025-12-20 01:33:42.869109
234	1	1	1dc51fce-9194-401f-9c80-2feaf98f8a36	Types-of-Penetration-Testing-Which-Is-Right-for-Your-Business.jpg	storage/documents/Types-of-Penetration-Testing-Which-Is-Right-for-Your-Business.jpg	https://rimba.webgis.app/cms/storage/documents/Types-of-Penetration-Testing-Which-Is-Right-for-Your-Business.jpg	image/jpeg	138.34 kB	\N	2025-12-20 01:37:26.436024	2025-12-20 01:37:26.436024
235	1	1	6835376a-3109-442d-8432-a569ef64a935	Types-of-Penetration-Testing-Which-Is-Right-for-Your-Business(1).jpg	storage/documents/Types-of-Penetration-Testing-Which-Is-Right-for-Your-Business(1).jpg	https://rimba.webgis.app/cms/storage/documents/Types-of-Penetration-Testing-Which-Is-Right-for-Your-Business(1).jpg	image/jpeg	138.34 kB	\N	2025-12-20 01:39:18.151514	2025-12-20 01:39:18.151514
236	1	1	c38d2429-ccff-40f3-a251-698748ac1e86	UU Nomor 59 Tahun 2024_compressed-dikompresi (1).pdf	storage/documents/UU Nomor 59 Tahun 2024_compressed-dikompresi (1).pdf	https://rimba.webgis.app/cms/storage/documents/UU%20Nomor%2059%20Tahun%202024_compressed-dikompresi%20(1).pdf	application/pdf	2.17 mB	\N	2025-12-20 01:59:17.483597	2025-12-20 01:59:17.483597
247	1	1	b83fbddf-a442-4b54-ba29-e7f8d630207a	7(3).png	storage/documents/7(3).png	https://rimba.webgis.app/cms/storage/documents/7(3).png	image/png	360.36 kB	\N	2025-12-20 02:31:20.459088	2025-12-20 02:31:20.459088
248	1	1	54d8865c-cb20-4b2e-9ebe-4fd15f6c89e8	8(2).png	storage/documents/8(2).png	https://rimba.webgis.app/cms/storage/documents/8(2).png	image/png	369.92 kB	\N	2025-12-20 02:31:51.949157	2025-12-20 02:31:51.949157
249	1	1	9ca7700f-130f-4d45-b747-0b730ba7ecdd	9(2).png	storage/documents/9(2).png	https://rimba.webgis.app/cms/storage/documents/9(2).png	image/png	357.27 kB	\N	2025-12-20 02:32:23.402466	2025-12-20 02:32:23.402466
250	1	1	5f16ef65-1243-4e32-92e0-3f4f91b96b8f	10(2).png	storage/documents/10(2).png	https://rimba.webgis.app/cms/storage/documents/10(2).png	image/png	373.20 kB	\N	2025-12-20 02:32:51.767825	2025-12-20 02:32:51.767825
251	1	1	ed500b7a-b073-4501-822d-189883545e20	11(1).png	storage/documents/11(1).png	https://rimba.webgis.app/cms/storage/documents/11(1).png	image/png	365.61 kB	\N	2025-12-20 02:36:40.028861	2025-12-20 02:36:40.028861
252	1	1	71d57dad-74e3-4da8-93db-a899ac389134	12(1).png	storage/documents/12(1).png	https://rimba.webgis.app/cms/storage/documents/12(1).png	image/png	383.81 kB	\N	2025-12-20 02:37:38.005031	2025-12-20 02:37:38.005031
253	1	1	0e3c69b3-2435-4534-8e96-e277adf08f72	13.png	storage/documents/13.png	https://rimba.webgis.app/cms/storage/documents/13.png	image/png	354.85 kB	\N	2025-12-20 02:38:07.220845	2025-12-20 02:38:07.220845
254	1	1	2d3909d1-4263-49c3-9be3-f282b047f820	14.png	storage/documents/14.png	https://rimba.webgis.app/cms/storage/documents/14.png	image/png	370.73 kB	\N	2025-12-20 02:38:37.25625	2025-12-20 02:38:37.25625
255	1	1	a4dc5efd-2c76-4a21-8013-7747fe59906d	15.png	storage/documents/15.png	https://rimba.webgis.app/cms/storage/documents/15.png	image/png	383.06 kB	\N	2025-12-20 02:39:11.584913	2025-12-20 02:39:11.584913
256	1	1	67f47aac-da6e-4a42-b1bd-7c14360c947e	16.png	storage/documents/16.png	https://rimba.webgis.app/cms/storage/documents/16.png	image/png	370.04 kB	\N	2025-12-20 02:39:40.233797	2025-12-20 02:39:40.233797
257	1	1	7dad7e23-0995-44da-a909-025d61a0ff85	17.png	storage/documents/17.png	https://rimba.webgis.app/cms/storage/documents/17.png	image/png	353.34 kB	\N	2025-12-20 02:41:09.474643	2025-12-20 02:41:09.474643
258	1	1	1de68599-081c-4ae7-b04a-98e15a89e1ac	18.png	storage/documents/18.png	https://rimba.webgis.app/cms/storage/documents/18.png	image/png	368.96 kB	\N	2025-12-20 02:41:39.427097	2025-12-20 02:41:39.427097
259	1	1	9e7b9e45-fa8e-4baa-9369-4408a20fe0a5	19.png	storage/documents/19.png	https://rimba.webgis.app/cms/storage/documents/19.png	image/png	370.79 kB	\N	2025-12-20 02:42:06.72156	2025-12-20 02:42:06.72156
260	42	1	1cb3bdd4-9e7c-4490-9679-89d7d70e3b0a	Laporan Pendahuluan_Kegiatan_Rimba_5_bln 29 agustus 2025.pdf	storage/documents/Laporan Pendahuluan_Kegiatan_Rimba_5_bln 29 agustus 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Pendahuluan_Kegiatan_Rimba_5_bln%2029%20agustus%202025.pdf	application/pdf	2.73 mB	\N	2025-12-20 03:04:43.767116	2025-12-20 03:04:43.767116
261	42	1	35dbd688-a6c8-48f7-93c7-43b08d7cba63	Laporan Antara RIMBA 05 12 2025.pdf	storage/documents/Laporan Antara RIMBA 05 12 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Antara%20RIMBA%2005%2012%202025.pdf	application/pdf	8.52 mB	\N	2025-12-20 03:08:12.555181	2025-12-20 03:08:12.555181
262	42	1	965983e8-eb0d-483b-bc33-e961d0393a95	Laporan Akhir Koridor RIMBA.pdf	storage/documents/Laporan Akhir Koridor RIMBA.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Akhir%20Koridor%20RIMBA.pdf	application/pdf	36.37 mB	\N	2025-12-20 03:22:20.303099	2025-12-20 03:22:20.303099
263	42	1	9c27111e-39b1-4789-97a0-c219acacdb27	Laporan Antara Koridor RIMBA_v1 review Mbak Yosi 7112025.pdf	storage/documents/Laporan Antara Koridor RIMBA_v1 review Mbak Yosi 7112025.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Antara%20Koridor%20RIMBA_v1%20review%20Mbak%20Yosi%207112025.pdf	application/pdf	24.81 mB	\N	2025-12-20 03:25:42.209025	2025-12-20 03:25:42.209025
264	42	1	2d817704-dd59-459e-8cf4-42e1c42f4d75	Laporan Pendahuluan Koridor RIMBA_v1.pdf	storage/documents/Laporan Pendahuluan Koridor RIMBA_v1.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Pendahuluan%20Koridor%20RIMBA_v1.pdf	application/pdf	3.33 mB	\N	2025-12-20 03:27:37.926891	2025-12-20 03:27:37.926891
265	42	1	f31592cb-20b0-493a-b747-b22cba2da958	Laporan Pendahuluan SPC Ekonomi Hijau 27 Agustus 2025 (1).pdf	storage/documents/Laporan Pendahuluan SPC Ekonomi Hijau 27 Agustus 2025 (1).pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Pendahuluan%20SPC%20Ekonomi%20Hijau%2027%20Agustus%202025%20(1).pdf	application/pdf	5.30 mB	\N	2025-12-20 03:31:12.195342	2025-12-20 03:31:12.195342
266	42	1	cb6c6526-bce4-469c-a432-ea29b40fcfd2	Laporan Antara SPC Ekonomi Hijau_Koreksi 11 Nov 2025 (2).pdf	storage/documents/Laporan Antara SPC Ekonomi Hijau_Koreksi 11 Nov 2025 (2).pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Antara%20SPC%20Ekonomi%20Hijau_Koreksi%2011%20Nov%202025%20(2).pdf	application/pdf	29.50 mB	\N	2025-12-20 03:32:27.086404	2025-12-20 03:32:27.086404
267	42	1	789c0360-ec36-408d-ba3e-72f5e5302c6d	Laporan Akhir Paket 01 - UGM.pdf	storage/documents/Laporan Akhir Paket 01 - UGM.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Akhir%20Paket%2001%20-%20UGM.pdf	application/pdf	30.25 mB	\N	2025-12-20 03:38:36.728557	2025-12-20 03:38:36.728557
268	42	1	98ed2cda-ac19-4309-9b0b-73aef2ea0b71	01. Laporan Kegiatan Sumbar_08-09 10 2025 (1).pdf	storage/documents/01. Laporan Kegiatan Sumbar_08-09 10 2025 (1).pdf	https://rimba.webgis.app/cms/storage/documents/01.%20Laporan%20Kegiatan%20Sumbar_08-09%2010%202025%20(1).pdf	application/pdf	996.00 kB	\N	2025-12-20 03:51:13.142094	2025-12-20 03:51:13.142094
269	42	1	815ccaf0-0718-405a-affc-dfc341f5c332	01. Laporan Kegiatan Riau_15-16 09 2025 (1).pdf	storage/documents/01. Laporan Kegiatan Riau_15-16 09 2025 (1).pdf	https://rimba.webgis.app/cms/storage/documents/01.%20Laporan%20Kegiatan%20Riau_15-16%2009%202025%20(1).pdf	application/pdf	996.00 kB	\N	2025-12-20 03:52:09.935263	2025-12-20 03:52:09.935263
270	42	1	9a7bbe78-91c0-45a5-adf0-36ad1bffbd94	01. Laporan Kegiatan Jambi_30-01 10 2025 (1).pdf	storage/documents/01. Laporan Kegiatan Jambi_30-01 10 2025 (1).pdf	https://rimba.webgis.app/cms/storage/documents/01.%20Laporan%20Kegiatan%20Jambi_30-01%2010%202025%20(1).pdf	application/pdf	996.00 kB	\N	2025-12-20 03:53:02.383798	2025-12-20 03:53:02.383798
271	42	1	2af62641-9936-46f7-afae-93342d79b19e	Laporan Pendahuluan 9.pdf	storage/documents/Laporan Pendahuluan 9.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Pendahuluan%209.pdf	application/pdf	3.08 mB	\N	2025-12-20 03:55:12.598865	2025-12-20 03:55:12.598865
272	42	1	452f8e86-9997-4de6-a351-7f5fa31c4b37	Laporan_Antara_9A.pdf	storage/documents/Laporan_Antara_9A.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan_Antara_9A.pdf	application/pdf	30.51 mB	\N	2025-12-20 03:56:22.787249	2025-12-20 03:56:22.787249
233	1	1	0cf40b3d-f5a2-4fcc-ad2f-d02a90b8dc6c	pdf-sample_0(1).pdf	storage/documents/pdf-sample_0(1).pdf	https://rimba.webgis.app/cms/storage/documents/pdf-sample_0(1).pdf	application/pdf	12.95 kB	2025-12-21 11:24:02.974269	2025-12-20 01:35:01.13075	2025-12-20 01:35:01.13075
273	1	1	c54c7469-f57f-4459-a0e3-30d7c861c16b	dummy-pdf_2.pdf	storage/documents/dummy-pdf_2.pdf	https://rimba.webgis.app/cms/storage/documents/dummy-pdf_2.pdf	application/pdf	7.30 kB	2025-12-21 13:43:21.88995	2025-12-21 11:24:03.534929	2025-12-21 11:24:03.534929
274	1	1	44a86481-8e3c-4e1c-94f6-ad187bc1125f	dummy-pdf_2.pdf	storage/documents/dummy-pdf_2.pdf	https://rimba.webgis.app/cms/storage/documents/dummy-pdf_2.pdf	application/pdf	7.30 kB	\N	2025-12-21 13:43:21.954781	2025-12-21 13:43:21.954781
275	1	1	f1f24632-4116-4285-868a-d16819e70051	3(4).png	storage/documents/3(4).png	https://rimba.webgis.app/cms/storage/documents/3(4).png	image/png	2.82 mB	\N	2025-12-21 16:16:04.192903	2025-12-21 16:16:04.192903
276	1	1	de476a42-2320-4c00-bbca-c2d9d86080bc	WhatsApp Image 2025-12-20 at 08.30.39(1).jpeg	storage/documents/WhatsApp Image 2025-12-20 at 08.30.39(1).jpeg	https://rimba.webgis.app/cms/storage/documents/WhatsApp%20Image%202025-12-20%20at%2008.30.39(1).jpeg	image/jpeg	427.51 kB	\N	2025-12-21 16:18:26.353801	2025-12-21 16:18:26.353801
277	1	1	4c169f8b-0977-4630-9cee-799e12d4fe31	2(4).png	storage/documents/2(4).png	https://rimba.webgis.app/cms/storage/documents/2(4).png	image/png	2.79 mB	\N	2025-12-21 16:19:34.093906	2025-12-21 16:19:34.093906
278	1	1	3f72bcf6-f7af-45af-9f2c-7bf081e42d9c	1(4).png	storage/documents/1(4).png	https://rimba.webgis.app/cms/storage/documents/1(4).png	image/png	2.64 mB	\N	2025-12-21 16:24:53.932263	2025-12-21 16:24:53.932263
279	42	1	2a9f6b8f-fa39-4410-9267-641d9b8d2ef4	Bahan Ajar Ã¢ÂÂ Penjangkauan Perubahan Perilaku Kebakaran Gambut 10.pdf	storage/documents/Bahan Ajar Ã¢ÂÂ Penjangkauan Perubahan Perilaku Kebakaran Gambut 10.pdf	https://rimba.webgis.app/cms/storage/documents/Bahan%20Ajar%20%C3%83%C2%A2%C3%82%C2%80%C3%82%C2%93%20Penjangkauan%20Perubahan%20Perilaku%20Kebakaran%20Gambut%2010.pdf	application/pdf	120.42 kB	\N	2025-12-21 16:42:53.58231	2025-12-21 16:42:53.58231
280	42	1	fb79ba61-2492-4029-b373-13efc1a0c2e0	Bahan Ajar Konflik Tenurial di Wilayah Gambut 10.pdf	storage/documents/Bahan Ajar Konflik Tenurial di Wilayah Gambut 10.pdf	https://rimba.webgis.app/cms/storage/documents/Bahan%20Ajar%20Konflik%20Tenurial%20di%20Wilayah%20Gambut%2010.pdf	application/pdf	784.29 kB	\N	2025-12-21 16:43:58.307018	2025-12-21 16:43:58.307018
281	42	1	f04b4a36-6fc1-49e9-9f39-be7948fa4445	Ekonomi Hijau & Bisnis Berkelanjutan di Wilayah Desa Gambut 10.pdf	storage/documents/Ekonomi Hijau & Bisnis Berkelanjutan di Wilayah Desa Gambut 10.pdf	https://rimba.webgis.app/cms/storage/documents/Ekonomi%20Hijau%20%26%20Bisnis%20Berkelanjutan%20di%20Wilayah%20Desa%20Gambut%2010.pdf	application/pdf	1.24 mB	\N	2025-12-21 16:44:55.025869	2025-12-21 16:44:55.025869
282	42	1	ed9308be-b75e-47ed-8fe1-6833b2b0a5e7	Materi KMIS-Paket 10-Keg 4. Perilaku,Rencana Aksi, Strategi MPA.pdf	storage/documents/Materi KMIS-Paket 10-Keg 4. Perilaku,Rencana Aksi, Strategi MPA.pdf	https://rimba.webgis.app/cms/storage/documents/Materi%20KMIS-Paket%2010-Keg%204.%20Perilaku%2CRencana%20Aksi%2C%20Strategi%20MPA.pdf	application/pdf	10.11 mB	\N	2025-12-21 16:46:02.077262	2025-12-21 16:46:02.077262
283	42	1	99d20e8e-aeea-4e7e-b6f6-975071db56f2	Pembasahan Kembali Gambut Ã¢ÂÂ Bahan Ajar Klaster 2 10.pdf	storage/documents/Pembasahan Kembali Gambut Ã¢ÂÂ Bahan Ajar Klaster 2 10.pdf	https://rimba.webgis.app/cms/storage/documents/Pembasahan%20Kembali%20Gambut%20%C3%83%C2%A2%C3%82%C2%80%C3%82%C2%93%20Bahan%20Ajar%20Klaster%202%2010.pdf	application/pdf	1.19 mB	\N	2025-12-21 16:47:24.619192	2025-12-21 16:47:24.619192
284	42	1	7fbb452e-fde0-4e7f-b488-dc69b73b6ab5	Perubahan Perilaku dalam Pencegahan dan Pemadaman Kebakaran Gambut 10.pdf	storage/documents/Perubahan Perilaku dalam Pencegahan dan Pemadaman Kebakaran Gambut 10.pdf	https://rimba.webgis.app/cms/storage/documents/Perubahan%20Perilaku%20dalam%20Pencegahan%20dan%20Pemadaman%20Kebakaran%20Gambut%2010.pdf	application/pdf	1.32 mB	\N	2025-12-21 16:48:34.045217	2025-12-21 16:48:34.045217
285	42	1	8feb83b1-2c38-4d2b-a83a-e88afb51b9d3	WhatsApp Image 2025-12-11 at 16.42.30.jpeg	storage/documents/WhatsApp Image 2025-12-11 at 16.42.30.jpeg	https://rimba.webgis.app/cms/storage/documents/WhatsApp%20Image%202025-12-11%20at%2016.42.30.jpeg	image/jpeg	101.33 kB	\N	2025-12-21 16:50:11.555868	2025-12-21 16:50:11.555868
286	42	1	8586c161-3ae9-478d-bd61-a1630a9bc061	WhatsApp Image 2025-12-11 at 16.42.56.jpeg	storage/documents/WhatsApp Image 2025-12-11 at 16.42.56.jpeg	https://rimba.webgis.app/cms/storage/documents/WhatsApp%20Image%202025-12-11%20at%2016.42.56.jpeg	image/jpeg	95.94 kB	\N	2025-12-21 16:51:50.216792	2025-12-21 16:51:50.216792
287	42	1	5e12f4d0-e9e3-4fdb-ac7d-7de7c9a688c4	WhatsApp Image 2025-12-11 at 16.43.09.jpeg	storage/documents/WhatsApp Image 2025-12-11 at 16.43.09.jpeg	https://rimba.webgis.app/cms/storage/documents/WhatsApp%20Image%202025-12-11%20at%2016.43.09.jpeg	image/jpeg	152.05 kB	\N	2025-12-21 16:52:54.904319	2025-12-21 16:52:54.904319
288	42	1	bd5a0300-ee3d-4d7a-9bc3-b31f5177058c	LAPORAN PENDAHULUAN RIMBA PAKET 12.pdf	storage/documents/LAPORAN PENDAHULUAN RIMBA PAKET 12.pdf	https://rimba.webgis.app/cms/storage/documents/LAPORAN%20PENDAHULUAN%20RIMBA%20PAKET%2012.pdf	application/pdf	13.86 mB	\N	2025-12-21 16:56:49.714408	2025-12-21 16:56:49.714408
289	42	1	074ef584-0544-4227-b91a-cc9b6c7d38db	LAPORAN ANTARA RIMBA12.pdf	storage/documents/LAPORAN ANTARA RIMBA12.pdf	https://rimba.webgis.app/cms/storage/documents/LAPORAN%20ANTARA%20RIMBA12.pdf	application/pdf	25.31 mB	\N	2025-12-21 16:59:13.954763	2025-12-21 16:59:13.954763
290	1	1	f3a03ac5-557b-4285-9a23-2b0d42289e9b	Sinergi Kebijakan Tata Ruang Koridor Rimba.png	storage/documents/Sinergi Kebijakan Tata Ruang Koridor Rimba.png	https://rimba.webgis.app/cms/storage/documents/Sinergi%20Kebijakan%20Tata%20Ruang%20Koridor%20Rimba.png	image/png	363.36 kB	\N	2025-12-22 04:14:05.444403	2025-12-22 04:14:05.444403
291	1	1	cb3f7c33-e3ff-46df-85c7-4d0fd5edfb93	R6-Modul Investasi Perdagangan Karbon APL Kawasan RIMBA.pdf	storage/documents/R6-Modul Investasi Perdagangan Karbon APL Kawasan RIMBA.pdf	https://rimba.webgis.app/cms/storage/documents/R6-Modul%20Investasi%20Perdagangan%20Karbon%20APL%20Kawasan%20RIMBA.pdf	application/pdf	9.76 mB	\N	2025-12-22 04:19:29.294918	2025-12-22 04:19:29.294918
292	1	1	db40dc4f-4857-4dde-9904-2f8467dfdef8	WhatsApp Image 2025-12-22 at 16.20.11.jpeg	storage/documents/WhatsApp Image 2025-12-22 at 16.20.11.jpeg	https://rimba.webgis.app/cms/storage/documents/WhatsApp%20Image%202025-12-22%20at%2016.20.11.jpeg	image/jpeg	67.43 kB	\N	2025-12-22 09:21:33.262805	2025-12-22 09:21:33.262805
293	1	1	6a9d59b3-d3f0-4d47-8065-eb82580fff80	R6-Modul Investasi Perdagangan Karbon APL Kawasan RIMBA(1).pdf	storage/documents/R6-Modul Investasi Perdagangan Karbon APL Kawasan RIMBA(1).pdf	https://rimba.webgis.app/cms/storage/documents/R6-Modul%20Investasi%20Perdagangan%20Karbon%20APL%20Kawasan%20RIMBA(1).pdf	application/pdf	9.76 mB	\N	2025-12-22 09:40:25.809491	2025-12-22 09:40:25.809491
294	1	1	26f78b09-9c12-4290-a76a-78606e063e86	20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0 (1).png	storage/documents/20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0 (1).png	https://rimba.webgis.app/cms/storage/documents/20251023_0645_Demo%20Test%20KMIS_simple_compose_01k874yptzet7806naj67p98s0%20(1).png	image/png	1.67 mB	\N	2025-12-22 14:54:19.845059	2025-12-22 14:54:19.845059
295	36	1	043a4e90-b50a-4396-b3b9-510a45f184be	certificate-17.pdf	storage/documents/certificate-17.pdf	https://rimba.webgis.app/cms/storage/documents/certificate-17.pdf	application/pdf	4.22 kB	\N	2025-12-22 16:23:55.572719	2025-12-22 16:23:55.572719
296	1	1	de87e3e2-787c-4ccb-a621-11ff38eb6e7b	20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0 (1)(1).png	storage/documents/20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0 (1)(1).png	https://rimba.webgis.app/cms/storage/documents/20251023_0645_Demo%20Test%20KMIS_simple_compose_01k874yptzet7806naj67p98s0%20(1)(1).png	image/png	1.67 mB	\N	2025-12-22 17:50:55.060426	2025-12-22 17:50:55.060426
297	36	1	a2f5c1e2-d31e-4174-ade2-9a6efd1d7f8b	certificate-20.pdf	storage/documents/certificate-20.pdf	https://rimba.webgis.app/cms/storage/documents/certificate-20.pdf	application/pdf	4.24 kB	\N	2025-12-22 17:53:28.695006	2025-12-22 17:53:28.695006
149	1	1	8fee960c-4ceb-47e9-ac48-80b991c1a6da	aec89b5fbfcf861805057dd7e0e7d3f7.jpg	storage/documents/aec89b5fbfcf861805057dd7e0e7d3f7.jpg	https://doc.rimbaexium.org/storage/documents/aec89b5fbfcf861805057dd7e0e7d3f7.jpg	image/jpeg	39.52 kB	2025-12-22 17:55:12.274346	2025-11-21 08:12:53.336179	2025-11-21 08:12:53.336179
298	1	1	1a91984d-cd8f-4bba-b0ff-3c2c40a8dea2	20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0 (1)(2).png	storage/documents/20251023_0645_Demo Test KMIS_simple_compose_01k874yptzet7806naj67p98s0 (1)(2).png	https://rimba.webgis.app/cms/storage/documents/20251023_0645_Demo%20Test%20KMIS_simple_compose_01k874yptzet7806naj67p98s0%20(1)(2).png	image/png	1.67 mB	\N	2025-12-22 17:55:12.362967	2025-12-22 17:55:12.362967
299	36	1	cea7891f-fde7-4bd0-af35-d242c4771cae	certificate-15.pdf	storage/documents/certificate-15.pdf	https://rimba.webgis.app/cms/storage/documents/certificate-15.pdf	application/pdf	4.30 kB	\N	2025-12-23 01:45:01.670225	2025-12-23 01:45:01.670225
300	36	1	8e367b58-f635-4914-bf7a-584ee44fb033	certificate-14.pdf	storage/documents/certificate-14.pdf	https://rimba.webgis.app/cms/storage/documents/certificate-14.pdf	application/pdf	4.28 kB	\N	2025-12-23 01:52:18.259025	2025-12-23 01:52:18.259025
301	47	1	5b787231-7840-46a6-9b39-e761ce311130	certificate-21.pdf	storage/documents/certificate-21.pdf	https://rimba.webgis.app/cms/storage/documents/certificate-21.pdf	application/pdf	4.27 kB	\N	2025-12-23 02:47:07.172874	2025-12-23 02:47:07.172874
302	47	1	52baadab-c3f6-4fad-be17-a02ef7c2a8c6	waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer(1).jpg	storage/documents/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer(1).jpg	https://rimba.webgis.app/cms/storage/documents/waist-up-portrait-handsome-serious-unshaven-male-keeps-hands-together-dressed-dark-blue-shirt-has-talk-with-interlocutor-stands-against-white-wall-self-confident-man-freelancer(1).jpg	image/jpeg	219.73 kB	\N	2025-12-23 07:25:45.238362	2025-12-23 07:25:45.238362
303	42	1	1852397c-d733-496f-b5a8-a0d6dfe9b5fa	08 KMIS RIMBA PAKET 1B - Materi.pdf	storage/documents/08 KMIS RIMBA PAKET 1B - Materi.pdf	https://rimba.webgis.app/cms/storage/documents/08%20KMIS%20RIMBA%20PAKET%201B%20-%20Materi.pdf	application/pdf	2.35 mB	\N	2026-01-03 10:14:25.564896	2026-01-03 10:14:25.564896
304	42	1	185e5350-923e-4b02-828e-94c2f7a7cec7	Modul Pelatihan Paket 2B.pdf	storage/documents/Modul Pelatihan Paket 2B.pdf	https://rimba.webgis.app/cms/storage/documents/Modul%20Pelatihan%20Paket%202B.pdf	application/pdf	1.96 mB	\N	2026-01-03 10:16:38.575861	2026-01-03 10:16:38.575861
305	42	1	b686607b-53d0-4533-a225-d3b414eb7d69	2025 10 22  Laporan Akhir Penyusunan Strategi Komunikasi Implementasi Skenario Ekonomi Hijau di Koridor RIMBA (laporan kegiatan)_compressed.pdf	storage/documents/2025 10 22  Laporan Akhir Penyusunan Strategi Komunikasi Implementasi Skenario Ekonomi Hijau di Koridor RIMBA (laporan kegiatan)_compressed.pdf	https://rimba.webgis.app/cms/storage/documents/2025%2010%2022%20%20Laporan%20Akhir%20Penyusunan%20Strategi%20Komunikasi%20Implementasi%20Skenario%20Ekonomi%20Hijau%20di%20Koridor%20RIMBA%20(laporan%20kegiatan)_compressed.pdf	application/pdf	2.65 mB	\N	2026-01-03 10:34:26.31486	2026-01-03 10:34:26.31486
306	42	1	d9d167e3-884a-424e-bc41-85a1d7a4ae32	FAQ Ekonomi Hijau.pdf	storage/documents/FAQ Ekonomi Hijau.pdf	https://rimba.webgis.app/cms/storage/documents/FAQ%20Ekonomi%20Hijau.pdf	application/pdf	8.79 mB	\N	2026-01-03 10:36:36.363429	2026-01-03 10:36:36.363429
307	42	1	e76861e9-5cdc-4c42-93ba-dd2d673bc9c7	Laporan Akhir SPC Ekonomi Hijau_9 Des 2025.pdf	storage/documents/Laporan Akhir SPC Ekonomi Hijau_9 Des 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Laporan%20Akhir%20SPC%20Ekonomi%20Hijau_9%20Des%202025.pdf	application/pdf	29.04 mB	\N	2026-01-03 10:42:20.626788	2026-01-03 10:42:20.626788
308	42	1	16d2e6f9-ab8d-4714-bbd1-42be67ad13bb	DISEMINASI SPC_RIMBA (1).pdf	storage/documents/DISEMINASI SPC_RIMBA (1).pdf	https://rimba.webgis.app/cms/storage/documents/DISEMINASI%20SPC_RIMBA%20(1).pdf	application/pdf	28.03 mB	\N	2026-01-03 10:46:34.392646	2026-01-03 10:46:34.392646
309	42	1	66fcd633-dc64-4d13-a29f-6ec19555c85b	Sosialisasi Buku Panduan SPC_2025_compressed.pdf	storage/documents/Sosialisasi Buku Panduan SPC_2025_compressed.pdf	https://rimba.webgis.app/cms/storage/documents/Sosialisasi%20Buku%20Panduan%20SPC_2025_compressed.pdf	application/pdf	20.19 mB	\N	2026-01-03 11:03:07.249664	2026-01-03 11:03:07.249664
310	42	1	d738ac4f-f156-4ab8-b708-077737479aa1	A1_INFOGRAFIS PAKET 7 ATR RIMBA_ID VERSION.png	storage/documents/A1_INFOGRAFIS PAKET 7 ATR RIMBA_ID VERSION.png	https://rimba.webgis.app/cms/storage/documents/A1_INFOGRAFIS%20PAKET%207%20ATR%20RIMBA_ID%20VERSION.png	image/png	4.74 mB	\N	2026-01-03 11:07:16.342265	2026-01-03 11:07:16.342265
311	42	1	c7a85975-d2f4-41d8-a452-ac563558defa	BMP 1_Nature-based Solution.pdf	storage/documents/BMP 1_Nature-based Solution.pdf	https://rimba.webgis.app/cms/storage/documents/BMP%201_Nature-based%20Solution.pdf	application/pdf	46.50 mB	\N	2026-01-03 11:14:54.882823	2026-01-03 11:14:54.882823
312	42	1	5663f5a6-971e-4e47-9e33-6dde749335c6	BMP 2_Imbal Jasa Lingkungan.pdf	storage/documents/BMP 2_Imbal Jasa Lingkungan.pdf	https://rimba.webgis.app/cms/storage/documents/BMP%202_Imbal%20Jasa%20Lingkungan.pdf	application/pdf	42.81 mB	\N	2026-01-03 11:20:28.067651	2026-01-03 11:20:28.067651
313	42	1	b9d70166-9a4a-4aa2-bfbf-ed8f2d8f2256	2-Matek RPerPres KSN Batabuh.pdf	storage/documents/2-Matek RPerPres KSN Batabuh.pdf	https://rimba.webgis.app/cms/storage/documents/2-Matek%20RPerPres%20KSN%20Batabuh.pdf	application/pdf	8.72 mB	\N	2026-01-09 02:44:20.252435	2026-01-09 02:44:20.252435
314	42	1	9d75e0e8-74ed-4956-b360-63df9563fcba	4-Kajian Perubahan Sikap terhadap EH, Pengembangan Mekanisme Imbal Jasa Air.pdf	storage/documents/4-Kajian Perubahan Sikap terhadap EH, Pengembangan Mekanisme Imbal Jasa Air.pdf	https://rimba.webgis.app/cms/storage/documents/4-Kajian%20Perubahan%20Sikap%20terhadap%20EH%2C%20Pengembangan%20Mekanisme%20Imbal%20Jasa%20Air.pdf	application/pdf	1.72 mB	\N	2026-01-09 04:23:12.516972	2026-01-09 04:23:12.516972
315	42	1	f16de5ef-e335-4fff-a086-82fbb4b1bca5	5-Peninjauan Deliniasi dan Kajian Koridor RIMBA.pdf	storage/documents/5-Peninjauan Deliniasi dan Kajian Koridor RIMBA.pdf	https://rimba.webgis.app/cms/storage/documents/5-Peninjauan%20Deliniasi%20dan%20Kajian%20Koridor%20RIMBA.pdf	application/pdf	800.49 kB	\N	2026-01-09 04:25:08.611572	2026-01-09 04:25:08.611572
341	42	1	bed7ba3e-2e06-4fab-aca6-d427fdace6c3	Paket 6 Indonesia Infografik 2025.png	storage/documents/Paket 6 Indonesia Infografik 2025.png	https://rimba.webgis.app/cms/storage/documents/Paket%206%20Indonesia%20Infografik%202025.png	image/png	2.52 mB	\N	2026-01-09 06:39:00.929084	2026-01-09 06:39:00.929084
316	42	1	a529bb14-6671-4b05-806c-2030eedb312c	6B-Fasilitasi Perencanaan Penggunaan Lahan Partisipatif Kawasan Pedesaan Klaster 1.pdf	storage/documents/6B-Fasilitasi Perencanaan Penggunaan Lahan Partisipatif Kawasan Pedesaan Klaster 1.pdf	https://rimba.webgis.app/cms/storage/documents/6B-Fasilitasi%20Perencanaan%20Penggunaan%20Lahan%20Partisipatif%20Kawasan%20Pedesaan%20Klaster%201.pdf	application/pdf	924.53 kB	\N	2026-01-09 04:27:41.614131	2026-01-09 04:27:41.614131
317	42	1	0b1ef16f-5996-45fe-8754-95ebb7f6eb7a	7-Kajian Konektivitas Jalur Lintasan dan Teritori Satwa Liar.pdf	storage/documents/7-Kajian Konektivitas Jalur Lintasan dan Teritori Satwa Liar.pdf	https://rimba.webgis.app/cms/storage/documents/7-Kajian%20Konektivitas%20Jalur%20Lintasan%20dan%20Teritori%20Satwa%20Liar.pdf	application/pdf	1.24 mB	\N	2026-01-09 04:28:39.329746	2026-01-09 04:28:39.329746
318	42	1	349e129c-4619-4e3f-9929-f2f032f1e6d3	8-Peninjauan RPHJPÃ¢ÂÂKPH.pdf	storage/documents/8-Peninjauan RPHJPÃ¢ÂÂKPH.pdf	https://rimba.webgis.app/cms/storage/documents/8-Peninjauan%20RPHJP%C3%83%C2%A2%C3%82%C2%80%C3%82%C2%93KPH.pdf	application/pdf	3.13 mB	\N	2026-01-09 04:29:48.566477	2026-01-09 04:29:48.566477
319	42	1	85fbbb8d-a4c9-46d9-9bba-3daa9c484755	9-Fasilitasi Perencanaan Lahan Partisipatif Gambut dan Penguatan MPA.pdf	storage/documents/9-Fasilitasi Perencanaan Lahan Partisipatif Gambut dan Penguatan MPA.pdf	https://rimba.webgis.app/cms/storage/documents/9-Fasilitasi%20Perencanaan%20Lahan%20Partisipatif%20Gambut%20dan%20Penguatan%20MPA.pdf	application/pdf	3.43 mB	\N	2026-01-09 04:32:01.677582	2026-01-09 04:32:01.677582
320	42	1	831a48d6-3f3d-4063-b1dc-43698e5b8e11	10-Kajian Pendekatan EH dalam Penyusunan Dokumen Perencanaan dan Pembanguna Daerah.pdf	storage/documents/10-Kajian Pendekatan EH dalam Penyusunan Dokumen Perencanaan dan Pembanguna Daerah.pdf	https://rimba.webgis.app/cms/storage/documents/10-Kajian%20Pendekatan%20EH%20dalam%20Penyusunan%20Dokumen%20Perencanaan%20dan%20Pembanguna%20Daerah.pdf	application/pdf	213.08 kB	\N	2026-01-09 04:32:46.78105	2026-01-09 04:32:46.78105
321	42	1	9389c143-2de6-4c3e-ad31-d80b87dbfffb	11-Sistem Pemantauan dan Evaluasi.pdf	storage/documents/11-Sistem Pemantauan dan Evaluasi.pdf	https://rimba.webgis.app/cms/storage/documents/11-Sistem%20Pemantauan%20dan%20Evaluasi.pdf	application/pdf	1.85 mB	\N	2026-01-09 04:33:46.38024	2026-01-09 04:33:46.38024
322	42	1	6408bd55-5cbe-4ddc-9db1-3af4850ab3da	12-Penyebaran Informasi Kegiatan Koridor Ekosistem RIMBA.pdf	storage/documents/12-Penyebaran Informasi Kegiatan Koridor Ekosistem RIMBA.pdf	https://rimba.webgis.app/cms/storage/documents/12-Penyebaran%20Informasi%20Kegiatan%20Koridor%20Ekosistem%20RIMBA.pdf	application/pdf	6.95 mB	\N	2026-01-09 04:37:03.430846	2026-01-09 04:37:03.430846
323	42	1	7b083c23-373c-41e7-8e0a-a904c5b3ed34	Paket 1 UGM_rev.pdf	storage/documents/Paket 1 UGM_rev.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%201%20UGM_rev.pdf	application/pdf	1.27 mB	\N	2026-01-09 04:55:50.360555	2026-01-09 04:55:50.360555
324	42	1	f63691e4-d206-4bb4-ade3-bc2bd878e2d6	Paket 2.pdf	storage/documents/Paket 2.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%202.pdf	application/pdf	9.00 mB	\N	2026-01-09 04:56:31.798348	2026-01-09 04:56:31.798348
325	42	1	589b8469-674c-4624-a969-1ca450947d31	Paket 6A.pdf	storage/documents/Paket 6A.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%206A.pdf	application/pdf	690.60 kB	\N	2026-01-09 04:57:41.513245	2026-01-09 04:57:41.513245
326	42	1	70dd2f72-db8b-4fec-8bd9-ece0c76cd802	Paket 6B.pdf	storage/documents/Paket 6B.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%206B.pdf	application/pdf	901.48 kB	\N	2026-01-09 04:58:11.534137	2026-01-09 04:58:11.534137
327	42	1	4aad42eb-ccaa-497c-a1bf-f52de7da688d	Paket 8.pdf	storage/documents/Paket 8.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%208.pdf	application/pdf	3.11 mB	\N	2026-01-09 04:59:26.343002	2026-01-09 04:59:26.343002
328	42	1	a8773a7d-f12b-42fb-970b-d69b453f4c33	Paket 9.pdf	storage/documents/Paket 9.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%209.pdf	application/pdf	3.41 mB	\N	2026-01-09 05:00:06.368468	2026-01-09 05:00:06.368468
329	42	1	c1e8aab1-ff88-4786-9813-ef41a7125f57	Paket 10.pdf	storage/documents/Paket 10.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%2010.pdf	application/pdf	200.75 kB	\N	2026-01-09 05:00:42.440619	2026-01-09 05:00:42.440619
330	42	1	b95dc825-202e-4131-9208-d6f345fcca80	Paket 11.pdf	storage/documents/Paket 11.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%2011.pdf	application/pdf	1.86 mB	\N	2026-01-09 05:01:18.622305	2026-01-09 05:01:18.622305
331	42	1	26315ff8-b081-45ad-af15-94a6e4f9748f	Paket 4.pdf	storage/documents/Paket 4.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%204.pdf	application/pdf	1.64 mB	\N	2026-01-09 05:02:49.217923	2026-01-09 05:02:49.217923
332	42	1	b0498f74-7e7a-4295-9e75-476af6e0d478	Paket 1A Indonesia Infografik 2025.pdf	storage/documents/Paket 1A Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%201A%20Indonesia%20Infografik%202025.pdf	application/pdf	5.10 mB	\N	2026-01-09 06:17:01.59063	2026-01-09 06:17:01.59063
333	42	1	04d73fd7-28cf-4871-8868-8480a401f28e	Paket 1A Inggris Infografik 2025.pdf	storage/documents/Paket 1A Inggris Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%201A%20Inggris%20Infografik%202025.pdf	application/pdf	5.16 mB	\N	2026-01-09 06:19:45.136993	2026-01-09 06:19:45.136993
334	42	1	d4792831-bde1-4b9e-a0d1-56d2e0f89b8e	Paket 1B Indonesia Infografik 2025.pdf	storage/documents/Paket 1B Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%201B%20Indonesia%20Infografik%202025.pdf	application/pdf	4.90 mB	\N	2026-01-09 06:21:57.219411	2026-01-09 06:21:57.219411
335	42	1	21c99a1f-1746-4f0c-80fe-f6e56f560913	Paket 2A Indonesia Infografik 2025.pdf	storage/documents/Paket 2A Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%202A%20Indonesia%20Infografik%202025.pdf	application/pdf	3.48 mB	\N	2026-01-09 06:22:59.504257	2026-01-09 06:22:59.504257
336	42	1	c86c5189-46d7-475c-bd98-f845b41ebb77	Paket 3 Indonesia Infografik 2025.pdf	storage/documents/Paket 3 Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%203%20Indonesia%20Infografik%202025.pdf	application/pdf	4.96 mB	\N	2026-01-09 06:24:44.186725	2026-01-09 06:24:44.186725
337	42	1	23f41093-7378-4fe2-b304-06bb0b2c6174	Paket 3 Inggris Infografik 2025.pdf	storage/documents/Paket 3 Inggris Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%203%20Inggris%20Infografik%202025.pdf	application/pdf	4.96 mB	\N	2026-01-09 06:25:42.646465	2026-01-09 06:25:42.646465
338	42	1	0378dbab-7e3b-4698-b1b3-4628bcef39b0	Paket 4C Indonesia Infografik 2025.pdf	storage/documents/Paket 4C Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%204C%20Indonesia%20Infografik%202025.pdf	application/pdf	11.12 mB	\N	2026-01-09 06:33:46.472108	2026-01-09 06:33:46.472108
339	42	1	fa2290e7-079e-4905-9e6f-7384f62d0238	Paket 4C Indonesia Infografik 2025(1).pdf	storage/documents/Paket 4C Indonesia Infografik 2025(1).pdf	https://rimba.webgis.app/cms/storage/documents/Paket%204C%20Indonesia%20Infografik%202025(1).pdf	application/pdf	11.12 mB	\N	2026-01-09 06:35:03.360843	2026-01-09 06:35:03.360843
340	42	1	d948c47d-5f17-4e6f-ac96-e78609d569cd	Paket 4C English Infografik 2025.pdf	storage/documents/Paket 4C English Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%204C%20English%20Infografik%202025.pdf	application/pdf	11.15 mB	\N	2026-01-09 06:36:24.81398	2026-01-09 06:36:24.81398
342	42	1	1544a016-caeb-4c10-8a7f-1f114cc3f1a8	Paket 6 Inggris Infografik 2025.png	storage/documents/Paket 6 Inggris Infografik 2025.png	https://rimba.webgis.app/cms/storage/documents/Paket%206%20Inggris%20Infografik%202025.png	image/png	2.52 mB	\N	2026-01-09 06:39:50.134308	2026-01-09 06:39:50.134308
343	42	1	8ebc63b7-0b73-48cb-bbda-35253d53afd8	Paket 7 Indonesia Infografik 2025.png	storage/documents/Paket 7 Indonesia Infografik 2025.png	https://rimba.webgis.app/cms/storage/documents/Paket%207%20Indonesia%20Infografik%202025.png	image/png	4.74 mB	\N	2026-01-09 06:41:55.780202	2026-01-09 06:41:55.780202
344	42	1	ff2f21f3-7214-48d0-9295-6104ecaeac3b	Paket 7 Inggris Infografik 2025.png	storage/documents/Paket 7 Inggris Infografik 2025.png	https://rimba.webgis.app/cms/storage/documents/Paket%207%20Inggris%20Infografik%202025.png	image/png	4.75 mB	\N	2026-01-09 06:43:06.961504	2026-01-09 06:43:06.961504
345	42	1	dd3f9a12-21df-46b4-9f47-16ab837962e6	Paket 8 Indonesia Infografik 2025.pdf	storage/documents/Paket 8 Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%208%20Indonesia%20Infografik%202025.pdf	application/pdf	16.66 mB	\N	2026-01-09 06:45:47.957345	2026-01-09 06:45:47.957345
346	42	1	9fcb3123-e78e-4a06-b1e3-5f9c994bf7dd	Paket 8 Inggris Infografik 2025.pdf	storage/documents/Paket 8 Inggris Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%208%20Inggris%20Infografik%202025.pdf	application/pdf	16.66 mB	\N	2026-01-09 06:47:27.524308	2026-01-09 06:47:27.524308
347	42	1	383f7802-b461-4fe0-937e-5845b621b655	Paket 11A Indonesia Infografik 2025.jpg	storage/documents/Paket 11A Indonesia Infografik 2025.jpg	https://rimba.webgis.app/cms/storage/documents/Paket%2011A%20Indonesia%20Infografik%202025.jpg	image/jpeg	22.80 mB	\N	2026-01-09 06:55:31.650918	2026-01-09 06:55:31.650918
348	42	1	2fb14bde-e10a-4940-a2df-f56cda234f20	Paket 11A Inggris Infografik 2025.jpeg	storage/documents/Paket 11A Inggris Infografik 2025.jpeg	https://rimba.webgis.app/cms/storage/documents/Paket%2011A%20Inggris%20Infografik%202025.jpeg	image/jpeg	182.37 kB	\N	2026-01-09 06:56:30.458591	2026-01-09 06:56:30.458591
349	42	1	a48a7e4e-79b1-4a75-8e08-dcae2ee85b13	Paket 11B Indonesia Infografik 2025-1.pdf	storage/documents/Paket 11B Indonesia Infografik 2025-1.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%2011B%20Indonesia%20Infografik%202025-1.pdf	application/pdf	1.11 mB	\N	2026-01-09 06:58:15.006894	2026-01-09 06:58:15.006894
350	42	1	8072b39e-ea0b-45e1-b70e-2aa0330390d9	Paket 2B Indonesia Infografik 2025.jpg	storage/documents/Paket 2B Indonesia Infografik 2025.jpg	https://rimba.webgis.app/cms/storage/documents/Paket%202B%20Indonesia%20Infografik%202025.jpg	image/jpeg	606.68 kB	\N	2026-01-09 06:59:20.370756	2026-01-09 06:59:20.370756
351	42	1	5ac0e0af-b71c-4489-871c-f7cc5283b3d0	Paket 4A Inggris Indonesia Infografik 2025-2.pdf	storage/documents/Paket 4A Inggris Indonesia Infografik 2025-2.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%204A%20Inggris%20Indonesia%20Infografik%202025-2.pdf	application/pdf	989.90 kB	\N	2026-01-09 07:08:19.374077	2026-01-09 07:08:19.374077
352	42	1	bae66b97-f0b7-4489-b0d4-1e86439812d3	Paket 4A Inggris Indonesia Infografik 2025-1.pdf	storage/documents/Paket 4A Inggris Indonesia Infografik 2025-1.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%204A%20Inggris%20Indonesia%20Infografik%202025-1.pdf	application/pdf	785.96 kB	\N	2026-01-09 07:08:56.6195	2026-01-09 07:08:56.6195
353	42	1	a78eb087-20a4-4484-8fb8-ed8113375687	Paket 9B Indonesia Infografik 2025.pdf	storage/documents/Paket 9B Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%209B%20Indonesia%20Infografik%202025.pdf	application/pdf	1.05 mB	\N	2026-01-09 07:11:24.191538	2026-01-09 07:11:24.191538
354	42	1	16114601-7c57-4776-828e-257318373875	Paket 9A Indonesia Infografik 2025.pdf	storage/documents/Paket 9A Indonesia Infografik 2025.pdf	https://rimba.webgis.app/cms/storage/documents/Paket%209A%20Indonesia%20Infografik%202025.pdf	application/pdf	4.82 mB	\N	2026-01-09 07:17:16.741151	2026-01-09 07:17:16.741151
355	42	1	c586864b-a4ae-4f0f-87e5-6c9d760eaaa2	Paket 10 Indonesia Infografik 2025.jpg	storage/documents/Paket 10 Indonesia Infografik 2025.jpg	https://rimba.webgis.app/cms/storage/documents/Paket%2010%20Indonesia%20Infografik%202025.jpg	image/jpeg	11.46 mB	\N	2026-01-09 07:38:25.137886	2026-01-09 07:38:25.137886
356	42	1	28414125-9bff-4cb4-88a2-c0fb3e892cea	Paket 10 Inggris Infografik 2025 (1).jpg	storage/documents/Paket 10 Inggris Infografik 2025 (1).jpg	https://rimba.webgis.app/cms/storage/documents/Paket%2010%20Inggris%20Infografik%202025%20(1).jpg	image/jpeg	11.37 mB	\N	2026-01-09 07:40:48.956225	2026-01-09 07:40:48.956225
357	42	1	72aa4157-20c6-4346-af24-dc712e732ce7	Paket 12 Indonesia Infografik 2025.png	storage/documents/Paket 12 Indonesia Infografik 2025.png	https://rimba.webgis.app/cms/storage/documents/Paket%2012%20Indonesia%20Infografik%202025.png	image/png	34.74 mB	\N	2026-01-09 07:51:14.96732	2026-01-09 07:51:14.96732
358	42	1	56184d45-f01f-4a07-8d63-df0b3290fb2f	Paket 12 Inggris Infografik 2025.png	storage/documents/Paket 12 Inggris Infografik 2025.png	https://rimba.webgis.app/cms/storage/documents/Paket%2012%20Inggris%20Infografik%202025.png	image/png	19.53 mB	\N	2026-01-09 07:53:37.700832	2026-01-09 07:53:37.700832
359	1	1	09e26bc0-d06a-4b79-922d-f6040fe2f514	Silokek--3.jpg	storage/documents/Silokek--3.jpg	https://rimba.webgis.app/cms/storage/documents/Silokek--3.jpg	image/jpeg	7.02 mB	\N	2026-01-14 10:19:53.647652	2026-01-14 10:19:53.647652
\.


--
-- Data for Name: kmis_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_categories (id, category_cover_ids, title, description, deleted_at, created_at, updated_at) FROM stdin;
1	[]	test	test	\N	2025-11-01 04:13:45.373122	2025-11-01 04:13:45.373122
12	[]	Sinergi Kebijakan Tata Ruang Koridor Rimba	Sinergi Kebijakan Tata Ruang Koridor Rimba	\N	2025-12-20 02:22:02.219831	2025-12-20 02:22:02.219831
13	[]	RTR-KSN Taman Nasional Sembilang	RTR-KSN Taman Nasional Sembilang	\N	2025-12-20 02:22:14.904759	2025-12-20 02:22:14.904759
14	[]	Pengembangan Kelembagaan Ekonomi Hijau Ekosistem Rimba	Pengembangan Kelembagaan Ekonomi Hijau Ekosistem Rimba	\N	2025-12-20 02:22:23.308093	2025-12-20 02:22:23.308093
15	[]	Mekanisme Insentif, Disinsentif, dan IJE Tata Ruang Koridor Rimba	Mekanisme Insentif, Disinsentif, dan IJE Tata Ruang Koridor Rimba	\N	2025-12-20 02:22:32.697197	2025-12-20 02:22:32.697197
16	[]	Strategi Komunikasi dan Pemasaran Sosial Ekonomi Hijau Koridor Rimba	Strategi Komunikasi dan Pemasaran Sosial Ekonomi Hijau Koridor Rimba	\N	2025-12-20 02:22:48.640094	2025-12-20 02:22:48.640094
17	[]	Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon	Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon	\N	2025-12-20 02:23:02.329475	2025-12-20 02:23:02.329475
18	[]	ToT Ekonomi Hijau dan Teknologi Rendah Karbon	ToT Ekonomi Hijau dan Teknologi Rendah Karbon	\N	2025-12-20 02:23:09.633099	2025-12-20 02:23:09.633099
19	[]	Pedoman Produksi dan Konsumsi Berkelanjutan	Pedoman Produksi dan Konsumsi Berkelanjutan	\N	2025-12-20 02:23:20.554427	2025-12-20 02:23:20.554427
20	[]	Pengelolaan Lingkungan dan Hutan Berkelanjutan Berbasis Masyarakat	Pengelolaan Lingkungan dan Hutan Berkelanjutan Berbasis Masyarakat	\N	2025-12-20 02:23:28.526389	2025-12-20 02:23:28.526389
21	[]	Pengembangan Sistem Informasi dan Analisis Spasial Koridor Rimba	Pengembangan Sistem Informasi dan Analisis Spasial Koridor Rimba	\N	2025-12-20 02:23:35.375571	2025-12-20 02:23:35.375571
22	[]	Integrasi Ekonomi Hijau dalam Perencanaan Tata Ruang Koridor Rimba	Integrasi Ekonomi Hijau dalam Perencanaan Tata Ruang Koridor Rimba	\N	2025-12-20 02:23:42.598595	2025-12-20 02:23:42.598595
23	[]	Partisipasi dan Publikasi Ekonomi Hijau Nasional-Global	Partisipasi dan Publikasi Ekonomi Hijau Nasional-Global	\N	2025-12-20 02:23:51.551271	2025-12-20 02:23:51.551271
24	[]	Perencanaan Lahan Partisipatif dan Penanganan Permukiman Ilegal	Perencanaan Lahan Partisipatif dan Penanganan Permukiman Ilegal	\N	2025-12-20 02:23:58.006794	2025-12-20 02:23:58.006794
25	[]	Desain Konektivitas Satwa dan Mitigasi Dampak	Desain Konektivitas Satwa dan Mitigasi Dampak	\N	2025-12-20 02:24:04.825448	2025-12-20 02:24:04.825448
26	[]	Strategi Pemulihan Ekosistem Gambut dan Pengelolaan Hutan Berkelanjutan	Strategi Pemulihan Ekosistem Gambut dan Pengelolaan Hutan Berkelanjutan	\N	2025-12-20 02:24:12.56184	2025-12-20 02:24:12.56184
27	[]	RPH KPH Klaster 3 Koridor Rimba: Konektivitas dan Konservasi Lanskap	RPH KPH Klaster 3 Koridor Rimba: Konektivitas dan Konservasi Lanskap	\N	2025-12-20 02:24:19.741659	2025-12-20 02:24:19.741659
28	[]	Penguatan Kapasitas PWS dan Perhutanan Sosial Klaster 3 Koridor Rimba	Penguatan Kapasitas PWS dan Perhutanan Sosial Klaster 3 Koridor Rimba	\N	2025-12-20 02:24:27.035942	2025-12-20 02:24:27.035942
29	[]	Peluang Investasi Ekonomi Hijau Koridor Rimba	Peluang Investasi Ekonomi Hijau Koridor Rimba	\N	2025-12-20 02:24:37.51596	2025-12-20 02:24:37.51596
31	[]	Modul Investasi Perdagangan Karbon Paket 6	Modul Investasi Perdagangan Karbon	\N	2025-12-22 04:08:56.279128	2025-12-22 04:37:11.304476
30	[]	Pengelolaan Mangrove Berkelanjutan	Pengelolaan Mangrove Berkelanjutan	\N	2025-12-20 02:24:46.618401	2025-12-22 07:03:38.238311
11	[]	Materi Induksi dan Orientasi Program	Menyediakan video pengenalan, manual onboarding, template dokumen dan standar operasional. Kategori ini memastikan setiap mitra baru, staf, atau stakeholder dapat memahami tujuan, struktur kerja, dan penggunaan aplikasi KMIS secara efisien sejak awal.	\N	2025-11-18 19:45:44.505727	2025-12-22 07:04:08.631875
2	[]	Ekonomi Hijau & Pembangunan Berkelanjutan	Ekonomi Hijau & Pembangunan Berkelanjutan	\N	2025-11-02 02:47:34.74834	2025-12-22 07:07:23.016674
10	[]	Komunikasi & Diseminasi	Komunikasi & Diseminasi	\N	2025-11-02 13:34:48.274789	2025-12-22 07:04:32.371271
9	[]	Digitalisasi & Manajemen Data	Digitalisasi & Manajemen Data	\N	2025-11-02 13:29:09.743316	2025-12-22 07:04:49.59897
32	[]	Strategi Komunikasi dan Pemasaran Sosial Ekonomi Hijau Koridor Rimba 3B-2024	Strategi Komunikasi dan Pemasaran Sosial Ekonomi Hijau Koridor Rimba	\N	2026-01-09 07:57:39.984243	2026-01-09 07:57:39.984243
8	[]	Pengelolaan Lahan Gambut & Pencegahan Kebakaran	Pengelolaan Lahan Gambut & Pencegahan Kebakaran	\N	2025-11-02 13:25:50.087331	2025-12-22 07:05:15.542495
7	[]	Konservasi Biodiversitas & Konektivitas Lanskap	Konservasi Biodiversitas & Konektivitas Lanskap	\N	2025-11-02 13:24:22.959273	2025-12-22 07:05:46.689528
6	[]	Partisipasi Masyarakat & Pemberdayaan	Partisipasi Masyarakat & Pemberdayaan	\N	2025-11-02 13:22:51.427688	2025-12-22 07:06:03.863233
5	[]	Pengelolaan Hutan Berkelanjutan	Pengelolaan Hutan Berkelanjutan	\N	2025-11-02 13:19:24.846349	2025-12-22 07:06:23.445355
4	[]	Jasa Ekosistem & Pembiayaan Lingkungan	Jasa Ekosistem & Pembiayaan Lingkungan	\N	2025-11-02 03:01:35.47207	2025-12-22 07:06:48.460048
3	[]	Tata Ruang & Perencanaan Wilayah	Tata Ruang & Perencanaan Wilayah	\N	2025-11-02 03:00:45.141189	2025-12-22 07:06:58.980708
\.


--
-- Data for Name: kmis_learning_attempts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_learning_attempts (id, attempt_by, kmis_topic_id, quiz_attempt_status, quiz_assessment_status, total_material, completed_quiz, quiz_started, quiz_finished, quiz_duration, questions_answered, correct_count, wrong_count, empty_count, score_total, deleted_at, created_at, updated_at, feedback, certificate_ids, completed_material_ids, learning_started, feedback_comment) FROM stdin;
22	43	21	1	f	2	0	\N	\N	\N	\N	0	0	0	0	\N	2026-01-15 04:53:26.322969	2026-01-15 04:54:58.898562	\N	[]	[]	2026-01-15 04:54:58.897	\N
23	43	36	1	f	3	0	\N	\N	\N	\N	0	0	0	0	\N	2026-01-15 04:54:18.211377	2026-01-15 04:56:03.936561	\N	[]	[]	2026-01-15 04:56:03.935	\N
7	36	5	1	f	0	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-20 04:50:53.804705	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
9	44	2	1	f	1	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-25 07:46:29.784809	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
1	36	1	2	t	1	2	2025-11-02 03:16:35.25	2025-11-02 03:16:53.965	19	2	0	2	0	0	\N	2025-11-02 03:15:38.454135	2026-01-09 07:53:37.708289	4	[64]	[]	2025-11-02 03:16:28.405	Sudah Baik
2	36	13	2	t	4	2	2025-11-04 07:42:29.176	2025-11-04 07:42:36.893	8	2	1	1	0	50	\N	2025-11-04 03:47:00.443889	2026-01-09 07:53:37.708289	5	[108]	[]	2025-11-04 07:41:55.968	Materi sudah jelas, tapi saya masih bingung, tapi materinya udah jelas, tapiya gitu deh
21	47	36	2	t	3	20	2025-12-23 02:44:11.495	2025-12-23 02:47:06.648	175	20	3	17	0	15	\N	2025-12-23 02:43:44.356903	2026-01-09 07:53:37.708289	5	[301]	[68, 73, 74]	2025-12-23 02:43:59.128	Sudah Bagus
19	3	21	1	f	3	0	\N	\N	\N	\N	0	0	0	0	\N	2025-12-22 15:08:16.535425	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
20	36	38	2	t	1	1	2025-12-22 17:53:23.402	2025-12-22 17:53:28.586	5	1	0	1	0	0	\N	2025-12-22 17:53:01.242692	2026-01-09 07:53:37.708289	5	[297]	[]	2025-12-22 17:53:20.673	Baik
18	3	36	1	f	1	0	\N	\N	\N	\N	0	0	0	0	\N	2025-12-22 15:08:10.835456	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
11	44	3	1	f	0	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-25 07:47:28.303169	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
12	44	9	1	f	1	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-25 07:51:26.928642	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
13	3	13	1	f	4	0	\N	\N	\N	\N	0	0	0	0	\N	2025-12-19 22:13:13.714602	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
3	36	12	1	f	0	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-04 07:41:28.228308	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
17	36	37	2	t	2	1	2025-12-22 16:23:41.02	2025-12-22 16:23:55.008	14	1	0	1	0	0	\N	2025-12-22 14:59:18.638979	2026-01-09 07:53:37.708289	5	[295]	[]	2025-12-22 15:43:22.376	alah
8	36	15	1	f	0	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-21 09:12:31.498911	2026-01-09 07:53:37.708289	\N	[]	[]	2025-11-22 02:23:54.8	\N
16	3	37	1	f	1	0	\N	\N	\N	\N	0	0	0	0	\N	2025-12-22 14:57:48.784473	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
4	43	12	1	f	0	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-17 07:06:00.661009	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
5	43	11	1	f	0	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-17 07:06:20.053342	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
6	36	14	1	f	2	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-19 06:36:36.66136	2026-01-09 07:53:37.708289	\N	[]	[]	2025-11-19 06:36:50.35	\N
10	44	1	1	f	2	0	\N	\N	\N	\N	0	0	0	0	\N	2025-11-25 07:47:23.037167	2026-01-09 07:53:37.708289	\N	[]	[]	\N	\N
15	36	21	3	t	3	3	2025-12-22 16:25:43.238	2025-12-23 01:45:01.582	33558	3	1	2	2	20	\N	2025-12-22 09:34:00.519305	2026-01-09 07:53:37.708289	\N	[299]	[]	2025-12-22 16:25:02.258	\N
14	36	36	2	t	0	20	2025-12-23 01:48:39.692	2025-12-23 01:52:18.172	218	20	9	11	0	45	\N	2025-12-22 09:33:53.693306	2026-01-09 07:53:37.708289	5	[300]	[68, 73, 74]	2025-12-22 16:25:24.473	sangat menyenangkan
\.


--
-- Data for Name: kmis_materials; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_materials (id, kmis_topic_id, created_by, uploaded_by, materials_file_ids, materials_cover_ids, title, material_types, material_data, description, deleted_at, created_at, updated_at) FROM stdin;
1	1	1	1	[63]	\N	Pendahuluan	dokumen	\N	<p>Pengelola Koridor Ekosistem bertugas untuk menjaga dan mengelola jalur yang menghubungkan kawasan konservasi, yang berfungsi sebagai alur migrasi bagi satwa dan biota laut.</p>	2025-11-19 08:52:11.198255	2025-11-02 03:10:39.904532	2025-11-19 08:46:17.914322
2	1	2	2	[65]	\N	Overview Proyek Rimba	dokumen	\N	<p>Proyek RIMBA (Strengthening Forest and Ecosystem Connectivity in RIMBA Landscape) bertujuan untuk meningkatkan konektivitas ekosistem dan melestarikan keanekaragaman hayati di kawasan koridor ekosistem RIMBA yang meliputi Provinsi Riau, Jambi, dan Sumatera Barat. Dengan fokus pada ekonomi hijau, proyek ini akan mendukung pengurangan emisi CO2, peningkatan tutupan hutan, dan pelestarian satwa, serta mendorong pembangunan berkelanjutan di wilayah tersebut.</p>	2025-11-19 08:52:11.198255	2025-11-02 03:24:51.018326	2025-11-19 08:46:17.914322
14	14	42	42	[143]	\N	Materi Induksi dan Orientasi Rimba 2025	dokumen	\N	<p data-path-to-node="1"><span class="citation-5 citation-end-5">Dokumen ini merupakan materi presentasi untuk program induksi bagi mitra pelaksana kegiatan tahun 2025 dalam proyek Koridor Ekosistem RIMBA, sebuah inisiatif kolaboratif antara Kementerian ATR/BPN, UNEP, dan GEF untuk mengembangkan ekonomi hijau dan pelestarian biodiversitas di wilayah Riau, Jambi, dan Sumatera Barat<sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span>. <span class="citation-4">Materi ini mencakup evaluasi kinerja mitra tahun 2024, rincian paket kegiatan strategis tahun 2025 (seperti integrasi tata ruang, pengelolaan lahan gambut, dan konservasi satwa), serta panduan teknis menyeluruh mengenai mekanisme pelaporan, administrasi, standar </span><em><span class="citation-4">branding</span></em><span class="citation-4 citation-end-4">, dan penggunaan Sistem Informasi Manajemen Pengetahuan (KMIS) untuk memantau capaian proyek<sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span>.</p>	\N	2025-11-20 08:07:31.083332	2025-11-20 08:07:31.083332
9	14	42	42	[134]	\N	Materi Induksi Tahun 2025	dokumen	\N	<p>Materi Induksi Program Koridor Ekosistem RIMBA Tahun 2025</p>	2025-11-19 08:52:11.198255	2025-11-19 06:27:17.556807	2025-11-19 08:46:17.914322
4	13	1	1	[105]	\N	Contoh Materi GAMBAR	gambar	\N	<div class="paragraph normal ng-star-inserted" data-start-index="0"><span class="ng-star-inserted" data-start-index="0">RIMBA adalah singkatan dari Riau&ndash;Jambi&ndash;Sumatera Barat</span><span class="ng-star-inserted" data-start-index="53">, yang merupakan nama untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="81">Program Koridor Ekosistem RIMBA</strong><span class="ng-star-inserted" data-start-index="112">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="113">&nbsp;</div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="113"><span class="ng-star-inserted" data-start-index="113">Program RIMBA adalah inisiatif kerja sama hibah internasional antara Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (Kementerian ATR/BPN) dengan&nbsp;</span><em class="ng-star-inserted" data-start-index="272">United Nations Environment Programme &ndash; Global Environment Facility</em><span class="ng-star-inserted" data-start-index="338"> (UNEP&ndash;GEF)</span><span class="ng-star-inserted" data-start-index="349">. Program ini bertujuan untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="379">memperkuat konektivitas ekosistem hutan</strong><span class="ng-star-inserted" data-start-index="418"> di bentang alam yang mencakup wilayah tiga provinsi (Riau, Jambi, dan Sumatera Barat)</span><span class="ng-star-inserted" data-start-index="504"> dengan total luas sekitar 3,8 juta hektar</span><span class="ng-star-inserted" data-start-index="546">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="547"><span class="ng-star-inserted" data-start-index="547">Kawasan RIMBA berfungsi sebagai koridor ekologis yang menghubungkan beberapa taman nasional dan suaka margasatwa</span><span class="ng-star-inserted" data-start-index="659">, menjadikannya habitat penting bagi satwa kunci seperti gajah dan harimau sumatra, sekaligus menyimpan cadangan karbon yang signifikan</span><span class="ng-star-inserted" data-start-index="794">. Visi program ini adalah memperkuat konektivitas ekosistem melalui investasi pada modal alam, konservasi keanekaragaman hayati, dan pengurangan emisi berbasis lahan dengan pendekatan&nbsp;</span><strong class="ng-star-inserted" data-start-index="978">pembangunan ekonomi hijau</strong><span class="ng-star-inserted" data-start-index="1003"> yang berkelanjutan dan berbasis data</span><span class="ng-star-inserted" data-start-index="1040">. Program RIMBA dirancang untuk menjadi model integrasi tata ruang, konservasi, dan pembangunan ekonomi hijau di Indonesia</span><span class="ng-star-inserted" data-start-index="1162">.</span></div>	2025-12-22 14:35:22.03345	2025-11-04 03:43:55.395899	2025-11-04 03:43:55.395899
10	14	42	42	[135]	\N	Executive Summary Program Koridor Ekosistem RIMBA Tahun 2024	dokumen	\N	<p>Executive Summary Program Koridor Ekosistem RIMBA Tahun 2024, meliputi visi dan misi, roadmap, kajian hingga tatakelola organisasi RIMBA.</p>	2025-11-19 08:52:11.198255	2025-11-19 06:29:18.843328	2025-11-19 08:46:17.914322
8	13	42	42	[]	[]	Test Mater Video Dari Youtube	video	https://www.youtube.com/embed/cLPl5bHgYWI	<div id="description-inner" class="style-scope ytd-watch-metadata">\r\n<div id="expanded" class="style-scope ytd-text-inline-expander"><span class="yt-core-attributed-string yt-core-attributed-string--white-space-pre-wrap" dir="auto"><span class="yt-core-attributed-string--link-inherit-color" dir="auto">Dari langkah awal menjaga bentang alam, kini Koridor Ekosistem RIMBA terus melangkah menuju masa depan yang lebih terhubung. Hutan yang menyatu, sungai yang bernyawa, masyarakat yang berdaya. ⠀ Saksikan rangkuman perjalanan Program Koridor Ekosistem RIMBA. </span></span></div>\r\n<div class="style-scope ytd-text-inline-expander">&nbsp;</div>\r\n<div class="style-scope ytd-text-inline-expander"><span class="yt-core-attributed-string yt-core-attributed-string--white-space-pre-wrap" dir="auto"><span class="yt-core-attributed-string--link-inherit-color" dir="auto">Yuk Kenali, hayati, dan jaga bersama! </span><span class="yt-core-attributed-string--link-inherit-color" dir="auto"><a class="yt-core-attributed-string__link yt-core-attributed-string__link--call-to-action-color" tabindex="0" href="https://www.youtube.com/hashtag/proyekrimba" target="">#ProyekRIMBA</a></span> <span class="yt-core-attributed-string--link-inherit-color" dir="auto"><a class="yt-core-attributed-string__link yt-core-attributed-string__link--call-to-action-color" tabindex="0" href="https://www.youtube.com/hashtag/ditjentataruang" target="">#DitjenTataRuang</a></span> <span class="yt-core-attributed-string--link-inherit-color" dir="auto"><a class="yt-core-attributed-string__link yt-core-attributed-string__link--call-to-action-color" tabindex="0" href="https://www.youtube.com/hashtag/bersamamenataruang" target="">#BersamaMenataRuang</a></span></span></div>\r\n<div id="snippet" class="style-scope ytd-text-inline-expander"></div>\r\n<div class="style-scope ytd-watch-metadata">\r\n<div id="always-shown" class="style-scope ytd-metadata-row-container-renderer"></div>\r\n<div id="collapsible" class="style-scope ytd-metadata-row-container-renderer"></div>\r\n</div>\r\n</div>	2025-11-20 01:53:41.52831	2025-11-13 04:37:33.147127	2025-11-13 04:38:03.619506
7	13	42	42	\N	\N	Test KMIS	text	\N	<div class="paragraph normal ng-star-inserted" data-start-index="0"><span class="ng-star-inserted" data-start-index="0">RIMBA adalah singkatan dari Riau&ndash;Jambi&ndash;Sumatera Barat</span><span class="ng-star-inserted" data-start-index="53">, yang merupakan nama untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="81">Program Koridor Ekosistem RIMBA</strong><span class="ng-star-inserted" data-start-index="112">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="113"><span class="ng-star-inserted" data-start-index="113">Program RIMBA adalah inisiatif kerja sama hibah internasional antara Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (Kementerian ATR/BPN) dengan&nbsp;</span><em class="ng-star-inserted" data-start-index="272">United Nations Environment Programme &ndash; Global Environment Facility</em><span class="ng-star-inserted" data-start-index="338">&nbsp;(UNEP&ndash;GEF)</span><span class="ng-star-inserted" data-start-index="349">. Program ini bertujuan untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="379">memperkuat konektivitas ekosistem hutan</strong><span class="ng-star-inserted" data-start-index="418">&nbsp;di bentang alam yang mencakup wilayah tiga provinsi (Riau, Jambi, dan Sumatera Barat)</span><span class="ng-star-inserted" data-start-index="504">&nbsp;dengan total luas sekitar 3,8 juta hektar</span><span class="ng-star-inserted" data-start-index="546">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="547"><span class="ng-star-inserted" data-start-index="547">Kawasan RIMBA berfungsi sebagai koridor ekologis yang menghubungkan beberapa taman nasional dan suaka margasatwa</span><span class="ng-star-inserted" data-start-index="659">, menjadikannya habitat penting bagi satwa kunci seperti gajah dan harimau sumatra, sekaligus menyimpan cadangan karbon yang signifikan</span><span class="ng-star-inserted" data-start-index="794">. Visi program ini adalah memperkuat konektivitas ekosistem melalui investasi pada modal alam, konservasi keanekaragaman hayati, dan pengurangan emisi berbasis lahan dengan pendekatan&nbsp;</span><strong class="ng-star-inserted" data-start-index="978">pembangunan ekonomi hijau</strong><span class="ng-star-inserted" data-start-index="1003">&nbsp;yang berkelanjutan dan berbasis data</span><span class="ng-star-inserted" data-start-index="1040">. Program RIMBA dirancang untuk menjadi model integrasi tata ruang, konservasi, dan pembangunan ekonomi hijau di Indonesia</span><span class="ng-star-inserted" data-start-index="1162">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1163">&nbsp;</div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1245"><span class="ng-star-inserted" data-start-index="1245">Untuk mendukung visi tersebut, RIMBA mengembangkan&nbsp;</span><strong class="ng-star-inserted" data-start-index="1296">Sistem Informasi RIMBA</strong><span class="ng-star-inserted" data-start-index="1318">&nbsp;yang terintegrasi, adaptif, dan berbasis data</span><span class="ng-star-inserted" data-start-index="1364">. Anda dapat menjelajahi bagaimana sistem ini mendukung tata kelola ruang dan sumber daya alam yang transparan</span><span class="ng-star-inserted" data-start-index="1474">&nbsp;melalui instrumen digital baru, seperti:</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1515"><span class="ng-star-inserted">&bull;&nbsp;</span><strong class="ng-star-inserted" data-start-index="1515">Modul Investasi Perdagangan Karbon</strong><span class="ng-star-inserted" data-start-index="1549">, yang menyediakan panduan teknis penyusunan skema perdagangan karbon di kawasan RIMBA, khususnya di Areal Penggunaan Lain (APL)</span><span class="ng-star-inserted" data-start-index="1677">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1678"><span class="ng-star-inserted">&bull;&nbsp;</span><strong class="ng-star-inserted" data-start-index="1678">Aplikasi Kepatuhan Ekonomi Hijau</strong><span class="ng-star-inserted" data-start-index="1710">, yang memantau tingkat kepatuhan perusahaan berbasis sumber daya alam terhadap prinsip-prinsip ekonomi hijau</span><span class="ng-star-inserted" data-start-index="1819">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1820"><span class="ng-star-inserted">&bull;&nbsp;</span><strong class="ng-star-inserted" data-start-index="1820">Aplikasi Pengukuran Dampak Aktual Proyek</strong><span class="ng-star-inserted" data-start-index="1860">, yang mengukur dampak proyek berdasarkan empat aspek utama: tata kelola, ekologi, sosial, dan ekonomi</span><span class="ng-star-inserted" data-start-index="1962">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1963"><span class="ng-star-inserted">&bull;&nbsp;</span><strong class="ng-star-inserted" data-start-index="1963">Knowledge Management Information System (KMIS)</strong><span class="ng-star-inserted" data-start-index="2009">, yang berfungsi sebagai pusat data, analisis, dan wahana pembelajaran pengetahuan mengenai praktik pembangunan ekonomi hijau</span><span class="ng-star-inserted" data-start-index="2134">.</span></div>	2025-11-19 23:53:28.172315	2025-11-13 04:34:35.836219	2025-11-19 23:53:05.700211
11	1	42	42	\N	\N	Video Langkah Penyusunan Roadmap: Langkah demi Langkah	video	https://drive.google.com/file/d/1DJZtsyxcdLBxW0wlpGuyf2ubsXK-sVPJ/view?usp=sharing	<p>Video Langkah Penyusunan Roadmap: Langkah demi Langkah</p>	\N	2025-11-20 01:53:01.952253	2025-11-20 01:53:01.952253
22	1	2	2	[153]	[]	Materi Induksi & Orientasi Program 2025	dokumen	\N	<div class="flex-1 flex flex-col gap-3 px-4 max-w-3xl mx-auto w-full pt-1">\r\n<div data-test-render-count="1">\r\n<div>\r\n<div class="group relative pb-3" data-is-streaming="false">\r\n<div class="font-claude-response relative leading-[1.65rem] [&amp;_pre&gt;div]:bg-bg-000/50 [&amp;_pre&gt;div]:border-0.5 [&amp;_pre&gt;div]:border-border-400 [&amp;_.ignore-pre-bg&gt;div]:bg-transparent [&amp;_.standard-markdown_:is(p,blockquote,h1,h2,h3,h4,h5,h6)]:pl-2 [&amp;_.standard-markdown_:is(p,blockquote,ul,ol,h1,h2,h3,h4,h5,h6)]:pr-8 [&amp;_.progressive-markdown_:is(p,blockquote,h1,h2,h3,h4,h5,h6)]:pl-2 [&amp;_.progressive-markdown_:is(p,blockquote,ul,ol,h1,h2,h3,h4,h5,h6)]:pr-8">\r\n<div>\r\n<div class="grid-cols-1 grid gap-2.5 [&amp;_&gt;_*]:min-w-0 standard-markdown">\r\n<p class="font-claude-response-body whitespace-normal break-words">Dokumen ini merupakan roadmap ekonomi hijau untuk Koridor Ekosistem RIMBA (Riau-Jambi-Sumatera Barat), kawasan strategis seluas 3,8 juta hektar yang membentang di tiga provinsi dan 22 kabupaten/kota sebagai penghubung ekologis habitat gajah, harimau, dan burung. Roadmap ini mendukung Visi Indonesia Emas 2045 dengan target menjadikan Koridor RIMBA sebagai model pengembangan ekonomi hijau yang dinamis, inklusif, dan efisien. Menggunakan pemodelan spasial dan sistem dinamik, skenario hijau dipilih karena menghasilkan nilai jasa ekosistem 23,6% lebih tinggi untuk valuasi karbon dan 24,4% lebih tinggi untuk potensi simpanan air dibanding skenario business as usual pada tahun 2045.</p>\r\n<p class="font-claude-response-body whitespace-normal break-words">Implementasi roadmap dilaksanakan dalam empat tahap selama 20 tahun (2025-2045) dengan tiga strategi utama: penguatan tata kelola melalui pengarusutamaan kebijakan dan reformasi kelembagaan, pengembangan investasi hijau dengan instrumen pembiayaan berkelanjutan, serta peningkatan kualitas SDM. Program kunci meliputi restorasi ekologis seluas 536.453 hektar, intervensi berbasis lahan pada sektor kehutanan dan pertanian, serta pengembangan sektor prioritas seperti carbon offset dan energi terbarukan. Tata kelola pelaksanaan melibatkan Dewan Pengarah Ekonomi Hijau Nasional dan Satuan Tugas di tingkat provinsi, dengan indikator capaian mencakup aspek sosial (penurunan kemiskinan), ekonomi (produktivitas meningkat, 70% energi terbarukan), dan lingkungan (pengurangan emisi 51,51%, peningkatan kualitas habitat satwa). Pendanaan bersumber dari APBN/APBD, sektor swasta, serta kerja sama internasional dengan GEF dan UNEP.</p>\r\n</div>\r\n</div>\r\n</div>\r\n<div class="absolute bottom-0 right-2 pointer-events-none">\r\n<div class="rounded-lg transition min-w-max pointer-events-auto translate-x-2 translate-y-full pt-2">\r\n<div class="text-text-300 flex items-stretch justify-between">\r\n<div class="w-fit" data-state="closed">\r\n<div class="relative">&nbsp;</div>\r\n</div>\r\n<div class="w-fit" data-state="closed">&nbsp;</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>\r\n</div>	2025-11-25 07:41:42.300619	2025-11-25 07:30:37.786888	2025-11-25 07:39:24.062911
25	2	42	42	[156]	\N	Poster Rencana Tataruang KSN Kawasan Berbak dan Bukit Tiga Puluh	dokumen	\N	<p>Poster ini merupakan ringkasan visual dari Program Koridor RIMBA (Riau-Jambi-Sumatera Barat) yang didukung UN Environment dan GEF, khususnya Paket Kegiatan 3: Penyusunan Materi Teknis Rancangan Peraturan Presiden (RPerpres) Rencana Tata Ruang Kawasan Strategis Nasional (RTR KSN) Taman Nasional Berbak dan Bukit Tiga Puluh. Poster menampilkan peta kawasan seluas &plusmn;2,9 juta hektare yang mencakup 7 kabupaten/kota di Jambi dan 2 kabupaten di Riau, dengan fokus melestarikan koridor ekosistem harimau sumatra dan gajah sumatra sambil mewujudkan ekonomi hijau. Tujuan utama adalah melestarikan keanekaragaman hayati ekosistem Rimba secara berkelanjutan dan berketahanan melalui pengembangan ekonomi hijau yang harmonis serta kolaboratif, dengan empat kebijakan besar: (1) pelestarian keanekaragaman hayati dan mitigasi bencana, (2) pengembangan ekonomi hijau berbasis produk ramah lingkungan, perdagangan karbon, dan ekowisata, (3) infrastruktur hijau dan pusat permukiman yang mendukung konservasi, serta (4) penguatan kelembagaan dan partisipasi masyarakat adat.</p>\r\n<p>Secara teknis, poster memaparkan metodologi berbasis Kajian Lingkungan Hidup Strategis (KLHS) dengan model InVEST, Google Earth Engine, dan ArcGIS untuk menganalisis daya dukung lingkungan (carbon storage, habitat quality, sediment delivery ratio, dll.) dan daya tekan (kepadatan penduduk, perubahan tutupan lahan, hotspot perizinan tambang dan sawit, dll.), sehingga menghasilkan Model Kebutuhan Penanganan (tinggi-sedang-rendah). Rencana pola ruang membagi kawasan menjadi zona lindung (badan air, hutan lindung, gambut, suaka alam, taman nasional, dll.) dan zona budi daya dengan intensitas tinggi hingga rendah, dilengkapi struktur ruang berjenjang (pusat pelayanan primer Jambi, sekunder Kuala Tungkal/Muara Sabak/Muara Bulian, dan tersier di berbagai kecamatan), serta arahan zonasi ketat seperti larangan drainase dan pembakaran pada kawasan gambut lindung (L1.2). Tahapan implementasi dibagi menjadi empat fase hingga 2045: Inisiasi (2025-2029), Pemulihan (2030-2034), Pengembangan (2035-2039), dan Aktualisasi (2040-2045), dengan penekanan kuat pada konektivitas jalur satwa, green infrastructure, bioprospeksi, circular economy, dan pemberdayaan masyarakat adat.</p>	\N	2025-11-26 07:16:18.360518	2025-11-26 07:16:18.360518
21	15	1	1	[151]	\N	Episode 2	gambar	\N	<p>test</p>	2025-12-22 17:54:43.491439	2025-11-21 12:07:47.012483	2025-11-21 12:07:47.012483
26	3	42	42	[157]	[]	Kajian solusi berbasis alam untuk menanggulangi Degradasi Lingkungan	dokumen	\N	<p>Laporan Akhir Kajian Solusi Berbasis Alam untuk Menanggulangi Dampak Degradasi Lingkungan di Koridor RIMBA, yang diterbitkan oleh WRI Indonesia pada Desember 2024, merupakan hasil kerjasama antara Kementerian Agraria dan Tata Ruang/BPN dengan UNEP-GEF dalam proyek RIMBA. Laporan ini membahas potensi solusi berbasis alam (NbS) untuk mengatasi degradasi lingkungan di koridor ekosistem RIMBA meliputi Riau, Jambi, dan Sumatera Barat, dengan tujuan memperkuat konektivitas hutan melalui investasi modal alam, konservasi biodiversitas, dan pengurangan emisi berbasis lahan. Pendahuluan menjelaskan tiga komponen proyek: pembentukan kerangka kelembagaan ekonomi hijau, demonstrasi pembangunan hijau, serta monitoring dan diseminasi. Tinjauan pustaka mendefinisikan NbS sebagai upaya melindungi, mengelola, dan memulihkan ekosistem untuk menangani tantangan sosial sekaligus meningkatkan kesejahteraan manusia, dengan tipe intervensi proteksi, restorasi, dan manajemen, serta fase perencanaan melibatkan identifikasi masalah hingga manfaat. Metode kajian mencakup kriteria prioritas sub-DAS menggunakan analisis morfometri dan pemodelan erosi RUSLE, serta kriteria lokasi untuk perlindungan hutan, restorasi daratan berdasarkan PermenLHK 10/2022, dan rehabilitasi gambut.</p>\r\n<p>Hasil kajian mengidentifikasi masalah degradasi seperti deforestasi, penambangan ilegal, dan kebakaran gambut di tiga kluster RIMBA, yang menyebabkan banjir, longsor, dan hilangnya habitat. Potensi NbS untuk mitigasi risiko meliputi restorasi dataran banjir, agroforestri, zona riparian, dan teknik konservasi tanah, dengan manfaat seperti retensi air, reduksi erosi, dan peluang wisata. Analisis prioritas sub-DAS menunjukkan urgensi tinggi di hulu akibat topografi curam, sementara hasil spasial merekomendasikan lokasi untuk penghindaran deforestasi (321 ribu ha), restorasi dalam hutan (334 ribu ha via agroforestri, reboisasi intensif, rehab gambut), dan luar hutan (200 ribu ha via penghijauan agroforestri, terasering, rehab gambut). Potensi pendanaan mencakup hibah, pembayaran berbasis kinerja (REDD+, ARR), impact investment, carbon/biodiversity credit, dan green sukuk. Tantangan implementasi termasuk keterbatasan kapasitas, dampak jangka panjang yang tak langsung terlihat, trade-off dengan pendekatan konvensional, akses dana, dan regulasi lokal. Kesimpulan menekankan NbS sebagai solusi efektif untuk pemulihan ekosistem, dengan rekomendasi kolaborasi multi-pihak, edukasi masyarakat, dan mekanisme pendanaan inovatif untuk keberlanjutan.</p>	\N	2025-11-26 07:28:27.43418	2025-11-26 07:28:50.71445
27	3	42	42	[158]	\N	Kajian Skema Imbal Jasa Air untuk Energi Terbarukan	dokumen	\N	<p>Laporan Akhir Kajian Perubahan Sikap terhadap Ekonomi Hijau, Pengembangan Mekanisme Imbal Jasa Air untuk Energi dan Solusi Berbasis Alam (Swakelola Tipe 3) Tahun Anggaran 2024, yang diterbitkan oleh WRI Indonesia pada Desember 2024, merupakan laporan komprehensif yang menyatukan tiga kajian utama dalam proyek RIMBA (Riau-Jambi-Sumatera Barat) bekerja sama dengan Kementerian Agraria dan Tata Ruang/BPN serta UNEP-GEF. Laporan ini bertujuan memperkuat konektivitas ekosistem hutan melalui investasi modal alam, konservasi keanekaragaman hayati, dan pengurangan emisi berbasis lahan, dengan tiga komponen program: pembentukan kerangka kelembagaan ekonomi hijau, demonstrasi pembangunan hijau, serta monitoring dan diseminasi. Struktur laporan mencakup Bab 1 Pendahuluan yang menguraikan latar belakang proyek dan cakupan kajian; Bab 2 Metode Kajian yang merinci pendekatan seperti studi literatur, FGD dengan metode iceberg/wave analysis, survei rumah tangga, wawancara mendalam, analisis hidrologi (termasuk model water balance, erosi RUSLE, morfometri), serta kriteria restorasi berdasarkan PermenLHK 10/2022; Bab 3 Hasil Kajian yang membahas sektor ekonomi hijau (pertanian berkelanjutan, pariwisata lingkungan, pengelolaan hutan lestari, energi terbarukan, dll.), kondisi implementasi dengan studi kasus, faktor pendukung/penghambat, potensi model seperti agroforestri dan biogas dari limbah sawit, analisis WTP/WTA untuk imbal jasa air (energi PLTA/PLTMH dan air minum), kajian hidrologi di sub-DAS seperti Batang Merao dan Batang Masurai, serta potensi NbS untuk mitigasi banjir/longsor/deforestasi di tiga kluster RIMBA; Bab 4 Penutup dengan kesimpulan dan rekomendasi; serta Bab 5 Referensi.</p>\r\n<p>Hasil kajian menunjukkan pemahaman stakeholder terhadap ekonomi hijau yang bervariasi, dengan pendukung seperti kebijakan pemerintah dan CSR, serta penghambat seperti konflik lahan dan infrastruktur terbatas, sehingga direkomendasikan roadmap transformasi melalui edukasi, kolaborasi, dan pemberdayaan masyarakat adat. Untuk imbal jasa air, analisis hidrologi mengonfirmasi ketersediaan debit andalan yang cukup untuk PLTA dan AMDK, dengan usulan skema pembayaran berbasis kinerja (Rp 3.000-5.000/kWh untuk energi, Rp 50-100/liter untuk air minum), sementara NbS seperti restorasi riparian, agroforestri, dan pencegahan deforestasi (di 321.000 ha kawasan hutan) direkomendasikan untuk mengatasi degradasi, dengan potensi pendanaan dari REDD+, carbon credit, dan green sukuk. Kesimpulan laporan menekankan bahwa integrasi ekonomi hijau dan NbS dapat meningkatkan keberlanjutan lingkungan-sosial-ekonomi di RIMBA, dengan rekomendasi untuk kebijakan berbasis data, peningkatan kapasitas lokal, dan penelitian lanjutan guna mempercepat transisi berkelanjutan di Indonesia.</p>	\N	2025-11-26 07:31:47.189122	2025-11-26 07:31:47.189122
28	4	42	42	[159]	\N	Album Peta	dokumen	\N	<p>Album Peta ini merupakan kompilasi peta-peta geospatial yang disusun untuk peninjauan kembali delineasi dan pengkajian Koridor RIMBA sebagai usulan Kawasan Strategis Nasional (KSN) dalam proses revisi Rencana Tata Ruang Wilayah Nasional (RTRWN), sebagai bagian dari Program GEF RIMBA tahun anggaran 2024, bekerja sama dengan UN Environment Programme, GEF, dan mitra seperti WRI Indonesia. Dokumen berisi 53 halaman ini mencakup daftar isi yang merinci berbagai peta Pulau Sumatera, termasuk peta batas administrasi wilayah, morfologi, geologi, curah hujan, aliran air, gambut, produktivitas akuifer, kelerengan, penetapan kawasan lindung berdasarkan SK KLHK, serta peta bahaya bencana seperti banjir, gempa bumi, kebakaran hutan dan lahan, likuefaksi, tanah longsor, dan multi bencana. Selain itu, album ini menyajikan peta tutupan lahan tahun 2017 dan 2023, serta hasil pengolahan data prediktor seperti NDVI, tree cover, forest cover, sungai, lahan basah, suhu tahunan, curah hujan tahunan, lahan gambut, ketinggian, kelerengan, populasi, dan jaringan jalan, yang mendukung analisis lingkungan, konservasi keanekaragaman hayati, dan perencanaan ekonomi hijau di koridor ekosistem Riau-Jambi-Sumatera Barat.</p>	\N	2025-11-26 07:34:48.256951	2025-11-26 07:34:48.256951
29	5	42	42	[160]	\N	Peninjauan Rencana Jangka Panjang Pengelolaan Hutan Termasuk Kawasan Penyangga	dokumen	\N	<p>Laporan Peninjauan Rencana Pengelolaan Hutan Jangka Panjang (RPHJP) Hutan Lindung Bukit Batabuh dan Kawasan Penyangga ini mengevaluasi efektivitas dokumen RPHJP KPH Singingi Unit XXXI, dengan fokus pada tinjauan visi-misi yang belum optimal terealisasi karena keterbatasan implementasi seperti legalitas kawasan, kapasitas SDM, dan koordinasi; analisis SWOT yang menyoroti kekuatan seperti organisasi KPH dan potensi jasa lingkungan, kelemahan seperti data potensi hutan tidak lengkap, peluang dukungan pemerintah, serta ancaman perambahan dan illegal logging; tinjauan anggaran yang menunjukkan kesenjangan besar antara estimasi Rp291 miliar dengan alokasi tahunan hanya Rp400 juta; keselarasan regulasi dengan UU Cipta Kerja, PP No.23/2021, dan Permen LHK terkait penyelesaian keterlanjuran sawit melalui sanksi, pemulihan, dan perhutanan sosial; peninjauan RTRW provinsi/kabupaten yang mengungkap ketiadaan buffer zone 500-1.000 meter, meningkatkan risiko degradasi; kesesuaian dengan FOLU Net Sink 2030 di mana 10 dari 15 rencana kegiatan selaras dengan upaya seperti rehabilitasi dan perhutanan sosial; serta evaluasi keseluruhan yang merekomendasikan harmonisasi tata ruang, penguatan kelembagaan, dan pendekatan ekonomi hijau untuk mencapai pengelolaan berkelanjutan.</p>	\N	2025-11-26 07:35:49.799957	2025-11-26 07:35:49.799957
30	5	42	42	[161]	\N	Rekomendasi Revisi RPHJP	dokumen	\N	<p>The report "Rekomendasi Revisi RPHJP UPT KPH Singingi_Paket 6A" offers comprehensive recommendations for revising the Long-Term Forest Management Plan (RPHJP) for the Protected Forest Bukit Batabuh and its buffer zone under the UPT KPH Singingi Unit XXXI, as part of efforts to enhance sustainable forest governance in alignment with environmental and economic goals. It begins with an overview of the forest area's arrangement, detailing the latest block divisions into protection blocks (e.g., core zones for biodiversity and hydrology), utilization blocks (for limited non-timber extraction), and special blocks (for research and community access), emphasizing ecological integrity and conflict resolution. The core of the report focuses on strategic recommendations across six pillars: strengthening institutions through optimizing KPH roles, accelerating boundary legalization, improving multi-stakeholder coordination, and competency-based staff mutations; optimizing budgets and funding via diversification (e.g., grants, CSR, public-private partnerships), environmental services schemes like payment for ecosystem services (PES), and efficient allocation; sustainable management practices including precise block mapping, rehabilitation of critical lands, and ecosystem-based approaches; community empowerment via capacity building, participatory planning, economic incentives, and inclusive decision-making; enhanced law enforcement through collaborations with enforcement agencies for patrols, investigations, and transparent prosecutions against illegal activities like logging and mining; and economic potential utilization, such as developing ecotourism, jasa lingkungan (environmental services), increasing value-added of non-timber forest products (HHBK) like honey and medicinal plants, and carbon trading mechanisms to generate revenue while supporting climate mitigation. The conclusion highlights key insights from the review, stressing the integration of green economy elements, spatial harmonization across governance levels, and ongoing participatory approaches to ensure the plan's alignment with sustainability visions, ultimately positioning KPH Singingi as a model for ecologically sound and socially beneficial forest management.</p>	\N	2025-11-26 07:38:14.325721	2025-11-26 07:38:14.325721
32	7	42	42	\N	\N	Visualisasi 3D koridor RIMBA Universitas Andalas	video	https://www.youtube.com/embed/RwB97XkxKGI	<p>Video &ldquo;Visualisasi 3D Koridor RIMBA&rdquo; karya Universitas Andalas menyajikan penerbangan imersif selama &plusmn;4 menit di atas koridor ekosistem seluas hampir 3 juta hektare yang menghubungkan Taman Nasional Berbak (Jambi) hingga Taman Nasional Bukit Tiga Puluh (Riau-Jambi), dengan perspektif tiga dimensi yang memadukan data elevasi DEMNAS, citra satelit terkini, serta pemodelan vegetasi dan hidrologi. Penonton diajak melayang dari dataran gambut Berbak yang luas, menyusuri sungai-sungai besar, melewati hutan primer Bukit Tiga Puluh yang masih menjadi habitat harimau dan gajah Sumatra, hingga melihat lanskap buffer zone yang kini terfragmentasi oleh perkebunan sawit dan permukiman. Visualisasi ini secara dramatis memperlihatkan konektivitas ekologi yang tersisa, zona-zona kritis dengan tingkat kebutuhan penanganan tinggi (merah), sedang (kuning), dan rendah (hijau) berdasarkan model InVEST serta Kajian Lingkungan Hidup Strategis (KLHS) Paket Kegiatan 3 Program GEF RIMBA, sekaligus menggambarkan visi penataan ruang KSN masa depan yang mengintegrasikan koridor satwa liar, infrastruktur hijau, dan pengembangan ekonomi hijau berbasis ekowisata serta perdagangan karbon, sehingga menjadi alat komunikasi yang kuat bagi pemangku kebijakan dan masyarakat untuk memahami urgensi pelestarian Koridor RIMBA sebagai salah satu benteng terakhir hutan hujan tropis Sumatra.</p>	\N	2025-11-26 07:48:49.931477	2025-11-26 07:48:49.931477
33	8	42	42	[163]	\N	Album Peta	dokumen	\N	<p>Album Peta &ldquo;Laporan Akhir Peninjauan Rencana Pengelolaan Hutan Jangka Panjang (RPHJP) Kesatuan Pengelolaan Hutan dan Rencana Tata Ruang Wilayah (RTRW) Berbasis Pengelolaan Gambut Berkelanjutan di Klaster II Koridor RIMBA&rdquo; (46 halaman, 2024) merupakan dokumen pendukung visual yang disusun oleh Tim Kajian Lembaga Penelitian dan Pengabdian Masyarakat Universitas Jambi dalam kerangka Program GEF-RIMBA Paket 8. Album ini menyajikan puluhan peta tematik berskala besar dan berkualitas tinggi yang mencakup sebaran ekosistem gambut dan Kesatuan Hidrologis Gambut (KHG), kondisi hidrologi serta kedalaman gambut, zonasi kawasan lindung dan budi daya berdasarkan RTRW provinsi/kabupaten, identifikasi kawasan gambut kritis dan rawan kebakaran, rekomendasi penataan ulang blok-blok pengelolaan KPH, lokasi prioritas restorasi dan rehabilitasi gambut, integrasi koridor satwa liar, serta arahan pengelolaan berkelanjutan yang selaras dengan FOLU Net Sink 2030 dan ekonomi hijau, sehingga menjadi acuan spasial penting bagi pemerintah daerah, KPH, dan pemangku kepentingan lainnya untuk menyusun revisi RPHJP dan RTRW yang lebih adaptif terhadap perlindungan gambut, mitigasi perubahan iklim, serta peningkatan kesejahteraan masyarakat lokal di Klaster II Koridor RIMBA.</p>	\N	2025-11-26 07:51:02.343176	2025-11-26 07:51:02.343176
36	9	42	42	[166]	\N	Peta Penggunaan Lahan Masyarakat Pada Koridor RIMBA di enam desa sasaran	dokumen	\N	<p>Dokumen &ldquo;Rencana Tata Guna Lahan di 6 (Enam) Desa Sasaran Berdasarkan Metode Participatory Land Use Planning (PLUP)&rdquo; (76 halaman, 2024) yang diterbitkan Yayasan HutanRiau merupakan hasil fasilitasi perencanaan penggunaan lahan partisipatif di Klaster I Koridor RIMBA, mencakup enam desa prioritas di Provinsi Riau dan Jambi, yaitu Desa Teluk Nilap, Kemingking Dalam, Kemingking Luar, Pulau Muda, Danau Embat, serta satu desa tambahan di wilayah penyangga Taman Nasional Bukit Tiga Puluh dan Hutan Lindung Bukit Batabuh. Dokumen ini memuat peta partisipatif berskala desa yang disepakati bersama masyarakat melalui serangkaian lokakarya PLUP, yang menggambarkan zonasi penggunaan lahan eksisting (hutan lindung, hutan desa, kawasan perhutanan sosial, kebun karet, sawit, permukiman, dan lahan terbuka), identifikasi konflik tenurial, area simpanan karbon tinggi, koridor satwa liar, serta rencana tata guna lahan 10&ndash;20 tahun ke depan yang berorientasi ekonomi hijau (agroforestry, ekowisata, HHBK, perlindungan sumber air, dan pencegahan kebakaran lahan). Hasilnya menjadi dokumen resmi desa yang dapat dijadikan dasar penyusunan Rencana Pembangunan Jangka Menengah Desa (RPJMDes), pengajuan skema perhutanan sosial, serta acuan teknis bagi pemerintah daerah dan KPH dalam harmonisasi Rencana Tata Ruang Wilayah (RTRW) serta pengelolaan kawasan penyangga yang inklusif dan berkelanjutan di Koridor RIMBA.</p>	\N	2025-11-26 07:58:00.392564	2025-11-26 07:58:00.392564
37	9	42	42	[167]	\N	Poster Fasilitasi Perencaan Penggunaan Lahan Partisipatif Kawasan Pedesaan di Lahan Gambut dan Penguatan Masyarakat Peduli Api	dokumen	\N	<p>Poster &ldquo;KRIS &ndash; PLUP &amp; MPA&rdquo; (Paket Kegiatan IX Program Koridor RIMBA) merupakan ringkasan visual kegiatan Konsorsium Rimba Sumatra (Pundi Sumatera, KKI WARSI, dan Mitra Aksi) di empat desa gambut timur Klaster II Koridor RIMBA (Pandan Sejahtera, Pandan Makmur, Rantau Panjang, dan Seponjen) yang berada dalam Kesatuan Hidrologis Gambut (KHG) di sekitar Taman Nasional Berbak dan hutan lindung gambut Sungai Buluh. Poster menjelaskan latar belakang degradasi gambut akibat kanal perkebunan/HTI, kebakaran berulang, konflik lahan masyarakat-perusahaan, serta kerawanan karhutla, dengan tujuan utama memfasilitasi Perencanaan Penggunaan Lahan Partisipatif (PLUP) untuk mendukung restorasi dan pengelolaan gambut berkelanjutan serta memperkuat kapasitas Masyarakat Peduli Api (MPA). Menggunakan pendekatan pemetaan partisipatif, FGD, teknologi SIG, pelatihan patroli dan pemadaman, poster menyoroti tantangan seperti pendanaan terbatas, konflik kepentingan, dan batas desa yang tidak jelas, sekaligus menampilkan output utama berupa Dokumen Rencana Tata Guna Lahan Partisipatif skenario 20 tahun ke depan serta Dokumen Strategi Penguatan Kapasitas dan Partisipasi MPA, yang semuanya mendukung ekonomi hijau dan pencegahan kebakaran berbasis masyarakat di kawasan gambut Koridor RIMBA.</p>	\N	2025-11-26 08:01:55.627176	2025-11-26 08:01:55.627176
38	10	42	42	[168]	\N	album peta	gambar	\N	<p>&nbsp;</p>\r\n<p>Peta Kluster RIMBA merupakan visualisasi spasial utama Program Koridor RIMBA yang mencakup wilayah seluas &plusmn;9,5 juta hektare di tiga provinsi (Riau, Jambi, dan Sumatera Barat). Peta ini membagi koridor menjadi tiga kluster utama yang saling terhubung secara ekologis:</p>\r\n<p>Klaster I (Utara): Menghubungkan Taman Nasional Bukit Tiga Puluh &ndash; Hutan Lindung Bukit Batabuh &ndash; Suaka Margasatwa Bukit Rimbang Baling &ndash; Suaka Margasatwa Kerumutan hingga kawasan gambut pesisir Riau. Klaster ini menjadi habitat utama harimau sumatra, gajah sumatra, dan tapir, dengan lanskap dominan hutan dataran rendah, hutan r326 rawa gambut, dan kawasan penyangga yang terfragmentasi oleh perkebunan sawit serta HTI.</p>\r\n<p>Klaster II (Tengah-Timur): Berpusat pada Taman Nasional Berbak &ndash; Sembilang dan ekosistem gambut timur Jambi-Riau (KHG Sungai Batanghari &ndash; Sungai Musi). Kawasan ini merupakan benteng terakhir hutan rawa gambut dataran rendah terluas di Sumatra, habitat harimau sumatra, serta jalur migrasi burung air global, namun paling kritis akibat kanal perusahaan, kebakaran berulang, dan konflik tenurial masyarakat-perusahaan.</p>\r\n<p>Klaster III (Barat-Selatan): Menghubungkan Taman Nasional Kerinci Seblat &ndash; Taman Nasional Bukit Barisan Selatan melalui pegunungan Bukit Barisan, hingga kawasan gambut dan hutan kerangas Sumatera Barat. Klaster ini memiliki nilai konservasi tertinggi dengan keanekaragaman hayati pegunungan, harimau sumatra, badak sumatra (populasi terakhir), serta fungsi hidrologi nasional.</p>\r\n<p>Peta ini dilengkapi lapisan informasi penting seperti delineasi Kesatuan Hidrologis Gambut (KHG), koridor satwa liar prioritas (harimau, gajah, jalur migrasi burung), tingkat degradasi dan kebutuhan penanganan (tinggi-sedang-rendah berdasarkan model InVEST &amp; KLHS), kawasan lindung resmi, konsesi perkebunan/HTI/tambang, serta lokasi desa-desa prioritas intervensi PLUP dan MPA. Secara keseluruhan, peta ini menjadi &ldquo;peta jalan&rdquo; utama bagi pemerintah pusat dan daerah, KPH, NGO, serta pemangku kepentingan lainnya untuk menjaga konektivitas ekologi terakhir di Sumatra tengah sekaligus mengintegrasikan pembangunan ekonomi hijau yang inklusif dan berkelanjutan.</p>	\N	2025-11-26 08:04:53.248114	2025-11-26 08:04:53.248114
39	12	42	42	[169]	\N	Poster penyebarluasan informasi kegiatan perwujudan ekonomi hijau dan pelestarian koridor ekosistem RIMBA	dokumen	\N	<p>Poster &ldquo;Paket 12: Pengembangan Model Ekonomi Hijau Berbasis Jasa Lingkungan dan Produk Ramah Lingkungan di Koridor RIMBA&rdquo; (1 halaman) merupakan visual ringkas kegiatan tahun 2024 yang difasilitasi oleh KKI WARSI bersama mitra lokal di Klaster I dan II Koridor RIMBA. Poster menampilkan empat model utama yang telah berhasil dikembangkan dan diuji coba:</p>\r\n<p>1. Madu Hutan Non-Timber (Desa Teluk Nilap &amp; Pulau Muda, Riau) dengan branding &ldquo;Madu Sialang RIMBA&rdquo;, sistem traceability berbasis QR-code, dan peningkatan nilai jual hingga 40%.<br>2. Ekowisata Berbasis Masyarakat (Danau Embat &amp; Seponjen) dengan paket wisata gambut, bird-watching, dan homestay yang melibatkan perempuan dan pemuda lokal.<br>3. Agroforestry Gambut Berkelanjutan (Pandan Makmur &amp; Rantau Panjang) berbasis jelutung, pinang, dan sagu tanpa bakar lahan.<br>4. Perhutanan Sosial Skema Kemitraan Konservasi di kawasan penyangga Taman Nasional Berbak.</p>\r\n<p>Poster menonjolkan hasil nyata berupa peningkatan pendapatan rumah tangga 25&ndash;60%, penurunan praktik pembukaan lahan dengan api hingga 80% di desa dampingan, serta terbangunnya 12 kelompok usaha berbasis perempuan dan pemuda. Dengan tagline &ldquo;Dari Hutan untuk Hutan&rdquo;, poster ini menegaskan bahwa ekonomi hijau bukan hanya sekadar konservasi, tetapi juga menjadi sumber penghidupan alternatif yang layak dan berkelanjutan bagi masyarakat di jantung Koridor RIMBA.</p>	\N	2025-11-26 08:08:13.828679	2025-11-26 08:08:13.828679
40	12	42	42	[170]	\N	Factsheet Burung	dokumen	\N	<p>Factsheet Burung &ndash; Koridor RIMBA&nbsp; merupakan lembar informasi ringkas yang menyoroti kekayaan dan urgensi perlindungan burung di Koridor Ekosistem Riau-Jambi-Sumatera Barat. Factsheet mencatat bahwa koridor seluas &plusmn;9,5 juta ha ini menjadi habitat bagi 327 jenis burung(41% dari total spesies burung Sumatra), termasuk 23 spesies terancam punah global (IUCN Red List) seperti Elang-ular Babi, Rangkong Gading, Kuau Raja, dan Burung Madu Jawa. Khusus di kawasan gambut timur (Taman Nasional Berbak-Sembilang dan sekitarnya) tercatat 198 jenis burung air dan rawa, menjadikannya salah satu jalur migrasi burung air terpenting di Asia Tenggara (East Asian-Australasian Flyway). Factsheet menekankan ancaman utama berupa kebakaran lahan gambut berulang, drainase kanal, dan konversi habitat, serta menampilkan foto ikonik Burung Kuau Raja, Rangkong Papan, dan Burung Madu Bakau. Dengan tagline &ldquo;Satu kebakaran lahan gambut = hilangnya ribuan sarang burung air&rdquo;, factsheet ini mengajak masyarakat dan pemangku kebijakan untuk mendukung restorasi gambut, pencegahan karhutla, dan pengembangan ekowisata birdwatching sebagai bagian dari ekonomi hijau Koridor RIMBA.</p>	\N	2025-11-26 08:12:47.984793	2025-11-26 08:12:47.984793
41	12	42	42	[171]	[]	Factsheet Gajah	dokumen	\N	<p>&nbsp;</p>\r\n<p>merupakan leaflet informasi resmi dari Program Koridor Ekosistem RIMBA (didukung UN Environment Programme dan GEF) yang memuat dua isu konservasi kritis di Pulau Sumatera. Halaman pertama menyoroti penurunan drastis populasi gajah Sumatera (Elephas maximus sumatranus) di Bentang Alam Bukit Tigapuluh (Riau-Jambi) dari 143 ekor (2011) menjadi hanya 90&ndash;120 ekor (2024) akibat deforestasi, fragmentasi habitat, konflik manusia-gajah, perburuan, dan perkawinan sedarah, disertai peta sebaran habitat yang semakin terjepit oleh perkebunan serta usulan solusi jangka pendek (penguatan APU) dan jangka panjang (penetapan Kawasan Ekosistem Esensial Gajah oleh gubernur). Halaman kedua dan ketiga beralih ke status harimau Sumatera (Panthera tigris sumatrae) di Taman Nasional Kerinci Seblat dan sekitarnya, dengan estimasi populasi 2024 sekitar 150&ndash;180 ekor, ancaman utama berupa perburuan, perdagangan satwa, deforestasi, fragmentasi habitat, dan penyakit, serta peta lokasi konflik satwa-manusia yang intens di koridor barat TNKS; dokumen ini juga menekankan peran strategis ATR/BPN dan lima upaya kolaboratif (patroli, kajian KEE, rehabilitasi habitat, edukasi masyarakat, dan penegakan hukum) untuk menjaga kelestarian harimau sebagai spesies payung hutan Sumatera. Secara keseluruhan, leaflet ini menjadi seruan mendesak untuk aksi bersama melindungi dua spesies ikonik yang terancam punah di dua bentang alam penting Sumatera.</p>	\N	2025-11-26 08:22:32.058182	2025-11-26 08:27:22.680564
42	12	42	42	[172]	[]	Factsheet Harimau	dokumen	\N	<p>&nbsp;</p>\r\n<p>Factsheet Harimau.adalah lembar fakta resmi Program Koridor Ekosistem RIMBA (didukung UN Environment Programme dan GEF) yang menggambarkan kondisi kritis harimau Sumatera (Panthera tigris sumatrae) di Taman Nasional Kerinci Seblat (TNKS) dan bentang alam sekitarnya. Dokumen menyatakan populasi harimau di TNKS pada 2024 diperkirakan hanya 150&ndash;180 ekor (turun dari estimasi sebelumnya 150&ndash;180+), dengan ancaman utama berupa perburuan dan perdagangan satwa (jerat masih menjadi penyebab kematian terbanyak), deforestasi, fragmentasi habitat, penyakit (terutama ancaman CDV dari anjing), serta konflik intens dengan manusia yang terlihat dari peta titik-titik merah konflik satwa di koridor barat TNKS. Factsheet menekankan peran TNKS sebagai &ldquo;rumah terakhir&rdquo; hutan Sumatera yang masih utuh serta mengajukan lima upaya kolaboratif mendesak: (1) patroli intensif dan penyelamatan harimau, (2) kajian dan penetapan Kawasan Ekosistem Esensial, (3) rehabilitasi habitat yang terdegradasi, (4) edukasi dan pemberdayaan masyarakat, serta (5) penegakan hukum tegas terhadap pelaku kejahatan satwa liar; disertai pula penjelasan peran strategis ATR/BPN dalam penguatan tata ruang, kepastian hukum tanah, dan pemanfaatan teknologi One Map Policy untuk konservasi efektif. Secara keseluruhan, factsheet ini adalah seruan darurat untuk aksi bersama menyelamatkan harimau Sumatera sebagai spesies payung sebelum populasi dan habitatnya lenyap sepenuhnya.</p>	\N	2025-11-26 08:26:53.338173	2025-11-26 16:06:28.081427
58	30	42	42	[281]	\N	Ekonomi Hijau & Bisnis Berkelanjutan di Wilayah Desa Gambut 10	dokumen	\N	<p><span class="citation-60">Ekonomi hijau di wilayah desa gambut merupakan pendekatan pembangunan integratif yang menyatukan kesejahteraan sosial, efisiensi ekonomi, dan pelestarian lingkungan melalui pergeseran paradigma dari praktik destruktif ke sistem produksi rendah emisi</span><span class="citation-60 citation-end-60"><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-59">Strategi ini menitikberatkan pada perlindungan fungsi ekologis gambut sebagai penyimpan karbon dan pengatur tata air dengan menghindari pembukaan lahan dengan api serta penggunaan drainase berlebih yang dapat memicu kebakaran</span><span class="citation-59 citation-end-59"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="0,7">. </span><span class="citation-58">Implementasinya mencakup pengembangan berbagai model bisnis berkelanjutan seperti agroforestri rawa (kombinasi jelutung atau sagu dengan tanaman pangan), budidaya komoditas ramah gambut (kopi liberika, purun, nanas), serta perikanan dan ekowisata rawa yang tidak merusak hidrologi gambut</span><span class="citation-58 citation-end-58"><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="0,11">. </span><span class="citation-57">Melalui dukungan regulasi seperti Peraturan Gubernur Jambi Nomor 7 Tahun 2024 dan kolaborasi multipihak, ekonomi hijau bertujuan menciptakan masa depan desa yang tangguh, produktif, dan berkelanjutan bagi masyarakat di sekitar ekosistem gambut</span><span class="citation-57 citation-end-57"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="0,15">.</span></p>	\N	2025-12-21 16:44:54.955369	2025-12-21 16:44:54.955369
52	26	42	42	[269]	\N	Laporan Kegiatan Riau	dokumen	\N	<p data-path-to-node="0">Laporan Kegiatan Kunjungan Daerah ke Provinsi Riau ini mendokumentasikan rangkaian upaya fasilitasi untuk mengintegrasikan pendekatan ekonomi hijau ke dalam dokumen rencana tata ruang dan rencana pembangunan daerah di kawasan Koridor Ekosistem RIMBA. Kunjungan yang dilaksanakan pada 15-16 September 2025 ini berfokus pada koordinasi strategis dengan pemerintah daerah guna menyelaraskan program pelestarian lingkungan dengan pertumbuhan ekonomi yang rendah karbon. Kegiatan ini menjadi krusial mengingat posisi Riau sebagai bagian penting dari koridor ekologis yang menghadapi tantangan besar dalam pengelolaan sumber daya alam.</p>\r\n<p data-path-to-node="1">Dalam pelaksanaannya, laporan ini merinci proses diskusi kelompok terarah (<em data-path-to-node="1" data-index-in-node="75">Focus Group Discussion</em>) yang melibatkan berbagai pemangku kepentingan di tingkat provinsi dan kabupaten, termasuk Kabupaten Kuantan Singingi. Dokumen ini memuat identifikasi isu-isu strategis di lapangan, draf sinkronisasi kebijakan spasial, serta langkah-langkah tindak lanjut untuk memperkuat perlindungan habitat satwa prioritas melalui instrumen ekonomi hijau. Hasil kunjungan ini diharapkan dapat mempercepat adopsi prinsip berkelanjutan dalam kebijakan pembangunan daerah demi menjaga konektivitas ekosistem RIMBA secara jangka panjang.</p>	2026-01-09 02:34:13.678037	2025-12-20 03:52:09.86133	2025-12-20 03:52:09.86133
56	30	42	42	[279]	\N	Bahan Ajar – Penjangkauan Perubahan Perilaku Kebakaran Gambut 10	dokumen	\N	<p><span class="citation-15">Bahan ajar ini menguraikan strategi komprehensif dalam penanggulangan kebakaran gambut di Indonesia dengan menitikberatkan pada perubahan perilaku dan kolaborasi multipihak antara pemerintah, sektor swasta, dan masyarakat</span><span class="citation-15 citation-end-15"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-14">Fokus utama diberikan kepada Masyarakat Peduli Api (MPA) sebagai garda terdepan di tingkat desa yang berperan dalam patroli, deteksi dini, dan pemadaman awal, meski mereka masih menghadapi kendala teknis, peralatan, serta legalitas kelembagaan</span><span class="citation-14 citation-end-14"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="0,7">. </span><span class="citation-13">Melalui analisis faktor pengetahuan, motivasi, dan partisipasi, modul ini menawarkan rencana aksi yang mencakup penguatan kapasitas teknis, penyediaan infrastruktur seperti sekat kanal, pengakuan formal MPA melalui peraturan desa, hingga pemberian insentif ekonomi produktif bagi desa bebas api</span><span class="citation-13 citation-end-13"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="0,11">. </span><span class="citation-12">Dengan mengintegrasikan teknologi pelaporan dan praktik pembukaan lahan tanpa bakar (zero burning), diharapkan tercipta kesadaran kolektif untuk mewujudkan desa yang mandiri dan tangguh terhadap ancaman kebakaran gambut secara berkelanjutan</span><span class="citation-12 citation-end-12"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span></p>	\N	2025-12-21 16:42:53.541158	2025-12-21 16:42:53.541158
57	30	42	42	[280]	\N	Bahan Ajar Konflik Tenurial di Wilayah Gambut 10	dokumen	\N	<p><span class="citation-39">ahan ajar ini menguraikan problematika konflik tenurial di wilayah gambut Indonesia sebagai sengketa hak kepemilikan, penguasaan, dan akses lahan yang melibatkan berbagai aktor seperti masyarakat, pemerintah, dan sektor swasta</span><span class="citation-39 citation-end-39"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-38">Konflik ini dipicu oleh akar permasalahan yang kompleks, termasuk tumpang tindih perizinan di atas lahan masyarakat, ketidakjelasan batas wilayah, lemahnya pengakuan hak masyarakat adat, serta masuknya investasi skala besar</span><span class="citation-38 citation-end-38"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="0,7">. </span><span class="citation-37">Dampaknya sangat signifikan, mulai dari ketegangan sosial dan penurunan pendapatan ekonomi hingga kerusakan lingkungan yang serius seperti kebakaran gambut dan gangguan struktur hidrologi</span><span class="citation-37 citation-end-37"><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="0,11">. </span><span class="citation-36">Sebagai solusi strategis, modul ini menekankan peran Gugus Tugas Reforma Agraria (GTRA) berdasarkan payung hukum UU Pokok Agraria serta Perpres Nomor 86 Tahun 2018 dan Nomor 62 Tahun 2023 untuk menata aset, memberikan akses tanah bagi masyarakat miskin, dan memfasilitasi penyelesaian sengketa</span><span class="citation-36 citation-end-36"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="0,15">. </span><span class="citation-35">Melalui rencana aksi spesifik di tingkat desa, seperti di Desa Pandan Sejahtera dan Rantau Panjang, diharapkan tercipta langkah penyelesaian yang integratif dengan mempertimbangkan aspek hukum, sosial, dan keberlanjasan ekosistem gambut</span><span class="citation-35 citation-end-35"><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup></span><span data-path-to-node="0,19">.</span></p>	\N	2025-12-21 16:43:58.259705	2025-12-21 16:43:58.259705
59	30	42	42	[282]	\N	 Perilaku,Rencana Aksi, Strategi MPA	dokumen	\N	<p style="text-align: justify;"><span class="citation-84">Materi ini menyajikan strategi komprehensif untuk memperkuat kapasitas Masyarakat Peduli Api (MPA) dalam upaya pemulihan ekosistem gambut dan pengelolaan hutan berkelanjutan melalui pendekatan perubahan perilaku</span><span class="citation-84 citation-end-84"><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-83">Dokumen ini menyoroti peran krusial MPA sebagai ujung tombak dalam pencegahan, deteksi dini, dan pemadaman awal kebakaran di tingkat desa, didukung oleh data bahwa tingkat pengetahuan dan motivasi anggota MPA saat ini sudah tergolong tinggi</span><span class="citation-83 citation-end-83"><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="0,7">. </span><span class="citation-82">Namun, efektivitas mereka masih terhambat oleh tantangan struktural seperti minimnya dana operasional, peralatan yang tidak memadai, serta kelembagaan yang belum terintegrasi secara formal dalam struktur desa</span><span class="citation-82 citation-end-82"><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="0,11">. </span><span class="citation-81">Untuk mengatasi hal tersebut, rencana aksi yang diusulkan mencakup penguatan kapasitas melalui sertifikasi keahlian, penyediaan infrastruktur seperti sekat kanal dan aplikasi pelaporan teknologi, serta integrasi MPA ke dalam kebijakan daerah guna memastikan perlindungan sosial dan pendanaan yang berkelanjutan</span><span class="citation-81 citation-end-81"><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="0,15">. </span><span class="citation-80">Sinergi antara pemerintah, sektor swasta, dan masyarakat melalui strategi terpadu ini menjadi kunci utama dalam menciptakan sistem pencegahan kebakaran yang lebih adaptif dan berkelanjutan di wilayah gambut</span><span class="citation-80 citation-end-80"><sup class="superscript" data-turn-source-index="5"><!----></sup></span><span data-path-to-node="0,19">.</span></p>	\N	2025-12-21 16:46:01.867299	2025-12-21 16:46:01.867299
60	30	42	42	[283]	\N	Pembasahan Kembali Gambut – Bahan Ajar Klaster 2	dokumen	\N	<p style="text-align: justify;"><span data-path-to-node="0,1"><span class="citation-97">Bahan ajar ini membahas urgensi dan teknik pembasahan kembali (</span><em data-path-to-node="0,1" data-index-in-node="63"><span class="citation-97">rewetting</span></em><span class="citation-97">) sebagai bagian integral dari restorasi ekosistem gambut di Klaster 2 Koridor Ekosistem RIMBA</span></span><span class="citation-97 citation-end-97"><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-96">Fokus utamanya adalah memulihkan hidrologi gambut yang rusak akibat drainase guna memitigasi risiko kebakaran, menekan laju subsidensi lahan, dan mengurangi emisi gas rumah kaca</span><span class="citation-96 citation-end-96"><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="0,7">. </span><span data-path-to-node="0,9"><span class="citation-95">Modul ini menjelaskan berbagai infrastruktur pembasahan gambut (IPG), seperti pembangunan sekat kanal dan embung, serta metodologi pemetaan prioritas pembasahan yang menggunakan data ketebalan gambut, titik panas (</span><em data-path-to-node="0,9" data-index-in-node="214"><span class="citation-95">hotspot</span></em><span class="citation-95">), dan jaringan kanal di desa-desa prioritas seperti Pandan Sejahtera, Pandan Makmur, Rantau Panjang, dan Seponjen</span></span><span class="citation-95 citation-end-95"><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="0,11">. </span><span class="citation-94">Selain aspek teknis, materi ini menekankan pentingnya peran strategis Kesatuan Pengelolaan Hutan (KPH) dan koordinasi multipihak yang dipetakan melalui matriks RACI untuk memastikan keberlanjutan pemeliharaan infrastruktur dan partisipasi aktif masyarakat lokal dalam menjaga tata air gambut</span><span class="citation-94 citation-end-94"><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="0,15">.</span></p>	\N	2025-12-21 16:47:24.569786	2025-12-21 16:47:24.569786
61	30	42	42	[284]	\N	Perubahan Perilaku dalam Pencegahan dan Pemadaman Kebakaran Gambut 	dokumen	\N	<p style="text-align: justify;"><span class="citation-111">Modul ini memfokuskan pada penguatan peran Masyarakat Peduli Api (MPA) sebagai garda terdepan dalam upaya pencegahan dan pemadaman kebakaran di desa-desa gambut</span><span class="citation-111 citation-end-111"><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-110">Dokumen ini menjelaskan bahwa keberhasilan pengendalian kebakaran sangat bergantung pada perubahan perilaku manusia, yang diukur melalui tiga indikator utama: tingkat pengetahuan mengenai penyebab dan dampak kebakaran, motivasi internal maupun eksternal (insentif), serta partisipasi aktif dalam patroli dan pengambilan keputusan</span><span class="citation-110 citation-end-110"><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="0,7">. </span><span class="citation-109">Tantangan utama yang diidentifikasi meliputi keterbatasan alat keselamatan, ketiadaan dana operasional tetap, dan perlunya pengakuan formal MPA melalui Peraturan Desa agar dapat mengakses pendanaan APBDes</span><span class="citation-109 citation-end-109"><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="0,11">. </span><span class="citation-108">Rencana aksi yang diusulkan mencakup penguatan kapasitas teknis, pembangunan infrastruktur pembasahan seperti sekat kanal dan embung, serta pemberian insentif ekonomi produktif bagi masyarakat yang berhasil menjaga desanya dari api</span><span class="citation-108 citation-end-108"><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="0,15">. </span><span data-path-to-node="0,17"><span class="citation-107">Melalui pendekatan </span><em data-path-to-node="0,17" data-index-in-node="19"><span class="citation-107">zero burning</span></em><span class="citation-107"> dan edukasi yang tepat, diharapkan terjadi transformasi perilaku masyarakat dari praktik pembukaan lahan dengan api menuju pengelolaan lahan gambut yang ramah lingkungan dan berkelanjutan</span></span><span class="citation-107 citation-end-107"><sup class="superscript" data-turn-source-index="5"><!----></sup></span><span data-path-to-node="0,19">.</span></p>	\N	2025-12-21 16:48:33.868984	2025-12-21 16:48:33.868984
62	30	42	42	[285]	\N	Peta Perencanaan Koridor Ekosistem Rimba di Pulau Sumatera	gambar	\N	<p style="text-align: justify;">Gambar tersebut menampilkan peta perencanaan wilayah konservasi yang disebut sebagai <strong data-path-to-node="1" data-index-in-node="85">Koridor Ekosistem Rimba</strong>, mencakup area lintas provinsi di Sumatera, yaitu Riau, Jambi, dan Sumatera Barat. Peta ini terbagi menjadi tiga panel utama: sisi kiri menunjukkan orientasi makro di sepanjang pulau Sumatera dengan garis batas merah yang menandai area koridor, sementara dua panel di sisi kanan memberikan tampilan detail (zoom-in) pada <strong data-path-to-node="1" data-index-in-node="430">Cluster II Koridor Rimba</strong>. Area yang diperbesar tersebut secara spesifik menyoroti lokasi perencanaan di tingkat desa yang terletak di wilayah administrasi Kabupaten Tanjung Jabung Timur, Kabupaten Muaro Jambi, dan sekitarnya. Dengan menggunakan latar belakang citra satelit, peta ini memperlihatkan tutupan lahan hijau yang luas dan jaringan hidrologi sungai, yang menegaskan fokus proyek pada pengelolaan lanskap hutan dan konektivitas ekosistem di wilayah tersebut.</p>	\N	2025-12-21 16:50:11.535802	2025-12-21 16:50:11.535802
63	30	42	42	[286]	\N	Struktur Operasional Pokja Restorasi Gambut dan Pengelolaan Kawasan	gambar	\N	<h3 data-path-to-node="0"><strong data-path-to-node="0" data-index-in-node="0">Struktur Operasional Pokja Restorasi Gambut dan Pengelolaan Kawasan</strong></h3>\r\n<p data-path-to-node="1">Infografis ini menyajikan struktur kerja yang terbagi ke dalam lima Kelompok Kerja (Pokja) dengan fokus strategis pada pelestarian ekosistem gambut dan koordinasi antarlembaga. Setiap Pokja memiliki tanggung jawab spesifik, mulai dari <strong data-path-to-node="1" data-index-in-node="235">Pokja 1</strong> yang menangani hidrologi dan restorasi gambut melalui BPDAS, <strong data-path-to-node="1" data-index-in-node="304">Pokja 2</strong> yang berfokus pada tata ruang dan legalitas di bawah Dinas PUPR, hingga <strong data-path-to-node="1" data-index-in-node="384">Pokja 3</strong> yang membidangi penghidupan berkelanjutan melalui Dinas Perkebunan. Lebih lanjut, upaya perlindungan diperkuat oleh <strong data-path-to-node="1" data-index-in-node="508">Pokja 4</strong> yang menangani Karhutla (Kebakaran Hutan dan Lahan) bersama Manggala Agni dan BPBD, serta <strong data-path-to-node="1" data-index-in-node="606">Pokja 5</strong> yang berfungsi sebagai pusat informasi, data, dan pembiayaan di bawah koordinasi UNJA dan Sekretariat Forum. Secara keseluruhan, diagram ini menunjukkan pendekatan multisektoral yang mengintegrasikan aspek teknis lingkungan, hukum, ekonomi masyarakat, dan mitigasi bencana dalam satu garis koordinasi yang sistematis.</p>\r\n<hr data-path-to-node="2">\r\n<p data-path-to-node="3"><strong data-path-to-node="3" data-index-in-node="0">Rincian Tugas Berdasarkan Gambar:</strong></p>\r\n<ul data-path-to-node="4">\r\n<li>\r\n<p data-path-to-node="4,0,0"><strong data-path-to-node="4,0,0" data-index-in-node="0">Pokja 1 (Hidrologi &amp; Restorasi Gambut):</strong> Penataan blok hidrologis, tata air, dan restorasi gambut.</p>\r\n</li>\r\n<li>\r\n<p data-path-to-node="4,1,0"><strong data-path-to-node="4,1,0" data-index-in-node="0">Pokja 2 (Tata Ruang &amp; Legalitas):</strong> Sinkronisasi RTRW/RDTR, penataan zona lindung, dan mitigasi konflik ruang.</p>\r\n</li>\r\n<li>\r\n<p data-path-to-node="4,2,0"><strong data-path-to-node="4,2,0" data-index-in-node="0">Pokja 3 (Penghidupan Berkelanjutan):</strong> Diversifikasi usaha ramah gambut dan integrasi pendanaan CSR.</p>\r\n</li>\r\n<li>\r\n<p data-path-to-node="4,3,0"><strong data-path-to-node="4,3,0" data-index-in-node="0">Pokja 4 (Karhutla &amp; Kedaruratan):</strong> Pencegahan karhutla, sistem peringatan dini, dan patroli.</p>\r\n</li>\r\n<li>\r\n<p data-path-to-node="4,4,0"><strong data-path-to-node="4,4,0" data-index-in-node="0">Pokja 5 (Informasi, Data &amp; Pembiayaan):</strong> Sistem data terpadu KHG dan monitoring kinerja forum.</p>\r\n</li>\r\n</ul>	\N	2025-12-21 16:51:50.198244	2025-12-21 16:51:50.198244
64	30	42	42	[287]	\N	Penguatan Forum Konservasi Gajah dan Lanskap Bukit Tigapuluh	gambar	\N	<p style="text-align: justify;">nfografis ini merinci strategi penguatan "Forum Gajah Lanskap Bukit Tigapuluh - Tebo - Tanjabbar" sebagai upaya preservasi habitat gajah di wilayah tersebut. Struktur koordinasi ini didasarkan pada legitimasi hukum melalui SK Gubernur untuk memastikan sinergi antar-instansi, dengan sekretariat yang dikelola melalui model konsorsium multipihak di bawah kepemimpinan Universitas Jambi (UNJA). Fokus utama forum ini mencakup empat pilar strategis: menjamin konektivitas habitat, melakukan mitigasi konflik antara gajah dan manusia, memulihkan areal konservasi di dalam konsesi PBPH (Perizinan Berusaha Pemanfaatan Hutan), serta melindungi koridor hutan dari ancaman perambahan lahan dan pembukaan kebun baru. Secara keseluruhan, dokumen ini menekankan pentingnya pendekatan kolaboratif yang terlembagakan untuk menjaga keberlangsungan ekosistem gajah di tengah tekanan aktivitas manusia dan perubahan penggunaan lahan.</p>	\N	2025-12-21 16:52:54.883685	2025-12-21 16:52:54.883685
67	25	1	1	[291]	[]	Modul Investasi Perdagangan Karbon APL Kawasan RIMBA	dokumen	\N	<p><span class="citation-29">Modul Investasi Perdagangan Karbon di Koridor Ekosistem RIMBA merupakan panduan strategis yang bertujuan untuk memfasilitasi investasi berbasis pasar karbon di wilayah Provinsi Riau, Jambi, dan Sumatera Barat, dengan fokus utama pada pemanfaatan Area Penggunaan Lain (APL)</span><span data-path-to-node="0,3">. </span><span class="citation-28">Dokumen ini menyoroti bahwa dari total 3,8 juta hektar lanskap RIMBA, terdapat 1,38 juta hektar (35,78%) lahan APL yang memiliki potensi mitigasi signifikan, terutama pada tutupan lahan perkebunan campuran dan semak belukar yang menyimpan nilai karbon tinggi</span><span data-path-to-node="0,7">. </span><span data-path-to-node="0,9"><span class="citation-27">Implementasi investasi ini difokuskan pada </span><em data-path-to-node="0,9" data-index-in-node="43"><span class="citation-27">Nature-based Solutions</span></em><span class="citation-27"> (NBS) yang bersifat regeneratif, seperti penggunaan biochar untuk meningkatkan karbon tanah, restorasi mangrove, serta pengembangan agroforestri guna memaksimalkan penyimpanan</span></span><span data-path-to-node="0,11">&nbsp;</span><span class="citation-26">Keberhasilan program ini didorong melalui kolaborasi multi-pihak yang melibatkan pemerintah pusat, daerah, serta lembaga internasional untuk menciptakan ekonomi hijau yang memberikan manfaat nyata bagi lingkungan, sosial, dan ekonomi masyarakat lokal</span></p>	\N	2025-12-22 04:19:29.048602	2025-12-22 08:04:31.508249
68	36	1	1	[293]	\N	Modul Investasi Perdagangan Karbon APL Kawasan RIMBA	dokumen	\N	<p><span class="citation-7">Modul Investasi Perdagangan Karbon di Koridor Ekosistem RIMBA merupakan panduan strategis yang bertujuan untuk memfasilitasi investasi berbasis pasar karbon di wilayah Provinsi Riau, Jambi, dan Sumatera Barat, dengan fokus utama pada pemanfaatan Area Penggunaan Lain (APL)</span><span data-path-to-node="0,3">. </span><span class="citation-6">Dokumen ini menyoroti bahwa dari total 3,8 juta hektar lanskap RIMBA, terdapat 1,38 juta hektar (35,78%) lahan APL yang memiliki potensi mitigasi signifikan, terutama pada tutupan lahan perkebunan campuran dan semak belukar yang menyimpan nilai karbon tinggi</span><span data-path-to-node="0,7">. </span><span data-path-to-node="0,9"><span class="citation-5">Implementasi investasi ini difokuskan pada </span><em data-path-to-node="0,9" data-index-in-node="43"><span class="citation-5">Nature-based Solutions</span></em><span class="citation-5"> (NBS) yang bersifat regeneratif, seperti penggunaan biochar untuk meningkatkan karbon tanah, restorasi mangrove, serta pengembangan agroforestri guna memaksimalkan penyimpanan,</span></span><span data-path-to-node="0,11">&nbsp;</span><span class="citation-4">Keberhasilan program ini didorong melalui kolaborasi multi-pihak yang melibatkan pemerintah pusat, daerah, serta lembaga internasional untuk menciptakan ekonomi hijau yang memberikan manfaat nyata bagi lingkungan, sosial, dan ekonomi masyarakat lokal</span></p>\r\n<p>&nbsp;</p>	\N	2025-12-22 09:40:25.560584	2025-12-22 09:40:25.560584
5	13	1	1	\N	\N	Contoh Materi VIDEO	video	https://www.youtube.com/embed/cLPl5bHgYWI?start=1	<p><span class="yt-core-attributed-string--link-inherit-color" dir="auto">Dari langkah awal menjaga bentang alam, kini Koridor Ekosistem RIMBA terus melangkah menuju masa depan yang lebih terhubung. Hutan yang menyatu, sungai yang bernyawa, masyarakat yang berdaya. ⠀ Saksikan rangkuman perjalanan Program Koridor Ekosistem RIMBA. Yuk Kenali, hayati, dan jaga bersama! </span></p>\r\n<p><span class="yt-core-attributed-string--link-inherit-color" dir="auto"><a class="yt-core-attributed-string__link yt-core-attributed-string__link--call-to-action-color" tabindex="0" href="https://www.youtube.com/hashtag/proyekrimba" target="">#ProyekRIMBA</a></span> <span class="yt-core-attributed-string--link-inherit-color" dir="auto"><a class="yt-core-attributed-string__link yt-core-attributed-string__link--call-to-action-color" tabindex="0" href="https://www.youtube.com/hashtag/ditjentataruang" target="">#DitjenTataRuang</a></span> <span class="yt-core-attributed-string--link-inherit-color" dir="auto"><a class="yt-core-attributed-string__link yt-core-attributed-string__link--call-to-action-color" tabindex="0" href="https://www.youtube.com/hashtag/bersamamenataruang" target="">#BersamaMenataRuang</a></span></p>	2025-12-22 14:35:22.03345	2025-11-04 03:44:55.627316	2025-11-04 03:44:55.627316
66	33	42	42	[289]	\N	Laporan Antara Peluang Investasi Ekonomi Hijau Koridor Rimba	dokumen	\N	<p style="text-align: justify;">Laporan Antara untuk kegiatan "Kajian Peluang Investasi Ekonomi Hijau di Kawasan Ekosistem RIMBA" merupakan dokumen yang memetakan potensi dan peluang investasi berbasis lanskap alam (nature-based investment) di wilayah seluas 3,8 juta hektar yang mencakup Provinsi Riau, Jambi, dan Sumatera Barat. Fokus utama kajian ini terletak pada empat kabupaten representatif, yaitu Kuantan Singingi, Sijunjung, Muaro Jambi, dan Merangin, yang dipilih untuk memberikan gambaran peluang investasi hijau dari berbagai klaster di wilayah tersebut. Struktur laporan ini terdiri dari tujuh bab utama yang diawali dengan pendahuluan, tinjauan kebijakan nasional hingga kabupaten, serta metodologi pelaksanaan yang menggunakan instrumen Integrated Model Sustainable Land-Economic Planning (IM-SLEP). Bagian inti laporan menyajikan gambaran umum wilayah, identifikasi potensi melalui analisis sektor unggulan (seperti LQ dan Shift-share), hingga analisis mendalam mengenai peluang investasi di sektor-sektor strategis seperti carbon credit, agroforestri sawit, pariwisata berkelanjutan (geopark dan candi), jasa lingkungan air minum (AMDK), serta teknologi pengolahan limbah sawit. Laporan ini ditutup dengan analisis kelembagaan, pemetaan pemangku kepentingan, serta identifikasi investor potensial untuk mendukung implementasi ekonomi hijau di Kawasan RIMBA</p>	2026-01-09 02:33:50.035716	2025-12-21 16:59:13.364618	2025-12-21 16:59:13.364618
6	13	1	1	[106]	\N	Contoh Materi DOKUMEN	dokumen	\N	<div class="paragraph normal ng-star-inserted" data-start-index="0"><span class="ng-star-inserted" data-start-index="0">RIMBA adalah singkatan dari Riau&ndash;Jambi&ndash;Sumatera Barat</span><span class="ng-star-inserted" data-start-index="53">, yang merupakan nama untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="81">Program Koridor Ekosistem RIMBA</strong><span class="ng-star-inserted" data-start-index="112">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="113"><span class="ng-star-inserted" data-start-index="113">Program RIMBA adalah inisiatif kerja sama hibah internasional antara Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (Kementerian ATR/BPN) dengan </span><em class="ng-star-inserted" data-start-index="272">United Nations Environment Programme &ndash; Global Environment Facility</em><span class="ng-star-inserted" data-start-index="338"> (UNEP&ndash;GEF)</span><span class="ng-star-inserted" data-start-index="349">.&nbsp;</span></div>	2025-12-22 14:35:22.03345	2025-11-04 03:46:36.005053	2025-11-04 03:46:36.005053
3	13	1	1	[]	[]	Contoh Materi TEXT	text	\N	<div class="paragraph normal ng-star-inserted" data-start-index="0"><span class="ng-star-inserted" data-start-index="0">RIMBA adalah singkatan dari Riau&ndash;Jambi&ndash;Sumatera Barat</span><span class="ng-star-inserted" data-start-index="53">, yang merupakan nama untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="81">Program Koridor Ekosistem RIMBA</strong><span class="ng-star-inserted" data-start-index="112">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="113"><span class="ng-star-inserted" data-start-index="113">Program RIMBA adalah inisiatif kerja sama hibah internasional antara Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (Kementerian ATR/BPN) dengan </span><em class="ng-star-inserted" data-start-index="272">United Nations Environment Programme &ndash; Global Environment Facility</em><span class="ng-star-inserted" data-start-index="338"> (UNEP&ndash;GEF)</span><span class="ng-star-inserted" data-start-index="349">. Program ini bertujuan untuk&nbsp;</span><strong class="ng-star-inserted" data-start-index="379">memperkuat konektivitas ekosistem hutan</strong><span class="ng-star-inserted" data-start-index="418"> di bentang alam yang mencakup wilayah tiga provinsi (Riau, Jambi, dan Sumatera Barat)</span><span class="ng-star-inserted" data-start-index="504"> dengan total luas sekitar 3,8 juta hektar</span><span class="ng-star-inserted" data-start-index="546">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="547"><span class="ng-star-inserted" data-start-index="547">Kawasan RIMBA berfungsi sebagai koridor ekologis yang menghubungkan beberapa taman nasional dan suaka margasatwa</span><span class="ng-star-inserted" data-start-index="659">, menjadikannya habitat penting bagi satwa kunci seperti gajah dan harimau sumatra, sekaligus menyimpan cadangan karbon yang signifikan</span><span class="ng-star-inserted" data-start-index="794">. Visi program ini adalah memperkuat konektivitas ekosistem melalui investasi pada modal alam, konservasi keanekaragaman hayati, dan pengurangan emisi berbasis lahan dengan pendekatan&nbsp;</span><strong class="ng-star-inserted" data-start-index="978">pembangunan ekonomi hijau</strong><span class="ng-star-inserted" data-start-index="1003"> yang berkelanjutan dan berbasis data</span><span class="ng-star-inserted" data-start-index="1040">. Program RIMBA dirancang untuk menjadi model integrasi tata ruang, konservasi, dan pembangunan ekonomi hijau di Indonesia</span><span class="ng-star-inserted" data-start-index="1162">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1163">&nbsp;</div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1245"><span class="ng-star-inserted" data-start-index="1245">Untuk mendukung visi tersebut, RIMBA mengembangkan </span><strong class="ng-star-inserted" data-start-index="1296">Sistem Informasi RIMBA</strong><span class="ng-star-inserted" data-start-index="1318"> yang terintegrasi, adaptif, dan berbasis data</span><span class="ng-star-inserted" data-start-index="1364">. Anda dapat menjelajahi bagaimana sistem ini mendukung tata kelola ruang dan sumber daya alam yang transparan</span><span class="ng-star-inserted" data-start-index="1474"> melalui instrumen digital baru, seperti:</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1515"><span class="ng-star-inserted">&bull; </span><strong class="ng-star-inserted" data-start-index="1515">Modul Investasi Perdagangan Karbon</strong><span class="ng-star-inserted" data-start-index="1549">, yang menyediakan panduan teknis penyusunan skema perdagangan karbon di kawasan RIMBA, khususnya di Areal Penggunaan Lain (APL)</span><span class="ng-star-inserted" data-start-index="1677">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1678"><span class="ng-star-inserted">&bull; </span><strong class="ng-star-inserted" data-start-index="1678">Aplikasi Kepatuhan Ekonomi Hijau</strong><span class="ng-star-inserted" data-start-index="1710">, yang memantau tingkat kepatuhan perusahaan berbasis sumber daya alam terhadap prinsip-prinsip ekonomi hijau</span><span class="ng-star-inserted" data-start-index="1819">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1820"><span class="ng-star-inserted">&bull; </span><strong class="ng-star-inserted" data-start-index="1820">Aplikasi Pengukuran Dampak Aktual Proyek</strong><span class="ng-star-inserted" data-start-index="1860">, yang mengukur dampak proyek berdasarkan empat aspek utama: tata kelola, ekologi, sosial, dan ekonomi</span><span class="ng-star-inserted" data-start-index="1962">.</span></div>\r\n<div class="paragraph normal ng-star-inserted" data-start-index="1963"><span class="ng-star-inserted">&bull; </span><strong class="ng-star-inserted" data-start-index="1963">Knowledge Management Information System (KMIS)</strong><span class="ng-star-inserted" data-start-index="2009">, yang berfungsi sebagai pusat data, analisis, dan wahana pembelajaran pengetahuan mengenai praktik pembangunan ekonomi hijau</span><span class="ng-star-inserted" data-start-index="2134">.</span></div>	2025-12-22 14:35:22.03345	2025-11-04 03:35:18.337586	2025-12-19 04:20:20.572739
70	13	1	1	\N	\N	Test 2	text	\N	<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at velit risus. Morbi eget tincidunt diam. Nulla ipsum metus, sollicitudin vehicula neque nec, porta consequat ante. Cras tempor sollicitudin leo, eget eleifend ligula pharetra ut. Integer non convallis leo, a malesuada lacus. Nulla facilisis condimentum urna, ac condimentum urna imperdiet eu. Ut eget nulla congue, dictum massa a, laoreet leo. Fusce faucibus orci velit, sit amet mollis nulla scelerisque nec. Integer id nibh in eros aliquet convallis. Fusce ullamcorper porttitor arcu non eleifend. Mauris sit amet mi quis sem luctus mollis. Duis eget sodales tortor. Cras at dictum nisi, volutpat tempor augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce vitae erat nibh.</p>\r\n<p>Vivamus tempor quam sed tincidunt tristique. Cras iaculis laoreet mattis. Quisque scelerisque accumsan convallis. Cras nulla lorem, egestas vel ullamcorper quis, imperdiet ac est. Donec sollicitudin nulla diam, vitae elementum metus dapibus vel. Phasellus non eleifend arcu. Maecenas ac elit rhoncus, varius erat quis, vulputate turpis. Vestibulum fringilla pretium dolor, at elementum elit dictum id. Fusce interdum tellus ac sollicitudin pretium. Etiam posuere mauris nec pulvinar mattis. Vestibulum laoreet venenatis convallis. Cras blandit elit a mi lacinia imperdiet.</p>\r\n<p>Aliquam finibus nisl massa, sit amet auctor risus commodo quis. Morbi finibus, dolor at laoreet vulputate, eros risus vehicula ipsum, non bibendum elit erat non erat. Vivamus nulla leo, consequat nec turpis sit amet, rutrum vulputate quam. Pellentesque tellus dui, vestibulum in ante id, dapibus euismod magna. Integer eget sapien nibh. Vivamus tortor lectus, molestie sodales tristique sit amet, venenatis pulvinar nulla. Nulla vitae felis molestie orci consequat tincidunt eget vel libero. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin posuere turpis a turpis auctor vestibulum. Integer venenatis a turpis dictum pellentesque. Pellentesque gravida et orci in porttitor. Duis semper in diam vitae malesuada. Sed hendrerit urna ut ex consequat finibus. Sed imperdiet nunc nec velit consequat bibendum.</p>\r\n<p>Integer ac odio fringilla, rhoncus elit a, malesuada velit. In nisi diam, placerat non tincidunt vel, dictum eu massa. Aenean aliquam magna eget turpis porttitor, quis pulvinar arcu sagittis. Proin fermentum suscipit nibh eget feugiat. Praesent id cursus risus. Nunc eu leo porttitor, placerat orci sit amet, venenatis nunc. Nulla tellus nunc, hendrerit eu porta non, pretium sed metus.</p>\r\n<p>Morbi velit tellus, maximus sed metus nec, suscipit facilisis sem. Praesent faucibus, libero vel condimentum dapibus, enim odio pellentesque sapien, a sagittis purus nulla ac ex. Nullam rutrum bibendum velit, sit amet finibus sapien viverra vitae. Ut posuere, tellus in eleifend bibendum, lorem velit volutpat lectus, a eleifend nulla quam sit amet ipsum. Nunc et nisi vitae risus congue iaculis. Etiam nec nibh suscipit, dapibus justo sit amet, egestas turpis. Donec interdum nisl a mattis rhoncus. Morbi et bibendum nisl. In hac habitasse platea dictumst. Nam pulvinar vitae risus ut venenatis. Sed sit amet libero quis elit efficitur placerat. In pretium lacus sed ligula mollis placerat.</p>	2025-12-22 14:54:34.481601	2025-12-22 14:43:56.137377	2025-12-22 14:43:56.137377
69	13	1	1	\N	\N	Text	text	\N	<p><strong>Lorem Ipsum</strong> is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.</p>	2025-12-22 14:54:38.626754	2025-12-22 14:36:28.418823	2025-12-22 14:36:28.418823
75	38	1	1	\N	\N	CONTOH MATERI TEXT	text	\N	<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.</p>	2025-12-22 17:54:16.66654	2025-12-22 17:51:42.184948	2025-12-22 17:51:42.184948
71	37	1	1	\N	\N	Contoh Materi TEXT	text	\N	<p>Lorem ipsum dolor sit amet consectetur adipiscing elit. Quisque faucibus ex sapien vitae pellentesque sem placerat. In id cursus mi pretium tellus duis convallis. Tempus leo eu aenean sed diam urna tempor. Pulvinar vivamus fringilla lacus nec metus bibendum egestas. Iaculis massa nisl malesuada lacinia integer nunc posuere. Ut hendrerit semper vel class aptent taciti sociosqu. Ad litora torquent per conubia nostra inceptos himenaeos.</p>	2025-12-22 17:54:21.908832	2025-12-22 14:55:45.288122	2025-12-22 14:55:45.288122
97	2	42	42	[324]	\N	Penyusunan Materi Teknis RPerpres RTR KSN Kawasan Hutan Lindung Bukit Batabuh	dokumen	\N	<p>Dokumen ini menguraikan penyusunan materi teknis untuk Rancangan Peraturan Presiden mengenai Rencana Tata Ruang Kawasan Strategis Nasional (RTR KSN) di Hutan Lindung Bukit Batabuh yang kini mengalami fragmentasi akibat aktivitas manusia. Fokus utamanya adalah pengarusutamaan ekonomi hijau sebagai instrumen pengaturan ruang untuk melestarikan keanekaragaman hayati, revitalisasi lanskap, dan pengurangan emisi karbon, serta memastikan adanya arahan pengendalian pemanfaatan ruang yang ketat guna mencegah alih fungsi lahan lindung menjadi area pembangunan yang tidak terencana.</p>	\N	2026-01-09 04:56:31.52449	2026-01-09 04:56:31.52449
73	36	1	1	[]	[]	TEST	text	\N	<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pulvinar lacus sem, vitae facilisis nulla tempus et. Sed vitae quam in nunc gravida lacinia. Nunc consectetur quis erat id laoreet. Sed ultricies auctor lorem quis ullamcorper. Aenean in erat vel magna lobortis feugiat. Ut varius condimentum odio sit amet volutpat. In sed posuere tellus.</p>\r\n<p>Phasellus sed sapien ut erat blandit imperdiet nec non nisi. Donec et est mauris. Nulla facilisis massa augue, eu venenatis turpis fringilla vel. Sed hendrerit bibendum velit, vel rhoncus leo auctor et. Aenean placerat, enim sit amet iaculis eleifend, nibh massa dignissim velit, eu accumsan nunc augue sed velit. Curabitur augue arcu, scelerisque ut mauris nec, maximus convallis leo. Maecenas iaculis metus nec odio tristique posuere. Nullam ornare purus lectus. Vivamus faucibus lectus ac enim tincidunt consequat. Integer consectetur vehicula massa sed fermentum. Morbi ac mi id justo sollicitudin congue nec in felis. Proin felis eros, ornare id urna in, lobortis porta arcu. Vestibulum dignissim nulla at tellus rhoncus, et euismod libero tincidunt. Duis tincidunt, lorem et euismod rutrum, nunc odio congue lorem, ut scelerisque risus magna eu felis. In hac habitasse platea dictumst.</p>\r\n<p>Morbi in tortor ut orci maximus efficitur. Integer quis nisi a orci pretium accumsan consequat sed tortor. Proin condimentum, urna sit amet viverra egestas, nibh lacus bibendum mi, sit amet posuere turpis leo ut metus. Suspendisse potenti. Etiam vel hendrerit velit. Integer posuere, quam ac tempor lobortis, sem sem rhoncus arcu, a vestibulum felis ex gravida augue. Vivamus sit amet vestibulum dolor, a finibus lorem. Sed augue lacus, tristique nec porttitor id, egestas ac magna. Morbi ultricies, nisi quis volutpat pharetra, magna risus mattis turpis, non elementum urna leo interdum purus. Aliquam congue ipsum eu sem porta, et convallis mi volutpat.</p>\r\n<p>Phasellus eu lacus scelerisque, cursus nisl vitae, varius nisi. Proin eu porttitor ligula. Donec id sem ultricies, porta orci at, feugiat elit. Aliquam semper velit eu mauris posuere, a gravida justo gravida. Ut at quam sed dolor blandit faucibus ut ut mi. Sed hendrerit tincidunt nunc, quis ultricies mauris lobortis ac. In lorem dolor, maximus id diam ullamcorper, pharetra vestibulum velit. Mauris molestie condimentum purus, quis eleifend nisi blandit ac. Aenean dignissim ex quis massa consectetur, et scelerisque justo faucibus. Praesent faucibus mi non lorem condimentum blandit. Quisque egestas lobortis justo et pulvinar. Nulla consequat nulla turpis, sed pharetra erat eleifend sed. Sed vestibulum finibus varius. In nec enim et urna efficitur malesuada. Aenean eu sapien fermentum, interdum nulla quis, blandit erat.</p>\r\n<p>Nullam accumsan, leo sed semper faucibus, nisl arcu posuere magna, at aliquam turpis orci sed justo. Morbi in odio sodales metus suscipit luctus. Morbi ut rutrum arcu. Donec eu scelerisque sem. Curabitur eu sem lobortis, varius turpis ac, viverra nunc. In dictum arcu diam, a porttitor ligula scelerisque quis. Fusce est risus, sollicitudin vel scelerisque in, ornare vel sapien. Sed commodo ante felis, id ultricies metus eleifend non. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam at orci ac erat gravida facilisis a et ligula. Cras vulputate vel magna sed efficitur. Vestibulum et viverra nulla.</p>	\N	2025-12-22 17:10:53.755175	2025-12-22 17:11:30.041966
74	36	1	1	\N	\N	TEST2	text	\N	<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed pulvinar lacus sem, vitae facilisis nulla tempus et. Sed vitae quam in nunc gravida lacinia. Nunc consectetur quis erat id laoreet. Sed ultricies auctor lorem quis ullamcorper. Aenean in erat vel magna lobortis feugiat. Ut varius condimentum odio sit amet volutpat. In sed posuere tellus.</p>\r\n<p>Phasellus sed sapien ut erat blandit imperdiet nec non nisi. Donec et est mauris. Nulla facilisis massa augue, eu venenatis turpis fringilla vel. Sed hendrerit bibendum velit, vel rhoncus leo auctor et. Aenean placerat, enim sit amet iaculis eleifend, nibh massa dignissim velit, eu accumsan nunc augue sed velit. Curabitur augue arcu, scelerisque ut mauris nec, maximus convallis leo. Maecenas iaculis metus nec odio tristique posuere. Nullam ornare purus lectus. Vivamus faucibus lectus ac enim tincidunt consequat. Integer consectetur vehicula massa sed fermentum. Morbi ac mi id justo sollicitudin congue nec in felis. Proin felis eros, ornare id urna in, lobortis porta arcu. Vestibulum dignissim nulla at tellus rhoncus, et euismod libero tincidunt. Duis tincidunt, lorem et euismod rutrum, nunc odio congue lorem, ut scelerisque risus magna eu felis. In hac habitasse platea dictumst.</p>\r\n<p>Morbi in tortor ut orci maximus efficitur. Integer quis nisi a orci pretium accumsan consequat sed tortor. Proin condimentum, urna sit amet viverra egestas, nibh lacus bibendum mi, sit amet posuere turpis leo ut metus. Suspendisse potenti. Etiam vel hendrerit velit. Integer posuere, quam ac tempor lobortis, sem sem rhoncus arcu, a vestibulum felis ex gravida augue. Vivamus sit amet vestibulum dolor, a finibus lorem. Sed augue lacus, tristique nec porttitor id, egestas ac magna. Morbi ultricies, nisi quis volutpat pharetra, magna risus mattis turpis, non elementum urna leo interdum purus. Aliquam congue ipsum eu sem porta, et convallis mi volutpat.</p>\r\n<p>Phasellus eu lacus scelerisque, cursus nisl vitae, varius nisi. Proin eu porttitor ligula. Donec id sem ultricies, porta orci at, feugiat elit. Aliquam semper velit eu mauris posuere, a gravida justo gravida. Ut at quam sed dolor blandit faucibus ut ut mi. Sed hendrerit tincidunt nunc, quis ultricies mauris lobortis ac. In lorem dolor, maximus id diam ullamcorper, pharetra vestibulum velit. Mauris molestie condimentum purus, quis eleifend nisi blandit ac. Aenean dignissim ex quis massa consectetur, et scelerisque justo faucibus. Praesent faucibus mi non lorem condimentum blandit. Quisque egestas lobortis justo et pulvinar. Nulla consequat nulla turpis, sed pharetra erat eleifend sed. Sed vestibulum finibus varius. In nec enim et urna efficitur malesuada. Aenean eu sapien fermentum, interdum nulla quis, blandit erat.</p>\r\n<p>Nullam accumsan, leo sed semper faucibus, nisl arcu posuere magna, at aliquam turpis orci sed justo. Morbi in odio sodales metus suscipit luctus. Morbi ut rutrum arcu. Donec eu scelerisque sem. Curabitur eu sem lobortis, varius turpis ac, viverra nunc. In dictum arcu diam, a porttitor ligula scelerisque quis. Fusce est risus, sollicitudin vel scelerisque in, ornare vel sapien. Sed commodo ante felis, id ultricies metus eleifend non. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam at orci ac erat gravida facilisis a et ligula. Cras vulputate vel magna sed efficitur. Vestibulum et viverra nulla.</p>	\N	2025-12-22 17:12:14.761602	2025-12-22 17:12:14.761602
20	15	1	1	[150]	\N	Episode 1	dokumen	\N	<p>test</p>	2025-12-22 17:54:47.250601	2025-11-21 12:07:33.693889	2025-11-21 12:07:33.693889
72	37	1	1	\N	\N	Tezt 2	text	\N	<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed at velit risus. Morbi eget tincidunt diam. Nulla ipsum metus, sollicitudin vehicula neque nec, porta consequat ante. Cras tempor sollicitudin leo, eget eleifend ligula pharetra ut. Integer non convallis leo, a malesuada lacus. Nulla facilisis condimentum urna, ac condimentum urna imperdiet eu. Ut eget nulla congue, dictum massa a, laoreet leo. Fusce faucibus orci velit, sit amet mollis nulla scelerisque nec. Integer id nibh in eros aliquet convallis. Fusce ullamcorper porttitor arcu non eleifend. Mauris sit amet mi quis sem luctus mollis. Duis eget sodales tortor. Cras at dictum nisi, volutpat tempor augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Fusce vitae erat nibh.</p>\r\n<p>Vivamus tempor quam sed tincidunt tristique. Cras iaculis laoreet mattis. Quisque scelerisque accumsan convallis. Cras nulla lorem, egestas vel ullamcorper quis, imperdiet ac est. Donec sollicitudin nulla diam, vitae elementum metus dapibus vel. Phasellus non eleifend arcu. Maecenas ac elit rhoncus, varius erat quis, vulputate turpis. Vestibulum fringilla pretium dolor, at elementum elit dictum id. Fusce interdum tellus ac sollicitudin pretium. Etiam posuere mauris nec pulvinar mattis. Vestibulum laoreet venenatis convallis. Cras blandit elit a mi lacinia imperdiet.</p>\r\n<p>Aliquam finibus nisl massa, sit amet auctor risus commodo quis. Morbi finibus, dolor at laoreet vulputate, eros risus vehicula ipsum, non bibendum elit erat non erat. Vivamus nulla leo, consequat nec turpis sit amet, rutrum vulputate quam. Pellentesque tellus dui, vestibulum in ante id, dapibus euismod magna. Integer eget sapien nibh. Vivamus tortor lectus, molestie sodales tristique sit amet, venenatis pulvinar nulla. Nulla vitae felis molestie orci consequat tincidunt eget vel libero. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Proin posuere turpis a turpis auctor vestibulum. Integer venenatis a turpis dictum pellentesque. Pellentesque gravida et orci in porttitor. Duis semper in diam vitae malesuada. Sed hendrerit urna ut ex consequat finibus. Sed imperdiet nunc nec velit consequat bibendum.</p>\r\n<p>Integer ac odio fringilla, rhoncus elit a, malesuada velit. In nisi diam, placerat non tincidunt vel, dictum eu massa. Aenean aliquam magna eget turpis porttitor, quis pulvinar arcu sagittis. Proin fermentum suscipit nibh eget feugiat. Praesent id cursus risus. Nunc eu leo porttitor, placerat orci sit amet, venenatis nunc. Nulla tellus nunc, hendrerit eu porta non, pretium sed metus.</p>\r\n<p>Morbi velit tellus, maximus sed metus nec, suscipit facilisis sem. Praesent faucibus, libero vel condimentum dapibus, enim odio pellentesque sapien, a sagittis purus nulla ac ex. Nullam rutrum bibendum velit, sit amet finibus sapien viverra vitae. Ut posuere, tellus in eleifend bibendum, lorem velit volutpat lectus, a eleifend nulla quam sit amet ipsum. Nunc et nisi vitae risus congue iaculis. Etiam nec nibh suscipit, dapibus justo sit amet, egestas turpis. Donec interdum nisl a mattis rhoncus. Morbi et bibendum nisl. In hac habitasse platea dictumst. Nam pulvinar vitae risus ut venenatis. Sed sit amet libero quis elit efficitur placerat. In pretium lacus sed ligula mollis placerat.</p>	2025-12-22 17:54:25.532543	2025-12-22 14:59:13.259205	2025-12-22 14:59:13.259205
76	17	42	42	[303]	\N	Penyusunan Materi Teknis Rancangan Peraturan Presiden Rencana Tata Ruang Kawasan Strategis Nasional  Kawasan Taman Nasional Sembilang 2025	dokumen	\N	<p style="text-align: justify;"><span class="citation-18">Materi teknis ini disusun sebagai bagian dari rancangan regulasi tata ruang nasional untuk Taman Nasional Sembilang tahun 2025 yang berfokus pada upaya pelestarian serta pengelolaan ekosistem mangrove dan gambut secara berkelanjutan</span><span class="citation-18 citation-end-18"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,4">. </span><span class="citation-17">Dokumen ini menyoroti peran vital mangrove sebagai benteng alami pesisir dari abrasi, penyimpan cadangan karbon yang signifikan, serta habitat bagi berbagai fauna, sembari memaparkan kondisi kritis penurunan luas hutan mangrove di kawasan TNS akibat alih fungsi lahan dan aktivitas ilegal</span><span class="citation-17 citation-end-17"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,8">. </span><span class="citation-16">Untuk menghadapi tantangan tersebut, diusulkan strategi yang mengombinasikan kebijakan perlindungan ekosistem melalui rehabilitasi dan pengendalian ruang dengan peningkatan kesejahteraan masyarakat melalui pengembangan ekonomi hijau-biru, seperti jasa lingkungan ekowisata</span><span class="citation-16 citation-end-16"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="2,12">. </span><span class="citation-15">Secara keseluruhan, dokumen ini bertujuan untuk mengintegrasikan kepentingan konservasi lingkungan dengan keberlangsungan ekonomi masyarakat pesisir di Taman Nasional Sembilang melalui pendekatan yang holistik</span><span class="citation-15 citation-end-15"><sup class="superscript" data-turn-source-index="5"><!----></sup></span></p>	\N	2026-01-03 10:14:24.907015	2026-01-03 10:14:24.907015
77	19	42	42	[304]	\N	elatihan Metodologi RIMBA: Transformasi Penilaian Jasa Ekosistem Menjadi Kebijakan Tata Ruang dan Instrumen Insentif.	dokumen	\N	<p><span class="citation-32">pelatihan ini menyajikan panduan sistematis mengenai metodologi RIMBA yang mengintegrasikan data ekosistem ke dalam perumusan kebijakan tata ruang melalui pendekatan berbasis ilmu pengetahuan</span><span class="citation-32 citation-end-32"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,4">. </span><span class="citation-31">Dokumen ini menguraikan alur kerja komprehensif mulai dari pengumpulan data biofisik dan sosial-ekonomi hingga pemodelan jasa ekosistem menggunakan perangkat lunak InVEST dan ARIES untuk mengkuantifikasi manfaat alam secara spasial, seperti penyimpanan karbon, kualitas habitat, dan tata kelola air</span><span class="citation-31 citation-end-31"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,8">. </span><span data-path-to-node="2,10"><span class="citation-30">Lebih lanjut, modul ini menjelaskan teknik analisis </span><em data-path-to-node="2,10" data-index-in-node="52"><span class="citation-30">overlay</span></em><span class="citation-30"> untuk mengidentifikasi zona prioritas bagi penerapan skema insentif dan disinsentif, serta merancang mekanisme pembiayaan yang berkelanjutan melalui analisis pemangku kepentingan yang mendalam</span></span><span class="citation-30 citation-end-30"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,12">. </span><span class="citation-29">Dengan menyertakan studi kasus nyata seperti program kopi hutan Kerinci, materi ini bertujuan untuk menjembatani aspek ekologis dengan kebijakan pembangunan guna mewujudkan perencanaan tata ruang yang lebih adil dan berkelanjutan</span></p>	\N	2026-01-03 10:16:38.470144	2026-01-03 10:16:38.470144
79	20	42	42	[306]	\N	FAQ Ekonomi Hijau	dokumen	\N	<p><span class="citation-67">Dokumen ini merupakan panduan komprehensif dalam format tanya-jawab yang mengulas secara mendalam konsep, urgensi, dan strategi implementasi ekonomi hijau sebagai respons terhadap model ekonomi "coklat" yang ekstraktif</span><span class="citation-67 citation-end-67"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,4">. </span><span class="citation-66">Dengan merujuk pada definisi dari berbagai lembaga internasional dan nasional seperti UNEP, Bappenas, dan World Bank, materi ini menjelaskan transisi menuju pertumbuhan ekonomi yang rendah karbon, efisien dalam penggunaan sumber daya, serta inklusif secara sosial demi menjaga keseimbangan ekologi</span><span class="citation-66 citation-end-66"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,8">. </span><span class="citation-65">Di dalamnya dibahas perbandingan mendalam antara ekonomi hijau dan coklat, prinsip-prinsip utama seperti keberlanjutan dan keadilan sosial, hingga langkah-langkah strategis untuk memperkuat ekonomi lokal di wilayah seperti Koridor RIMBA</span><span class="citation-65 citation-end-65"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,12">. </span><span class="citation-64">Secara keseluruhan, dokumen ini bertujuan untuk memberikan pemahaman yang seragam kepada para pemangku kepentingan mengenai tantangan dan manfaat ganda dari ekonomi hijau&mdash;yaitu kelestarian alam dan peningkatan kesejahteraan masyarakat&mdash;sebagai investasi vital bagi generasi masa depan</span><span class="citation-64 citation-end-64"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span></p>	\N	2026-01-03 10:36:36.154124	2026-01-03 10:36:36.154124
89	6	42	42	[316]	\N	Fasilitasi Perencanaan Penggunaan Lahan Partisipatif di Kawasan Pedesaan Klaster 1 Koridor RIMBA	dokumen	\N	<p>Materi ini menguraikan upaya fasilitasi perencanaan tata ruang desa melalui pendekatan partisipatif di wilayah Klaster 1 Koridor RIMBA, yang mencakup Kabupaten Kampar, Kuantan Singingi, dan Sijunjung. Program ini bertujuan untuk menyelaraskan pemanfaatan lahan masyarakat dengan perlindungan ekosistem melalui penyusunan Dokumen Perencanaan Kawasan Perdesaan (DPKP) dan Rencana Tata Ruang Desa yang berbasis pada potensi lokal serta kearifan tradisional. Kajian ini menyoroti keberhasilan dalam pemetaan partisipatif dan legalitas kawasan hutan, namun juga mengidentifikasi tantangan signifikan berupa konflik tenurial, tumpang tindih regulasi, serta keterbatasan kapasitas sumber daya manusia di tingkat desa dalam mengelola aset lingkungan secara mandiri dan berkelanjutan.</p>	\N	2026-01-09 04:27:41.541979	2026-01-09 04:27:41.541979
81	23	42	42	[308]	\N	Diseminasi Panduan Produksi dan Konsumsi Berkelanjutan  untuk Implementasi Ekonomi Hijau di Koridor Ekosistem RIMBA	dokumen	\N	<p><span data-path-to-node="2,2"><span class="citation-110">Dokumen ini menyajikan materi diseminasi mengenai fasilitasi penyusunan panduan Produksi dan Konsumsi Berkelanjutan (</span><em data-path-to-node="2,2" data-index-in-node="117"><span class="citation-110">Sustainable Production and Consumption</span></em><span class="citation-110">/SPC) yang dirancang untuk mendukung transisi ekonomi hijau di wilayah Koridor Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat) pada akhir tahun 2025</span></span><span class="citation-110 citation-end-110"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,4">. </span><span class="citation-109">Panduan ini mengintegrasikan prinsip-prinsip SDG Goal 12 ke dalam lima sektor strategis, yaitu kehutanan, perkebunan, pertanian, pertambangan, dan ekonomi sirkular, dengan tujuan utama meminimalkan dampak lingkungan negatif sekaligus meningkatkan kualitas hidup masyarakat secara holistik</span><span class="citation-109 citation-end-109"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,8">. </span><span class="citation-108">Di dalamnya diuraikan lima aspek implementasi utama yang mencakup penguatan konektivitas ekosistem, pemeliharaan kualitas habitat, pengurangan emisi dan limbah, peningkatan kesejahteraan masyarakat, hingga penguatan tata kelola yang kolaboratif antar-pemangku kepentingan</span><span class="citation-108 citation-end-108"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="2,12">. </span><span class="citation-107">Secara keseluruhan, materi ini berfungsi sebagai instrumen operasional yang bersifat sukarela bagi pemerintah, dunia usaha, dan masyarakat untuk mencapai indikator keberhasilan pelestarian bentang alam RIMBA, seperti stabilisasi populasi satwa lindung, peningkatan tutupan hutan, serta pengurangan emisi CO2 secara berkelanjutan</span></p>	\N	2026-01-03 10:46:33.801323	2026-01-03 10:46:33.801323
82	23	42	42	[309]	\N	Buku Panduan SPC	dokumen	\N	<p>Dokumen ini merupakan materi sosialisasi komprehensif mengenai Buku Panduan Produksi dan Konsumsi Berkelanjutan (<em data-path-to-node="2" data-index-in-node="124">Sustainable Production and Consumption</em>/SPC) yang disusun khusus untuk wilayah Koridor Ekosistem RIMBA pada tahun 2025. Materi ini menguraikan landasan konseptual SPC yang selaras dengan target SDG 12, yang menekankan pada efisiensi pemanfaatan sumber daya alam, pengurangan limbah melalui pendekatan siklus hidup, serta peningkatan kualitas hidup masyarakat tanpa mengorbankan daya dukung lingkungan. Fokus utama dokumen ini terletak pada penjabaran matriks implementasi yang mendetail, yang mengatur peran serta tanggung jawab berbagai regulator&mdash;seperti Kementerian ATR/BPN, Kementerian Kehutanan, hingga pemerintah desa&mdash;dalam mencapai indikator-indikator kunci seperti penguatan konektivitas ekosistem, penyelesaian sengketa tata ruang, dan pengawasan tata batas kawasan. Secara keseluruhan, presentasi ini berfungsi sebagai panduan operasional untuk memastikan bahwa strategi ekonomi hijau dapat diturunkan menjadi aksi nyata yang terukur di tingkat tapak oleh seluruh pemangku kepentingan terkait</p>	\N	2026-01-03 11:03:06.760691	2026-01-03 11:03:06.760691
83	26	42	42	[310]	\N	Infografis Fasilitasi Integrasi Ekonomi Hijau dalam Perencanaan Wilayah Koridor Rimba	gambar	\N	<p>Infografis ini memaparkan strategi Program Koridor Rimba dalam mewujudkan ekonomi hijau di kawasan ekosistem Riau, Jambi, dan Sumatera Barat sebagai upaya mendukung visi Indonesia Emas 2045 dan target <em data-path-to-node="2" data-index-in-node="212">Net Zero Emission</em> 2060. Melalui kolaborasi antarlembaga, program ini memfasilitasi integrasi prinsip pembangunan rendah karbon dan pelestarian keanekaragaman hayati ke dalam dokumen rencana tata ruang (RTRW) serta rencana pembangunan daerah (RPJMD/RKPD). Di dalamnya dijelaskan alur transformasi ekonomi yang terukur melalui Indeks Ekonomi Hijau, serta menyajikan contoh konkret sinkronisasi program pada ekosistem ekonomi sirkular di wilayah Bukit Batabuh dan Kabupaten Sijunjung, lengkap dengan identifikasi sumber pendanaan yang melibatkan sinergi antara pemerintah pusat, daerah, serta sektor swasta</p>	\N	2026-01-03 11:07:16.217518	2026-01-03 11:07:16.217518
84	26	42	42	[311]	\N	Panduan Praktik Pengelolaan Terbaik Ekonomi Hijau: Solusi Berbasis Alam dalam Pertanian Berkelanjutan	dokumen	\N	<p><span data-path-to-node="3,2"><span class="citation-123">Dokumen yang disusun oleh Direktorat Jenderal Tata Ruang Kementerian ATR/BPN ini berfungsi sebagai panduan strategis dalam mengimplementasikan konsep </span><em data-path-to-node="3,2" data-index-in-node="150"><span class="citation-123">Nature-based Solution</span></em><span class="citation-123"> (NbS) atau Solusi Berbasis Alam untuk mengatasi krisis sistem pangan global dan degradasi lahan</span></span><span class="citation-123 citation-end-123"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="3,4">. </span><span class="citation-122">Fokus utama materi ini adalah mentransformasi sektor pertanian&mdash;khususnya padi di Koridor Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat)&mdash;dari pendorong kerusakan lingkungan menjadi sistem produktif yang mampu merehabilitasi ekosistem serta meningkatkan ketahanan pangan</span><span class="citation-122 citation-end-122"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="3,8">. </span><span class="citation-121">Panduan ini mencakup definisi, kriteria, hingga langkah-langkah teknis implementasi NbS, mulai dari analisis kondisi lahan, pemilihan varietas, hingga penguatan nilai ekonomi dan pemberdayaan masyarakat guna mencapai target pelestarian lingkungan sekaligus kesejahteraan sosial-ekonomi</span></p>	\N	2026-01-03 11:14:53.938205	2026-01-03 11:14:53.938205
85	26	42	42	[312]	\N	Panduan Praktik Pengelolaan Terbaik Ekonomi Hijau: Mekanisme Imbal Jasa Lingkungan di Koridor Ekosistem RIMBA	dokumen	\N	<p><span data-path-to-node="2,2"><span class="citation-144">Dokumen yang disusun oleh Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) ini menyajikan panduan strategis mengenai implementasi skema Imbal Jasa Lingkungan atau </span><em data-path-to-node="2,2" data-index-in-node="185"><span class="citation-144">Payment for Ecosystem Services</span></em><span class="citation-144"> (PES) sebagai solusi ekonomi untuk pelestarian lingkungan di wilayah Riau, Jambi, dan Sumatera Barat</span></span><span class="citation-144 citation-end-144"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,4">. </span><span class="citation-143">Panduan ini dilatarbelakangi oleh ancaman deforestasi masif dan kerusakan lahan gambut yang mengganggu habitat satwa endemik serta meningkatkan emisi karbon di Koridor Ekosistem RIMBA</span><span class="citation-143 citation-end-143"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,8">. </span><span class="citation-142">Di dalamnya dijelaskan secara komprehensif mulai dari konsep valuasi jasa ekosistem, identifikasi penerima manfaat, hingga mekanisme pembayaran dan pemantauan aktivitas konservasi</span><span class="citation-142 citation-end-142"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,12">. </span><span data-path-to-node="2,14"><span class="citation-141">Melalui penerapan </span><em data-path-to-node="2,14" data-index-in-node="18"><span class="citation-141">Best Management Practices</span></em><span class="citation-141"> (BMP), dokumen ini bertujuan menyediakan insentif finansial bagi komunitas lokal agar mampu menginternalisasi nilai jasa lingkungan, seperti regulasi air dan penyimpanan karbon, guna mencapai keseimbangan antara perlindungan ekologis dan kesejahteraan ekonomi masyarakat</span></span></p>	\N	2026-01-03 11:20:27.153523	2026-01-03 11:20:27.153523
31	5	42	42	[162]	\N	Executive Summary: Peninjauan Rencana Jangka Panjang Pengelolaan Hutan Termasuk Kawasan Penyangga	dokumen	\N	<p>Executive Summary Paket 6A (5 halaman) merangkum hasil peninjauan dan rekomendasi revisi Rencana Pengelolaan Hutan Jangka Panjang (RPHJP) Hutan Lindung Bukit Batabuh dan kawasan penyangganya di Provinsi Riau yang dikelola oleh KPH Singingi Unit XXXI. Dokumen ini menekankan nilai ekologis tinggi kawasan (112 jenis flora, keberadaan harimau sumatra, gajah, tapir, serta potensi ekowisata berbasis 8 air terjun), sekaligus ancaman serius berupa deforestasi, illegal logging, perambahan sawit, SRDP, HGU perusahaan, konflik satwa, fragmentasi habitat, dan kerentanan bencana. Melalui metode kombinasi data primer (survei lapangan, observasi biofisik, wawancara mendalam, FGD) dan sekunder serta pemetaan partisipatif (Participatory Land Use Planning/PLUP), kajian ini mengidentifikasi ketidaksesuaian RPHJP existing dengan kondisi aktual, kekurangan anggaran (hanya Rp400 juta/tahun dari kebutuhan Rp291 miliar), serta belum optimalnya visi-misi, tata batas, dan koordinasi lintas sektor. Rekomendasi utama mencakup penataan ulang blok kawasan (lindung, pemanfaatan terbatas, khusus), penguatan kelembagaan KPH, diversifikasi pendanaan melalui jasa lingkungan dan carbon trading, rehabilitasi lahan kritis, pemberdayaan masyarakat lokal, penegakan hukum yang lebih tegas, serta pengembangan ekonomi hijau berbasis ekowisata dan HHBK untuk menjadikan Bukit Batabuh sebagai model pengelolaan hutan lindung yang berkelanjutan dan inklusif.</p>	2026-01-09 02:32:59.50246	2025-11-26 07:41:06.62578	2025-11-26 07:41:06.62578
24	2	42	42	[155]	\N	Executive Summary: Rencana Tataruang KSN Kawasan Berbak dan Bukit Tiga Puluh	dokumen	\N	<p class="font-claude-response-body whitespace-normal break-words">Dokumen ini merupakan poster program Paket Kegiatan 3 yang menyajikan Penyusunan Materi Teknis Rancangan Peraturan Presiden (RPerpres) Rencana Tata Ruang (RTR) Kawasan Strategis Nasional (KSN) Taman Nasional Berbak dan Bukit Tiga Puluh sebagai bagian dari Program Koridor RIMBA yang bertujuan mewujudkan ekonomi hijau di koridor ekosistem Riau-Jambi-Sumatera Barat. KSN ini mencakup 7 kabupaten/kota di Provinsi Jambi (Kota Jambi, Tanjung Jabung Barat, Tanjung Jabung Timur, Muaro Jambi, Tebo, Batanghari, dan Sarolangun) serta 2 kabupaten di Provinsi Riau (Indragiri Hilir dan Indragiri Hulu) dengan total luas sekitar 2,9 juta hektar. Metodologi penyusunan menggunakan pendekatan integratif yang menggabungkan analisis kualitatif, aplikasi InVEST untuk pemodelan jasa lingkungan, Google Earth Engine, dan ArcGIS untuk analisis spasial, dengan fokus pada model daya dukung, daya tekan, dan kebutuhan penanganan kawasan.</p>\r\n<p class="font-claude-response-body whitespace-normal break-words">Tujuan penataan ruang KSN ini adalah melestarikan keanekaragaman hayati ekosistem RIMBA secara berkelanjutan dan berketahanan melalui pengembangan ekonomi hijau yang harmonis dan kolaboratif. Dokumen mengidentifikasi lima isu strategis utama, yaitu keanekaragaman hayati endemik yang terancam punah (harimau dan gajah sumatera), kegiatan budidaya bernilai ekonomi tinggi yang menurunkan fungsi kawasan hutan, belum optimalnya pemanfaatan jasa lingkungan dan kolaborasi perlindungan, rendahnya pelibatan masyarakat adat, serta kejadian bencana yang mengancam kelestarian. Rencana tata ruang menerapkan empat kebijakan utama dengan konsep penataan yang mencakup perlindungan ekosistem dan habitat satwa, pengembangan ekonomi hijau berbasis daya dukung lingkungan, konektivitas dan jalur pergerakan kawasan melalui infrastruktur hijau, serta pelibatan stakeholder dan masyarakat adat. Pola ruang dibagi menjadi kawasan lindung dan kawasan budidaya dengan hierarki struktur ruang dari pusat pelayanan primer (Kota Jambi) hingga tersier, dilengkapi dengan Indikasi Arahan Zonasi Sistem Nasional (IAZSN) yang mengatur kegiatan yang diperbolehkan, bersyarat, dan dilarang, serta tahapan pengembangan dari inisiasi (2025-2029) hingga aktualisasi (2040-2045).</p>	2026-01-09 02:33:03.045277	2025-11-25 08:00:51.385171	2025-11-25 08:00:51.385171
23	8	42	42	[154]	[]	Executive Summary: Fasilitasi Perencaan Penggunaan Lahan Partisipatif Kawasan Pedesaan di Lahan Gambut dan Penguatan Masyarakat Peduli Api	dokumen	\N	<p class="font-claude-response-body whitespace-normal break-words">Dokumen ini merupakan Laporan Eksekutif Penyusunan Materi Teknis Rancangan Peraturan Presiden (RAPERPRES) Rencana Tata Ruang (RTR) Kawasan Strategis Nasional (KSN) Kawasan Hutan Lindung Bukit Batabuh yang diselesaikan pada Desember 2024. KSN ini terletak di perbatasan Provinsi Riau dan Sumatera Barat, mencakup 10 kabupaten/kota dengan luas total sekitar 2,08 juta hektar, yang terdiri dari kawasan inti seluas 541.135 ha dan kawasan penyangga seluas 1,54 juta hektar. Kawasan ini ditetapkan sebagai KSN berdasarkan PP No. 13 Tahun 2017 dengan sudut kepentingan fungsi dan daya dukung lingkungan hidup, karena merupakan bagian vital dari Koridor Ekosistem RIMBA yang menghubungkan beberapa kawasan konservasi dan menjadi habitat penting bagi satwa langka seperti Harimau Sumatera, Gajah Sumatera, dan berbagai spesies burung.</p>\r\n<p class="font-claude-response-body whitespace-normal break-words">Tujuan utama penataan ruang KSN ini adalah melestarikan keanekaragaman hayati dan mengembangkan ekonomi hijau pada Koridor Ekosistem RIMBA secara produktif, berkelanjutan, dan meningkatkan kesejahteraan masyarakat. Dokumen ini mengidentifikasi delapan isu strategis utama, termasuk deforestasi akibat ekspansi perkebunan kelapa sawit, fragmentasi habitat, perambahan hutan, konflik satwa dengan manusia yang meningkat 400% (2020-2022), serta tantangan terkait kawasan adat dan tanah ulayat. Rencana tata ruang ini menerapkan empat kebijakan utama: perlindungan keanekaragaman hayati, pengembangan ekonomi hijau berbasis sumber daya alam, pengembangan infrastruktur terintegrasi yang memperhatikan koridor ekosistem, dan pengendalian kawasan budidaya berbasis mitigasi bencana serta perubahan iklim, dengan proporsi kawasan lindung 30,16% dan kawasan budidaya 69,84% yang dikelola melalui pendekatan kolaboratif melibatkan pemerintah, masyarakat, dan sektor swasta.</p>	2026-01-09 02:33:06.271799	2025-11-25 07:53:43.094184	2025-11-25 07:56:49.155038
19	10	42	42	[148]	\N	Executive Summary: PENDEKATAN EKONOMI HIJAU DALAM PENYUSUNAN DOKUMEN PERENCANAAN DAN PEMBANGUNAN DAERAH DI KORIDOR RIMBA	dokumen	\N	<p><span class="citation-73 interactive-span-hovered">Laporan Akhir ini berjudul </span><span class="citation-73 interactive-span-hovered">"Kajian Pendekatan Ekonomi Hijau Dalam Penyusunan Dokumen Perencanaan Dan Pembangunan Daerah Di Koridor RIMBA"</span><span class="citation-73 citation-end-73 interactive-span-hovered"> <sup class="superscript" data-turn-source-index="1"><!----></sup></span><span class="citation-72">, yang merupakan bagian dari proyek </span><span class="citation-72">GEF RIMBA</span><span class="citation-72 citation-end-72"> yang bertujuan untuk mengarusutamakan pembangunan ekonomi hijau demi pelestarian keanekaragaman hayati dan peningkatan cadangan karbon di Koridor RIMBA (Riau, Jambi, Sumatera Barat)<sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span>. <span class="citation-71 citation-end-71">Dokumen ini menyajikan analisis spasial dan non-spasial, termasuk estimasi nilai karbon <sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span class="citation-70">, untuk mengidentifikasi potensi dan praktik ekonomi hijau yang kemudian diintegrasikan ke dalam dokumen perencanaan daerah, seperti </span><span class="citation-70">Rencana Tata Ruang Wilayah (RTRW)</span><span class="citation-70">, </span><span class="citation-70">Rencana Pembangunan Jangka Menengah Daerah (RPJMD)</span><span class="citation-70">, dan </span><span class="citation-70">Kajian Lingkungan Hidup Strategis (KLHS)</span><span class="citation-70 citation-end-70"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span>. <span class="citation-69 citation-end-69">Hasil kajian ini menghasilkan rekomendasi dan kerangka kerja intervensi kebijakan spesifik&mdash;meliputi sektor berbasis lahan (jasa ekosistem dan kehutanan, sistem pangan dan pertanian, pariwisata, manajemen lahan) dan non-lahan&mdash;untuk memastikan keberlanjutan ekonomi dan lingkungan secara terintegrasi di kawasan tersebut<sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup></span>.</p>	2026-01-09 02:33:11.257992	2025-11-20 13:53:19.499318	2025-11-20 13:53:19.499318
18	9	42	42	[147]	\N	Executive Summary: Fasilitasi Perencaan Penggunaan Lahan Partisipatif Kawasan Pedesaan di Lahan Gambut dan Penguatan Masyarakat Peduli Api	dokumen	\N	<p><span class="citation-63">Laporan Akhir ini menyajikan hasil </span><span class="citation-63">Peninjauan Kembali Delineasi dan Pengkajian Koridor RIMBA</span><span class="citation-63"> (meliputi Riau, Jambi, dan Sumatera Barat) sebagai usulan </span><span class="citation-63">Kawasan Strategis Nasional (KSN)</span><span class="citation-63 citation-end-63"> dalam proses Revisi Rencana Tata Ruang Wilayah Nasional (RTRWN)<sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span>. <span class="citation-62 citation-end-62">Kajian ini bertujuan untuk memperkuat landasan hukum tata kelola kawasan dalam rangka konservasi keanekaragaman hayati dan mendukung Pembangunan Ekonomi Hijau<sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span>. <span class="citation-61">Dengan menggunakan pendekatan </span><span class="citation-61">Greater Ecosystem (GE)</span><span class="citation-61"> dan analisis konektivitas habitat (Least Cost Path Analysis), laporan ini merekomendasikan penetapan Koridor Satwa di Koridor RIMBA dengan total luasan mencapai </span><span class="citation-61">4.566.227,79 hektare</span><span class="citation-61 citation-end-61"> <sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span class="citation-60 citation-end-60">untuk memastikan konektivitas ekologis bagi spesies kunci seperti Harimau, Gajah, dan Orangutan Sumatera, serta mengintegrasikan kawasan lindung utama, kawasan lindung pendukung, dan kawasan dengan kesesuaian habitat tinggi<sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span></p>	2026-01-09 02:33:14.819691	2025-11-20 13:49:15.675207	2025-11-20 13:49:15.675207
17	7	42	42	[146]	\N	Executive Summary: KONEKTIVITAS JALUR LINTASAN DAN TERITORI SATWA LIAR DI CLUSTER 1 KORIDOR RIMBA	dokumen	\N	<p><span class="citation-41">Laporan Akhir </span><span class="citation-41">Kajian Konektivitas Jalur Lintasan dan Teritori Satwa Liar di Cluster 1 Koridor RIMBA</span><span class="citation-41"> ini, yang merupakan bagian dari </span><span class="citation-41">Program GEF RIMBA</span><span class="citation-41 citation-end-41"> (Riau, Jambi, Sumatera Barat), bertujuan untuk mengatasi ancaman serius dari fragmentasi habitat dan konversi lahan terhadap keanekaragaman hayati<sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span>. <span class="citation-40 citation-end-40">Dilaksanakan oleh Universitas Andalas bekerja sama dengan Kementerian ATR/BPN dan UNEP-GEF <sup class="superscript" data-turn-source-index="2"><!----></sup></span><span class="citation-39">, kajian ini berfokus pada pemodelan dan identifikasi jalur serta kualitas habitat bagi satwa kunci seperti </span><span class="citation-39">Harimau Sumatera</span><span class="citation-39">, </span><span class="citation-39">Gajah Sumatera</span><span class="citation-39">, dan </span><span class="citation-39">Burung Rangkong</span><span class="citation-39 citation-end-39"> di Cluster 1<sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span>. <span class="citation-38 citation-end-38">Hasilnya merekomendasikan usulan desain konektivitas jalur alami dan buatan <sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span class="citation-37">, yang melibatkan mitigasi dampak infrastruktur seperti jaringan jalan eksisting dan rencana </span><span class="citation-37">Jalan Tol Trans Sumatera</span><span class="citation-37 citation-end-37"> <sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup></span><span class="citation-36 citation-end-36">, untuk memfasilitasi pergerakan satwa yang berkelanjutan dan mengurangi potensi konflik manusia-satwa di kawasan koridor RIMBA</span></p>	2026-01-09 02:33:17.905003	2025-11-20 13:38:59.055646	2025-11-20 13:38:59.055646
16	6	42	42	[145]	\N	Executive Summary: Fasilitasi Perencanaan Penggunaan Lahan Partisipatif Kawasan Pedesaan di Klaster I	dokumen	\N	<p><span class="citation-29">Laporan Akhir ini merangkum pekerjaan </span><span class="citation-29">"Fasilitasi Perencanaan Penggunaan Lahan Partisipatif Kawasan Pedesaan di Klaster I"</span><span class="citation-29 citation-end-29"> yang dilaksanakan di enam desa/nagari sasaran, yaitu Desa Kasang, Desa Seberang Cengar, Nagari Timpeh, Nagari Taratak Tinggi, Nagari Kamang, dan Nagari Aie Amo<sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span>. <span class="citation-28 citation-end-28">Konten utama laporan mencakup hasil Pemetaan Spasial, identifikasi isu lokal dan konflik penggunaan lahan, pelaksanaan pelatihan dan perencanaan pemanfaatan lahan menggunakan metode Participatory Land Use Planning (PLUP), serta Dokumen draf kesepakatan penggunaan lahan yang disesuaikan dengan kebijakan otoritas pengelola kawasan<sup class="superscript" data-turn-source-index="2"><!----></sup></span>. <span class="citation-27 citation-end-27">Dokumen ini bertujuan untuk menyediakan informasi dan dasar bagi pelaksanaan kegiatan selanjutnya, sekaligus memberikan masukan penting dalam penyusunan kebijakan dan strategi tata ruang di berbagai tingkatan wilayah<sup class="superscript" data-turn-source-index="3"><!----></sup></span>.</p>	2026-01-09 02:33:21.108374	2025-11-20 13:34:56.962324	2025-11-20 13:34:56.962324
15	4	42	42	[144]	[]	Executive Summary: Metode peninjauan kembali Deliniasi Koridor RIMBA	dokumen	\N	<p><span class="citation-23">Laporan akhir ini berjudul </span><span class="citation-23">"Peninjauan Kembali Delineasi dan Pengkajian Koridor Rimba sebagai Usulan Kawasan Strategis Nasional (KSN) dalam Proses Revisi Rencana Tata Ruang Wilayah Nasional (RTRWN)"</span><span class="citation-23 citation-end-23"> <sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span class="citation-22 citation-end-22">, yang bertujuan untuk meninjau dan mengusulkan delineasi Koridor RIMBA (mencakup Riau, Jambi, dan Sumatera Barat) sebagai Kawasan Strategis Nasional (KSN) dari sudut kepentingan fungsi dan daya dukung lingkungan hidup <sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span class="citation-21 citation-end-21">, dalam rangka memperkuat landasan hukum tata kelola kawasan dan berkontribusi pada pembangunan Ekonomi Hijau<sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span>. <span class="citation-20 citation-end-20">Kajian yang meliputi seluruh Pulau Sumatera ini <sup class="superscript" data-turn-source-index="4"><!----></sup></span><span class="citation-19">menggunakan metode analisis berbasis </span><em><span class="citation-19">Greater Ecosystem</span></em><span class="citation-19 citation-end-19"> (GE) <sup class="superscript" data-turn-source-index="5"><!----></sup></span><span class="citation-18 citation-end-18">, pemodelan kesesuaian habitat, dan konektivitas habitat untuk spesies kunci<sup class="superscript" data-turn-source-index="6"><!----></sup><sup class="superscript" data-turn-source-index="6"><!----></sup><sup class="superscript" data-turn-source-index="6"><!----></sup><sup class="superscript" data-turn-source-index="6"><!----></sup></span>. <span class="citation-17 citation-end-17">Hasilnya merekomendasikan penetapan dan perluasan Koridor Satwa berbasis GE di Koridor RIMBA seluas total 4.566.227,79 hektare <sup class="superscript" data-turn-source-index="7"><!----></sup><sup class="superscript" data-turn-source-index="7"><!----></sup><sup class="superscript" data-turn-source-index="7"><!----></sup><sup class="superscript" data-turn-source-index="7"><!----></sup></span><span class="citation-16 citation-end-16">untuk memperkuat konektivitas ekologis, mencegah fragmentasi habitat, dan mendukung keberlanjutan fungsi ekologis di wilayah tersebut</span></p>	2026-01-09 02:33:24.096547	2025-11-20 13:28:42.867596	2025-11-20 13:29:09.247829
13	2	42	42	[137]	\N	Executive Summary: Rencana Tataruang KSN Kawasan Hutan Lindung Bukit Batabuh	dokumen	\N	<p>Dokumen ini adalah Laporan Eksekutif&nbsp;Penyusunan Materi Teknis Rancangan&nbsp;Peraturan Presiden (RAPERPRES)&nbsp;Rencana Tata Ruang (RTR) Kawasan&nbsp;Strategis Nasional (KSN) Kawasan<br>Hutan Lindung (HL) Bukit Batabuh,&nbsp;yang merupakan bagian dari Proyek&nbsp;RIMBA (Strengthening Forest and&nbsp;Ecosystem Connectivity in RIMBA&nbsp;Landscape of Central Sumatera).</p>	2026-01-09 02:33:27.223352	2025-11-20 02:12:36.732352	2025-11-20 02:12:36.732352
12	1	42	42	[136]	\N	Executive Summary : Roadmap Ekonomi Hijau Koridor RIMBA 2025-2045	dokumen	\N	<p>Roadmap Ekonomi Hijau Koridor&nbsp;RIMBA 2025-2045</p>\r\n<p>Roadmap ini adalah panduan pengembangan Ekonomi Hijau di Koridor Ekosistem RIMBA (Riau-Jambi- Sumatera Barat) seluas &plusmn;3,8 juta ha, yang berfungsi sebagai koridor satwa gajah, harimau, dan burung. Roadmap ini bertujuan untuk mencapai Visi&nbsp;Indonesia Emas 2045 dan keluar dari&nbsp;middle income trap melalui&nbsp;transformasi ekonomi.</p>	2026-01-09 02:33:30.221819	2025-11-20 02:03:19.497577	2025-11-20 02:03:19.497577
80	23	42	42	[307]	\N	Laporan Akhir SPC	dokumen	\N	<p><span data-path-to-node="2,2"><span class="citation-87">Laporan akhir ini menyajikan panduan strategis mengenai pola Produksi dan Konsumsi Berkelanjutan (</span><em data-path-to-node="2,2" data-index-in-node="98"><span class="citation-87">Sustainable Production and Consumption</span></em><span class="citation-87">/SPC) sebagai instrumen utama dalam transformasi ekonomi hijau di wilayah Koridor Ekosistem RIMBA yang mencakup Provinsi Riau, Jambi, dan Sumatera Barat</span></span><span class="citation-87 citation-end-87"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,4">. </span><span data-path-to-node="2,6"><span class="citation-86">Dokumen ini mengintegrasikan pendekatan teknis seperti analisis </span><em data-path-to-node="2,6" data-index-in-node="64"><span class="citation-86">Life Cycle Assessment</span></em><span class="citation-86"> (LCA) dan efisiensi sumber daya ke dalam lima sektor kunci, yaitu kehutanan, perkebunan, pertanian, pertambangan, dan ekonomi sirkular, guna menekan emisi gas rumah kaca serta menjaga konektivitas habitat satwa liar</span></span><span class="citation-86 citation-end-86"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,8">. </span><span class="citation-85">Melalui kolaborasi multipihak yang melibatkan pemerintah, sektor swasta, hingga masyarakat adat, laporan ini merumuskan indikator keberhasilan yang terukur serta instrumen monitoring dan evaluasi untuk memastikan praktik ekonomi yang dijalankan selaras dengan daya dukung ekologi kawasan</span><span class="citation-85 citation-end-85"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,12">. </span><span class="citation-84">Secara keseluruhan, panduan ini berfungsi sebagai rujukan operasional untuk meningkatkan kesejahteraan masyarakat lokal sembari memperkuat kelestarian bentang alam melalui efisiensi pemanfaatan sumber daya alam yang berkelanjutan</span></p>	2026-01-09 02:33:41.130639	2026-01-03 10:42:19.877252	2026-01-03 10:42:19.877252
78	20	42	42	[305]	\N	Laporan Akhir Penyusunan Strategi Komunikasi Implementasi Skenario Ekonomi Hijau di Koridor Ekosistem RIMBA 2025	dokumen	\N	<p><span class="citation-45">aporan akhir ini menyajikan strategi komunikasi komprehensif yang dirancang oleh Kementerian ATR/BPN untuk mendukung implementasi skenario ekonomi hijau di Koridor Ekosistem RIMBA sebagai bagian dari misi pembangunan berkelanjutan nasional</span><span class="citation-45 citation-end-45"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,4">. </span><span data-path-to-node="2,6"><span class="citation-44">Dengan menggunakan pendekatan </span><em data-path-to-node="2,6" data-index-in-node="30"><span class="citation-44">Social Behavior Change Communication</span></em><span class="citation-44"> (SBCC), dokumen ini mengidentifikasi hambatan komunikasi serta rendahnya pemahaman </span><em data-path-to-node="2,6" data-index-in-node="150"><span class="citation-44">stakeholder</span></em><span class="citation-44"> saat ini, lalu merumuskan rencana aksi terintegrasi yang mencakup advokasi kebijakan, mobilisasi sosial, kampanye publik kreatif, hingga komunikasi antarpribadi</span></span><span class="citation-44 citation-end-44"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,8">. </span><span class="citation-43">Strategi ini memprioritaskan sektor agroforestri dan pariwisata berkelanjutan sebagai proyek percontohan dengan memanfaatkan beragam saluran komunikasi yang disesuaikan dengan kearifan lokal serta profil sasaran di tingkat tapak</span><span class="citation-43 citation-end-43"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="2,12">. </span><span class="citation-42">Secara keseluruhan, laporan ini berfungsi sebagai panduan operasional hingga tahun 2028 untuk mendorong perubahan perilaku lintas aktor menuju adopsi praktik ekonomi rendah karbon yang inklusif, terukur, dan berdampak pada kesejahteraan masyarakat di wilayah Sumatera</span></p>	2026-01-09 02:33:45.165787	2026-01-03 10:34:26.208526	2026-01-03 10:34:26.208526
65	33	42	42	[288]	\N	Laporan Pendahuluan Peluang Investasi Ekonomi Hijau Koridor Rimba	dokumen	\N	<p>Laporan Pendahuluan ini membahas kajian peluang investasi ekonomi hijau di Kawasan Ekosistem RIMBA yang meliputi wilayah seluas 3,8 juta hektar di Provinsi Riau, Jambi, dan Sumatera Barat. Kegiatan ini bertujuan untuk menjaga kelestarian keanekaragaman hayati dan meningkatkan cadangan karbon melalui pemetaan potensi investasi berbasis lanskap alam (nature-based investment). Sektor-sektor strategis yang dikaji mencakup energi terbarukan, agroforestri, pertanian, perhutanan, perkebunan, pertambangan, pariwisata, serta konservasi gambut dan mangrove. Secara teknis, kajian ini menggunakan instrumen Integrated Model Sustainable Land-Economic Planning (IM-SLEP) untuk menganalisis hubungan dinamis antara tata ruang, lingkungan, dan sosio-ekonomi. Ruang lingkup wilayah yang menjadi fokus utama mencakup empat kabupaten representatif, yaitu Kuantan Singingi, Sijunjung, Muaro Jambi, dan Merangin. Hasil akhir dari kegiatan selama delapan bulan ini adalah dokumen skenario pembangunan ekonomi hijau, album peta identifikasi potensi investasi, serta ringkasan eksekutif untuk sistem manajemen pengetahuan (KMIS) RIMBA.</p>	2026-01-09 02:33:56.149994	2025-12-21 16:56:49.453011	2025-12-21 16:56:49.453011
55	28	42	42	[272]	\N	Laporan Antara Perencanaan Lahan Partisipatif dan Penanganan Permukiman Ilegal	dokumen	\N	<p style="text-align: justify;" data-path-to-node="0">Laporan Antara ini menyajikan kemajuan pelaksanaan kegiatan fasilitasi perencanaan penggunaan lahan partisipatif dan pencarian solusi alternatif bagi permukiman tidak berizin di Koridor Ekosistem Hutan Lindung (HL) Bukit Batabuh. Dokumen ini mendetailkan profil wilayah kajian yang mencakup KPH Singingi, KPH Kampar Kiri, KPH Sijunjung, dan KPH Dharmasraya, serta memaparkan hasil identifikasi awal terhadap empat bagian jasa ekosistem dan praktik pengelolaan terbaik di wilayah tersebut. Fokus utama laporan ini adalah membedah isu kompleks mengenai permukiman masyarakat di dalam kawasan hutan yang tidak memiliki izin legalitas, guna mencari jalan tengah antara perlindungan habitat satwa dan pemenuhan hak-hak dasar masyarakat.</p>\r\n<p style="text-align: justify;" data-path-to-node="1">Dalam laporan ini, dipaparkan pula metodologi yang digunakan dalam pengumpulan data sosial, ekonomi, dan budaya masyarakat yang bermukim di koridor tersebut. Capaian kegiatan yang dilaporkan mencakup perumusan pola kemitraan dan strategi penanganan permukiman yang inklusif agar sesuai dengan standar perlindungan lingkungan dan sosial. Dengan adanya dokumen ini, diharapkan tercipta dasar pengambilan keputusan yang terarah bagi para pemangku kepentingan untuk mewujudkan tata guna lahan yang adil, berkelanjutan, dan mampu menjaga konektivitas ekosistem RIMBA di perbatasan Provinsi Riau dan Sumatera Barat.</p>	2026-01-09 02:34:00.739492	2025-12-20 03:56:22.058657	2025-12-20 03:56:22.058657
54	28	42	42	[271]	\N	Laporan Pendahuluan Perencanaan Lahan Partisipatif dan Penanganan Permukiman Ilegal	dokumen	\N	<p style="text-align: justify;">Laporan Pendahuluan ini membahas rencana fasilitasi perencanaan penggunaan lahan secara partisipatif serta pencarian solusi alternatif bagi permukiman tidak berizin di kawasan Hutan Lindung (HL) Bukit Batabuh, yang merupakan bagian dari Koridor Ekosistem RIMBA. Kawasan yang terletak di antara Provinsi Riau dan Sumatera Barat ini menghadapi tantangan deforestasi akibat alih fungsi lahan menjadi perkebunan kelapa sawit, sehingga diperlukan langkah strategis untuk memulihkan ekosistem sekaligus menjaga keberlanjutan habitat satwa langka seperti gajah dan harimau sumatera. Fokus utama dari kegiatan ini adalah melakukan identifikasi jasa ekosistem, mengkaji pola sosial-ekonomi masyarakat yang bermukim di dalam kawasan hutan, serta merumuskan kesepakatan kemitraan untuk penyelesaian konflik tenurial. Melalui pendekatan kualitatif, analisis spasial, dan diskusi kelompok terarah (FGD), laporan ini bertujuan menghasilkan rencana permukiman yang sesuai dengan standar IFC Safeguard serta merekomendasikan mata pencaharian "hijau" alternatif bagi masyarakat lokal. Upaya ini diharapkan dapat menyinergikan perlindungan lingkungan dengan peningkatan kesejahteraan masyarakat melalui tata kelola lahan yang lebih bertanggung jawab.</p>	2026-01-09 02:34:05.152627	2025-12-20 03:55:12.505076	2025-12-20 03:55:12.505076
53	26	42	42	[270]	\N	Laporan Kegiatan Jambi	dokumen	\N	<p style="text-align: justify;">Laporan Kegiatan Kunjungan Daerah ke Provinsi Jambi ini mendokumentasikan serangkaian upaya fasilitasi untuk mengintegrasikan pendekatan ekonomi hijau ke dalam dokumen rencana spasial dan rencana pembangunan daerah di kawasan Koridor Ekosistem RIMBA. Kegiatan yang berlangsung pada 30 September hingga 1 Oktober 2025 ini bertujuan untuk mensinkronkan kebijakan pembangunan wilayah dengan upaya pelestarian lingkungan yang berkelanjutan. Provinsi Jambi memiliki peran strategis sebagai bagian dari koridor ekologis tersebut, sehingga penyelarasan rencana tata ruang menjadi krusial untuk menjaga keseimbangan ekosistem dan pertumbuhan ekonomi daerah. Fokus utama kunjungan ini adalah melakukan koordinasi intensif dengan berbagai pemangku kepentingan di tingkat provinsi untuk memastikan bahwa prinsip-prinsip ekonomi rendah karbon terakomodasi dalam kebijakan lokal. Dokumen ini mencakup rangkuman diskusi, identifikasi tantangan dalam integrasi rencana pembangunan, serta rekomendasi langkah-langkah strategis untuk memperkuat tata kelola koridor RIMBA di wilayah Jambi. Melalui laporan ini, diharapkan tercipta sinergi yang lebih kuat antara pemerintah pusat dan daerah dalam mewujudkan pembangunan yang inklusif dan berwawasan lingkungan di sepanjang kawasan koridor.</p>	2026-01-09 02:34:10.215433	2025-12-20 03:53:02.317915	2025-12-20 03:53:02.317915
51	26	42	42	[268]	\N	Laporan Kegiatan Sumatra Barat	dokumen	\N	<p style="text-align: justify;">Laporan Kegiatan Kunjungan Daerah ke Provinsi Sumatera Barat ini mendokumentasikan upaya fasilitasi integrasi pendekatan ekonomi hijau ke dalam dokumen rencana tata ruang dan rencana pembangunan daerah di kawasan Koridor Ekosistem RIMBA. Kunjungan yang dilaksanakan pada 8-9 Oktober 2025 ini bertujuan untuk mensinergikan kebijakan pemerintah pusat dan daerah dalam mengelola koridor ekologis yang menjadi habitat satwa penting sekaligus mendorong pembangunan ekonomi yang rendah karbon. Fokus utama dari kegiatan ini adalah melakukan koordinasi dengan berbagai pemangku kepentingan lokal di Sumatera Barat untuk memastikan prinsip-prinsip ekonomi berkelanjutan terakomodasi dalam perencanaan spasial wilayah tersebut. Dokumen ini menyajikan catatan penting dari pertemuan daerah, identifikasi tantangan dalam penyelarasan dokumen pembangunan, serta langkah-langkah strategis untuk memperkuat perlindungan lingkungan di kawasan koridor tanpa mengabaikan kesejahteraan masyarakat lokal.</p>	2026-01-09 02:34:18.082698	2025-12-20 03:51:12.932404	2025-12-20 03:51:12.932404
50	25	42	42	[267]	\N	Laporan akhir Pengembangan Sistem Informasi dan Analisis Spasial Koridor Rimba	dokumen	\N	<div class="container">\r\n<div id="model-response-message-contentr_73fb230672f1b3c2" class="markdown markdown-main-panel stronger enable-updated-hr-color" dir="ltr" aria-live="polite" aria-busy="false">\r\n<p data-path-to-node="0">Laporan Akhir ini menyajikan hasil penyusunan peta jalan (<em data-path-to-node="0" data-index-in-node="58">roadmap</em>) dan skenario ekonomi hijau untuk pengelolaan Koridor Ekosistem RIMBA yang mencakup wilayah Riau, Jambi, dan Sumatera Barat. Dokumen ini merumuskan strategi komprehensif untuk menyinergikan pembangunan wilayah dengan pelestarian modal alam, pengurangan emisi karbon, serta pencegahan degradasi lahan di kawasan yang menjadi habitat kritis gajah dan harimau Sumatera. Melalui pendekatan berbasis data, laporan ini menetapkan visi jangka panjang bagi transformasi ekonomi di wilayah koridor agar lebih rendah karbon dan inklusif secara sosial.</p>\r\n<p data-path-to-node="1">Selain memuat peta jalan teknis, laporan ini juga mendokumentasikan hasil kajian tingkat pemahaman dan kapasitas pemangku kepentingan terkait prinsip ekonomi hijau di tingkat lokal. Di dalamnya termuat rekomendasi kebijakan yang konkret, termasuk rancangan kelembagaan seperti pembentukan Satuan Tugas (Satgas) Provinsi untuk memastikan implementasi program di lapangan berjalan efektif dan terkoordinasi. Dengan tersusunnya laporan ini, diharapkan terdapat panduan operasional yang jelas bagi pemerintah dan sektor swasta dalam menjaga konektivitas ekosistem sekaligus meningkatkan kesejahteraan masyarakat di sepanjang Koridor RIMBA.</p>\r\n</div>\r\n<!----><!----></div>	2026-01-09 02:34:24.794092	2025-12-20 03:38:36.015206	2025-12-20 03:38:36.015206
49	23	42	42	[266]	\N	Laporan AntaraPedoman Produksi dan Konsumsi Berkelanjutan	dokumen	\N	<p style="text-align: justify;">Laporan Antara ini menyajikan kemajuan penyusunan panduan teknis mengenai pola produksi dan konsumsi yang berkelanjutan atau Sustainable Production and Consumption (SPC) sebagai pilar utama implementasi ekonomi hijau di Koridor RIMBA (Riau, Jambi, dan Sumatera Barat). Fokus utama dokumen ini adalah mengintegrasikan lima aspek strategis&mdash;konektivitas ekologis, kualitas habitat, rendah emisi dan limbah, kesejahteraan masyarakat, serta tata kelola yang baik&mdash;ke dalam sektor-sektor kunci seperti kehutanan, perkebunan, pertanian, pertambangan, dan ekonomi sirkular. Laporan ini merinci hasil analisis Life Cycle Assessment (LCA) dan efisiensi sumber daya untuk memastikan setiap aktivitas ekonomi di koridor tersebut tetap mendukung kelestarian habitat satwa ikonik Sumatera sekaligus mendorong efisiensi pemanfaatan sumber daya alam. Selain menyajikan data teknis, laporan ini memaparkan strategi kolaborasi multipihak yang melibatkan pemerintah, sektor swasta, akademisi, hingga masyarakat adat melalui forum koordinasi dan konsultasi publik di tiga provinsi. Dokumen ini juga memuat draf konsep panduan praktis dan instrumen monitoring yang dirancang agar aplikatif bagi para pelaku usaha, seperti penerapan sertifikasi berkelanjutan dan pengembangan UMKM hijau di sekitar kawasan konservasi. Melalui pendekatan yang berbasis bukti dan partisipatif, Laporan Antara ini menjadi landasan penting untuk menyinkronkan kebijakan penataan ruang dengan praktik ekonomi rendah karbon demi mewujudkan pembangunan yang berkeadilan dan berwawasan lingkungan di wilayah RIMBA.</p>	2026-01-09 02:34:29.561279	2025-12-20 03:32:25.892417	2025-12-20 03:32:25.892417
48	23	42	42	[265]	\N	Laporan Pendahuluan Pedoman Produksi dan Konsumsi Berkelanjutan	dokumen	\N	<p style="text-align: justify;" data-path-to-node="0">Laporan Pendahuluan ini membahas rencana fasilitasi penyusunan panduan produksi dan konsumsi yang berkelanjutan sebagai bagian dari pengimplementasian ekonomi hijau di Indonesia. Fokus utama dari dokumen ini adalah menciptakan kerangka kerja yang mampu mengarahkan pola aktivitas ekonomi agar lebih selaras dengan prinsip keberlanjutan, efisiensi sumber daya, dan pengurangan dampak negatif terhadap lingkungan. Panduan ini dirancang untuk menjadi acuan strategis bagi berbagai pemangku kepentingan dalam menyinkronkan target pembangunan ekonomi dengan upaya pelestarian fungsi ekosistem secara jangka panjang.</p>\r\n<p style="text-align: justify;" data-path-to-node="1">Dalam pelaksanaannya, laporan ini merinci metodologi, ruang lingkup, serta tahapan pengumpulan data yang mencakup analisis profil wilayah, kondisi sosial-ekonomi, dan kebijakan sektoral yang relevan. Melalui pendekatan kolaboratif yang melibatkan pemerintah, akademisi, dan sektor swasta, kegiatan ini bertujuan untuk menghasilkan dokumen teknis yang aplikatif guna mendorong inovasi teknologi ramah lingkungan dan perubahan perilaku konsumsi masyarakat. Hasil awal ini diharapkan dapat memberikan arah yang jelas bagi pengembangan kebijakan ekonomi hijau yang inklusif dan berdaya saing di tingkat nasional maupun daerah.</p>	2026-01-09 02:34:33.975218	2025-12-20 03:31:12.065003	2025-12-20 03:31:12.065003
47	21	42	42	[264]	\N	Laporan pendahuluan Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon	dokumen	\N	<p style="text-align: justify;" data-path-to-node="0">Laporan Pendahuluan ini memaparkan rencana awal dalam penyusunan modul ekonomi hijau yang berfokus pada inovasi teknologi rendah karbon di Koridor Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat). Kawasan ini merupakan koridor ekologis vital bagi satwa prioritas seperti gajah, harimau, dan burung, sehingga memerlukan pengelolaan sumber daya manusia yang kompeten untuk menjaga kelestarian lingkungannya. Laporan ini menetapkan landasan kerja, kerangka konseptual, serta metodologi yang akan digunakan untuk mengembangkan materi edukasi yang mampu menyelaraskan pembangunan wilayah dengan perlindungan keanekaragaman hayati.</p>\r\n<p style="text-align: justify;" data-path-to-node="1">Kegiatan ini mencakup identifikasi kebutuhan kapasitas bagi berbagai pemangku kepentingan, mulai dari pemerintah daerah hingga masyarakat lokal, guna memastikan transisi menuju ekonomi hijau yang efektif. Dalam dokumen ini, dirumuskan rencana kerja yang sistematis, termasuk tahap pengumpulan data, analisis kebijakan ekonomi rendah karbon, serta penyusunan kurikulum pelatihan yang adaptif terhadap kondisi lokal. Melalui laporan pendahuluan ini, diharapkan tercipta arah yang jelas dalam pengembangan modul yang tidak hanya teoretis, tetapi juga praktis dalam mendukung pemanfaatan ekosistem secara bertanggung jawab di sepanjang koridor RIMBA.</p>	2026-01-09 02:34:38.752399	2025-12-20 03:27:37.752511	2025-12-20 03:27:37.752511
46	21	42	42	[263]	\N	Laporan Antara Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon	dokumen	\N	<p style="text-align: justify;">Laporan Antara ini memaparkan progres penyusunan modul pembelajaran ekonomi hijau yang dirancang khusus untuk memperkuat kapasitas sumber daya manusia di Koridor Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat). Fokus utama kegiatan ini adalah menyediakan acuan pembelajaran yang sistematis bagi tiga kelompok pemangku kepentingan utama, yakni pemerintah daerah, sektor bisnis, dan masyarakat sipil (CSO), guna menjembatani kesenjangan antara pemahaman teoritis dan implementasi praktis di lapangan. Laporan ini mencakup hasil asesmen awal mengenai tingkat pemahaman ekonomi hijau, rancangan kurikulum, hingga simulasi jadwal pelatihan yang akan diterapkan pada wilayah prioritas di enam kabupaten. Modul yang disusun mencakup lima tema strategis, yaitu energi, pertanian dan kehutanan, ekonomika lingkungan dan sumber daya alam, teknologi hijau, serta pemberdayaan masyarakat. Materi tersebut diklasifikasikan ke dalam tiga tingkatan kompetensi&mdash;dasar, menengah, dan lanjut&mdash;dengan pendekatan pembelajaran berbasis pengalaman (experiential learning) agar relevan dengan tantangan lokal seperti mitigasi emisi karbon dan pelestarian keanekaragaman hayati. Melalui dokumen ini, diharapkan tercipta standar pelatihan yang inklusif untuk mendorong transisi menuju ekonomi rendah karbon di kawasan koridor ekologis yang menjadi habitat vital satwa prioritas seperti gajah dan harimau Sumatera.</p>	2026-01-09 02:34:42.846006	2025-12-20 03:25:41.668705	2025-12-20 03:25:41.668705
45	21	42	42	[262]	\N	Laporan Akhir Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon	dokumen	\N	<p>Laporan Akhir Penyusunan Modul Ekonomi Hijau ini merupakan dokumen komprehensif yang merumuskan strategi peningkatan kapasitas sumber daya manusia di Koridor Ekosistem RIMBA (Riau, Jambi, dan Sumatera Barat) untuk mendukung pembangunan berkelanjutan. Laporan ini merinci proses pengembangan materi pembelajaran yang sistematis bagi tiga kelompok sasaran utama, yaitu pemerintah daerah, sektor bisnis/usaha, dan masyarakat sipil (CSO), dengan fokus pada lima tema kunci: energi, pertanian dan kehutanan, ekonomika lingkungan, teknologi hijau, serta pemberdayaan masyarakat. Dokumen ini tidak hanya berisi draf modul pembelajaran yang disesuaikan dengan tingkatan kompetensi (dasar, menengah, dan terapan), tetapi juga mencakup buku panduan teknis pelatihan yang dirancang untuk menciptakan kader pelatih atau local champion di wilayah tersebut. Tujuan utama dari laporan akhir ini adalah menyediakan instrumen edukasi yang aplikatif untuk menjembatani kesenjangan antara pengetahuan teoritis dan praktik implementasi ekonomi hijau di lapangan. Di dalamnya dipaparkan hasil asesmen kapasitas pemangku kepentingan, metodologi penyusunan modul (metode ADDIE), hingga catatan hasil diseminasi yang dilakukan di tingkat provinsi untuk memastikan materi yang disusun relevan dengan tantangan lokal seperti mitigasi perubahan iklim dan pengelolaan sumber daya alam lestari. Dengan selesainya laporan ini, diharapkan terdapat acuan standar nasional yang dapat memperkuat konektivitas ekosistem RIMBA sekaligus mendorong pertumbuhan ekonomi rendah karbon melalui inovasi teknologi yang ramah lingkungan.</p>	2026-01-09 02:34:46.16768	2025-12-20 03:22:18.804215	2025-12-20 03:22:18.804215
44	19	42	42	[261]	\N	Laporan Antara Mekanisme Insentif, Disinsentif, dan IJE Tata Ruang Koridor Rimba	dokumen	\N	<div id="model-response-message-contentr_99997e608e2c2ae8" class="markdown markdown-main-panel stronger enable-updated-hr-color" dir="ltr" aria-live="polite" aria-busy="false">\r\n<p data-path-to-node="0"><span data-path-to-node="0,0">Laporan Antara ini menyajikan kajian mendalam mengenai instrumen insentif dan disinsentif, termasuk mekanisme Imbal Jasa Ekosistem (IJE), sebagai strategi pengendalian tata ruang di Koridor RIMBA (Riau, Jambi, dan Sumatera Barat). </span><span class="citation-24">Kawasan ini merupakan koridor ekologis strategis nasional yang menghubungkan bentang alam penting seperti Taman Nasional Kerinci Seblat dan Bukit Tigapuluh, yang berfungsi sebagai habitat satwa prioritas seperti harimau dan gajah Sumatera</span><span data-path-to-node="0,4">. </span><span class="citation-23">Kajian ini menggunakan pemodelan spasial canggih (InVEST) untuk memetakan berbagai jasa ekosistem&mdash;mulai dari stok karbon hingga mitigasi risiko banjir&mdash;guna mengidentifikasi zona prioritas yang memerlukan dukungan insentif bagi pihak yang menjaga lingkungan atau disinsentif bagi aktivitas yang merusak ekosistem</span><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQswM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQsgM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQsQM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQsAM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQrwM"><!----><!----></button><!----><!----><!----><!----></p>\r\n<!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!---->\r\n<p data-path-to-node="1"><span class="citation-22">Hasil kajian ini merumuskan berbagai skema kebijakan, mulai dari instrumen regulatif wajib hingga investasi sukarela yang melibatkan peran aktif pemerintah, sektor swasta, dan masyarakat adat</span><span data-path-to-node="1,3">. </span><span class="citation-21">Rekomendasi yang diberikan mencakup penerapan Transfer Fiskal Ekologis (TFE), sertifikasi komoditas berkelanjutan (seperti kopi dan karet), serta pengetatan izin di zona bernilai ekologis tinggi</span><span data-path-to-node="1,7">. </span><span class="citation-20">Melalui pendekatan yang inklusif dan berkeadilan sosial, laporan ini diharapkan menjadi panduan bagi pemangku kepentingan dalam menyinkronkan pembangunan ekonomi hijau dengan pelestarian fungsi ekologis koridor RIMBA secara berkelanjutan</span><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQuAM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQtwM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQtgM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQtQM"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQtAM"><!----><!----></button><!----><!----><!----><!----></p>\r\n<!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----><!----></div>\r\n<p>&nbsp;</p>	2026-01-09 02:34:50.116851	2025-12-20 03:08:12.329776	2025-12-20 03:08:12.329776
96	1	42	42	[323]	\N	Paket 1: Penyusunan Roadmap Koridor RIMBA dan Pengembangan Skenario Ekonomi Hijau	dokumen	\N	<p>Materi ini membahas penyusunan peta jalan (<em data-path-to-node="2" data-index-in-node="43">roadmap</em>) strategis sebagai visi dan rencana aksi bersama bagi pemangku kepentingan dalam mengimplementasikan pembangunan ekonomi hijau di Koridor RIMBA. Melalui pemodelan skenario hijau seperti <em data-path-to-node="2" data-index-in-node="237">InVEST Modelling</em> dan <em data-path-to-node="2" data-index-in-node="258">System Dynamic</em>, kajian ini bertujuan meningkatkan kapasitas teknis serta koordinasi lintas sektor guna memastikan penataan ruang berbasis ekosistem dapat berjalan efektif, sekaligus memberikan rekomendasi kebijakan berupa insentif ekonomi bagi praktik yang mendukung kelestarian lingkungan di wilayah Riau, Jambi, dan Sumatera Barat.</p>	\N	2026-01-09 04:55:50.247133	2026-01-09 04:55:50.247133
43	19	42	42	[260]	\N	Laporan pendahuluan Mekanisme Insentif, Disinsentif, dan IJE Tata Ruang Koridor Rimba	dokumen	\N	<p data-path-to-node="0"><span class="citation-9">Laporan Pendahuluan ini membahas kajian mengenai penerapan instrumen insentif dan disinsentif, termasuk mekanisme imbal jasa ekosistem (PES), untuk mendukung perwujudan ekonomi hijau di Koridor Ekosistem RIMBA yang meliputi wilayah Sumatera Barat, Riau, dan Jambi</span><span class="citation-9 citation-end-9"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="0,3">. </span><span class="citation-8">Kawasan ini memiliki peran vital sebagai penghubung antar kawasan konservasi strategis dan habitat spesies ikonik seperti harimau dan gajah Sumatera, namun saat ini menghadapi ancaman serius akibat alih fungsi lahan, ekspansi pertambangan, dan lemahnya kepatuhan terhadap tata ruaang</span><span class="citation-8 citation-end-8"><sup class="superscript" data-turn-source-index="2"><!----></sup></span><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQ9wI"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQ9gI"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQ9QI"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQ9AI"><!----><!----></button><!----><!----><!----><!----><button class="button ng-star-inserted" aria-label="Lihat detail sumber. Membuka panel samping." data-hveid="0" data-ved="0CAAQvoAQahgKEwjhxIGE_MqRAxUAAAAAHQAAAAAQ8wI"><!----><!----></button><!----><!----><!----><!----></p>\r\n<p><!----><!----><!----><!----></p>\r\n<p><!----><!----><!----><!----></p>\r\n<p><!----><!----><!----><!----></p>\r\n<p><!----><!----><!----><!----></p>\r\n<p><!----><!----><!----><!----><!----><!----><!----><!----><!----></p>\r\n<p data-path-to-node="1"><span class="citation-7">Fokus utama dari kegiatan ini adalah merumuskan rekomendasi kebijakan yang efektif dan inklusif untuk mengelola koridor tersebut melalui integrasi nilai ekologis ke dalam perencanaan tata ruang wilayah</span><span class="citation-7 citation-end-7"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="1,3">. </span><span class="citation-6">Melalui pendekatan pemodelan spasial dan partisipasi multi-aktor, kajian ini bertujuan untuk mengidentifikasi model insentif bagi pihak yang menjaga lingkungan serta disinsentif atau sanksi bagi aktivitas yang merusak ekosistem</span><span class="citation-6 citation-end-6"><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup><sup class="superscript" data-turn-source-index="4"><!----></sup></span><span data-path-to-node="1,7">. </span><span class="citation-5">Hasil akhirnya diharapkan dapat menjadi landasan bagi pemerintah pusat dan daerah dalam menyinergikan pembangunan ekonomi dengan pelestarian lingkungan yang berkelanjutan</span><span class="citation-5 citation-end-5"><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup><sup class="superscript" data-turn-source-index="5"><!----></sup></span></p>	2026-01-09 02:34:53.68546	2025-12-20 03:04:43.630327	2025-12-20 03:04:43.630327
35	9	42	42	[165]	\N	Laporan Output II: Kegiatan Penguatan Kapasitas Masyarakat Peduli Api	dokumen	\N	<p>Laporan Output 2 Kegiatan Penguatan Kapasitas Masyarakat Peduli Api (MPA) Konsorsium RIMBA Sumatra (158 halaman, Desember 2024) merupakan dokumentasi lengkap Paket Kegiatan IX Program GEF-RIMBA yang berfokus pada peningkatan kapasitas MPA di empat desa gambut timur Koridor RIMBA (Pandan Sejahtera, Pandan Makmur, Seponjen, dan Rantau Panjang). Laporan ini mencatat bahwa keempat desa telah memiliki kelompok MPA resmi (13&ndash;30 anggota) yang aktif mendampingi Satgas Karhutla, namun masih terkendala minimnya peralatan pemadam dan APD standar, lemahnya kapasitas mitigasi (patroli rutin, edukasi masyarakat, pemantauan muka air gambut, dan deteksi sumber api), serta ketiadaan pendanaan berkelanjutan sehingga anggota MPA bekerja sukarela. Selain itu, perusahaan-perusahaan sawit, HTI, dan migas di sekitar wilayah belum memberikan kontribusi finansial yang signifikan. Melalui serangkaian workshop, pelatihan teknis pemadaman, simulasi, penyediaan peralatan dasar, penguatan SOP patroli, dan pendampingan penyusunan rencana kerja tahunan MPA, kegiatan ini berhasil meningkatkan kesiapsiagaan dini, mendorong perubahan perilaku masyarakat dari pembakaran lahan menjadi praktik zero burning, serta merumuskan rekomendasi pendanaan berkelanjutan melalui dana desa, CSR perusahaan, dan skema imbal jasa lingkungan, sehingga menjadi model penguatan MPA yang efektif untuk eliminasi kebakaran hutan dan lahan berulang di kawasan gambut Koridor RIMBA.</p>	2026-01-09 02:34:56.824879	2025-11-26 07:55:25.40218	2025-11-26 07:55:25.40218
34	9	42	42	[164]	\N	Laporan Output I : Evaluasi Eksisting Pemanfaatan Lahan Gambut dan Dokumen Rencana Tata Guna Lahan Partisipatif	dokumen	\N	<p>Laporan Output 1 Fasilitasi Perencanaan Penggunaan Lahan Partisipatif (PLUP) Konsorsium RIMBA Sumatra (145 halaman, 2024) merupakan dokumen lengkap kegiatan Paket IX Program GEF-RIMBA yang berfokus pada empat desa di lahan gambut timur Koridor RIMBA, yaitu Desa Pandan Sejahtera dan Pandan Makmur (Kab. Tanjung Jabung Timur) serta Desa Seponjen dan Rantau Panjang (Kab. Muaro Jambi). Laporan ini mendokumentasikan proses fasilitasi intensif PLUP untuk menyusun peta penggunaan lahan partisipatif, analisis area simpanan karbon, penyelesaian konflik tenurial antar masyarakat, perusahaan HTI/perkebunan, dan pemerintah, serta penguatan Masyarakat Peduli Api (MPA) guna mencegah kebakaran berulang akibat drainase kanal yang tidak terkendali. Melalui serangkaian FGD, lokakarya desa, pemetaan partisipatif, identifikasi model usaha berkelanjutan berbasis jasa ekosistem (agroforestry, perikanan darat, madu hutan, ekowisata), dan pengembangan skema perhutanan sosial, kegiatan ini berhasil menghasilkan dokumen rencana tata guna lahan desa yang disepakati bersama, memperkuat kapasitas masyarakat dalam pemadaman dini kebakaran, serta memberikan rekomendasi teknis rewetting gambut dan penutupan kanal untuk pemulihan hidrologi, sehingga menjadi model replikasi pengelolaan gambut berbasis masyarakat yang inklusif dan berkelanjutan di Klaster II Koridor RIMBA.</p>	2026-01-09 02:35:02.076116	2025-11-26 07:53:44.062178	2025-11-26 07:53:44.062178
86	2	42	42	[313]	\N	Materi Teknis Rencana Peraturan Presiden (RPerPres) RTR KSN Kawasan Hutan Lindung Bukit Batabuh	dokumen	\N	<p style="text-align: justify;"><span class="citation-5">Materi ini disusun untuk mempercepat penetapan Rencana Tata Ruang Kawasan Strategis Nasional (RTR KSN) di Kawasan Hutan Lindung Bukit Batabuh yang merupakan bagian krusial dari Koridor Ekosistem RIMBA (Riau-Jambi-Sumatera Barat)</span><span class="citation-5 citation-end-5"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="1,3">. </span><span data-path-to-node="1,5"><span class="citation-4">Fokus utamanya adalah pengarusutamaan </span><strong data-path-to-node="1,5" data-index-in-node="38"><span class="citation-4">Ekonomi Hijau</span></strong><span class="citation-4"> sebagai instrumen pengaturan ruang guna mengatasi isu strategis seperti deforestasi akibat perkebunan kelapa sawit, perambahan hutan, fragmentasi habitat satwa akibat infrastruktur, serta konflik agraria</span></span><span class="citation-4 citation-end-4"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="1,7">. </span><span class="citation-3">Melalui strategi pelestarian keanekaragaman hayati, pengembangan ekowisata, dan penguatan perhutanan sosial, rencana ini bertujuan untuk menciptakan keseimbangan antara perlindungan ekosistem esensial dengan peningkatan kesejahteraan masyarakat lokal secara berkelanjutan dan adaptif terhadap perubahan iklim</span><span class="citation-3 citation-end-3"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span></p>	\N	2026-01-09 02:44:19.13615	2026-01-09 02:44:19.13615
87	3	42	42	[314]	\N	Kajian Implementasi Ekonomi Hijau dan Mekanisme Imbal Jasa Air di Koridor Ekosistem RIMBA	dokumen	\N	<p><span data-path-to-node="2,1"><span class="citation-5">Materi ini memaparkan kajian komprehensif mengenai transisi menuju ekonomi hijau di Koridor RIMBA (Riau, Jambi, dan Sumatera Barat) melalui pengembangan mekanisme imbal jasa air (IJA) dan Solusi Berbasis Alam (</span><em data-path-to-node="2,1" data-index-in-node="210"><span class="citation-5">Nature-based Solutions</span></em><span class="citation-5">)</span></span><span class="citation-5 citation-end-5"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,3">. </span><span class="citation-4">Fokus utama kajian meliputi pengembangan skema IJA untuk sektor energi hidroelektrik di DAS Batang Merao guna menjaga debit air dan menekan laju sedimentasi, serta untuk industri air minum dalam kemasan di DAS Nilo, Kabupaten Merangin</span><span class="citation-4 citation-end-4"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,7">. </span><span class="citation-3">Selain merumuskan alternatif restorasi ekosistem seluas 2,5 juta hektar, dokumen ini juga mengidentifikasi berbagai tantangan strategis seperti keterbatasan kapasitas lokal, kebutuhan regulasi yang mendukung, serta pentingnya peran Komite Sekretariat RIMBA dalam menjamin keberlanjutan tata kelola sumber daya alam di wilayah hulu</span><span class="citation-3 citation-end-3"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,11">.</span></p>	\N	2026-01-09 04:23:12.443111	2026-01-09 04:23:12.443111
88	4	42	42	[315]	\N	Peninjauan Deliniasi dan Pengkajian Koridor RIMBA sebagai Usulan Kawasan Strategis Nasional dalam Revisi RTRWN	dokumen	\N	<p><span class="citation-20">Materi ini membahas hasil pengkajian dan peninjauan kembali deliniasi Koridor RIMBA (Riau, Jambi, dan Sumatera Barat) yang diusulkan menjadi Kawasan Strategis Nasional (KSN) dalam rangka revisi Rencana Tata Ruang Wilayah Nasional (RTRWN)</span><span class="citation-20 citation-end-20"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,3">. </span><span class="citation-19">Fokus utama kajian ini adalah menyiapkan batas wilayah koridor ekosistem yang sesuai dengan kondisi terkini untuk menjaga habitat satwa penting seperti gajah, harimau, dan burung, serta mewujudkan pembangunan ekonomi hijau yang berkelanjutan di wilayah tersebut</span><span class="citation-19 citation-end-19"><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,7">. </span><span class="citation-18">Melalui pendekatan analisis kawasan lindung, kesesuaian habitat, dan konektivitas, dokumen ini menyajikan data luas usulan kawasan lindung di berbagai provinsi di Sumatera sekaligus mengidentifikasi tantangan koordinasi intensif antar pemangku kepentingan yang diperlukan untuk pengelolaan ekosistem pada skala mikro di lapangan</span><span class="citation-18 citation-end-18"><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup><sup class="superscript" data-turn-source-index="3"><!----></sup></span></p>	\N	2026-01-09 04:25:08.529862	2026-01-09 04:25:08.529862
90	7	42	42	[317]	\N	Kajian Konektivitas Jalur Lintasan dan Teritori Satwa Liar di Klaster 1 Koridor RIMBA	dokumen	\N	<p><span class="citation-39">Materi ini menyajikan hasil kajian mendalam mengenai konektivitas ekosistem dan jalur pergerakan satwa liar kharismatik Sumatera, seperti harimau, gajah, tapir, dan beruang, di wilayah Klaster 1 Koridor RIMBA</span><span class="citation-39 citation-end-39"><sup class="superscript" data-turn-source-index="1"><!----></sup><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,3">. </span><span class="citation-38">Melalui pemetaan distribusi satwa dan analisis kualitas habitat, kajian ini bertujuan untuk merancang desain koridor alami maupun buatan guna mengatasi fragmentasi habitat yang disebabkan oleh pembangunan infrastruktur dan alih fungsi lahan</span><span class="citation-38 citation-end-38"><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,7">. </span><span class="citation-37">Dokumen ini menyimpulkan bahwa meskipun terdapat beberapa titik fragmentasi, jalur lintasan alami di wilayah ini masih memegang peran krusial dalam menjaga keseimbangan ekologi dan mencegah isolasi populasi satwa</span><span class="citation-37 citation-end-37"><sup class="superscript" data-turn-source-index="3"><!----></sup></span><span data-path-to-node="2,11">. </span><span class="citation-36">Implementasi rekomendasi dari kajian ini diharapkan dapat menjamin koeksistensi yang harmonis antara pembangunan ekonomi masyarakat dengan upaya pelestarian biodiversitas di pulau Sumatera</span><span class="citation-36 citation-end-36"><sup class="superscript" data-turn-source-index="4"><!----></sup></span></p>	\N	2026-01-09 04:28:39.252889	2026-01-09 04:28:39.252889
91	8	42	42	[318]	\N	Peninjauan RPHJP-KPH dan RTRW Berbasis Pengelolaan Gambut Berkelanjutan di Klaster II Koridor RIMBA	dokumen	\N	<p><span class="citation-49">Materi ini membahas peninjauan Rencana Pengelolaan Hutan Jangka Panjang (RPHJP) dan Rencana Tata Ruang Wilayah (RTRW) yang difokuskan pada pelestarian ekosistem gambut di Provinsi Jambi, khususnya Klaster II Koridor RIMBA</span><span class="citation-49 citation-end-49"><sup class="superscript" data-turn-source-index="1"><!----></sup></span><span data-path-to-node="2,3">. </span><span class="citation-48">Kajian ini menyoroti urgensi perlindungan lahan gambut dari ancaman deforestasi dan kebakaran melalui strategi restorasi hidrologi, seperti pembangunan sekitar 275 unit infrastruktur pembasahan gambut (sekat kanal) serta penetapan kawasan gambut dengan kedalaman lebih dari 300 cm sebagai zona konservasi</span><span class="citation-48 citation-end-48"><sup class="superscript" data-turn-source-index="2"><!----></sup></span><span data-path-to-node="2,7">. </span><span class="citation-47">Selain teknis pemulihan fisik, dokumen ini juga merekomendasikan pengembangan pola agroforestri pada areal perhutanan sosial untuk meningkatkan kesejahteraan ekonomi masyarakat lokal tanpa merusak fungsi ekologis ekosistem gambut yang kaya akan keanekaragaman hayati</span><span class="citation-47 citation-end-47"><sup class="superscript" data-turn-source-index="3"><!----></sup></span></p>	\N	2026-01-09 04:29:48.450641	2026-01-09 04:29:48.450641
92	9	42	42	[319]	\N	Fasilitasi Perencanaan Penggunaan Lahan Partisipatif di Lahan Gambut dan Penguatan Masyarakat Peduli Api (MPA)	dokumen	\N	<p>Materi ini mengulas upaya fasilitasi perencanaan tata guna lahan secara partisipatif dan penguatan kapasitas Masyarakat Peduli Api (MPA) di ekosistem gambut Klaster II Koridor RIMBA, khususnya di Kabupaten Tanjung Jabung Timur dan Muaro Jambi. Program ini fokus pada pemulihan lahan gambut yang terdegradasi akibat kebakaran hutan dan pembuatan kanal drainase melalui strategi diversifikasi komoditi ramah lingkungan serta pengembangan potensi ekowisata, seperti di Danau Rasau dan persawahan Rimbo Piatu. Selain pemetaan spasial desa, dokumen ini menekankan pentingnya mitigasi bencana melalui pembangunan infrastruktur pencegah banjir dan abrasi serta edukasi masyarakat untuk meninggalkan praktik perkebunan monokultur sawit demi menjaga stok karbon, konektivitas hutan, dan keberlanjutan ekonomi lokal secara inklusif</p>	\N	2026-01-09 04:32:01.558355	2026-01-09 04:32:01.558355
93	10	42	42	[320]	\N	Integrasi Strategi Ekonomi Hijau dalam Dokumen Perencanaan dan Pembangunan Daerah di Koridor RIMBA	dokumen	\N	<p>Materi ini membahas hasil kajian mengenai pengarusutamaan prinsip Ekonomi Hijau ke dalam dokumen perencanaan daerah, seperti RPJMD, RTRW Kabupaten, dan KLHS, di wilayah yang mencakup tiga klaster Koridor RIMBA. Dengan menggunakan metodologi analisis spasial tingkat lanjut seperti <em data-path-to-node="2" data-index-in-node="281">Cellular Automata</em> untuk proyeksi perubahan lahan dan analisis daya dukung IGT (Informasi Geospasial Tematik), kajian ini merumuskan rekomendasi kebijakan yang mensinergikan pembangunan ekonomi dengan pelestarian fungsi lindung ekosistem sesuai amanat Perpres No. 13/2012. Dokumen ini juga mengidentifikasi tantangan dalam optimalisasi pendanaan dan pengendalian ruang melalui skema insentif-disinsentif, serta menyajikan album peta tematik mengenai konektivitas habitat satwa besar sebagai basis pengambilan keputusan yang berkelanjutan di tingkat daerah.</p>	\N	2026-01-09 04:32:46.747708	2026-01-09 04:32:46.747708
94	11	42	42	[321]	\N	Pengembangan Sistem Pemantauan, Evaluasi, dan Platform Spasial Program Koridor RIMBA	dokumen	\N	<p>Materi ini menguraikan pembangunan sistem monitoring dan evaluasi (Monev) serta platform spasial yang dirancang untuk mengawasi seluruh paket kegiatan Program Koridor RIMBA di Provinsi Riau, Jambi, dan Sumatera Barat. Sistem ini berfungsi sebagai instrumen transparansi dan media publikasi yang mengintegrasikan data lapangan ke dalam fitur peta interaktif, akses metadata, serta peta cetak guna memastikan setiap tahapan pembangunan ekonomi hijau berjalan sesuai rencana. Dengan menggunakan metode pengembangan perangkat lunak yang sistematis&mdash;mulai dari perencanaan hingga pemeliharaan&mdash;platform ini menjawab tantangan standarisasi data antar-pemangku kepentingan, sehingga memudahkan koordinasi multi-sektor dalam menjaga keberlanjutan ekosistem koridor secara <em data-path-to-node="2" data-index-in-node="762">real-time</em> dan berbasis data spasial yang akurat</p>	\N	2026-01-09 04:33:46.314681	2026-01-09 04:33:46.314681
95	12	42	42	[322]	\N	Strategi Komunikasi dan Penyebarluasan Informasi Perwujudan Ekonomi Hijau di Koridor Ekosistem RIMBA	dokumen	\N	<p>Materi ini menguraikan upaya strategis dalam mendiseminasikan informasi mengenai program Ekonomi Hijau dan pelestarian ekosistem di wilayah Riau, Jambi, dan Sumatera Barat melalui berbagai platform komunikasi terintegrasi. Fokus utama dari kegiatan ini adalah meningkatkan kesadaran publik (<em data-path-to-node="2" data-index-in-node="291">awareness</em>) melalui pengelolaan media sosial, publikasi pada Buletin Tata Ruang (Butaru), pembuatan video profil, serta penyusunan materi edukatif seperti banner dan flyer. Dengan menghadirkan konten informatif mulai dari berita terkini hingga infografis, program ini bertujuan untuk memastikan seluruh pemangku kepentingan dan masyarakat luas memahami pentingnya konektivitas hutan serta praktik konsumsi dan produksi yang berkelanjutan demi menjaga keberlangsungan ekosistem RIMBA secara jangka panjaang</p>\r\n<p>&nbsp;</p>	\N	2026-01-09 04:37:03.215083	2026-01-09 04:37:03.215083
98	5	42	42	[325]	\N	Paket 6A: Peninjauan RPHJP Kawasan Hutan dan Penataan Kawasan Penyangga pada KPH Singingi	dokumen	\N	<p>Kajian ini berfokus pada penyempurnaan Rencana Pengelolaan Hutan Jangka Panjang (RPHJP) di KPH Singingi untuk periode 2025-2034 dengan mengintegrasikan prinsip-prinsip ekonomi hijau. Dokumen ini mengidentifikasi tantangan serius seperti okupasi lahan sawit ilegal dan deforestasi, lalu merumuskan solusi melalui pendekatan perhutanan sosial, pengembangan ekowisata, agroforestri, serta penegakan hukum yang tegas terhadap kegiatan tak berizin di kawasan hutan lindung guna memastikan layanan alam seperti air dan keanekaragaman hayati tetap terjaga.</p>	\N	2026-01-09 04:57:41.476025	2026-01-09 04:57:41.476025
99	6	42	42	[326]	\N	Fasilitasi Perencanaan Penggunaan Lahan Partisipatif Kawasan Pedesaan di Klaster I	dokumen	\N	<p>Materi ini menjelaskan proses fasilitasi perencanaan tata guna lahan yang melibatkan partisipasi aktif masyarakat desa di Kabupaten Kampar, Kuantan Singingi, dan Sijunjung melalui metode <em data-path-to-node="10" data-index-in-node="187">Participatory Land Use Planning</em> (PLUP). Hasil utama dari kegiatan ini meliputi dokumen rencana tata ruang desa dan peta penggunaan lahan masyarakat yang bertujuan menyelaraskan kebutuhan ekonomi warga dengan upaya perlindungan jalur kritis koridor satwa, serta menciptakan kesepakatan pemanfaatan lahan yang sesuai dengan regulasi otoritas pengelola kawasan setempat.</p>	\N	2026-01-09 04:58:11.485799	2026-01-09 04:58:11.485799
100	8	42	42	[327]	\N	Peninjauan RPHJP-KPH dan RTRW Berbasis Pengelolaan Gambut Berkelanjutan di Klaster II	dokumen	\N	<p>Materi ini membahas evaluasi rencana pengelolaan hutan dan tata ruang wilayah dengan penekanan khusus pada pelestarian ekosistem gambut di Provinsi Jambi guna memitigasi bencana kebakaran dan deforestasi. Rekomendasi strategis yang dihasilkan mencakup restorasi hidrologi melalui pembangunan sekitar 275 unit infrastruktur pembasahan gambut (sekat kanal), penetapan area gambut dalam sebagai kawasan konservasi, serta mendorong penggunaan pola agroforestri pada lahan perhutanan sosial agar masyarakat tetap produktif tanpa merusak ekosistem lahan basah.</p>	\N	2026-01-09 04:59:26.212588	2026-01-09 04:59:26.212588
101	9	42	42	[328]	\N	Fasilitasi Perencanaan Lahan Partisipatif Gambut dan Penguatan Masyarakat Peduli Api	dokumen	\N	<p>Kajian ini memfokuskan pada pemberdayaan masyarakat di Kabupaten Tanjung Jabung Timur dan Muaro Jambi dalam mengelola lahan gambut yang terdegradasi melalui perencanaan partisipatif dan penguatan kelompok Masyarakat Peduli Api (MPA). Program ini mendorong diversifikasi komoditas ramah lingkungan selain sawit, pengembangan destinasi ekowisata berbasis air, serta pembangunan infrastruktur mitigasi bencana seperti DAM untuk mengatasi banjir dan abrasi, guna menjamin keberlanjutan ekonomi desa sekaligus menjaga stok karbon di wilayah tersebut.</p>	\N	2026-01-09 05:00:06.251548	2026-01-09 05:00:06.251548
102	10	42	42	[329]	\N	Kajian Pendekatan Ekonomi Hijau dalam Penyusunan Dokumen Perencanaan Daerah	dokumen	\N	<p>Materi ini mengulas integrasi prinsip ekonomi hijau ke dalam dokumen perencanaan daerah (RPJMD, RTRW, dan KLHS) di tiga provinsi Koridor RIMBA dengan menggunakan metodologi analisis spasial <em data-path-to-node="18" data-index-in-node="190">Cellular Automata</em>. Dokumen ini menyediakan album peta tematik konektivitas ekosistem kritis dan distribusi satwa besar sebagai basis rekomendasi kebijakan, dengan tantangan utama pada optimalisasi sinkronisasi pendanaan serta sistem insentif-disinsentif bagi daerah yang berhasil mempertahankan kawasan berfungsi lindung</p>	\N	2026-01-09 05:00:42.410612	2026-01-09 05:00:42.410612
103	11	42	42	[330]	\N	Sistem Pemantauan, Evaluasi, dan Platform Spasial Program Koridor RIMBA	dokumen	\N	<p>Dokumen ini memaparkan pengembangan sistem monitoring terpadu dan platform spasial digital yang dirancang untuk mengawasi pelaksanaan seluruh paket kegiatan ekonomi hijau di Koridor RIMBA. Platform ini menyediakan fitur peta interaktif dan akses metadata yang memudahkan para pemangku kepentingan untuk memantau progres lapangan secara transparan, memastikan akurasi data antar-wilayah administrasi, serta menjadi instrumen evaluasi berkala bagi keberlanjutan program pelestarian ekosistem di Riau, Jambi, dan Sumatera Barat</p>	\N	2026-01-09 05:01:18.551517	2026-01-09 05:01:18.551517
104	3	42	42	[331]	\N	Kajian Perubahan Sikap terhadap Ekonomi Hijau dan Pengembangan Mekanisme Imbal Jasa Air (IJA) di Wilayah Hulu DAS Batanghari	dokumen	\N	<p>Materi ini membahas hasil kajian mengenai transisi menuju ekonomi hijau di wilayah hulu Daerah Aliran Sungai (DAS) Batanghari, khususnya di Kabupaten Kerinci, Merangin, dan Kota Sungai Penuh, melalui pengembangan mekanisme Imbal Jasa Air (IJA) dan Solusi Berbasis Alam (<em data-path-to-node="2" data-index-in-node="270">Nature-based Solutions</em>). Fokus utama kajian ini adalah merancang skema kompensasi berkelanjutan bagi sektor energi hidroelektrik guna menekan laju sedimentasi dan menjaga debit air yang kian menurun akibat alih fungsi lahan dan aktivitas pertambangan galian C. Dengan mengintegrasikan model restorasi yang sesuai karakteristik lokal dan kerangka regulasi yang fleksibel, program ini bertujuan untuk mensinergikan perlindungan ekosistem hutan dengan kebutuhan ekonomi sektor swasta dan kesejahteraan masyarakat di sepanjang Koridor RIMBA.</p>	\N	2026-01-09 05:02:49.146391	2026-01-09 05:02:49.146391
105	16	42	42	[332]	\N	Integrasi Kebijakan Tata Ruang dan Strategi Zonasi Koridor Ekosistem RIMBA Berbasis Ekonomi Hijau	dokumen	\N	<p>Materi ini menguraikan kajian strategis mengenai integrasi kebijakan tata ruang lintas matra (darat, laut, udara, dan dalam bumi) di Koridor Ekosistem RIMBA yang menggabungkan berbagai Rencana Tata Ruang Kawasan Strategis Nasional (RTR KSN) eksisting, seperti TN Kerinci Seblat, HL Bukit Batabuh, dan TN Berbak-Bukit Tigapuluh. Dokumen ini merumuskan struktur zonasi yang komprehensif&mdash;mulai dari Zona Inti sebagai perlindungan biodiversitas mutlak, hingga Zona Penyangga dan Transisi baik di wilayah hulu maupun hilir&mdash;guna memastikan konektivitas habitat satwa liar tetap terjaga di tengah aktivitas pembangunan. Dengan mengedepankan prinsip ekonomi hijau, integrasi ini bertujuan untuk menyelaraskan kepentingan lintas sektor seperti kehutanan, pertambangan, dan masyarakat adat dalam satu kerangka perencanaan terpadu yang adaptif terhadap daya dukung lingkungan dan perlindungan hidrologi di Pulau Sumatera.</p>	\N	2026-01-09 06:17:01.387293	2026-01-09 06:17:01.387293
112	23	42	42	[339]	\N	Infografi Kajian dan Fasilitasi Ekonomi Hijau serta Konservasi di Sumatra (2025)	dokumen	\N	<p dir="auto">Dokumen ini merupakan kumpulan infografis dari berbagai laporan pendahuluan dan antara tahun 2025 dalam Program Koridor Ekosistem RIMBA, didukung oleh UN Environment Programme, Global Environment Facility, dan institusi seperti IPB University. Infografis-infografis tersebut menampilkan sampul visual dengan dominasi warna hijau, foto lanskap hutan lebat Sumatra, harimau Sumatera, gajah, rangkong, peta koridor penghubung Riau-Jambi-Sumatera Barat, elemen warisan budaya seperti candi Muara Takus dan menara observasi, grafik pasar saham, serta ilustrasi jalan melintasi hutan, yang secara keseluruhan menggambarkan integrasi antara pelestarian biodiversitas, konektivitas ekosistem, investasi ekonomi hijau, insentif tata ruang termasuk imbal jasa ekosistem, panduan produksi-konsumsi berkelanjutan, serta solusi partisipatif untuk permukiman tidak berizin di kawasan lindung.</p>	\N	2026-01-09 06:35:03.140856	2026-01-09 06:35:03.140856
106	16	42	42	[333]	\N	[English Version] Integration of Spatial Planning Policies and Zoning Strategies for the RIMBA Ecosystem Corridor Based on the Green Economy	dokumen	\N	<p>This material outlines a strategic study on the integration of cross-sectoral spatial planning policies (land, sea, air, and underground) in the RIMBA Ecosystem Corridor, which combines various existing National Strategic Area Spatial Plans (RTR KSN), such as Kerinci Seblat National Park, Bukit Batabuh Forest Reserve, and Berbak-Bukit Tigapuluh National Park. This document formulates a comprehensive zoning structure&mdash;ranging from Core Zones for absolute biodiversity protection to Buffer and Transition Zones in both upstream and downstream areas&mdash;to ensure the connectivity of wildlife habitats is maintained amid development activities. By prioritizing the principles of green economy, this integration aims to harmonize cross-sectoral interests such as forestry, mining, and indigenous communities within a single integrated planning framework that is adaptive to the environmental carrying capacity and hydrological protection of the island of Sumatra.</p>\r\n<p>&nbsp;</p>\r\n<p><em>Translated with <a href="https://www.deepl.com/?utm_campaign=product&amp;utm_source=web_translator&amp;utm_medium=web&amp;utm_content=copy_free_translation">DeepL.com</a> (free version)</em></p>	\N	2026-01-09 06:19:44.996733	2026-01-09 06:19:44.996733
107	17	42	42	[334]	\N	Integration of Spatial Planning Policies and Zoning Strategies for the RIMBA Ecosystem Corridor Based on the Green Economy	dokumen	\N	<p>Materi ini menyajikan kerangka komprehensif mengenai penyusunan Rencana Tata Ruang Kawasan Strategis Nasional (RTR KSN) di Taman Nasional Sembilang yang mengintegrasikan aspek perlindungan lingkungan dengan pembangunan ekonomi hijau-biru yang inklusif. Melalui pendekatan delineasi berbasis keterkaitan ekologis lintas wilayah Jambi dan Sumatera Selatan, dokumen ini menyoroti isu-isu strategis seperti degradasi 266.097 hektar lahan gambut, hilangnya kawasan mangrove, serta fragmentasi habitat satwa kunci dan burung migran di jalur EAAF. Dengan mengandalkan instrumen Kajian Lingkungan Hidup Strategis (KLHS), materi ini merumuskan struktur dan pola ruang yang bertujuan untuk menjaga kelestarian ekosistem lahan basah bernilai global sekaligus memperkuat mitigasi bencana dan konektivitas ekologis di sepanjang koridor pesisir Sumatera.</p>	\N	2026-01-09 06:21:57.093862	2026-01-09 06:21:57.093862
108	18	42	42	[335]	\N	Kajian Bentuk dan Pengembangan Kelembagaan Ekonomi Hijau di Koridor Ekosistem RIMBA	dokumen	\N	<p>Materi ini memaparkan urgensi pembentukan kelembagaan yang kuat dan berkelanjutan untuk mengelola Koridor Ekosistem RIMBA guna mengatasi tantangan fragmentasi tata kelola lintas sektor serta tumpang tindih pemanfaatan ruang di wilayah Riau, Jambi, dan Sumatera Barat. Melalui model Badan Pengelola Koridor Ekosistem RIMBA yang bersifat kolaboratif (<em data-path-to-node="2" data-index-in-node="349">pentahelix</em>), dokumen ini merumuskan struktur organisasi yang melibatkan kementerian terkait, pemerintah daerah, dan sektor swasta untuk menjamin implementasi terpadu tiga Kawasan Strategis Nasional (KSN). Strategi ini difokuskan pada penguatan koordinasi tata kelola bentang alam (<em data-path-to-node="2" data-index-in-node="630">landscape</em>), transformasi ekonomi hijau, dan peningkatan kesejahteraan masyarakat melalui pengelolaan modal alam yang berkelanjutan demi menjaga keberlangsungan ekosistem jangka panjang.</p>	\N	2026-01-09 06:22:59.372077	2026-01-09 06:22:59.372077
109	20	42	42	[336]	\N	Penyusunan Strategi Komunikasi dan Perubahan Perilaku (SBCC) untuk Implementasi Ekonomi Hijau di Koridor RIMBA	dokumen	\N	<p>Materi ini menguraikan perancangan strategi komunikasi berbasis perubahan perilaku sosial (<em data-path-to-node="2" data-index-in-node="91">Social Behavior Change Communication</em> &mdash; SBCC) untuk mendukung implementasi ekonomi hijau dan visi "Indonesia Emas 2045" di wilayah Koridor RIMBA. Fokus utama kegiatan ini adalah mengatasi hambatan komunikasi seperti rendahnya kesadaran publik dan resistensi terhadap praktik berkelanjutan melalui identifikasi persepsi pemangku kepentingan serta penyusunan pesan kunci yang kreatif dan relevan di berbagai sektor, mulai dari agroforestri hingga perdagangan karbon. Dengan mengintegrasikan metode advokasi, mobilisasi sosial, dan kampanye publik, strategi ini bertujuan mengubah paradigma masyarakat&mdash;seperti transisi dari pembakaran lahan ke kesadaran ekologis&mdash;guna memastikan keberlanjutan lingkungan dan efektivitas Rencana Tata Ruang Kawasan Strategis Nasional di Pulau Sumatera.</p>	\N	2026-01-09 06:24:43.990797	2026-01-09 06:24:43.990797
110	20	42	42	[337]	\N	[English Version] Development of a Communication and Behavior Change Strategy (SBCC) for Green Economy Implementation in the RIMBA Corridor	dokumen	\N	<p>This material outlines the design of a social behavior change communication (SBCC) strategy to support the implementation of a green economy and the &ldquo;Golden Indonesia 2045&rdquo; vision in the RIMBA Corridor region. The main focus of this activity is to overcome communication barriers such as low public awareness and resistance to sustainable practices by identifying stakeholder perceptions and developing creative and relevant key messages across various sectors, ranging from agroforestry to carbon trading. By integrating advocacy, social mobilization, and public campaign methods, this strategy aims to change community paradigms&mdash;such as the transition from land burning to ecological awareness&mdash;to ensure environmental sustainability and the effectiveness of the National Strategic Area Spatial Plan on the island of Sumatra.</p>\r\n<p>&nbsp;</p>	\N	2026-01-09 06:25:42.529355	2026-01-09 06:25:42.529355
111	23	42	42	[338]	\N	Kajian dan Fasilitasi Ekonomi Hijau serta Konservasi di Sumatra (2025)	dokumen	\N	<p dir="auto">Dokumen ini merupakan kumpulan infografis dari berbagai laporan pendahuluan dan antara tahun 2025 dalam Program Koridor Ekosistem RIMBA, didukung oleh UN Environment Programme, Global Environment Facility, dan institusi seperti IPB University. Infografis-infografis tersebut menampilkan sampul visual dengan dominasi warna hijau, foto lanskap hutan lebat Sumatra, harimau Sumatera, gajah, rangkong, peta koridor penghubung Riau-Jambi-Sumatera Barat, elemen warisan budaya seperti candi Muara Takus dan menara observasi, grafik pasar saham, serta ilustrasi jalan melintasi hutan, yang secara keseluruhan menggambarkan integrasi antara pelestarian biodiversitas, konektivitas ekosistem, investasi ekonomi hijau, insentif tata ruang termasuk imbal jasa ekosistem, panduan produksi-konsumsi berkelanjutan, serta solusi partisipatif untuk permukiman tidak berizin di kawasan lindung.</p>	\N	2026-01-09 06:33:46.231339	2026-01-09 06:33:46.231339
113	23	42	42	[340]	\N	[English Version] Green Economy and Conservation Assessment and Facilitation in Sumatra (2025)	dokumen	\N	<p>This document is a collection of infographics from various preliminary and interim reports for the year 2025 in the RIMBA Ecosystem Corridor Program, supported by the UN Environment Programme, Global Environment Facility, and institutions such as IPB University. The infographics feature visual covers dominated by green colors, photos of Sumatra's dense forest landscapes, Sumatran tigers, elephants, hornbills, maps of the Riau-Jambi -West Sumatra, cultural heritage elements such as the Muara Takus temple and observation tower, stock market charts, and illustrations of roads crossing forests, which collectively illustrate the integration of biodiversity conservation, ecosystem connectivity, green economy investments, spatial planning incentives including ecosystem services payments, sustainable production-consumption guidelines, and participatory solutions for unauthorized settlements in protected areas.</p>	\N	2026-01-09 06:36:24.579387	2026-01-09 06:36:24.579387
114	25	42	42	[341]	\N	Pengembangan dan Redesain Sistem Knowledge Management Information System (KMIS) untuk Kawasan Koridor Ekosistem RIMBA	gambar	\N	<p dir="auto">Paket 6 RIMBA 2025 merupakan inisiatif dari Kementerian Agraria dan Tata Ruang/Badan Pertanahan Nasional (ATR/BPN) yang fokus pada pengembangan dan redesain sistem informasi berbasis web untuk Knowledge Management Information System (KMIS) di Kawasan Koridor Ekosistem RIMBA, meliputi wilayah strategis seluas 3,8 juta hektare di Provinsi Riau, Jambi, dan Sumatera Barat. Kegiatan ini bertujuan memperkuat pemantauan, evaluasi, dan diseminasi pengetahuan melalui integrasi data spasial, interoperabilitas dengan sistem pemerintah lain, modul investasi perdagangan karbon, aplikasi kepatuhan ekonomi hijau, pengukuran dampak proyek, serta penambahan dashboard dan konten edukatif, guna mendukung pengelolaan berkelanjutan, konservasi keanekaragaman hayati, dan pembangunan ekonomi hijau yang bermanfaat bagi pemerintah pusat, daerah, serta kelestarian ekosistem RIMBA.</p>	\N	2026-01-09 06:39:00.809363	2026-01-09 06:39:00.809363
115	25	42	42	[342]	\N	[English Version] Development and Redesign of the Knowledge Management Information System (KMIS) for the RIMBA Ecosystem Corridor Area	gambar	\N	<p dir="auto">Package 6 of RIMBA 2025 is an initiative by the Ministry of Agrarian Affairs and Spatial Planning/National Land Agency (ATR/BPN) focused on the development and redesign of a web-based information system for the Knowledge Management Information System (KMIS) in the RIMBA Ecosystem Corridor Area, covering a strategic region of 3.8 million hectares across the provinces of Riau, Jambi, and West Sumatra. This activity aims to enhance monitoring, evaluation, and knowledge dissemination through spatial data integration, interoperability with other government systems, a carbon trading investment module, green economy compliance applications, actual project impact assessments, as well as additional dashboards and educational content, to support sustainable management, biodiversity conservation, and green economy development that benefits central and local governments as well as the preservation of the RIMBA ecosystem.</p>	\N	2026-01-09 06:39:50.066192	2026-01-09 06:39:50.066192
116	26	42	42	[343]	\N	Fasilitasi Integrasi Pendekatan Ekonomi Hijau dalam Dokumen Rencana Spasial dan Rencana Pembangunan di Kawasan Koridor Ekosistem RIMBA	gambar	\N	<p dir="auto">Program Koridor Ekosistem RIMBA, yang mencakup wilayah strategis seluas 3,8 juta hektare di Provinsi Riau, Jambi, dan Sumatera Barat, merupakan inisiatif untuk mewujudkan ekonomi hijau yang berkelanjutan melalui transisi rendah emisi, pelestarian keanekaragaman hayati, dan pencapaian target Net Zero Emission 2060. Fasilitasi ini bertujuan mengintegrasikan prinsip ekonomi hijau&mdash;seperti pembangunan rendah karbon, pengelolaan ekosistem, dan peningkatan indeks ekonomi hijau&mdash;ke dalam dokumen rencana spasial (RTR KS N, RTRW Provinsi/Kabupaten/Kota) serta rencana pembangunan daerah (RPJMD, RKPD), dengan langkah-langkah transformasi meliputi identifikasi rencana, sinkronisasi hasil integrasi, penentuan program prioritas, dan penyusunan rekomendasi prioritas ekonomi hijau, guna mendukung pembangunan daerah yang ramah lingkungan, peningkatan kesejahteraan masyarakat, serta pelestarian habitat satwa ikonik seperti harimau dan gajah Sumatera.</p>	\N	2026-01-09 06:41:55.62551	2026-01-09 06:41:55.62551
117	26	42	42	[344]	\N	[English Version] Facilitation of Green Economy Approach Integration in Spatial Planning and Development Documents in the RIMBA Ecosystem Corridor Area	gambar	\N	<p dir="auto">The RIMBA Ecosystem Corridor Program, covering a strategic area of 3.8 million hectares across the provinces of Riau, Jambi, and West Sumatra, is an initiative to realize a sustainable green economy through low-emission transitions, biodiversity conservation, and achieving the Net Zero Emission target by 2060. This facilitation aims to integrate green economy principles&mdash;such as low-carbon development, ecosystem management, and enhancing the green economy index&mdash;into spatial planning documents (National Strategic Area Spatial Plans, Provincial/Regency/City Spatial Plans) and regional development plans (RPJMD, RKPD), involving transformation steps including plan identification, synchronization of integration results, determination of priority programs, and formulation of green economy priority recommendations, to support environmentally friendly regional development, improved community welfare, and preservation of iconic wildlife habitats such as Sumatran tigers and elephants.</p>	\N	2026-01-09 06:43:06.838515	2026-01-09 06:43:06.838515
118	27	42	42	[345]	\N	Partisipasi dan Publikasi Ekonomi Hijau Secara Nasional dan/atau Internasional untuk Program Koridor Ekosistem RIMBA 	dokumen	\N	<p dir="auto">Paket 8 Program Koridor Ekosistem RIMBA tahun 2025 bertujuan meningkatkan eksposur dan pemahaman masyarakat terhadap inisiatif ekonomi hijau di koridor ekosistem Riau-Jambi-Sumatera Barat melalui berbagai kegiatan komunikasi dan diseminasi. Kegiatan ini mencakup penulisan karya ilmiah populer, pembuatan infografis, foto beresolusi tinggi, serta video profil program; pengelolaan aktif media sosial @koridor.rimba dengan konten edukatif dan interaktif; eksplorasi literatur tentang ekonomi hijau, keanekaragaman hayati, dan pembangunan rendah emisi; serta kolaborasi dalam konferensi dan pameran nasional/internasional seperti CDC 2025 dan ICI 2025. Seluruh upaya ini diarahkan untuk memperluas jangkauan program, mendidik publik, serta mendorong partisipasi stakeholder dalam mewujudkan pembangunan berkelanjutan dan pelestarian ekosistem RIMBA.</p>	\N	2026-01-09 06:45:47.534765	2026-01-09 06:45:47.534765
119	27	42	42	[346]	\N	[English Version] National and/or International Participation and Publication of Green Economy for the RIMBA Ecosystem Corridor Program	dokumen	\N	<p dir="auto">Package 8 of the 2025 RIMBA Ecosystem Corridor Program aims to enhance exposure and public understanding of green economy initiatives in the Riau-Jambi-West Sumatra ecosystem corridor through various communication and dissemination activities. These include writing popular scientific publications, creating infographics, high-resolution photos, and program profile videos; active management of the @koridor.rimba social media with educational and interactive content; literature exploration on green economy, biodiversity, and low-emission development; as well as collaboration in national/international conferences and exhibitions such as CDC 2025 and ICI 2025. All these efforts are directed towards expanding the program's reach, educating the public, and encouraging stakeholder participation in achieving sustainable development and preservation of the RIMBA ecosystem.</p>	\N	2026-01-09 06:47:27.106678	2026-01-09 06:47:27.106678
120	31	42	42	[347]	\N	Program Koridor RIMBA: Mewujudkan Ekonomi Hijau di Sumatera	gambar	\N	<p>Infografis ini menyajikan rencana strategis Program Koridor RIMBA, sebuah inisiatif konservasi di jantung Sumatra yang mencakup wilayah Riau, Jambi, dan Sumatra Barat. Fokus utama program ini adalah peninjauan Rencana Pengelolaan Hutan Jangka Panjang (RPHJP) untuk memulihkan koridor satwa liar, konektivitas lanskap, dan fungsi daerah aliran sungai (DAS), khususnya di Klaster III (Kabupaten Kerinci dan Merangin).</p>	\N	2026-01-09 06:55:31.216164	2026-01-09 06:55:31.216164
121	31	42	42	[348]	\N	[English Version] RIMBA Corridor Program: Realizing a Green Economy in Sumatra	gambar	\N	<p>This infographic presents the strategic plan for the RIMBA Corridor Program, a conservation initiative in the heart of Sumatra covering the provinces of Riau, Jambi, and West Sumatra. The program's main focus is the review of the Long-Term Forest Management Plan (RPHJP) to restore wildlife corridors, landscape connectivity, and watershed functions, particularly in Cluster III (Kerinci and Merangin Regencies).</p>	\N	2026-01-09 06:56:30.383703	2026-01-09 06:56:30.383703
122	32	42	42	[349]	\N	Penguatan Kapasitas Multi Pihak dan Analisis Strategis Skema Payment for Water Services (PWS) di Klaster III Koridor RIMBA	dokumen	\N	<p>Materi ini memaparkan hasil analisis mendalam mengenai hidrologi, risiko kebencanaan, dan spasial sebagai landasan ilmiah untuk mengembangkan skema Imbal Jasa Air (<em data-path-to-node="2" data-index-in-node="164">Payment for Water Services</em>) di wilayah hulu Provinsi Jambi, khususnya Lanskap Kerinci. Fokus utama kajian ini adalah memitigasi dampak perubahan tutupan lahan yang memicu peningkatan risiko banjir, erosi, dan tanah longsor melalui penguatan kapasitas multi pihak dalam mengelola kawasan penyangga Taman Nasional Kerinci Seblat (TNKS). Dengan mengintegrasikan skema perhutanan sosial dan mekanisme insentif berbasis fungsi ekosistem, program ini bertujuan untuk menciptakan keseimbangan ekonomi yang inklusif antara pelestarian lanskap di wilayah hulu dengan keberlanjutan penyediaan jasa air bagi pengguna di wilayah hilir demi mendukung implementasi ekonomi hijau yang berkelanjutan.</p>	\N	2026-01-09 06:58:14.900607	2026-01-09 06:58:14.900607
123	19	42	42	[350]	\N	Kajian Insentif dan Disinsentif dalam Pengelolaan Koridor RIMBA (Riau-Jambi-Sumatera Barat)	gambar	\N	<p>Infografik ini memaparkan rencana strategis Program Koridor RIMBA untuk mewujudkan ekonomi hijau melalui pengelolaan tata ruang yang berkelanjutan di wilayah Riau, Jambi, dan Sumatera Barat. Program ini menyoroti berbagai tantangan kritis seperti degradasi lahan dan konflik tenurial, serta menawarkan solusi melalui pendekatan imbal jasa ekosistem yang terbagi ke dalam spektrum instrumen sukarela (hibah, CSR, sertifikasi) hingga wajib (fiskal dan penegakan hukum). Dengan tujuan menyelaraskan konservasi dan kesejahteraan masyarakat, inisiatif yang dikembangkan oleh IPB University ini merumuskan rekomendasi kebijakan berupa insentif bagi kegiatan yang menjaga ekosistem serta disinsentif tegas bagi aktivitas yang merusak rencana tata ruang.</p>	\N	2026-01-09 06:59:20.305437	2026-01-09 06:59:20.305437
124	21	42	42	[351]	\N	Pengembangan Modul Pembelajaran Ekonomi Hijau melalui Inovasi Teknologi Rendah Karbon di Koridor RIMBA	dokumen	\N	<p>Materi ini menguraikan penyusunan modul pembelajaran ekonomi hijau yang komprehensif sebagai alat sistematis untuk meningkatkan kapasitas sumber daya manusia di wilayah Koridor RIMBA. Modul ini dirancang dalam tiga tingkat kesulitan&mdash;Dasar, Menengah, dan Terapan&mdash;dengan mencakup lima tema utama: Energi, Pertanian dan Kehutanan, Ekonomi Lingkungan dan Sumber Daya Alam, Teknologi Hijau, serta Pemberdayaan Masyarakat. Menggunakan pendekatan metode <em data-path-to-node="2" data-index-in-node="447">ANDRAGOGY</em> (pembelajaran dewasa) dan model <em data-path-to-node="2" data-index-in-node="489">ADDIE</em>, dokumen ini menyediakan panduan teknis dan ringkasan eksekutif bagi pemerintah, sektor swasta, dan organisasi masyarakat sipil guna mempercepat adopsi teknologi rendah karbon serta praktik pembangunan berkelanjutan yang selaras dengan tantangan global saat ini.</p>	\N	2026-01-09 07:08:19.330557	2026-01-09 07:08:19.330557
125	21	42	42	[352]	\N	[English Version] Development of Green Economy Learning Modules through Low Carbon Technology Innovation in the RIMBA Corridor	dokumen	\N	<p>This material outlines the development of a comprehensive green economy learning module as a systematic tool to improve human resource capacity in the RIMBA Corridor region. The module is designed in three levels of difficulty&mdash;Basic, Intermediate, and Applied&mdash;covering five main themes: Energy, Agriculture and Forestry, Environmental Economics and Natural Resources, Green Technology, and Community Empowerment. Using the ANDRAGOGY (adult learning) approach and the ADDIE model, this document provides technical guidance and an executive summary for governments, the private sector, and civil society organizations to accelerate the adoption of low-carbon technologies and sustainable development practices in line with current global challenges.</p>	\N	2026-01-09 07:08:56.568701	2026-01-09 07:08:56.568701
126	29	42	42	[353]	\N	Usulan Desain Konektivitas dan Mitigasi Dampak Pembangunan Infrastruktur terhadap Migrasi Satwa di Koridor RIMBA	dokumen	\N	<p>Materi ini membahas kajian strategis mengenai dampak pembangunan infrastruktur jalan nasional dan rencana jalan tol terhadap integritas ekosistem serta jalur migrasi satwa liar di Koridor RIMBA. Melalui analisis multi-disiplin yang mencakup aspek ekologi, sosial-ekonomi, dan teknik sipil, dokumen ini mengidentifikasi titik-titik kritis perlintasan harimau dan gajah yang terfragmentasi oleh jaringan jalan di wilayah Riau, Jambi, dan Sumatera Barat. Kajian ini merekomendasikan penerapan infrastruktur ramah lingkungan, rekayasa ekologi, serta pendekatan sosial guna memitigasi konflik manusia-satwa dan memastikan fungsi konektivitas ekologis tetap terjaga di tengah meningkatnya tekanan ekspansi perkebunan, perambahan, dan alih fungsi lahan di sepanjang koridor tersebut.</p>	\N	2026-01-09 07:11:24.136146	2026-01-09 07:11:24.136146
127	28	42	42	[354]	\N	Fasilitasi Perencanaan Penggunaan Lahan Partisipatif dan Solusi Alternatif Permukiman Tidak Berizin di Kawasan Hutan Lindung Bukit Batabuh	dokumen	\N	<p>Materi ini membahas kajian strategis untuk menangani masalah permukiman tidak berizin yang menyebabkan degradasi hutan dan fragmentasi habitat di kawasan Hutan Lindung Bukit Batabuh, yang merupakan bagian vital dari Koridor RIMBA. Fokus utama kegiatan ini adalah menyusun rencana penanganan permukiman berdasarkan standar <em data-path-to-node="2" data-index-in-node="322">IFC Safeguard</em> serta mengidentifikasi solusi alternatif bagi masyarakat yang tinggal di kawasan lindung, terutama di Kecamatan Kuantan Mudik dan Pucuk Rantau. Dengan mempertimbangkan aspek hidrologi, hak ulayat, dan tekanan ekonomi akibat alih fungsi lahan menjadi sawit, dokumen ini merumuskan langkah penertiban dan penguasaan kembali kawasan guna menjaga konektivitas ekosistem bagi satwa kunci seperti harimau Sumatera sekaligus memitigasi konflik sosial-ekonomi di wilayah tersebut.</p>	\N	2026-01-09 07:17:16.597767	2026-01-09 07:17:16.597767
128	30	42	42	[355]	\N	Strategi Pemulihan Ekosistem Gambut dalam Pengelolaan Hutan Berkelanjutan di Provinsi Jambi	gambar	\N	<p>Infografik ini menyajikan rencana strategis upaya pemulihan ekosistem gambut seluas kurang lebih 736.228 hektar di Provinsi Jambi, khususnya di wilayah Tanjung Jabung Timur, Muaro Jambi, Tanjung Jabung Barat, serta beberapa kabupaten lainnya. Program yang dijalankan oleh LPPM Universitas Jambi ini berfokus pada penyelesaian sengketa tanah di luar kawasan konservasi, pengembangan model bisnis berkelanjutan bagi masyarakat, serta pembasahan kembali (<em data-path-to-node="2" data-index-in-node="452">rewetting</em>) lahan gambut di klaster-klaster prioritas. Melalui metode yang komprehensif&mdash;mulai dari pembentukan forum multipihak hingga penguatan Masyarakat Peduli Api (MPA)&mdash;kegiatan ini menghasilkan output berupa rencana aksi ekonomi hijau di berbagai sektor dan strategi pemulihan ekosistem guna mengatasi permasalahan kritis seperti kebakaran lahan, kekeringan, dan subsidi lahan gambut demi tercapainya tata kelola hutan yang lestari.</p>	\N	2026-01-09 07:38:24.89321	2026-01-09 07:38:24.89321
129	30	42	42	[356]	\N	[English Version] Peatland Ecosystem Restoration Strategy in Sustainable Forest Management in Jambi Province	gambar	\N	<p>This infographic presents a strategic plan for the restoration of approximately 736,228 hectares of peatland ecosystem in Jambi Province, particularly in the areas of East Tanjung Jabung, Muaro Jambi, West Tanjung Jabung, and several other districts. The program, run by the University of Jambi's Research and Community Service Institute (LPPM), focuses on resolving land disputes outside conservation areas, developing sustainable business models for communities, and rewetting peatlands in priority clusters. Through comprehensive methods&mdash;ranging from the establishment of multi-stakeholder forums to the strengthening of the Fire Awareness Community (MPA)&mdash;this activity has produced outputs in the form of green economy action plans in various sectors and ecosystem restoration strategies to address critical issues such as land fires, drought, and peatland subsidies in order to achieve sustainable forest management.</p>	\N	2026-01-09 07:40:48.673548	2026-01-09 07:40:48.673548
130	33	42	42	[357]	\N	Kajian Peluang Investasi Ekonomi Hijau di Kawasan Ekosistem RIMBA	gambar	\N	<p>Infografik ini menguraikan strategi identifikasi dan pemetaan peluang investasi ekonomi hijau di Koridor Ekosistem RIMBA yang mencakup wilayah Riau, Jambi, dan Sumatera Barat seluas kurang lebih 3,8 juta hektar. Melalui pendekatan metodologi yang komprehensif&mdash;termasuk analisis keunggulan daerah, studi kelayakan teknis, hingga analisis pemangku kepentingan&mdash;program ini bertujuan untuk memprioritaskan sektor investasi ramah lingkungan seperti energi terbarukan, agroforestri, dan restorasi ekosistem. Meskipun menghadapi tantangan berupa ketidakpastian tata ruang dan risiko lingkungan-sosial, inisiatif ini menghasilkan output berupa portofolio proyek siap kembang yang mengintegrasikan skema pembiayaan campuran (<em data-path-to-node="2" data-index-in-node="716">blended finance</em>) dan pasar karbon untuk mencapai target penurunan emisi serta peningkatan kesejahteraan masyarakat di koridor tersebut.</p>	\N	2026-01-09 07:51:14.215474	2026-01-09 07:51:14.215474
131	33	42	42	[358]	\N	Study of Green [English Version] Economy Investment Opportunities in the RIMBA Ecosystem Area	gambar	\N	<p>This infographic outlines the strategy for identifying and mapping green economy investment opportunities in the RIMBA Ecosystem Corridor, which covers an area of approximately 3.8 million hectares in Riau, Jambi, and West Sumatra. Through a comprehensive methodological approach&mdash;including regional advantage analysis, technical feasibility studies, and stakeholder analysis&mdash;the program aims to prioritize environmentally friendly investment sectors such as renewable energy, agroforestry, and ecosystem restoration. Despite challenges such as spatial uncertainty and environmental-social risks, this initiative has produced a portfolio of ready-to-develop projects that integrate blended finance and carbon markets to achieve emission reduction targets and improve community welfare in the corridor.</p>	\N	2026-01-09 07:53:37.146282	2026-01-09 07:53:37.146282
\.


--
-- Data for Name: kmis_quiz; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_quiz (id, kmis_topic_id, question, answer_a, answer_b, answer_c, answer_d, correct_option, explanation, deleted_at, created_at, updated_at, created_by) FROM stdin;
1	1	Apa fungsi utama dari koridor ekosistem dalam konteks pengelolaan kawasan konservasi?	Sebagai jalur penghubung antara kawasan konservasi untuk mendukung migrasi satwa.	Sebagai wilayah untuk pembangunan infrastruktur baru.	Sebagai kawasan yang diperuntukkan untuk pengembangan perkebunan.	Sebagai tempat bagi aktivitas pertambangan dan sumber daya alam.	A	Koridor ekosistem berfungsi sebagai jalur penghubung antara kawasan konservasi, yang memungkinkan migrasi satwa dan biota laut antar wilayah tersebut. Hal ini penting untuk menjaga kelangsungan hidup spesies dengan memberikan akses ke habitat yang lebih luas dan beragam, serta mengurangi isolasi ekosistem. Tanpa koridor ini, banyak spesies terancam kehilangan akses ke habitat yang lebih baik, yang bisa berakibat pada penurunan populasi atau bahkan kepunahan.	\N	2025-11-02 03:12:37.777803	2025-11-19 08:32:22.599545	1
2	1	Proyek RIMBA bertujuan untuk menghubungkan beberapa kawasan konservasi. Manakah dari berikut ini yang merupakan bagian dari koridor ekosistem dalam proyek RIMBA?	Taman Nasional Ujung Kulon.	Suaka Margasatwa Bukit Rimbang-Bukit Baling.	Cagar Alam Kalimantan Barat.	Kawasan Hutan Lindung Gunung Leuser.	B	Proyek RIMBA bertujuan untuk menghubungkan beberapa kawasan konservasi di Sumatera melalui koridor ekosistem, salah satunya adalah Suaka Margasatwa Bukit Rimbang-Bukit Baling. Koridor ini berfungsi sebagai jalur migrasi untuk satwa seperti gajah, harimau, dan burung. Melalui pengelolaan koridor ini, keberlanjutan ekosistem dan perlindungan terhadap keanekaragaman hayati di kawasan tersebut dapat terjaga dengan lebih baik.	\N	2025-11-02 03:13:51.476633	2025-11-19 08:32:22.599545	1
16	36	Standar sertifikasi internasional mana yang dikenal fokus pada proyek berbasis masyarakat (community-based)?	Verra (VCS)	Gold Standard	Plan Vivo	CDM	C	Plan Vivo adalah standar sertifikasi untuk proyek berbasis masyarakat yang menekankan partisipasi lokal (Hal 44).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:31:22.077809	1
15	36	Target penurunan emisi Koridor RIMBA pada tahun 2030 ditetapkan sebesar berapa persen dari baseline?	0.29	0.32	0.41	1	B	Target tahun 2030 adalah 32% dari baseline, selaras dengan Enhanced NDC Indonesia (Hal 20).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:31:47.835272	1
14	36	Apa perbedaan mendasar antara Pasar Kepatuhan (Compliance Market) dan Pasar Sukarela (Voluntary Market)?	Pasar kepatuhan bersifat global, pasar sukarela bersifat lokal.	Pasar kepatuhan berbasis Cap-and-Trade wajib, pasar sukarela berbasis offset sukarela.	Pasar kepatuhan tidak diatur pemerintah, pasar sukarela diatur ketat.	Pasar kepatuhan hanya untuk BUMN, pasar sukarela untuk swasta.	B	Pasar kepatuhan diwajibkan regulasi dengan sistem cap-and-trade, sedangkan pasar sukarela didorong tanggung jawab sosial tanpa kewajiban hukum (Hal 23).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:31:54.71529	1
13	36	Dalam konteks KBLI, kode manakah yang direkomendasikan sebagai KBLI Utama untuk aktivitas profesional proyek karbon?	KBLI 02109	KBLI 74909	KBLI 70209	KBLI 71129	B	KBLI 74909 (Aktivitas Profesional, Ilmiah, dan Teknis Lainnya YTDL) direkomendasikan sebagai KBLI Utama (Hal 79).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:03.243543	1
12	36	Apa fungsi utama dari Sistem Registri Nasional (SRN) PPI?	Sebagai tempat lelang harga karbon tertinggi.	Platform resmi pencatatan aksi mitigasi dan unit karbon untuk menghindari perhitungan ganda.	Aplikasi untuk memantau kebakaran hutan secara real-time.	Lembaga yang menerbitkan sertifikat ISO lingkungan.	B	SRN adalah platform pemerintah untuk pencatatan aksi mitigasi dan unit karbon agar tercatat resmi dan mencegah double counting (Hal 38).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:10.522319	1
11	36	Manakah dari berikut ini yang BUKAN merupakan salah satu dari 4 carbon pools yang dihitung dalam model InVEST?	Aboveground biomass (Biomassa atas permukaan)	Belowground biomass (Biomassa bawah permukaan)	Atmospheric carbon (Karbon atmosfer)	Soil organic carbon (Karbon organik tanah)	C	4 pools dalam InVEST adalah: aboveground biomass, belowground biomass, soil organic carbon, dan dead organic matter. Atmospheric carbon tidak termasuk (Hal 51).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:18.675797	1
10	36	Aplikasi pemodelan spasial apa yang direkomendasikan modul untuk menghitung stok karbon di lanskap?	ArcGIS Pro	QGIS	InVEST	Google Earth Engine	C	Modul secara spesifik membahas penggunaan model InVEST (Integrated Valuation of Ecosystem Services and Tradeoffs) (Hal 51).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:26.314323	1
9	36	Apa kepanjangan dari MRV yang merupakan standar wajib dalam proyek karbon?	Management, Review, Valuation	Monitoring, Reporting, Validation	Measurement, Reporting, Verification	Mitigation, Restoration, Verification	C	MRV singkatan dari Measurement (Pengukuran), Reporting (Pelaporan), dan Verification (Verifikasi) (Hal 35).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:35.721817	1
8	36	Regulasi manakah yang disebut sebagai kerangka hukum baru pengganti Perpres 98/2021 untuk penyelenggaraan Nilai Ekonomi Karbon?	Peraturan Presiden Nomor 110 Tahun 2025	Peraturan Pemerintah Nomor 46 Tahun 2017	Undang-Undang Nomor 16 Tahun 2016	Peraturan OJK Nomor 14 Tahun 2023	A	Hal 13 menyebutkan Perpres No. 110 Tahun 2025 sebagai regulasi baru pengganti Perpres 98/2021.	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:44.608046	1
7	36	Berapa perkiraan luas Area Penggunaan Lain (APL) di Koridor Ekosistem RIMBA yang menjadi fokus modul ini?	Sekitar 500 ribu hektar	Sekitar 1,38 juta hektar	Sekitar 2,48 juta hektar	Sekitar 3,8 juta hektar	B	Modul menyebutkan APL mencakup sekitar 1,38 juta hektar atau setara 35,78% dari total koridor (Hal 5).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:32:54.972376	1
3	13	Apa tujuan utama Proyek RIMBA, sebagaimana disebutkan dalam dokumen presentasi?	Menjaga kelestarian Keanekaragaman Hayati dan meningkatkan cadangan karbon di seluruh wilayah bentang alam RIMBA melalui pembangunan ekonomi hijau.	Membangun infrastruktur pariwisata di tiga provinsi di Sumatera.	Memperluas wilayah perkebunan kelapa sawit di koridor ekosistem RIMBA.	Melakukan penataan ruang kawasan budidaya di Pulau Sumatera tanpa mempertimbangkan aspek lingkungan.	A	Tujuan proyek secara eksplisit adalah menjaga kelestarian keanekaragaman hayati dan meningkatkan cadangan karbon dengan cara meningkatkan konektivitas koridor ekosistem melalui pembangunan ekonomi hijau.	2025-12-22 14:56:04.615608	2025-11-04 03:49:20.27978	2025-11-04 03:49:20.27978	1
21	36	Apa peran Mutual Recognition Arrangement (MRA) dalam perdagangan karbon?	Perjanjian jual beli antara dua perusahaan.	Kesepakatan saling pengakuan antara sistem sertifikasi nasional (SRN) dengan standar internasional.	Mekanisme penetapan pajak karbon.	Aturan tentang pembagian dividen proyek.	B	MRA memungkinkan sertifikat nasional (SPEI) diakui oleh sistem internasional tanpa verifikasi ulang yang berlebihan (Hal 45).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:30:30.852879	1
26	21	Konservasi secara etimologis berasal dari kata?	consent	consume	conservse	conservare	D	(text, optional)	\N	2025-12-22 09:22:35.510686	2025-12-22 09:22:35.510686	1
27	21	Salah satu pilar penting dalam konservasi yang terdapat dalam World Conservation Strategy adalah?	pemeliharaan proses-proses sosial	pengawetan keanekaragaman hayati	pemanfaatan secara lestari spesies dan ekosistem	pemanfaatan sesuai dengan kebutuhan manusia	C	\N	\N	2025-12-22 09:22:35.510686	2025-12-22 09:22:35.510686	1
28	21	Apa kepanjangan dari CBD?	Convention on Biological Diversity	Convention on Biological Demand	Convention on Big Diversity	Communication on Biological Diversity	A	\N	\N	2025-12-22 09:22:35.510686	2025-12-22 09:22:35.510686	1
29	21	Undang-Undang Nomor 32 Tahun 2024 mengatur tentang apa?	pengelolaan lingkungan hidup	konservasi sumber daya alam hayati dan ekosistemnya	perlindungan lingkungan hidup	penyelenggaraan kehutanan	B	\N	\N	2025-12-22 09:22:35.510686	2025-12-22 09:22:35.510686	1
30	21	Hal yang bukan merupakan pembaruan penting dalam Undang-Undang Nomor 32 Tahun 2024 adalah?	pelemahan ketentuan pidana/hukum	penguatan tata kelola konservasi berbasis kolaborasi	penguatan tata kelola konservasi berbasis keadilan ekologis	konservasi inklusif	A	\N	\N	2025-12-22 09:22:35.510686	2025-12-22 09:22:35.510686	1
24	36	Berdasarkan data baseline emisi Kawasan RIMBA, faktor penyebab emisi terbesar di sektor kehutanan (61,2%) adalah:	Kebakaran Hutan	Degradasi Hutan	Deforestasi Hutan	Konversi Lahan Gambut	C	Hal 19 menunjukkan diagram lingkaran di mana Deforestasi Hutan menyumbang 61,2% emisi.	\N	2025-12-22 08:59:32.301912	2025-12-22 09:28:20.363695	1
20	36	Dokumen apa yang harus disusun oleh pengembang proyek untuk menjelaskan desain teknis dan rencana aksi mitigasi?	AMDAL	Project Design Document (PDD) / DRAM	Laporan Keuangan Tahunan	Surat Izin Usaha Perdagangan	B	Dokumen desain proyek (PDD) atau DRAM (Dokumen Rancangan Aksi Mitigasi) diperlukan untuk menjelaskan aktivitas mitigasi dan metodologi (Hal 67).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:30:40.77128	1
22	36	Jenis vegetasi apa yang disebutkan dalam studi kasus Kabupaten Sijunjung sebagai tanaman fast-growing potensial?	Jati (Tectona grandis)	Sengon (Albizia chinensis)	Mahoni (Swietenia macrophylla)	Sawit (Elaeis guineensis)	B	Studi kasus menyebutkan Sengon sebagai tanaman fast-growing yang adaptif dan potensial (Hal 59).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:29:40.795304	1
25	36	Apa tujuan utama dari 'Tier 2' dalam pendekatan IPCC untuk perhitungan emisi?	Menggunakan data default global yang kasar.	Menggunakan data spesifik nasional atau lokal yang lebih akurat daripada default.	Menggunakan pemodelan sangat kompleks dan dinamis.	Menggunakan data satelit tanpa validasi lapangan.	B	Tier 2 menggunakan data nasional/lokal dengan tingkat ketelitian sedang-tinggi, di atas Tier 1 (default) dan di bawah Tier 3 (model dinamis) (Hal 50).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:30:06.638169	1
23	36	Apa itu 'Blue Carbon' yang disebutkan sebagai salah satu potensi proyek di APL?	Karbon yang tersimpan di langit biru.	Karbon yang diserap oleh ekosistem laut dan pesisir, seperti mangrove.	Kredit karbon yang diperdagangkan di pasar Eropa.	Teknologi penangkap karbon dari pabrik kimia.	B	Modul menyebutkan Restorasi Mangrove sebagai solusi Blue Carbon dengan kemampuan serapan tinggi (Hal 7).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:30:19.685246	1
19	36	Strategi apa yang disarankan untuk 12 bulan pertama bagi investor yang masuk ke pasar karbon RIMBA?	Langsung ekspansi ke 10.000 hektar.	Fokus pada proyek percontohan skala 100-200 hektar.	Melakukan IPO di bursa saham.	Menunggu harga karbon mencapai titik tertinggi.	B	Rekomendasi strategis menyarankan 12 bulan pertama fokus pada proyek percontohan skala 100-200 ha untuk pembelajaran (Hal 83).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:30:49.006739	1
18	36	Dalam tahapan perhitungan karbon InVEST, data apa yang wajib (Required) dimasukkan?	Price of Carbon	Future LULC	Current LULC dan Carbon Pools Table	Discount Rate	C	Workspace, Current LULC, dan Carbon Pools adalah parameter wajib. Future LULC wajib hanya jika menghitung sekuestrasi (Hal 52).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:31:04.048887	1
17	36	Apa yang dimaksud dengan 'Additionality' dalam prinsip validasi proyek karbon?	Proyek harus memberikan keuntungan finansial tambahan bagi investor.	Pengurangan emisi harus terjadi karena adanya proyek, bukan karena kondisi 'business as usual'.	Proyek harus menambah luas wilayah hutan secara fisik.	Adanya tambahan tenaga kerja dalam proyek.	B	Prinsip additionality memastikan bahwa pengurangan emisi benar-benar terjadi karena intervensi proyek, bukan sesuatu yang akan terjadi dengan sendirinya (Hal 32).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:31:13.001528	1
6	36	Apa definisi Area Penggunaan Lain (APL) dalam konteks tata ruang kehutanan Indonesia menurut modul ini?	Kawasan hutan yang dikhususkan untuk konservasi satwa liar.	Areal di luar kawasan hutan negara yang dapat digunakan untuk keperluan pembangunan di luar kehutanan.	Wilayah hutan produksi yang dikelola oleh swasta.	Lahan gambut yang tidak boleh disentuh aktivitas manusia.	B	APL adalah areal di luar kawasan hutan negara yang diperuntukkan bagi pembangunan di luar kegiatan kehutanan, seperti pertanian, permukiman, dan perkebunan (Hal 8).	\N	2025-12-22 08:59:32.301912	2025-12-22 09:33:03.473358	1
4	13	Berapa periode pelaksanaan Proyek RIMBA (Strengthening Forest and Ecosystem Connectivity in RIMBA Landscape of Central Sumatera)?	2012–2020	2021–2024	2020–2025	2023–2028	D	Dokumen menyebutkan periode proyek adalah 2023–2028, dengan fase PCA-UNEP (Project Cooperation Agreement) dimulai tahun 2021.	2025-12-22 14:56:04.615608	2025-11-04 06:19:34.950694	2025-11-04 06:19:34.950694	1
5	13	Test Pertanyaan?	Jawaban A	Jawaban B	Jawaban C	Jawaban D	B	JAWABAN B ADALAH JAWABAN YANG BENAR	2025-12-22 14:56:04.615608	2025-11-18 07:00:27.699478	2025-11-18 07:00:27.699478	42
32	36	test	12	123	1234	12345	C	123	2025-12-22 17:46:37.191875	2025-12-22 17:45:10.725209	2025-12-22 17:45:10.725209	1
33	38	Test Pertanyaan	Opsi A	Opsi B	Opsi C	Opsi D	C	Coba penjelasan	2025-12-22 17:53:48.584823	2025-12-22 17:52:50.699373	2025-12-22 17:52:50.699373	1
31	37	1	1	12	123	1234	D	1	2025-12-22 17:53:52.414773	2025-12-22 14:57:26.109638	2025-12-22 14:57:26.109638	1
\.


--
-- Data for Name: kmis_quiz_responses; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_quiz_responses (id, kmis_learning_attempt_id, kmis_quiz_id, is_marker, is_correct, answered_at, deleted_at, created_at, updated_at, selected_option) FROM stdin;
1	1	1	f	f	2025-11-02 03:16:40.299	2025-11-02 03:16:44.195307	2025-11-02 03:16:40.289433	2025-11-02 03:16:40.289433	C
2	1	1	f	f	2025-11-02 03:16:44.2	2025-11-02 03:16:45.673923	2025-11-02 03:16:44.195307	2025-11-02 03:16:44.195307	B
3	1	1	f	f	2025-11-02 03:16:45.68	\N	2025-11-02 03:16:45.673923	2025-11-02 03:16:45.673923	C
4	1	2	f	f	2025-11-02 03:16:49.673	\N	2025-11-02 03:16:49.664307	2025-11-02 03:16:49.664307	D
5	2	3	f	t	2025-11-04 07:42:32.09	\N	2025-11-04 07:42:32.085384	2025-11-04 07:42:32.085384	A
6	2	4	f	f	2025-11-04 07:42:34.409	\N	2025-11-04 07:42:34.393166	2025-11-04 07:42:34.393166	C
7	17	31	f	f	2025-12-22 16:23:44.728	2025-12-22 16:23:48.640234	2025-12-22 16:23:44.722306	2025-12-22 16:23:44.722306	B
8	17	31	f	f	2025-12-22 16:23:48.646	2025-12-22 16:23:49.619337	2025-12-22 16:23:48.640234	2025-12-22 16:23:48.640234	C
9	17	31	f	t	2025-12-22 16:23:49.632	2025-12-22 16:23:50.955977	2025-12-22 16:23:49.619337	2025-12-22 16:23:49.619337	D
10	17	31	f	f	2025-12-22 16:23:50.969	2025-12-22 16:23:52.295681	2025-12-22 16:23:50.955977	2025-12-22 16:23:50.955977	A
11	17	31	f	f	2025-12-22 16:23:52.301	\N	2025-12-22 16:23:52.295681	2025-12-22 16:23:52.295681	C
13	15	28	f	t	2025-12-22 16:26:01.921	\N	2025-12-22 16:26:01.913042	2025-12-22 16:26:01.913042	A
12	15	27	t	f	2025-12-22 16:25:51.772	2025-12-22 16:26:08.938376	2025-12-22 16:25:51.759507	2025-12-22 16:25:51.759507	 
14	15	27	t	f	2025-12-22 16:26:08.949	2025-12-22 16:26:12.080283	2025-12-22 16:26:08.938376	2025-12-22 16:26:08.938376	B
15	15	27	f	f	2025-12-22 16:26:12.092	\N	2025-12-22 16:26:12.080283	2025-12-22 16:26:12.080283	B
16	15	26	f	f	2025-12-22 16:26:49.906	\N	2025-12-22 16:26:49.894916	2025-12-22 16:26:49.894916	C
17	20	33	f	f	2025-12-22 17:53:26.58	\N	2025-12-22 17:53:26.575713	2025-12-22 17:53:26.575713	D
18	14	6	f	t	2025-12-23 01:48:45.384	2025-12-23 01:48:47.703296	2025-12-23 01:48:45.377966	2025-12-23 01:48:45.377966	B
19	14	6	f	f	2025-12-23 01:48:47.716	2025-12-23 01:48:50.331781	2025-12-23 01:48:47.703296	2025-12-23 01:48:47.703296	C
20	14	6	f	f	2025-12-23 01:48:50.336	\N	2025-12-23 01:48:50.331781	2025-12-23 01:48:50.331781	A
21	14	7	f	t	2025-12-23 01:48:57.027	\N	2025-12-23 01:48:57.022273	2025-12-23 01:48:57.022273	B
22	14	8	f	f	2025-12-23 01:48:59.848	\N	2025-12-23 01:48:59.843628	2025-12-23 01:48:59.843628	C
23	14	9	f	t	2025-12-23 01:49:03.193	\N	2025-12-23 01:49:03.189106	2025-12-23 01:49:03.189106	C
24	14	10	f	f	2025-12-23 01:49:07.941	\N	2025-12-23 01:49:07.937176	2025-12-23 01:49:07.937176	B
25	14	11	f	f	2025-12-23 01:49:12.269	\N	2025-12-23 01:49:12.264945	2025-12-23 01:49:12.264945	A
26	14	12	f	f	2025-12-23 01:49:15.585	\N	2025-12-23 01:49:15.580326	2025-12-23 01:49:15.580326	A
27	14	13	f	f	2025-12-23 01:49:18.225	\N	2025-12-23 01:49:18.219268	2025-12-23 01:49:18.219268	A
28	14	14	f	f	2025-12-23 01:49:21.289	\N	2025-12-23 01:49:21.285913	2025-12-23 01:49:21.285913	A
29	14	15	f	f	2025-12-23 01:49:25.054	\N	2025-12-23 01:49:25.043718	2025-12-23 01:49:25.043718	A
30	14	16	f	t	2025-12-23 01:49:31.444	\N	2025-12-23 01:49:31.441174	2025-12-23 01:49:31.441174	C
31	14	17	f	t	2025-12-23 01:49:34.246	\N	2025-12-23 01:49:34.242645	2025-12-23 01:49:34.242645	B
32	14	18	f	f	2025-12-23 01:49:38.419	\N	2025-12-23 01:49:38.41504	2025-12-23 01:49:38.41504	B
33	14	19	f	t	2025-12-23 01:49:42.663	\N	2025-12-23 01:49:42.65846	2025-12-23 01:49:42.65846	B
34	14	20	f	t	2025-12-23 01:51:46.319	\N	2025-12-23 01:51:46.315323	2025-12-23 01:51:46.315323	B
35	14	21	f	t	2025-12-23 01:51:49.099	\N	2025-12-23 01:51:49.093402	2025-12-23 01:51:49.093402	B
36	14	22	f	t	2025-12-23 01:51:52.306	\N	2025-12-23 01:51:52.302062	2025-12-23 01:51:52.302062	B
37	14	23	f	t	2025-12-23 01:51:54.658	\N	2025-12-23 01:51:54.653879	2025-12-23 01:51:54.653879	B
38	14	24	f	f	2025-12-23 01:51:58.241	\N	2025-12-23 01:51:58.23631	2025-12-23 01:51:58.23631	B
39	14	25	t	f	2025-12-23 01:52:03.197	\N	2025-12-23 01:52:03.193687	2025-12-23 01:52:03.193687	 
40	21	6	f	f	2025-12-23 02:44:14.147	\N	2025-12-23 02:44:14.141603	2025-12-23 02:44:14.141603	C
42	21	8	f	f	2025-12-23 02:44:24.142	\N	2025-12-23 02:44:24.136891	2025-12-23 02:44:24.136891	D
43	21	9	f	t	2025-12-23 02:44:26.743	\N	2025-12-23 02:44:26.737785	2025-12-23 02:44:26.737785	C
44	21	10	f	f	2025-12-23 02:44:28.822	\N	2025-12-23 02:44:28.817375	2025-12-23 02:44:28.817375	A
45	21	11	f	f	2025-12-23 02:44:33.584	\N	2025-12-23 02:44:33.578424	2025-12-23 02:44:33.578424	B
46	21	12	f	f	2025-12-23 02:44:35.983	\N	2025-12-23 02:44:35.977864	2025-12-23 02:44:35.977864	D
47	21	13	f	f	2025-12-23 02:44:38.025	\N	2025-12-23 02:44:38.020543	2025-12-23 02:44:38.020543	C
48	21	14	f	t	2025-12-23 02:44:40.12	\N	2025-12-23 02:44:40.115173	2025-12-23 02:44:40.115173	B
49	21	15	f	f	2025-12-23 02:44:42.699	\N	2025-12-23 02:44:42.695173	2025-12-23 02:44:42.695173	C
50	21	16	f	f	2025-12-23 02:44:45.481	\N	2025-12-23 02:44:45.476934	2025-12-23 02:44:45.476934	A
51	21	17	f	f	2025-12-23 02:44:48.018	\N	2025-12-23 02:44:48.013896	2025-12-23 02:44:48.013896	D
52	21	18	f	f	2025-12-23 02:44:50.485	\N	2025-12-23 02:44:50.480138	2025-12-23 02:44:50.480138	D
53	21	19	f	f	2025-12-23 02:44:54.44	\N	2025-12-23 02:44:54.436628	2025-12-23 02:44:54.436628	D
54	21	20	f	f	2025-12-23 02:44:58.166	\N	2025-12-23 02:44:58.162668	2025-12-23 02:44:58.162668	A
55	21	21	f	f	2025-12-23 02:45:00.681	2025-12-23 02:45:02.496885	2025-12-23 02:45:00.677716	2025-12-23 02:45:00.677716	D
56	21	21	f	t	2025-12-23 02:45:02.501	\N	2025-12-23 02:45:02.496885	2025-12-23 02:45:02.496885	B
57	21	22	f	f	2025-12-23 02:45:06.144	\N	2025-12-23 02:45:06.140075	2025-12-23 02:45:06.140075	D
41	21	7	t	f	2025-12-23 02:44:19.881	2025-12-23 02:46:40.529401	2025-12-23 02:44:19.87549	2025-12-23 02:44:19.87549	 
59	21	23	f	f	2025-12-23 02:46:45.789	\N	2025-12-23 02:46:45.784336	2025-12-23 02:46:45.784336	D
60	21	24	f	f	2025-12-23 02:46:49.476	\N	2025-12-23 02:46:49.472372	2025-12-23 02:46:49.472372	B
61	21	25	f	f	2025-12-23 02:46:52.483	\N	2025-12-23 02:46:52.479285	2025-12-23 02:46:52.479285	D
58	21	7	t	f	2025-12-23 02:46:40.534	2025-12-23 02:46:57.879417	2025-12-23 02:46:40.529401	2025-12-23 02:46:40.529401	A
62	21	7	f	f	2025-12-23 02:46:57.884	2025-12-23 02:46:59.493265	2025-12-23 02:46:57.879417	2025-12-23 02:46:57.879417	A
63	21	7	f	f	2025-12-23 02:46:59.497	\N	2025-12-23 02:46:59.493265	2025-12-23 02:46:59.493265	D
\.


--
-- Data for Name: kmis_topic_views; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_topic_views (id, kmis_topic_id, viewer_ip, viewer_region, view_date, deleted_at, created_at, updated_at) FROM stdin;
1	1	::1	\N	2025-11-01	\N	2025-11-01 05:58:10.467256	2025-11-01 05:58:10.467256
2	4	127.0.0.1	\N	2025-11-02	\N	2025-11-02 03:04:21.674269	2025-11-02 03:04:21.674269
3	1	::1	\N	2025-11-02	\N	2025-11-02 03:15:36.501226	2025-11-02 03:15:36.501226
5	1	127.0.0.1	\N	2025-11-02	\N	2025-11-02 03:19:01.457342	2025-11-02 03:19:01.457342
7	13	127.0.0.1	\N	2025-11-04	\N	2025-11-04 03:36:54.133782	2025-11-04 03:36:54.133782
9	1	::1	\N	2025-11-04	\N	2025-11-04 03:55:18.294017	2025-11-04 03:55:18.294017
11	1	127.0.0.1	\N	2025-11-04	\N	2025-11-04 07:40:15.352308	2025-11-04 07:40:15.352308
13	12	127.0.0.1	\N	2025-11-04	\N	2025-11-04 07:41:27.136782	2025-11-04 07:41:27.136782
14	12	127.0.0.1	\N	2025-11-12	\N	2025-11-12 02:50:26.035475	2025-11-12 02:50:26.035475
16	1	127.0.0.1	\N	2025-11-12	\N	2025-11-12 16:27:43.810647	2025-11-12 16:27:43.810647
17	13	::1	\N	2025-11-12	\N	2025-11-12 16:27:59.645816	2025-11-12 16:27:59.645816
18	13	127.0.0.1	\N	2025-11-12	\N	2025-11-12 16:28:04.580452	2025-11-12 16:28:04.580452
20	1	::1	\N	2025-11-12	\N	2025-11-12 16:30:15.069481	2025-11-12 16:30:15.069481
26	12	::1	\N	2025-11-12	\N	2025-11-12 16:53:36.251246	2025-11-12 16:53:36.251246
27	11	::1	\N	2025-11-12	\N	2025-11-12 16:53:40.14636	2025-11-12 16:53:40.14636
32	13	127.0.0.1	\N	2025-11-13	\N	2025-11-13 04:34:13.058916	2025-11-13 04:34:13.058916
33	13	::1	\N	2025-11-13	\N	2025-11-13 05:47:44.766806	2025-11-13 05:47:44.766806
35	1	127.0.0.1	\N	2025-11-13	\N	2025-11-13 07:25:52.87268	2025-11-13 07:25:52.87268
39	1	127.0.0.1	\N	2025-11-17	\N	2025-11-17 06:42:03.707675	2025-11-17 06:42:03.707675
40	12	127.0.0.1	\N	2025-11-17	\N	2025-11-17 06:56:21.486632	2025-11-17 06:56:21.486632
41	11	127.0.0.1	\N	2025-11-17	\N	2025-11-17 07:06:16.37413	2025-11-17 07:06:16.37413
43	13	::1	\N	2025-11-17	\N	2025-11-17 13:35:36.106224	2025-11-17 13:35:36.106224
46	1	::1	\N	2025-11-18	\N	2025-11-18 07:12:48.935664	2025-11-18 07:12:48.935664
47	14	127.0.0.1	\N	2025-11-19	\N	2025-11-19 05:21:36.8009	2025-11-19 05:21:36.8009
48	13	127.0.0.1	\N	2025-11-19	\N	2025-11-19 05:21:40.7759	2025-11-19 05:21:40.7759
49	1	127.0.0.1	\N	2025-11-19	\N	2025-11-19 05:21:52.126059	2025-11-19 05:21:52.126059
55	1	::1	\N	2025-11-19	\N	2025-11-19 05:59:18.84781	2025-11-19 05:59:18.84781
56	13	::1	\N	2025-11-19	\N	2025-11-19 05:59:36.381187	2025-11-19 05:59:36.381187
57	14	::1	\N	2025-11-19	\N	2025-11-19 06:36:35.11503	2025-11-19 06:36:35.11503
64	11	127.0.0.1	\N	2025-11-19	\N	2025-11-19 08:06:31.055264	2025-11-19 08:06:31.055264
74	12	::1	\N	2025-11-19	\N	2025-11-19 08:43:54.770648	2025-11-19 08:43:54.770648
88	1	::1	\N	2025-11-20	\N	2025-11-20 02:03:32.931195	2025-11-20 02:03:32.931195
89	13	127.0.0.1	\N	2025-11-20	\N	2025-11-20 02:36:48.855491	2025-11-20 02:36:48.855491
91	14	::1	\N	2025-11-20	\N	2025-11-20 02:49:28.250092	2025-11-20 02:49:28.250092
95	12	::1	\N	2025-11-20	\N	2025-11-20 02:59:56.39535	2025-11-20 02:59:56.39535
96	13	::1	\N	2025-11-20	\N	2025-11-20 03:00:57.353978	2025-11-20 03:00:57.353978
99	2	127.0.0.1	\N	2025-11-20	\N	2025-11-20 03:25:21.004271	2025-11-20 03:25:21.004271
100	4	127.0.0.1	\N	2025-11-20	\N	2025-11-20 03:25:54.901367	2025-11-20 03:25:54.901367
101	5	127.0.0.1	\N	2025-11-20	\N	2025-11-20 03:49:25.371176	2025-11-20 03:49:25.371176
113	11	127.0.0.1	\N	2025-11-20	\N	2025-11-20 04:13:01.031148	2025-11-20 04:13:01.031148
114	10	127.0.0.1	\N	2025-11-20	\N	2025-11-20 04:13:15.767593	2025-11-20 04:13:15.767593
115	1	127.0.0.1	\N	2025-11-20	\N	2025-11-20 04:35:56.328155	2025-11-20 04:35:56.328155
116	5	::1	\N	2025-11-20	\N	2025-11-20 04:50:52.194873	2025-11-20 04:50:52.194873
117	14	127.0.0.1	\N	2025-11-20	\N	2025-11-20 04:55:20.034071	2025-11-20 04:55:20.034071
122	6	::1	\N	2025-11-20	\N	2025-11-20 12:31:20.276454	2025-11-20 12:31:20.276454
123	4	::1	\N	2025-11-20	\N	2025-11-20 12:31:22.616251	2025-11-20 12:31:22.616251
124	3	::1	\N	2025-11-20	\N	2025-11-20 12:31:24.3724	2025-11-20 12:31:24.3724
127	10	::1	\N	2025-11-20	\N	2025-11-20 12:32:40.753269	2025-11-20 12:32:40.753269
128	9	::1	\N	2025-11-20	\N	2025-11-20 12:32:43.418519	2025-11-20 12:32:43.418519
129	8	::1	\N	2025-11-20	\N	2025-11-20 12:32:45.609341	2025-11-20 12:32:45.609341
130	7	::1	\N	2025-11-20	\N	2025-11-20 12:32:50.169057	2025-11-20 12:32:50.169057
131	10	::1	\N	2025-11-21	\N	2025-11-21 08:06:49.007779	2025-11-21 08:06:49.007779
132	15	127.0.0.1	\N	2025-11-21	\N	2025-11-21 09:12:30.422315	2025-11-21 09:12:30.422315
133	10	127.0.0.1	\N	2025-11-21	\N	2025-11-21 09:13:04.402085	2025-11-21 09:13:04.402085
135	15	::1	\N	2025-11-21	\N	2025-11-21 09:13:14.411802	2025-11-21 09:13:14.411802
147	14	127.0.0.1	\N	2025-11-21	\N	2025-11-21 09:39:07.612556	2025-11-21 09:39:07.612556
148	14	::1	\N	2025-11-21	\N	2025-11-21 09:39:09.865061	2025-11-21 09:39:09.865061
178	1	127.0.0.1	\N	2025-11-21	\N	2025-11-21 10:47:55.188331	2025-11-21 10:47:55.188331
179	13	127.0.0.1	\N	2025-11-21	\N	2025-11-21 11:07:46.379162	2025-11-21 11:07:46.379162
188	13	::1	\N	2025-11-21	\N	2025-11-21 12:00:05.8212	2025-11-21 12:00:05.8212
197	5	::1	\N	2025-11-21	\N	2025-11-21 13:13:17.824704	2025-11-21 13:13:17.824704
200	15	127.0.0.1	\N	2025-11-22	\N	2025-11-22 02:17:39.283798	2025-11-22 02:17:39.283798
204	15	::1	\N	2025-11-22	\N	2025-11-22 02:18:51.33838	2025-11-22 02:18:51.33838
233	10	127.0.0.1	\N	2025-11-22	\N	2025-11-22 02:55:27.609527	2025-11-22 02:55:27.609527
250	14	127.0.0.1	\N	2025-11-22	\N	2025-11-22 04:48:34.405606	2025-11-22 04:48:34.405606
252	15	127.0.0.1	\N	2025-11-23	\N	2025-11-23 11:30:14.311506	2025-11-23 11:30:14.311506
254	14	127.0.0.1	\N	2025-11-23	\N	2025-11-23 11:33:55.045741	2025-11-23 11:33:55.045741
255	15	::1	\N	2025-11-23	\N	2025-11-23 11:34:02.430368	2025-11-23 11:34:02.430368
257	10	127.0.0.1	\N	2025-11-23	\N	2025-11-23 11:34:12.702422	2025-11-23 11:34:12.702422
258	10	::1	\N	2025-11-23	\N	2025-11-23 11:34:13.677546	2025-11-23 11:34:13.677546
259	13	::1	\N	2025-11-23	\N	2025-11-23 11:34:36.047163	2025-11-23 11:34:36.047163
262	13	127.0.0.1	\N	2025-11-23	\N	2025-11-23 11:40:33.085908	2025-11-23 11:40:33.085908
264	10	127.0.0.1	\N	2025-11-24	\N	2025-11-24 04:47:09.989425	2025-11-24 04:47:09.989425
267	10	127.0.0.1	\N	2025-11-25	\N	2025-11-25 07:37:13.52576	2025-11-25 07:37:13.52576
268	10	::1	\N	2025-11-25	\N	2025-11-25 07:37:16.843626	2025-11-25 07:37:16.843626
273	14	::1	\N	2025-11-25	\N	2025-11-25 07:42:17.381021	2025-11-25 07:42:17.381021
274	12	::1	\N	2025-11-25	\N	2025-11-25 07:42:21.044935	2025-11-25 07:42:21.044935
275	11	::1	\N	2025-11-25	\N	2025-11-25 07:42:24.915975	2025-11-25 07:42:24.915975
276	2	::1	\N	2025-11-25	\N	2025-11-25 07:46:26.436874	2025-11-25 07:46:26.436874
278	1	::1	\N	2025-11-25	\N	2025-11-25 07:47:21.547517	2025-11-25 07:47:21.547517
279	3	::1	\N	2025-11-25	\N	2025-11-25 07:47:27.376601	2025-11-25 07:47:27.376601
280	11	127.0.0.1	\N	2025-11-25	\N	2025-11-25 07:51:19.535309	2025-11-25 07:51:19.535309
281	9	127.0.0.1	\N	2025-11-25	\N	2025-11-25 07:51:25.769439	2025-11-25 07:51:25.769439
282	3	127.0.0.1	\N	2025-11-25	\N	2025-11-25 07:51:35.002609	2025-11-25 07:51:35.002609
285	9	::1	\N	2025-11-25	\N	2025-11-25 08:04:52.705501	2025-11-25 08:04:52.705501
286	7	::1	\N	2025-11-26	\N	2025-11-26 10:47:17.758197	2025-11-26 10:47:17.758197
287	7	127.0.0.1	\N	2025-11-26	\N	2025-11-26 10:47:37.786322	2025-11-26 10:47:37.786322
288	10	::1	\N	2025-11-26	\N	2025-11-26 12:58:34.336807	2025-11-26 12:58:34.336807
293	14	127.0.0.1	\N	2025-11-27	\N	2025-11-27 02:05:57.007122	2025-11-27 02:05:57.007122
294	12	127.0.0.1	\N	2025-11-27	\N	2025-11-27 02:06:06.582522	2025-11-27 02:06:06.582522
295	13	127.0.0.1	\N	2025-11-27	\N	2025-11-27 02:07:03.332344	2025-11-27 02:07:03.332344
297	14	::1	\N	2025-11-27	\N	2025-11-27 02:09:20.051485	2025-11-27 02:09:20.051485
300	12	::1	\N	2025-11-27	\N	2025-11-27 02:11:27.919872	2025-11-27 02:11:27.919872
319	13	::1	\N	2025-11-27	\N	2025-11-27 03:34:56.982235	2025-11-27 03:34:56.982235
321	5	127.0.0.1	\N	2025-11-27	\N	2025-11-27 03:41:14.106864	2025-11-27 03:41:14.106864
331	8	127.0.0.1	\N	2025-11-27	\N	2025-11-27 07:30:24.920321	2025-11-27 07:30:24.920321
332	8	::1	\N	2025-11-27	\N	2025-11-27 07:30:27.672602	2025-11-27 07:30:27.672602
335	10	::1	\N	2025-11-27	\N	2025-11-27 09:02:03.5543	2025-11-27 09:02:03.5543
336	9	::1	\N	2025-11-27	\N	2025-11-27 09:02:07.493587	2025-11-27 09:02:07.493587
339	6	127.0.0.1	\N	2025-11-29	\N	2025-11-29 05:18:24.356826	2025-11-29 05:18:24.356826
340	14	127.0.0.1	\N	2025-11-29	\N	2025-11-29 12:10:32.352776	2025-11-29 12:10:32.352776
341	14	::1	\N	2025-11-29	\N	2025-11-29 12:10:33.624563	2025-11-29 12:10:33.624563
342	14	::1	\N	2025-12-02	\N	2025-12-02 15:51:22.734342	2025-12-02 15:51:22.734342
343	14	127.0.0.1	\N	2025-12-02	\N	2025-12-02 15:51:24.236735	2025-12-02 15:51:24.236735
344	13	127.0.0.1	\N	2025-12-04	\N	2025-12-04 03:00:07.332742	2025-12-04 03:00:07.332742
346	14	202.46.155.71	\N	2025-12-16	\N	2025-12-16 00:39:07.082541	2025-12-16 00:39:07.082541
348	12	103.111.191.90	\N	2025-12-16	\N	2025-12-16 03:35:06.726303	2025-12-16 03:35:06.726303
350	10	103.111.191.90	\N	2025-12-16	\N	2025-12-16 07:26:35.21447	2025-12-16 07:26:35.21447
351	1	116.206.240.83	\N	2025-12-16	\N	2025-12-16 07:35:21.327734	2025-12-16 07:35:21.327734
353	13	103.111.191.90	\N	2025-12-16	\N	2025-12-16 07:50:03.638924	2025-12-16 07:50:03.638924
354	3	103.111.191.90	\N	2025-12-16	\N	2025-12-16 07:51:47.13557	2025-12-16 07:51:47.13557
357	8	36.91.84.243	\N	2025-12-17	\N	2025-12-17 08:16:37.204129	2025-12-17 08:16:37.204129
358	9	158.140.166.70	\N	2025-12-17	\N	2025-12-17 15:46:25.964321	2025-12-17 15:46:25.964321
360	13	45.126.187.12	\N	2025-12-18	\N	2025-12-18 15:38:54.652368	2025-12-18 15:38:54.652368
365	5	45.126.187.12	\N	2025-12-18	\N	2025-12-18 15:44:51.785935	2025-12-18 15:44:51.785935
367	15	45.126.187.12	\N	2025-12-18	\N	2025-12-18 15:45:03.91322	2025-12-18 15:45:03.91322
373	13	45.126.187.12	\N	2025-12-19	\N	2025-12-19 04:18:05.100713	2025-12-19 04:18:05.100713
378	13	36.73.154.72	\N	2025-12-19	\N	2025-12-19 08:36:08.766709	2025-12-19 08:36:08.766709
379	15	114.5.104.49	\N	2025-12-19	\N	2025-12-19 22:12:55.793048	2025-12-19 22:12:55.793048
380	13	114.5.104.49	\N	2025-12-19	\N	2025-12-19 22:13:07.559776	2025-12-19 22:13:07.559776
384	13	45.126.187.12	\N	2025-12-20	\N	2025-12-20 01:22:25.806979	2025-12-20 01:22:25.806979
399	13	36.73.210.122	\N	2025-12-20	\N	2025-12-20 07:51:13.660575	2025-12-20 07:51:13.660575
401	13	114.8.223.162	\N	2025-12-20	\N	2025-12-20 11:12:21.075952	2025-12-20 11:12:21.075952
403	34	114.8.223.162	\N	2025-12-20	\N	2025-12-20 11:32:59.461473	2025-12-20 11:32:59.461473
408	31	114.8.223.162	\N	2025-12-20	\N	2025-12-20 11:33:44.890543	2025-12-20 11:33:44.890543
411	26	114.8.223.162	\N	2025-12-20	\N	2025-12-20 11:33:53.316286	2025-12-20 11:33:53.316286
413	34	122.144.5.30	\N	2025-12-22	\N	2025-12-22 03:19:03.939885	2025-12-22 03:19:03.939885
416	8	122.144.5.30	\N	2025-12-22	\N	2025-12-22 03:32:24.689137	2025-12-22 03:32:24.689137
419	30	122.144.5.30	\N	2025-12-22	\N	2025-12-22 03:32:35.975266	2025-12-22 03:32:35.975266
421	13	122.144.5.30	\N	2025-12-22	\N	2025-12-22 03:33:45.715463	2025-12-22 03:33:45.715463
425	13	158.140.166.107	\N	2025-12-22	\N	2025-12-22 03:41:04.255003	2025-12-22 03:41:04.255003
435	21	122.144.5.30	\N	2025-12-22	\N	2025-12-22 04:04:15.715467	2025-12-22 04:04:15.715467
437	33	122.144.5.30	\N	2025-12-22	\N	2025-12-22 04:06:42.792536	2025-12-22 04:06:42.792536
439	35	122.144.5.30	\N	2025-12-22	\N	2025-12-22 04:16:14.83503	2025-12-22 04:16:14.83503
447	32	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:29:31.24281	2025-12-22 08:29:31.24281
448	31	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:29:34.868733	2025-12-22 08:29:34.868733
450	29	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:29:43.296121	2025-12-22 08:29:43.296121
451	28	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:29:48.853547	2025-12-22 08:29:48.853547
452	27	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:29:53.577051	2025-12-22 08:29:53.577051
453	26	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:29:56.940163	2025-12-22 08:29:56.940163
454	3	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:30:03.800234	2025-12-22 08:30:03.800234
455	4	122.144.5.30	\N	2025-12-22	\N	2025-12-22 08:30:06.762778	2025-12-22 08:30:06.762778
460	36	122.144.5.30	\N	2025-12-22	\N	2025-12-22 09:33:17.613439	2025-12-22 09:33:17.613439
473	8	182.253.87.182	\N	2025-12-22	\N	2025-12-22 11:35:32.058159	2025-12-22 11:35:32.058159
475	7	182.253.87.182	\N	2025-12-22	\N	2025-12-22 11:36:48.045628	2025-12-22 11:36:48.045628
477	36	182.253.87.182	\N	2025-12-22	\N	2025-12-22 11:39:34.295582	2025-12-22 11:39:34.295582
478	21	182.253.87.182	\N	2025-12-22	\N	2025-12-22 11:40:06.233397	2025-12-22 11:40:06.233397
479	13	114.8.218.219	\N	2025-12-22	\N	2025-12-22 14:23:02.023252	2025-12-22 14:23:02.023252
483	13	49.128.181.227	\N	2025-12-22	\N	2025-12-22 14:33:39.060412	2025-12-22 14:33:39.060412
487	36	49.128.181.227	\N	2025-12-22	\N	2025-12-22 14:34:47.44227	2025-12-22 14:34:47.44227
488	21	49.128.181.227	\N	2025-12-22	\N	2025-12-22 14:35:06.79613	2025-12-22 14:35:06.79613
494	12	49.128.181.227	\N	2025-12-22	\N	2025-12-22 14:35:37.615804	2025-12-22 14:35:37.615804
511	37	114.8.218.219	\N	2025-12-22	\N	2025-12-22 14:57:47.932486	2025-12-22 14:57:47.932486
513	37	49.128.181.227	\N	2025-12-22	\N	2025-12-22 14:59:17.397988	2025-12-22 14:59:17.397988
517	36	114.8.218.219	\N	2025-12-22	\N	2025-12-22 15:08:09.628043	2025-12-22 15:08:09.628043
518	21	114.8.218.219	\N	2025-12-22	\N	2025-12-22 15:08:14.720427	2025-12-22 15:08:14.720427
527	26	114.10.44.236	\N	2025-12-22	\N	2025-12-22 15:13:51.331807	2025-12-22 15:13:51.331807
536	21	114.10.44.236	\N	2025-12-22	\N	2025-12-22 15:15:24.181454	2025-12-22 15:15:24.181454
541	1	114.10.44.236	\N	2025-12-22	\N	2025-12-22 15:15:43.908234	2025-12-22 15:15:43.908234
542	37	114.10.44.236	\N	2025-12-22	\N	2025-12-22 15:15:47.288548	2025-12-22 15:15:47.288548
547	36	114.10.44.236	\N	2025-12-22	\N	2025-12-22 15:27:08.594366	2025-12-22 15:27:08.594366
574	12	114.10.44.236	\N	2025-12-22	\N	2025-12-22 15:42:30.682168	2025-12-22 15:42:30.682168
628	14	114.10.44.236	\N	2025-12-22	\N	2025-12-22 16:37:46.201396	2025-12-22 16:37:46.201396
630	5	114.10.44.236	\N	2025-12-22	\N	2025-12-22 16:37:49.463366	2025-12-22 16:37:49.463366
638	1	49.128.181.227	\N	2025-12-22	\N	2025-12-22 16:58:07.361128	2025-12-22 16:58:07.361128
646	1	104.28.247.132	\N	2025-12-22	\N	2025-12-22 17:27:59.848565	2025-12-22 17:27:59.848565
647	21	104.28.247.132	\N	2025-12-22	\N	2025-12-22 17:28:02.226207	2025-12-22 17:28:02.226207
648	36	104.28.247.132	\N	2025-12-22	\N	2025-12-22 17:28:07.106166	2025-12-22 17:28:07.106166
660	38	158.140.166.107	\N	2025-12-22	\N	2025-12-22 17:52:59.848816	2025-12-22 17:52:59.848816
661	21	110.138.91.89	\N	2025-12-23	\N	2025-12-23 01:35:12.803057	2025-12-23 01:35:12.803057
662	36	110.138.91.89	\N	2025-12-23	\N	2025-12-23 01:46:33.485723	2025-12-23 01:46:33.485723
666	36	158.140.166.107	\N	2025-12-23	\N	2025-12-23 02:02:24.60979	2025-12-23 02:02:24.60979
669	36	182.2.72.93	\N	2025-12-23	\N	2025-12-23 02:42:22.768068	2025-12-23 02:42:22.768068
673	36	114.10.20.192	\N	2025-12-23	\N	2025-12-23 06:30:29.332247	2025-12-23 06:30:29.332247
676	36	36.73.214.37	\N	2025-12-26	\N	2025-12-26 04:07:04.317573	2025-12-26 04:07:04.317573
678	33	114.8.208.47	\N	2025-12-29	\N	2025-12-29 10:01:46.363603	2025-12-29 10:01:46.363603
681	8	114.8.208.47	\N	2025-12-29	\N	2025-12-29 10:02:43.573305	2025-12-29 10:02:43.573305
684	30	114.8.208.47	\N	2025-12-29	\N	2025-12-29 10:02:52.860412	2025-12-29 10:02:52.860412
687	9	114.8.208.47	\N	2025-12-29	\N	2025-12-29 10:03:11.261445	2025-12-29 10:03:11.261445
690	7	114.8.208.47	\N	2025-12-29	\N	2025-12-29 10:03:30.691256	2025-12-29 10:03:30.691256
692	36	114.8.208.47	\N	2025-12-29	\N	2025-12-29 10:07:19.654837	2025-12-29 10:07:19.654837
694	36	110.138.92.134	\N	2025-12-29	\N	2025-12-29 13:05:25.307808	2025-12-29 13:05:25.307808
700	36	110.138.92.134	\N	2025-12-30	\N	2025-12-30 03:06:21.13852	2025-12-30 03:06:21.13852
701	33	114.10.44.100	\N	2025-12-30	\N	2025-12-30 09:12:53.964251	2025-12-30 09:12:53.964251
706	33	36.73.150.215	\N	2026-01-02	\N	2026-01-02 08:19:03.715627	2026-01-02 08:19:03.715627
708	36	180.252.158.134	\N	2026-01-05	\N	2026-01-05 07:13:52.581732	2026-01-05 07:13:52.581732
709	21	180.252.158.134	\N	2026-01-05	\N	2026-01-05 07:14:00.700243	2026-01-05 07:14:00.700243
710	36	114.10.44.217	\N	2026-01-06	\N	2026-01-06 03:28:13.659713	2026-01-06 03:28:13.659713
712	36	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:29:00.906953	2026-01-06 03:29:00.906953
713	21	114.10.44.217	\N	2026-01-06	\N	2026-01-06 03:29:08.312593	2026-01-06 03:29:08.312593
714	21	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:29:17.723751	2026-01-06 03:29:17.723751
716	27	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:31:14.026258	2026-01-06 03:31:14.026258
719	1	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:32:54.747417	2026-01-06 03:32:54.747417
720	2	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:33:13.27013	2026-01-06 03:33:13.27013
721	6	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:33:13.83338	2026-01-06 03:33:13.83338
722	10	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:33:14.091798	2026-01-06 03:33:14.091798
726	33	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:38:42.310259	2026-01-06 03:38:42.310259
728	11	114.10.44.217	\N	2026-01-06	\N	2026-01-06 03:54:35.031693	2026-01-06 03:54:35.031693
732	12	114.10.44.217	\N	2026-01-06	\N	2026-01-06 03:54:58.239624	2026-01-06 03:54:58.239624
737	20	114.10.44.217	\N	2026-01-06	\N	2026-01-06 03:55:36.542426	2026-01-06 03:55:36.542426
739	12	36.91.84.243	\N	2026-01-06	\N	2026-01-06 03:55:41.936257	2026-01-06 03:55:41.936257
742	28	114.10.44.217	\N	2026-01-06	\N	2026-01-06 03:58:22.119222	2026-01-06 03:58:22.119222
745	36	114.10.31.119	\N	2026-01-06	\N	2026-01-06 11:19:36.261712	2026-01-06 11:19:36.261712
747	36	114.10.44.56	\N	2026-01-06	\N	2026-01-06 12:26:19.243773	2026-01-06 12:26:19.243773
750	33	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:10:59.969827	2026-01-06 16:10:59.969827
753	32	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:12:58.934755	2026-01-06 16:12:58.934755
755	31	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:13:05.76567	2026-01-06 16:13:05.76567
756	30	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:13:07.468962	2026-01-06 16:13:07.468962
760	29	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:15:51.296246	2026-01-06 16:15:51.296246
761	28	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:15:53.784971	2026-01-06 16:15:53.784971
762	27	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:15:55.883374	2026-01-06 16:15:55.883374
763	26	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:15:57.543783	2026-01-06 16:15:57.543783
764	25	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:03.281803	2026-01-06 16:16:03.281803
765	24	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:07.224624	2026-01-06 16:16:07.224624
766	23	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:09.185386	2026-01-06 16:16:09.185386
767	22	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:12.527593	2026-01-06 16:16:12.527593
768	20	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:15.937745	2026-01-06 16:16:15.937745
769	19	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:17.971043	2026-01-06 16:16:17.971043
770	18	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:20.014014	2026-01-06 16:16:20.014014
771	11	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:26.82401	2026-01-06 16:16:26.82401
772	17	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:32.450371	2026-01-06 16:16:32.450371
773	14	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:38.999109	2026-01-06 16:16:38.999109
774	12	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:44.093255	2026-01-06 16:16:44.093255
775	10	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:16:51.676736	2026-01-06 16:16:51.676736
779	21	114.10.31.119	\N	2026-01-06	\N	2026-01-06 16:19:11.221717	2026-01-06 16:19:11.221717
781	17	36.91.84.243	\N	2026-01-08	\N	2026-01-08 05:24:10.363173	2026-01-08 05:24:10.363173
783	32	36.91.84.243	\N	2026-01-08	\N	2026-01-08 05:24:24.72212	2026-01-08 05:24:24.72212
786	33	36.91.84.243	\N	2026-01-08	\N	2026-01-08 05:24:33.339116	2026-01-08 05:24:33.339116
789	27	36.91.84.243	\N	2026-01-08	\N	2026-01-08 05:25:40.756232	2026-01-08 05:25:40.756232
790	26	36.91.84.243	\N	2026-01-08	\N	2026-01-08 05:25:43.335051	2026-01-08 05:25:43.335051
794	36	114.10.44.217	\N	2026-01-12	\N	2026-01-12 04:31:46.431335	2026-01-12 04:31:46.431335
796	33	114.10.44.217	\N	2026-01-12	\N	2026-01-12 04:32:48.6584	2026-01-12 04:32:48.6584
798	21	180.252.149.102	\N	2026-01-15	\N	2026-01-15 04:53:13.020406	2026-01-15 04:53:13.020406
800	36	180.252.149.102	\N	2026-01-15	\N	2026-01-15 04:54:14.872794	2026-01-15 04:54:14.872794
802	12	180.252.149.102	\N	2026-01-15	\N	2026-01-15 04:59:33.637633	2026-01-15 04:59:33.637633
803	33	180.252.149.102	\N	2026-01-15	\N	2026-01-15 05:01:39.705349	2026-01-15 05:01:39.705349
806	26	180.252.149.102	\N	2026-01-15	\N	2026-01-15 05:01:57.774524	2026-01-15 05:01:57.774524
809	32	180.252.149.102	\N	2026-01-15	\N	2026-01-15 05:03:08.784479	2026-01-15 05:03:08.784479
812	31	180.252.149.102	\N	2026-01-15	\N	2026-01-15 05:04:21.194934	2026-01-15 05:04:21.194934
815	30	180.252.149.102	\N	2026-01-15	\N	2026-01-15 05:04:59.53796	2026-01-15 05:04:59.53796
817	33	36.80.243.224	\N	2026-01-15	\N	2026-01-15 05:14:20.123371	2026-01-15 05:14:20.123371
819	32	36.80.243.224	\N	2026-01-15	\N	2026-01-15 05:14:38.273963	2026-01-15 05:14:38.273963
821	36	114.10.44.56	\N	2026-01-15	\N	2026-01-15 05:17:55.827077	2026-01-15 05:17:55.827077
824	30	114.10.44.56	\N	2026-01-15	\N	2026-01-15 08:41:53.768702	2026-01-15 08:41:53.768702
827	30	114.10.19.156	\N	2026-01-15	\N	2026-01-15 10:35:06.954595	2026-01-15 10:35:06.954595
\.


--
-- Data for Name: kmis_topics; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kmis_topics (id, kmis_categories_id, topic_cover_ids, title, description, deleted_at, created_at, updated_at, total_quiz, quiz_duration, material_order_ids, total_views, topic_type, user_pic) FROM stdin;
36	31	[292]	Modul Investasi Perdagangan Karbon APL Kawasan RIMBA	Modul Investasi Perdagangan Karbon APL Kawasan RIMBA merupakan instrumen strategis yang dirancang untuk memetakan dan mengoptimalkan potensi ekonomi dari sekuestrasi karbon di Areal Penggunaan Lain (APL) melalui mekanisme pasar karbon yang terstandardisasi. Dokumen ini menyajikan kerangka kerja holistik bagi para investor untuk memonetisasi nilai ekologis lahan non-hutan, mengubah paradigma pemanfaatan lahan dari eksploitasi konvensional menjadi konservasi produktif yang bernilai ekonomi tinggi. Dengan mengintegrasikan analisis risiko, validasi metodologi perhitungan kredit karbon, dan skema kemitraan yang inklusif, modul ini tidak hanya menawarkan panduan teknis untuk mencapai Return on Investment (ROI) yang kompetitif, tetapi juga memastikan kontribusi nyata terhadap mitigasi perubahan iklim global serta keberlanjutan keanekaragaman hayati di kawasan RIMBA	\N	2025-12-22 09:21:33.205075	2026-01-09 07:53:37.708289	20	1500	[68, 73, 74]	22	Pelatihan	[42]
35	31	[290]	Modul Investasi Perdagangan Karbon	Modul Investasi Perdagangan Karbon	2025-12-22 08:04:04.644925	2025-12-22 04:14:05.355962	2025-12-22 04:19:29.301808	0	\N	[67]	1	Pengetahuan	[2, 42]
13	1	[104]	Demo Topik KMIS	RIMBA merupakan sesi demonstrasi sistem Knowledge Management Information System (KMIS) yang dikembangkan untuk mendukung pengelolaan informasi, dokumentasi, dan kolaborasi data di lingkungan RIMBA. Kegiatan ini menampilkan fitur utama seperti manajemen pengetahuan, pelaporan, serta integrasi data lintas unit sebagai upaya meningkatkan efisiensi dan transparansi proses kerja.	2025-12-22 14:50:15.581715	2025-11-04 03:31:53.909169	2025-12-22 14:56:04.615608	0	7380	["69", "70"]	29	Pengetahuan	[42]
37	1	[294]	DEMO PELATIHAN KMIS	DEMO PELATIHAN KMIS	2025-12-22 17:50:08.099681	2025-12-22 14:54:19.325001	2025-12-22 17:53:52.414773	0	600	[71, 72]	3	Pelatihan	[2, 42]
38	1	[296]	DEMO TEST KMIS FIXING	DEMO TEST KMIS FIXING	2025-12-22 17:54:05.772264	2025-12-22 17:50:54.450117	2025-12-22 17:53:48.584823	0	1200	[75]	1	Pelatihan	[2, 42]
15	9	[298]	Test Pengetahuan	test	2025-12-22 14:53:41.732989	2025-11-21 08:12:52.737841	2025-12-22 17:55:12.27111	0	\N	["20", "21"]	8	Pengetahuan	[2]
34	30	[259]	Pengeloaan Mangrove Berkelanjutan	Pengeloaan Mangrove Berkelanjutan	2025-12-22 07:49:40.125216	2025-12-20 02:42:06.68081	2025-12-22 07:08:20.853727	0	\N	[]	2	Pengetahuan	[2, 42]
21	17	[246]	Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon Paket 4A-2025	Modul Ekonomi Hijau dan Inovasi Teknologi Rendah Karbon	\N	2025-12-20 02:30:45.170428	2026-01-09 07:53:37.708289	6	1500	[124, 125]	12	Pelatihan	[2, 42]
31	27	[256]	RPH KPH Klaster 3 Koridor Rimba: Konektivitas dan Konservasi Lanskap 11A-2025	RPH KPH Klaster 3 Koridor Rimba: Konektivitas dan Konservasi Lanskap	\N	2025-12-20 02:39:40.199677	2026-01-09 07:53:37.708289	0	\N	[120, 121]	4	Pengetahuan	[2, 42]
33	29	[258]	Peluang Investasi Ekonomi Hijau Koridor Rimba Paket 12-2025	Peluang Investasi Ekonomi Hijau Koridor Rimba	\N	2025-12-20 02:41:39.391137	2026-01-09 07:53:37.708289	20	\N	[130, 131]	10	Pengetahuan	[2, 42]
22	18	[247]	ToT Ekonomi Hijau dan Teknologi Rendah Karbon Paket 4B-2025	ToT Ekonomi Hijau dan Teknologi Rendah Karbon	\N	2025-12-20 02:31:20.398766	2026-01-09 07:53:37.708289	0	\N	[]	1	Pengetahuan	[2, 42]
16	12	[241]	Sinergi Kebijakan Tata Ruang Koridor Rimba Paket 1A-2025	Sinergi Kebijakan Tata Ruang Koridor Rimba	\N	2025-12-20 02:27:33.683351	2026-01-09 07:53:37.708289	0	\N	[105, 106]	\N	Pengetahuan	[2, 42]
17	13	[242]	RTR-KSN Taman Nasional Sembilang Paket 1B-2025	RTR-KSN Taman Nasional Sembilang	\N	2025-12-20 02:28:37.717645	2026-01-09 07:53:37.708289	0	\N	[76, 107]	2	Pengetahuan	[2, 42]
4	3	[180]	Pengelola Koridor Ekosistem Paket 5-2024	Pengelola Koridor Ekosistem berfokus pada upaya untuk memelihara dan mengelola kawasan yang berfungsi sebagai jalur penghubung antara habitat alami, guna menjaga kelangsungan hidup spesies dan keberagaman hayati.	\N	2025-11-02 03:03:06.318837	2026-01-09 07:53:37.708289	0	7380	[28, 88]	4	Pengetahuan	[42]
1	2	[183]	Perencanaan Ekonomi Hijau Paket 1-2024	Perencanaan Ekonomi Hijau merupakan pendekatan strategis dalam pembangunan yang mengintegrasikan aspek ekonomi, sosial, dan lingkungan secara seimbang.	\N	2025-11-01 04:14:20.007379	2026-01-09 07:53:37.708289	2	7380	[11, 96]	21	Pengetahuan	[42]
24	20	[249]	Pengelolaan Lingkungan dan Hutan Berkelanjutan Berbasis Masyarakat Paket 5-2025	Pengelolaan Lingkungan dan Hutan Berkelanjutan Berbasis Masyarakat	\N	2025-12-20 02:32:23.357271	2026-01-09 07:53:37.708289	0	\N	[]	1	Pengetahuan	[2, 42]
10	3	[175]	Integrasi Ekonomi Hijau Paket 10-2024	Integrasi Ekonomi Hijau adalah pendekatan yang menggabungkan prinsip-prinsip keberlanjutan lingkungan dalam pembangunan ekonomi, dengan tujuan menciptakan pertumbuhan yang inklusif dan ramah lingkungan.	\N	2025-11-02 13:28:55.944444	2026-01-09 07:53:37.708289	0	7380	[38, 93, 102]	15	Pengetahuan	[42]
28	24	[253]	Perencanaan Lahan Partisipatif dan Penanganan Permukiman Ilegal Paket 9A-2025	Perencanaan Lahan Partisipatif dan Penanganan Permukiman Ilegal	\N	2025-12-20 02:38:07.182521	2026-01-09 07:53:37.708289	0	\N	[127]	3	Pengetahuan	[2, 42]
14	11	[185]	Materi Induksi dan Orientasi Program Koridor Ekosistem Rimba	Materi Induksi dan Orientasi Program Koridor Ekosistem Rimba	\N	2025-11-18 20:05:10.748324	2026-01-09 07:53:37.708289	0	600	[14]	18	Pengetahuan	[42]
19	15	[244]	Mekanisme Insentif, Disinsentif, dan IJE Tata Ruang Koridor Rimba Paket 2B-2025	Mekanisme Insentif, Disinsentif, dan IJE Tata Ruang Koridor Rimba	\N	2025-12-20 02:29:46.267094	2026-01-09 07:53:37.708289	0	\N	[77, 123]	1	Pengetahuan	[2, 42]
18	14	[243]	Pengembangan Kelembagaan Ekonomi Hijau Ekosistem Rimba Paket 2A-2025	Pengembangan Kelembagaan Ekonomi Hijau Ekosistem Rimba	\N	2025-12-20 02:29:07.171785	2026-01-09 07:53:37.708289	0	\N	[108]	1	Pengetahuan	[2, 42]
11	9	[174]	Digitalisasi Monitoring dan Knowledge Management Paket 11-2024	Digitalisasi Monitoring & Knowledge Management adalah penerapan teknologi digital dalam proses pemantauan dan pengelolaan pengetahuan di berbagai organisasi. Melalui penggunaan alat dan sistem berbasis teknologi, seperti platform berbasis cloud, sensor, dan perangkat lunak analitik, organisasi dapat memantau kinerja secara real-time, mengumpulkan data, dan mengelola informasi dengan lebih efisien.	\N	2025-11-02 13:34:30.234451	2026-01-09 07:53:37.708289	0	7380	[94, 103]	8	Pengetahuan	[42]
27	23	[252]	Partisipasi dan Publikasi Ekonomi Hijau Nasional-Global Paket 8-2025	Partisipasi dan Publikasi Ekonomi Hijau Nasional-Global	\N	2025-12-20 02:37:37.962355	2026-01-09 07:53:37.708289	0	\N	[118, 119]	4	Pengetahuan	[2, 42]
2	3	[182]	Tata Ruang Kawasan Strategis Ksn Bukit Batabuh Paket 2- 2024	Tata Ruang & Perencanaan Wilayah membahas pengelolaan ruang dan wilayah secara terpadu untuk mencapai keseimbangan antara pembangunan ekonomi, sosial, dan kelestarian lingkungan.	\N	2025-11-02 03:01:15.763131	2026-01-09 07:53:37.708289	0	7380	[25, 97, 86]	3	Pengetahuan	[42]
29	25	[254]	Desain Konektivitas Satwa dan Mitigasi Dampak Paket 9B-Paket 2025	Desain Konektivitas Satwa dan Mitigasi Dampak	\N	2025-12-20 02:38:37.222339	2026-01-09 07:53:37.708289	0	\N	[126]	2	Pengetahuan	[2, 42]
12	10	[173]	Investasi dan Publikasi Paket 12-2024	Investasi & Publikasi adalah dua aspek penting dalam mengembangkan dan memperkenalkan peluang bisnis atau proyek kepada publik dan calon investor. Investasi merujuk pada alokasi dana untuk mendukung pertumbuhan ekonomi atau pengembangan usaha, dengan tujuan menghasilkan keuntungan jangka panjang.	\N	2025-11-02 13:35:25.043019	2026-01-09 07:53:37.708289	0	7380	[39, 40, 41, 42, 95]	16	Pengetahuan	[42]
6	6	[178]	PLUP Kawasan Pedesaan Paket 6B-2024	PLUP (Perencanaan Lahan dan Usaha Pemanfaatan) Kawasan Pedesaan adalah proses perencanaan yang bertujuan untuk mengoptimalkan penggunaan lahan di kawasan pedesaan dengan mempertimbangkan aspek sosial, ekonomi, dan lingkungan.	\N	2025-11-02 13:24:05.772122	2026-01-09 07:53:37.708289	0	7380	[89, 99]	3	Pengetahuan	[42]
9	8	[176]	Partisipasi Masyarakat dan Alternatif Solusi Paket 9-2024	Partisipasi Masyarakat & Alternatif Solusi adalah konsep yang menekankan pentingnya keterlibatan aktif masyarakat dalam pengambilan keputusan dan pemecahan masalah, khususnya dalam konteks pengelolaan sumber daya alam dan pembangunan berkelanjutan.	\N	2025-11-02 13:28:00.658149	2026-01-09 07:53:37.708289	0	7380	[36, 37, 92, 101]	6	Pengetahuan	[42]
20	16	[245]	Strategi Komunikasi dan Pemasaran Sosial Ekonomi Hijau Koridor Rimba Paket 3-2025	Strategi Komunikasi dan Pemasaran Sosial Ekonomi Hijau Koridor Rimba	\N	2025-12-20 02:30:13.212255	2026-01-09 07:53:37.708289	0	\N	[79, 109, 110]	2	Pengetahuan	[2, 42]
3	4	[181]	Mekanisme Ekonomi Hijau Paket 4-2024	Mekanisme Ekonomi Hijau merujuk pada serangkaian kebijakan, instrumen, dan strategi yang dirancang untuk mendorong pertumbuhan ekonomi yang ramah lingkungan.	\N	2025-11-02 03:02:14.704459	2026-01-09 07:53:37.708289	0	7380	[26, 27, 87, 104]	5	Pengetahuan	[42]
25	21	[250]	Pengembangan Sistem Informasi dan Analisis Spasial Koridor Rimba Paket 6-2025	Pengembangan Sistem Informasi dan Analisis Spasial Koridor Rimba	\N	2025-12-20 02:32:51.725269	2026-01-09 07:53:37.708289	0	\N	[67, 114, 115]	1	Pengetahuan	[2, 42]
8	8	[184]	Pengelolaan Lahan Gambut dan Kebakaran Paket 8-2024	Pengelolaan Gambut & Kebakaran adalah upaya untuk melindungi dan mengelola ekosistem gambut yang rentan terhadap kebakaran. Lahan gambut, yang menyimpan karbon dalam jumlah besar, sangat sensitif terhadap perubahan iklim dan aktivitas manusia.	\N	2025-11-02 13:26:39.640458	2026-01-09 07:53:37.708289	0	7380	[33, 91, 100]	7	Pengetahuan	[42]
7	7	[177]	Pemantauan Satwa Liar Paket 7-2024	Pemantauan Satwa Liar adalah aktivitas yang dilakukan untuk mengawasi kondisi populasi, pergerakan, dan perilaku satwa liar di habitat alaminya. Tujuan utama dari pemantauan ini adalah untuk melindungi keanekaragaman hayati, mendeteksi ancaman terhadap spesies tertentu, serta mendukung upaya konservasi dan pengelolaan habitat.	\N	2025-11-02 13:25:19.091754	2026-01-09 07:53:37.708289	0	7380	[32, 90]	5	Pengetahuan	[42]
26	22	[251]	Integrasi Ekonomi Hijau dalam Perencanaan Tata Ruang Koridor Rimba Paket 7-2025	Integrasi Ekonomi Hijau dalam Perencanaan Tata Ruang Koridor Rimba	\N	2025-12-20 02:36:39.989621	2026-01-09 07:53:37.708289	0	\N	[83, 84, 85, 116, 117]	6	Pengetahuan	[2, 42]
30	26	[255]	Strategi Pemulihan Ekosistem Gambut dan Pengelolaan Hutan Berkelanjutan Paket 10-2025	Strategi Pemulihan Ekosistem Gambut dan Pengelolaan Hutan Berkelanjutan	\N	2025-12-20 02:39:11.542714	2026-01-09 07:53:37.708289	0	\N	[58, 56, 57, 59, 60, 61, 62, 63, 64, 128, 129]	6	Pengetahuan	[2, 42]
32	28	[257]	Penguatan Kapasitas PWS dan Perhutanan Sosial Klaster 3 Koridor Rimba 11B-2025	Penguatan Kapasitas PWS dan Perhutanan Sosial Klaster 3 Koridor Rimba	\N	2025-12-20 02:41:09.403077	2026-01-09 07:53:37.708289	0	\N	[122]	5	Pengetahuan	[2, 42]
5	5	[179]	Pengelolaan Hutan Berkelanjutan Paket 6A-2024	Pengelolaan Hutan Berkelanjutan adalah pendekatan yang bertujuan untuk memelihara keberlanjutan ekosistem hutan, dengan mempertimbangkan kebutuhan ekologis, ekonomi, dan sosial. Fokus utama dari pengelolaan ini adalah untuk memastikan bahwa hutan dikelola dengan cara yang tidak hanya memberikan manfaat jangka pendek, tetapi juga menjaga fungsi dan keberagaman hayati hutan untuk generasi mendatang.	\N	2025-11-02 13:22:07.959552	2026-01-09 07:53:37.708289	0	7380	[29, 30, 98]	6	Pengetahuan	[42]
23	19	[248]	Pedoman Produksi dan Konsumsi Berkelanjutan Paket 4C-2025	Pedoman Produksi dan Konsumsi Berkelanjutan	\N	2025-12-20 02:31:51.903857	2026-01-09 07:55:38.848027	0	\N	["81", "82", "112", "111", "113"]	1	Pengetahuan	[2, 42]
\.


--
-- Data for Name: modules; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.modules (id, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	kmis_dashboard	Dashboard utama modul KMIS Dashboard	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
2	kmis_category	Manajemen kategori modul KMIS Kategori	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
3	kmis_topic	Manajemen topik modul KMIS Topik	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
4	kmis_educator	Manajemen data modul KMIS Pengajar	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
5	kmis_student	Manajemen data modul KMIS Peserta	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
6	kmis_material	Manajemen modul KMIS Materi Pembelajaran	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
7	kmis_quiz	Manajemen modul KMIS Kuis dan Soal	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
8	monev_activity	Aktivitas modul Monev Monitoring dan Evaluasi	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
9	monev_verification	Proses verifikasi pada Monev	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
10	cms_management	Manajemen konten CMS	\N	2025-09-18 11:38:12.800216	2025-09-18 11:38:12.800216
11	master_data	Manajemen seluruh data master aplikasi	\N	2025-09-22 10:57:45.197092	2025-09-22 10:57:45.197092
12	kmis_learning_course	Pembelajaran dan ujian untuk peserta	\N	2025-10-03 14:46:51.784921	2025-10-03 14:46:51.784921
13	monev_target	Proses target pada Monev	\N	2025-10-26 11:27:41.274566	2025-10-26 11:27:41.274566
14	monev_monthly_realization	Proses realisasi bulanan pada Monev	\N	2025-10-26 11:27:41.274566	2025-10-26 11:27:41.274566
15	monev_activity_calendar	Manajemen aktivitas kalender pada Monev	\N	2025-10-26 11:27:41.274566	2025-10-26 11:27:41.274566
16	monev_share_report	Manajemen penyimpanan dokumen bersama	\N	2025-10-26 11:27:41.274566	2025-10-26 11:27:41.274566
17	monev_user	Manajemen pengguna non PIC dari MONEV	\N	2025-10-27 10:06:28.575685	2025-10-27 10:06:28.575685
18	monev_dashboard	Dashboard utama modul MONEV	\N	2025-10-31 15:57:48.227313	2025-10-31 15:57:48.227313
\.


--
-- Data for Name: monev_activity_calendar; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_activity_calendar (id, created_by, monev_activity_category_id, name, description, location, started_date, finished_date, started_time, finished_time, deleted_at, created_at, updated_at) FROM stdin;
1	1	5	Rapat Program Koridor Ekosistem RIMBA	Pembahasan mengenaik program koridor ekosistem RIMBA yang dihadiri oleh pihak PT WebGIS dan Exium Studio	Zoom 	2025-11-02	2025-11-02	09:00:00	12:00:00	\N	2025-11-01 02:59:10.87954	2025-11-01 02:59:10.87954
2	1	3	Testing RIMBA oleh Harawi	testing aja semuanya biar yoiii	Alva Cervo S5	2025-11-01	2025-11-01	08:00:00	15:00:00	\N	2025-11-01 03:10:22.056565	2025-11-01 07:08:35.296775
5	1	6	Pembahasan Laporan Antara Kegiatan Kontraktual dan Swakelola Tipe II	Pembahasan Laporan Antara Kegiatan Kontraktual dan Swakelola Tipe II Proyek Pengembangan Ekonomi Hijau di Koridor Ekosistem RIMBA, Direktorat Perencanaan Tata Ruang Tahun Anggaran 2025	Ruang Rapat Prambanan, Gedung Ditjen Tata Ruang Lantai 1, Jalan Raden Patah 1 No. 1, Kebayoran Baru, Jakarta Selatan	2025-10-28	2025-10-28	08:30:00	00:00:00	\N	2025-11-02 14:50:05.212359	2025-11-02 14:50:39.294309
7	1	1	FINALISASI SISTEM INFROMASI RIMBA	FINALISASI SISTEM INFROMASI RIMBA	Jakarta	2025-11-03	2025-11-03	00:00:00	00:00:00	\N	2025-11-03 16:38:56.022395	2025-11-05 03:01:31.704314
8	1	7	Audiensi dengan DISKOMINFO Bali	kegiatan bertujuan memberikan masukan terkait paket yang sedang dikerjakan	Bali	2025-11-04	2025-11-04	13:00:00	14:00:00	\N	2025-11-05 03:03:04.564183	2025-11-05 03:03:04.564183
10	1	6	FGD III	Pendalaman materi untuk penyusunan Aplikasi Kepatuhan Ekonomi Hijau dan Mengkaji Interoperabilitas Sistem Informasi RIMBA dengan Sistem Informasi SIGAP	THE 101 Jakarta Sedayu Darmawangsa	2025-11-11	2025-11-11	12:00:00	17:00:00	\N	2025-11-05 03:11:14.633501	2025-11-05 03:11:14.633501
11	1	6	Kajian Integrasi Kebijakan Satu Rencana Tata Ruang di Koridor Ekosistem RIMBA. Lokasi: Novotel Pekanbaru	Pukul 09.00 WIB Kajian Integrasi Kebijakan Satu Rencana Tata Ruang di Koridor Ekosistem RIMBA. Lokasi: Novotel Pekanbaru	Novotel Pekanbaru, Kota Pekanbaru, Provinsi Riau	2025-11-04	2025-11-04	09:00:00	17:00:00	\N	2025-11-27 07:37:08.866624	2025-11-27 07:37:08.866624
\.


--
-- Data for Name: monev_activity_categories; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_activity_categories (id, title, description, deleted_at, created_at, updated_at) FROM stdin;
1	test	test	\N	2025-11-01 02:45:39.710733	2025-11-01 02:45:39.710733
2	test 2	test 2	\N	2025-11-01 02:46:01.400309	2025-11-01 02:46:01.400309
3	test 3	test 3	\N	2025-11-01 02:46:55.695854	2025-11-01 02:46:55.695854
4	test 4	test 4	\N	2025-11-01 02:48:04.498073	2025-11-01 02:48:04.498073
5	test 5	test 5	\N	2025-11-01 02:58:01.689084	2025-11-01 02:58:01.689084
6	Forum Group Discussion (FGD)	Forum Group Discussion (FGD)	\N	2025-11-02 14:48:12.294696	2025-11-02 14:48:12.294696
7	Survey	Survey	\N	2025-11-05 03:01:50.985464	2025-11-05 03:01:50.985464
\.


--
-- Data for Name: monev_activity_packages; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_activity_packages (id, created_by, edited_by, monev_pic_division_id, contract_type, mak, name, description, started_month, finished_month, unit_output, code_output, volume, pagu, partner, deleted_at, created_at, updated_at, started_year, finished_year) FROM stdin;
10	1	\N	3	Swakelola 2	TEST MAK	Koordinasi Kebijakan Satu Rencana Tata Ruang Nasional"	Koordinasi Kebijakan Satu Rencana Tata Ruang Nasional"	0	9	Dokumen Pendukung RTR Nasional	DPRTRN	02	672800000	Perusahaan Test	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	2025	2025
11	1	\N	4	Swakelola 1	Test MAK	Penyusunan Petunjuk Teknis Mekanisme Perhitungan RTH Dengan Indeks Hijau Biru Indonesia Dan Privately Owned Publik Spaces	Penyusunan Petunjuk Teknis Mekanisme Perhitungan RTH Dengan Indeks Hijau Biru Indonesia Dan Privately Owned Publik Spaces	7	11	Rancangan Peraturan NSPK	RPNSPK	01	588959000	Test Perusahaan 2	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	2025	2025
\.


--
-- Data for Name: monev_dashboards; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_dashboards (id, framework_file_ids, plan_file_ids, description, networth_hibah, deleted_at, created_at, updated_at) FROM stdin;
1	[138]	[139]	-	9000000	\N	2025-11-04 13:25:58.823903	2025-11-27 07:38:45.125715
\.


--
-- Data for Name: monev_monthly_realization_pending_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_monthly_realization_pending_updates (id, monev_monthly_realization_id, monev_activity_packages_id, evidence_file_ids, month, budget_realization, progress, description, problem, deleted_at, created_at, updated_at, edited_by, year) FROM stdin;
\.


--
-- Data for Name: monev_monthly_realizations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_monthly_realizations (id, monev_activity_packages_id, evidence_file_ids, month, budget_realization, progress, description, problem, deleted_at, created_at, updated_at, validation_status, rejection_message, validate_at, validate_by, edited_by, year) FROM stdin;
49	10	[]	1	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
50	10	[]	2	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
51	10	[]	3	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
52	10	[]	4	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
53	10	[]	5	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
54	10	[]	6	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
55	10	[]	7	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
56	10	[]	8	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
57	10	[]	9	[]	0	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
58	11	[]	7	[]	0	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
59	11	[]	8	[]	0	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
60	11	[]	9	[]	0	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
61	11	[]	10	[]	0	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
62	11	[]	11	[]	0	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
48	10	[112]	0	[{"name": "KAS KEGIATAN", "value": 33000000}, {"name": "Akomodasi", "value": 640000}]	6	REALISASI KEGIATAN :\r\n1. Koordinasi Teknis terkait Muatan RPP RTRWN\r\n2. Pembahasan Pokok-Pokok Perubahan Muatan Rancangan Peraturan Pemerintah tentang Rencana Tata Ruang Wilayah Nasional\r\n3. Ekspose Revisi Rencana Tata Ruang Wilayah Nasional (RTRWN)\r\n\r\nREALISASI OUTPUT\r\n1. Notulensi dan dokumentasi Koordinasi Teknis terkait Muatan RPP RTRWN\r\n2. Notulensi dan dokumentasi Pembahasan Pokok-Pokok Perubahan Muatan Rancangan Peraturan Pemerintah tentang Rencana Tata Ruang Wilayah Nasional\r\n3. Notulensi dan dokumentasi Ekspose Revisi Rencana Tata Ruang Wilayah Nasional (RTRWN)	Tidak ada	\N	2025-11-05 02:43:34.090364	2025-11-05 03:00:23.812313	2	\N	2025-11-05 03:00:23.812313	1	1	2025
\.


--
-- Data for Name: monev_pic_divisions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_pic_divisions (id, user_pic, title, description, deleted_at, created_at, updated_at) FROM stdin;
3	[{"name": "Test User PIC MONEV", "email": "mapgis800@gmail.com"}]	Subdirektorat Perencanaan Tata Ruang Nasional, Pulau dan Kepulauan	Subdirektorat Perencanaan Tata Ruang Nasional, Pulau dan Kepulauan	\N	2025-11-02 03:39:19.51952	2025-11-03 01:09:30.933259
4	[{"name": "sulengpol", "email": "sulengpol@gmail.com"}]	Subdirektorat Pedoman Tata Ruang	Subdirektorat Pedoman Tata Ruang	\N	2025-11-03 00:52:24.714607	2025-11-03 06:01:12.452802
1	[]	Stock	Cek Stock	2025-11-03 07:37:35.111315	2025-11-01 09:26:52.132414	2025-11-01 09:26:52.132414
2	[{"name": "Ndoo", "email": "ndocfa123@gmail.com"}]	test 11	test 11	2025-11-05 22:54:07.395447	2025-11-02 02:44:13.302326	2025-11-04 22:16:10.039331
5	[]	Subdirektorat Perencanaan Tata Ruang Kawasan Strategis Nasional I	Subdirektorat Perencanaan Tata Ruang Kawasan Strategis Nasional I	\N	2025-11-27 07:32:11.042092	2025-11-27 07:32:11.042092
\.


--
-- Data for Name: monev_share_reports; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_share_reports (id, created_by, report_file_ids, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	1	[55]	test edit	test edit	2025-11-02 14:53:38.291309	2025-11-01 08:38:33.331972	2025-11-03 16:36:59.953698
\.


--
-- Data for Name: monev_target_pending_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_target_pending_updates (id, monev_target_id, monev_activity_packages_id, month, budget_target, physical_target, description, deleted_at, created_at, updated_at, edited_by, year) FROM stdin;
5	48	10	0	40368000	6	Target Kegiatan :Persiapan\nTarget Output : Rencana Kerja	2025-11-05 02:54:26.923264	2025-11-05 02:53:42.136557	2025-11-05 02:54:26.923264	39	2025
6	48	10	0	33640000	5	Target Kegiatan :Persiapan\nTarget Output : Rencana Kerja	2025-11-05 02:55:31.229148	2025-11-05 02:55:05.78578	2025-11-05 02:55:31.229148	39	2025
\.


--
-- Data for Name: monev_targets; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.monev_targets (id, monev_activity_packages_id, month, budget_target, physical_target, description, deleted_at, created_at, updated_at, validation_status, rejection_message, validate_at, validate_by, edited_by, year) FROM stdin;
49	10	1	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
50	10	2	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
51	10	3	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
52	10	4	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
53	10	5	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
54	10	6	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
55	10	7	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
56	10	8	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
57	10	9	\N	\N	\N	\N	2025-11-05 02:43:34.090364	2025-11-05 02:43:34.090364	\N	\N	\N	\N	\N	2025
59	11	8	\N	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
60	11	9	\N	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
61	11	10	\N	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
62	11	11	\N	\N	\N	\N	2025-11-05 02:49:28.250154	2025-11-05 02:49:28.250154	\N	\N	\N	\N	\N	2025
48	10	0	40368000	6	Target Kegiatan :Persiapan\nTarget Output : Rencana Kerja	\N	2025-11-05 02:43:34.090364	2025-11-05 02:55:31.229148	3	TIdak boleh mengganti lebih dari 1 kali	2025-11-05 02:55:31.229148	1	39	2025
58	11	7	500000	40	sudah diselenggarakan rapat	\N	2025-11-05 02:49:28.250154	2025-11-27 07:29:01.192954	2	\N	2025-11-27 07:29:01.192954	1	1	2025
\.


--
-- Data for Name: permissions; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.permissions (id, module_id, key, name, description, deleted_at, created_at, updated_at) FROM stdin;
1	1	view.kmis_dashboard	View	View permission untuk module kmis_dashboard	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
2	1	create.kmis_dashboard	Create	Create permission untuk module kmis_dashboard	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
3	1	edit.kmis_dashboard	Edit	Edit permission untuk module kmis_dashboard	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
4	1	delete.kmis_dashboard	Delete	Delete permission untuk module kmis_dashboard	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
5	1	restore.kmis_dashboard	Restore	Restore permission untuk module kmis_dashboard	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
6	2	view.kmis_category	View	View permission untuk module kmis_category	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
7	2	create.kmis_category	Create	Create permission untuk module kmis_category	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
8	2	edit.kmis_category	Edit	Edit permission untuk module kmis_category	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
9	2	delete.kmis_category	Delete	Delete permission untuk module kmis_category	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
10	2	restore.kmis_category	Restore	Restore permission untuk module kmis_category	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
11	3	view.kmis_topic	View	View permission untuk module kmis_topic	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
12	3	create.kmis_topic	Create	Create permission untuk module kmis_topic	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
13	3	edit.kmis_topic	Edit	Edit permission untuk module kmis_topic	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
14	3	delete.kmis_topic	Delete	Delete permission untuk module kmis_topic	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
15	3	restore.kmis_topic	Restore	Restore permission untuk module kmis_topic	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
16	4	view.kmis_educator	View	View permission untuk module kmis_educator	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
17	4	create.kmis_educator	Create	Create permission untuk module kmis_educator	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
18	4	edit.kmis_educator	Edit	Edit permission untuk module kmis_educator	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
19	4	delete.kmis_educator	Delete	Delete permission untuk module kmis_educator	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
20	4	restore.kmis_educator	Restore	Restore permission untuk module kmis_educator	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
21	5	view.kmis_student	View	View permission untuk module kmis_student	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
22	5	create.kmis_student	Create	Create permission untuk module kmis_student	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
23	5	edit.kmis_student	Edit	Edit permission untuk module kmis_student	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
24	5	delete.kmis_student	Delete	Delete permission untuk module kmis_student	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
25	5	restore.kmis_student	Restore	Restore permission untuk module kmis_student	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
26	6	view.kmis_material	View	View permission untuk module kmis_material	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
27	6	create.kmis_material	Create	Create permission untuk module kmis_material	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
28	6	edit.kmis_material	Edit	Edit permission untuk module kmis_material	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
29	6	delete.kmis_material	Delete	Delete permission untuk module kmis_material	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
30	6	restore.kmis_material	Restore	Restore permission untuk module kmis_material	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
31	7	view.kmis_quiz	View	View permission untuk module kmis_quiz	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
32	7	create.kmis_quiz	Create	Create permission untuk module kmis_quiz	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
33	7	edit.kmis_quiz	Edit	Edit permission untuk module kmis_quiz	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
34	7	delete.kmis_quiz	Delete	Delete permission untuk module kmis_quiz	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
35	7	restore.kmis_quiz	Restore	Restore permission untuk module kmis_quiz	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
36	8	view.monev_activity	View	View permission untuk module monev_activity	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
37	8	create.monev_activity	Create	Create permission untuk module monev_activity	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
38	8	edit.monev_activity	Edit	Edit permission untuk module monev_activity	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
39	8	delete.monev_activity	Delete	Delete permission untuk module monev_activity	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
40	8	restore.monev_activity	Restore	Restore permission untuk module monev_activity	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
41	9	view.monev_verification	View	View permission untuk module monev_verification	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
42	9	create.monev_verification	Create	Create permission untuk module monev_verification	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
43	9	edit.monev_verification	Edit	Edit permission untuk module monev_verification	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
44	9	delete.monev_verification	Delete	Delete permission untuk module monev_verification	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
45	9	restore.monev_verification	Restore	Restore permission untuk module monev_verification	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
46	10	view.cms_management	View	View permission untuk module cms_management	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
47	10	create.cms_management	Create	Create permission untuk module cms_management	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
48	10	edit.cms_management	Edit	Edit permission untuk module cms_management	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
49	10	delete.cms_management	Delete	Delete permission untuk module cms_management	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
50	10	restore.cms_management	Restore	Restore permission untuk module cms_management	\N	2025-09-18 12:06:19.836814	2025-09-18 12:06:19.836814
51	11	view.master_data	View	View permission untuk module master_data	\N	2025-09-22 10:57:58.507515	2025-09-22 10:57:58.507515
52	11	create.master_data	Create	Create permission untuk module master_data	\N	2025-09-22 10:57:58.507515	2025-09-22 10:57:58.507515
53	11	edit.master_data	Edit	Edit permission untuk module master_data	\N	2025-09-22 10:57:58.507515	2025-09-22 10:57:58.507515
54	11	delete.master_data	Delete	Delete permission untuk module master_data	\N	2025-09-22 10:57:58.507515	2025-09-22 10:57:58.507515
55	11	restore.master_data	Restore	Restore permission untuk module master_data	\N	2025-09-22 10:57:58.507515	2025-09-22 10:57:58.507515
56	12	view.kmis_learning_course	View	View permission untuk module kmis_learning_course	\N	2025-10-03 14:55:04.687753	2025-10-03 14:55:04.687753
57	12	create.kmis_learning_course	Create	Create permission untuk module kmis_learning_course	\N	2025-10-03 14:55:04.687753	2025-10-03 14:55:04.687753
58	12	edit.kmis_learning_course	Edit	Edit permission untuk module kmis_learning_course	\N	2025-10-03 14:55:04.687753	2025-10-03 14:55:04.687753
59	13	create.monev_target	Create	Create permission untuk module monev_target	\N	2025-10-26 11:29:46.577852	2025-10-26 11:29:46.577852
60	13	view.monev_target	View	View permission untuk module monev_target	\N	2025-10-26 11:29:46.577852	2025-10-26 11:29:46.577852
61	13	delete.monev_target	Delete	Delete permission untuk module monev_target	\N	2025-10-26 11:29:46.577852	2025-10-26 11:29:46.577852
62	13	restore.monev_target	Restore	Restore permission untuk module monev_target	\N	2025-10-26 11:29:46.577852	2025-10-26 11:29:46.577852
63	13	edit.monev_target	Edit	Edit permission untuk module monev_target	\N	2025-10-26 11:29:46.577852	2025-10-26 11:29:46.577852
64	14	view.monev_monthly_realization	View	View permission untuk module monev_monthly_realization	\N	2025-10-26 11:29:56.810471	2025-10-26 11:29:56.810471
65	14	create.monev_monthly_realization	Create	Create permission untuk module monev_monthly_realization	\N	2025-10-26 11:29:56.810471	2025-10-26 11:29:56.810471
66	14	edit.monev_monthly_realization	Edit	Edit permission untuk module monev_monthly_realization	\N	2025-10-26 11:29:56.810471	2025-10-26 11:29:56.810471
67	14	restore.monev_monthly_realization	Restore	Restore permission untuk module monev_monthly_realization	\N	2025-10-26 11:29:56.810471	2025-10-26 11:29:56.810471
68	14	delete.monev_monthly_realization	Delete	Delete permission untuk module monev_monthly_realization	\N	2025-10-26 11:29:56.810471	2025-10-26 11:29:56.810471
69	15	edit.monev_activity_calendar	Edit	Edit permission untuk module monev_activity_calendar	\N	2025-10-26 11:30:03.615648	2025-10-26 11:30:03.615648
70	15	restore.monev_activity_calendar	Restore	Restore permission untuk module monev_activity_calendar	\N	2025-10-26 11:30:03.615648	2025-10-26 11:30:03.615648
71	15	delete.monev_activity_calendar	Delete	Delete permission untuk module monev_activity_calendar	\N	2025-10-26 11:30:03.615648	2025-10-26 11:30:03.615648
72	15	create.monev_activity_calendar	Create	Create permission untuk module monev_activity_calendar	\N	2025-10-26 11:30:03.615648	2025-10-26 11:30:03.615648
73	15	view.monev_activity_calendar	View	View permission untuk module monev_activity_calendar	\N	2025-10-26 11:30:03.615648	2025-10-26 11:30:03.615648
74	16	edit.monev_share_report	Edit	Edit permission untuk module monev_share_report	\N	2025-10-26 11:30:10.640397	2025-10-26 11:30:10.640397
75	16	delete.monev_share_report	Delete	Delete permission untuk module monev_share_report	\N	2025-10-26 11:30:10.640397	2025-10-26 11:30:10.640397
76	16	create.monev_share_report	Create	Create permission untuk module monev_share_report	\N	2025-10-26 11:30:10.640397	2025-10-26 11:30:10.640397
77	16	restore.monev_share_report	Restore	Restore permission untuk module monev_share_report	\N	2025-10-26 11:30:10.640397	2025-10-26 11:30:10.640397
78	16	view.monev_share_report	View	View permission untuk module monev_share_report	\N	2025-10-26 11:30:10.640397	2025-10-26 11:30:10.640397
79	17	create.monev_user	Create	Create permission untuk module monev_user	\N	2025-10-27 10:09:17.594351	2025-10-27 10:09:17.594351
80	17	view.monev_user	View	View permission untuk module monev_user	\N	2025-10-27 10:09:17.594351	2025-10-27 10:09:17.594351
81	17	edit.monev_user	Edit	Edit permission untuk module monev_user	\N	2025-10-27 10:09:17.594351	2025-10-27 10:09:17.594351
82	18	create.monev_dashboard	Create	Create permission untuk module monev_dashboard	\N	2025-10-31 16:00:14.571854	2025-10-31 16:00:14.571854
83	18	view.monev_dashboard	View	View permission untuk module monev_dashboard	\N	2025-10-31 16:00:14.571854	2025-10-31 16:00:14.571854
84	18	edit.monev_dashboard	Edit	Edit permission untuk module monev_dashboard	\N	2025-10-31 16:00:14.571854	2025-10-31 16:00:14.571854
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, deleted_at, created_at, updated_at, permission_ids) FROM stdin;
2	Educator	Bertanggung jawab untuk mengelola dan menyampaikan konten pendidikan kepada peserta didik.	\N	2025-10-01 00:00:00	2025-10-01 00:00:00	[1, 3, 26, 27, 28, 29, 31, 32, 33, 34, 35]
3	Monev	Bertanggung jawab untuk mengelola dan membuat fitur target	\N	2025-10-01 00:00:00	2025-10-01 00:00:00	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
4	Student	Peserta didik yang terdaftar dalam kursus dan dapat mengakses materi pembelajaran.	\N	2025-10-01 00:00:00	2025-10-01 00:00:00	[56, 57, 58]
1	Super Admin	Memiliki kontrol penuh atas sistem aplikasi Rimba, termasuk manajemen pengguna dan pengaturan sistem.	\N	2025-10-01 00:00:00	2025-10-01 00:00:00	[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84]
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, role_id, photo_profile_ids, name, email, password, phone_number, profession, gender, birth_date, address, account_status, register_at, deactivate_at, last_login, deleted_at, created_at, updated_at, last_change_password, telegram_id) FROM stdin;
33	3	[]	Monev	rezahawari19@gmail.com	$2a$12$cGPTIRWljKwJKsg1Nwt2he8XIvK3W5SKHeoAcPzIK6o75Drmre5de	\N	Monev	1	\N	\N	2	2025-10-23 20:03:13.633344	\N	2025-10-31 10:43:04.275	\N	2025-10-23 20:03:13.633344	2025-10-27 11:39:54.590725	\N	\N
2	2	[]	Educator	fatwalinovera@gmail.com	$2a$12$Glc6DxHgNkfTY9lbs/W3tu8n1qtqzjjpDVqcALAz.VzQNRqMK05ry	\N	Educator	1	\N	\N	2	2025-09-03 21:12:45.422969	\N	2025-11-27 04:04:29.338	\N	2025-09-03 21:12:45.422969	2025-11-23 08:11:18.084441	\N	\N
37	1	[]	Super Admin	superadmin@gmail.com	$2a$12$45XAcGzrpQufJmUhdBw8HuYbSQlZDqsbpKzvzhPqApbPtErd/LjBm	\N	\N	1	\N	\N	2	2025-11-02 13:29:54.325236	\N	2025-11-02 16:06:58.211	\N	2025-11-02 13:29:54.325236	2025-11-02 13:29:54.325236	\N	\N
38	3	[]	Reza	reza_hashfi@yahoo.co.id	$2b$12$EK/futUDzwaRcpsFMEoKY.UYg3ZQ9AOhbrkSNIkxFTHxI2nD8FVou	\N	\N	\N	\N	\N	2	2025-11-03 01:00:25.729304	\N	2025-11-03 07:03:30.435	\N	2025-11-03 01:00:25.729304	2025-11-03 01:00:25.729304	\N	\N
41	3	[]	Ndoo	ndocfa123@gmail.com	$2b$12$sv8y/OEjeK0poiYMGqDLv.xCBbI04olvkCkx7nSOGhp1vGVri421i	\N	\N	\N	\N	\N	2	2025-11-03 23:05:06.325304	\N	2025-11-05 03:33:53.808	\N	2025-11-03 23:05:06.325304	2025-11-03 23:05:06.325304	\N	\N
40	3	[]	sulengpol	sulengpol@gmail.com	$2b$12$iFN8Z4L9UqBMlKkeDsBrGOEWoHako5Gye9aEMkO7LVDR3xUKHkXvK	\N	\N	\N	\N	\N	2	2025-11-03 06:01:12.452802	\N	2025-11-03 07:38:42.77	\N	2025-11-03 06:01:12.452802	2025-11-03 06:01:12.452802	\N	\N
44	4	[]	Ibra	ibrafabian22@gmail.com	$2b$12$/j2VuWYbokuwnq82C.4RIO1Lmuhbl4BhPRFgwWvubkr6nnHIHW6Le	\N	\N	\N	\N	\N	2	2025-11-25 07:32:16.595139	\N	2025-11-25 10:42:45.74	\N	2025-11-25 07:32:16.595139	2025-11-25 07:32:16.595139	\N	\N
43	4	[]	Anne	anneluntungan@gmail.com	$2b$12$mawFpgTuvW.KjYH44bXpMO2GX8IFQ2y.781gGggC226ZeGcuLWDlm	\N	\N	\N	\N	\N	2	2025-11-17 07:05:41.725887	\N	2026-01-15 04:53:17.657	\N	2025-11-17 07:05:41.725887	2025-11-17 07:05:41.725887	\N	\N
36	4	[103]	Kurniaji Satrio	bytnote@gmail.com	$2b$12$qcGJFopcwV4JoWJgGLzsr.AI0UHInv1B0SyRooue29vaXKtbxZbee	\N	\N	\N	\N	\N	2	2025-11-02 03:05:32.15948	\N	2026-01-15 10:34:17.611	\N	2025-11-02 03:05:32.15948	2025-11-04 01:20:36.009065	\N	\N
3	4	[119]	Student	candhyfadhila@gmail.com	$2b$10$UCvJ4WryD9EZhjw8yLcZCeLWEQaQjlF617wmNtFdsqaavEeh1rD2u	\N	Student	1	\N	\N	2	2025-09-03 21:13:55.937998	\N	2025-12-22 15:07:56.029	\N	2025-09-03 21:13:55.937998	2025-11-13 02:17:58.83331	\N	\N
47	4	[302]	Test User	kreasiteknologikini@gmail.com	$2b$12$Q8TagEGiCRBlqTjV3c1Nle73m7fctGxp0Ob4Fv83tOeYGqhLM9ZSq	\N	\N	\N	\N	\N	2	2025-12-23 02:42:55.530961	\N	2025-12-23 02:46:16.055	\N	2025-12-23 02:42:55.530961	2025-12-23 07:25:45.165193	\N	\N
39	3	[]	Test User PIC MONEV	mapgis800@gmail.com	$2b$10$3Ha57v7VAr5qFibmDKXDKuvWLyjn1trMGwRxqM2URSCi8GMhiQpWS	\N	\N	\N	\N	\N	2	2025-11-03 01:09:30.933259	\N	2026-01-05 03:41:39.339	\N	2025-11-03 01:09:30.933259	2025-11-03 01:09:30.933259	2026-01-05 03:07:37.085984	\N
42	2	[]	Paket 6	rimbapaket6.2025@gmail.com	$2b$10$NgFgn4TLMQtnEXQzMZ1jxuK2WTpdNKKRPKYMYQTel910EBD3jZj22	\N	\N	\N	\N	\N	2	2025-11-13 02:18:49.220929	\N	2026-01-09 04:22:05.287	\N	2025-11-13 02:18:49.220929	2025-11-13 02:18:49.220929	2025-11-18 02:29:44.603112	\N
1	1	[]	Super Admin	studio.exium@gmail.com	$2b$12$ssDpb1Mo./L3.eWvdnq79OeN0eifyIQoqUP9rImA7LtaNhk5EtVWe	\N	Super Admin	\N	\N	\N	2	2025-09-03 21:05:35.826486	\N	2026-01-14 10:19:10.074	\N	2025-09-03 21:05:35.826486	2025-09-14 11:20:29.4724	\N	\N
\.


--
-- Name: activity_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.activity_logs_id_seq', 1085, true);


--
-- Name: cms_animal_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_animal_categories_id_seq', 4, true);


--
-- Name: cms_animal_composition_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_animal_composition_id_seq', 3, true);


--
-- Name: cms_contents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_contents_id_seq', 119, true);


--
-- Name: cms_events_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_events_categories_id_seq', 5, true);


--
-- Name: cms_events_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_events_id_seq', 7, true);


--
-- Name: cms_faqs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_faqs_id_seq', 3, true);


--
-- Name: cms_legal_docs_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_legal_docs_categories_id_seq', 1, true);


--
-- Name: cms_legal_documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_legal_documents_id_seq', 12, true);


--
-- Name: cms_news_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_news_categories_id_seq', 2, true);


--
-- Name: cms_news_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cms_news_id_seq', 13, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 359, true);


--
-- Name: kmis_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_categories_id_seq', 32, true);


--
-- Name: kmis_learning_attempts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_learning_attempts_id_seq', 23, true);


--
-- Name: kmis_materials_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_materials_id_seq', 131, true);


--
-- Name: kmis_quiz_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_quiz_id_seq', 33, true);


--
-- Name: kmis_quiz_responses_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_quiz_responses_id_seq', 63, true);


--
-- Name: kmis_topic_views_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_topic_views_id_seq', 828, true);


--
-- Name: kmis_topics_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.kmis_topics_id_seq', 38, true);


--
-- Name: modules_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.modules_id_seq', 18, true);


--
-- Name: monev_activity_calendar_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_activity_calendar_id_seq', 11, true);


--
-- Name: monev_activity_categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_activity_categories_id_seq', 7, true);


--
-- Name: monev_activity_packages_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_activity_packages_id_seq', 12, true);


--
-- Name: monev_dashboards_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_dashboards_id_seq', 1, true);


--
-- Name: monev_monthly_realization_pending_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_monthly_realization_pending_updates_id_seq', 7, true);


--
-- Name: monev_monthly_realizations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_monthly_realizations_id_seq', 74, true);


--
-- Name: monev_pic_divisions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_pic_divisions_id_seq', 5, true);


--
-- Name: monev_share_reports_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_share_reports_id_seq', 2, true);


--
-- Name: monev_target_pending_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_target_pending_updates_id_seq', 6, true);


--
-- Name: monev_targets_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.monev_targets_id_seq', 74, true);


--
-- Name: permissions_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.permissions_id_seq', 84, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 4, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 47, true);


--
-- Name: activity_logs activity_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_pkey PRIMARY KEY (id);


--
-- Name: cms_animal_categories cms_animal_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_animal_categories
    ADD CONSTRAINT cms_animal_categories_pkey PRIMARY KEY (id);


--
-- Name: cms_animal_composition cms_animal_composition_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_animal_composition
    ADD CONSTRAINT cms_animal_composition_pkey PRIMARY KEY (id);


--
-- Name: cms_contents cms_contents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_contents
    ADD CONSTRAINT cms_contents_pkey PRIMARY KEY (id);


--
-- Name: cms_events_categories cms_events_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_events_categories
    ADD CONSTRAINT cms_events_categories_pkey PRIMARY KEY (id);


--
-- Name: cms_events cms_events_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_events
    ADD CONSTRAINT cms_events_pkey PRIMARY KEY (id);


--
-- Name: cms_faqs cms_faqs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_faqs
    ADD CONSTRAINT cms_faqs_pkey PRIMARY KEY (id);


--
-- Name: cms_legal_docs_categories cms_legal_docs_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_legal_docs_categories
    ADD CONSTRAINT cms_legal_docs_categories_pkey PRIMARY KEY (id);


--
-- Name: cms_legal_documents cms_legal_documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_legal_documents
    ADD CONSTRAINT cms_legal_documents_pkey PRIMARY KEY (id);


--
-- Name: cms_news_categories cms_news_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_news_categories
    ADD CONSTRAINT cms_news_categories_pkey PRIMARY KEY (id);


--
-- Name: cms_news cms_news_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_news
    ADD CONSTRAINT cms_news_pkey PRIMARY KEY (id);


--
-- Name: documents documents_file_id_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_file_id_unique UNIQUE (file_id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: kmis_categories kmis_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_categories
    ADD CONSTRAINT kmis_categories_pkey PRIMARY KEY (id);


--
-- Name: kmis_learning_attempts kmis_learning_attempts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_learning_attempts
    ADD CONSTRAINT kmis_learning_attempts_pkey PRIMARY KEY (id);


--
-- Name: kmis_materials kmis_materials_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_materials
    ADD CONSTRAINT kmis_materials_pkey PRIMARY KEY (id);


--
-- Name: kmis_quiz kmis_quiz_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz
    ADD CONSTRAINT kmis_quiz_pkey PRIMARY KEY (id);


--
-- Name: kmis_quiz_responses kmis_quiz_responses_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz_responses
    ADD CONSTRAINT kmis_quiz_responses_pkey PRIMARY KEY (id);


--
-- Name: kmis_topic_views kmis_topic_views_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topic_views
    ADD CONSTRAINT kmis_topic_views_pkey PRIMARY KEY (id);


--
-- Name: kmis_topics kmis_topics_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topics
    ADD CONSTRAINT kmis_topics_pkey PRIMARY KEY (id);


--
-- Name: modules modules_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.modules
    ADD CONSTRAINT modules_pkey PRIMARY KEY (id);


--
-- Name: monev_activity_calendar monev_activity_calendar_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_calendar
    ADD CONSTRAINT monev_activity_calendar_pkey PRIMARY KEY (id);


--
-- Name: monev_activity_categories monev_activity_categories_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_categories
    ADD CONSTRAINT monev_activity_categories_pkey PRIMARY KEY (id);


--
-- Name: monev_activity_packages monev_activity_packages_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_packages
    ADD CONSTRAINT monev_activity_packages_pkey PRIMARY KEY (id);


--
-- Name: monev_dashboards monev_dashboards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_dashboards
    ADD CONSTRAINT monev_dashboards_pkey PRIMARY KEY (id);


--
-- Name: monev_monthly_realization_pending_updates monev_monthly_realization_pending_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realization_pending_updates
    ADD CONSTRAINT monev_monthly_realization_pending_updates_pkey PRIMARY KEY (id);


--
-- Name: monev_monthly_realizations monev_monthly_realizations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realizations
    ADD CONSTRAINT monev_monthly_realizations_pkey PRIMARY KEY (id);


--
-- Name: monev_pic_divisions monev_pic_divisions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_pic_divisions
    ADD CONSTRAINT monev_pic_divisions_pkey PRIMARY KEY (id);


--
-- Name: monev_share_reports monev_share_reports_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_share_reports
    ADD CONSTRAINT monev_share_reports_pkey PRIMARY KEY (id);


--
-- Name: monev_target_pending_updates monev_target_pending_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_target_pending_updates
    ADD CONSTRAINT monev_target_pending_updates_pkey PRIMARY KEY (id);


--
-- Name: monev_targets monev_targets_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_targets
    ADD CONSTRAINT monev_targets_pkey PRIMARY KEY (id);


--
-- Name: permissions permissions_key_uniq; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_key_uniq UNIQUE (key);


--
-- Name: permissions permissions_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_pkey PRIMARY KEY (id);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: kmis_topic_views uniq_topic_ip_date; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topic_views
    ADD CONSTRAINT uniq_topic_ip_date UNIQUE (kmis_topic_id, viewer_ip, view_date);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: cms_legal_docs_categories_created_at_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cms_legal_docs_categories_created_at_idx ON public.cms_legal_docs_categories USING btree (created_at);


--
-- Name: cms_legal_docs_categories_description_gin_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cms_legal_docs_categories_description_gin_idx ON public.cms_legal_docs_categories USING gin (description jsonb_path_ops);


--
-- Name: cms_legal_docs_categories_name_en_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cms_legal_docs_categories_name_en_idx ON public.cms_legal_docs_categories USING btree (lower((name ->> 'en'::text))) WHERE (deleted_at IS NULL);


--
-- Name: cms_legal_docs_categories_name_gin_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cms_legal_docs_categories_name_gin_idx ON public.cms_legal_docs_categories USING gin (name jsonb_path_ops);


--
-- Name: cms_legal_docs_categories_name_id_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX cms_legal_docs_categories_name_id_idx ON public.cms_legal_docs_categories USING btree (lower((name ->> 'id'::text))) WHERE (deleted_at IS NULL);


--
-- Name: idx_kla_attempt_by_not_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_kla_attempt_by_not_deleted ON public.kmis_learning_attempts USING btree (attempt_by) WHERE (deleted_at IS NULL);


--
-- Name: idx_kla_created_topic_not_deleted; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_kla_created_topic_not_deleted ON public.kmis_learning_attempts USING btree (created_at, kmis_topic_id) WHERE (deleted_at IS NULL);


--
-- Name: idx_kmis_learning_attempts_completed_material_ids; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_kmis_learning_attempts_completed_material_ids ON public.kmis_learning_attempts USING gin (completed_material_ids);


--
-- Name: idx_kmis_learning_attempts_kmis_topic_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_kmis_learning_attempts_kmis_topic_id ON public.kmis_learning_attempts USING btree (kmis_topic_id);


--
-- Name: idx_kmis_materials_id; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_kmis_materials_id ON public.kmis_materials USING btree (id);


--
-- Name: idx_kmis_topics_material_order_ids; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_kmis_topics_material_order_ids ON public.kmis_topics USING gin (material_order_ids);


--
-- Name: idx_mac_active_finished; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mac_active_finished ON public.monev_activity_calendar USING btree (finished_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_mac_active_started; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_mac_active_started ON public.monev_activity_calendar USING btree (started_date) WHERE (deleted_at IS NULL);


--
-- Name: idx_monev_pic_divisions_user_pic_gin; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_monev_pic_divisions_user_pic_gin ON public.monev_pic_divisions USING gin (user_pic jsonb_path_ops);


--
-- Name: idx_users_email_lower; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email_lower ON public.users USING btree (lower((email)::text));


--
-- Name: kmis_quiz_created_by_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX kmis_quiz_created_by_idx ON public.kmis_quiz USING btree (created_by);


--
-- Name: kmis_topics_user_pic_gin_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX kmis_topics_user_pic_gin_idx ON public.kmis_topics USING gin (user_pic jsonb_path_ops);


--
-- Name: permissions_key_uidx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX permissions_key_uidx ON public.permissions USING btree (lower(key)) WHERE (deleted_at IS NULL);


--
-- Name: permissions_module_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX permissions_module_idx ON public.permissions USING btree (module_id);


--
-- Name: uq_monev_real_pkg_month; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_monev_real_pkg_month ON public.monev_monthly_realizations USING btree (monev_activity_packages_id, month);


--
-- Name: uq_monev_real_pkg_ym; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_monev_real_pkg_ym ON public.monev_monthly_realizations USING btree (monev_activity_packages_id, year, month);


--
-- Name: uq_monev_targets_pkg_month; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_monev_targets_pkg_month ON public.monev_targets USING btree (monev_activity_packages_id, month);


--
-- Name: uq_monev_targets_pkg_ym; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX uq_monev_targets_pkg_ym ON public.monev_targets USING btree (monev_activity_packages_id, year, month);


--
-- Name: users_account_status_idx; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX users_account_status_idx ON public.users USING btree (account_status);


--
-- Name: activity_logs activity_logs_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.activity_logs
    ADD CONSTRAINT activity_logs_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cms_animal_composition cms_animal_composition_cms_animal_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_animal_composition
    ADD CONSTRAINT cms_animal_composition_cms_animal_category_id_fkey FOREIGN KEY (cms_animal_category_id) REFERENCES public.cms_animal_categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cms_events cms_events_cms_event_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_events
    ADD CONSTRAINT cms_events_cms_event_category_id_fkey FOREIGN KEY (cms_event_category_id) REFERENCES public.cms_events_categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: cms_legal_documents cms_legal_documents_category_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_legal_documents
    ADD CONSTRAINT cms_legal_documents_category_fk FOREIGN KEY (cms_legal_docs_categories_id) REFERENCES public.cms_legal_docs_categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: cms_news cms_news_cms_news_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cms_news
    ADD CONSTRAINT cms_news_cms_news_category_id_fkey FOREIGN KEY (cms_news_category_id) REFERENCES public.cms_news_categories(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: documents documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: documents documents_verified_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_verified_by_fkey FOREIGN KEY (verified_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: kmis_learning_attempts kmis_learning_attempts_attempt_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_learning_attempts
    ADD CONSTRAINT kmis_learning_attempts_attempt_by_fkey FOREIGN KEY (attempt_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_learning_attempts kmis_learning_attempts_kmis_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_learning_attempts
    ADD CONSTRAINT kmis_learning_attempts_kmis_topic_id_fkey FOREIGN KEY (kmis_topic_id) REFERENCES public.kmis_topics(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_materials kmis_materials_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_materials
    ADD CONSTRAINT kmis_materials_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_materials kmis_materials_kmis_topics_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_materials
    ADD CONSTRAINT kmis_materials_kmis_topics_id_fkey FOREIGN KEY (kmis_topic_id) REFERENCES public.kmis_topics(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: kmis_materials kmis_materials_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_materials
    ADD CONSTRAINT kmis_materials_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_quiz kmis_quiz_created_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz
    ADD CONSTRAINT kmis_quiz_created_by_fk FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_quiz kmis_quiz_kmis_topics_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz
    ADD CONSTRAINT kmis_quiz_kmis_topics_id_fkey FOREIGN KEY (kmis_topic_id) REFERENCES public.kmis_topics(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_quiz_responses kmis_quiz_responses_kmis_learning_attempt_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz_responses
    ADD CONSTRAINT kmis_quiz_responses_kmis_learning_attempt_id_fkey FOREIGN KEY (kmis_learning_attempt_id) REFERENCES public.kmis_learning_attempts(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: kmis_quiz_responses kmis_quiz_responses_kmis_quiz_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_quiz_responses
    ADD CONSTRAINT kmis_quiz_responses_kmis_quiz_id_fkey FOREIGN KEY (kmis_quiz_id) REFERENCES public.kmis_quiz(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: kmis_topic_views kmis_topic_views_kmis_topic_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topic_views
    ADD CONSTRAINT kmis_topic_views_kmis_topic_id_fkey FOREIGN KEY (kmis_topic_id) REFERENCES public.kmis_topics(id) ON DELETE CASCADE;


--
-- Name: kmis_topics kmis_topics_kmis_categories_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kmis_topics
    ADD CONSTRAINT kmis_topics_kmis_categories_id_fkey FOREIGN KEY (kmis_categories_id) REFERENCES public.kmis_categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: monev_monthly_realizations mmr_edited_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realizations
    ADD CONSTRAINT mmr_edited_by_fk FOREIGN KEY (edited_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: monev_monthly_realizations mmr_validate_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realizations
    ADD CONSTRAINT mmr_validate_by_fk FOREIGN KEY (validate_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: monev_activity_calendar monev_activity_calendar_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_calendar
    ADD CONSTRAINT monev_activity_calendar_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: monev_activity_calendar monev_activity_calendar_monev_activity_category_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_calendar
    ADD CONSTRAINT monev_activity_calendar_monev_activity_category_id_fkey FOREIGN KEY (monev_activity_category_id) REFERENCES public.monev_activity_categories(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: monev_activity_packages monev_activity_packages_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_packages
    ADD CONSTRAINT monev_activity_packages_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: monev_activity_packages monev_activity_packages_edited_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_packages
    ADD CONSTRAINT monev_activity_packages_edited_by_fkey FOREIGN KEY (edited_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: monev_activity_packages monev_activity_packages_monev_pic_division_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_activity_packages
    ADD CONSTRAINT monev_activity_packages_monev_pic_division_id_fkey FOREIGN KEY (monev_pic_division_id) REFERENCES public.monev_pic_divisions(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: monev_monthly_realization_pending_updates monev_monthly_realization_pen_monev_monthly_realization_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realization_pending_updates
    ADD CONSTRAINT monev_monthly_realization_pen_monev_monthly_realization_id_fkey FOREIGN KEY (monev_monthly_realization_id) REFERENCES public.monev_monthly_realizations(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: monev_monthly_realization_pending_updates monev_monthly_realization_pendi_monev_activity_packages_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realization_pending_updates
    ADD CONSTRAINT monev_monthly_realization_pendi_monev_activity_packages_id_fkey FOREIGN KEY (monev_activity_packages_id) REFERENCES public.monev_activity_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: monev_monthly_realizations monev_monthly_realizations_monev_activity_packages_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realizations
    ADD CONSTRAINT monev_monthly_realizations_monev_activity_packages_id_fkey FOREIGN KEY (monev_activity_packages_id) REFERENCES public.monev_activity_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: monev_monthly_realization_pending_updates monev_mrpu_edited_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_monthly_realization_pending_updates
    ADD CONSTRAINT monev_mrpu_edited_by_fk FOREIGN KEY (edited_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: monev_share_reports monev_share_reports_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_share_reports
    ADD CONSTRAINT monev_share_reports_uploaded_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: monev_target_pending_updates monev_target_pending_updates_monev_activity_packages_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_target_pending_updates
    ADD CONSTRAINT monev_target_pending_updates_monev_activity_packages_id_fkey FOREIGN KEY (monev_activity_packages_id) REFERENCES public.monev_activity_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: monev_target_pending_updates monev_target_pending_updates_monev_target_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_target_pending_updates
    ADD CONSTRAINT monev_target_pending_updates_monev_target_id_fkey FOREIGN KEY (monev_target_id) REFERENCES public.monev_targets(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: monev_targets monev_targets_edited_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_targets
    ADD CONSTRAINT monev_targets_edited_by_fk FOREIGN KEY (edited_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: monev_targets monev_targets_monev_activity_packages_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_targets
    ADD CONSTRAINT monev_targets_monev_activity_packages_id_fkey FOREIGN KEY (monev_activity_packages_id) REFERENCES public.monev_activity_packages(id) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: monev_targets monev_targets_validate_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_targets
    ADD CONSTRAINT monev_targets_validate_by_fk FOREIGN KEY (validate_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: monev_target_pending_updates monev_tpu_edited_by_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.monev_target_pending_updates
    ADD CONSTRAINT monev_tpu_edited_by_fk FOREIGN KEY (edited_by) REFERENCES public.users(id) ON UPDATE CASCADE ON DELETE SET NULL;


--
-- Name: permissions permissions_module_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.permissions
    ADD CONSTRAINT permissions_module_id_fkey FOREIGN KEY (module_id) REFERENCES public.modules(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: users users_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON UPDATE CASCADE ON DELETE RESTRICT;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO user_rimba;


--
-- Name: TABLE activity_logs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.activity_logs TO user_rimba;


--
-- Name: SEQUENCE activity_logs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.activity_logs_id_seq TO user_rimba;


--
-- Name: TABLE cms_animal_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_animal_categories TO user_rimba;


--
-- Name: SEQUENCE cms_animal_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_animal_categories_id_seq TO user_rimba;


--
-- Name: TABLE cms_animal_composition; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_animal_composition TO user_rimba;


--
-- Name: SEQUENCE cms_animal_composition_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_animal_composition_id_seq TO user_rimba;


--
-- Name: TABLE cms_contents; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_contents TO user_rimba;


--
-- Name: SEQUENCE cms_contents_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_contents_id_seq TO user_rimba;


--
-- Name: TABLE cms_events; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_events TO user_rimba;


--
-- Name: TABLE cms_events_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_events_categories TO user_rimba;


--
-- Name: SEQUENCE cms_events_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_events_categories_id_seq TO user_rimba;


--
-- Name: SEQUENCE cms_events_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_events_id_seq TO user_rimba;


--
-- Name: TABLE cms_faqs; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_faqs TO user_rimba;


--
-- Name: SEQUENCE cms_faqs_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_faqs_id_seq TO user_rimba;


--
-- Name: TABLE cms_legal_docs_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_legal_docs_categories TO user_rimba;


--
-- Name: SEQUENCE cms_legal_docs_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.cms_legal_docs_categories_id_seq TO user_rimba;


--
-- Name: TABLE cms_legal_documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_legal_documents TO user_rimba;


--
-- Name: SEQUENCE cms_legal_documents_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_legal_documents_id_seq TO user_rimba;


--
-- Name: TABLE cms_news; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_news TO user_rimba;


--
-- Name: TABLE cms_news_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.cms_news_categories TO user_rimba;


--
-- Name: SEQUENCE cms_news_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_news_categories_id_seq TO user_rimba;


--
-- Name: SEQUENCE cms_news_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.cms_news_id_seq TO user_rimba;


--
-- Name: TABLE documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.documents TO user_rimba;


--
-- Name: SEQUENCE documents_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.documents_id_seq TO user_rimba;


--
-- Name: TABLE kmis_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_categories TO user_rimba;


--
-- Name: SEQUENCE kmis_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_categories_id_seq TO user_rimba;


--
-- Name: TABLE kmis_learning_attempts; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_learning_attempts TO user_rimba;


--
-- Name: SEQUENCE kmis_learning_attempts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_learning_attempts_id_seq TO user_rimba;


--
-- Name: TABLE kmis_materials; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_materials TO user_rimba;


--
-- Name: SEQUENCE kmis_materials_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_materials_id_seq TO user_rimba;


--
-- Name: TABLE kmis_quiz; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_quiz TO user_rimba;


--
-- Name: SEQUENCE kmis_quiz_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_quiz_id_seq TO user_rimba;


--
-- Name: TABLE kmis_quiz_responses; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_quiz_responses TO user_rimba;


--
-- Name: SEQUENCE kmis_quiz_responses_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_quiz_responses_id_seq TO user_rimba;


--
-- Name: TABLE kmis_topic_views; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_topic_views TO user_rimba;


--
-- Name: SEQUENCE kmis_topic_views_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_topic_views_id_seq TO user_rimba;


--
-- Name: TABLE kmis_topics; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.kmis_topics TO user_rimba;


--
-- Name: SEQUENCE kmis_topics_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.kmis_topics_id_seq TO user_rimba;


--
-- Name: TABLE modules; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.modules TO user_rimba;


--
-- Name: SEQUENCE modules_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.modules_id_seq TO user_rimba;


--
-- Name: TABLE monev_activity_calendar; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_activity_calendar TO user_rimba;


--
-- Name: SEQUENCE monev_activity_calendar_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_activity_calendar_id_seq TO user_rimba;


--
-- Name: TABLE monev_activity_categories; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_activity_categories TO user_rimba;


--
-- Name: SEQUENCE monev_activity_categories_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_activity_categories_id_seq TO user_rimba;


--
-- Name: TABLE monev_activity_packages; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_activity_packages TO user_rimba;


--
-- Name: SEQUENCE monev_activity_packages_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_activity_packages_id_seq TO user_rimba;


--
-- Name: TABLE monev_dashboards; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_dashboards TO user_rimba;


--
-- Name: SEQUENCE monev_dashboards_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_dashboards_id_seq TO user_rimba;


--
-- Name: TABLE monev_monthly_realization_pending_updates; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_monthly_realization_pending_updates TO user_rimba;


--
-- Name: SEQUENCE monev_monthly_realization_pending_updates_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_monthly_realization_pending_updates_id_seq TO user_rimba;


--
-- Name: TABLE monev_monthly_realizations; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_monthly_realizations TO user_rimba;


--
-- Name: SEQUENCE monev_monthly_realizations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_monthly_realizations_id_seq TO user_rimba;


--
-- Name: TABLE monev_pic_divisions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_pic_divisions TO user_rimba;


--
-- Name: SEQUENCE monev_pic_divisions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_pic_divisions_id_seq TO user_rimba;


--
-- Name: TABLE monev_share_reports; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_share_reports TO user_rimba;


--
-- Name: SEQUENCE monev_share_reports_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_share_reports_id_seq TO user_rimba;


--
-- Name: TABLE monev_target_pending_updates; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_target_pending_updates TO user_rimba;


--
-- Name: SEQUENCE monev_target_pending_updates_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_target_pending_updates_id_seq TO user_rimba;


--
-- Name: TABLE monev_targets; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.monev_targets TO user_rimba;


--
-- Name: SEQUENCE monev_targets_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.monev_targets_id_seq TO user_rimba;


--
-- Name: TABLE permissions; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.permissions TO user_rimba;


--
-- Name: SEQUENCE permissions_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.permissions_id_seq TO user_rimba;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.roles TO user_rimba;


--
-- Name: SEQUENCE roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.roles_id_seq TO user_rimba;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.users TO user_rimba;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,USAGE ON SEQUENCE public.users_id_seq TO user_rimba;


--
-- PostgreSQL database dump complete
--

\unrestrict ccTjMF15zOjQb8yUnuLJFtjUvjnIGPq38WOlpBxKlwNb9uX06ilxQ4sAflemHq6

