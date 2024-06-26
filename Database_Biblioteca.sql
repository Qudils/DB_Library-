/* sequenza di auto increment per l'id del fornitore */
CREATE SEQUENCE AUTO_INCREMENT_ID_FORNITORE
START WITH 1
INCREMENT BY 1;

CREATE TABLE FORNITORE
(
    ID_FORNITORE                    number (3, 0),
    NUMERO_TELEFONO_FORNITORE       varchar(10)   UNIQUE NOT NULL,

    CONSTRAINT PRIMARY_KEY_FORNITORE           PRIMARY KEY (ID_FORNITORE),
    CONSTRAINT CHECK_NUMERO_TELEFONO_FORNITORE CHECK       (REGEXP_LIKE(NUMERO_TELEFONO_FORNITORE, '^[0-9]{9,10}+$'))
);

CREATE TABLE BIBLIOTECARIO
(
    NUMERO_MATRICOLA              char   (8),
    NOME_BIBLIOTECARIO            varchar(20)    NOT NULL,
    COGNOME_BIBLIOTECARIO         varchar(20)    NOT NULL,
    DATA_NASCITA_BIBLIOTECARIO    date           NOT NULL,
    NUMERO_TELEFONO_BIBLIOTECARIO varchar(10)    UNIQUE NOT NULL,

    CONSTRAINT PRIMARY_KEY_BIBLIOTECARIO           PRIMARY KEY (NUMERO_MATRICOLA),
    CONSTRAINT CHECK_MATRICOLA                     CHECK       (REGEXP_LIKE(NUMERO_MATRICOLA, '^[0-9]{8}+$')),
    CONSTRAINT CHECK_NOME_BIBLIOTECARIO            CHECK       (REGEXP_LIKE(NOME_BIBLIOTECARIO, '^[A-Za-z ]+$')),
    CONSTRAINT CHECK_COGNOME_BIBLIOTECARIO         CHECK       (REGEXP_LIKE(COGNOME_BIBLIOTECARIO, '^[A-Za-z ]+$')),
    CONSTRAINT CHECK_NUMERO_TELEFONO_BIBLIOTECARIO CHECK       (REGEXP_LIKE(NUMERO_TELEFONO_BIBLIOTECARIO, '^[0-9]{9,10}+$'))
);

CREATE TABLE CLIENTE
(
    CODICE_FISCALE_CLIENTE          char   (16),
    DATA_NASCITA_CLIENTE            date            NOT NULL,
    NOME_CLIENTE                    varchar(20)     NOT NULL,
    COGNOME_CLIENTE                 varchar(20)     NOT NULL,
    EMAIL_CLIENTE                   varchar(30)     UNIQUE NOT NULL,

    CONSTRAINT PRIMARY_KEY_CLIENTE          PRIMARY KEY (CODICE_FISCALE_CLIENTE),
    CONSTRAINT CHECK_CODICE_FISCALE_CLIENTE CHECK       (REGEXP_LIKE(CODICE_FISCALE_CLIENTE, '^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$')),
    CONSTRAINT CHECK_NOME_CLIENTE           CHECK       (REGEXP_LIKE(NOME_CLIENTE, '^[A-Za-z]+$')),
    CONSTRAINT CHECK_COGNOME_CLIENTE        CHECK       (REGEXP_LIKE(COGNOME_CLIENTE, '^[A-Za-z ]+$')),
    CONSTRAINT CHECK_EMAIL_CLIENTE          CHECK       (EMAIL_CLIENTE LIKE '%@%.%' AND EMAIL_CLIENTE NOT LIKE '@%' AND EMAIL_CLIENTE NOT LIKE '%@%@%')
);

CREATE TABLE EVENTO
(
    DATA_E_ORA_EVENTO       date,
    DURATA_EVENTO           number(5, 2)      NOT NULL,
    NOME_EVENTO             varchar(40)       NOT NULL,

    CONSTRAINT PRIMARY_KEY_EVENTO  PRIMARY KEY (DATA_E_ORA_EVENTO),
    CONSTRAINT CHECK_DURATA_EVENTO CHECK       (DURATA_EVENTO IN (1, 1.30, 2)),
    CONSTRAINT CHECK_NOME_EVENTO   CHECK       (REGEXP_LIKE(NOME_EVENTO, '^[A-Za-z ]+$')),
    CONSTRAINT CHECK_INIZIO_EVENTO CHECK       (TO_CHAR(DATA_E_ORA_EVENTO, 'HH24') BETWEEN 8 AND 17),
    CONSTRAINT CHECK_FINE_EVENTO   CHECK       (TO_NUMBER(TO_CHAR(DATA_E_ORA_EVENTO, 'HH24')) * 60 + TO_NUMBER(TO_CHAR(DATA_E_ORA_EVENTO, 'MI')) + DURATA_EVENTO * 60 <= 1140),
    CONSTRAINT CHECK_GIORNO_EVENTO CHECK       (TO_CHAR(DATA_E_ORA_EVENTO, 'D') BETWEEN 1 AND 5)
);

CREATE UNIQUE INDEX DATA_EVENTO_UNIVOCA ON EVENTO (TRUNC(DATA_E_ORA_EVENTO));

CREATE TABLE SCAFFALE
(
    NUMERO_PIANO           number (1, 0),
    CATEGORIA_SCAFFALE     varchar(20),
    DATA_ACQUISTO_SCAFFALE date               NOT NULL,

    CONSTRAINT PRIMARY_KEY_SCAFFALE     PRIMARY KEY (NUMERO_PIANO, CATEGORIA_SCAFFALE),
    CONSTRAINT CHECK_PIANO_SCAFFALE     CHECK       (NUMERO_PIANO IN (1, 2, 3)),
    CONSTRAINT CHECK_CATEGORIA_SCAFFALE CHECK       (LOWER(CATEGORIA_SCAFFALE) IN ('storia', 'letteratura', 'geografia', 'fantasy', 'scienze', 'giallo', 'romanzo', 'matematica', 'horror'))
);

CREATE TABLE AUTORE
(
    ISNI             char(16),
    NOME_AUTORE      varchar(20)    NOT NULL,
    COGNOME_AUTORE   varchar(20)    NOT NULL,

    CONSTRAINT PRIMARY_KEY_AUTORE   PRIMARY KEY (ISNI),
    CONSTRAINT CHECK_ISNI           CHECK       (REGEXP_LIKE(ISNI, '^[0-9]{16}+$')),
    CONSTRAINT CHECK_NOME_AUTORE    CHECK       (REGEXP_LIKE(NOME_AUTORE, '^[A-Za-z]+$')),
    CONSTRAINT CHECK_COGNOME_AUTORE CHECK       (REGEXP_LIKE(COGNOME_AUTORE, '^[A-Za-z ]+$'))
);

CREATE TABLE LIBRO
(
    ISBN                     char   (13),
    TITOLO                   varchar(30)     NOT NULL,
    ANNO_PUBBLICAZIONE       number (4, 0)   NOT NULL,
    GENERE                   varchar(20)     NOT NULL,

    CONSTRAINT PRIMARY_KEY_LIBRO  PRIMARY KEY (ISBN),
    CONSTRAINT CHECK_ISBN_LIBRO   CHECK       (REGEXP_LIKE(ISBN, '^[0-9]{13}+$')),
    CONSTRAINT CHECK_GENERE_LIBRO CHECK       (LOWER(GENERE) IN ('storia', 'letteratura', 'geografia', 'fantasy', 'scienze', 'giallo', 'romanzo', 'matematica', 'horror'))
);

/* sequenza di auto increment per la chiave esterna di casa editrice e donatore */
CREATE SEQUENCE AUTO_INCREMENT_ID_CASA_DONATORE
START WITH 1
INCREMENT BY 1;

CREATE TABLE CASA_EDITRICE
(
    PARTITA_IVA           char   (11),
    NOME_CASA_EDITRICE    varchar(30)        UNIQUE NOT NULL,
    ID_FORNITORE          number (3, 0)      UNIQUE NOT NULL,

    CONSTRAINT PRIMARY_KEY_CASA_EDITRICE PRIMARY KEY (PARTITA_IVA),
    CONSTRAINT FOREIGN_KEY_CASA_EDITRICE FOREIGN KEY (ID_FORNITORE) REFERENCES FORNITORE (ID_FORNITORE),
    CONSTRAINT CHECK_PARTITA_IVA         CHECK       (REGEXP_LIKE(PARTITA_IVA, '^[0-9]{11}+$'))
);

CREATE TABLE DONATORE
(
    CODICE_FISCALE_DONATORE     char   (16),
    NOME_DONATORE               varchar(20)     NOT NULL,
    COGNOME_DONATORE            varchar(20),
    ID_FORNITORE                number (3, 0)   UNIQUE NOT NULL,

    CONSTRAINT PRIMARY_KEY_DONATORE          PRIMARY KEY (CODICE_FISCALE_DONATORE),
    CONSTRAINT FOREIGN_KEY_DONATORE          FOREIGN KEY (ID_FORNITORE) REFERENCES FORNITORE (ID_FORNITORE),
    CONSTRAINT CHECK_CODICE_FISCALE_DONATORE CHECK       (REGEXP_LIKE(CODICE_FISCALE_DONATORE, '^[A-Z]{6}\d{2}[A-Z]\d{2}[A-Z]\d{3}[A-Z]$')),
    CONSTRAINT CHECK_NOME_DONATORE           CHECK       (REGEXP_LIKE(NOME_DONATORE, '^[A-Za-z]+$')),
    CONSTRAINT CHECK_COGNOME_DONATORE        CHECK       (REGEXP_LIKE(COGNOME_DONATORE, '^[A-Za-z ]+$'))
);

CREATE TABLE TURNO
(
    NUMERO_MATRICOLA   char(8),
    DATA_E_ORA_TURNO   date,
    DURATA_TURNO       number(1, 0) NOT NULL,

    CONSTRAINT PRIMARY_KEY_TURNO  PRIMARY KEY (NUMERO_MATRICOLA, DATA_E_ORA_TURNO),
    CONSTRAINT FOREIGN_KEY_TURNO  FOREIGN KEY (NUMERO_MATRICOLA) REFERENCES BIBLIOTECARIO (NUMERO_MATRICOLA),
    CONSTRAINT CHECK_DURATA_TURNO CHECK       (DURATA_TURNO BETWEEN 4 AND 8),
    CONSTRAINT CHECK_INIZIO_TURNO CHECK       (TO_CHAR(DATA_E_ORA_TURNO, 'HH24') BETWEEN 8 AND 16),
    CONSTRAINT CHECK_FINE_TURNO   CHECK       (TO_NUMBER(TO_CHAR(DATA_E_ORA_TURNO, 'HH24')) * 60 + TO_NUMBER(TO_CHAR(DATA_E_ORA_TURNO, 'MI')) + DURATA_TURNO * 60 <= 1200),
    CONSTRAINT CHECK_GIORNO_TURNO CHECK       (TO_CHAR(DATA_E_ORA_TURNO, 'D') BETWEEN 1 AND 5)   
);

CREATE UNIQUE INDEX DATA_TURNO_UNIVOCA ON TURNO (NUMERO_MATRICOLA, TRUNC(DATA_E_ORA_TURNO));

CREATE TABLE REGISTRAZIONE
(
    NUMERO_TESSERA                char(8),
    DATA_REGISTRAZIONE            date            NOT NULL,
    DATA_SCADENZA_TESSERA         date            NOT NULL,
    CODICE_FISCALE_CLIENTE		  char(16)	      UNIQUE NOT NULL,

    CONSTRAINT PRIMARY_KEY_REGISTRAZIONE          PRIMARY KEY (NUMERO_TESSERA),
    CONSTRAINT FOREIGN_KEY_REGISTRAZIONE          FOREIGN KEY (CODICE_FISCALE_CLIENTE) REFERENCES CLIENTE (CODICE_FISCALE_CLIENTE),
    CONSTRAINT CHECK_NUMERO_TESSERA_REGISTRAZIONE CHECK       (REGEXP_LIKE(NUMERO_TESSERA, '^[0-9]{8}+$')),
    CONSTRAINT CHECK_SCADENZA_REGISTRAZIONE       CHECK       (DATA_SCADENZA_TESSERA > DATA_REGISTRAZIONE)
);

/* sequenza di auto increment per il numero della multa */
CREATE SEQUENCE AUTO_INCREMENT_NUMERO_MULTA
START WITH 1
INCREMENT BY 1;

CREATE TABLE MULTA
(
    IUV                  char(20),
    NUMERO_TESSERA       char  (8),
    DATA_PAGAMENTO       date,                     

    CONSTRAINT PRIMARY_KEY_MULTA          PRIMARY KEY (IUV, NUMERO_TESSERA),
    CONSTRAINT FOREIGN_KEY_MULTA          FOREIGN KEY (NUMERO_TESSERA) REFERENCES REGISTRAZIONE (NUMERO_TESSERA)
);

CREATE TABLE MENSOLA
(
    LETTERA_MENSOLA     char   (1),
    NUMERO_PIANO        number (1, 0),
    CATEGORIA_SCAFFALE  varchar(20),
    CAPIENZA            number (3, 0)   NOT NULL,

    CONSTRAINT PRIMARY_KEY_MENSOLA    PRIMARY KEY (LETTERA_MENSOLA, NUMERO_PIANO, CATEGORIA_SCAFFALE),
    CONSTRAINT FOREIGN_KEY_MENSOLA    FOREIGN KEY (NUMERO_PIANO, CATEGORIA_SCAFFALE) REFERENCES SCAFFALE (NUMERO_PIANO, CATEGORIA_SCAFFALE),
    CONSTRAINT CHECK_LETTERA_MENSOLA  CHECK       (LOWER(LETTERA_MENSOLA) BETWEEN 'a' AND 'z'),
    CONSTRAINT CHECK_CAPIENZA_MENSOLA CHECK       (CAPIENZA > 0)
);

CREATE TABLE ORDINE
(
    DATA_ACQUISTO_ORDINE        date,
    ISBN_COPIE_ACQUISTATE       char  (13)    NOT NULL,
    NUMERO_COPIE_ACQUISTATE     number(3, 0)  NOT NULL,
    ID_FORNITORE                number(3, 0),

    CONSTRAINT PRIMARY_KEY_ORDINE            PRIMARY KEY (DATA_ACQUISTO_ORDINE, ID_FORNITORE),
    CONSTRAINT FOREIGN_KEY_ORDINE            FOREIGN KEY (ID_FORNITORE) REFERENCES FORNITORE (ID_FORNITORE),
    CONSTRAINT CHECK_ISBN_ORDINE             CHECK       (REGEXP_LIKE(ISBN_COPIE_ACQUISTATE, '^[0-9]{13}+$')),
    CONSTRAINT CHECK_NUMERO_COPIE_ACQUISTATE CHECK       (NUMERO_COPIE_ACQUISTATE > 0)
);

CREATE TABLE COPIA
(
    ISBN                     char   (13),
    NUMERO_COPIA             number (4, 0),
    CONDIZIONE               char   (5)      NOT NULL,
    LETTERA_MENSOLA          char   (1)      NOT NULL,
    NUMERO_PIANO             number (1, 0)   NOT NULL,
    CATEGORIA_SCAFFALE       varchar(20)     NOT NULL,
    DATA_ACQUISTO_ORDINE     date            NOT NULL,
    ID_FORNITORE             number (3, 0)   NOT NULL,

    CONSTRAINT PRIMARY_KEY_COPIA      PRIMARY KEY (ISBN, NUMERO_COPIA),
    CONSTRAINT FOREIGN_KEY1_COPIA     FOREIGN KEY (ISBN)                                              REFERENCES LIBRO   (ISBN),
    CONSTRAINT FOREIGN_KEY2_COPIA     FOREIGN KEY (LETTERA_MENSOLA, NUMERO_PIANO, CATEGORIA_SCAFFALE) REFERENCES MENSOLA (LETTERA_MENSOLA, NUMERO_PIANO, CATEGORIA_SCAFFALE),
    CONSTRAINT FOREIGN_KEY3_COPIA     FOREIGN KEY (DATA_ACQUISTO_ORDINE, ID_FORNITORE)                REFERENCES ORDINE  (DATA_ACQUISTO_ORDINE, ID_FORNITORE),
    CONSTRAINT CHECK_ISBN_COPIA       CHECK       (REGEXP_LIKE(ISBN, '^[0-9]{13}+$')),
    CONSTRAINT CHECK_NUMERO_COPIA     CHECK       (NUMERO_COPIA > 0),
    CONSTRAINT CHECK_CONDIZIONE_COPIA CHECK       (LOWER(CONDIZIONE) IN ('nuovo', 'usato'))
);

CREATE TABLE RECENSIONE
(
    DATA_RECENSIONE     date,
    VALUTAZIONE         number(1, 0)  NOT NULL,
    ISBN                char  (13)    NOT NULL,
    NUMERO_TESSERA		char  (8),

    CONSTRAINT PRIMARY_KEY_RECENSIONE  PRIMARY KEY (ISBN, NUMERO_TESSERA),
    CONSTRAINT FOREIGN_KEY1_RECENSIONE FOREIGN KEY (ISBN)           REFERENCES LIBRO         (ISBN),
    CONSTRAINT FOREIGN_KEY2_RECENSIONE FOREIGN KEY (NUMERO_TESSERA) REFERENCES REGISTRAZIONE (NUMERO_TESSERA),
    CONSTRAINT CHECK_VALUTAZIONE       CHECK       (VALUTAZIONE IN (1, 2, 3, 4, 5))
);

CREATE TABLE PRENDE
(
    NUMERO_TESSERA              char  (8),
    ISBN                        char  (13),
    NUMERO_COPIA                number(4, 0),
    DATA_INIZIO_PRESTITO        date         NOT NULL,
    DATA_SCADENZA_PRESTITO      date         NOT NULL,
    DATA_RESTITUZIONE           date,

    CONSTRAINT PRIMARY_KEY_PRENDE  PRIMARY KEY (NUMERO_TESSERA, ISBN, NUMERO_COPIA),
    CONSTRAINT FOREIGN_KEY1_PRENDE FOREIGN KEY (NUMERO_TESSERA)     REFERENCES REGISTRAZIONE (NUMERO_TESSERA),
    CONSTRAINT FOREIGN_KEY2_PRENDE FOREIGN KEY (ISBN, NUMERO_COPIA) REFERENCES COPIA         (ISBN, NUMERO_COPIA)
);

CREATE TABLE SEGUITO
(
    NUMERO_TESSERA        char(8),
    DATA_E_ORA_EVENTO     date,

    CONSTRAINT PRIMARY_KEY_SEGUITO  PRIMARY KEY (NUMERO_TESSERA, DATA_E_ORA_EVENTO),
    CONSTRAINT FOREIGN_KEY1_SEGUITO FOREIGN KEY (NUMERO_TESSERA)       REFERENCES REGISTRAZIONE (NUMERO_TESSERA),
    CONSTRAINT FOREIGN_KEY2_SEGUITO FOREIGN KEY (DATA_E_ORA_EVENTO)    REFERENCES EVENTO        (DATA_E_ORA_EVENTO)
);

CREATE TABLE SCRITTO
(
    ISNI        char(16)    NOT NULL,
    ISBN        char(13)    NOT NULL,

    CONSTRAINT PRIMARY_KEY_SCRITTO  PRIMARY KEY (ISNI, ISBN),
    CONSTRAINT FOREIGN_KEY1_SCRITTO FOREIGN KEY (ISNI) REFERENCES AUTORE (ISNI),
    CONSTRAINT FOREIGN_KEY2_SCRITTO FOREIGN KEY (ISBN) REFERENCES LIBRO  (ISBN)
);

CREATE TABLE ASSISTE
(
    CODICE_FISCALE_CLIENTE char(16),
    NUMERO_MATRICOLA       char(8),
    DATA_ASSISTENZA        date         NOT NULL,

    CONSTRAINT PRIMARY_KEY_ASSISTE  PRIMARY KEY (CODICE_FISCALE_CLIENTE, NUMERO_MATRICOLA, DATA_ASSISTENZA),
    CONSTRAINT FOREIGN_KEY1_ASSISTE FOREIGN KEY (CODICE_FISCALE_CLIENTE) REFERENCES CLIENTE       (CODICE_FISCALE_CLIENTE),
    CONSTRAINT FOREIGN_KEY2_ASSISTE FOREIGN KEY (NUMERO_MATRICOLA)       REFERENCES BIBLIOTECARIO (NUMERO_MATRICOLA)
);