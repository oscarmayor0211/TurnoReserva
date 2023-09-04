--
-- PostgreSQL database dump
--

-- Dumped by pg_dump version 15.3


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
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: postgres
--

-- *not* creating schema, since initdb creates it


ALTER SCHEMA public OWNER TO postgres;

--
-- TOC entry 226 (class 1255 OID 16453)
-- Name: pl_generate_appointments(date, date, integer); Type: FUNCTION; Schema: public; Owner: postgres
--
--funcion para seleccionar turnos desde una fecha de inicio hasta una final
CREATE FUNCTION public.pl_generate_appointments(start_date date, end_date date, service_code integer) RETURNS smallint
    LANGUAGE plpgsql
    AS $$
--declaro variables
DECLARE
		current_shift timestamp;
		final_shift timestamp;
		selected_service services%ROWTYPE;
BEGIN
	--La declaración RAISE NOTICE nos dara el valor de las fechas
	RAISE NOTICE 'Start Date is %', start_date;
	RAISE NOTICE 'End Date is %', end_date;
	
	--obtener el servicio por el ID
	SELECT *
	FROM public.services 
	INTO selected_service
	WHERE service_id = service_code;
	
	raise notice 'Service Start time is %', selected_service.start_time;
	raise notice 'Service End time is %', selected_service.end_time;
	
	--Generar la fecha de inicio con la hora y la de final con la hora
	current_shift = start_date || ' ' || selected_service.start_time;
	final_shift = end_date || ' ' || selected_service.end_time;
	
	raise notice 'Shift starts at %', current_shift;
	raise notice 'Shift Should end at %', final_shift;
	
	--mientras la fecha actual sea menor a la final, agregar a la tabla
	WHILE current_shift < final_shift LOOP
		
		BEGIN
		
			--si la hora del turno actual esta dentro de las horas del servicio, insertar
			IF extract(HOUR FROM current_shift) >= extract(hour from selected_service.start_time) 
				AND extract(HOUR FROM current_shift) < extract(hour from selected_service.end_time) THEN
					RAISE NOTICE 'If block to check time %', extract(HOUR FROM current_shift);
				
					--insertar en la tabla de turnos
					INSERT INTO public.appointment(service_id, start_time, end_time, status) 
					VALUES (
					selected_service.service_id, 
					current_shift, 
					current_shift + (selected_service.min_duration * INTERVAL '1 minute'),
					'UNASSIGNED'
				);
			END IF;
			 
			RAISE NOTICE 'Current iteration is %', current_shift;
			
			--acá modificar el turno actual agregando segun el numero de minutos del servicio
			current_shift = current_shift + (selected_service.min_duration * INTERVAL '1 minute');
			
		END;
		
	END LOOP;
	
	return 1;
END;
$$;


ALTER FUNCTION public.pl_generate_appointments(start_date date, end_date date, service_code integer) OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 210 (class 1259 OID 16428)
-- Name: commerce; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.commerce (
    commerce_id bigint NOT NULL,
    commerce_name character varying(255) NOT NULL,
    max_capacity integer DEFAULT 1
);


ALTER TABLE public.commerce OWNER TO postgres;

--
-- TOC entry 209 (class 1259 OID 16427)
-- Name: Commerce_commerce_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public."Commerce_commerce_id_seq"
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public."Commerce_commerce_id_seq" OWNER TO postgres;

--
-- TOC entry 3342 (class 0 OID 0)
-- Dependencies: 209
-- Name: Commerce_commerce_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public."Commerce_commerce_id_seq" OWNED BY public.commerce.commerce_id;


--
-- TOC entry 214 (class 1259 OID 16456)
-- Name: appointment; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.appointment (
    appointment_id bigint NOT NULL,
    service_id bigint NOT NULL,
    start_time timestamp(6) without time zone DEFAULT now(),
    end_time timestamp(6) without time zone,
    status character varying(255)
);


ALTER TABLE public.appointment OWNER TO postgres;

--
-- TOC entry 213 (class 1259 OID 16455)
-- Name: appointment_appointment_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.appointment_appointment_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.appointment_appointment_id_seq OWNER TO postgres;

--
-- TOC entry 3343 (class 0 OID 0)
-- Dependencies: 213
-- Name: appointment_appointment_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.appointment_appointment_id_seq OWNED BY public.appointment.appointment_id;


--
-- TOC entry 212 (class 1259 OID 16436)
-- Name: services; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.services (
    service_id bigint NOT NULL,
    commerce_id bigint NOT NULL,
    service_name character varying(255),
    start_time time without time zone,
    end_time time without time zone,
    min_duration smallint
);


ALTER TABLE public.services OWNER TO postgres;

--
-- TOC entry 211 (class 1259 OID 16435)
-- Name: services_service_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.services_service_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.services_service_id_seq OWNER TO postgres;

--
-- TOC entry 3344 (class 0 OID 0)
-- Dependencies: 211
-- Name: services_service_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.services_service_id_seq OWNED BY public.services.service_id;


--
-- TOC entry 3181 (class 2604 OID 16476)
-- Name: appointment appointment_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment ALTER COLUMN appointment_id SET DEFAULT nextval('public.appointment_appointment_id_seq'::regclass);


--
-- TOC entry 3178 (class 2604 OID 16484)
-- Name: commerce commerce_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commerce ALTER COLUMN commerce_id SET DEFAULT nextval('public."Commerce_commerce_id_seq"'::regclass);


--
-- TOC entry 3180 (class 2604 OID 16501)
-- Name: services service_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services ALTER COLUMN service_id SET DEFAULT nextval('public.services_service_id_seq'::regclass);


--
-- TOC entry 3335 (class 0 OID 16456)
-- Dependencies: 214
-- Data for Name: appointment; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.appointment VALUES (1, 1, '2023-09-16 09:00:00', '2023-09-16 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (2, 1, '2023-09-16 09:30:00', '2023-09-16 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (3, 1, '2023-09-16 10:00:00', '2023-09-16 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (4, 1, '2023-09-16 10:30:00', '2023-09-16 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (5, 1, '2023-09-16 11:00:00', '2023-09-16 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (6, 1, '2023-09-16 11:30:00', '2023-09-16 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (7, 1, '2023-09-16 12:00:00', '2023-09-16 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (8, 1, '2023-09-16 12:30:00', '2023-09-16 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (9, 1, '2023-09-16 13:00:00', '2023-09-16 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (10, 1, '2023-09-16 13:30:00', '2023-09-16 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (11, 1, '2023-09-16 14:00:00', '2023-09-16 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (12, 1, '2023-09-16 14:30:00', '2023-09-16 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (13, 1, '2023-09-16 15:00:00', '2023-09-16 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (14, 1, '2023-09-16 15:30:00', '2023-09-16 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (15, 1, '2023-09-16 16:00:00', '2023-09-16 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (16, 1, '2023-09-16 16:30:00', '2023-09-16 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (19, 1, '2023-09-17 10:00:00', '2023-09-17 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (20, 1, '2023-09-17 10:30:00', '2023-09-17 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (21, 1, '2023-09-17 11:00:00', '2023-09-17 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (22, 1, '2023-09-17 11:30:00', '2023-09-17 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (23, 1, '2023-09-17 12:00:00', '2023-09-17 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (24, 1, '2023-09-17 12:30:00', '2023-09-17 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (25, 1, '2023-09-17 13:00:00', '2023-09-17 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (26, 1, '2023-09-17 13:30:00', '2023-09-17 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (27, 1, '2023-09-17 14:00:00', '2023-09-17 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (28, 1, '2023-09-17 14:30:00', '2023-09-17 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (29, 1, '2023-09-17 15:00:00', '2023-09-17 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (30, 1, '2023-09-17 15:30:00', '2023-09-17 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (31, 1, '2023-09-17 16:00:00', '2023-09-17 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (32, 1, '2023-09-17 16:30:00', '2023-09-17 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (33, 1, '2023-09-18 09:00:00', '2023-09-18 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (34, 1, '2023-09-18 09:30:00', '2023-09-18 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (35, 1, '2023-09-18 10:00:00', '2023-09-18 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (36, 1, '2023-09-18 10:30:00', '2023-09-18 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (37, 1, '2023-09-18 11:00:00', '2023-09-18 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (38, 1, '2023-09-18 11:30:00', '2023-09-18 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (39, 1, '2023-09-18 12:00:00', '2023-09-18 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (40, 1, '2023-09-18 12:30:00', '2023-09-18 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (41, 1, '2023-09-18 13:00:00', '2023-09-18 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (42, 1, '2023-09-18 13:30:00', '2023-09-18 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (43, 1, '2023-09-18 14:00:00', '2023-09-18 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (44, 1, '2023-09-18 14:30:00', '2023-09-18 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (45, 1, '2023-09-18 15:00:00', '2023-09-18 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (46, 1, '2023-09-18 15:30:00', '2023-09-18 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (47, 1, '2023-09-18 16:00:00', '2023-09-18 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (48, 1, '2023-09-18 16:30:00', '2023-09-18 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (49, 1, '2023-09-19 09:00:00', '2023-09-19 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (50, 1, '2023-09-19 09:30:00', '2023-09-19 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (51, 1, '2023-09-19 10:00:00', '2023-09-19 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (52, 1, '2023-09-19 10:30:00', '2023-09-19 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (53, 1, '2023-09-19 11:00:00', '2023-09-19 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (54, 1, '2023-09-19 11:30:00', '2023-09-19 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (55, 1, '2023-09-19 12:00:00', '2023-09-19 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (56, 1, '2023-09-19 12:30:00', '2023-09-19 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (57, 1, '2023-09-19 13:00:00', '2023-09-19 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (58, 1, '2023-09-19 13:30:00', '2023-09-19 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (59, 1, '2023-09-19 14:00:00', '2023-09-19 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (60, 1, '2023-09-19 14:30:00', '2023-09-19 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (61, 1, '2023-09-19 15:00:00', '2023-09-19 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (62, 1, '2023-09-19 15:30:00', '2023-09-19 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (63, 1, '2023-09-19 16:00:00', '2023-09-19 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (64, 1, '2023-09-19 16:30:00', '2023-09-19 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (65, 1, '2023-09-20 09:00:00', '2023-09-20 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (66, 1, '2023-09-20 09:30:00', '2023-09-20 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (67, 1, '2023-09-20 10:00:00', '2023-09-20 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (68, 1, '2023-09-20 10:30:00', '2023-09-20 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (69, 1, '2023-09-20 11:00:00', '2023-09-20 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (70, 1, '2023-09-20 11:30:00', '2023-09-20 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (71, 1, '2023-09-20 12:00:00', '2023-09-20 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (72, 1, '2023-09-20 12:30:00', '2023-09-20 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (73, 1, '2023-09-20 13:00:00', '2023-09-20 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (74, 1, '2023-09-20 13:30:00', '2023-09-20 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (75, 1, '2023-09-20 14:00:00', '2023-09-20 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (76, 1, '2023-09-20 14:30:00', '2023-09-20 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (77, 1, '2023-09-20 15:00:00', '2023-09-20 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (78, 1, '2023-09-20 15:30:00', '2023-09-20 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (79, 1, '2023-09-20 16:00:00', '2023-09-20 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (80, 1, '2023-09-20 16:30:00', '2023-09-20 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (81, 1, '2023-09-21 09:00:00', '2023-09-21 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (82, 1, '2023-09-21 09:30:00', '2023-09-21 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (83, 1, '2023-09-21 10:00:00', '2023-09-21 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (84, 1, '2023-09-21 10:30:00', '2023-09-21 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (85, 1, '2023-09-21 11:00:00', '2023-09-21 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (86, 1, '2023-09-21 11:30:00', '2023-09-21 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (87, 1, '2023-09-21 12:00:00', '2023-09-21 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (88, 1, '2023-09-21 12:30:00', '2023-09-21 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (89, 1, '2023-09-21 13:00:00', '2023-09-21 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (90, 1, '2023-09-21 13:30:00', '2023-09-21 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (91, 1, '2023-09-21 14:00:00', '2023-09-21 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (92, 1, '2023-09-21 14:30:00', '2023-09-21 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (93, 1, '2023-09-21 15:00:00', '2023-09-21 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (94, 1, '2023-09-21 15:30:00', '2023-09-21 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (95, 1, '2023-09-21 16:00:00', '2023-09-21 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (96, 1, '2023-09-21 16:30:00', '2023-09-21 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (97, 1, '2023-09-22 09:00:00', '2023-09-22 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (98, 1, '2023-09-22 09:30:00', '2023-09-22 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (99, 1, '2023-09-22 10:00:00', '2023-09-22 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (100, 1, '2023-09-22 10:30:00', '2023-09-22 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (101, 1, '2023-09-22 11:00:00', '2023-09-22 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (102, 1, '2023-09-22 11:30:00', '2023-09-22 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (103, 1, '2023-09-22 12:00:00', '2023-09-22 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (104, 1, '2023-09-22 12:30:00', '2023-09-22 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (105, 1, '2023-09-22 13:00:00', '2023-09-22 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (106, 1, '2023-09-22 13:30:00', '2023-09-22 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (107, 1, '2023-09-22 14:00:00', '2023-09-22 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (18, 1, '2023-09-17 09:30:00', '2023-09-17 10:00:00', 'CONFIRMED');
INSERT INTO public.appointment VALUES (108, 1, '2023-09-22 14:30:00', '2023-09-22 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (109, 1, '2023-09-22 15:00:00', '2023-09-22 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (110, 1, '2023-09-22 15:30:00', '2023-09-22 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (111, 1, '2023-09-22 16:00:00', '2023-09-22 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (112, 1, '2023-09-22 16:30:00', '2023-09-22 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (113, 1, '2023-09-23 09:00:00', '2023-09-23 09:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (114, 1, '2023-09-23 09:30:00', '2023-09-23 10:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (115, 1, '2023-09-23 10:00:00', '2023-09-23 10:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (116, 1, '2023-09-23 10:30:00', '2023-09-23 11:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (117, 1, '2023-09-23 11:00:00', '2023-09-23 11:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (118, 1, '2023-09-23 11:30:00', '2023-09-23 12:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (119, 1, '2023-09-23 12:00:00', '2023-09-23 12:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (120, 1, '2023-09-23 12:30:00', '2023-09-23 13:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (121, 1, '2023-09-23 13:00:00', '2023-09-23 13:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (122, 1, '2023-09-23 13:30:00', '2023-09-23 14:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (123, 1, '2023-09-23 14:00:00', '2023-09-23 14:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (124, 1, '2023-09-23 14:30:00', '2023-09-23 15:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (125, 1, '2023-09-23 15:00:00', '2023-09-23 15:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (126, 1, '2023-09-23 15:30:00', '2023-09-23 16:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (127, 1, '2023-09-23 16:00:00', '2023-09-23 16:30:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (128, 1, '2023-09-23 16:30:00', '2023-09-23 17:00:00', 'UNASSIGNED');
INSERT INTO public.appointment VALUES (17, 1, '2023-09-17 09:00:00', '2023-09-17 09:30:00', 'CONFIRMED');


--
-- TOC entry 3331 (class 0 OID 16428)
-- Dependencies: 210
-- Data for Name: commerce; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.commerce VALUES (1, 'CLARO', 100);
INSERT INTO public.commerce VALUES (3, 'TIGO', 100);
INSERT INTO public.commerce VALUES (2, 'TELEFONICA MOVISTAR', 100);


--
-- TOC entry 3333 (class 0 OID 16436)
-- Dependencies: 212
-- Data for Name: services; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO public.services VALUES (1, 1, 'CLARO - QUEJAS Y RECLAMOS', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (2, 1, 'CLARO - PORTABILIDAD NUMERICA', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (3, 1, 'CLARO - OTROS SERVICIOS', '09:00:00', '17:00:00', 15);
INSERT INTO public.services VALUES (4, 2, 'MOVISTAR - QUEJAS Y RECLAMOS', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (5, 2, 'MOVISTAR - PORTABILIDAD NUMERICA', '09:00:00', '17:00:00', 15);
INSERT INTO public.services VALUES (6, 2, 'MOVISTAR - SERVICIOS FIJOS', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (7, 3, 'ATENCION GENERAL', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (8, 3, 'QUEJAS Y RECLAMOS', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (9, 3, 'SERVICIOS FIJOS', '09:00:00', '17:00:00', 30);
INSERT INTO public.services VALUES (10, 3, 'OTROS SERVICIOS', '09:00:00', '17:00:00', 30);


--
-- TOC entry 3345 (class 0 OID 0)
-- Dependencies: 209
-- Name: Commerce_commerce_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public."Commerce_commerce_id_seq"', 3, true);


--
-- TOC entry 3346 (class 0 OID 0)
-- Dependencies: 213
-- Name: appointment_appointment_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.appointment_appointment_id_seq', 128, true);


--
-- TOC entry 3347 (class 0 OID 0)
-- Dependencies: 211
-- Name: services_service_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.services_service_id_seq', 10, true);


--
-- TOC entry 3184 (class 2606 OID 16486)
-- Name: commerce Commerce_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.commerce
    ADD CONSTRAINT "Commerce_pkey" PRIMARY KEY (commerce_id);


--
-- TOC entry 3188 (class 2606 OID 16478)
-- Name: appointment appointment_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT appointment_pkey PRIMARY KEY (appointment_id);


--
-- TOC entry 3186 (class 2606 OID 16503)
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (service_id);


--
-- TOC entry 3190 (class 2606 OID 16524)
-- Name: appointment fk5ixajc1q1xjyvjnqiasyjuqqx; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.appointment
    ADD CONSTRAINT fk5ixajc1q1xjyvjnqiasyjuqqx FOREIGN KEY (service_id) REFERENCES public.services(service_id);


--
-- TOC entry 3189 (class 2606 OID 16508)
-- Name: services services_commerce_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_commerce_id_fkey FOREIGN KEY (commerce_id) REFERENCES public.commerce(commerce_id);


--
-- TOC entry 3341 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE USAGE ON SCHEMA public FROM PUBLIC;
GRANT ALL ON SCHEMA public TO PUBLIC;


-- Completed on 2023-08-17 13:54:04 -05

--
-- PostgreSQL database dump complete
--