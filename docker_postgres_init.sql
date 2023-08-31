--
-- PostgreSQL database dump
--

-- Dumped from database version 13.8
-- Dumped by pg_dump version 13.8

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
-- Name: dbo; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA dbo;


--
-- Name: AddIndicatorAndFixToDiscipline(integer, text, integer, text); Type: PROCEDURE; Schema: dbo; Owner: -
--

CREATE PROCEDURE dbo."AddIndicatorAndFixToDiscipline"(disciplineid integer, competencecode text, indicatornumber integer, indicatordescription text)
    LANGUAGE plpgsql
    AS $$

DECLARE

    lengthDisciplineData integer;

    lengthCompetenceData integer;

    lengthIndicatorData  integer;

    competenceId         integer;

    indicatorId          integer;

begin

    lengthDisciplineData := (SELECT COUNT(*) FROM dbo."Disciplines" WHERE "Id" = disciplineId);



    IF lengthDisciplineData = 0 THEN

        RAISE EXCEPTION 'Cannot find Discipline by Id %', cast(disciplineId as TEXT);

    END IF;



    lengthCompetenceData := (SELECT COUNT(*)

                             FROM dbo."Competences"

                             WHERE "Code" = competenceCode);



    IF lengthCompetenceData = 0 THEN

        RAISE EXCEPTION 'Cannot find Competence by Code %', competenceCode;

    END IF;



    lengthIndicatorData := (SELECT COUNT(*)

                            FROM dbo."Indicators"

                            WHERE "Number" = indicatorNumber

                              AND "Description" = indicatorDescription);



    IF lengthIndicatorData != 0 THEN

        RAISE EXCEPTION 'Indicator already exist';

    END IF;



    competenceId := (SELECT ("Id") FROM dbo."Competences" WHERE "Code" = competencecode LIMIT 1);



    INSERT INTO dbo."Indicators"

    ( "Number"

    , "Description"

    , "CompetenceId")

    VALUES ( indicatorNumber

           , indicatorDescription

           , competenceId);



    indicatorId := (SELECT ("Id") FROM dbo."Indicators" ORDER BY "Id" DESC LIMIT 1);



    INSERT INTO dbo."DisciplineIndicator"

    ( "DisciplinesId"

    , "IndicatorsId")

    VALUES ( disciplineId

           , indicatorId);



    commit;

end;

$$;


--
-- Name: AddIndicatorWithCompetenceAndFixToDiscipline(integer, text, text, integer, text); Type: PROCEDURE; Schema: dbo; Owner: -
--

CREATE PROCEDURE dbo."AddIndicatorWithCompetenceAndFixToDiscipline"(disciplineid integer, competencecode text, competencedescription text, indicatornumber integer, indicatordescription text)
    LANGUAGE plpgsql
    AS $$
DECLARE
	lengthDisciplineData integer;
	customMessage TEXT;
	lengthCompetenceData integer;
	lengthIndicatorData integer;
	competenceId integer;
	indicatorId integer;
begin
	lengthDisciplineData := (SELECT COUNT(*) FROM dbo."Disciplines" WHERE "Id" = disciplineId);
	
	IF lengthDisciplineData = 0 THEN
		RAISE EXCEPTION 'Cannot find Discipline by Id %', cast(disciplineId as TEXT);
	END IF;

	lengthCompetenceData := (SELECT COUNT(*) FROM dbo."Competences" WHERE "Code" = competenceCode
																	OR "Name" = competenceDescription);

	IF lengthCompetenceData != 0 THEN
		RAISE EXCEPTION 'Competence already exist';
	END IF;

	lengthIndicatorData := (SELECT COUNT(*) FROM dbo."Indicators" WHERE "Number" = indicatorNumber 
																	AND "Description" = indicatorDescription);

	IF lengthIndicatorData != 0 THEN
		RAISE EXCEPTION 'Indicator already exist';
	END IF;

	INSERT INTO dbo."Competences"
           ("Code"
           ,"Name")
     VALUES
           (competenceCode, competenceDescription);

	competenceId := (SELECT ("Id") FROM dbo."Competences" ORDER BY "Id" DESC LIMIT 1);

	INSERT INTO dbo."Indicators"
           ("Number"
           ,"Description"
           ,"CompetenceId")
     VALUES
           (indicatorNumber
           ,indicatorDescription
           ,competenceId);
		   
	indicatorId := (SELECT ("Id") FROM dbo."Indicators" ORDER BY "Id" DESC LIMIT 1);

	INSERT INTO dbo."DisciplineIndicator"
           ("DisciplinesId"
           ,"IndicatorsId")
     VALUES
           (disciplineId
           ,indicatorId);

    commit;
end;$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: AcademicDegrees; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."AcademicDegrees" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "ShortName" text NOT NULL
);


--
-- Name: AcademicDegrees_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."AcademicDegrees" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."AcademicDegrees_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: AcademicRanks; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."AcademicRanks" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL
);


--
-- Name: AcademicRanks_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."AcademicRanks" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."AcademicRanks_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: RoleClaims; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."RoleClaims" (
    "Id" integer NOT NULL,
    "RoleId" character varying(450) NOT NULL,
    "ClaimType" text,
    "ClaimValue" text
);


--
-- Name: AspNetRoleClaims_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."RoleClaims" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."AspNetRoleClaims_Id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: UserClaims; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."UserClaims" (
    "Id" integer NOT NULL,
    "UserId" character varying(450) NOT NULL,
    "ClaimType" text,
    "ClaimValue" text
);


--
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."UserClaims" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."AspNetUserClaims_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: AudienceEducationalProgram; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."AudienceEducationalProgram" (
    "AudiencesId" integer NOT NULL,
    "EducationalProgramsId" integer NOT NULL
);


--
-- Name: Audiences; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Audiences" (
    "Id" integer NOT NULL,
    "Number" integer NOT NULL,
    "BuildingNumber" integer NOT NULL,
    "RegistrationNumber" text NOT NULL
);


--
-- Name: Audiences_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Audiences" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Audiences_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: CompetenceFormationLevelEvaluationToolType; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."CompetenceFormationLevelEvaluationToolType" (
    "CompetenceFormationLevelsId" integer NOT NULL,
    "EvaluationToolTypesId" integer NOT NULL
);


--
-- Name: CompetenceFormationLevels; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."CompetenceFormationLevels" (
    "Id" integer NOT NULL,
    "LevelNumber" integer NOT NULL,
    "FormationLevel" integer NOT NULL,
    "FactualDescription" text NOT NULL,
    "LearningOutcomes" text NOT NULL,
    "IndicatorId" integer NOT NULL,
    "EducationalProgramId" integer NOT NULL
);


--
-- Name: CompetenceFormationLevels_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."CompetenceFormationLevels" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."CompetenceFormationLevels_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: CompetenceLesson; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."CompetenceLesson" (
    "CompetencesId" integer NOT NULL,
    "LessonsId" integer NOT NULL
);


--
-- Name: Competences; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Competences" (
    "Id" integer NOT NULL,
    "Code" text NOT NULL,
    "Name" text NOT NULL
);


--
-- Name: Competences_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Competences" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Competences_Id_seq"
    START WITH 2000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Curriculums; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Curriculums" (
    "Id" integer NOT NULL,
    "RegistrationNumber" text NOT NULL,
    "ApprovalDate" timestamp with time zone NOT NULL,
    "StudyStartingYear" timestamp with time zone NOT NULL,
    "SpecialtyId" integer NOT NULL
);


--
-- Name: Curriculums_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Curriculums" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Curriculums_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: DepartmentHeads; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."DepartmentHeads" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "Surname" text NOT NULL,
    "Patronymic" text NOT NULL
);


--
-- Name: DepartmentHeads_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."DepartmentHeads" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."DepartmentHeads_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Departments; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Departments" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "ShortName" text NOT NULL,
    "DepartmentHeadId" integer NOT NULL
);


--
-- Name: Departments_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Departments" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Departments_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: DisciplineIndicator; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."DisciplineIndicator" (
    "DisciplinesId" integer NOT NULL,
    "IndicatorsId" integer NOT NULL
);


--
-- Name: DisciplineTeacher; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."DisciplineTeacher" (
    "DisciplinesId" integer NOT NULL,
    "TeachersId" integer NOT NULL
);


--
-- Name: Disciplines; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Disciplines" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "Number" text NOT NULL,
    "LaborIntensityHours" integer NOT NULL,
    "LaborIntensityCreditUnits" integer NOT NULL,
    "ContactWorkHours" integer NOT NULL,
    "LecturesHours" integer NOT NULL,
    "LaboratoryClassesHours" integer,
    "PracticalClassesHours" integer,
    "CourseProjectSemester" integer,
    "CourseWorkSemester" integer,
    "SelfStudyHours" integer NOT NULL,
    "DepartmentId" integer NOT NULL,
    "CurriculumId" integer NOT NULL,
    "Status" integer DEFAULT 4 NOT NULL
);


--
-- Name: Disciplines_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Disciplines" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Disciplines_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: EducationalProgramInspector; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EducationalProgramInspector" (
    "EducationalProgramsId" integer NOT NULL,
    "InspectorsId" integer NOT NULL
);


--
-- Name: EducationalProgramKnowledgeControlForm; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EducationalProgramKnowledgeControlForm" (
    "EducationalProgramsId" integer NOT NULL,
    "KnowledgeControlFormsId" integer NOT NULL
);


--
-- Name: EducationalProgramMethodicalRecommendation; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EducationalProgramMethodicalRecommendation" (
    "EducationalProgramsId" integer NOT NULL,
    "MethodicalRecommendationsId" integer NOT NULL
);


--
-- Name: EducationalProgramProtocol; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EducationalProgramProtocol" (
    "EducationalProgramsId" integer NOT NULL,
    "ProtocolsId" integer NOT NULL
);


--
-- Name: EducationalProgramTrainingCourseForm; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EducationalProgramTrainingCourseForm" (
    "EducationalProgramsId" integer NOT NULL,
    "TrainingCourseFormsId" integer NOT NULL
);


--
-- Name: EducationalPrograms; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EducationalPrograms" (
    "Id" integer NOT NULL,
    "ApprovalDate" timestamp with time zone,
    "ApprovalRecommendedDate" timestamp with time zone,
    "ProtocolNumber" integer,
    "DisciplineId" integer NOT NULL,
    "ReviewerId" integer
);


--
-- Name: EducationalPrograms_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."EducationalPrograms" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."EducationalPrograms_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: EvaluationToolTypes; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EvaluationToolTypes" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL
);


--
-- Name: EvaluationToolTypes_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."EvaluationToolTypes" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."EvaluationToolTypes_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: EvaluationTools; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."EvaluationTools" (
    "EducationalProgramId" integer NOT NULL,
    "EvaluationToolTypeId" integer NOT NULL,
    "SetNumber" integer NOT NULL
);


--
-- Name: Faculties; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Faculties" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL
);


--
-- Name: Faculties_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Faculties" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Faculties_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: FederalStateEducationalStandards; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."FederalStateEducationalStandards" (
    "Id" integer NOT NULL,
    "Code" text NOT NULL,
    "Date" timestamp with time zone NOT NULL
);


--
-- Name: FederalStateEducationalStandards_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."FederalStateEducationalStandards" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."FederalStateEducationalStandards_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Indicators; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Indicators" (
    "Id" integer NOT NULL,
    "Number" integer NOT NULL,
    "Description" text NOT NULL,
    "CompetenceId" integer NOT NULL
);


--
-- Name: Indicators_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Indicators" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Indicators_Id_seq"
    START WITH 2000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: InformationBlockContents; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."InformationBlockContents" (
    "EducationalProgramId" integer NOT NULL,
    "InformationBlockId" integer NOT NULL,
    "Content" text NOT NULL
);


--
-- Name: InformationBlocks; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."InformationBlocks" (
    "Id" integer NOT NULL,
    "Number" text NOT NULL,
    "Name" text NOT NULL,
    "IsRequired" boolean NOT NULL
);


--
-- Name: InformationBlocks_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."InformationBlocks" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."InformationBlocks_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: InformationTemplates; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."InformationTemplates" (
    "Id" integer NOT NULL,
    "Content" text NOT NULL,
    "InformationBlockId" integer NOT NULL
);


--
-- Name: InformationTemplates_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."InformationTemplates" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."InformationTemplates_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Inspectors; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Inspectors" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "Surname" text NOT NULL,
    "Patronymic" text NOT NULL,
    "Position" text NOT NULL
);


--
-- Name: Inspectors_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Inspectors" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Inspectors_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: KnowledgeAssessment; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."KnowledgeAssessment" (
    "KnowledgeControlFormId" integer NOT NULL,
    "WeekId" integer NOT NULL,
    "MaxMark" integer NOT NULL
);


--
-- Name: KnowledgeControlForms; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."KnowledgeControlForms" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "ShortName" text NOT NULL
);


--
-- Name: KnowledgeControlForms_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."KnowledgeControlForms" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."KnowledgeControlForms_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: LessonWeek; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."LessonWeek" (
    "LessonsId" integer NOT NULL,
    "WeeksId" integer NOT NULL
);


--
-- Name: Lessons; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Lessons" (
    "Id" integer NOT NULL,
    "Number" integer NOT NULL,
    "Name" text NOT NULL,
    "Content" text,
    "Hours" integer NOT NULL,
    "LessonType" integer NOT NULL,
    "TrainingCourseFormId" integer,
    "EducationalProgramId" integer NOT NULL
);


--
-- Name: Lessons_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Lessons" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Lessons_Id_seq"
    START WITH 100
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: LiteratureTypeInfos; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."LiteratureTypeInfos" (
    "EducationalProgramId" integer NOT NULL,
    "LiteratureId" integer NOT NULL,
    "Type" integer NOT NULL
);


--
-- Name: Literatures; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Literatures" (
    "Id" integer NOT NULL,
    "Description" text NOT NULL,
    "Recommended" text NOT NULL,
    "SetNumber" text NOT NULL
);


--
-- Name: Literatures_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Literatures" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Literatures_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: MethodicalRecommendations; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."MethodicalRecommendations" (
    "Id" integer NOT NULL,
    "Content" text NOT NULL,
    "Link" text NOT NULL
);


--
-- Name: MethodicalRecommendations_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."MethodicalRecommendations" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."MethodicalRecommendations_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Positions; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Positions" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "ShortName" text NOT NULL
);


--
-- Name: Positions_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Positions" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Positions_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Protocols; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Protocols" (
    "Id" integer NOT NULL,
    "Date" timestamp with time zone NOT NULL,
    "Number" integer NOT NULL
);


--
-- Name: Protocols_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Protocols" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Protocols_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: RefreshTokens; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."RefreshTokens" (
    "Id" uuid NOT NULL,
    "Token" text NOT NULL,
    "JwtId" text NOT NULL,
    "CreationDate" timestamp with time zone NOT NULL,
    "ExpiryDate" timestamp with time zone NOT NULL,
    "Used" boolean NOT NULL,
    "UserId" character varying(450) NOT NULL
);


--
-- Name: Reviewers; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Reviewers" (
    "Id" integer NOT NULL,
    "Position" text NOT NULL,
    "Name" text NOT NULL,
    "Surname" text NOT NULL,
    "Patronymic" text NOT NULL
);


--
-- Name: Reviewers_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Reviewers" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Reviewers_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Roles; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Roles" (
    "Id" character varying(450) NOT NULL,
    "Name" character varying(256),
    "NormalizedName" character varying(256),
    "ConcurrencyStamp" text
);


--
-- Name: SemesterDistributions; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."SemesterDistributions" (
    "DisciplineId" integer NOT NULL,
    "SemesterId" integer NOT NULL,
    "KnowledgeCheckType" integer NOT NULL
);


--
-- Name: Semesters; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Semesters" (
    "Id" integer NOT NULL,
    "Number" integer NOT NULL,
    "WeeksNumber" integer NOT NULL,
    "CourseNumber" integer NOT NULL,
    "CourseProjectEndWeek" integer NOT NULL,
    "ExamEndWeek" integer NOT NULL
);


--
-- Name: Semesters_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Semesters" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Semesters_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Specialties; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Specialties" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL,
    "Code" text NOT NULL,
    "ProfileName" text NOT NULL,
    "Qualification" text NOT NULL,
    "LearningForm" text NOT NULL,
    "StudyPeriod" integer NOT NULL,
    "DepartmentId" integer NOT NULL,
    "FederalStateEducationalStandardId" integer NOT NULL,
    "FacultyId" integer NOT NULL
);


--
-- Name: Specialties_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Specialties" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Specialties_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: Teachers; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Teachers" (
    "Id" integer NOT NULL,
    "AcademicDegreeId" integer,
    "AcademicRankId" integer,
    "PositionId" integer NOT NULL,
    "DepartmentId" integer NOT NULL,
    "ApplicationUserId" character varying(450) NOT NULL
);


--
-- Name: Teachers_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Teachers" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Teachers_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: TrainingCourseForms; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."TrainingCourseForms" (
    "Id" integer NOT NULL,
    "Name" text NOT NULL
);


--
-- Name: TrainingCourseForms_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."TrainingCourseForms" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."TrainingCourseForms_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: UserRoles; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."UserRoles" (
    "UserId" character varying(450) NOT NULL,
    "RoleId" character varying(450) NOT NULL
);


--
-- Name: Users; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Users" (
    "Id" character varying(450) NOT NULL,
    "UserName" character varying(256),
    "NormalizedUserName" character varying(256),
    "Email" character varying(256),
    "NormalizedEmail" character varying(256),
    "EmailConfirmed" boolean NOT NULL,
    "PasswordHash" text,
    "SecurityStamp" text,
    "ConcurrencyStamp" text,
    "PhoneNumber" text,
    "Surname" text NOT NULL,
    "Patronymic" text NOT NULL,
    "IsActive" boolean DEFAULT true NOT NULL,
    "DepartmentId" integer
);


--
-- Name: Weeks; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."Weeks" (
    "Id" integer NOT NULL,
    "Number" integer NOT NULL,
    "IndependentWorkHours" integer NOT NULL,
    "TrainingModuleNumber" integer NOT NULL,
    "SemesterId" integer NOT NULL,
    "EducationalProgramId" integer NOT NULL
);


--
-- Name: Weeks_Id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

ALTER TABLE dbo."Weeks" ALTER COLUMN "Id" ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME dbo."Weeks_Id_seq"
    START WITH 1000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: __EFMigrationsHistory; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo."__EFMigrationsHistory" (
    "MigrationId" character varying(150) NOT NULL,
    "ProductVersion" character varying(32)
);


--
-- Name: academicdegrees_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.academicdegrees_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academicdegrees_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.academicdegrees_id_seq OWNED BY dbo."AcademicDegrees"."Id";


--
-- Name: academicranks_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.academicranks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: academicranks_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.academicranks_id_seq OWNED BY dbo."AcademicRanks"."Id";


--
-- Name: aspnetroleclaims_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.aspnetroleclaims_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aspnetroleclaims_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.aspnetroleclaims_id_seq OWNED BY dbo."RoleClaims"."Id";


--
-- Name: aspnetuserclaims_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.aspnetuserclaims_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: aspnetuserclaims_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.aspnetuserclaims_id_seq OWNED BY dbo."UserClaims"."Id";


--
-- Name: audiences_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.audiences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: audiences_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.audiences_id_seq OWNED BY dbo."Audiences"."Id";


--
-- Name: competenceformationlevels_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.competenceformationlevels_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competenceformationlevels_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.competenceformationlevels_id_seq OWNED BY dbo."CompetenceFormationLevels"."Id";


--
-- Name: competences_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.competences_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: competences_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.competences_id_seq OWNED BY dbo."Competences"."Id";


--
-- Name: curriculums_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.curriculums_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: curriculums_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.curriculums_id_seq OWNED BY dbo."Curriculums"."Id";


--
-- Name: departmentheads_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.departmentheads_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departmentheads_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.departmentheads_id_seq OWNED BY dbo."DepartmentHeads"."Id";


--
-- Name: departments_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.departments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: departments_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.departments_id_seq OWNED BY dbo."Departments"."Id";


--
-- Name: disciplines_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.disciplines_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: disciplines_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.disciplines_id_seq OWNED BY dbo."Disciplines"."Id";


--
-- Name: educationalprograms_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.educationalprograms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: educationalprograms_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.educationalprograms_id_seq OWNED BY dbo."EducationalPrograms"."Id";


--
-- Name: evaluationtooltypes_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.evaluationtooltypes_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: evaluationtooltypes_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.evaluationtooltypes_id_seq OWNED BY dbo."EvaluationToolTypes"."Id";


--
-- Name: faculties_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.faculties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: faculties_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.faculties_id_seq OWNED BY dbo."Faculties"."Id";


--
-- Name: federalstateeducationalstandards_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.federalstateeducationalstandards_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: federalstateeducationalstandards_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.federalstateeducationalstandards_id_seq OWNED BY dbo."FederalStateEducationalStandards"."Id";


--
-- Name: indicators_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.indicators_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: indicators_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.indicators_id_seq OWNED BY dbo."Indicators"."Id";


--
-- Name: informationblocks_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.informationblocks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: informationblocks_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.informationblocks_id_seq OWNED BY dbo."InformationBlocks"."Id";


--
-- Name: informationtemplates_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.informationtemplates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: informationtemplates_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.informationtemplates_id_seq OWNED BY dbo."InformationTemplates"."Id";


--
-- Name: inspectors_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.inspectors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: inspectors_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.inspectors_id_seq OWNED BY dbo."Inspectors"."Id";


--
-- Name: knowledgecontrolforms_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.knowledgecontrolforms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: knowledgecontrolforms_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.knowledgecontrolforms_id_seq OWNED BY dbo."KnowledgeControlForms"."Id";


--
-- Name: lessons_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.lessons_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: lessons_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.lessons_id_seq OWNED BY dbo."Lessons"."Id";


--
-- Name: literatures_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.literatures_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: literatures_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.literatures_id_seq OWNED BY dbo."Literatures"."Id";


--
-- Name: methodicalrecommendations_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.methodicalrecommendations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: methodicalrecommendations_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.methodicalrecommendations_id_seq OWNED BY dbo."MethodicalRecommendations"."Id";


--
-- Name: positions_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.positions_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: positions_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.positions_id_seq OWNED BY dbo."Positions"."Id";


--
-- Name: protocols_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.protocols_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: protocols_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.protocols_id_seq OWNED BY dbo."Protocols"."Id";


--
-- Name: reviewers_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.reviewers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: reviewers_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.reviewers_id_seq OWNED BY dbo."Reviewers"."Id";


--
-- Name: semesters_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.semesters_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: semesters_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.semesters_id_seq OWNED BY dbo."Semesters"."Id";


--
-- Name: specialties_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.specialties_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: specialties_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.specialties_id_seq OWNED BY dbo."Specialties"."Id";


--
-- Name: sysdiagrams; Type: TABLE; Schema: dbo; Owner: -
--

CREATE TABLE dbo.sysdiagrams (
    name character varying(128),
    principal_id integer,
    diagram_id integer NOT NULL,
    version integer,
    definition text
);


--
-- Name: sysdiagrams_diagram_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.sysdiagrams_diagram_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sysdiagrams_diagram_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.sysdiagrams_diagram_id_seq OWNED BY dbo.sysdiagrams.diagram_id;


--
-- Name: teachers_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.teachers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: teachers_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.teachers_id_seq OWNED BY dbo."Teachers"."Id";


--
-- Name: trainingcourseforms_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.trainingcourseforms_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: trainingcourseforms_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.trainingcourseforms_id_seq OWNED BY dbo."TrainingCourseForms"."Id";


--
-- Name: weeks_id_seq; Type: SEQUENCE; Schema: dbo; Owner: -
--

CREATE SEQUENCE dbo.weeks_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: weeks_id_seq; Type: SEQUENCE OWNED BY; Schema: dbo; Owner: -
--

ALTER SEQUENCE dbo.weeks_id_seq OWNED BY dbo."Weeks"."Id";


--
-- Name: sysdiagrams diagram_id; Type: DEFAULT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo.sysdiagrams ALTER COLUMN diagram_id SET DEFAULT nextval('dbo.sysdiagrams_diagram_id_seq'::regclass);


--
-- Data for Name: AcademicDegrees; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."AcademicDegrees" ("Id", "Name", "ShortName") FROM stdin;
1	Кандидат экономических наук	
2	Доктор физико-математических наук	
3	Доктор технических наук	
4	Кандидат технических наук	к. т.н.
5	Кандидат физико-математических наук	канд. физ.-мат. наук
\.


--
-- Data for Name: AcademicRanks; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."AcademicRanks" ("Id", "Name") FROM stdin;
1	Доцент
2	Профессор
\.


--
-- Data for Name: AudienceEducationalProgram; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."AudienceEducationalProgram" ("AudiencesId", "EducationalProgramsId") FROM stdin;
\.


--
-- Data for Name: Audiences; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Audiences" ("Id", "Number", "BuildingNumber", "RegistrationNumber") FROM stdin;
1	517	2	ПУЛ-4/517.2-21
2	518	2	ПУЛ-4/518.2-21
\.


--
-- Data for Name: CompetenceFormationLevelEvaluationToolType; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."CompetenceFormationLevelEvaluationToolType" ("CompetenceFormationLevelsId", "EvaluationToolTypesId") FROM stdin;
\.


--
-- Data for Name: CompetenceFormationLevels; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."CompetenceFormationLevels" ("Id", "LevelNumber", "FormationLevel", "FactualDescription", "LearningOutcomes", "IndicatorId", "EducationalProgramId") FROM stdin;
1000	1	0			2030	1003
1001	2	1			2030	1003
1002	3	2			2030	1003
1003	1	0			2028	1004
1004	2	1			2028	1004
1005	3	2			2028	1004
1006	1	0			2029	1004
1007	2	1			2029	1004
1008	3	2			2029	1004
1009	1	0			2007	1005
1010	2	1			2007	1005
1011	3	2			2007	1005
1012	1	0			2008	1005
1013	2	1			2008	1005
1014	3	2			2008	1005
1015	1	0			2031	1006
1016	2	1			2031	1006
1017	3	2			2031	1006
\.


--
-- Data for Name: CompetenceLesson; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."CompetenceLesson" ("CompetencesId", "LessonsId") FROM stdin;
\.


--
-- Data for Name: Competences; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Competences" ("Id", "Code", "Name") FROM stdin;
2003	УК-1	Способен осуществлять поиск, критический анализ и синтез информации, применять системный подход для решения поставленных задач
2004	ОПК-7	Способен применять в практической деятельности основные концепции, принципы, теории и факты, связанные с информатикой
2005	ОПК-2	Способен использовать современные информационные технологии и программные средства, в том числе отечественного производства, при решении задач профессиональной деятельности
2006	ОПК-6	Способен разрабатывать алгоритмы и программы, пригодные для практического использования, применять основы информатики и программирования к проектированию, конструированию и тестированию программных продуктов
2007	ОПК-8	Способен осуществлять поиск, хранение, обработку и анализ информации из различных источников и баз данных, представлять ее в требуемом формате с использованием информационных, компьютерных и сетевых технологий
2008	ПК-9	Владение навыками использования операционных систем, сетевых технологий, средств разработки программного интерфейса, применения языков и методов формальных спецификаций, систем управления базами данных
2009	ОПК-5	Способен инсталлировать программное и аппаратное обеспечение для информационных и автоматизированных систем
2010	ПК-10	Владение навыками использования различных технологий разработки программного обеспечения
2011	ОПК-4	Способен участвовать в разработке стандартов, норм и правил, а также технической документации, связанной с профессиональной деятельностью
2012	ОПК-3	Способен решать стандартные задачи профессиональной деятельности на основе информационной и библиографической культуры с применением информационно-коммуникационных технологий и с учетом основных требований информационной безопасности
2013	ПК-2	Владение методами контроля проекта и готовностью осуществлять контроль версий
2014	ОПК-1	Способен применять естественнонаучные и общеинженерные знания, методы математического анализа и моделирования, теоретического и экспериментального исследования в профессиональной деятельности
2015	ПК-4	Готовность к использованию методов и инструментальных средств исследования объектов профессиональной деятельности
2016	ПК-8	Способность создавать программные интерфейсы
\.


--
-- Data for Name: Curriculums; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Curriculums" ("Id", "RegistrationNumber", "ApprovalDate", "StudyStartingYear", "SpecialtyId") FROM stdin;
1	090301-4	2019-12-27 03:00:00+03	2020-09-01 03:00:00+03	1
2	090304-4	2019-12-27 03:00:00+03	2020-09-01 03:00:00+03	2
\.


--
-- Data for Name: DepartmentHeads; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."DepartmentHeads" ("Id", "Name", "Surname", "Patronymic") FROM stdin;
1	Виктор	Кутузов	Владимирович
2	Ирина	Ивановская	Викторовна
3	Анатолий	Александров	Витальевич
4	Александр	Щур	Васильевич
5	Наталья	Рытова	Николаевна
6	Виталий	Замураев	Геннадьевич
7	Александр	Хомченко	Васильевич
8	Дмитрий	Самуйлов	Николаевич
9	Анатолий	Якимов	Иванович
10	Сергей	Сергеев	Сергеевич
\.


--
-- Data for Name: Departments; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Departments" ("Id", "Name", "ShortName", "DepartmentHeadId") FROM stdin;
1	Программное обеспечение информационных технологий	ПОИТ	1
2	Экономика и управление	ЭУ	2
3	Маркетинг и менеджмент	МИМ	3
4	Техносферная безопасность и производственный дизайн	ТБИПД	4
5	Гуманитарные дисциплины	ГД	5
6	Высшая математика	ВМ	6
7	Физика	Ф	7
8	Физвоспитание и спорт	ФИС	8
9	Автоматизированные системы управления	АСУ	9
10	Физические методы контроля	ФМК	10
\.


--
-- Data for Name: DisciplineIndicator; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."DisciplineIndicator" ("DisciplinesId", "IndicatorsId") FROM stdin;
17	2005
17	2006
18	2007
18	2008
19	2009
19	2010
20	2011
20	2012
21	2013
22	2014
22	2015
24	2016
25	2017
25	2018
27	2019
28	2020
28	2021
30	2022
32	2023
33	2024
33	2025
36	2026
41	2027
43	2028
43	2029
45	2030
46	2030
47	2031
48	2031
\.


--
-- Data for Name: DisciplineTeacher; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."DisciplineTeacher" ("DisciplinesId", "TeachersId") FROM stdin;
21	2
24	4
45	4
46	4
19	5
25	5
30	5
41	5
43	5
22	7
22	8
28	8
36	8
47	8
48	8
22	12
20	14
27	14
33	14
25	22
33	22
41	22
43	22
30	23
32	25
32	26
7	28
13	28
15	28
21	28
36	28
39	28
56	28
21	1000
48	28
47	28
18	28
45	28
43	28
\.


--
-- Data for Name: Disciplines; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Disciplines" ("Id", "Name", "Number", "LaborIntensityHours", "LaborIntensityCreditUnits", "ContactWorkHours", "LecturesHours", "LaboratoryClassesHours", "PracticalClassesHours", "CourseProjectSemester", "CourseWorkSemester", "SelfStudyHours", "DepartmentId", "CurriculumId", "Status") FROM stdin;
4	История	Б1.О.1	144	4	68	34	\N	34	\N	\N	76	5	2	4
5	Иностранный язык	Б1.О.2	432	12	204	0	\N	204	\N	\N	228	5	2	4
6	Философия	Б1.О.3	144	4	68	34	\N	34	\N	\N	76	5	2	4
7	Безопасность жизнедеятельности	Б1.О.4	108	3	50	16	\N	34	\N	\N	58	4	2	4
8	Математика	Б1.О.5	360	10	238	102	\N	136	\N	\N	122	6	2	4
9	Физика	Б1.О.6	324	9	168	68	50	50	\N	\N	156	7	2	4
10	Инженерная графика	Б1.О.7	108	3	50	16	\N	34	\N	\N	58	4	2	4
11	Экономика	Б1.О.8	144	4	68	34	\N	34	\N	\N	76	2	2	4
12	Правоведение	Б1.О.9	108	3	50	16	\N	34	\N	\N	58	2	2	4
13	Экология	Б1.О.10	108	3	48	16	16	16	\N	\N	60	4	2	4
14	Физическая культура	Б1.О.11	72	2	8	8	\N	\N	\N	\N	64	8	2	4
15	Дискретная математика	Б1.О.12	180	5	68	34	34	\N	\N	\N	112	9	2	4
16	Теория вероятностей, математическая статистика и с	Б1.О.13	144	4	68	34	\N	34	\N	\N	76	6	2	4
17	Информатика	Б1.О.14	108	3	68	34	34	\N	\N	\N	40	1	2	4
19	Базы данных	Б1.О.16	288	8	134	50	84	\N	4	\N	154	1	2	4
20	Операционные системы	Б1.О.17	252	7	134	50	84	\N	\N	\N	118	1	2	4
22	Объектно-ориентированное программирование	Б1.О.19	288	8	118	50	68	\N	5	\N	170	1	2	4
23	Логика и теория алгоритмов	Б1.О.20	144	4	68	34	34	\N	\N	\N	76	9	2	4
24	Теория формальных языков	Б1.О.21	144	4	66	16	50	\N	\N	\N	78	1	2	4
25	Основы программной инженерии	Б1.О.22	72	2	32	16	\N	16	\N	\N	40	1	2	4
26	Электроника	Б1.О.23	144	4	50	16	34	\N	\N	\N	94	10	2	4
27	Защита информации	Б1.О.24	108	3	50	16	34	\N	\N	\N	58	1	2	4
28	Проектирование программного обеспечения	Б1.О.25	216	6	68	34	34	\N	7	\N	148	1	2	4
29	Обработка экспериментальных данных	Б1.О.26	144	4	44	22	22	\N	\N	\N	100	9	2	4
30	Системный анализ	Б1.О.27	108	3	44	14	30	\N	\N	\N	64	1	2	4
31	Теоретическая информатика	Б1.О.28	72	2	32	16	16	\N	\N	\N	40	9	2	4
32	Экспертные системы	Б1.О.29	216	6	128	64	64	\N	\N	8	88	1	2	4
33	Тестирование и отладка программного обеспечения	Б1.О.30	108	3	68	34	34	\N	\N	\N	40	1	2	4
34	Сети и телекоммуникации	Б1.О.31	288	8	168	68	100	\N	\N	6	120	9	2	4
35	Типы и структуры данных	Б1.В1	108	3	68	34	34	\N	\N	\N	40	9	2	4
36	Паттерны программирования	Б1.В2	144	4	66	16	50	\N	\N	\N	78	1	2	4
37	Культурология	Б1.В3	108	3	32	16	\N	16	\N	\N	76	5	2	4
38	Основы межличностных коммуникаций	Б1.В4	108	3	32	16	\N	16	\N	\N	76	5	2	4
39	Политология	Б1.В5	108	3	28	14	\N	14	\N	\N	80	5	2	4
40	Исследование операций	Б1.В6	180	5	110	44	66	\N	\N	\N	70	9	2	4
41	Архитектура программных систем	Б1.В7	180	5	60	30	30	\N	\N	7	120	1	2	4
42	Компьютерная графика	Б1.В8	180	5	68	34	34	\N	\N	3	112	9	2	4
44	Социология	Б1.В10	72	2	32	16	\N	16	\N	\N	40	5	2	4
46	Технологии Интернет-программирования	Б1.В11	144	4	68	34	34	\N	\N	\N	76	1	2	4
49	Современные системы программирования	Б1.В13	180	5	104	52	52	\N	\N	\N	76	9	2	4
50	Интегрированные информационные системы предприятий	Б1.В13	180	5	104	52	52	\N	\N	\N	76	9	2	4
51	Математическое моделирование	Б1.В14	180	5	60	30	30	\N	\N	8	120	9	2	4
52	Имитационное моделирование систем	Б1.В14	180	5	60	30	30	\N	\N	8	120	9	2	4
53	Элективные курсы по физической культуре и спорту	Б1.В15	328	9	272	0	\N	272	\N	\N	56	8	2	4
54	Университетоведение	ФД.1	36	1	16	16	\N	\N	\N	\N	20	5	2	4
55	Коррупция и ее общественная опасность	ФД.2	36	1	10	10	\N	\N	\N	\N	26	3	2	4
56	Охрана труда	ФД.3	36	1	10	10	\N	\N	\N	\N	26	4	2	4
57	Перевод технической литературы	ФД.4	72	2	30	0	\N	30	\N	\N	42	5	2	4
21	ЭВМ и периферийные устройства	Б1.О.18	216	6	136	68	68	\N	\N	\N	80	1	2	4
43	Технологии разработки программного обеспечения	Б1.В9	180	5	66	16	50	\N	\N	6	114	1	2	4
18	Программирование	Б1.О.15	252	7	136	68	68	\N	2	\N	116	1	2	1
48	Проектирование графического интерфейса пользовател	Б1.В12	180	5	68	34	34	\N	\N	5	112	1	2	4
47	Средства взаимодействия человека с вычислительными	Б1.В12	180	5	68	34	34	\N	\N	5	112	1	2	4
45	Основы WEB-программирования	Б1.В11	144	4	68	34	34	\N	\N	\N	76	1	2	1
\.


--
-- Data for Name: EducationalProgramInspector; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EducationalProgramInspector" ("EducationalProgramsId", "InspectorsId") FROM stdin;
\.


--
-- Data for Name: EducationalProgramKnowledgeControlForm; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EducationalProgramKnowledgeControlForm" ("EducationalProgramsId", "KnowledgeControlFormsId") FROM stdin;
\.


--
-- Data for Name: EducationalProgramMethodicalRecommendation; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EducationalProgramMethodicalRecommendation" ("EducationalProgramsId", "MethodicalRecommendationsId") FROM stdin;
1005	1002
\.


--
-- Data for Name: EducationalProgramProtocol; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EducationalProgramProtocol" ("EducationalProgramsId", "ProtocolsId") FROM stdin;
\.


--
-- Data for Name: EducationalProgramTrainingCourseForm; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EducationalProgramTrainingCourseForm" ("EducationalProgramsId", "TrainingCourseFormsId") FROM stdin;
\.


--
-- Data for Name: EducationalPrograms; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EducationalPrograms" ("Id", "ApprovalDate", "ApprovalRecommendedDate", "ProtocolNumber", "DisciplineId", "ReviewerId") FROM stdin;
1003	\N	\N	\N	45	1003
1004	\N	\N	\N	43	1004
1005	\N	\N	\N	18	1005
1006	\N	\N	\N	48	1006
\.


--
-- Data for Name: EvaluationToolTypes; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EvaluationToolTypes" ("Id", "Name") FROM stdin;
1	Тестовые задания
2	Экзаменационные билеты
3	Вопросы к экзамену
4	Вопросы к зачету
\.


--
-- Data for Name: EvaluationTools; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."EvaluationTools" ("EducationalProgramId", "EvaluationToolTypeId", "SetNumber") FROM stdin;
1005	2	1
\.


--
-- Data for Name: Faculties; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Faculties" ("Id", "Name") FROM stdin;
1	Инженерно-экономический факультет
\.


--
-- Data for Name: FederalStateEducationalStandards; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."FederalStateEducationalStandards" ("Id", "Code", "Date") FROM stdin;
2	920	2017-09-19 03:00:00+03
1	929	2017-09-19 03:00:00+03
\.


--
-- Data for Name: Indicators; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Indicators" ("Id", "Number", "Description", "CompetenceId") FROM stdin;
2005	4	Способен применять системный подход при формализации и алгоритмизации поставленных задач и при написании программного кода	2003
2006	1	Применяет в практической деятельности основные концепции, принципы, теории и факты, связанные с информатикой	2004
2007	1	Способен использовать современные программные средства, в том числе отечественного производства при решении задач профессиональной деятельности	2005
2008	1	Применяет основные языки программирования для работы с базами данных, операционные системы и оболочки, современные программные среды разработки информационных систем и технологий	2006
2009	1	Применяет методы поиска и хранения информации с использованием современных информационных технологий	2007
2010	1	Применяет методы формальных спецификаций и системы управления базами данных	2008
2011	2	Выполняет параметрическую настройку информационных и автоматизированных систем	2009
2012	2	Способен применять современные средства, операционные системы и языки программирования	2008
2013	3	Обладает навыками инсталляции программного и аппаратного обеспечения информационных и автоматизированных систем	2009
2014	2	Применяет языки программирования и современные программные среды разработки информационных систем для автоматизации бизнес-процессов	2006
2015	1	Применяет современные технологии разработки ПО (структурное, объектно-ориентированное)	2010
2016	2	Способен применять в практической деятельности основные концепции, принципы теории формальных языков программирования при создании прототипов программно-технических комплексов	2004
2017	2	Способен участвовать в составления технической документации на различных этапах жизненного цикла информационной системы	2011
2018	4	Применяет основы информатики и программирования к проектированию алгоритмов и программ ведения баз данных и информационных хранилищ	2006
2019	1	Способен применять принципы, методы и средства решения стандартных задач профессиональной деятельности с учетом основных требований информационной безопасности	2012
2020	2	Способен решать стандартные задачи профессиональной деятельности на основе информационной и библиографической культуры с применением информационно коммуникационных технологий	2012
2021	1	Применяет основные методы информационной безопасности ИС	2013
2022	4	Способен применять естественнонаучные знания, методы математического анализа и моделирования для исследования сложных объектов в профессиональной деятельности	2014
2023	2	Способен использовать современные информационные технологии и программные средства при построении экспертных систем в профессиональной деятельности	2005
2024	3	Владеет навыками программирования, отладки и тестирования прототипов программно-технических комплексов задач	2006
2025	3	Обладает навыками в проведении переговоров и способен осуществлять контроль версий	2013
2026	2	Применяет современные паттерны программирования при разработке ПО	2010
2027	4	Обладает навыками применения языков и методов формальных спецификаций	2008
2028	2	Способен организовать работы по управлению проектом ИС	2013
2029	1	Использует современные инструментальные средства программного обеспечения	2015
2030	3	Умеет использовать современные технологии WEB-программирования и Интернет-программирования в решении практических задач разработки ПО	2010
2031	1	Применяет способы создания программных интерфейсов	2016
\.


--
-- Data for Name: InformationBlockContents; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."InformationBlockContents" ("EducationalProgramId", "InformationBlockId", "Content") FROM stdin;
1003	54	
1003	50	
1003	48	
1003	53	
1003	46	
1003	55	
1003	47	
1004	54	
1004	53	
1004	52	
1004	50	
1004	49	
1004	48	
1004	47	
1004	46	
1004	55	
1005	54	
1005	53	
1005	52	
1005	50	
1005	49	
1005	48	
1005	55	
1005	47	\n  <html> <head> <meta charset="UTF-8">\n  <style>\n    li { margin-left:1cm;margin: 0cm; }\n    h2, h3, h4 { font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n    p { font-size: 16px; font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    td { padding: 0; padding: 0in 5.4pt 0in 5.4pt }\n    td p {text-align: left; text-indent: 0cm; margin: 0}\n    table { width: 100%;  border-collapse: collapse; padding: 0px; border="1" }\n    table, th, td {\n      border: 1px solid;\n    }\n    ol {margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n  </style>\n  </head>\n  <body><br><p>Данные отсутствуют</p>\n  </body>\n  </html>
1005	46	\n  <html> <head> <meta charset="UTF-8">\n  <style>\n    li { margin-left:1cm;margin: 0cm; }\n    h2, h3, h4 { font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n    p { font-size: 16px; font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    td { padding: 0; padding: 0in 5.4pt 0in 5.4pt }\n    td p {text-align: left; text-indent: 0cm; margin: 0}\n    table { width: 100%;  border-collapse: collapse; padding: 0px; border="1" }\n    table, th, td {\n      border: 1px solid;\n    }\n    ol {margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n  </style>\n  </head>\n  <body><br><p><strong>Hello,sdfsdf world</strong></p><figure class="table"><table><tbody><tr><td><p style="text-align:center;">sdfsdfdsf</p></td><td>sdfdsfdsf</td></tr><tr><td><p style="text-align:right;">dsfdsfdsfdsfdsf</p></td><td>dsfdsfsdf</td></tr></tbody></table></figure><ul><li>sdfsdf</li><li>dsfdsf</li><li>dsfdsfdsf</li></ul>\n  </body>\n  </html>
1006	54	
1006	53	
1006	50	
1006	49	
1006	52	
1006	47	
1006	46	
1006	55	
1006	48	
\.


--
-- Data for Name: InformationBlocks; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."InformationBlocks" ("Id", "Number", "Name", "IsRequired") FROM stdin;
55	7.4.3	Перечень программного обеспечения, используемого в образовательном процессе	t
46	1.1	Цель учебной дисциплины	t
47	1.2	Планируемые результаты изучения дисциплины	t
48	1.3	Место учебной дисциплины в системе подготовки студента	t
49	2.3	Требования к курсовому проекту (курсовой работе)	t
50	5.3	Критерии оценки лабораторных работ	f
51	5.4	Критерии оценки практических работ	f
52	5.5	Критерии оценки курсового проекта / работы	f
53	5.6	Критерии оценки экзамена / зачета	f
54	7.3	Перечень ресурсов сети Интернет по изучаемой дисциплине	t
\.


--
-- Data for Name: InformationTemplates; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."InformationTemplates" ("Id", "Content", "InformationBlockId") FROM stdin;
2	\n   \n  <html> <head> <meta charset="UTF-8">\n  <style>\n    li { margin-left:1cm;margin: 0cm; }\n    p { font-size: 16px; font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    td { padding: 0; } \n    table { width: 100%;  border-collapse: collapse }\n    ol {margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n  </style>\n  </head>\n  <body><p>&nbsp;</p>\n<p><strong>Студент, изучивший дисциплину, должен знать:</strong></p>\n<ul>\n<li class="MsoNormal">основы объектно-ориентированного подхода к программированию;</li>\n<li class="MsoNormal">способы реализации отношений между классами;</li>\n<li class="MsoNormal">использование свойств полиморфизма, наследования и инкапсуляции;</li>\n<li class="MsoNormal">использование абстрактных классов, интерфейсов и шаблонов.</li>\n</ul>\n<p>&nbsp;</p>\n<p><strong>Студент, изучивший дисциплину, должен уметь:</strong></p>\n<ul>\n<li>работать с современными объектно-ориентированными системами программирования и проектирования;</li>\n<li>создавать программы на основе технологий использования классов с использованием современных систем объектно</li>\n<li>ориентированного проектирования;</li>\n<li>переходить из одной объектно</li>\n<li>ориентированной платформы на другую;</li>\n<li>использовать возможности классов при написании программ.</li>\n</ul>\n<p>&nbsp;</p>\n<p><strong>Студент, изучивший дисциплину, должен владеть:</strong></p>\n<ul>\n<li class="MsoNormal">языками объектно</li>\n<li class="MsoNormal">ориентированного программирования и проектирования;</li>\n<li class="MsoNormal">навыками разработки и отладки программ на одном из объектно-ориентированных языков программирования;</li>\n<li class="MsoNormal">навыками разработки интерфейсов к информационным системам с помощью современных технологий.</li>\n</ul>\n  </body>\n  </html>	47
3	<html> <head> <meta charset="UTF-8">\n  <style>\n    li { margin-left:1cm;margin: 0cm; }\n    p { font-size: 16px; font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    td { padding: 0; } \n    table { width: 100%;  border-collapse: collapse }\n    ol {margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n  </style>\n  </head>\n  <body><p>Дисциплина &laquo;Объектно-ориентированное программирование&raquo; относится к блоку 1 &laquo;Вариативная часть (обязательные дисциплины)&raquo;.</p>\n<p>Перечень учебных дисциплин, изучаемых ранее, усвоение которых необходимо для изучения данной дисциплины:</p>\n<ul>\n<li>основы программной инженерии;</li>\n<li>информатика;</li>\n<li>основы программирования;</li>\n<li>логика и теория алгоритмов;</li>\n<li>технологии разработки программного обеспечения;</li>\n<li>базы данных.</li>\n</ul>\n<p>Перечень учебных дисциплин(циклов дисциплин), которые будут опираться на данную дисциплину:</p>\n<ul>\n<li>базы данных;</li>\n<li>проектирование программного обеспечения;</li>\n<li>тестирование и отладка программного обеспечения;</li>\n<li>основы WEB-программирования.</li>\n</ul>\n<p>Кроме того, результаты изучения дисциплины используются в ходе практики и при подготовке выпускной квалификационной работы.</p>\n  </body>\n  </html>	48
4	 \n  <html> <head> <meta charset="UTF-8">\n  <style>\n    li { margin-left:1cm;margin: 0cm; }\n    p { font-size: 16px; font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    td { padding: 0; } \n    table { width: 100%;  border-collapse: collapse }\n    ol {margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n  </style>\n  </head>\n  <body><p>Курсовой проект по дисциплине закрепляет теоретические знания студентов и развивает практические навыки по разработке программного обеспечения. Тематика курсовых проектов связана с разработкой программного обеспечения информационных систем .</p>\n<p>Курсовой проект состоит из графической части (до двух листов формата А2 или АЗ) и пояснительной записки (до 40 страниц текста), включающей: выбор технологии, языка и среды программирования; анализ и уточнение требований к программному продукту; разработку структурной схемы программного продукта; проектирование ин&shy; терфейса пользователя; построение классов предметной области; выбор стратегии те&shy; стирования и разработку тестов. Графическая часть может содержать граф диалога и структурную схему программного продукта, формы ввода-вывода информации, диаграмму классов.</p>\n<p>Примерный перечень тем для курсового проекта:</p>\n<ul>\n<li>разработка локальной информационной системы;</li>\n<li>разработка сетевой информационной системы.</li>\n</ul>\n<p>Выполненный и правильно оформленный курсовой проект сдается руководите&shy; лю на проверку не позднее, чем за три дня до установленного срока защиты и после проверки может быть допущен к защите. Курсовой проект должен быть подписан авто&shy; ром и руководителем.</p>\n<p>Защита курсового проекта производится перед комиссией в составе не 2 препо&shy; давателей кафедры.</p>\n<p>На выполнение курсового проекта отводится 36 часов самостоятельной работы.</p>\n<p>Разбивка этапов курсового проекта, определение количества минимальных и максимальных баллов за каждый из них производится руководителем проекта. При&shy; мерный перечень этапов выполнения курсового проекта и количества баллов за каж&shy; дый из них представлен в следующей таблице.</p>\n<p>&nbsp;</p>\n<table border="1">\n<tbody>\n<tr style="height: 22px;">\n<td style="width: 60%; text-align: center; height: 22px;">Этап выполнения</td>\n<td style="width: 20%; text-align: center; height: 22px;">Минимум</td>\n<td style="width: 20%; text-align: center; height: 22px;">Максимум</td>\n</tr>\n<tr>\n<td style="width: 60%; text-align: left; padding-left: 10px;">Теоретические исследования проблемы, постановка задачи</td>\n<td style="width: 20%; text-align: center;">21</td>\n<td style="width: 20%; text-align: center;">12</td>\n</tr>\n<tr>\n<td style="width: 60%; text-align: left; padding-left: 10px;">Практические исследования</td>\n<td style="width: 20%; text-align: center;">12</td>\n<td style="width: 20%; text-align: center;">12</td>\n</tr>\n<tr>\n<td style="width: 60%; text-align: left; padding-left: 10px;">Разработка рекомендаций и предложений</td>\n<td style="width: 20%; text-align: center;">8</td>\n<td style="width: 20%; text-align: center;">9</td>\n</tr>\n</tbody>\n</table>\n  </body>\n  </html>	49
5	 \n   \n  <html> <head> <meta charset="UTF-8">\n  <style>\n    li { margin-left:1cm;margin: 0cm; }\n    p { font-size: 16px; font-family: 'Times New Roman',serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }\n    td { padding: 0; } \n    table { width: 100%;  border-collapse: collapse }\n    ol {margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: 'Times New Roman',serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm;}\n  </style>\n  </head>\n  <body><ol>\n<li>Сайт1.com</li>\n<li>Сайт2.com</li>\n<li>Сайт3.com</li>\n<li>Сайт4.com</li>\n</ol>\n  </body>\n  </html>	54
1	<html> <head> <meta charset=\\"UTF-8\\">  <style>    li { margin-left:1cm;margin: 0cm; }    p { font-size: 16px; font-family: "Times New Roman",serif; margin: 0cm; margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }    ul { list-style-type: disc;margin: 0cm; margin-left: 1.8cm;font-size: 16px; font-family: "Times New Roman",serif;margin-bottom: .0001pt; text-align: justify; text-indent: 1.0cm; }  </style>  </head>  <body><p>&nbsp;</p><p>Целью учебной дисциплины является обучение студентов методам построения сложных программ и систем с применением объектно-ориентированного программирования и проектирования.</p></body>  </html>	46
\.


--
-- Data for Name: Inspectors; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Inspectors" ("Id", "Name", "Surname", "Patronymic", "Position") FROM stdin;
\.


--
-- Data for Name: KnowledgeAssessment; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."KnowledgeAssessment" ("KnowledgeControlFormId", "WeekId", "MaxMark") FROM stdin;
2	1120	5
\.


--
-- Data for Name: KnowledgeControlForms; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."KnowledgeControlForms" ("Id", "Name", "ShortName") FROM stdin;
1	Контрольная работа	КР
2	Защита индивидуального задания	ЗИЗ
3	Промежуточный контроль успеваемости	ПКУ
4	Промежуточная аттестация	ПА (зачет)
5	Промежуточная аттестация	ПА (экзамен)
1000	Защита лабораторной работы	ЗЛР
\.


--
-- Data for Name: LessonWeek; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."LessonWeek" ("LessonsId", "WeeksId") FROM stdin;
144	1120
\.


--
-- Data for Name: Lessons; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Lessons" ("Id", "Number", "Name", "Content", "Hours", "LessonType", "TrainingCourseFormId", "EducationalProgramId") FROM stdin;
144	1	Работа с каталогами. Сериализация	\N	2	1	\N	1005
\.


--
-- Data for Name: LiteratureTypeInfos; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."LiteratureTypeInfos" ("EducationalProgramId", "LiteratureId", "Type") FROM stdin;
\.


--
-- Data for Name: Literatures; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Literatures" ("Id", "Description", "Recommended", "SetNumber") FROM stdin;
1	Основная литература 1	sdfdsfsdfsdfsdf	12
2	Дополнительная литература 1	Гриф 2	4
3	Основная литература 2	Гриф 2	sgjhsbnm
4	Дополнительная литература 2	sdvfhdsf	sdfsfg
1000	Описание1	Гриф1	3
1001	Описание1	Гриф1	2
1002	Догадин, Н. Б. Архитектура компьютера : учебное пособие / Н. Б. Догадин. - 4-е изд. - Москва : Лаборатория знаний, 2020. - 274 с. 	Допущено Министерством образования РФ в качестве учебного пособия	ЭБС znanium.com
1003	Партыка, Т. Л. Периферийные устройства вычислительной техники : учебное пособие / Т. Л. Партыка, И. И. Попов. - 3-e изд., испр. и доп. - Москва : Форум, 2019. - 432 с. : ил.	Допущено Министерством образования РФ в качестве учебного пособия	ЭБС znanium.com
1004	Горнец Н.Н. ЭВМ и периферийные устрой-ства.Устройства ввода-вывода:учебник для студентов вузов. Н.Н.Горнец, А.Г.Рощин.-2 изд.,стер.-М.:Академия.2016.-224 с.	Допущено Мин. обр-ния РФ в качестве уч. пособия для студентов ВУЗов	5
1005	Горелик В. Ю. Схемотехника ЭВМ : учеб. пособие для вузов. - М. : Учебно-методический центр по образованию на железнодорожном транспорте, 2007. - 174с. - (Высшее профессиональное образование).	Рек. управлением учебных заведений и правового обеспечения Федерального агентства железнодорожного транспорта	-
1006	Цилькер Б. Я. Организация ЭВМ и систем : учебник. - СПб. : Питер, 2004. - 668с.	-	2
1007	Калабеков Б. А. Цифровые устройства и мик-ропроцессорные системы : учебник. - 2-е изд., перераб. и доп. - М. : Горячая линия-Телеком, 2007. - 336с.	Доп. Министерством связи РФ	1
1008	Костров Б. В. Архитектура микропроцессор-ных систем : Учеб. пособие для вузов. - М. : Диалог-МИФИ, 2007. - 304с.	Доп. УМО вузов по унив. политехническому образованию	1
1009	Гук М. Ю. Аппаратные средства IBM PC : эн-цикл. - 2-е изд. - СПб. : Питер, 2005. - 923с.	-	5+
1010	Гук М. Аппаратные интерфейсы ПК. Энцик-лопедия - С-Пб: Издательство "Питер", 2002. – 528 с.: ил.	-	2+
1011	Партыка Т. Л. Периферийные устройства вы-числительной техники : учеб. пособие для вузов. - 3-е изд., испр. и доп. - М. : Форум, 2012. - 432с.	Допущено Министерством образования РФ в качестве учебного пособия для студентов ВУЗов	2
\.


--
-- Data for Name: MethodicalRecommendations; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."MethodicalRecommendations" ("Id", "Content", "Link") FROM stdin;
1	Борисов Н.К. Объектно-ориентированное программирование. Объектно- ориентированное программирование и проектирование. Методические рекомендации к курсовому проектированию для студентов специальностей 1-53 01 02 «Автоматизированные системы обработки информации» и 09.03.01 «Информатика и вычислительная техника», часть 1. - Могилев, 2016. 46 с. (56 экз.)	sdfdsf
2	Борисов Н.К. Объектно-ориентированное программирование. Объектно- ориентированное программирование и проектирование. Методические рекомендации к курсовому проектированию для студентов специальностей 1-53 01 02 «Автоматизиро­ванные системы обработки информации» и 09.03.01 «Информатика и вычислительная техника», часть 2. - Могилев, 2016. 46 с. (56 экз.)	ssdsdf
1000	Методические рекомендации	выва
1001	Столяров Ю.Д., Прудников В.М.: ЭВМ и периферийные устройства Методические рекомендации к выполнению лабораторных работ для студентов специальности 09.03.04«Программная инженерия»: БРУ, 2021, -48с. 	-
1002	fhghj	gfhgfh
\.


--
-- Data for Name: Positions; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Positions" ("Id", "Name", "ShortName") FROM stdin;
1	Ассистент-стажер	
2	Ассистент	
3	Старший преподаватель	ст. преподаватель
4	Доцент	доцент
5	Профессор	профессор
6	Заведующий кафедрой	зав. кафедры
\.


--
-- Data for Name: Protocols; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Protocols" ("Id", "Date", "Number") FROM stdin;
\.


--
-- Data for Name: RefreshTokens; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."RefreshTokens" ("Id", "Token", "JwtId", "CreationDate", "ExpiryDate", "Used", "UserId") FROM stdin;
17edd9b0-be33-440d-a358-b8ab035dcdbd	A82vAJSiJtmabgxSlqDwA9sLWISGh+6MQ1EhhGtmV80lqxhiFOfrPUn5GTCtIsmozUKsbvoIm2EA5UPouwscDg==	848faf72-9823-40e9-8238-aad34058b1cb	2022-04-27 21:47:35.587781+03	2022-10-27 21:47:35.587889+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
d7780395-6870-44ea-a613-e0761d7456c9	6HViSvPIri/FEKCoCgSQYAAD1v3LNjx+okUrc6QcxSSb0ORR87TJpy+tdDH7Emf6nDSyTgYgTOS0kBKBJkXoQA==	3371c987-7731-4e8f-9bd0-cc92b181d30d	2022-04-27 21:48:01.73788+03	2022-10-27 21:48:01.737881+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
3cb9fca4-585c-45d8-9d1a-de2fd8d95bf3	fLI/sg/TwNVNQgDRiUw/jiZio45tfKMiRrxi+q1vKOw2tVL4xCUDPogWq0W3vo+vpfdmQ6oO2HRqkLUBl6awfw==	580905d4-c426-406f-88e8-19f8ef0103f5	2022-04-27 21:48:14.660748+03	2022-10-27 21:48:14.660748+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
1471cb79-deac-496e-ac13-6b5ebd2d45fc	HX0dEckQJciyu2Wy6YgShbFOwgvVXp039f+dbgsDEJJhWgS6o88QHvA0+Q1VPujQURZkQCjXW0CkvvB97cS9Kw==	e1473008-5c7e-45a9-b6b8-a35b67061cf0	2022-04-27 21:48:26.484195+03	2022-10-27 21:48:26.484195+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
42e84583-a755-4c37-948a-cf15e2835a7f	h+CZy9VTt6xUazKWHRoxRGBTMexNxd4Fhdw1ENW67ata6yEyQFD0cDIgXbmDjPgww8o5cw9hWIaxRcaGSVylKA==	7b67bcd3-38b7-402c-bab0-313032542491	2022-04-27 21:48:42.526649+03	2022-10-27 21:48:42.526649+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
5bf5537c-b18a-4480-bb8c-5a66b549d939	wnCeuOBhs7+niaEcaR/LdBDWT0SY1hoNEoOsf/s+TKcnAqKgM8/KYqSzmE9Slyejkoq+GMy6Ys8xTdED5rOeXQ==	6a4cf80e-1685-4f86-986e-543b4232e5bd	2022-04-27 21:50:21.458409+03	2022-10-27 21:50:21.45841+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
74db6924-2849-41b3-ba4a-76e07d5dace0	N3M/XMO0ATJocC5yEVDDVG7QGGb4qzIeP3IHOIsMadXY/o85BtJ2npoSRzR4FoX4GlJ+R/E7sfXEU+uNKjhioA==	d280e401-10c8-40ad-8544-393962cdeb18	2022-04-27 21:50:33.853729+03	2022-10-27 21:50:33.853729+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
80fb7013-3efc-41be-96a5-f9336c9b9c81	idEwpMEwGz9GrPkPwqh7c8oRHPMj+uM5amPst3d2CgXdYnwURqdEJF4ulX+RFIExIDxPX1CaNzVCfeVGhPXC5Q==	84af6f3e-6a68-42d9-80dd-c941448a14d8	2022-04-27 21:51:56.872304+03	2022-10-27 21:51:56.872351+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
17ac41c2-ae29-4387-9749-ae0a776903b7	nygS754AaFVx6MX6rjbWfHq2/cQu1I7AV2BHNNn3n6zWziRVVrLcTcTAi3WLypSy39TVMrWhT1D6GAYQ5tNW9A==	50c73c5b-0dd8-4c47-9b3b-38199f5a9601	2022-04-27 21:53:08.030405+03	2022-10-27 21:53:08.030405+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
7476f9b6-b0dd-4b08-a910-be26207a63e7	NdVK9/CM+PTNAA8azJzUAzvPsc9HZc6bdnTbUpenwFOkTxYmi0c7Pxd3UB73dLjc+diG0rt5eRa4OIKBEvrZWw==	451f00e3-b0f7-435a-a6a1-a6bb313f0451	2022-04-27 21:53:16.607517+03	2022-10-27 21:53:16.607517+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
3f3f8b54-1f56-49f1-a2ab-0e3fa34e4062	5O9A2qtp9u2QeQkwkekf+1rgpcSYzUn8Xm/SsJwVNl1Z/6gkZFI9ll67p07UgUOR304h2kP42J7yQsf7DQO0iA==	3e027c20-f127-4e62-8bd9-7ca33cf4ff06	2022-04-27 21:53:53.146648+03	2022-10-27 21:53:53.146648+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
dea54d3e-4cb0-4e8c-989a-593271a61c8c	OFG6CnCU9VnRJAeAzyHINAy/puLQRTHpb1TpCskOSCO8I9jVRQ/7MmV4FnO/mpCTgYUb3Q70OW+TWyjHRVK23g==	b504e602-645f-4305-9b6d-c9c44d4e4b23	2022-04-27 21:54:49.165171+03	2022-10-27 21:54:49.165171+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
a3134d71-d510-4362-a99c-a03c0c503ae0	42S4rI9bNF4Zi431r/3W00KvI/e2G6kleld+QVYVd9akJ5w70+Ad/EqYdJryiNr9ePo8mzvXV2N1pd68mfSwgg==	42f3a006-284a-49f9-bcd4-c7d2561dcdc3	2022-04-27 21:54:53.586953+03	2022-10-27 21:54:53.586953+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
38d78ad4-2391-4625-a7e3-82223bde03b9	TBWm+cLdgPXq/qqO86FWfefO+cnblzyALBL3UKzor1xlC3teDTvd+bU+mhiXDzBXiNRXiWeunSXnGj6xvEiTxg==	e1c713a5-9393-478e-9f53-e2a74f7a1098	2022-04-27 21:55:17.976994+03	2022-10-27 21:55:17.976994+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
3c25c7b9-53b2-45fd-9361-795682e65a70	8feDa0lXNpJNxBGJ+4iJVj/OqbfhpwmZ3487tziOy+uHkEMzxEDrpupDskeHYF+xWPMDLa/+DOQd53uz7HiXCQ==	72cdee06-7e1c-41b4-8db4-07d51b5e4383	2022-04-27 21:59:15.903137+03	2022-10-27 21:59:15.903138+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d447dba6-ad82-44b6-ad31-d35e7ef4f14e	hEmPB90e0geSHOypWG16cAdT/gQv2HuFHWiyQ8h1U0n5rILklD5qTiUvyg9HkaZNlY909nFXTJ7MDKSVgcRR5g==	abd936dd-f1d4-4773-a408-717341840966	2022-04-27 22:09:21.472103+03	2022-10-27 22:09:21.472176+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d0e254aa-2db8-4e22-ab9c-b26bfb562cd7	oUOtNqbYN/CeDtrmu0eliGB1nqv1d/8akI9S//bh2Eoaw4UBWR+pZkyHelPfOnC3N4SRs78mLLxy7ISOqRp3Ig==	92a39f65-719d-432c-b1e1-f62a5fc1a164	2022-04-27 22:09:25.197639+03	2022-10-27 22:09:25.19764+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
49395701-64c5-44a5-b470-e86213825c65	QFjLjACmCayp12qBkYPbZzJP02XmktAEDjUwjlTmYa8ebPlRJ2hnChAgzNm0BTdlUfbRczBhnlbbyxqbZuqLaw==	b1c47025-d090-455c-bc62-4d8d9d86c275	2022-04-27 22:11:21.576009+03	2022-10-27 22:11:21.576068+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
c5f3c405-d487-467a-ae76-62d11a2b3780	MjZjiNGXmXMyZPopFVJl9pYcjjMq6LqBAGl9eaABfwKMn8B/S3ETIvWmZYYTT4vMpHoi0sIwyWo1sVCwi7JTuQ==	e8eedf9a-51cb-4344-b30f-3e05661098af	2022-04-27 22:11:45.938595+03	2022-10-27 22:11:45.938595+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
efabcd12-d573-4356-acbd-adb419cb5033	M1Ao5reusZxhlnsxrLl3zjiXw9eCwjcQ99Q9RaJmA9oTKmyWStJZ1a+TlAmwbDT3E4cv45rKoFEmLfk48mFMiA==	03d98bf1-3502-411e-afa8-e30611f1e616	2022-04-27 22:15:32.042507+03	2022-10-27 22:15:32.042555+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
942e4fd7-eeec-47bc-9eab-dccd57a61f85	0P+W8Y1WNVqPrE30ZssgNw6GK1f8nLlCqtiIWhSx92DXnLzdeCyNPgAwLRuVNaaarHX+Ibv9wFEiOrISgEPpzw==	91c327df-b2e2-4f4e-aaa8-565c9fae0fbb	2022-04-27 22:17:45.809452+03	2022-10-27 22:17:45.809453+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
c7f4a1dd-8ffe-4006-85eb-f5809fc3fee7	jqc5pby1i2k0Ur8Gz1V5lYF6/PM3dlR8/Ss+9hRFr8sOku5VlHhNUH+8EvWeFoJDw1Gs4dl+LsLaemMSesQ0iA==	f2850111-4e60-459b-9316-11e51192d6ed	2022-04-27 22:26:52.916784+03	2022-10-27 22:26:52.916806+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
1532733c-c8ed-4b2b-891c-950f20349e25	yIvNUIclVhy6gbRut9GgZm7GA3ZRTngorkBWv3aLeY3kzt7ArfHdGr+bBsRyIhFLgiQZ5jnJvMDNzWjylSu2BQ==	16072933-a3c0-4db5-a120-11674ba5f01f	2022-04-27 22:27:33.397786+03	2022-10-27 22:27:33.397787+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
ed0286bf-a774-4c8c-b957-fca6ff1a567f	g6ZMIuOKSCKiJ4WIUpRByWx1ayKVaObwUJQUsnCp2jozMVP7XHWy3BRMEPEP/zmGKclmrKbY2pw/lmYPz+/9Ag==	9225990f-007c-4f77-bc46-010f03c353ec	2022-04-27 22:40:53.547629+03	2022-10-27 22:40:53.54763+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d49b74fa-b117-482e-9093-7edad97be0fa	b6KOFtZhPiAAmJRdkgfsCQrwxAEzWYF+RhCVP2fZB1HTNCQy6JgHwggSFhy7c3C5cP98MLNNwd82J745LfurrA==	5343f3f6-ca9b-4f25-a61c-9e2e25f0d385	2022-04-27 22:41:34.291732+03	2022-10-27 22:41:34.291732+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
09a46243-3998-4ccc-a88d-665e3a9a9775	OQrKq2e7gQO0y4w74FwqE2GrpwCNUGI/m9CCsHJAGKX3J33Zc492ceQBR5h6YvB3iwQGYAlqwJwzgl3khA3k5w==	731b5484-8a00-47ba-b775-51ef6d8ead5d	2022-04-27 22:54:54.51223+03	2022-10-27 22:54:54.51223+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
05dfd400-052f-4f64-9a5a-571027760143	Iexc2FzFNG2QDAQDgFL7Y5BtrybeSN+5+Lm2rLun1RyomUBJ7IarghYyZZX9Bpn+h7cvlg48Z2TFUSc2b/TcEw==	1d09f062-26a5-4097-a6fb-1247ba2b7660	2022-04-27 22:55:35.344333+03	2022-10-27 22:55:35.344334+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
ecc350c5-7eb5-4a62-801a-5cf82c60b68a	6JIFYZJ0zkhJw+WojV3P1f5q1kf0iOadwMPE3GFaOdC4M9YqojBk/o1muxn5qEQTPPNQagdNJfP9d0Z7VYW1IA==	b7d97106-9e4a-461f-8282-15a93845e193	2022-04-27 23:08:55.431835+03	2022-10-27 23:08:55.431835+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
b5e191e9-c461-49a3-a0ca-49bc5f903286	w1Et2Hh52JUUGUiu6sEg7rPZaLoL4MhELByqgNEV2863MjhoOTVJsNnDqMAad1LrVSLbbCFWo9Jm/d0qAnngbw==	d6312853-eaee-4306-b76e-1fda199e9352	2022-04-28 12:46:49.873523+03	2022-10-28 12:46:49.873544+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
c86851f8-fe13-48ce-b574-c50a4d6eb800	W17oEQajLM6PQpE+snmyVCYW0RWt6g4PKu62MIPiC+6oHquuNt0z37SrmAMKOttVQjpj0S/fXBE3YwoFfOzJVg==	8ffc44ba-cdd7-444d-8416-1584fb04cf22	2022-04-28 13:00:51.214093+03	2022-10-28 13:00:51.214093+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
67329b9c-e165-4a57-9d3a-f31d9a5f8125	anCG6THSEqJCfGDOWQBaVCXrjegwd4/ru/bCnSKgF3uw+FsMfyxxa5GVT3oZr1uEUDgJHfOJx2B7bLnQLtSX7Q==	3c535cc3-1f95-46df-aab9-dcbb6126364f	2022-04-27 23:09:36.291517+03	2022-10-27 23:09:36.291517+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
6bc1cb84-8dd1-4209-9955-341e98d5f0b5	P9DODXZhg357oamMio/zFw+TOW+KUzJVFWShJvkN73bDmdbVFuaQXzjm5y56u9rJNe50In6c9jpyx1RQWdQogA==	838bccd6-6d1b-49a9-b12a-7a0a80804973	2022-04-29 19:20:36.424929+03	2022-10-29 19:20:36.42493+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
8cc66efa-a5c6-4bd5-a8da-0d53cd4e8416	1l4qSR2ial+cb0l9LEvOWw6AOX7YHR2R6ApRD+wVx3ONhLOfzQwEJcYl8DoAZGh943zjXGpT1xPGXpARpk9+dA==	d2eac0bd-fc98-4ec0-9ada-85748145defb	2022-04-29 19:19:58.601637+03	2022-10-29 19:19:58.601738+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
a937a495-de63-4cb4-9a10-fe0a2623edf4	vTyhBgee6BzJSuONm5n0xdM8LQNF62RvaP6NVtiNXjef+77U/sJwukUDI6+nkqoDG2NkM2TJbyAJlaIa/2kKNA==	1baac229-84fd-47db-a391-8dc28b467166	2022-04-29 19:16:12.553388+03	2022-10-29 19:16:12.553421+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
9679c229-35a7-405a-a2ef-800cddc25dcd	TrSEJHP48vuTd38Q2VG03qGocxxmUEhnV8e2C2l8YoH9LyBtRotieaKBa0YEu4DHOMaMrkWxXK4xkKd3foRCvQ==	18017066-c371-429f-8afa-ef788d9a760a	2022-04-29 19:20:42.489045+03	2022-10-29 19:20:42.489045+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
752c4043-5385-47b9-ace4-22e4f2108343	yWtNnPn5QHdSsEYR1Su6xhWUzUyvyh33tN1sY/y70tlsORKiqPf2qhfKaDjlESV/ABE08+67hZ1k/FX54+qwcw==	361f90ef-ef87-4f4d-b3ec-495efcbef7a2	2022-04-29 19:22:23.814432+03	2022-10-29 19:22:23.814432+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
526c354b-a377-41b0-bddd-258515fd9754	FRl1BQlv0NNFy2+pEY+Bpy3LTAOtNySwAppUb23TUnGLCTQ5KEr8DydzDnyHWI4CAl5O5LCFRaCdJZIt5xUF3g==	0a3cd799-0895-47fc-a1f3-d59f5c46df58	2022-04-29 19:28:06.513189+03	2022-10-29 19:28:06.513189+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
21a2e354-a204-4e4e-ad8c-c83c446ea152	r2+bizlz5liC7fhg//t4EjBKlQV9vkHS3TIMefVk4AvTjSxRuxC5PQBkslCe6KpIWpqo4/DW3k8pjx4JoRzgMg==	7c6c0362-0066-4f23-abc2-7000597f5b32	2022-04-29 19:22:23.924958+03	2022-10-29 19:22:23.924959+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
0db7f085-e268-4887-a0e9-bfaefbc88793	02zYmCR//WpS1RDan620sxVH7M/N61rv99eWdORMVHR4HM1lrssJ3NAl4ej+WTgNW8zpKcl2GnGMLFiQV9SoXw==	6c6410dc-a293-4914-8e06-f80fca18f2a3	2022-04-29 19:24:29.602952+03	2022-10-29 19:24:29.602952+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
18b5a005-ab1a-499b-9a58-70f3465f9d5c	ElLiYwnwuY9/1c9F6Yhq79Q+GBl4g+8hlcZfKLmd21nG/w+OVXlHbVJg6kU+BPTXNu3m3Vp34X3irkhArrcFTg==	0e5b343f-34de-4e43-8b44-72c246e5fb55	2022-04-29 19:24:29.76202+03	2022-10-29 19:24:29.76202+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
c77c8bda-4633-4fe2-9284-6d31f2f04a60	QQv2JpwBxPEqxHpPDfD/JVWVX1tDOCKPHO3UzjtFjiM8gUn9b3vXTnzG64cWi4yhD2kDEUZUavDok5BtL2oHcw==	eb7c24c0-4e86-4921-8c55-fc468f748ae3	2022-04-29 19:30:14.499097+03	2022-10-29 19:30:14.499097+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
a48db6f9-d501-4844-88bb-e955b39f08ec	8T1cZVJ4txpBcZRwOeJ2bU76WL8trkTAyJh0oynofVmf69JSkC+2e7pSez2IT/Dj15gojlYKdpRxbXNamBiLjA==	2e12848f-280f-468d-a5f5-37135caf8b64	2022-04-29 19:28:07.478951+03	2022-10-29 19:28:07.478951+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
932e5a2a-adf1-4c91-9b5c-4c1e7fd7f69f	nQCfMd39N8VKcIcvyXVTrzPpvWPLUnezeaIHOOkn4h2Q1N394GItJtMC0mmf4RBiJBAZUVz1SCz6osvqm0pt1Q==	1281ed5a-b16c-480a-be96-d55eb95b8808	2022-04-29 19:36:42.863558+03	2022-10-29 19:36:42.863559+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
b89207d5-bab3-4ee5-9585-8bc7b2a424ce	jI6zVKD7Ln/vRLAqwXdDLP2RMDkdjWzYmLDoAx2plTpMZOzwzUh5vWtWWe8DjPD8cEUzezXkSCjBvc0smquOBQ==	1f06d598-cd6d-4bbf-8448-32eb41f48f86	2022-04-29 19:34:51.95177+03	2022-10-29 19:34:51.951791+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
dcd3c36c-fd0b-4b8a-bff0-2b7e01a7a8a7	pvAyypVKVAzytiS04bdTtkN8Gd5KL2l5BUqjJubB0LTjyX6FKafPStyumhvazauhMN3a6otocO4GL9UV3uY1bA==	0b913e3c-ec70-477f-87a1-ee88a40a5a8c	2022-04-29 19:37:02.328076+03	2022-10-29 19:37:02.328076+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
bf6be7ef-323c-499a-8d9c-4a3b88dccf63	w7Rg2thZ5VKqRc7vq2PisRlVMyF1EWQCLE8LP4FkjHYtHPqtjhNElXrSzIBx6mdnjiQcm6EoGutLuKFdJTYjoQ==	6eaef8bc-4bd4-4df3-96e3-cd3355ef36de	2022-04-29 19:48:53.503782+03	2022-10-29 19:48:53.503782+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
1ae31a52-fb4e-4c99-a6eb-deedc4841a6d	1RWHzKxW7iclMjYqRzbmj6qh2EC/ns8xbz6FjGOBzWGjjT4DekxWu1h3wC2DCoaF98eYtut6YeYNB+iH5Wvxng==	2b90522e-4c8e-4cdf-b50b-e5a336484a00	2022-04-29 19:51:04.514328+03	2022-10-29 19:51:04.514328+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
39fbe835-ccf8-4eb8-beb2-fedd8af8d229	IBsqPS0DTFbkTHDMGoz76ELrPnV9QUwB9PmVgaPUhsQ05+21HMiybpPLCntm/GYDLcPBAQekyT5zDQb69OvBFw==	c75269c5-2f0b-4905-8ffa-17bcae3d0a2e	2022-04-29 20:02:55.661687+03	2022-10-29 20:02:55.661687+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
2b63f05d-4345-418a-a4f2-aa70a7411bd6	TdBZps4VjvNWc7hQWinQjNh1j8dl9BhK+F7pkt3ofTafzVBvk7bX9M2q96Bd52E6Z7H5VqWJOz7RZ3nKcCrkoQ==	04c625bc-8fd6-41f5-8e56-399792956899	2022-04-29 20:05:06.504786+03	2022-10-29 20:05:06.504786+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
95f42f2f-46b4-42e4-a8b4-a92cf8f8fe50	dLpecGeaS5ERgS3YUQty/VKhmMLhuF9ILH93L0ewA4Lf+q2BejZKd/0weGSUgOv3J313HlYC8RAISMMqVb70HA==	a452b268-0f09-4edd-9cd6-edeb2965d505	2022-04-29 20:16:57.523318+03	2022-10-29 20:16:57.523318+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
08bf97e7-2e0e-4535-b72b-68abd074f6ac	uaNtuYX0N1cXW9EZ6o6+1EF0/nMZRR8R7Fetfs8yYSroLQ4nEc5umwHreP3rJbdbOYPUSBRZE0wJ36S9PwZJ9Q==	af6c7bef-189d-472e-95c3-02a9d14ac5fc	2022-04-29 20:19:08.497196+03	2022-10-29 20:19:08.497196+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
5c8b9ae7-b1ff-4693-ae7c-1acd98f8e055	W+JlEzPUeG4CSK7bAGoKxsCUJlA9jrexMAaFiNpXH9R9WHm7PM/0oqFKNDE4GGgGzSo3TKDofmsKMq4IhFNxNw==	9d519cd7-d67e-4225-82ce-ae2d5c1f7045	2022-05-03 20:53:53.77033+03	2022-11-03 20:53:53.770366+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3bde01d5-e8ff-4a8a-b02b-79bb08637ba4	ZGY9EdQcy3LH2T7a3YqKS1N4OjmPT2Xkk0XVCeYN8Yne/dEVMi9M2jXjjG+FPHlUPggdwSwVNXeTgfE+ZF1Ofg==	75c75ad6-b9e2-4f0a-bdd1-00d797851538	2022-05-03 20:55:36.261216+03	2022-11-03 20:55:36.261216+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
de00aab6-ab7f-492b-add6-50f9a36f6c54	fT6N3E3dlwCGykEeTDxAx8/VtOqPp3Op+C3FPzIem4S2qukVw9CQ1bodpcDdGUkW5NIQLgFbANIwFXDIbGaIkw==	aafe7c98-8d50-4594-a90c-81df6c9d4879	2022-05-03 20:56:49.962217+03	2022-11-03 20:56:49.962217+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2f665672-51e2-49e9-90df-896547f52b18	Ub8pqhxxSZnjTn8PHVwj1MH4Ql8GdkOVwBMZ43xpsdQ9D9ITGc8pS5xTSA7astDa/5OPO8JSjlOoAtwzozQKWQ==	80d4107b-8b89-4eeb-8088-8e61d95da0f6	2022-05-03 20:58:41.780866+03	2022-11-03 20:58:41.780866+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
eae95506-68ce-49f9-85cb-7f07e904661e	tUVZaJ3t0R3CkWPF85FQLcG5s8PXMIUntaWLp5xMzSf4vfwuixLrS4Xc/rosa9MLKhgNXkq10WseydZQ6QsBGw==	eda27e3f-86ee-4433-9b37-a8f74a4b4a34	2022-05-03 21:00:09.112625+03	2022-11-03 21:00:09.112625+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
4985479b-09cf-4d9b-a24c-6e9f7fccb292	5DjO26GCC/c9Mb0kKYWr3IMIpzrBqBwbnAR4ELsdv61o3RO+dAvxIliFcViC1xL2/a4CDS0FbjpzY94Annl5/Q==	31103aa1-01e2-48b1-b3fa-7b46ff6becef	2022-04-29 20:33:10.49609+03	2022-10-29 20:33:10.49609+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
daba07ab-27c7-46dc-a992-775ff8003850	lL+rFgO2xrtbvHN5dNNFmR/kLunbI+svI+vEJh1sIZT0Yg6MCvBB/ak0Owfm2/iQ0iJZy7kGPJr130IbnCgHNA==	7b68cfaf-78dc-41af-9b0a-70f4f383ee80	2022-05-04 17:41:33.287706+03	2022-11-04 17:41:33.287728+03	t	acb7c30e-5427-4ac5-9298-2834f21a0c16
5ef6bb68-8297-4789-a2ca-593810d61db1	Vh/pje5m92vlddp6xaXL/J1Wlhc5xEl9++Px3j3YL/12oiHx4Eklc6sS5gIqsXyY/rWQArAN6gE9clA8j1vXMg==	f9f6c192-68f2-4acd-a1bc-9e4aa6d576ca	2022-05-04 20:53:51.836007+03	2022-11-04 20:53:51.836029+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
1099083b-8917-4316-aba9-79353f8b221c	bDlFayv7h51z5nLOUH5g1nzhSIRzHrKzobJxQVrs5Bg67SKAP/h37IXRXbmo4l+bt3MxogbvgkzLYAYO26UtsA==	12702067-1956-4ebd-926d-24e7a34f9136	2022-05-04 20:55:09.818139+03	2022-11-04 20:55:09.818139+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
33adcb42-cf1b-4230-b49d-918cb8d932d0	/NBzkoyTYOTTpzbWi2oweARcDplgVAJFC9yWkFOgsuazBdkYlTo7VeNon7YeUx11UBtZTmgRFM00PctUkz2jlw==	f26ecb9e-8e77-4ff2-9b56-dd6d04e6f451	2022-05-04 21:12:23.576006+03	2022-11-04 21:12:23.576008+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ac99dcc4-3c99-47d4-8182-46ef77e8e84c	1CIh4rNyhd7sNdq6FCcWLWn9R+iDteCP3xLcWpAb6IM9KDOJOY/7awL2VgNIgX6xX51ZwuAJvs7PiZvFqeQHfw==	dbc03476-a8f4-4a03-980d-cf28027f717f	2022-05-04 21:29:37.608056+03	2022-11-04 21:29:37.608057+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7a64a4eb-72be-4305-b09b-56f7de62486a	ev9e3ztd0QpjqY51T3CXamhsG7QDaNOewGfKdH1OyG5eDvu2jXc5zB0P6aFeqGmhoZiMNQMmuf4m31JgcAgnvA==	e755a040-5fbf-4a09-948d-40bc33fbaddc	2022-05-04 21:46:51.503937+03	2022-11-04 21:46:51.503937+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5480d82e-e6d9-4505-bf91-b93484672ca4	+HeI9qQYoZ0EtR0QMw1gsklSmWFKWmiWU1pw5NJjTr3yslgvxFcsuGdGPT7blF5PHXvREw+FIz3zD131dyn+4w==	9a7bc76e-8f13-439f-9915-c96049248b26	2022-05-04 22:04:05.550763+03	2022-11-04 22:04:05.550763+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8b0c4f1e-248a-4644-b363-fabebe3a5671	zPp7hQqCsPW7Q3bteuNX+1NCesyMmaM156UGvnE/fJPzL8mc/Eizq9wUXvK0AefJZwW7AnqjBh2mfDKPf+TZiw==	e2edd0cf-19b7-49ce-b5e2-81c1885322ce	2022-05-04 22:21:19.318272+03	2022-11-04 22:21:19.318273+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
be306a79-895f-4466-b9ce-368c63747306	pK263cWTW6qB2/yGCLK8RNDeK4/BrTgMT+83DytlYZRjLBh+JyAWDPg6mVdGwVa14ooV7cNqpn3c6Lsdg8ikqg==	92d2ef8b-eebc-4d7b-920c-93e868ea66e1	2022-05-04 22:38:33.350065+03	2022-11-04 22:38:33.350065+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
19b1dc44-c780-46e1-8417-6c5c7efde419	joeFh1ZXRDsLuUqDsh3mutT9FH3iD2QVwS2yY07ZxYpJVt6mVjVK4HrFLGinXiUtPjXLBimcERrsc9WRFkxtyw==	b87bec11-9c3f-480e-a5a5-30af5ae3edae	2022-05-05 20:45:22.650763+03	2022-11-05 20:45:22.650793+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
915a94b9-1e8e-40aa-8fb9-e3fc04b12a89	+LolkBx7RE9LBE/WapVkQ+73IEWaPAODtn8wJjxIDpNniAyYm80sQOW4t/ZCJoGWS7wmU/Hc1fCoVzkXxbdpbg==	5256e495-4dc1-4484-a831-46bb95a95e5f	2022-05-04 17:41:51.469472+03	2022-11-04 17:41:51.469472+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bcf7daa3-b1de-41ee-b812-d6201f75b39f	7RD+dbXzn57EYgzD52AvjuP2FoBYfb9ulFMm1X165CcoT/7QSM0D5vnNjoJDb5zpitJvmPDepBuovdD8M+MM7w==	11f1c87c-78b8-4e8b-bbeb-f43595983caa	2022-04-29 20:30:59.587049+03	2022-10-29 20:30:59.587049+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
2f509337-0028-4d91-afe6-18061d2b1a11	uVfYstV+JYYuV9kvHwjGGeMeZ9o17qZIcE+jC/YXlbQjrvLo/dTEWoCn+W9wPh8+UU8XJxp3P3oFEmZU+jdKlA==	02de37f8-6c3a-46e5-abac-369de5b71fb7	2022-05-05 20:46:02.38947+03	2022-11-05 20:46:02.389471+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
03874d10-8489-4781-a589-7c0f3210ef84	mRJrBgNylIdGZvL1LcbwlK2nAkzPMaNkztiQKz3frqi07zJflo0jpyonopPL/NXAxpRiphKE8lDSaO3vWte3zw==	16548d2c-0f92-4b27-9e9b-59f709d0a24c	2022-05-05 20:46:52.766838+03	2022-11-05 20:46:52.766838+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e0764335-cba1-493b-ac93-eb2ccca3d025	616/w7hbsBDMHElEgut38MzDih02diNRAHmsxrSu8GilAuxKERZ9X0Dr/kRs7EyP8YfJ/uTwz9PmDQJmeOw9HA==	63304eb3-db53-4c6b-9cb0-e5067375283a	2022-05-05 22:13:25.430812+03	2022-11-05 22:13:25.430841+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
9bbf8961-138d-4cd2-a3df-75155fd48645	qqbnLdPV/zFslZcnknFHUzsiV7k+P3yn6DXh/6KYawSdrRbuZE4W32EoLZ4mK0vJWRYfYTcsZFWYsqra6xR4Ag==	4fecbf22-7551-480b-8b32-0722aa532831	2022-05-14 16:18:30.934509+03	2022-11-14 16:18:30.93453+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d96333cf-1315-4dd3-acc0-607f89dd20d7	jdq+8m81SyjMmJf7t6EEewEkUppQJym/QUT8crtPcoUhzcFbJ0Bk0+j578LVaxF6j+6D5gC2m+j9JMjlfD43dw==	9393c273-5432-474d-b480-841c6cb81070	2022-05-14 16:19:59.337909+03	2022-11-14 16:19:59.33791+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e28c21e2-f198-4dfe-8ed4-77a1acc97dea	mulci8lzKQORJHCyuyMKw0tHCyiCv4E+l/Fdzcring3xLbCoAd0jbmRpOf2ElU9H29OPOpWTvmce2qi8z+i5SA==	4edb9348-0da7-44b0-bded-b1dac277998b	2022-05-14 17:34:31.948813+03	2022-11-14 17:34:31.948835+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
be769e00-a507-4cf7-9420-2413942a25ab	T2tcRkJUpPxRUKC3hhC8UMMnQQwifautcybZttwXeIoA0Yl+lsvVL6aNV9cBlET35JbxTqln7lhl9cITQNbynA==	102668a0-924e-4894-9eef-4653d631c441	2022-05-14 17:39:32.851826+03	2022-11-14 17:39:32.851827+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
47488592-9d9e-4324-9c15-a611589a34bc	b2HJLXo0/Bch1CaYI0GXcisdDCMfnLMc3wtz576uAZn/i4AvPVfMQPOp7JzqOOu5jEiuYvF5IqFDLaHJHD7LCA==	a1ac854a-679a-4469-a63e-85bb07de274c	2022-05-14 17:53:32.799006+03	2022-11-14 17:53:32.799006+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
28c103cf-4371-4c69-ad3a-69909359a5c3	TeMaNF+plpbbOL22gtOziNaKWNSjldoyikcWd1tOc9LAxdE1bOgmao0SPY0IxdZJJAl2677CkNnxgbL8FvyPxw==	30772dcc-3df6-402b-bff3-b411f1d42175	2022-05-14 18:07:32.848597+03	2022-11-14 18:07:32.848598+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d34f0b40-9101-4d26-b6ee-611e2037277c	jNrr0sxchJYwKW7ipJ6WDDjG7u0579fVanqHSsEArDbxoK2joEJqjQNfTOu1P38ekvXJrUcKt4Gn2DS3joOKfA==	a3c9b34d-49e4-40cb-a95e-6616583eca4b	2022-05-14 18:21:32.750174+03	2022-11-14 18:21:32.750174+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
89e288e0-be14-45c1-8dbc-1801ada2a6a3	MwU7Lo9wLitoKAP++mHfYVnSsDylfgCABls8xr7PoiuGAccFk7WHe6t2GIlAyU1qe5rxfcxgXTt0XDmEzMeIWg==	d8b7c9df-b646-46cb-901a-a145811d4ce5	2022-05-17 11:19:44.638541+03	2022-11-17 11:19:44.638562+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8d865d5e-f247-4a0c-9eae-ccd3b34cc312	0+4Jf+gNHTnPxDyD68Xj7FRYW47PQwfREjSpQAGsBZvtBXEPMff1wUnAgtX6sYCah6dzRLKTbzOEIgwxH0yt7A==	2df3a695-c71d-4cea-a1c5-596b29c683f2	2022-05-17 11:33:47.065645+03	2022-11-17 11:33:47.065647+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2765ac9c-b2b3-44c9-8419-f9d3b747df59	opR3NPf0kzYqX+RlFjRPoLuOSy2XaA43EWgbHFDUlq7UQkJDrKmQ38mMEupxWwYubpw2JCXBjZgiCT2j9BJUjQ==	72b96525-cf3f-4715-888b-fec078c07f5a	2022-05-17 11:47:50.229885+03	2022-11-17 11:47:50.229885+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
19ee5b87-837e-4cdc-85bc-37f942c8df33	FFVKJh1AZ9D7hkLAZ5ZqHNcwo94es9eOpkjqt2Mu3+u0qGGuAOupicUdsZUEdHmYF1zDssX7qT70gbGNAfC+3A==	859043e5-7794-42e7-a896-10f1eb0d552a	2022-05-17 15:12:20.94853+03	2022-11-17 15:12:20.94853+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
426b577d-e293-4861-843c-40b6e8b7e206	hSlYVOCrVWDSxlPCYBmqvEXdts0S5giPEN9eCLlBOSYlFkkxC86lQWjhnOQ1BVOvWWL6cE9FbZTcqqhXJXVfPQ==	c9be4d10-c11e-4cad-b3f1-f39c35dc1483	2022-05-17 15:09:16.330041+03	2022-11-17 15:09:16.330075+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
eb8791a0-3920-4be3-a191-60a75c3f80b2	oCtztyDl6+rviQivegxE/44ik3Cj5+9Wr2hg6snzEwqpNppuMnao/SnDQKIZ1xpfRyu38fKBdAitnj+hH9jwvg==	bcd3fdac-bd09-49d9-9deb-a42f1e02f055	2022-05-17 15:13:15.209632+03	2022-11-17 15:13:15.209632+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5ab418ce-665b-4c57-8cb4-e4fa25a2b97e	rV6slRhlVdg7pwHBpp36DKZ8p83kReasuKPTVkv2Ra/crKOv6Fck+84KZK8ZbCg/vZNIGaUbosfEAf+WHIQPbg==	396ebd37-e8bf-4fd5-a264-fd9df4c60748	2022-05-17 15:13:30.802827+03	2022-11-17 15:13:30.802827+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7b4ed024-b714-4428-a904-a7cae3918684	PuEtk8kF9wJtMzqOKJi0LokHAjN7X8U/QfU7B/nVnxn3gqnPDzdwduhFjRkrbzRl+/H4MQqeojQPcNfZDSV/LA==	ccf64233-185b-4ab3-b3ab-f7f29f98b9c9	2022-05-17 15:16:32.712939+03	2022-11-17 15:16:32.712939+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5cea2fea-3a0f-4887-8b17-15d9966d3b41	AasFwYDCtl96fuFMRzkK380t57bdeI3QMqcBhmnIMdPsTkcyXeCK0nkzAZOkRSqaw+dIwm0jRezikQhiA/a93A==	6f7c54c3-ee5a-45dd-88a2-9986efd59d2b	2022-05-17 15:13:26.557009+03	2022-11-17 15:13:26.55701+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1a3410d4-3d13-4ce0-954f-008acc15c243	LTvYc/MIvtxipfpGJMRorOAKUUm6DcQT1S11Z5ZWxSU/07ffq4wS3zl7XfyC58vdN2UTJjfv7xq7faGxNS58AA==	b9a9098f-2cb6-461a-8675-4615555e7123	2022-05-17 15:27:28.772287+03	2022-11-17 15:27:28.772287+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0c987136-ce81-4863-b47b-36304de74d95	yJzvnHfbW0mFnedl4+SA3HQ/IwdjpGFyIFnFSHiUhYqupuOrCgxxImHTQGiHvVixXWFPfTzf5uxZ8H8bKoGxNQ==	ba354a82-e7c7-4e65-b8ca-729ea6092009	2022-05-17 15:41:30.678209+03	2022-11-17 15:41:30.678209+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ef187f56-c24f-46b9-91fe-6339ae237b57	oUOg0TCX9IDWn0djLqVXNrL4NENRGzcnXUb3+AlIUEVFggjL+uQJ/gSAv/GGgdMqg/sNvI0Xh1NyETgVSILKkQ==	fadeca01-c62e-499b-bcd6-53c5e13f6200	2022-05-17 18:51:50.888557+03	2022-11-17 18:51:50.888578+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
27ebee18-518a-4855-ab08-c6baca0ec418	YJV6eP89xs34Hcc4i1qopBUOofzAHgAxzER6K/iU7ykUo/EDbBtczEF5ir9iuExpAcloF2wFef4jeO8UDteI2w==	461f121b-8d72-4abf-af52-7d09bdd54702	2022-05-17 18:54:21.563316+03	2022-11-17 18:54:21.563316+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5ac2a560-9aef-45f7-baad-1095d4c46b1c	EEPMBbgl2FX6NkiyvezgK5gRtwFQLG1+yGsndWMLq7AQxDQ4DP7f0MQ1VHNIffya0HYDxQQko7awdX+EgGdJyA==	88d5932d-0745-432e-96f0-f5e1eb174954	2022-05-17 18:58:33.461053+03	2022-11-17 18:58:33.461055+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8c1aea6d-5191-4427-90ac-2cc55163df80	fgamg+cUbPXHRLvAyV7y4w6o29txtH2dlD6e/qdpry9s2OI+PqVtBRVPjDIY0tl7Ems4WKwrL1ONOZJqm4hhvQ==	7ee81070-067c-407d-a3e7-690017f8b14a	2022-05-17 19:16:57.750167+03	2022-11-17 19:16:57.750211+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bcd38e28-6f09-49a4-9c5f-c8502f9a31fa	oiOg56oN8A7ONhtCkRR96cacsbUz490zYyomWQPWYtg65J4rX2A5XsqfqFWLkP5F2c6ZLY/oNaHXsTuGwQ6CmA==	3efc00be-623b-4896-a93c-adfea091999f	2022-05-17 19:17:33.455688+03	2022-11-17 19:17:33.455691+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
82b09a7e-02b8-4b8b-9e02-22927f9bbc99	eCYBq3/QmI5xturPlB5moZ6KbVyORsHAW8e3jvvaU74pGEftF6GHghHOKZyjsvurA5BGuttpsyIUR10ARxYg7Q==	4cc8579e-24ca-4741-9c92-307e44d8ab6f	2022-05-17 19:30:01.593724+03	2022-11-17 19:30:01.593724+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c5a976dd-7695-4acc-b2e5-3d82d06dd772	SUqokCmTg/orCj1dUUxKNl6EdKFPGE6CI1uAKtrqLoPL1ZZHpNgDBjcsUyGwMeDhgmoV+svq+EjIcwaw2vrNHw==	6464d738-3481-412b-99a6-8db2e4ff53ca	2022-05-17 19:12:35.871218+03	2022-11-17 19:12:35.871218+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8f7a937e-eba9-464b-b4c6-9b865b79403c	/1fv3YJCJJsoUtp7kU26L0GV19qnRTe9SFq0MgcKZA8brukD7qCYlYylNNGrW5KG/J3qGVSmFguNO5IUuH8/5A==	c1dcd09f-e0c6-4dfa-aaf7-152b7611e48a	2022-05-17 19:38:53.818709+03	2022-11-17 19:38:53.81873+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5a4675a5-ed54-4076-b0f1-e99ba9adfba6	/ec3pSANpEHdks+B3MjP2bFEKkn5ohsnvXbPq7hrmZHeOkSiR/CNh+dO8Dm03bdntMfjULQ1Ed66K9LZF0J63Q==	59c075a4-4dff-49d3-8937-ed8f7d04adb5	2022-05-18 15:44:49.202689+03	2022-11-18 15:44:49.20271+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b3fdc469-180a-4e46-9051-e8a40c17dd25	69bOkj7O+FdW4taLxGz+GBs2M5BBkNLZob8LJQcVlIKcXmA//1a2H5B24HKJZt8iLF0iIonZz/xs8BkW5S5fmg==	6beadd09-bfe6-4eb6-8e71-2603d277284c	2022-05-18 15:58:51.502942+03	2022-11-18 15:58:51.502942+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f73f21a6-6b63-4965-9f96-397ee9b3e238	M3MO3+qkV1il9DQVFTxIKU3NvtohMNwYXnbKGFSlfsUTIGJxoN1yHQlorPZLIhCQfWBp8XJngVNWaPSBS3VkXw==	6741bb6d-f162-4ec9-a349-bfbbffa8b304	2022-05-18 16:12:53.546141+03	2022-11-18 16:12:53.546142+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ffc50b3c-4395-470b-adff-375cc5303626	WwhDk+3iy6d0g5RCIjMjP1tKuGBIsp8TbdShKJ2YNf5fVciCpoNXuvAthEK324Q4nXBl9B+q3WBK/RErKSZqbA==	8313c168-7504-4eb8-a8d2-92242b9bc82f	2022-05-18 16:15:09.733297+03	2022-11-18 16:15:09.733297+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d70dd571-4939-4dca-a007-26e6669646c0	tBFoFVemNX0wDnGmkl2tSk3gfcWHSOFVn6l/iX82CX5dtN4fqHpxHaICpJOUu0FMK8QTNpl5OnYwo/nSs8sEbg==	7c666fb5-cf76-472f-a773-b908f24f57bd	2022-05-17 19:32:46.546638+03	2022-11-17 19:32:46.546678+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
22a2cded-cab4-45ea-a92c-e977a7b5cecc	DP8wcYMbhA977xE+Vj+k5CiYRxkdaZ+tsIUNXcX3FgmlXNG71LOFEOHWetC1QYx53Peg2O7PIQExcfnl5hDLBw==	ba75ef21-f78d-48e1-9a71-b4810c840e2c	2022-05-18 16:29:11.468416+03	2022-11-18 16:29:11.468417+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8337c9a1-45d1-4766-8a97-bf9781fd610f	OBepAe7J1A1nbu0FEBDBeK17sjSGVzNc+6qg1xBwQhqEou3T/gYDTRv8kzwAN+sNEsH39FHbaFUP22z5Rez3Aw==	5bd38062-7ae5-4ca0-8040-2aa3fca46c92	2022-05-18 16:43:13.059011+03	2022-11-18 16:43:13.059013+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d5c0ba9a-1cf2-4e50-bcec-c02ee7a456f0	bvBxKHyyHi5DzIx8Y5W8GyUA3N2HSJENOBJm7zkUeuTw9ThBczhLnmpK3/zdfaguhINT95AXL050/jvgVqSQhw==	ddd59fad-a2f7-4c69-988d-7ecc8c76fdb9	2022-05-18 17:47:48.252991+03	2022-11-18 17:47:48.253021+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
978da214-d83a-49b4-990d-37be82c8fbe8	Fnos5uRfe520v5M2puUv7/GolLKyzGJFeBls5AfVJoLXXhVbE4yVQM/xR+jEl2kqX5i1DePmAcMSczqmyAGeVQ==	62987221-63d9-4afd-911a-6f7d3d2bb4f8	2022-05-18 18:01:49.07003+03	2022-11-18 18:01:49.070031+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c4f542a0-8341-4a28-b981-1d33007fcbd9	iKLZEdSRFFuOav3dV45K8lZpNgLYAAqg7TrWvalUk0M9Im9dPCbHRAavd5yDxCe8VncZe6BKT5/1BCpC6J8vpw==	d44cf1f6-f04a-44bd-854b-74a72f9f9f46	2022-05-18 18:15:50.114493+03	2022-11-18 18:15:50.114493+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
834807d1-0fc7-4c2f-a3d1-2a2136d28d94	dPXvV/urFE0pCOcw8bt91q/FYE56F+/IRLOdAkz740eeq8rHNdSrLzvulBrRl7aI+Ix8o3PHLVFdl7MTHeIjtA==	4dbded90-4b21-494c-8b3b-66caa06413b1	2022-05-18 18:29:49.951416+03	2022-11-18 18:29:49.951416+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2789275c-f153-4f81-9671-bebfe60d07e3	UMHeRIgTXpjbPiWYOgP38pibiL6eRWq2qrg9Xv5j6/iYRZKWtYzl/0ytjE2dJnjYjum/+lZXPYdfS8Gj11Z/ZQ==	d8f34417-9833-4ed5-a62a-f6a90156fa19	2022-05-18 18:43:49.175751+03	2022-11-18 18:43:49.175753+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3998687c-9cb1-4e78-95ef-0870a7a15cab	gH8N7oZOONDSj4FwYP5Ms2EViCHF2VHUD9qGDpJJJP5wIwKXALOR5CvOaudlCyT3HLxhHsC42eTbjkLvkNK17A==	557e4cc1-b8b8-4907-8e58-f168eb75ad2c	2022-05-18 18:57:50.059091+03	2022-11-18 18:57:50.059091+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
74ae5a67-0abd-4d35-bf45-c5f341132bc4	J1Z7MJ0HdnRnOaZJfirO/NlxhWnaHH1S/UMHrK9aOdc0S05SocusX+RIkpiyVeTcF8TpIyvQ1UkDr3wtC9Z13g==	c87886c8-0cc7-4bfc-896d-95b619f60645	2022-05-18 19:11:51.174078+03	2022-11-18 19:11:51.174079+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ab1001ce-7e9d-4121-ae1b-ccbe70c283cb	cP9tebPTkzHLkusIwpHPegdiie8SnEQDL317sZxF6FuhuAOROkdtqWoRwD4TmqY+06whpaY461mHdd8Jxq1bRg==	02f7b7fe-92e9-4696-9b71-b68f14d1b106	2022-05-18 19:25:51.187829+03	2022-11-18 19:25:51.187829+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
95f5344e-aef2-4f67-8721-f235b84700c3	PGWqgE839kZoZmTWdXKtWiCJyB8TPz5/JxXGq0Ep+JqR6EB55UqP0qpsYuZ8G6n2z1UgmMjslYuRkxKKNoB3YQ==	ab331a77-abd5-42a5-aea6-72b28846e3ac	2022-05-18 19:46:33.390773+03	2022-11-18 19:46:33.39082+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5dd6acae-147d-4214-a231-a2e4cdc1f0f2	OJZKs4OYps+F4+75wJLpKzBxAyGUHF7O8dPlSOybsUChMUPCMpF6QcpkAdIYaBxso96n+IUsrrXJTAjnB00WoA==	c89e2d1c-1b10-4598-b57e-0022baa9e0b5	2022-05-18 19:39:52.127845+03	2022-11-18 19:39:52.127845+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
298a8d49-0545-4c9d-a900-c766c43a37b7	HZruvVF4zYy8DbFYgbf4+/mDMpP+CG7tVES+TBNplJ1meNsUe7LdWbjxIeX7H8cZpMV56zT6/9/kppPJCzKXew==	543b3032-f24a-4b8f-8768-43d4bbeddada	2022-05-18 19:52:12.516408+03	2022-11-18 19:52:12.516529+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d8412ce7-9732-497d-90b6-cebd61ad9f4b	ZDCuM9pvgTC19F7nmk+JPE/+tZhafdrnJ1hHgFXHzsn+EIzCQyEh9kDsmSAsDmk60/yaK7kvqTL6EopU5qe3Hg==	8f00fee0-d367-41ab-b018-1bf451533c24	2022-05-18 19:54:48.587045+03	2022-11-18 19:54:48.587142+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9ee7858d-0aec-4062-8ef1-13698343cf1f	z67efxxfakDelRoAoDtCcvTe7kykL+kaU+MEMjPVbWnwClkn0Rv+Z6S9MB8HFVmoJIrIGIpMQYQcweTkWORfzQ==	033511f2-fcdc-4635-9a7f-41107b4ff325	2022-05-18 19:55:56.182794+03	2022-11-18 19:55:56.182795+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f00d37b3-a8b4-45a0-b70e-e6e6b9a648ab	5lt3S4IDgWdU3rfJ+dS+1vZ0D2Zm6wOf7fa4sNQeH+tJ17VUdLy976GYl84kIAWcny2/RWJ0rOLcKoM2ClHO5w==	7ef4064a-9fe0-4d22-874d-df07f5b7ed18	2022-05-18 19:56:54.544117+03	2022-11-18 19:56:54.544117+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b41b1d16-5af4-487e-84c8-d4e5556bedfd	TtdoADeshvGYlLuZZtuLjLkbG44onB7b8zeb2S5PuH0byvQe8xwKJnkAPQql0EaVWdLvR66W5Ys2EnD6lOY4Qw==	02a898c1-909b-41ff-a56a-aba68bfa9062	2022-05-18 19:59:53.520987+03	2022-11-18 19:59:53.520988+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
dc7038b0-601f-4d80-af7c-30095880327f	+nnM5IponbeIQj120A6EB2++iGwAKjRNW/b7o6wZ4V/0M3lt8t7FCtUjViXobI2YkJgDEDi8ZkNNLasZ3LN4Hw==	61f78fe6-c6c0-4b6f-bbc1-80ab701a049d	2022-05-18 20:00:11.221703+03	2022-11-18 20:00:11.221703+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7b5670e6-ef62-4fe5-a373-1a4e2d3f0f9f	ZClQY/IoJBAvgsB0a4m0yNpsYkOgUVLd2puz52Zf29ieNC6EhHG2W12rpFEQC/DmBub+h/TvLchB7VlPg6wa3Q==	1101e29d-328d-4c6c-bcba-9604ddb5750a	2022-05-18 19:53:53.126801+03	2022-11-18 19:53:53.126801+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ad41422f-8502-4809-b0ab-00d2fc100609	SnKURKgFm996/lKtNsnDoIedAzJeyYKC2zZk75JXm3uVP5Ab5/XmxKTXBI9JTTh5h/kl/HQYQbQfN+awO061TA==	99ea0e2b-7e40-4cfc-be8d-4d60aa16d61d	2022-05-18 20:13:49.803823+03	2022-11-18 20:13:49.803924+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
89a1eecb-b49a-4da9-9416-797d4b639396	PqKqdwRyWkcMJ/ssS7M/aM7l4LJ0rHTRkJF2CSOFxaBQMYfWX9atv/vz4iqUQIte8UvXwmzUyHExhfAsA9IjpA==	5b4a972f-0ac8-4f97-b6f2-11fd2d1fb793	2022-05-18 20:02:08.583007+03	2022-11-18 20:02:08.583007+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
aebceb13-704a-4626-bcd1-fa1f6703db9f	ciLtRFVjw8EZnwqMcW4KHwCEewOk1WsZlysS/IFy0M2N3pX9lyOv9nXPvyp+qgsxZ3Jj9cy5H7/uYYbcN307iQ==	45a06955-0791-4a9e-801b-cf5e54c9f235	2022-05-18 20:15:42.410929+03	2022-11-18 20:15:42.410985+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f2d933e7-7247-4c8b-900d-b1b39f353445	A7CoENBtkKnoPnp2i2KZCluXMd+frYEYLy6sABEAPhkOaSNfXCNrIK1/832UQXzk3WwcztKGs5O6idj3Se4KhA==	f9425504-4c96-4f72-a128-1e681f94b7bd	2022-05-18 20:17:54.457016+03	2022-11-18 20:17:54.457016+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b4def654-0697-4590-9ae9-a133af28436d	8OnWkR4x5uQn/+FlgXvsoBK5J48mMe6NdLu2QsuNVstH40YJPLEd6+d17lVhsu11oa+tTtH2a7ZGJ9VOljSf3g==	9f8e7eb1-22b1-42c2-8666-4631e4ac053a	2022-05-18 20:18:14.203288+03	2022-11-18 20:18:14.203288+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bd709bd8-9650-416f-a3db-5f9acded66e2	bfAdkuxTtmS65P/GCQ9okJ/fECLlJFdPfPINTPgu+O73hVLv0Pl7ChbPTdaaCdKCed8Vx349jMSvTnCFtJ9WaA==	bfe4552d-dd51-432e-a962-44ae670a349f	2022-05-18 20:07:54.253745+03	2022-11-18 20:07:54.253745+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1732519e-3316-4d45-a3b2-2958c9611d81	DV8IFbOTU8AxFLZvhC22dqO+2oV7JBtojKF7YEMqwJUCl/UlRy2KGU3YQK5Ogb5MrNrONiFeeUUgQnYJus+nVA==	38d9b760-d9e1-42ba-9e6e-d3afdad7f90b	2022-05-18 20:21:32.178409+03	2022-11-18 20:21:32.178409+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cc12743f-f09e-4bbd-bf06-66fcd2a08c86	E03Vywx7+u0rEBLAdjxw+3KuyF9+7IsQ8OfR433haqNyILyDk2jvsqG/Gs8Fis4Ly+X4F/AnFpbKQRlEVbXiZg==	6237e7f2-2b65-4129-bf20-44cd08441111	2022-05-18 20:21:55.214806+03	2022-11-18 20:21:55.214807+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
11c5ab45-0315-4ee5-abef-665962948628	CQFsV1dopiI1ck827BVMWcFAvO1IEQhmiLs2aZIb/UdBXFwqrEjXQLcgsVBuXUwCgXeYYp8HnW3di0J3N9w2wg==	8147eb1b-25e7-4eb0-9595-18574ed3974f	2022-05-18 20:35:30.160107+03	2022-11-18 20:35:30.160297+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
30877893-5b9a-4939-a539-3a6c419829d7	Z8d7Fdp6UYAEr3mC6a1hDFJlBB76p0RaAdDrNZVLfy/WgGd+1IEWp8YCB+Z7DFYHaR6W9FzsRDSjIF9yhqyPuQ==	56ccfb4b-8a62-4c75-a2b6-e9ccae30979b	2022-05-18 20:35:56.201946+03	2022-11-18 20:35:56.201946+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
00811093-d3bc-4105-af64-a6cd98057ff3	I05hFi+oZxjwsyUdg7v9RtI60DW7+BUSvZJI42pVqZ8RtCWS7dQNolYzvbhxQT45vSVi+QQCovQ6EAco6c9s2w==	a85ae7d9-fc5f-4060-921e-d627ca149280	2022-05-18 20:44:34.098126+03	2022-11-18 20:44:34.098126+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6ea6e27e-9285-4813-8f29-704283cbec57	PGX1CMHU/528hPlVz4WMraS8SCfIyXkRTDpST1bP/TIprNUO5IBAgJjMe1+xt0I3tfZSo3z49fKrIhVFvCYuTw==	200b6492-1a4b-408f-a11d-a0fc9be003b6	2022-05-18 20:45:02.843326+03	2022-11-18 20:45:02.843326+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
17c881ae-a1be-4564-bf21-ccc1be91958d	IOhzIyjOxANBUOCQRiY8CRQy0jP+3yliNRfs6nu+06EmUJFham7hA9mrBa9K5gjOVKlFUtDvvzjR+WI9JepA/g==	23919b7c-f8bf-4896-8789-edf89a6b3f5b	2022-05-18 20:50:33.858698+03	2022-11-18 20:50:33.858698+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ecc0b75a-a970-4d81-87cf-16030435baf9	TcrYBqQsLSXUdfGIlOjVVhWVnoYiEQzyhXu3iSALh5lM1PgnyqY12FU2RhPkjXisvSP8VSBTTealjwAvcLwEXQ==	c5975cdf-ea00-43c5-a628-395e61340ead	2022-05-18 20:50:59.575731+03	2022-11-18 20:50:59.575731+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
995644f5-f0de-42e0-a670-59ff60d587b1	ihw3d5KFOWwjSSMEMZGva2NDkIY21DhbmS85i/vkr+aNv3S4mpsaDDJQyR41IpKKVcyHpNIvvxbLiLVHlmtayA==	21e8de7b-fcbd-4e9e-a71b-40853fd487c3	2022-05-18 20:51:34.900007+03	2022-11-18 20:51:34.900008+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f8e9f2ba-4564-4ba1-b0bf-f698d332d2bd	P819c/vo1AFKKUcmTyf5J5/U6p0aZ/DjET4oBP+NnK1ZCTcgkr9BwwLYwC9PUkAPdoahxmaD7uVt5cUBz7L5hA==	0b6846a4-7042-4243-a55d-638501190b42	2022-05-18 20:53:44.606219+03	2022-11-18 20:53:44.60622+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d0693523-40d0-46d8-968a-681608408456	u55bjEUXWVScCryDwu8vRNHOKUbdlJ7KlpIFr4DJ0XmafFhE8aQJculHjV5dLcPHeqWATcrIzZ9TJF0Ffee9nw==	27872759-7a19-44a2-b256-6ff98f945bf4	2022-05-18 20:55:24.689331+03	2022-11-18 20:55:24.689331+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
894c5328-2c9d-40aa-916a-1e5284c9a6dc	jGiTgxpAPNK3MdlQG9jU7S6ul9oJazonhYOYu2bAUhbI88JjZL+Qpr0c4j/u2pHLn5wmRIAH3fYUO+QpwJCpYw==	69b6909f-45a2-4a88-9440-d225c6a99bb3	2022-05-18 20:55:41.443222+03	2022-11-18 20:55:41.443222+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3d6597bb-2b98-42a5-a065-a6bee75b1464	t2L+NZe4zbltAwKNjdNt8FfDFEt2xk7sfd2ImvTmojWrfmLE/4PeQS5dTr+yoqi9VMM6IORNARvXUCFwtDhfaA==	33ecda92-0f2e-49d2-9762-c788e92a363c	2022-05-18 20:58:04.334836+03	2022-11-18 20:58:04.334935+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
f581e27f-1604-4207-8325-c64d67b4623f	Xwer5vaPMwcWGoYk9nIN+XzwnFm8CGdaskGSWcBNis0UOd1tjEbzFA9NHm2x5LfXFbhJbIJTMLi4YbVyW9LR8A==	bc5a6187-efc2-45dc-a6ba-bbab5a8090e7	2022-05-18 20:49:57.18287+03	2022-11-18 20:49:57.18287+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bef1a57e-87a3-479e-941f-88b62f7a52e3	NgmhJV5zQYw/k1r/wGyuKOP23cMMaLAy6JcrkEyachZqMIbCrQpM1XxteL0VvBhfNkxvDj4Q1ptvzhxRBTu7aQ==	56152f67-0418-468c-a987-9d893dae58c0	2022-05-18 21:01:17.500151+03	2022-11-18 21:01:17.500183+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2e2f106e-30c8-4852-b5a5-5a86ae5626ed	4PIzfN3yST7D6s1WYQO/GwPryXCqbzCOLdcybjINxqYxPS+Jl/+n0SQ5G2QsNIVnKkGkOue/EMX7/wv39EkHIA==	18e7c346-8375-4a63-a5fd-43d4235e60dc	2022-05-18 21:02:06.614952+03	2022-11-18 21:02:06.614952+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
92998cfd-72de-4182-963c-73ecaf87a2ff	wmfMLUCw6huHADH03/vHsTsfHgc6BJ6WeWAYeY/Re5w3oWrrlCeomTXjbrr0Tc/zaugm4FdJb6Kw83uZ+pd3ow==	86a5ebdc-f6fb-470d-9216-5d89dd9e2424	2022-05-18 21:01:40.287701+03	2022-11-18 21:01:40.287702+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b41fd64a-e155-4769-b50a-043916ddaa98	TE316GcgFR2XqMXmglHxCRMWtaAlEs70NmGe3ks+EkV635/aotMysFI/ke3zb5uPLK8Fa2b+K/VjmIlAjJpd1g==	3d0b6a73-44ed-4dd2-9d2c-c993e6171677	2022-05-18 21:04:44.068819+03	2022-11-18 21:04:44.068856+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
cc8ad0d8-3a6d-4607-bb36-1653e35a7a9d	MW680R4Tmc2LGYoIGKR+xsgr9/tgrFV2V35I2FZInj33DnsIU4FD7Su8V8Oj7iopredf67InHQAvIaicNDpy2Q==	351e4db7-a148-487b-aefc-5f9a7d49ede6	2022-05-18 21:04:44.068822+03	2022-11-18 21:04:44.06886+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b920a6d4-cdf2-48b3-9f6e-1fb3cad8ab11	MEXZkcFwT496XDrx0/h11movgpiz3Luzs0yA1iiGNATgrHOuq6hEapLvZ0nJ3yeupuuNODlkyqBT8HbCMoMbwA==	d370c4c4-a1c7-4880-a305-2b4ea385e5b1	2022-05-18 22:29:23.675389+03	2022-11-18 22:29:23.675411+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
34aff174-3455-4d1e-9b56-8f0c59f58f72	u+SHr5wd0Tu1GCitbEf/jBYhlTCQXBMiJgwLms7T2xZ+JZ4/lzJzhBAuOTC3k9WIaN7iofXTizaWrreva/UVAA==	94948023-06a1-40d5-92a2-a220ac92fa8a	2022-05-18 22:52:05.587692+03	2022-11-18 22:52:05.587694+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5985abc1-6fa5-4e14-b551-240417441402	Jnc+w+qQS4b3xctJqY35ZADmWE2uSiB+nGgz645NhwgbODoedUrHjCR6Xoq7Og6H715QYIJtYrlMtsW+4cwbJQ==	aef5ecad-4451-4e46-bb6c-fca12914a581	2022-05-18 22:54:59.342392+03	2022-11-18 22:54:59.342392+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1b6b18c4-699c-4020-9007-b22ff1c9b02a	aIH2co8mQYCM2V2ORWZ8ROX6gSjJDLEwaxhDEAiyx59j1EUZ7G3PcKR9JGvLKQptV5VDBZgYkN5kVMKF40HDcA==	01400fdc-e9c7-4d67-a4ab-0ea1e46d63df	2022-05-18 22:43:23.098643+03	2022-11-18 22:43:23.098644+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6b3ae1d2-b84a-4087-884e-90bf00b378fb	90lsksi1l2SSv1g+gCtOblm25BCTrXwdXVFd1hFUzv7tSEVed+wzHGRD45IvWLAJ4Fi8JkOLBFLb0v3qahZtlA==	afb5efd2-6501-404c-8c8f-af895e06eceb	2022-05-18 22:55:20.498909+03	2022-11-18 22:55:20.498909+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
323874cd-dabc-47d7-b2bf-68ee95d882ef	hW+gEA3nvFYsl3+PhEQYUVNMumG6Ey5AvbmNOoJe2p3KObR/vkfXyV+OHf3HFTKHLBz1++vzueRpnJDdAj3aPw==	90b75ad9-445c-4781-9153-c72cb3248524	2022-05-18 22:57:24.189926+03	2022-11-18 22:57:24.189926+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d5148374-7e91-41f1-b28b-cae3367b25ba	tELIjoCUB7SmdVGAVOFdcctYLQ6KSxY2t8l6V7HrArE8TBZgfzCeeiH0qEC3hrIJb3OLpnDE2kXIcPk9MOhuOg==	cb11a05e-900d-403b-b5e4-ee219e89c0c3	2022-05-18 23:09:21.263701+03	2022-11-18 23:09:21.263701+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
960804c4-5e82-41a3-aaf7-f9571e335678	C5kGfdGbfIi9LZ1Tn1eVLaeQRWyu/VwOhP1+tr48Ihxde21bRlIRW0xhKMjzPqIElJPRoM1FkliD83rO8PMmlw==	e89f3d22-fa3d-4f5d-8018-6a2bb76d7155	2022-05-18 23:11:25.252768+03	2022-11-18 23:11:25.252768+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6509a90b-491e-4cca-89fc-7dad9f2bedf4	cu2MQQ1wVflaF7b8+UYQE86G/vu/VcVydcgVd2wp7/6YLrk0PiC7pdLnhyTx1TNMFwMVvJiXggGFEIqEqE3IZg==	83f1ef36-c160-4b6a-9a09-5d087c86b3a9	2022-05-18 23:25:26.246835+03	2022-11-18 23:25:26.246835+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
30ddecd5-1435-46ae-b63c-e1dfcb2e296e	+O7dnlUyrhBOlgZ3WN77QkxIB4yFl559cOptoWCxEkk0JhVbktmxij1enB/xFIyOY/5ayA6rui0O3kFBe35c9A==	1dbc09a5-d806-43e1-8a4e-d746c2931d4a	2022-05-18 23:23:22.789344+03	2022-11-18 23:23:22.789344+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cf461081-f1ec-4e89-a85c-662d5340c61e	CZ+fB6TAl8YinJ0ekO/LlGk+orW6ZGuG2sZDQJppNCsXan98+fnoE3jc1HyuDgVj3APdxYNeE4KW0dS9ptgTMw==	7b11fb7f-20a2-4d07-b231-b5c4b3f34649	2022-05-18 23:34:13.593288+03	2022-11-18 23:34:13.593288+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
98253b2d-8ae7-4b08-a451-c3bf1e58d972	Dxi46R2keOVhif5BURt2ZaeBcrF0MMem94k65ShSpXTaoh4P/mB3v9hNdj7p88VrsTXmt/du7qeOiOf1wKAg3w==	dd4e26ed-884b-4148-9fa1-5719a835450f	2022-05-18 23:48:14.260968+03	2022-11-18 23:48:14.260968+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ced0abb1-a730-432e-8b0a-c450f9274335	RjEBUVPQoyspCzQHmaTKNVVXUiW4Rd/QSkZ16U7In23efA9Mx3Mtn3Vp81xIrZi0+nodh4Y5YHS47ymB9NnNUA==	5a56209f-ebe2-4c73-8018-138d06413dd2	2022-05-19 00:02:15.288559+03	2022-11-19 00:02:15.288559+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
62880f9c-331a-4c38-90b0-babac21868d1	sMKKodFa/i+vEwC5iWyPFLjVjlNyKKaqDP99Xlz0sqDXwciD+0epNi0/oiir5X6D2C1LgC3hWyBPc+h0Qq0Kfw==	59f4f7e6-3841-4ab5-aa0e-7916829c80a6	2022-05-19 00:16:16.337052+03	2022-11-19 00:16:16.337052+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
eb16f66f-0b89-40bb-a611-a73bec138a43	Dek1f/uLEKih9oqZhMEIJVljPB3b8/KQSTa7tlps6uc4VXUXVf9IJoCKJwKfQiu/m4U54GuQwjxCYpcCpAM+Cg==	25b187b9-32a5-44c9-8698-2f38c31828d2	2022-05-19 00:30:17.544884+03	2022-11-19 00:30:17.544884+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
c4993912-e4d5-4493-a69f-4d1bcdc432f9	T8EHBkHO2rMj1mnPyIPvKZGv1kLVsVJIOS2sdy4vj9hpFdpIz10esZCFCQPgevFtcuLxSnGhpvxyO6u2UEG1vw==	cfb516b1-c267-424d-9316-b70489c5edf7	2022-05-18 23:37:23.324535+03	2022-11-18 23:37:23.324536+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
68831997-8249-46da-87ae-a2253b2838eb	+n7sYkNgXqLZcBSOsq4GbpjqN3vbZbXV7GEMZjufev0zRAB6AuUYY7kOwR1wdKcFg+tKashhGfqqt+LxSpW7dg==	50ac1c9f-07fb-4f70-a79f-60d70f15c024	2022-05-22 13:35:02.454413+03	2022-11-22 13:35:02.454443+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f88e69a2-e3a8-4820-8ea4-a4b6f5528c7e	r3wwHOnZZwdyf8F2vv0hsn60bdzXB7NReWLWa0UC481BG6y/eO8RmIoXXn9fRk5v6j2b4bZjvabayszOTaXRSA==	bdf9d48e-6dcc-4067-b8dc-bfa2fe6bdf65	2022-05-26 09:40:22.377192+03	2022-11-26 09:40:22.377214+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
1818ec81-a462-4b26-bf83-ea3856fc1114	Yh/M1qAHpN1oIiW9DvZFqb7MtNxEktT8Vv38iiDjbIR8MItRxt4Nd7p03kEJtAKgAQCYT5UdAFP58zGGglJLwQ==	13e61926-7793-4821-8482-70dba49a22ca	2022-06-25 13:03:00.084933+03	2022-12-25 13:03:00.085006+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
ca044f05-8714-4a7a-878d-bd9ef428d7d9	vcAosHfNUM8iae9/VWZATwVYI1jZQFDRoZNtjC8Ecdl9nSahyNlh7cu1vupm3IirEU53rogG1sM5njM+9PNHAw==	e76e9900-e209-414c-9769-7207e16cb434	2022-06-25 13:12:14.265104+03	2022-12-25 13:12:14.265145+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d8040c1e-a05f-4e5b-82a7-cead2458f528	+gMd7be+9xAdKwGpePcgw1t+QQqoNy8NPgy9nBCLrLO/MYBjYf4AYA7/77OEydrhgWr4J6x6/zqujCk4uWN0VQ==	b7d24862-c164-4fbc-8097-bc8a84f8210e	2022-06-25 13:26:15.88874+03	2022-12-25 13:26:15.88874+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
6c2da114-0107-4e22-9c83-5bcbd2ef17fb	Qy0Z40JZbxmAnWlGG06ATh9TFOuT8azqY3rRGpeDokDWcJKP6ITzNUWN/PdTvUz918JHofZQNdk2dmRCabw+Rw==	67e60eab-8643-4381-a9a5-29415bd50108	2022-06-29 13:37:21.333314+03	2022-12-29 13:37:21.333335+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2e9a54d5-896a-4e3d-8ab4-3583f23fd0d0	XJzN7RTobnJH9N3WOR0XewlrkrJcxKMzKiCoI4T1B6ipC4b9y8Qtem8XIxTvtXSLp9xpXEKgcegXxmWy3G65hA==	12ab277a-f39e-4ba9-a748-9b21b9169561	2022-06-29 17:18:56.262431+03	2022-12-29 17:18:56.262453+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
37980e2a-ef07-456c-a994-fdaaae4cc9c7	vTKMuFa2GuCOXEJrfGckeabOaPdO7OgzoGh5fftSDDAUJAOpv3UO3wHZJ70MWuTvTK5noznkH8EpYlasnUBNOQ==	05ab2ab7-ed56-4794-b2e1-ba4354ef1f99	2022-06-30 13:51:31.706567+03	2022-12-30 13:51:31.706598+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2365ecb7-e91c-4fb1-b243-24b41a32b04c	n9bFN9bbAtzAdkZPBp0XtLZPRYOfEkjaHhvuiCpWrqJ5vHgN/4AOgqcEYRVIFcMwtFdtK+xLAoOWkWLdrzdnGA==	f6315fba-a816-4949-b43f-5d3ea7c1fc6d	2022-07-01 14:46:13.202128+03	2023-01-01 14:46:13.202156+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
84792de9-f7ed-428f-9d5f-07e8490bb155	J0+IpcQzDVflN+EjIPyn5kT+P6UZKGw6isLRO+ob8UG8H7tSGrMOqjhvzMQY57kmmo4ReBZN58W4r2QP3BJDog==	d047161c-7005-4fcb-9934-f439fdcb34d7	2022-07-01 15:00:15.796711+03	2023-01-01 15:00:15.796712+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
319cb355-cc67-42fb-8215-0ea7d3955b59	I2qEjLNq+Ch7N3v/bZCLGm5gbE+zYLlH/vqOxB+e9LVBTHKnS6cJ9nkK4EmMH69ABCOKADMdlwR8GFIA0QFMRA==	33d377b6-381b-4359-9842-08563f12f09d	2022-07-04 12:16:17.234422+03	2023-01-04 12:16:17.234422+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
f3ed8dff-ea44-4b32-a217-1f1cd42b6e4e	jrL4c1XKKOen4ni1xoqWsWkKBblO0IOPwkt+juEV0VdhvmymZ76aeue5Nh8ILdKMmzem5z48qGAorg5T6y1T8A==	22fce9e2-b3b1-431f-ac85-ead7c3b92e1b	2022-07-04 12:15:57.16958+03	2023-01-04 12:15:57.169601+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8fae482a-9f7f-4109-9266-25b0a2ec7c07	ZbEb9c7BGtFZtgYVaEqW5lqIJd4SDHjzfG05Y1d5YHLKHUMguI8sXD26pr6tmXeI2vhE916aY7nUPv854YQivw==	8512b084-630c-4a04-acc6-9ee251c57a49	2022-07-04 12:30:00.575846+03	2023-01-04 12:30:00.575846+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3f2ce6eb-a3c1-4c5e-85a8-0cf32e2bfb1d	CXDPPJZOfLuf5xYcYVmTn4t4Ek/OklhViL3G/yErp08L1YwuDB57KCvq/5l2HPWIWYuWQ5H4iETGlV0FEa3/wQ==	b549813f-340b-45bf-8c39-01fe25a2f0cd	2022-07-04 12:17:38.964956+03	2023-01-04 12:17:38.964957+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7cd1d1b2-389e-4057-92f1-e067055e0481	+RLO2Ew9mytj2f3zH4CiBB51t+a27vkttfjZGp6E8GpxSfIidMXkdS9jPiRj6VpXET5g0Rd/HQo4FGsJtmMowQ==	60a28764-bc94-48b5-820e-f85156763f91	2022-07-05 09:00:28.303665+03	2023-01-05 09:00:28.303686+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
388c50bd-1b8d-4299-821b-2a20a3afdcf1	RyGkLmLitlG9jB2ToBT9A1c5GNatkBvKFVKdF/nbT2TXF7Ch1x1EzdqYRj2msoXLZ8r8BJPgbIM/98OhuBOk1w==	596e77ca-eec8-474c-9a34-b4c568610890	2022-07-05 09:14:27.139818+03	2023-01-05 09:14:27.139818+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c5c5dfd1-25bc-45a4-b8d2-ad59384ee271	9qmhOLL/ceHQT5pl98Clps8U4Hz9pAvMTBNbAnk4c/Po672pBgh+lRX6aUFFtcD51uWUNcdkQgGr47ujNH2wMg==	63d4b8ca-77de-476d-82be-f0e227123269	2022-07-05 09:28:29.499388+03	2023-01-05 09:28:29.499388+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
63bcb431-cde5-4b79-95a7-f0b4006e61f6	EXZy9uBrh5OcM39WuLPArZ2MWc2ATybITt5TtWCAPvQgdhoyMWTOZ7dl8FAOyu3CXiUnHVUJ4coFGYFDYZkKxQ==	9c589405-4013-480c-823d-b9ef1b45bf84	2022-07-05 09:42:30.721325+03	2023-01-05 09:42:30.721325+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6abed8f3-e216-4e29-83b5-a121bcc87cb3	twt0JvOQ54x4IWTQEWCpLAdwrfkRsx0V5yM3HRSoNDNZbfy6OfufRb4Ff+Jqn3frYSdcmXy5J60EgjNzjWQkaQ==	eb2d1ec3-6492-499e-baa2-2dfa849fa0f4	2022-07-05 09:56:31.742782+03	2023-01-05 09:56:31.742783+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
10ec454f-8035-445d-a331-2d86387072e6	UJpb8kJ2C71Cy/jW1ajxo2CddtQ/jRlTmtu+dCyiDwQG7FAzEfZhqtrljSkh5NdkmNbvGY1PPSm9ShmjO3U2sA==	f71790d3-2f08-4894-90f6-204bcfa9d889	2022-07-05 10:10:32.873784+03	2023-01-05 10:10:32.873784+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ecc6c40c-f99d-4e11-8f72-9fd8aa3b4b86	YSELsHg92j/andhQoYHffwv3TOzqsIqn7v4sb259QW2SBGjofgPW/7ozMyFjpj9lZCIS7QrA28NO5JQIg4zD4w==	9702bdaf-c42e-4fac-94e2-2fb6c7089f43	2022-07-05 10:24:34.35055+03	2023-01-05 10:24:34.350552+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2d1d44f1-3dce-4067-a38e-9909e8dabf17	wYDJtHN4mz/+1P6U5i8SO5NK+1K+nIpYosg3mHIrWcqmytSSBIRWdM02DiI5QsvaZF4uDz5+MUYTYPktGiZEFw==	6023d24c-3ac4-4bc7-bf33-bc049e09168b	2022-07-05 10:38:36.428902+03	2023-01-05 10:38:36.428902+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6d1743ef-b294-4b77-8fd7-91f93e6e0164	mQFWDAKaekEsNWFSsBXtdGq6lfp5Gep6TKFUEJ5xuECn+N7zm5OoPRmHoCi87EQwxIJ0GQRI7yIN9SJzYmx6jA==	00e609bd-781b-4e41-bc71-dcc5fbdd7a86	2022-07-05 10:52:37.879651+03	2023-01-05 10:52:37.879651+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0d60a1b6-5ad9-4bb3-a1c3-201674a0fa64	l3F5VyvMX0D0p/B6hy1VYzeAqyWj+iNsOO52XjRtMXGgyZwe1khPCdKoEg1p8DQb9Lxq2t6iLS+ziXpPXyK+0Q==	bd1391be-0941-4a56-88d0-663be17ba0ac	2022-07-05 11:06:38.894419+03	2023-01-05 11:06:38.894419+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d8677308-fa42-438a-bc6b-3baa4f16dc22	PKs1jNhgcaMNkcQKquELaGAViiEhGTkkRiETyZhiyQMKX0gq/oHhpnf0tk9wLofgsKaMR0xCgdGaYpmL5rXXKw==	8954d666-c301-4f4c-aa55-d2d8fad6e01d	2022-07-05 11:20:39.745619+03	2023-01-05 11:20:39.745619+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
788c71b0-ef96-4dbf-afac-90a0b5cda37d	rMWBERVOUZXljpQbmi6a0N8uYwOXId/gdRHk/dAyrk97j9np43H2IV6YTdbyulXH2kIB8RZRBPph34waMxc92g==	19a1b136-1e6b-4577-872b-548e99843ca3	2022-07-05 11:34:41.352052+03	2023-01-05 11:34:41.352052+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e7ab5792-214a-4d37-890a-6696aa672fcb	Q1WTU/fR8pTkN4/eQKq+Oh4feWem/ZZpOCZVh+HfYp00vm56kc6+s8kF8ms7tOirFziAsw7WpCFVoDlGrlLAjg==	01cfea9d-944c-4326-a32d-5458d1f68280	2022-07-05 11:48:43.001277+03	2023-01-05 11:48:43.001278+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c6030aad-d8fd-4cd0-b8fd-60914a312b41	u4B9hHTi14nFEydePAfBmhgKbpEfZbHBh3pacfV2IU4gGz46eo76cwnONtF72OermEiFUeVeY39/QOckPtrlfg==	0770a9e1-8b41-47fb-8298-688c9cbdb950	2022-07-05 12:02:44.852254+03	2023-01-05 12:02:44.852254+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ccdad71d-ec3f-4c6f-8b5d-f119ef842b9c	uk3MqdfHG/8Hvt5ifdKwnk6hBccEhw/T4ciHP7w1k4JE8A/873PrOX0GPOYLBAUaFlgJAz4ou6uQXu1uqMA9qA==	99188026-ed8e-4da9-8bfb-d1742b1ecf5d	2022-07-05 12:16:46.058067+03	2023-01-05 12:16:46.058067+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c1dd93c2-2fed-412f-82b0-996c10db7cc2	oYvxPZyoTreS/BIdnE7Ce3q+drHGzfd1o9rPPsqpuRiORegWZo3OjFeGg9Y986y+FMlZGVjtRBeU1no6sHCtRQ==	2337d3e6-b261-41c2-9d31-9c8a48ada9fe	2022-07-05 12:27:52.6014+03	2023-01-05 12:27:52.601401+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
11ba2367-66f4-48e3-928f-10c88f867ede	90J0XaYzDFkwoG6HXaRzkI3RrDIizz5KW5S9PAWiPRFYiNdZaCg5HgwhAnVljqA70ffqmmpGz1Qcr6A8b3wwpg==	74dd69dc-6563-49ad-ad0c-1e2d283aa835	2022-07-05 13:46:07.166541+03	2023-01-05 13:46:07.166562+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1d3dc619-8a28-498a-8d8a-5172556f44dc	qKYLXQ/CT2tjNjWLQTqquyluHtPNwjtqF/w6rJqsotYGsI0JC17vb5oPvFuyB50y886rAP8x0R/+rPouGhGXZw==	ca9b4093-974a-4fb1-a8bf-98453770ae3c	2022-07-05 14:00:09.533899+03	2023-01-05 14:00:09.533901+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
43ff9a0c-7204-4ec5-9e25-85bcd3ffd309	H1AMFxER++YGq3F7WWRfF07PjEWomqm/kVraCOnBS/njF+ehr9koI1fuNE8brVwma6aqOKgn+8KElRODNbXHHA==	d6d34e51-4344-438f-a855-e00c7c92fda4	2022-07-05 14:14:11.138496+03	2023-01-05 14:14:11.138496+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fb22a869-de06-40f4-9c80-76ea9be07555	xauhyPRe8pUbK5ahKDOHa5ohYiMfV8MECgaJNv1DBXLtZrAQPrfzzBxNSvw8oE41/NypuSAb9Ecd9cvl9xFq/A==	953cd385-1d2f-4593-b0e9-64e5f9a9214a	2022-07-05 14:28:12.113464+03	2023-01-05 14:28:12.113464+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4403bd5a-942d-4769-9d74-82bd873e6b01	okyfOGItEL7nMH5h26FEbJSD0LhHfgDEl4vyVr+UfRlV0KsmoCN0V1NK4Pi3T0Hx+KZPX8/kJbKYJCA521PCSQ==	337406e4-226a-4b99-b560-cdc374a1657f	2022-07-05 14:35:33.916863+03	2023-01-05 14:35:33.916863+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
07c45ce4-179b-4bfa-979b-000133c9574b	EFMjJ0Sn29V/6PtJAdpgQ/5WOB3DmDGbX+NVmufsxulKgbLpa4YM49gVPtYZrEdMJFnkMYm9uGD4E20kivTHNg==	1c364bb6-dec6-4ffa-91b8-53532eda2f6d	2022-07-04 13:19:43.284395+03	2023-01-04 13:19:43.284417+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e6650050-7609-4cfb-aed7-89263e353f8d	/zGkdx477F+5TYgZ2EJrnNKQRM7KJrvI+b4AgWs1SpCKHXN0J+VCUfqb10w5G1dKQg/5/p94r4eNo6ktzRE/LA==	5a776b3d-ff78-47bb-a27b-a8f740088080	2022-07-05 14:42:13.29633+03	2023-01-05 14:42:13.296331+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7f602ff5-4edd-4098-b0b6-c488eb3494b0	A49H4NfZ3/MG1xEFJ1bBiqT/yxzoU+jd4NYp2/TxUIHbiq2KpH+QxbEjHxsbsRyrfYqDsSBVkxdvi9Kuwqn3nw==	8273b299-4894-466b-8934-f6cd9c47468b	2022-07-05 14:47:27.513158+03	2023-01-05 14:47:27.513158+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f23faf9c-545e-4072-82a7-1dd9cd2fdc15	BfezVd1RbCv5XZgXuvlu5kfiUgsH7ojXI3iQQ576YwKzHWVZAX1G7U8nsXXk0v6aqFNyHgNnhNa2/yUx58j20Q==	e81e69bc-9dd2-4e8e-aadb-c0e780bc3fbe	2022-07-05 14:56:17.006178+03	2023-01-05 14:56:17.006178+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
202d9a58-65ac-4794-b2d2-d35718bb83e0	iONJ+mC5z30vx+WYcm+uMEhJDXcob8urudNurPAS+Uw9qxXhojhJird0QqNR8ao7ayzm1jYmFriP0WTY8pB2cg==	771302f4-c89e-4489-84ae-2c65d41b06b7	2022-07-05 15:10:18.241475+03	2023-01-05 15:10:18.241475+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0e5721fb-b552-4d80-9167-430f88a7a9d6	I415r+RdynEbixGQh5W/nqUNIsWMY8DpyDY/Qs3KH9G/1cX1zHyozZzUErWIeMVSLcvvbpdIocFpQKuJ/43LOg==	28eed7c9-7a56-497b-9059-3ea59e427cce	2022-07-05 15:24:19.922546+03	2023-01-05 15:24:19.922546+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ea673f4e-36cf-4bb1-9e80-3f6b244bc3b6	IZWAC9UfaTqNT/rBAXdBYAbJo9W9Mt6F/jDq8REcCaufxEVULZbh1WWcqPTmSOCUXzpaVXtllWOf51wfJtaE1w==	fa77ad9e-df81-47ac-a481-900a3dc76698	2022-07-05 15:01:28.964675+03	2023-01-05 15:01:28.964675+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
025065fa-400c-4221-848a-ef03be2adeb7	R8vLuTSKmqq82e0WM49CiLMdz25A7m7LEcvhbL83WsA+d270XGl0a1EzLxBXfsFISn7b9ZmmXDiINJjkVSUi5w==	97582883-2d89-4c97-a772-0dd988643cf4	2022-07-05 15:49:09.908414+03	2023-01-05 15:49:09.908447+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e2177a42-342d-44b7-8950-8fb4e563de71	qYeDskjZejTitmNkmZOqAZ4I6iM3Yz6dKLH00ZhO4h8lzkJdTmVNICFwihZHFoXBgkoqy1HBHr1K8lg+cI3EBQ==	2be49f6b-12a0-4048-8441-7ce68b92abd4	2022-07-05 15:38:20.277558+03	2023-01-05 15:38:20.277558+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9d4b1cbe-180b-45c4-b3a4-59c5fc508c14	bgLxJaNTaMZxQCAgpOvmKD2o1ATRMu3aDPtrdzgLZIHlNDCZVfwGOLgo7w83wJ7RaRZHMkI7Q5gIyiiFUtWJcw==	c16f550b-f2f1-459a-9165-8ca85e96dcf9	2022-07-05 15:53:47.337903+03	2023-01-05 15:53:47.337904+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
acdeb3fc-bcd1-47f9-b7a2-7d45c104ca23	UnPDWvj3TaI8gJ28TE17h3xQCwtys1oe7aLWRM1GwerFeOWjUWlZW7ONTqcQ2EU5pXDTm9cp8TBeTyT0MRGTHg==	1ecec6fa-8752-486c-a564-9fe75f2b4749	2022-07-05 15:53:36.44215+03	2023-01-05 15:53:36.44215+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4082dd2f-aed0-49e5-ae09-c2072344012d	uRqBTfXNk2OX8N9iHwoyJMh83YMIZcP1nO/bFZNGRQNoxlrn0CTVOYWmwISG1DQhDv1hD8M62ixH1VkLZ+mxRw==	7aca035a-3003-4331-b46b-940564317cb4	2022-07-05 15:59:31.825523+03	2023-01-05 15:59:31.825551+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
34a3b8ef-718f-42fd-9712-5a6958deb23d	Qjq98OovjHTz/ZmuZFveMtdtgs7xXsX7u+6cufle8j2LEXDywhbjPeBGxhuOHb7xEximGgv4P4hIiZYDGpnghw==	b9082983-cc85-4dbb-9109-f1a5b75e327e	2022-07-06 11:40:14.976775+03	2023-01-06 11:40:14.9768+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
48b9c3b8-68f3-4822-8bf5-d53cba48f293	CcfyrYfaaCi3GYJRnVDuG6jOc9isUepghJnxcKQbl2GdIdPvB8xbnldKYhpM/KOdbSefJ8Rz/AYCfshN9BVdAA==	8ce4f6f8-270c-4883-9cec-ca3a3ff465a6	2022-07-06 11:41:47.872338+03	2023-01-06 11:41:47.872338+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
eda7e810-f8bc-4e9d-8242-457598945323	sYPAZ5u4BiY1H9OR4+LioKNfZENzfKB/YB7TAJV7JS+MuvttCf9PrfN/IQDI5JHiuDDgUu2B5OeU7LGJYVvoSw==	78b76728-6f81-44d6-be77-2a0d9ae8956c	2022-07-06 11:55:50.152658+03	2023-01-06 11:55:50.152659+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
41d76b30-07dd-4bb1-8e0c-12a52b4ac145	7uH0EU6nQFFzLInLh0BxBJqde4m7+NoikltiSP1idgkXkHuMPAPwrFhFRvkY28NJ2WUpyJEiFcGT4djzp2ySJw==	579917e6-9874-4973-923c-a1fd16b30054	2022-07-06 12:09:53.08232+03	2023-01-06 12:09:53.082322+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3fe96f75-d107-4451-ba0e-8d2e9a81a88f	Gqr6BaI2fuX9HXURqvkLJjQYjTSdKv9+EUn03BQiMn4r1/q1/iwUY/FkQtrd0UgvkRllhgYbTkITPilSW/OOiw==	8c190df2-2bfc-4435-aceb-32af40370dd7	2022-07-05 15:53:55.308189+03	2023-01-05 15:53:55.308189+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e7b9c54f-2867-474b-b6a0-cab8cd804f8e	JqHETY8/NQSRIv3TLfi2u9olxWhwO7ygYdUcLoz4nPwcgHcwPwN7AzAST7m5fqWZJovSuvkA9v/y/qiFekAY5A==	04230e8a-729d-40fb-8502-170c4a21bf2b	2022-08-02 15:36:13.956802+03	2023-02-02 15:36:13.956824+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
94492c37-f698-41ab-9dd5-61ac41c99593	2NwDDqYokkNvLyPgEBQ2cSHoC9qimAwe1Aw5Ha5pc92XgXidXJ51hdufaMWLE9IfOAHsp3nvi1h/M0k4bIh8Fg==	9528fce4-b21b-485d-925f-39470eda3430	2022-08-02 15:36:40.852642+03	2023-02-02 15:36:40.852642+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ea505711-7e7a-4b48-b07a-d7230e064bf9	VkjQdSGsKWSXdI15Chnu1JbGhDY1XnD+cwuuRQUSSse46dbJba59cfzl84/QAT23QRD9ykXQfrk4NAbB46kOSQ==	72ea63d6-d8cd-43ce-992a-4283c3a0ce81	2022-08-03 15:36:38.713953+03	2023-02-03 15:36:38.713975+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bb821d85-9f3e-412a-b757-bd0c7272cb14	1HiVEKa/9dE+6JldNNCpHGrI6eh5YQH4WEYDMMwkKSWmwUncmoVONKVp5BTOWC/S5ZEKK7ysBe+1pytK2MvF1A==	78981c03-4bd7-45b8-b536-2ab08c0eec91	2022-08-03 15:50:37.262407+03	2023-02-03 15:50:37.262407+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c97c72cc-5301-4797-899a-a51d6044e6f9	FR/9QNMn5no+KPTPp+QMp+TaMA1BTrkO+1m14PU4Lvs7JBI4+fRB32qrtcM6Va/r0eI7gdrN/iiA9D/VxDWpng==	6082fc23-7c6e-4f48-931c-0585b6a2d0b6	2022-08-03 16:04:44.187428+03	2023-02-03 16:04:44.187428+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c2b30350-4deb-4c9f-b802-ea2b095371c9	5LFKDFvFMyolcGATpeMIiqo4NOUKGV539dZAq0TpoGqEjB2GjML+SSMsz3MI4NjvWrEXPPQbTos8gzCWrHN3hw==	948483d9-d95b-4ee8-a908-b2922293e053	2022-07-06 12:23:56.046977+03	2023-01-06 12:23:56.046977+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4e9b1e50-9bbe-4e06-9f18-ce6d1f44e58d	zlIeBvCrOTr/ShL9AP5kVqem6dlJW5BvIIeQQtehTa3ZEwitk5zmj0K2OuGzr/ZAcbphrQiBrSUOaps5tFZcWg==	bc99da08-2796-45ce-a3e3-e9f274534346	2022-08-03 17:27:24.993208+03	2023-02-03 17:27:24.993209+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7de1eba0-53c4-4179-84a6-0bd280f85996	0kulpw8ZNNkhp+jlQcr8lc9AzbGWJEgCbb09KNhQi/Rg1fHmxZeqFFTqRFKVIZyiXbZ2B8WcftdZaa9P/tHAPA==	4a6dcf15-df40-48c7-b6de-957fb46e7f8e	2022-08-03 17:26:55.610142+03	2023-02-03 17:26:55.610176+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a986d80c-d988-4a53-b1da-b1bf5fc7531b	j+o7URilFthx1PejqPtCK64ek/N0vbkutQXQWp8eBY7hyPtkdwiyFSXY+iAbTB1SX4xvJgDyrjwYK5l5B8+Nrw==	44991db8-60e6-4634-8eb2-239580b3d532	2022-08-03 17:28:09.373745+03	2023-02-03 17:28:09.373747+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2783a89f-5e8c-4915-a30b-872b952b2587	0PCpSbQI1MQDNFJ4lnAkopMWm7B9GV2pfEsZGvRMe2wQN8eZDkzxfjrWPuv91aG/5gQrMp4rkaWzsgyPhYOIsw==	d43f8a14-a0ca-4f68-bef3-9806e6dbf9e0	2022-08-03 17:40:55.055638+03	2023-02-03 17:40:55.055639+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fe990755-6c22-4d41-87f6-e11d34fccb72	TzvAnCvRz02Lc00oSBnCm9T65nlRmfuqnUXKJeU6kbYMnHOSGmwvlRZ7+UguTQiETMcRGOcKaR3zTKslfVAjuQ==	bc90be20-27dd-438b-a59e-6199ed45310a	2022-08-03 17:41:35.241497+03	2023-02-03 17:41:35.241498+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2931d39b-0f3d-41b1-80bc-80bc50e0e833	OR9HVFpePaHYhALc1ePO8hHxFr1qQkRnfXmrhzhQk29S67unlpQsoNUtD+onaoF0BOd7js7z4Bg2+ighKkxcPQ==	e51856b3-60c0-4870-85b7-e9f8bc192844	2022-08-03 17:54:55.780869+03	2023-02-03 17:54:55.780869+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c5f26415-dc1b-4c9f-ac0e-c93aef8e2ca9	4DnyNzkjDFcUcHUz9KabTGYlojGjoggJ7dpm/FLAkBZpMfy1OANEnFYUYeO14JA59Z4z5RVtcUe9eUUzFfc+tQ==	ecd03122-18a0-42eb-9660-586df9d8306a	2022-08-03 17:55:36.972843+03	2023-02-03 17:55:36.972843+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b7319943-9dad-4989-8dfc-b0be4af87016	ieH+HsDpiOO7YMS9mUe88Vh5bT//2m00H8BKEUKzoqNpbUqjfoFTyuegQdJFWzU7XKDovjvTN6lL9wRwR+3rVg==	b73ca049-77a8-4e77-b029-ca3482b6179c	2022-08-03 18:08:54.155029+03	2023-02-03 18:08:54.155029+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
89565863-bf10-479f-a789-4f3151a79ac1	akHrEOU0xGc9amdDJgnXGyJdzQD7OWrrWmO4D1Z32NIyvBuSaSND5UvAGa+tmnaBaNjzqDm5lJZq/rM1BL8UTw==	e7ca0a8d-88f8-456a-8fca-4b32b93f32e7	2022-08-03 18:09:37.94907+03	2023-02-03 18:09:37.94907+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
79fd16a2-4419-49e7-ae3f-16b5253b4d54	swlZzu7/HaMSQ/o+C4LaxLskgxJUrBNfd9ChMnHdOiqGNB3g3eQrjXv1o1xzcNqgjlftYyQaleWUE6qn9JipQg==	4cdd78c8-d091-44b8-9602-eda188c079bf	2022-08-03 18:22:53.04592+03	2023-02-03 18:22:53.04592+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
586a1cf1-dfd4-438a-8b44-feef97176093	bMPIKkzdgoKoqmouw2lDfpRxkIHXJmvY6NBWjpOQFFQ1CEC1yCX1wK7jMAn5wcpkIe764KK2Wz4M9FhO/qKq6A==	8dd4b25e-27b9-4ca7-899d-7a78c9306033	2022-08-03 18:23:38.993674+03	2023-02-03 18:23:38.993674+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1f4f2687-e552-4ac9-93c9-2a2275175de2	CUNYbZz401+hHzmDN4Qjry5EKUCFJQDXyW+/IkScpl5SpsEhU9xoGe81VQQzEoMsPbhtjnGIIBUSBjQd3RwxuA==	b7a6af02-e959-4439-8262-fc8bef17ad9d	2022-08-03 18:36:52.025056+03	2023-02-03 18:36:52.025056+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
78e3cf59-230c-41ab-935d-25f6811b5c2a	yXeos9QwKT0Fts2b+XKV/2voIFECIEdFO+Od2tCtAis0wBLHLSBhswfmfU7hIv0LA+AZCXAorSve06JM23W7Rg==	3d3107b9-372e-4ece-ad3a-e4e2e5015cf3	2022-08-03 18:37:40.127492+03	2023-02-03 18:37:40.127492+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ea5a51a5-3f52-4a83-b542-b76f1dfe7724	KUCa7xD+kJWKH/HcwbDfjSGmk/T8F4qYxtRpKxzpRMdDIlnwX5UNDWiAtqxuKf8ncOS11taj3C69IkXptVf8/w==	a149bac0-77a3-4b0d-8148-9738be7cf602	2022-08-03 18:50:50.703096+03	2023-02-03 18:50:50.703096+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a3932ada-ad2e-46bc-a1c0-c9f846b8f869	+4+vTB95L4W8pJ3NT98vT0Ir9d89xN+vTsVuTGKzjJQnQwtoj3FZChZyAFw9r8+5ske3bCL622/rP+3M9QtDsw==	47dc1c80-a24a-484c-941e-b5f662fc2f9b	2022-08-03 19:04:48.661178+03	2023-02-03 19:04:48.661178+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
383149c0-2ed1-481e-ba71-ac9dd020f441	5KWxtzAPgzwrULj+tvhezy67TJB0DOvOHb/E4nMgxspAC3T6bLyivCVmxwvhUwDgzwkjhGmFUeyLt73BNbK9mA==	e193706c-4129-4e58-bb69-c02a5fa5e2f1	2022-08-03 19:18:47.168747+03	2023-02-03 19:18:47.168747+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
b5c4fcdc-7b08-4bf6-a191-cbdf823a5df2	XnrlODVM79rCtrvhXjtIhJQuCaN4PB3IUXcfSjbjXzKCEaWkhXPBtlWXGCnCK9Vs+95U6ZPK8eMQVG6WT09AkA==	1c64fba3-2d33-4967-a0b8-397adfdf55d9	2022-08-08 17:55:08.347768+03	2023-02-08 17:55:08.347788+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
06b6f26a-f3fb-4733-8e3e-a249bd25aa0e	D7MFZ6QiHcXlRaf2A9Fo7kIGL/cV3QDUfQGDPpKDDmF0BimOwZiHsqiMnaKs3Y6A+L6u/mh9DwcfETvUtQubVw==	d77a518f-8a75-4e34-8612-8447f64d612c	2022-08-08 18:09:07.329081+03	2023-02-08 18:09:07.329082+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ecf0ba6f-334e-4728-b5ce-29c353303199	83V/uLRD2v/Q4zV61sgK9lnEFQScKnqqi9X7b79wlxF+cZ2UG+Ys65NDSIiMvVmKSfRlwnZyUfpPFXftBONXYw==	2a1242cf-0464-4022-ad36-c1e23dfbc572	2022-08-08 18:23:07.850906+03	2023-02-08 18:23:07.850906+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d6dd98a2-2f6d-41f6-bc4e-7892e48b3c69	9EdZhFBV8dwc7p2KfRcoR5zTlPAMF77SEHTEaYLSyeWHxELXn+KZstmM3g7Ye3J+b9dKyDLDOoGCE8Ic9vJRqw==	adca7280-f344-4355-8d56-8b5e89badbfc	2022-08-08 18:37:07.649017+03	2023-02-08 18:37:07.649017+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b04859fe-9de5-4d5d-bb40-c1c327df60d4	mIuRUlpXzUoTeXUnTNYBdDDQmCFeLH4uRA7M0A/xr7ZMj0aduRMl0VvWq5bBHa0uH3NPpV3S1Ug/QnBagpfyyA==	79a4ffa2-954c-49af-a4f9-f3addb154d6d	2022-08-08 18:51:07.558821+03	2023-02-08 18:51:07.558821+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6d2083eb-fa09-4d22-9d40-01876c2151cf	q2/y1zNY9K6liApKh/WqPBonJibLyMT77mx9Mk79KsBFXZcA6k7WqRDQCBu9cqiNE3rVyPD42WDOXUOl0VTCOA==	e4dcfc59-ade0-49e9-a60f-ce256f859472	2022-08-08 19:05:07.665004+03	2023-02-08 19:05:07.665005+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fca45ac8-efc9-492f-9cac-d8e7f46285a1	TUnRLq+18MimRUD9ZIWDIZNGdKpCX9dVOkV/9J96IRzn4PLZWeHcKhFJdEIXs+n4IkpzvHLd3O2y5rkFts6FuQ==	b7daff36-6fd4-4512-a0fe-f5d0872f2db1	2022-08-09 12:13:52.746245+03	2023-02-09 12:13:52.746266+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6af4e6d9-fe5d-4edd-873c-83fa57835fdb	VgOrz369bSJJMidXxIMwGvCGIXv1kY4WEpmAxAEfx+NbFyixEFDRActhXavXG66iuE6Te1Q8xeJviLG6eiCf1w==	e2866bf3-c6af-4f14-8412-5fe6d542a76d	2022-08-09 12:27:51.692219+03	2023-02-09 12:27:51.692219+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0947ff92-e457-49bf-8a0a-167c44073f88	LIri3bdMpwO/qKxGRFezx6R7PLaOigqf044WZk5r9hRjYvte6cWeZtg7ffTjtl1OA5G9YMd/+nAahTwWqe2QyA==	f0367593-e1dd-4c89-8c94-ffd42b890d10	2022-08-09 12:41:50.704895+03	2023-02-09 12:41:50.704895+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d5bd02a0-4318-4cd6-82e1-c4d5f2058176	GM86nQC5G6yV1rYIsN/e9XHARy5UVftkgWiFACrU15eB+AsRpZvVcToiCCvPRmXKkjShHWl3Dma+NpfhVs6aAA==	d1a3ee3e-0915-4b20-918d-44d7c2a27c1e	2022-08-09 12:55:49.628197+03	2023-02-09 12:55:49.628197+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
10a8e207-0453-4028-8b4c-bc86a927993b	8XUnOc1+BgqXa/NcjH7Fk1G5rgEtVSYE1bj3Kx+96mOYKuXZXRF9HeSyNih58SfkRyb8m1oEctOR17REjg0+jQ==	4844d36f-d759-4140-82da-78213b065111	2022-08-03 18:51:42.130275+03	2023-02-03 18:51:42.130275+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1c444d85-2d3b-40f7-8a1e-b0c9386b86e7	FUepoRZURuUIZsgdJCJL79H7nZ2ZdA4tAiez4oA7XYmcmGSpXcLMkjY47guPYtyp3bZUviiGZXpQ94IalxnjXg==	4860fd9e-93fe-4f24-8df3-4b001564a121	2022-08-10 15:34:17.220103+03	2023-02-10 15:34:17.220125+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4e3ab0cc-8a2c-46d6-a1d4-13e733bbb775	bT8sJul+pe/UGbU6633Up8mWsl3/FBo3xAICxl7Dq1Bz1psUQN9CXuZXCJRTRJfjf1g5NStFe5dRtok3QCCaxA==	794ed96d-550f-4665-8d1c-42701a7bd439	2022-08-10 15:34:57.840525+03	2023-02-10 15:34:57.840525+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
a1b6f344-b39d-446a-aadb-3d07465d800b	mg35X0Fe0/dMwc4lbkUCq9DLmp4kwzAcYZ8PyjTos6gY/urtAkZjnS2JimAT5zmPNahukoM4ufrZD7LC76KdrA==	0c20809d-babb-4fe5-91b6-d0fa34e7a6db	2022-08-10 15:48:18.86807+03	2023-02-10 15:48:18.868071+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
53ad3d5b-d0e3-4779-bde4-0773c2b5b9cc	dfh5tsp38z9yui9kBgPCfe75HHOzjenv9qSnoJH+W7StSjNL2mzOs2E628/kpI6ie9Hjj538Xx9ey2bJ/z2oJA==	16698e1b-9f68-4f3e-b4d9-475051cfa0ea	2022-08-10 16:02:20.016978+03	2023-02-10 16:02:20.016979+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
00151a68-1130-46a6-905a-db7df774f71c	RK7UpREaiseVIaNDq5ll+9BlTRC7GRJ00NP03EfYiw2WvQnKPmVgAJRCHFsLHy1Le/tfCgNbFlKFxq77WVIJIA==	021a603b-fd41-4922-a772-23c29b124ecb	2022-08-10 16:16:22.055656+03	2023-02-10 16:16:22.055656+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
77fd47aa-c953-424d-a399-3d019d7941ae	UZKR+E66BXZa19kKUEzzXrbT93ZHPVW15rCrKr0Jsuru69VQHHCgQ3ODHHJkcPyfsJ85jDprZT9I/Ew0IzOh7w==	18489de9-c965-4b75-9960-be00767e3f85	2022-08-10 16:30:23.930916+03	2023-02-10 16:30:23.930916+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6071a686-6ed1-44d2-bf40-e88393f5c0fd	vy0xGW9iRRDjnrAp/cw360XkM7++qHYVq61IgYIVDQQmYoEfRQRxCO7hJNbB4cOcyK0h/xdnizCbNzSaakpMJQ==	2ae7b775-eb21-4f3b-b2d6-f7d464ba4295	2022-08-10 16:44:24.91908+03	2023-02-10 16:44:24.919081+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
efbe1127-8ede-48c5-81b4-228a1d17e669	msqkEk8Tf+mRak+6wVezLngZmhj17FF88wQf4AwrRmp8F1CjwSuv4QIcO8sEigh7Rdfm3M/fSTSONpCOdFpKmQ==	35a6d44e-7f00-48ce-8f5b-15d45ee6f2af	2022-08-10 16:58:25.937897+03	2023-02-10 16:58:25.937897+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
224c954e-9c11-4f9f-b5e4-36b2d0c51d64	k/+PHopNz1tnLO5h/kzYbxt3mPAUr2hAU0zREpzEClLtf4h5e9rv2YPgZ5uioAU0a+m0SZsAZYnPRfhLK55TAA==	1954b680-8b88-43ed-909f-55b61439f95d	2022-08-10 17:12:26.872033+03	2023-02-10 17:12:26.872033+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
794a01b8-e3c7-4bc0-989e-b0cae4207a7c	39nGfyWnQj9sT4AwUlfkAIlXCGdEZ5f3eCmn5oQ6KKz8HjG7FKaEPpz8KAzyZISV5BvoNzlmDzWvZXXlMHxyxg==	be0b1b48-2416-4484-9533-739063e55d59	2022-08-10 17:26:27.987937+03	2023-02-10 17:26:27.987937+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6a0482d0-ea16-4993-ba8e-1764a5c82e37	HVNUc1UDQbDOb6ce4PjuQUZjicPy9wW3uDPyXHHdQ7uDFmX8HozfEJ06bqSIyIBkMVBc3/b34300ahA8K1fb/Q==	f3b210b9-1409-425e-a4ed-34b0139f71e2	2022-08-10 17:40:29.194546+03	2023-02-10 17:40:29.194546+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
713287fb-dfd6-4ec4-b032-a66374540f56	hMrm9Kv8NgCCHI1dCAd5OCMqOHh6E92dJtk3wagHif/RNxqek3c9ayLKJDaEo0YJXtWANrT+wpHtj4zFqEvnUA==	d9516d19-2d71-4ec3-8241-217bd20174c5	2022-08-10 17:54:30.992529+03	2023-02-10 17:54:30.992529+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d010e55e-acd7-42dd-96ac-c5768a672d59	LMFTHLnBqf99oYseHl9zGPe5U8NscSscr/SukbWsNIevBdDx9vAlZ2cd+05jCTFmWGVp/lBWp2gDU9u4jPrwrw==	3943862a-9653-4835-82d6-da71c8e2e216	2022-08-10 18:08:31.998669+03	2023-02-10 18:08:31.99867+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
121dce70-bb69-43d2-a1be-020f86c71178	qOhG51xjkFsfuLoj30VyRSmfQ4ReUqBVMWi9onBeulCaweP5+j7HmkLKxKwTwV4BMQEHWINnSSQEJPaPZs6N8Q==	9dd6251b-64e5-44b1-a0ac-f1157f637841	2022-08-10 18:22:34.021568+03	2023-02-10 18:22:34.021568+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4f29ea8a-b300-4f77-bfe7-e0bd80d3c7b2	PGGIDiqiSlR7AvQBtjbnYBNscmFT2hzpRFm/XXJ02SkdtNs0smb7yJ0CvE7njyfT6hcGNwytmJv7qG3OOydSDw==	94c1388f-df3e-4366-b966-4ba2f58f81c1	2022-08-10 18:36:36.101113+03	2023-02-10 18:36:36.101114+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
005f1cb1-5cfb-453b-a20e-c4fb2161e728	AeWSAHWzmnCrNjAZ/GOig3TCibniySuR53IPyyTz+pwmuMrZqiwJg1RPr6x+fqX1qW5wJMPdHMzyXEAIuHtoEQ==	46eeb15d-f70b-40d9-b6b3-e39ec4206d64	2022-08-10 19:03:35.546133+03	2023-02-10 19:03:35.546133+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9e95c461-9b18-487d-9930-a57d10e85345	4KDKfSlQRLO8nzA/w49Q6d7VDiK1O/7NH6cIkVq3wWnkqaLl2F6fwxNaeAcW05g4N3t84vWCKUNph2f8MSqRDg==	11dc15ae-d7de-4af7-8ff0-de64d2cc8235	2022-08-10 19:17:37.429342+03	2023-02-10 19:17:37.429342+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
65d0e7f4-edde-4eb2-8057-a5fb7090c416	kmZNYyTBSA94W0oIWISskP48ugWJRfF1bE6A+ug6UJ9+/nRDGhWUHu0TznIrgp/XZ2i9Gdtu7/QRFlpyS8xXrA==	6d30215f-704b-4bc3-913e-870052f9c5dd	2022-08-10 19:31:39.27399+03	2023-02-10 19:31:39.27399+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9cd6a641-e968-4690-bfb0-dc8063247a7d	tRfmhDLjfvuw/kfDd6Kp0rC/z/9gpHTx+xVzBCVhY/ypXPMdWnXoapLrAlE0r/pWHQBtG1x4g6MhFw6pY+/qeA==	693c5e39-8f5e-4cac-b8ee-74bdca64afc3	2022-08-10 15:48:58.901577+03	2023-02-10 15:48:58.901579+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
76efe007-9bb0-4dc1-9e61-814af376e46c	e28+LnzqWYrQayYs4UKbypNks43pwwVgTe2ieh6S18s/HHDT1UStZ+4DLZ60SQ1ch3aTHGaoaHdAMe5sAw1OHA==	b0672625-ba70-4ec6-aa96-800e44ea4ed9	2022-08-09 13:09:48.683623+03	2023-02-09 13:09:48.683624+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5e3a9bf8-5e65-4538-a128-a112c984c901	8ge1YxMiwSwkr40Bh+2WqhMTetXFb9d44WMyrGGPoPgLbY6kaE8NlIzlxm3dQFOIdPlLpqZofoT/K4MHWpCJoQ==	495b518b-346f-49ea-9c11-f9cff1b9e66f	2022-08-10 19:45:41.26254+03	2023-02-10 19:45:41.26254+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6f13290b-dba6-42b5-9539-5b34755e9229	QvJ60jH9nI0lzkeY4dICfDTbwnYClvt4JzMqdzg1uiPwRXa/KIdYgfKeynwf+ziS1XuSiZvWvAD266bisCbdjw==	ab71ea59-6b82-47d7-a4ff-e3b3aa594035	2022-08-10 19:57:57.007661+03	2023-02-10 19:57:57.007661+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2fa54d5c-01a8-498e-9b17-2dc3fb6e9f9d	lmoT2vMxbUMoScnw4akUs/vOmYTpwBNzLAvPkGeBZQMcf5HYDucZT4WCH1cLinqPCLjZ0NzfaZZrLT+0Q/YJ3Q==	eea9c908-e7df-46ba-8a25-f96d2a7d7ab2	2022-08-10 20:11:59.267472+03	2023-02-10 20:11:59.267472+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
04897f59-f091-470f-ba91-58977e14db17	VaXtyR67RZ1ZD+DPCQA19ADh7BtwVY7MkzQWn80l5Dv4w3sybTW0n19izJP/bl7TFBMZrdLWigv38KfH9qxyLw==	9c2d5057-67ac-4745-9715-573ba17132a0	2022-08-10 20:26:01.256669+03	2023-02-10 20:26:01.256669+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
95030291-c0c9-4fe5-a170-f6570984b349	8GZHG9C3mKQJnf2DmUlehJH0oTtNWVJI4LPD/zdIu8BYe0cSzJxkmhFGyiaDLQGxMQUNLRRtdQLV2KvjJ6dGNg==	094afd93-201e-4f4d-a18f-5c232a7dfca7	2022-08-10 21:26:37.649997+03	2023-02-10 21:26:37.650018+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ce5d64ad-9fcf-4275-a369-549d65da1d32	hccCXQyeqzh16citEVwlefOBE3dH7yndGlnOkWtGYgKemkrqSZRSRP3ZinIvmQq3CGbs+w+U3IUny5vuFkp0rg==	b472915e-3d38-4839-83fe-baef3fe889d4	2022-08-10 21:40:39.260633+03	2023-02-10 21:40:39.260633+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
601a1fcd-ad89-466e-9480-7441d62baea8	qoz7jbQsara7JkV0npCv9l3nax8kun77CJftXuqSa9jQgiZ7U+GRN1xlje7WD7qzYsQ9p8i/vVy0mbwHHdIz1Q==	0093c016-676e-4fa5-a9f9-011c293b3153	2022-08-10 23:46:28.530979+03	2023-02-10 23:46:28.531001+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e8e4f349-b7f9-4d36-9b02-71268e562df9	34WtGt2xCOo598hhbM/KrRnH4ot38SZetBO62MJFjiTPukQEj6WCa/SooCNmt7VHuDBWsc9OJ1m1dD81YbTbyA==	8ed00022-bea3-438b-9859-a3df339587dc	2022-08-11 00:00:30.276637+03	2023-02-11 00:00:30.276637+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
606d8906-176d-4604-a423-36fbbe308400	SkWFUTY//2XzH7eXE/R5x4NGYPF1HC5suXEwYBbzgfQfmex+uGHuGBBTCShq6pEj3Ns8ez7oFy/3GuCNlRm8JA==	110dcf49-5486-4442-9514-b90f535e3169	2022-08-11 00:06:05.241371+03	2023-02-11 00:06:05.241371+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
60e1f69f-16f9-44d2-9290-723f314065c6	wqWG7p/gSbbnSmz0OAGk1672kLpHcvk8xeXHyETS0491WpuPG0UyHMj3f19DYLS1LAmBPkBgcTfAvC1CLsdDow==	37eee49b-654a-4c1a-9684-26a0f7d6c515	2022-08-11 00:06:51.158429+03	2023-02-11 00:06:51.158432+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
efebda2a-9725-4ef5-a2a5-ea3945e5701d	qxSxjooFmWJ3Nmcz1FK32Fky5mAoTu091Ao1yFAlPtAMlI4+8R8NYWbIHkreah+Mcg3P42z61J8bsJwehTrWrg==	9c4fce1d-48fd-467b-af2f-6afa54fd0da8	2022-08-11 00:10:40.769608+03	2023-02-11 00:10:40.769651+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
26748a1c-ee84-4e32-be39-95a4963fdebc	kJwHWXIwzp97T3G2bdJOS1n0e8mkylBUY32mSnoDjzpTR7Y7EYm46LlCTtpMPMYQEHVsOSZLBi2vesJ6c/MwkA==	f5a174b5-3c2e-40d6-8dbe-a8e7e978ef9b	2022-08-11 00:08:57.99079+03	2023-02-11 00:08:57.99079+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
6c4c44a8-c1d5-4676-90ef-82215259a068	fgZ19I/0t0isTtNBw6GUJsEDNaEYdYqAewnfsShBIeMDWBLArv1Mh4Qjq4UPLJFkfHwUc3BHp597IfOkKojdEw==	dc7b4f01-2820-4237-b6d5-d7abb0a2b290	2022-08-11 00:11:04.504374+03	2023-02-11 00:11:04.504374+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
a7eca0bb-fb4b-475b-bfc1-90d44a71b35c	DbzCwnLzwo3Qb7e77Jcm1Vq6JwlDATbYw9+Th2iEx9q3hEqxDYUTBY4IlGoqoyIogdU4aD5XXferqS5tY7XaIg==	cb691ab2-a881-4701-9b40-45e5522ce814	2022-08-11 00:12:38.585087+03	2023-02-11 00:12:38.585087+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
c1edf8de-1d9a-4529-9ef2-bc73f0461666	mYx2sN+oeqtIhktXV+zRW+uG5aN5PHZdTfCYP+N19Xf+74AkKbb23PAz2JpNgl9hFvruSo1hv849iumOtVo60A==	9b6179f3-cb3a-463b-ae61-48eec642ab34	2022-08-11 00:12:46.430709+03	2023-02-11 00:12:46.430709+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
f9795031-e072-498b-8e55-8834d1631998	JkSOk3W0nBR+QvF8i/lBr4B9Naw+Op0cXzuxhGgB3kYDDjoKNIcUkymdnGvU1yUeb2D2YDrUzcCmt+LUx3v/pw==	c9087103-ee81-4b1b-96b9-f83d285f2ea5	2022-08-11 00:05:49.328837+03	2023-02-11 00:05:49.328911+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3c24589c-0b44-4f5f-8542-75cbc99e8018	1yqlRB1vME2dQ+pq81EfRUSTPQTqSub8tZif2QYUTaPYJb6fs+lBznlRzzwrjJsp9UQh0+c+S+tzgqJ5pTmR1w==	f3be732e-aec7-47b8-a37d-deae05ef9af9	2022-08-11 00:11:38.349254+03	2023-02-11 00:11:38.349254+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
17c4e110-2280-4ab6-8d7f-26fe06b014ca	3pJq44aFighg5IDF6DW40WuNZ9ye4Z1RBl9WZ/qvctJifSu3ohVQM+LYg1bMDDurpAoTKaVvLRMHsvuqdy9XVg==	e17ab28b-cc24-4b28-a008-5db6cae9b49a	2022-08-11 00:14:56.292027+03	2023-02-11 00:14:56.292027+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
02c9d27a-00c3-4fd9-beb0-43dca41ffe79	zSUi0P4g5K4SCqhGkhn00B+ECfQl7DfTU+kR06qZw8jnEHa1VY1XtZmXKy9KgxXSCPgtsWxylLqJA0rRMc+PXA==	9809ee75-4279-4dfa-8b37-caac74946d70	2022-08-11 00:14:32.067951+03	2023-02-11 00:14:32.067951+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1a5f63eb-a474-40d0-b7a3-f859ab6c0652	mBsCDrza57GXoX0FNGZ8I4F5ObDCgPrssVItRl2hHodk6INOCzmVXoKDLC8fVLdI66fbAgwLe6i2TTa2cznmjw==	7858c798-294d-4618-85aa-5e408d2e30dc	2022-08-11 00:17:25.916174+03	2023-02-11 00:17:25.916174+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
924c510a-4991-4028-a5e0-80f167161c68	I7Pt6J/w7YDdrPOZvalHvElT/ovYHehVpLO+T70AlRQjdHy8nPL+JWEy0bm6dNOIscYJi+RfBnec3LCbIuFfZQ==	c268f432-40d3-4065-9931-9635dafe903e	2022-08-11 00:15:02.443112+03	2023-02-11 00:15:02.443113+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
fee7cd6f-20f7-43e1-8c5e-950167a5f17d	FluAjqq4XYQ6tJpr6KJwhnNHw923joI91vVDVuNi5fq3bBBqhokJxOjMNWfra5zYaX6/ZvyJtKfbP+rVUqHyug==	90fb5a8a-bed0-4513-8722-009e1e917d4f	2022-08-11 00:19:51.157082+03	2023-02-11 00:19:51.157082+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
95ca857c-f6e7-487a-be07-ba41ee6ec87b	tiQfgfYZaTqEaSXp7XuvRl9E21BORooP7WXbesa5HN4AazJETMSbg9z8OvCGUrtDoGCuPg2Z+poYm5oA1Jx9rw==	eb847381-4b9c-4104-933a-3ca8686fc25e	2022-08-11 12:41:07.783775+03	2023-02-11 12:41:07.783796+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4fd23c84-d401-4c95-924e-b94e8f165446	AHwhaMyqE27JEOChr0cJtl9jx6bNWelRNW8rbOwhMaYIBdrdrSNjFxSNF7SlDsc4gyh7JtDvBbOIuoQlaxoQZQ==	1353efae-4b33-4c5f-b90d-7b1ebbe48d1a	2022-08-11 00:29:05.18749+03	2023-02-11 00:29:05.187517+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
2c125d12-3b86-4bcb-9076-a0dbc84504b2	giqzGjQELeivOBZGHkgoqPzGuN3cAUBoWzQjScayZftFkFyFQs5NWcAStykOaDLbxb/U/lOmaQsZ09VD5PhOKw==	fe0e510c-d4bc-4044-a66c-97d47830bbe5	2022-08-11 13:49:38.17545+03	2023-02-11 13:49:38.17548+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
79e1f891-6c79-419d-8f1e-30ebeb11fe40	Cbc5fi9bcgJNUIkmYhqazNk9QcMzT9xFjKlibRLNm7T29RAhShXVD5xneVUnmrxtEAdBzKfQNciEGU9a62LTlw==	667298b3-3978-4124-a4ab-e41fa2d8aff4	2022-08-11 14:03:40.014909+03	2023-02-11 14:03:40.014909+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
4e8863a2-ddc3-4369-8488-be4bd4194ad5	PIhO6mCX+0uvpWKBwHgIBNhwE3SenpDRBOEQdBdy75TySEGLB7sX0b1kczanpwE8dHQajiwOlqXoRFaUvoWAwg==	0f20b2cc-b98d-4deb-9e18-e6e5e907f655	2022-08-11 14:15:17.649051+03	2023-02-11 14:15:17.649051+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d65c8b84-8c70-4e2d-b6dd-394e2b97dd2e	JpPXuvzGtoWDX1FTN4MNbCWqszGsVUvzFNdLqnk8Bm/wkmNoCgYP3t0OTEzJ6g7o2CzQ0T6G5lGiUjzVWHkMDg==	8c2ac236-c3b0-49a2-8dab-d6c25351284f	2022-08-11 14:15:44.60165+03	2023-02-11 14:15:44.601651+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
751bd918-e225-4fab-8310-c81d801f2719	0wqo0/43cHVHygJt0CUb1ECmXyM3D7Omt8Dts3bgRpVjgENuX+6dG/YpJ+QNAm1emP7OZsemxyyNX7QVTpqEUw==	9b7b7b0d-0570-43b8-b11e-0b82321b8a5a	2022-08-11 14:15:54.163381+03	2023-02-11 14:15:54.163381+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
b7db35c1-4e1f-4c77-a149-799bfebfbbda	z7NIEED88oGMPURlLhB/XEUp6BSuwnGoCoN6B8rjRo/2OOZXS7Ei5g2LNj/V3+vgLDxf3TkJ0qNe7avTJyic7w==	580cdc59-3b5b-4a01-820b-75ddf52c0476	2022-08-12 11:42:17.783359+03	2023-02-12 11:42:17.783388+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
07ba008f-0f4c-4c23-b862-db65438d717a	VzMvpr3U3T4rNf8rXgR/vN4EiR8WNfVKI48oheHIAmnH+k37cxA3xzjulXYP6/5Ze6+rxA7rLo8b7YOSlqUG2w==	26a09297-837b-4829-914b-194373aea6be	2022-08-11 14:16:07.768913+03	2023-02-11 14:16:07.768913+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
259eda6e-8ef6-40ab-9c7e-dc1b3831788c	np9F9iTl0XkQvnyI1wwle7L3yl6dl42qjNgWFVOptEiDImZqVpTObgS0tq7P+DqTV1qbvgb7afPigV4Q+n5esg==	b0764fd2-79e2-49ed-9ba0-8d3b14117eff	2022-08-12 11:56:19.290547+03	2023-02-12 11:56:19.290548+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
39333019-f3d6-49e7-b9ce-810cbad00c91	YfBuFObcatQBuPVu28faKJK1JzTPUj6e1Fs3qwK4+KUoFcq5d01P0dK3GNZxxmAny57b16gfNzayFGV33DOewA==	40a702f8-e763-4bbc-a1f6-cb001f2465e3	2022-08-12 11:59:36.940492+03	2023-02-12 11:59:36.940492+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c6eb3c6d-cfe1-4c2f-9081-0a0af52dedc6	8hea4XwyEHNrnglwrTIq4AJsDSLmhtdrubMCnDOhdj85i9SmdEE3HWuLNHd/a6K9Fq3YeTnn9JyTzFXHfdRGHg==	b5a460f6-9262-4246-a66f-6cc85ec82e88	2022-08-12 12:10:21.279371+03	2023-02-12 12:10:21.279372+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
7061fe79-2290-4243-8f5f-5f0a7ddfea55	NtxwAm+pghBSqEFOfEqQhEn5JauSyh/UZSKh9RhYK05oJUC43yomAaW+as0ooAQwmbAA+4OoK44noH71/B3D3Q==	0cc8fb90-d211-43a5-83f3-958b1dc76c3e	2022-08-12 12:13:38.225641+03	2023-02-12 12:13:38.225641+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a1379899-7675-44c1-bdb3-a6f06bf60cda	OM9+zBQA2BH+/V4iCvXaIni/xU8zjIkXO4Lu5sE2U+pWo4jujZd6XzhAEhiSHVsevXYaxsere9+d6VYG1rKeyA==	157fa8c6-7403-4f48-93ca-b6aa76667470	2022-08-15 10:40:23.970764+03	2023-02-15 10:40:23.970786+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
924489ca-7dca-449b-b689-eca5b3630307	iGyYU+sbwWcbebRqQvVqClw72gBGcbfZZRdJLJkYhC7iivvLQOG22vieRF7tz4Gl9KnH1nvO047pDn8/dYamOQ==	4f902224-527d-4cac-aa16-4a42694f698a	2022-08-15 10:54:25.510567+03	2023-02-15 10:54:25.510569+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3e51a65a-3516-4821-878a-391d91b313b7	uf+UnDfs2wG5jPqjZu5uuOqVXaNL9tx6D1JEUpsvGh0J+YLuvArDfYCRATRmv91fQOz41qccYk0peL7zBmdRpg==	d7c5f38d-25ed-4a6e-bdbe-de947874dfb3	2022-08-15 11:08:27.358236+03	2023-02-15 11:08:27.358236+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7daab275-056c-40c8-afca-d8cab3036e44	4vGJ6+D6/ztz4hi85qScFoy9u2FbzBcItwpfUxGVGUAPBqzuv1Sf93ABs3p5YzoUwJJZ4nuw7/+bUbV/R0aP1g==	f39d64c6-3612-4978-8b6b-8131cfd91743	2022-08-15 11:22:29.342996+03	2023-02-15 11:22:29.342997+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b1d10688-eed0-419b-b86a-7c9541844863	zYaacVPyXI/Rm2XmKngVFE+Irfaag33xDl94aHHrlN2kVbI51tii9mQHbatPfDmS91NB/WWfQV4gLimMBuf3lw==	72ebf852-2e05-4f4c-81bc-d3cb76bbf442	2022-08-15 11:36:31.319033+03	2023-02-15 11:36:31.319033+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7a5db2f8-b8ad-47fe-8465-004ed5004ae5	ECgIRrr61FQuyJuo/Q8gIKygO9oEh68zj4/J3y2esgRwgTNGowVLJUnRYqo4DNu8PA96BGCQsnq9jV8EPLqYKg==	cf13524b-fece-4143-8b2e-4474f069e8e2	2022-08-15 11:50:33.508946+03	2023-02-15 11:50:33.508946+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ad1c6101-fa30-452c-ada2-7285ad1957ba	mV+3bRyrkkIyUINEZ2EiPTqZcV+uYf61H0Mx8cqXVtcJheMQ4dAilNQnIX6vxVpkczHl0jSkiEfAUTb3bTSxcA==	1eeac6b6-d128-43a6-8505-3b10fabe77f6	2022-08-15 12:04:35.475718+03	2023-02-15 12:04:35.475718+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fdc478f0-ec93-430a-aa8f-f7389700c5d0	jzXlR6hC4eVwFTD5JPw5bMy5A0tcjKG2f1U+y1aC9bWXIp1UucBp+mQ2Ah7WTUBuUNKzA0b6Td8H+JRH1KKVCA==	c36e1563-112e-4f82-a85c-e4dc09cbdc80	2022-08-15 16:42:53.305983+03	2023-02-15 16:42:53.306018+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a66bb9b9-ebc0-4ef7-b68a-365744aa98df	V56dZnYy38wdVQT2ZwKUZ3moYqkNam3orzTO6xx2+JsL4EwcHUvjae5aeqZlhYwbq5NNk8g4seLxOXanRXHiHw==	4e7cb5c5-1ad7-45c0-977b-43da40b112d6	2022-08-15 17:35:56.054074+03	2023-02-15 17:35:56.054099+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
677d7ee1-f992-4d4c-a68f-bb3e5127141e	ohC1yTfHd7bsJLZHkJSv5izX+1SuIQ4UlA6EzpHDytJZPm6CXemYt+jFQowaVW+AABBpazUAFJ0Q1bQAzWcMBg==	0b620f65-5fac-40ef-921c-f5bff65b1d74	2022-08-15 17:49:58.126357+03	2023-02-15 17:49:58.126358+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
da0417d7-3493-4a44-8eba-f2762674a336	EFLV6U/l4+0B8yzzVKpUZZ9Oef3FbH7j/r+iOKBNIdNl25UIR8YJb9JYHl3XsW5foVC0G9Z11xE+TrMAL2EIzA==	1a273944-227b-4d2c-81b4-6aa0c3d15e70	2022-08-15 19:08:47.867355+03	2023-02-15 19:08:47.867378+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
df72130f-d392-4a84-8f92-9a0c8e7f5fa7	gZJqWTorgm0pfDXLTKeRpal64V2go5CVidyCXdQcE+hUooRdBpY6yYfpuOAG4Fe5XefGZAXHvLpp5lPZcg6QUA==	1e64dfec-9af3-4d4e-8f8a-a9f497d250c0	2022-08-15 22:53:16.211896+03	2023-02-15 22:53:16.211917+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c5853bef-e2db-4d70-a500-150b400466d6	umMWYRSsvIFldpB9An8JnqHGp0eF66QyySzkv9VAbIIZTXDiRp0fFSOvZ0/qg5S3Tt63vHl4SC8dD1K2OInl+A==	3187fef7-3ed8-4cea-bde0-da6a668af02a	2022-08-15 23:02:33.079873+03	2023-02-15 23:02:33.079875+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1f7a3f86-3512-4e4d-ae8c-c0dcf23035d0	su+UkJtrcGqG8m+BdOgXi1/FGOs5KpVL14cpOGLPTsjyxWglcWP/szvXRXWlG7XYBgwzdMWZdqMh4el0xteZSw==	91210d88-94e2-4f42-99f9-a52a934a3ad3	2022-08-18 22:54:24.856271+03	2023-02-18 22:54:24.857116+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
3bec2f69-f78c-4ace-bab0-355bf058a8f4	XCnPX8lKmE8VdoBo7gqMVUiegJvHIF8DCBZukluN1kz0J4aoOnubsB2P0lbEcOvphk9zvlqX7XT1djqkCDYKAA==	65d08ad1-6c82-4e80-a962-586c10e80905	2022-08-18 22:55:47.264496+03	2023-02-18 22:55:47.264497+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7b57ce0a-f6b3-424d-b923-74c9a6d5ad47	KlMDoif12DFWj+Q4u0JQ+OwAx+e4jwrNgPlGubDx7wmk7UjQWLB20amHqb1SjjVnk3EVSEcUweDAhBihL88TWg==	8d5a37af-45e9-454a-88bb-5a79c675ee72	2022-08-18 22:55:21.754123+03	2023-02-18 22:55:21.754123+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
6348325b-896c-479d-926f-6d6d7742ebe6	NtztqpjuSDt5+zfCIgRi1Dm32X48SaMpQXN04KdxlbTs318hFxVQRegeHeFMOwQKSSexUXqTuaWYeP8H8Q6bAA==	64fc8f0c-83c8-4962-bf08-c7c349e6d42a	2022-08-18 22:56:45.172014+03	2023-02-18 22:56:45.172014+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cf7d8713-5e0d-4a89-8ce9-5d880a3d0b53	ztFk4VQXtm4haRrFhscodgBcFtCcNBxH+IJjg7fWkUPsfFV0a/svMtARHI2GafDKVF0uT/skaJ0R+miU+YV6fw==	9ad2caf1-e5e0-45a5-af15-b5a2cf146e01	2022-08-18 22:57:21.0759+03	2023-02-18 22:57:21.0759+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
00b1a388-0b2c-4009-84b8-9a0cbf20c106	gZrj8ZpqyLLMkFlC5icaRRIvU8W8SkeSFN444lpmsdHopcIynOw8xk9DWf03mZf8DWCA7f+F5biJYoNeWd+Cew==	c3de3cb8-9570-4cf1-a63f-7c90bc488048	2022-08-18 22:56:57.542227+03	2023-02-18 22:56:57.542227+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
02f389e9-56c4-43f7-9775-813c58761fc5	lwWcHPFGcSEyep8SA0Dtz6uqsmS1PPomfLK9WAiak4g8nAqvf8wLmC9TH3jU6me73s5Jm53M67DJtVZwEv54Ww==	085111e3-3837-410f-96c2-3a106d6e0e4a	2022-08-18 22:58:26.47238+03	2023-02-18 22:58:26.47238+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
64ab9df6-9b1d-47c5-b75d-9a99f04c2c75	DcynVsG7pOGIhak9ljeFpZcgj6JbBK1jAtILCS60oV6gEIuerd/Gnjg4XYyk4/89GpXtsK7HAJI0nA8o16nKeA==	c5c227e7-3bc2-4b18-beed-2b8c4074e87d	2022-08-18 22:58:26.768624+03	2023-02-18 22:58:26.768624+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
4d0d33ab-196c-41b9-8015-000c170d0fab	Wn/jIrNJjHDeRMF7QcN7SJvKGRLJWMvW5+0zQKp2bFff7IjZewgxg9IP4Ao3y/XvH9d5OgtphNUGWKwOhCsAZg==	0778ea68-dbec-4ab3-b8a5-aec435da7bf9	2022-08-18 23:00:52.849387+03	2023-02-18 23:00:52.849387+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
239e6e87-42c6-41d0-835a-fe2aeb0945f1	0R7bar41anfmKtaGMUhxuKYYyEZR/GD1nET6etzyT5PAKMnXgQAP48ZH63kHIMU5ugJYyJngNV8qXdHXzhufVA==	3b968c14-f0ba-4b6b-92de-a475d9f0f827	2022-08-18 23:01:51.453798+03	2023-02-18 23:01:51.453799+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
a4762b95-0d97-4949-812e-e685aa2a696b	I6Wzi7DF8IPq0wtb1Zw2lPnVHvVCd8R/DB0tLMWhB6T9ylrt/SUcO1/XZrOYw2iENSezRdZ1gqW/BcLHScjs3g==	dbd85e76-8acc-4b37-8ab8-b802cb6aa48f	2022-08-18 23:00:53.223346+03	2023-02-18 23:00:53.223346+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
ef0f3814-8619-451d-971f-23d80634929e	amSENjcOqxmjO2VcHZJRWYgKKNgC15EOySQF20hlmA1hM86ReroIJeA4R/19RO4IFutIVThj48jUwcAxBdYS8A==	84d04576-6508-4d33-9bca-0ebb281d1203	2022-08-16 14:38:03.048488+03	2023-02-16 14:38:03.048509+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
440abf16-e852-4ed6-9dbf-8cc93c318f7b	99Pgk2+1QS6e3BDVmR+G90f4ZUSPSw4Q2bsFsAVL0R9ELAh5+RmOYuCmC53djuv4DC/Av34P5VfAec8G5SDBuw==	42f2b1a0-383e-42e0-9105-afb715d4c22e	2022-08-18 22:57:48.000976+03	2023-02-18 22:57:48.001006+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
ce0cc0b6-a665-43cc-ad2b-c05f3c4d86d9	mA1qRCm/DM0yZGG49XTzzq/nla6xUiGZ+LeiTIy3Cr1ZTjR5nPM4f6FpkEpn3HJPcwixT9nXisMB/rwmfhe4iw==	656b8079-22d5-4479-bffb-307f1fb7a548	2022-08-18 23:11:49.339296+03	2023-02-18 23:11:49.339298+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
078926ca-5b17-41e2-8c96-a310fc4f4d5f	F7E+styI1YB5njF/4+20MJzKRj4XpVERjXEYdnZgq11Oz3Rzzdxb889iq4ucY8keWsasWrm0JnOpPo7U7Ndigw==	c9d0d2ac-aafa-4b65-b982-84b44d55d656	2022-08-18 23:02:12.941658+03	2023-02-18 23:02:12.941658+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
9904138f-51d8-4ce7-a347-e04eb8d2359e	puwyCSNvand3RESQEjXFWc+p4TTYpReJ5qTmyNXGchbz8z99R+ss2ijVDYcXO8HmaPgUkX3aYO0mICEm5KkD9w==	cb5ce1e4-167c-4729-aace-493ea700a1ae	2022-08-18 23:13:35.857509+03	2023-02-18 23:13:35.857531+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
edd6ad7f-8b96-46e1-a65f-984552a5ed26	40DYwG6yXxWLLtcKsjpvJ7KhbiMqL0bOXQEvUVIeFtk3N9NotoZBvOHzv0iRRFVGlwgpAy41kAhGwYbCbQdujg==	61dc0c57-73e0-47da-bb66-de2ea3d5610c	2022-08-18 23:14:10.10981+03	2023-02-18 23:14:10.10981+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7636d9c0-b9ce-4663-9fa4-73e607239dc6	vN22fiWH+2E6dPS/qkxxH0P9e43CfSln2C8hUB6GO+fB8BjoJRLMfuBia2epDzDNv6qx+/jJvnvdsxupWS5vgQ==	71629d10-acf2-4b44-9e26-74bcf1a9941b	2022-08-18 23:06:48.857205+03	2023-02-18 23:06:48.857205+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ffdfb7f4-ddc4-43bb-aac8-2f21fc8e050c	9eoNRMyURKOcIxuDA2yDSBIR+nNjwOB+42hwDxGXbfCE4zqA8efg2RQLTB1i5J22/O/hq3mVwkXGoBlyK4U7iA==	fcfd88a5-9178-4a5b-b77d-66f1984394c0	2022-08-18 23:14:54.521134+03	2023-02-18 23:14:54.521134+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cee025c0-1465-4d7f-9e8e-5ce181bb10b9	SREe85OzTkGaiBUN5mQCfPQD7PUoomnPd8prsprixff9dzyFkR0IRPLtFNxbWssw0TT6VxHPU8Ba7gV7JEScIg==	0eea6de1-2d47-4e2f-98cf-1bfac74a236c	2022-08-18 23:14:29.387045+03	2023-02-18 23:14:29.387046+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1acaa115-a173-48e1-85a2-bd898eabaa26	EvS5ZMaYeY/Eb6BCxGNYXvXk3+SUZ5oaegVqyRerdV6dh2aHC85oHnXT/XtnUmqnEXVio9jAhtXQVt+RBoVxnw==	828f07a5-fe31-4302-90e5-d75c56903606	2022-08-18 23:15:20.710064+03	2023-02-18 23:15:20.710064+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b3346069-a42d-4d04-8c28-39c94bf9772a	6Mj3PFEuLIGzM7LJ7uJsXkRQfii4SnDqfUwUnb7GXQ60u+UmeH+/4/tqv8kijvRD+9pXh6hY2RGeXjc49mEKMw==	e22ed2f3-3a04-41b1-b98b-7594781ba700	2022-08-18 23:16:22.117082+03	2023-02-18 23:16:22.117082+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1db7e290-9066-410b-860c-7ccf03617d4e	ybyijvfF3QlMvhNf2IqC9lDrd/bcfDkL6MKCUfdnfKEGPzFut8Z6y2xEecQt68VSfKppPZVvGZ1E6tGgiMeGaw==	ce6fb794-e715-44d1-98b8-f3177f3f7a5e	2022-08-18 23:17:21.677175+03	2023-02-18 23:17:21.677175+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
3496c415-3d28-49f6-8b63-bf5c1bff3ab5	vHYzg/IecN0mgcZr7rz2OJXtyEJwRCoQpWGY1Eqmho9FlUSoEDG2R/koHEFP7Jisu1dn/EtY8tUXAgUllcOjBw==	36f1a403-4da8-4272-a209-c11d2348c3e1	2022-08-18 23:17:11.601545+03	2023-02-18 23:17:11.601545+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b8916005-d68d-4c63-8394-e2fa10574f97	MYOdmoalLvufvT/HPlhwx6B7XGMkH/R3ljBSC6tUfM9imnN3R8/uuOExtZVk3SGnefSIztQpIOqJEeNiv5mWLg==	0ae4ea0a-1819-43a6-87ad-3cbf2e663fdb	2022-08-18 23:15:38.881478+03	2023-02-18 23:15:38.881478+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
5a171ccd-2176-4c67-ac0f-393a9ee2d952	tDrGUedv/zL0Vg7cPLqZAlMSgJHOysTUExjkvHiHBPKSohSgVE3O6R8q/CQxI1lcNOwqrfS6ZjCnW5TrcXIEOQ==	a25e2211-7f2b-4eff-867b-689d27bd0f09	2022-08-18 23:31:13.222717+03	2023-02-18 23:31:13.222717+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e310a7bc-a7c5-4c58-906b-9e10921a0f6b	hb9HG3ISd99P4t52rqardCM5gK5kqguA8dNpdA96pcNMkkt0VgFXGnRWQN880ErTatwtloEXzfQBJfBKePr9Tw==	fd4cb423-5cad-41c8-8dcd-b90ab001df0a	2022-08-18 23:17:53.521026+03	2023-02-18 23:17:53.521027+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
4f897df7-4e49-42c9-9787-f2583a531cce	aXxc2DHlqIXeDqO06LnN4+8oTUU3E3FHTxqd80eAEI8XGLs68sBsIbw84gVVwg5eKNuXise5Fkxh5iK2f5MQLA==	d48e2630-7845-41fb-9f9e-87d18bab0f83	2022-08-19 00:10:22.356772+03	2023-02-19 00:10:22.356819+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
96092693-19b1-437e-8cba-8306fd64d8ce	PVRldLRECigTDYpKeWos+ldEGQ42pxb3IKjZYNZqN+63Ml3UQwpe+FwDiDCJNDG4OVCMrhRPiDFiL9WcCooH+Q==	bf74cd64-428f-4396-ab17-9f8ee58533a9	2022-08-19 00:23:29.030355+03	2023-02-19 00:23:29.030355+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0e2f506e-ea87-48af-8623-965ef3850a4d	7v2Y9+EJPJj1MvSa+Z6t6DoQLADKqfPhqZuxEO71gBfL4T6zyq4ixxHdns0az7OjQSm9YzU+0vXCXu3MPY1OvA==	b808d9af-cf50-43d9-a989-8260393d15d1	2022-08-19 00:23:49.698966+03	2023-02-19 00:23:49.698966+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a4854a1c-2ca9-463c-a433-74082c9383c9	qLhvzpQyF935a30Zi2B0eaBYW0Zq+ocfhrW9n6Ec27c7BUzGmYtkOvdOIOiLOEtden2Iss/FATrAWpBectBhXQ==	7f2b43e5-1e31-4bbc-ac97-5f22c8a0e023	2022-08-19 00:24:00.342029+03	2023-02-19 00:24:00.342029+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
eaaf54e0-46b5-495e-a356-e61b414bdfb8	WU0S8YypiPlMa6tS2gfjBOwjqVAoZFWOB48EM3ZiHpWMZQn8JiYEXB8za2soi9zOsVrY4J/aUH6Zx5EUoO7XRA==	89bd5051-b1b8-405c-8dd3-93ba4e33b0c2	2022-08-19 00:24:05.074504+03	2023-02-19 00:24:05.074506+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d781dacb-3762-46cd-848c-fa9b2aadcc4a	nAIZFZViFlh0n9mV7WBnBo4+LFtGCTCEUvGo+YMH0JgcegJ1S0PctFCBk5xDTU40lRt2qXT0fMxh1zKik3tHXQ==	c8ee30fb-f17e-4bfe-88a6-519d894bab37	2022-08-19 00:24:21.560863+03	2023-02-19 00:24:21.560863+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
aad1ebec-b3f5-40e4-adef-b5038f4b800d	9xUAeKdND8aEZdQ8Uneetd1jKEdMGC7NIdN4sTVoruo1IJQF/2PG52ajSf7ZWB0JOFWqPs+h0xnQx39KENRKtQ==	cf3e0849-adad-42d1-a2a9-b5de1b301fa1	2022-08-19 00:24:29.293494+03	2023-02-19 00:24:29.293494+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d305ce6e-45ee-46d6-9ff8-9ced6a0a0f44	GtzxharIiG1dydoRebalJ30+U6D+ToxQ/YEwezFKeVFT9ZusRrbFcfqUxqlA5+13xvlFrzEx8mWbPbg++JuB9Q==	adffaa9b-ecf9-4f93-9fde-a3d08c670005	2022-08-19 00:26:39.767895+03	2023-02-19 00:26:39.767895+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c4e96ced-9418-498c-b87f-ba3ffef7dfe5	s7qjzgstt5mNlztmPqBoN8eVLKDW+900yboSi+voKq+vrc2dgNzLKYRoD77e9Ogm5dEad51Vfui27H2ITQZtAA==	2ffff1e3-c5e0-4779-b83d-b528e776223b	2022-08-19 00:28:58.037207+03	2023-02-19 00:28:58.037208+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
38b84bbf-739c-46e3-84bb-1b9fce298d2e	VQkO7+bUkhbmSHJMGuHleRMY1rtxfjB090v2bezy/P1MIxxrfDmUYxFYwTyTf/98EGvAnk5QHEZH+V73Nv16gA==	23457dd5-66fe-43f9-8346-f84b3a7cce89	2022-08-19 00:29:04.751371+03	2023-02-19 00:29:04.751371+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c984141f-3685-423f-898d-ce328e65ea2d	jVcuvGIsHTF43ktCxK+WF66zzjkXkGOlxEw5tlZYerIuDUcDtiibs/lts52IOffRLUPdC+BLNETaXOSgj9QStQ==	b85dc8a9-488e-408d-aa55-3d3fc69a56eb	2022-08-19 00:29:07.740583+03	2023-02-19 00:29:07.740583+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
669a6f9a-aa6f-4360-9fc4-8820a41e17ab	akoxO/r/W4Dls0NjqpT8v07rzMX6P7F4H0jOcfGdal1694PBTmui5SgIRXV02PtJvPpjEuZlNMyDN+WzsabbhQ==	20aacda2-ec26-4a9c-82d4-20627bab6ae0	2022-08-19 00:23:18.167821+03	2023-02-19 00:23:18.167856+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
ee76b3b3-375b-4646-9364-a23160b5651b	qxklqYTV03Au4+f2GJ18yCMP7mhaXgKvgBAyQP4QbcbWmUYlOmFJu0ju9vGRckUykpsUZBylcIr29crQl9FnEw==	d8290ef1-5fc5-4d06-8a11-e5d9d2a0c68b	2022-08-19 00:29:12.074796+03	2023-02-19 00:29:12.074796+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4643ed51-be1c-4fb1-8710-92a916fbfce7	6BeCYDuu5V4BF3FJN5SZh34ytv8MhMqm8LyRq9oBNLr8NxdYgBfOCBjfKC2Qf+M3l7SBKZ0N9/D0Dd6GMUMjOw==	b2c946fc-2f61-4c45-a19f-d2875d52d2f3	2022-08-19 00:29:43.730707+03	2023-02-19 00:29:43.730707+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
bdfbacef-999e-47ac-9803-9fd4b1c93ef0	cGKxRIEXV0t/iwBJArKPIZp9z3w8B7XWmfgrSLimoljeSToeROeL1f3Zd492xHboHgwZfMXPeK5N5NT6iIFHnQ==	c1082d6c-e701-4e7e-993c-6d4a9c4a88bb	2022-08-19 00:30:27.062598+03	2023-02-19 00:30:27.062598+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5a7cec9a-a201-4c27-95ea-2a66b49ec3e2	S8sYw9CTMlhZeZ4Kid2hq0Y+zeVwAuy2LC0yG7t0W2G3LyDYJZM3EYv8VviF9HGu8laLczml13UUtBXkQZb+LQ==	3a0060ba-9e17-441b-8d36-82e283ca8227	2022-08-19 00:28:38.281421+03	2023-02-19 00:28:38.281457+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
59b1a313-6019-42eb-b8ea-8bddf0a3b279	/8SMASgR1/F/+QBZPQ1mWUL++5rhx5vvRsjVUN3t/TpoFp8RNVq1f9jtqw+VpVXARHk7w5eEA5ccCuOEc2e1Mg==	f9aa85bf-cbec-4f34-97f4-d1c77d3e2b84	2022-08-19 00:32:35.621789+03	2023-02-19 00:32:35.621789+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bef35f4e-5f5e-4f3d-8e91-7222b14f1227	TSswNIVt2+X2HRxgbPeiVdZPT0vTvKUKYoDoRI/fvZ7CqaKMWwyumx3Alxgenvgn/AXgIXgZQ3uO4Ouqgptrog==	097080e0-8638-4e6c-9199-c84fa20f07da	2022-08-19 00:32:02.715613+03	2023-02-19 00:32:02.715614+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9391f2bd-7576-428a-a378-008b5d784024	GmKfU32P0Osl3EzpelYCHrg/pWYGz50byP9FOwrqrS4ddrryd3ocFg7eEsSnWyD0+jYIPkauICFapIYZvaxdpw==	5d34d447-9bad-467c-ba47-b5650c0e13e1	2022-08-19 00:32:54.720371+03	2023-02-19 00:32:54.720371+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
61cc80ea-a496-4265-8c90-cbf43e97a808	/S1bKT2tKmd2imzC6zE0fpEgEUsFlGlf3UjXIl6Y05wQ3sNXqXd9gGG74PDDk+kOGi+AnW9pVxQaQiIb47HluA==	79220aa1-b4a2-44c6-a7be-6d1f4dd14cc0	2022-08-19 00:32:55.224346+03	2023-02-19 00:32:55.224346+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b4c7620d-5a12-42c0-8883-6e5b8a2a580a	AlGDK5JUGFT6qVJDuh9soE0ou2GgrsHcZlwRB8/hMxReYBsl2tdn5iNSOoSZh05mkxxbObtYOWMsmkon2EGXYw==	ce4b9439-8631-4039-b25f-fe1b1a144221	2022-08-19 00:33:12.394183+03	2023-02-19 00:33:12.394183+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
25cf5e1d-89b7-4bac-9c15-67ea91411f16	F6dQ7oy4qDF7egnyS6/1Q7lrx91yYmWsqbwuykk9Lp8i2Iio2/0xxTzSJz6CmNmsQYULEe9KJD28upuNrkHlIA==	4eedae8a-5387-4266-bd25-28a29c066049	2022-08-19 00:30:40.076874+03	2023-02-19 00:30:40.076874+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cdf76738-b331-40f7-bb63-d22a81ecca19	BI4umunKJEQBpe4LKPWXhZibOG0xq+jZRbRQwVq5UeaCF0Cs73sL20T5PaTwYi4b8FTimCOelr5xxqNFZboosg==	b9a9fab9-d911-410c-b3fc-96fca525ce7a	2022-08-19 00:33:11.571001+03	2023-02-19 00:33:11.571002+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
838dd769-962a-47e2-8782-dc73ee09def4	QjlsLmzrkDpVZSsTxNMRyVy0wqYSD6uF8hhRqws5PwEZJQ7fyQ5MAri2Eb6h6ktsOssNa6ah+clIzw7uCFOHSQ==	b1b42d03-a27d-4c0f-969f-37b9a7f0ea93	2022-08-19 00:34:38.474119+03	2023-02-19 00:34:38.474119+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
b8d8b53e-72f5-43b8-826c-d10f40c3a698	vshbj1+hsN0nSnuvNcfmL6jHFd/W81Q7BqvOz+KDim1iyrGHqrd9Vz5ExDxuwehZsmd75ICJSiOa/DLZnfu2Sg==	6406fea5-ad75-4d01-9d8d-3c6d57ede07d	2022-08-19 00:35:26.49009+03	2023-02-19 00:35:26.49009+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
6308602a-9fb0-4cf1-885c-375fed0d0ff5	COOCJ1fpIeccHBV+OKPVxCvEKNKI14k1BcvCqqq1M4KgbOfzc/ItWnZK947t7nNEPySCLC0jq/F0BdgpDi4r7Q==	a8f26ee3-22ab-4fbc-8ab3-065b34825ab2	2022-08-19 00:36:41.794189+03	2023-02-19 00:36:41.794189+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
a304e6e1-07f9-452e-a0b8-5794fd97241c	nq/vnC5Y5pfM7kxvUEOzaj/rOHt/2pJIwBpQrtsSybsdxxyM6+Y7MZcIqdphlPO1WNZgdjFLf4HCEutMLBo4kQ==	6de17c8e-2866-4155-9129-da1855eb352d	2022-08-19 00:36:41.537769+03	2023-02-19 00:36:41.537769+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
66d539f9-09ce-4c0c-9d11-92ac01672a4f	mEXs+sP6ySHNUXTpz/S8X9B4K+Gmm6h6dXKljxw9LAoK1Kc8v7AZLx/4vM9yj59lBdPwQrn6SyBz4rBm3mRZYA==	23a5f959-77e1-4df0-89c7-653810edd12f	2022-08-19 00:38:36.902041+03	2023-02-19 00:38:36.902041+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
82878c18-a34b-4d83-8391-8922d648b7b4	iWxJ7/FLXC9np1s43ZGL73sZe5LUFo5fdGJhmiM/i9l/qUCHqo86HF/YetAU3L0tSFyBkC0NO3tl5lqZByVsgw==	1ddad9cd-b48f-490d-b761-29d5ae922656	2022-08-19 00:36:44.09451+03	2023-02-19 00:36:44.09451+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
b1a8093a-79e4-4bb6-a046-d8ec978cf285	EsfkZufgnZXc0dgxXjXyKdL/rYcSDV/Lw1X+blOaIAy+UxHyPVX0tUvt19GdFk6yv6+H6zYPGlsbEZdnGD6HAQ==	339277ab-9555-4acf-98a3-0033f9921a92	2022-08-19 00:36:43.993849+03	2023-02-19 00:36:43.993849+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
9f50071f-e49a-4185-8e5e-ebf8ba5e3e66	TjqVpfGlkDwpqoH/vFwJcPIfHvO+OcOBCt7cRt3PqYuaLm265/KJGdKKk3lhUvYqJGDJTt1D4TLC6pEszdbNMA==	a74dbd4f-5fac-4f92-9cd4-d81832733a5e	2022-08-19 00:29:32.949928+03	2023-02-19 00:29:32.949928+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1459ec84-670e-4c44-ba25-0abf1818cb3a	pnqBUMKat2H1s2Fos9MF3iwjv6yvTs63iEAkWwqOyKXPazW5W5RUNssTybtK9belbx419Kfdgw6b9SmDLHLv7w==	737ada3e-acf5-4b65-9408-0aa9299a8324	2022-08-19 00:40:19.038678+03	2023-02-19 00:40:19.038678+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
70765cfb-4c61-4aae-a46a-ea8aefcce190	JPSKmwSO6K9CgHjGBAuN3imB+1UrInEu6CMKNrkSJZVYOV7DlEE+g6lV5ve6si9/JhimI8vm5w+hF5YCEPLbrw==	789f3208-684d-4880-8c89-16c35985f061	2022-08-19 00:38:53.733287+03	2023-02-19 00:38:53.733287+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
28f6cfba-6270-4e09-a94b-f83407729bae	8YAmVjW9xkJxPpNVeM7qebgtHWyZ0rGsbFW1W+j6C0u+A+D1FEil9NX4/redHLb/c32bVQIJDLLus10F2utFsA==	fd8e156b-6fa8-4cfa-ace0-70789567f296	2022-08-22 18:35:31.566019+03	2023-02-22 18:35:31.566019+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
64141784-ef5e-4f4c-9d53-b0b93be85203	xzWa8MKkfFVefqWGKqSLFuVNSyNCkF9Q3bFalCZyXJYc1aS1xZYYrjkDxDiBedUljvKwGQVuel/NIW9cThQviw==	4cf7a3c8-fa7c-4776-badf-89aeba696d97	2022-08-22 18:34:41.281442+03	2023-02-22 18:34:41.281507+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
428d03fc-cb61-4a19-86a5-8a3042504fa3	vEHppMFp6sa0gw/3t1W3Pan8ipXrg7fyrMjPJYNbUIHo2YVUTiHtKtYL2RLLwLccKHXxFb4cE7/TIqyEQ3js+A==	2070020d-7a16-4828-9ff1-a13459ddaa01	2022-08-22 18:35:27.550961+03	2023-02-22 18:35:27.551002+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c77b27f7-ac1c-46e7-8103-ae60107b2a3d	ahr1oVZM2dRgNMYnWK9Wh7FeRiF5o4dpI/rUMTKwhw0hl7Gw/LCzlXBqzIh6YU76ObDe+TN7nlKtm26hDP2VIQ==	38891b2f-a903-488b-bedb-aed2c15939cb	2022-08-22 18:37:26.286839+03	2023-02-22 18:37:26.286839+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8908e19d-265b-458f-b7af-44dba61338fe	uRjNdFiKN3ugEVXLoaz8z5vvlQd/JuFcMivkqBKkCUY+JU9+VKxffZ51eDt2uzNuRuTMT/dQt+NiqENy0eGjyQ==	3fb905dc-fbcb-46be-9445-10c45e7e3f46	2022-08-22 18:48:42.858317+03	2023-02-22 18:48:42.858317+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
91eb70af-c812-4075-8570-ab1f915b1ff9	637rSPc7RZSsAfSfjQis5pxLh+INbwIbDduAobBGqW2kV08ZC+OplJaWC6r13X25mym7ll3upYJaFekFdY5CMA==	096971a5-c108-4fd5-8691-d557032975e3	2022-08-22 19:02:56.623833+03	2023-02-22 19:02:56.623833+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
03986b85-a681-47bd-81ee-1d16dc6977bb	gHbEtG8oBWHmo5kjXksTLposnLrRbvbrcSu9WWBWrhkknWUlk4C1Rw6xs7h/Uo2Gl5p6hXd/7KhVnHHcY59dEA==	a462ccd1-68a4-4483-8ad0-8948a898349c	2022-08-22 18:49:28.071236+03	2023-02-22 18:49:28.071236+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6ad36c01-99b7-4ed3-a76b-5ab2ff802999	At87fNpNBEQJ7dHJFJBctXN6vJYveBK9U48VmdQ8ena0QYZ8SAZnVXx/FQP0rjZXEsn3NH8VokS44Nh1nXG2vg==	bb306f9a-5878-4e43-a30a-c1b5d9bf9b8d	2022-08-22 18:51:26.991543+03	2023-02-22 18:51:26.991543+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f58fbb7e-1ae0-4ef2-ade0-e3b691ad9091	7sAy3iw1/4qsJdP2H2k3sHk3NgsvP62PzOcUjiNn5Fdz/fMThemhbpVD6SocE7F77tCKwGsBfanT/y4DzAKVkg==	85d1f0e8-4959-49f1-93b5-705885a66b88	2022-08-22 19:05:12.879926+03	2023-02-22 19:05:12.879926+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
57510c2b-37ab-473a-85fa-81abcd8969bc	rRjw2fCsYvGvM6+oTTNH9HyJe0fKLUD+hGVz5T4HPYAdyRU1yDyyB3N+FeDFXzn+oKJeYLAzN9UWwAVCSbH74Q==	46e1ad72-4e55-416a-bba8-f87b4ce3a2b3	2022-08-22 19:03:29.098722+03	2023-02-22 19:03:29.098722+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9e0258f0-d099-499f-aba8-9386726f00fb	JKh5yXidqUlBhfwxUtm+1Xlfd22+/MhovfbQim5Um3rvzWZCBqTruAzc6EosksDPvw6FIQ60gLOl/PEl22HwDg==	a8f8bd99-58a5-4d01-9ef0-142cc10b8765	2022-08-22 19:17:30.080955+03	2023-02-22 19:17:30.080955+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fa494b31-a072-4cc4-a811-0b34ea432958	O1AMNoC6DF+Fb/Lo6V10Wrpiqa0HlN9yMUwlw60fWOxD2iQQlpRCNm1GLell+CNAwzVy9/nzT02XR7RR/0eC3g==	c733b7cc-93c1-46b8-8bb6-733a2d533bc2	2022-08-22 19:31:31.126059+03	2023-02-22 19:31:31.126059+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4740e0d3-bad0-4de2-b825-f1fca9fb1805	cnH0bIjiovAZauasR7q98L5Ci6YjohOYeC+r9aBE1f9oPY5a30hHaQww8mX+I14gATTDtO4IDC8iBjtFqHvrFw==	ea4b0b78-bdd8-428c-b5de-9a3b44360435	2022-08-22 19:51:56.741705+03	2023-02-22 19:51:56.741706+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e3f72d3d-a1fa-4867-8b2f-966bb037fd87	MS4db53gKBf/hXnc3zkf53gb8/4VT63kVEh6PccEAGNeQcoz0WNYmolyBO3Lp0GUnXcgPbh1yVzQoFMxseoH1A==	f05ef7f2-816e-4c15-9285-d5e228487f22	2022-08-22 20:05:57.900311+03	2023-02-22 20:05:57.900311+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
70531e20-a450-4c98-8427-07a1acac4e25	iCMjm9ktXI8bVWn14HuRdb+WoqoC2P6QN3Z9bsh4zqbg/CpCHWptMU77wQrIDCvkNHSHxYvtsxQi17m3EB1T1Q==	9094d0fd-83b0-487a-a343-a7c1f0aead3f	2022-08-22 20:19:59.013806+03	2023-02-22 20:19:59.013806+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1a8b6fe0-1d41-4f1f-9976-42d2fdd1a2b0	Giqjumm85QiK5sB330fBPrpMazEY02srj6PowkL78H+HA4MJrOwSJcRPFAzX6LxC+6CEV8YbqqymEOUCWmzECQ==	bdee8489-acaf-4f0e-b021-2f4a94c84310	2022-08-22 20:34:00.899751+03	2023-02-22 20:34:00.899751+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
51d96954-b7f1-4e33-ab58-613ea26fa91f	QR/G7KxY/HMO0LhTf8dA4cp3Kjy7XdEafnll/kWg65oo73qkJ55zjT6rGkXII//cj5/0Fv2NCOelLQwJaeEVKw==	f80e6662-b791-48e3-8b6e-b9d3fccf2ab3	2022-08-22 23:00:45.687613+03	2023-02-22 23:00:45.687697+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
da6bb262-4c64-44f0-a05c-c1832f0435f0	Q9KT46SBOwYjCMvei9lrJ2HkV6ZaKJ34tGb6UwBu1MGQ2B9OiTwRtmJIXH0mUtpUstKk2al2SBQWuOlV5/Kw1Q==	c12fd25f-15d6-455a-a718-ea2fe51735e4	2022-08-22 19:02:43.571192+03	2023-02-22 19:02:43.57123+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
14b0c324-390c-4598-9376-3a04631ed10a	ypEnEahWKzeLTjmRqFi4233EjAPOwN0Y9wfjtJ1anfXMBHo3fopMMKeg7X3g8nGUpmjigKOSo9mSLYiChwlfNQ==	007e5abc-614b-4d10-a7c2-50e40c7c728f	2022-08-22 23:59:24.11918+03	2023-02-22 23:59:24.119181+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
ef53ce6a-de61-4a7b-9230-6d41038bdb61	mTOAEpK8P1nJLALMTRlEcVO8395XdaHEYx5cCOZDUQvtPsSJCnqxe4SeVjv7W4oeLH40fLKl31vjqN6TDFdMbg==	3b99e080-d742-403f-835e-3dda06c3db96	2022-08-23 00:00:08.316319+03	2023-02-23 00:00:08.316319+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
2af3fde0-f712-4c05-8e31-6576ac9b4c61	MztPjeesZuZUSgIDJYwIswGBUZN1fP0Pj9DzGkVIxzgWd7tWYf0ywyS98aipKJxP2knCz+4TuM5QJImODMfs6A==	ff60afe7-efb5-4449-9058-e00bed6807c0	2022-08-23 00:02:55.704378+03	2023-02-23 00:02:55.704378+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
f7d4b840-7590-4526-a7d6-c2fcae4acb5c	RMdwfcfxShuXNlNnoNuTMx3NQxv3aHsa2VdgCXZRCqj/LM/JW6OhyaP/z4CHj+LLCF9SQCF1BlieCrL09V3zzA==	9d0419e8-c7b0-4288-939f-0510c3e014f9	2022-08-23 00:03:19.686706+03	2023-02-23 00:03:19.686706+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c94ca69d-e84f-4041-81f4-c1c5483ea975	Cq0m9WjTiBqI6WeyxhA8M7FKDNNncuh3WQTKXSyXPD86kANexfQR8MsvQ0KpbGhMfUsAd2bspPaMWxaqpqmMyg==	739b147a-27ed-499f-b0e5-ad37450f39ee	2022-08-23 00:02:55.828033+03	2023-02-23 00:02:55.828033+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
26d7bea7-d4f7-4d20-86ba-ca7411a4241d	0ilxhKnRRXTvObdd5ZmdvFKt/a9dTG6Ju6VWimLzlwOM1DDbebRkQMUCU3z9kY9/ro6n9D5muIRvNB8NsgTZTg==	4733b964-125d-4f6a-9b77-f08843b46bee	2022-08-23 00:03:45.377111+03	2023-02-23 00:03:45.377111+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a83dd7e6-1715-4bf4-8cd1-d1929a87ebb7	4odlTTKU9VqryTeGsdUZ/vPzWf9gjo+iy/S+677327kNuYp81sV2TD5yhoR1xcMfmdSQNBgCp7uy5LMRJEnSgA==	6d355d33-6670-4037-96cd-17519c380a6c	2022-08-23 00:04:01.226133+03	2023-02-23 00:04:01.226134+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
19ebd65f-1bab-43fe-a564-15f15e3b6e10	hWZhTMIo006HAmeV7MQMn0uptU68dGexbkIyIjaNpsUhWa6kabSbGXz2F2Mw1WPVQf3zpydnqf2Ei7JLCixFaA==	ab75de5f-0d0d-4766-a0a5-4636d647d7a7	2022-08-23 00:04:34.60578+03	2023-02-23 00:04:34.605781+03	t	ba2c9a0d-5cc7-411a-9628-1b9418c54741
e7e3e862-8c55-4b11-84b6-4abd637d6179	H8STWAedfMROpoy2YYD+d8QrDTqr2++7f5YxUWBXZWDfwp0O21i059io8yAXyfyELUFjIW2a+90/N+wjAXhS0A==	0f066b8d-08bf-4fa4-9037-d4d53315e180	2022-08-23 00:04:22.966247+03	2023-02-23 00:04:22.966248+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4994375c-10d7-47ad-bcc0-7d65526b2f8b	mOGo2+bLz5PhoLLNg4lyhzv8y2NRycD9Btqk64fNpWv6CpDwHe2jaGUb6NcCFg2lJv5BJzpviSVzkeA5zY7JYQ==	3bef2306-63c8-4c37-a0f6-f7e0d68b1cf6	2022-08-23 00:05:30.141717+03	2023-02-23 00:05:30.141717+03	f	ba2c9a0d-5cc7-411a-9628-1b9418c54741
26c254a9-88cf-427a-bd79-a333e49d4b30	7iwYsZaUQ/cVYE/jb2DF2v92raXpT74bRmDexqyyWl5QkhW/P0+aX7r6YAQVsRZLo5p1WcC71NSjCKML2S/JCQ==	3f030177-a84b-4f3d-b577-0ae1540fcc5b	2022-08-23 00:05:30.297065+03	2023-02-23 00:05:30.297066+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
37a4c3e1-500b-44b5-bc40-6b12775f1f0f	3uXK8DsyuYZxbBaxIfVLr7wicao/JwXznfHPKFvZ3KSeL2gFLT129Cm4qxaAlydZSd2BcQ8t7+CXwg2rl2tSlQ==	0b0673a9-3492-486c-a969-a8c046856f21	2022-08-23 00:07:04.846305+03	2023-02-23 00:07:04.846306+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
be4e01a4-f1b8-45ad-bafb-12610bd7d1a7	FmKSNaNgvEHLcZuBCbrFBlL+kci8sh3tD7HYhfnwIq96WFiTfiYOtY/uw+DPihs+NDEs686LxMFZPyf0krVwiA==	b5646774-2638-4c0b-a4c0-4cb00f2122d2	2022-08-22 20:48:01.990283+03	2023-02-22 20:48:01.990283+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b40fca24-6bda-45da-856d-9a9b6ee84feb	SuOkWUdm897Ul1gEFOGk7qA9cNIv/lujqK3GHnkLERSld6sy7iX31STLPlm3wloME94B91mZc7FGw4s3W+Kg3A==	a04ea387-50aa-4b0b-a462-e06ba088da16	2022-08-23 13:02:05.903454+03	2023-02-23 13:02:05.903482+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
531bfce7-391c-4807-bae3-e6dbef90ecf6	PJMRmo1F3+MM+TLUXEV9SVCX/rGk5k5NAA81OTmChi6g9xt0cA5PZTaSO6Mkd5KUI23rT0SYf/pbqZ4xzrsLCg==	5ac47096-ad16-444e-b452-9a76b4e8eb37	2022-08-23 13:55:19.940173+03	2023-02-23 13:55:19.940196+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8b4b264f-494c-46d3-9888-9f444ee5047e	xikDtrgZq7ngXx0mWC3BTwf7B9jJKsnWHb7XhdDSbkGz9U+bZxH359w5ynLTyDTY5hZ5XR2/bNmhZDxMp8DZ6Q==	db4e6ee8-6978-488d-91d8-0e17cc9c0e34	2022-08-23 14:09:20.766016+03	2023-02-23 14:09:20.766018+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
84430f0b-b39e-4b08-b34c-0fa1a67194cc	rOo5opZVHZTNJNcieZQO9AsH6tZKnwLFE/9UiPP9SK371K9xQAPyiqlq3mZHHYsF52gbRK1mOSyUWXsUz3bzNA==	92aa3dec-75cf-4eee-90ec-fb86a14836a5	2022-08-23 14:23:21.728231+03	2023-02-23 14:23:21.728231+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d3d56b44-4145-491f-9646-1704644c2ff0	TgycR6ehqBoEAhgXGTnBOj7kygK3gU9nvcfDQ9+TqA6jO/ZGv2f5h1vuMTTKxAccfPYQ2qsl6WplVRidJiMP7Q==	372c2315-3af3-41ef-b742-a55457882357	2022-08-23 14:36:31.560193+03	2023-02-23 14:36:31.560193+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
02343aad-dc41-450e-8af6-e47dd33a0479	3emVZmzhmAmPHm8GFBrO1+7b2dFFQdo9BSgOSJfoU2vJBjVNczfg5HcJMA0MMFDB87HB8luJYTLIf/01Dn9S/g==	3f1e2034-6e2c-4910-8430-94ebfe472883	2022-08-23 14:50:32.725893+03	2023-02-23 14:50:32.725894+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7ad04952-99cf-419d-8e06-53bb1399bd86	MMzodr+QYcKN5hOiSa017VZoRPAODL+epk5rmwoCcF8GgaB37nv2J9JByANSE3hdmVBBE9rF4aVdr6vFTDaIeA==	20f67fba-4c0a-4ccc-9f38-bb71d5d069c5	2022-08-23 15:04:33.829642+03	2023-02-23 15:04:33.829642+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f4338136-62bf-4fe3-b7f4-fca90ca44af2	M2ioM3UeMRPhcEQaGiCCibbaedK9nxBPLJgNPrq8++rdCWrnROeA8LQci1CIMIJTIC+Q4ruOsfo9i83x7fg3Ug==	5773a5e5-69b2-4969-bcb9-d226e4c4f59f	2022-08-23 15:18:34.776892+03	2023-02-23 15:18:34.776892+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d423aee8-aed6-4dcb-a7ec-795b00d6d537	+q7Fnkc8MJUWpIp15Jq7PdP9aeAn3LXd3BgSM0LKPdOF1e4ci+Cdt7Sa01ESzMvfewnxsqh8oWIboBFobpVcxw==	b0b4cba6-8258-4bee-8b41-bcea2e45c7e6	2022-08-25 16:18:42.897152+03	2023-02-25 16:18:42.897177+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
82fd7f08-31d5-41db-ad85-bb025e8af30e	YyNqdYUCPrnrwr8U19rfGCvDZBsjJABct8Gj2XMfaEaQZJOmIPsgw8YvJR6n6oSz4cLwU2CJ/92LV2i0af2LsQ==	3af71d97-47c2-4cda-b062-852dae9837cc	2022-08-25 16:32:46.504869+03	2023-02-25 16:32:46.504869+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
19555855-f6e7-415e-b1a7-bbfa5b1a8f6d	ktuU+LfKTufE583Vbg3/3IOTrBkh2RsS/Gpn4czd3HX/2V4QcQie1ljr1jFhTMri5hI9/2cjMKsMOaAsafh3VQ==	d644f64c-4439-4c04-a44c-65fbd77cb9ea	2022-08-29 17:58:17.841308+03	2023-02-28 17:58:17.841329+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0c085b12-0ff2-4fe4-b8f3-556d064c23e5	c1lBEENkWum2X/CDDZge+NgbGqbbb1Q1cXrOGaKWUKD5Dpim9ByNBgkSL2NHfFT6R71VQj8UOANzWXdyAFBmdQ==	fc7a3143-afc0-4ce2-afa9-a6327a2a7ea7	2022-08-29 18:09:22.948159+03	2023-02-28 18:09:22.948159+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ac23d75e-57a7-4550-bd74-1fc3ec80fa43	r60o/NCJvX8YkWJVfJ0z3jexvuXgOe2m4DJWMI4ZuTaQrFQqU24gVcjAFYDcCemBixU+j2MeVfQuiHHEQRhOKQ==	6cdb1c10-5e4f-444c-bfa2-3d72f094f915	2022-08-29 18:23:23.341548+03	2023-02-28 18:23:23.341549+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ffe2cb3b-57dc-4514-81de-51b8ff94a41f	0Hqgl6Rskd8CiN6bYFWUs4A94rQ4rluYyGLAKe0R1ghZMly41fWjZSFQa2PxnP+fmeAQtPABfhMv6KcuobnzoA==	2d952da2-693b-4830-addd-29982d506c09	2022-08-31 23:09:33.613386+03	2023-02-28 23:09:33.613408+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
84f302db-8ad8-47c4-8ecd-fbda51ad7f6c	1FkQ8LE+GZ/51L889vSThabvSsPneeaVABRjpFGay8klA2Fl8LhOlaNZuQfd2xRJVRyifiUKAHsdpmWNNGY3AQ==	2c91d2b3-0f3b-43ad-a935-91e082d2b5bb	2022-09-02 05:55:01.763987+03	2023-03-02 05:55:01.764019+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
54e3b1e9-90f3-4137-bdf4-d4a7db9efcc7	zTM8LS5AeRqIYqODzD4m3/on9KI81YVjC54p7tiTbx5B969NkEztqOcxuGul/+eCXWlRB8Or90k4kmDK+EoQsw==	2e936130-5a0d-4bc0-90e2-c839e95044cf	2022-09-02 06:09:01.58076+03	2023-03-02 06:09:01.580762+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
865a5227-8623-4b37-83c6-c114ee6b8512	QwQdmLctb6URrVCyguQOVJoDdNCoBkBZZSxGan+C9h5tEu9s3cNnKMMhV4xE/Yo7eeQ6rQGVWsvM43zuxRpSDg==	bf70b7a1-2566-4817-9a48-2d34cbb9b83a	2022-09-02 06:23:01.878258+03	2023-03-02 06:23:01.878258+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3681eeec-1bcb-4354-af1e-00fb940950e5	0qK2E7lVk/svFMDfUhz2SdSErDUvVIQc0K6udic9Q4cddASIZwLg3HZ+wo76YW8bO5rMc9jxi4LBG0xmqLdewg==	178c6f27-6267-435f-9f36-02ee86c5c931	2022-09-02 06:37:00.612505+03	2023-03-02 06:37:00.612505+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
da622406-d1f7-41aa-8bcc-66ac3afde86f	c2Xnf+uZHm6Pr2St/TikXWdQ31rOP8o+4lnwAQlAWfcf2NtRRyJQTaXN8tEqaE06sQBJbt64m5u5fxH9yQc4Zg==	01af3a59-ab9f-47cc-b793-0cb3440640a7	2022-09-02 06:51:01.190061+03	2023-03-02 06:51:01.190062+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
442fe266-475d-462b-9b7c-5df4521577e3	tBjkiQe7vVD0Q2idA4D9LyVkx3JlE90kamivs/epcgMrKHHoG/u1L6phhosE0jjZy08kSY1sYKaUCse5eFlXlw==	79e712e0-df58-49a0-bb52-bbf796c58ee6	2022-08-25 16:46:50.143069+03	2023-02-25 16:46:50.143069+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b4cb5c2c-ea89-4c59-bdc1-fb4d55b33ae4	Q7fyrV+Xc210j2kJtCDmRSrgY6GggHtBpc4HgeJMNc1vKrrmbQX+fqxrRYxNJQ0otlq6dMNnmJRqnseG1k3a6g==	dd316fcc-ec26-4171-9216-d4512d1c553e	2022-08-23 13:16:06.759219+03	2023-02-23 13:16:06.759219+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fdaca5a5-b626-40df-9b65-e1eeb84d70d7	SJjSZLEOKyxAZkHpqL8eLXA8UYi9XPTBg4kdO1f2JSHKstizBhEplvoN5wnlGJT7AemDPX4mYqwbtpYWBKotkA==	bb478d26-62c4-4e17-bb75-bda8cc269c63	2022-09-02 14:51:26.945103+03	2023-03-02 14:51:26.945103+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1a2413a1-9d98-4526-a164-526169df95ec	ctF7YLtZZchv6Y0JFtE28Qt5wLU0jSQf1BBnA2BNprynfTEJqoKMX1ZxfKaqgTCw0oYpMJ5zlRlE8NDU3a2FKw==	c02ec77d-e379-4ef7-b545-3b27570e5ac0	2022-09-02 14:51:38.489248+03	2023-03-02 14:51:38.489248+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
384d5505-1237-45de-9c38-6e044f3bf3c8	83V9kT7PsoPU/27l3lzQJg/500Z6WlEzZQOhgV8LZ+IYLXZ360/k0gHyfukuPh7CKlk2rr1tyxxRbhGuXY1QHg==	da80fe1a-68cf-418d-8099-852cd4a85e19	2022-09-02 14:51:58.75704+03	2023-03-02 14:51:58.75704+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f5d45e5b-66db-453e-8dee-1726ba649d64	zUKH+mnA0Ve/A+EwjlnUKgSxWwGgquJfaOZLbGICogeJPNFSYGMp9tGpkDe32pJS9W0llx9HD54X4JcZudWdhA==	a50dfe90-11c9-4cfb-8b7f-80ec8f22a9c0	2022-09-02 15:06:00.997414+03	2023-03-02 15:06:00.997416+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
57924680-e9ec-4365-8c16-3d80561999f9	0I1l5Cufo9RR2sBGYJ3LmNouLKLk1LJ5izJw8OdShpWKbtIZCIZYTYhZZtzv53G0BYNQq4bpGOH3A7zB8rND+Q==	a60c535f-da98-4d72-a1dc-137252093831	2022-09-02 07:05:01.666264+03	2023-03-02 07:05:01.666264+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8605c6ee-8b77-4823-a591-52b0ec96a07b	EF4wihYqyWFGdI/oIAxefHH9JwHbD4SUsfHehch7Cgxt7QB0gLMh9TAGZlpwKyvzJ6gdIFwNCnvacQdHJqLvaA==	635ef004-6511-409f-b155-5488026c5309	2022-09-02 15:41:00.712437+03	2023-03-02 15:41:00.712438+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
54ac5052-e398-4da0-93e9-b585dc868e42	RBU4HDOzDIyX6MIU9t7MOabXetiAwkMOhaFdI+nQMsz3/YC3xGKHN/R6zOfGlkjtHdJ+t7bI6LHooAqBqk0rbg==	b66beb95-b06d-4ab2-b607-59ee9bf3f164	2022-09-02 15:42:10.165939+03	2023-03-02 15:42:10.165939+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1bdab5db-3e29-4a58-835c-d9ebe70eb307	zuMFxJSbssYpawlNs9TT02U0NPTFseoLRgrbP0gsh+KBe41fODjdf+Fb3Fnqqs2N73Ka0Hah/a34aY+BCBaTgQ==	190881c4-6b09-4dcc-b1de-1d05ada7b089	2022-09-02 15:20:02.845134+03	2023-03-02 15:20:02.845134+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5c60c04e-0102-4f56-bea0-cd60e2e430ce	4GC5a+3Rpp4XdZpHuOJXfplLVDLDq/QwmbEvCjtf8j2ibT1gGPivV11BejxQge0je3rBrjZ+s52QBaCQJttbGQ==	16d2b700-0051-4052-8931-684b9debb0e7	2022-09-04 15:23:48.070735+03	2023-03-04 15:23:48.070763+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
86d2c7ce-77b5-4ba3-900e-0098996e115c	xlf7j7R8QpOWFzLa0QubaGp3KTQ4hsNmINLGRo7KxRzJcD7YAG2wKGAtidvnyL0km2mTWPFDzg0FTWETHdyY4w==	912ff8b6-7e33-48be-9847-75a5c38f10f2	2022-09-04 15:37:48.724796+03	2023-03-04 15:37:48.724797+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cf3e67c3-5aad-4a35-b8ec-ff3e9bd51d4b	olGWTbSrcFNvV7DX/zzB7KEp8mWlu8YQ4Tf71cn0YE4/QlAOTDyA+GKYqwjXb0Bz22I3Z2xvjJdbmoRDXAJJvQ==	40c99c6a-9d71-40a8-bcc5-1d16bf366cfd	2022-09-02 14:50:07.878816+03	2023-03-02 14:50:07.878838+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
81cee353-7105-4d28-879e-af6bfe5f3ea8	JGe9Uq603sLkbxwHWZ1ikasXCNKu9bH7LRpdMue0yxKpY0DHTLL25/hNDdfR8puVOMWt9XUyu3J5EvCGvyS5kQ==	edcef222-a838-4044-a86f-96294593007f	2022-09-08 09:53:26.207384+03	2023-03-08 09:53:26.207406+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
aa710468-8331-45a5-920c-1972c3225bd2	xurCqz333qPQkR+/YG6yx8yEjMnz8NJFXtA7QMaEdaJs+8mDC6nta5T1sc9C+Hx6+hePmM+fT9wuvi3JdEjKrA==	79948450-731f-48d9-a6c2-136915b2c5bf	2022-09-08 10:02:11.514674+03	2023-03-08 10:02:11.514703+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
ef9a0b29-836a-4db8-a5f4-4ff7c8f16991	53Ay9fcCYNBXZazBOYFoXaIzyypSGoHWFbhXfCgSJN1BBGA8pvBsd/Y97D/RY8blvgmeY5h5TXkyDR8JeFIiJg==	b49c1e32-b16b-4439-b1f7-cf8259356471	2022-09-08 10:34:32.980297+03	2023-03-08 10:34:32.98032+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
dfbd8b68-c1c3-4823-bf58-97a507c6b045	NzwufPkDvKGYG+Tw+7Q0cmLPZLGG00C4QBiSeX3s9GbTFEGsDF0Gio/iMgYTsqATGig6lxDiNLbQNbRQ+NgcvQ==	112e1f7c-78f9-47f9-b92f-d00f25ba2576	2022-09-06 00:02:38.052744+03	2023-03-06 00:02:38.052765+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
87434480-0c81-4ef7-912a-a6c56770c9f8	GwXKAQNuGOKgdzarvPGRGlE6FWdcGTfjDIwNfjgnIs4kSPXHcZjEirAh9EbI1tdve8C/A6fMRv0N5Or/1hQTDA==	2b082e17-025b-4a71-8c24-fa40eb9d0d6d	2022-09-08 10:35:18.381399+03	2023-03-08 10:35:18.381399+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f3da0bf5-d540-4a36-bcaa-873fc1d54052	WPfErvDcpJWZfYWLDPcL1Wt2GHIQN1gVMw+tHcBwoRMzbAtZW1a2wtzZ7SEjpgBhDAyLSyAclwSr3v2NoPDiGQ==	80d4e534-6396-4d8f-a18c-7b109b0a66ca	2022-09-08 10:38:55.901748+03	2023-03-08 10:38:55.901783+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
f60f88d7-e4f7-4259-beb4-0d4e4e5f53c2	HZFFVyqvYJd8MsfBdfzLNRXsSSPH6iw6fyBTG9dn2+3zO0wC6cr6UDiXrKb/prMnKOBuEMR0iOSnB/lgqyaEtA==	d38bdf43-1e04-492b-bce3-8d86d605194b	2022-09-08 10:43:57.120656+03	2023-03-08 10:43:57.120688+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
5acbdb84-e50a-4884-9358-e53ee44b3a02	9XqfZ2cl0Lv+4Yz28NAMevgAzrXr9o4ZR010Vqi5XrPCAM+OaaSsfo3by4dEbYBTZYDWp9vOX25m0kOm7qbq+Q==	442d3c49-af9d-4788-a1b3-8b311ff76554	2022-09-08 10:44:19.504459+03	2023-03-08 10:44:19.50446+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
8fc0df79-3f94-4706-b951-2d6555dbed07	WLw+YHAsz5Ja5oxKPMcE/O8+In9zNfeMkbDXlR/62nPFZKmF+DvMSjZ1NFS7aPJP2PNV0OOA5VY6NoX3OdePrg==	4038b1a0-1b42-4fd5-8b44-20831d19baff	2022-09-08 10:39:07.583762+03	2023-03-08 10:39:07.583762+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
09a1da48-9e94-431d-b671-b3970ca41e6d	nbOk4mTU2EKaHu/+xv+cYNg2Saz3Gu5VKwvdCIqMgynAiodVkrERICAQn8x22z+frKqiSwqIA12/mqQ0Vy3TRA==	8f65b027-8a94-4621-8c16-40bf6f95663b	2022-09-08 10:48:59.944154+03	2023-03-08 10:48:59.944157+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
ca8536ce-cd51-4b9d-97f6-c62173ba2de5	mqN5lBz5hdrs5k1TreJ3ZoigXntIEFOXQR0efSZ5kb1g+HzRfudvipq6eP3gZtmR34c0ZoxtgcSDLatxLMV8rA==	81cdfa51-ecfe-4b43-bd2f-ac0f66be4f06	2022-09-08 10:51:26.102369+03	2023-03-08 10:51:26.102369+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3b8fefed-ae03-4dc8-b72a-9e6d68594e3d	mQRqWzLQfk6YqdmMOB3oqaSv8pBm9GVbKu4MRV6wHYof3JBnJ8oxv4XTwMVfHpLxEA1IzmEAJ7ui8JN7Ygc/fg==	cbe1d989-21c9-4d3d-8d90-2f614bf3dafe	2022-09-08 10:54:38.468671+03	2023-03-08 10:54:38.468672+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
ff01599d-c215-414a-9659-65509ab4682f	QuoNc6u4EKZNxZNafiwOH0aPMhMvYQP0pVbeFoDus3+TTMU4bkqhTt1hk8K+psGmozqk8fgnhSqfO3NrOdOCMw==	c5bde529-cb86-4051-a48f-1593bbd6de2c	2022-09-08 10:47:21.316073+03	2023-03-08 10:47:21.316073+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
cf372529-b937-4fb1-8fd5-8bbaa123b31e	rNDn+cqCskNAqPtBVbVEWa0Ds9vkww8Svhe7xn6O5sREY+VKgZKe7SQ/sHI/Wlj6xTIw1ZR9m9XvAn/iXUpdqA==	165a556f-aada-49df-bfcd-1f3555db6cf8	2022-09-08 10:55:24.367964+03	2023-03-08 10:55:24.367964+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
5a2b76cc-3bbf-4062-91c8-d51bc4bf333a	6sSGMUmc+fam0dOXl55Jp8vmK0WMR7co1FrN5GiQP4qfgf92dGQHp7bF9FcbMqidn5/1YJYH60Z9cl2vLkpXmg==	eea6ce2d-14b6-4fdd-9728-8a198f305cec	2022-09-08 10:55:30.390464+03	2023-03-08 10:55:30.390465+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
161f6278-fdd0-438f-8347-09f577908f62	kOah3C0/7KJ0AOA/EJxrx50MVC0OQtvxsTjBQyhsRMo/8i4BfOEcyjpkTqslv9r6NRwlApae7hqz/gxQa5S3SQ==	496e1226-88f1-4be4-b793-3744d111e467	2022-09-08 10:55:12.608558+03	2023-03-08 10:55:12.608558+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
37d70888-6df5-4d03-9aaa-d6770dd8b034	rXcM4m/tem8+HMEFui3ptMGR78ge2Xh9ubQkpjOQsbbDKJm8Q3tDzsbNNz2IHcmIv9n5HudBwz3xjfHsfA45Tg==	7d956bf7-74d2-4b93-81c0-d87ad02f6741	2022-09-08 10:55:44.939159+03	2023-03-08 10:55:44.939159+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
7cbcb440-2e5c-4eb0-acb8-8993b2390808	Rj0s9qTvmrd9KltEAgAFKypBD3v2PPGFQnn3c2UkumqjaNxKIJP6DKcKnl+W32z56FMFxLtXbx7O1+wH8pMHUg==	289114a7-5f87-4cae-80d0-ec0ef65edfda	2022-09-08 11:01:24.919943+03	2023-03-08 11:01:24.919943+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
f0805239-f25e-4713-bd83-d52515b19d05	Ipee9aKKUV57Xma68eE0kxxLHDm1TBOCnw5LK46QqFHpf/znKGFnB72U8Ppw4UW9pb4doT1+PyQ70IAK05oCIw==	ea11af60-1f0c-4547-9e74-c0a91b398cf1	2022-09-08 10:56:07.070724+03	2023-03-08 10:56:07.070724+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
baf611df-8453-4691-a071-2e6e6aefa15f	ldWJfOlNqJnYFg4HskO4EmuiMofoLb5q7DjeSC0SNGU2BLq9APjv9PMqIUxknSj4GLM9n4PSsAFgNfVt8KNJoA==	6154b35f-f9a4-4b2b-bb72-8bc44015f5ec	2022-09-08 11:06:12.427464+03	2023-03-08 11:06:12.427465+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f045e5e7-692f-4758-a844-4c2ae625e242	EH5pLgX3xFPRzWTitPa3eSC3zd0AHgeLaB9qICBvMaBJ4oPEUwAM/p64pdg3X5PEu8z0SSTbMkMjrQ6OvCoi2w==	e6645165-8610-4617-a258-8efb46c68d87	2022-09-08 11:15:26.341206+03	2023-03-08 11:15:26.341206+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
75678181-ba0a-4d1f-83a0-65f24cc7324b	CEeYIiijrc1Q/vYkeSROtnppvy454snvJuM+FrYhnlIy9IcDfT8rYvSsnnfiN94+KpssrneB/E18+FsGgatAig==	1ac5d317-74e2-4143-879e-1bcb659216c3	2022-09-08 11:10:09.278221+03	2023-03-08 11:10:09.278221+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
b2a53fbd-0af6-4fa0-81f3-cc879c9b4797	0rSj7viY377DOsya2sfGEGNxMNA5YN7fEbA9QfrpCc/QOgMNRCBjuCrg9w4kfAOr4/lGZCWgmIDBrUOBN27hcQ==	b12fc11e-e026-4cb9-8b5f-ec9362d04cab	2022-09-08 11:20:14.236933+03	2023-03-08 11:20:14.236933+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ec56eaec-229f-4211-9793-3b7ac18b6c5d	RPpzMzu5ZA4RYFP1+ANlRAeqm7FTXgmVa8YlPs+GPVQZEJWy/CiJRJW9nCTOOIfMzf0DdlukGfsbFT7C9Ugkxg==	bfb1434c-03d9-487a-a1ce-52dfea786609	2022-09-08 11:29:28.47345+03	2023-03-08 11:29:28.47345+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e898790e-5904-431d-996b-473ac0786ecd	Fo3BiXL2SXvsBvNpKl9n7azIUHCcQHBbGZOGG2H5UsVvDZ2JfWChIlitRIKMqE+iS0u2Gmj/yMiuheqKp5qyPA==	0e77d79c-ec4f-4f5c-94f6-539eda9dcc21	2022-09-08 11:24:11.446539+03	2023-03-08 11:24:11.446539+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
96318519-9f68-4da9-ad51-9f9a36493638	3Bxj//leyS3ojGrTlhq0Zufyj9fja8zp8KU0wSIuHjuR0aHqlp7dz+C7BJEOILmENEoavbLyFkFOeyQPjl9sMQ==	94fd9a10-7f0d-4de4-9354-64c175e2c821	2022-09-08 11:34:16.316229+03	2023-03-08 11:34:16.316229+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e08afb0f-cceb-4e41-9ee2-d29ac03363c0	ZisnqwCHkvz9XTTwF7HGMc+qEhk7MlHJNYAfQsm+dH1te0v/XtFq2F6UXIlVj9P20x+bjmezVFwZYL1ontjvSA==	59184dc1-5079-4705-b88a-eb1fd9af0cc8	2022-09-08 11:43:30.822332+03	2023-03-08 11:43:30.822332+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ea51de18-272c-44b7-bd90-61e0a9008856	pLDBc5h3Foshbe422FJJ7oIpnVVpPvquwcfptsWV+63wosnhjtuVE8Atps4lNIWY4wW/tEsx7lARCJXUBARHIQ==	1cea1001-6139-4b0a-b191-c659f7c8242f	2022-09-08 11:38:13.194349+03	2023-03-08 11:38:13.194349+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
ba25b3a3-4088-4033-9950-b7452f7015f3	HBxrF0K3tYyaWtwfEc8BtezKl7iu28h3d7ZZEXuLtKXU1mVGLGqtgV0mqZr+GG/MOPSC/SZCT8qCC+pZiiow9Q==	adc75149-bd6d-4030-ad99-0e2afc955285	2022-09-12 20:57:42.229645+03	2023-03-12 20:57:42.229666+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
02e4acbf-a2ad-4fcc-b3f1-414939d430f0	XeCuaw7ItozGNv1D/3j5VDHb4Krk+36UQ/+4xAT2DPuH9zAdWmFaCEvDvmN38v7oBZ5hJAQez4KvSSbDtqdG9w==	95fb5c8a-023f-4fe0-9822-fb315b4dee7c	2022-09-12 21:12:56.434704+03	2023-03-12 21:12:56.434705+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
17f02e3c-ab5e-4acc-ab6e-9034a1c9b9ab	RuFrk5z0d4fbK1TOOWZ6lQYbaKnZ0/nk5jQcquzSuE9zDt/gzEq1DUFXFXtvMtc+pBQQ6EX/30MdHljvHOO9hA==	5ae36fde-4e01-4605-8941-85841b9406ed	2022-09-12 21:28:10.915709+03	2023-03-12 21:28:10.915709+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e2fa6b06-ed8e-4937-aca9-7474dff4f063	z1t8ev7Dn2u2spl0uIIVCWEsuSmkjRnKgVUni5Qs+fXPHFUCoXhJMVILpz54/uok4bw1O3doOmHVBm0Lh2vFSw==	2ec61235-086c-4c5b-a127-b7816198fc50	2022-09-12 21:43:24.71884+03	2023-03-12 21:43:24.71884+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bcaf9fcb-7c92-475c-955e-1ef2d524e499	qmXpc3fRNqs+O3TSPgO9WYuaIyvmceWpqz0MIpJFN0TMflp3QOgAXAgTQXtWmqWSd22vEst1PWxGqgkfOFY1HQ==	938f10cb-51d8-475b-9e28-24d1246f30ea	2022-09-12 21:58:38.307787+03	2023-03-12 21:58:38.307788+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c37c0d54-9cc9-4e9e-a8df-915ed959e847	QSNc8s2w+ZqcZ5CNEqo2f1U0G/KUMfCukIStNavqTgoyaA/67N1XLRk0eOT6a7q0US9txDitS+0Ohl3N8CxVkQ==	c02aa089-d961-4c12-85d4-3d679d5b9ae0	2022-09-12 22:13:52.595884+03	2023-03-12 22:13:52.595884+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
909e2e33-33d8-4c33-9b9e-14c049cd8ee0	LhIHMPKrfLFVP2GfQ9hTTDeUh6VZWET85GQkvG2bOQHJETbYFHV7xzwbzKoGAgmG4zZjZxKgtV+0HDaDQZvbjg==	630fdec8-533f-4e74-b136-0961e17e9953	2022-09-12 22:29:06.145085+03	2023-03-12 22:29:06.145085+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d8643631-40b8-46f0-9c1a-cb1579f838ea	VjjlbN6skmx8o/MB2NZIoBXAiB/d63Q/oXHxIAMtHtySYWzVX34FC+I+jt0OFcqC6arMoBPgQJnt/MG+PMG+Sg==	db49a84d-08df-4724-909c-19e474fc89ac	2022-09-08 11:48:18.108142+03	2023-03-08 11:48:18.108143+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f0c2e77e-e5d0-4325-b28b-2084b7e5edca	bcJMaq6Xw0OzcqPo8y/vAjI/MndLTKH/4WF91rTL1aANQNvS4uE2JUOrzM7Ek2wLfuxrNqaou0DagsssonHGQA==	657e8859-e562-4410-b2c9-ffbb3131fe92	2022-09-08 11:52:15.238141+03	2023-03-08 11:52:15.238141+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
45ff6381-6e7e-426a-a248-e1b02601d5f0	ZRfl0C/h+ALWI7s7T1UhOL78+fT2I1XAvDsGMn8vqC1BgTv0TnLQObcpp6ohrPld2hfLpvot1CAoeYqwrlpt0w==	9db87a4f-fc31-44f5-acb6-2a360508dfeb	2022-09-12 22:44:20.534626+03	2023-03-12 22:44:20.534627+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
64630578-87f4-40df-ac1c-6fd84d6b9d7a	Brdd24hn0QJ9oKHR2Yrm4fbs9l7NjMYf1nzhVQY95N6gyiSZwEI3rQ2B1rN/ubDFunOlVJ/pmLjQnNbUwhAQ2Q==	373fbdf2-8439-4027-a00a-b5b67298f348	2022-09-12 22:59:34.200371+03	2023-03-12 22:59:34.200371+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f6bc6455-6df0-4ec0-8aae-399696830770	ds9p4YtFhCVWIFjp03PJYjOinVeRLEJDps5i1HfaBAUuiWEsQ3g/82mdDOy0/cmoMA+cOVNbHBKANCgiZq6N/w==	b4b3aff2-3dce-4e5b-9cdd-e0484774ec57	2022-09-12 23:14:48.39269+03	2023-03-12 23:14:48.39269+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
01bef23a-6604-4ce7-87c6-0c400a66e288	wI3XMlErhWoLxv2jGDDD2h+GwfQ4V7XTo+SP+u41v1R6n5TUPO3j3m+Kcx+oGnL03RLurk5WkLeptLGRytFvcg==	5ae2e3fd-67f1-4158-8c5a-30908debd3a5	2022-09-12 23:30:02.488914+03	2023-03-12 23:30:02.488914+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d7cb52a8-8cf2-48fb-86b4-efdb7d252f8a	hTX5WHZhLtHgNYhEnTMiT7R99M3NyxKY7laeqVXN23uQYKmsUunf/mHCXWSe36PbiSa0wdaOqtqtDgZA1QfAuQ==	55b32b43-2633-4dd5-a615-7e9c51da0ca0	2022-09-12 23:45:16.179708+03	2023-03-12 23:45:16.179708+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
97258541-0035-4c00-a658-062f03f6a18f	1EDuiXYpuNyWgKViZxC0QNnAeRxZldjs4I+H1i48WXPU4E/nyVf8uN0StLo63QEI3H6klCHYt+p618Uj8rdtZg==	3b1cbef3-64a8-42d9-8b98-028ec563d282	2022-09-13 00:00:30.195502+03	2023-03-13 00:00:30.195503+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f7ea8e2b-efe9-4a56-a1c8-14732388d4d9	F78fdMKnC8ICxsOhp5yQcFBt7o4TQdJfI6iHRCiEuKXuKaD2ammdCzA23hVZxaJO1OUqtwQJy7KhCfspsS9KXg==	569c8d51-3830-403c-aa69-b23a7d3dd8b5	2022-09-13 22:09:41.129664+03	2023-03-13 22:09:41.129686+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c7062baa-b849-47fb-af5d-14621c5cd302	eLfhH6ae02mmhtRQ8GadslFq8dwPRuRcpXk4B5di2hzCdi5fPlrdhxWxlSojMsu+M+o4jLBN/vUViPMkiBPKfg==	a4cb667a-8d47-478b-82a5-150804865ad3	2022-09-13 22:24:57.907194+03	2023-03-13 22:24:57.907196+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
30c46600-ae82-48c1-bd1c-ec4bde0e51a4	85WSVfKkAWzfebivXt6+x9SsKbow40MjGQf77FmHRSd+YVjVvxSQhyHN4J23ucWVLznhSg0guYuT6ZFJi/4mdw==	10410147-0578-4ff9-a488-ae6a9bae05a0	2022-09-13 22:40:13.709012+03	2023-03-13 22:40:13.709012+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e3b9ae9d-8469-4f8c-8868-5480753b5ab4	3JxDLgAsM9NxWXZ0u3X97RkM/SXnTGUxoBXT839T7j2NKZIDcrZxCHXEyhdCcw4iL395zdf8RmZWpnHdUxyxFQ==	1b167ac3-983b-4b30-b0a7-9c00d72a570d	2022-09-13 22:55:29.573244+03	2023-03-13 22:55:29.573244+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
34f6f96e-af7d-4c47-9397-769c0c39193d	83d7o9T5Rv/RCX0rOCi7YzdmXMn5fMlktj1TmXNpnKKq4/gle15Uihv0LyNCh0x/WcYN+zRFhp0Bv+dx5dd53w==	8df32404-5c81-40ab-8758-bdb891317385	2022-09-13 23:10:45.594836+03	2023-03-13 23:10:45.594836+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fe11cdbb-729e-46af-b964-a26c72cd5af0	K9QTcwccXf3Pz1T+/T8LT3l8XBmm/QMS3Fku6HM9U5zhKXa5cAROs/DJ+dggrZK6AfYAj4emc8PNi7conuA9aA==	2898e8d3-f05a-4078-9825-dce875a00ab7	2022-09-13 23:26:01.544677+03	2023-03-13 23:26:01.544677+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d9cb8070-6c0f-470b-b822-8f6d8241d4b6	6EH9WQJRr396YTV1zMXwu8r8HWtPzxUY9ApCt6zE0mhUbe3ZP6ujZan3juZKQdWUwtwu8xcrLIISHFDOkZCVNg==	813810c9-fd48-4d85-9660-c279a4162e3b	2022-09-13 23:41:17.714499+03	2023-03-13 23:41:17.714499+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
34ea5585-d913-4e27-aee7-f3d0c1c32f70	zAxnZ7IggVdMSrGL3ZnqVyjMeYY2yPRxc+23rPBEGODCb0GHB+HB8TamhdNNXM+AUMFPjHeQt+l5SXxDlkLTuA==	852b6510-8ee7-4023-bb5b-025376ad7998	2022-09-13 23:56:33.569791+03	2023-03-13 23:56:33.569791+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
344728c0-1e74-4171-af3b-666b945c80cb	l9cdFFQ4wgKUWz+lbYvEeWy9x7Ur7nHKTCRvdGhH4JuKw+8QQvPGI6QzGc7gSYy6uEhqKgQLtM+PqCNgynKvvA==	745af399-11cb-4591-82b5-c616033c0adb	2022-09-14 00:11:49.648839+03	2023-03-14 00:11:49.648839+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
72e0158a-74e5-4c0f-a6be-fe3427fc15b0	FHQc/1Brl0LbIbov8PV2B0W3p92sSZm0aIIO40ODqLrOpPA+128gBntPyHcKQNWhemMR8P4zKe6KeyO6zY/VdQ==	e6951b62-d915-4b37-aefb-a7908024e517	2022-09-17 21:22:35.109509+03	2023-03-17 21:22:35.109536+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
58d2a505-9126-459b-b8f4-e29fa95a3b9b	41p/CIJ3O7Va4XeYa/6doVSwkz6ydf2mG7MM0T1aMtTCpepRd9MS9DK9blVW3ODAa2NJrpYn3ePFPE6Nh6bBCw==	8fed3e56-3979-4b84-bd88-e74a3b24c43f	2022-09-17 21:37:58.710344+03	2023-03-17 21:37:58.710345+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a1f578e0-69e4-4a93-a6ca-94baada50af5	8wFYSMyiGnlJXORxgkOWCkOaywNOmaCydO1o1HHrcA2hNcCZVcvJkmf90mLiBku1YRKH+8w9aOgIV+rsn00Wkg==	e521ac3d-9ff2-4d91-b878-60545b6de180	2022-09-17 21:53:21.651246+03	2023-03-17 21:53:21.651246+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d9bf7101-73fb-4da0-9a13-f2872ea2f42a	KNa62nOCo28SVTIKDiiCudGD5jJv9q4sO6dUaghIwCdCfx6tDw5m535ymiIiIEETYRvsjOEnmXW77GVVq2S0EA==	8468f622-daf9-4f09-b3af-b781ca02f882	2022-09-17 22:08:44.796444+03	2023-03-17 22:08:44.796444+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
463d8ba6-6c28-4b63-90ff-be49e8ebe458	AOj8XjgvOWcq1QVBWAFt9a723y/0bDBbTCWzeunz7fBSYi8Yms6wFK2dYJQ+QQuDXZ44cJBVcKZy4FtcznN3cg==	4f60d04b-e0e5-406c-b87d-9e8d9f6be8b1	2022-09-17 22:24:07.81462+03	2023-03-17 22:24:07.81462+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9f8000d1-c60b-444a-99aa-7f15899a4307	KgiCm0gVFkE5HIPgknP/d9D66PcTYpTjm7+KoANFVWHUNh0jKQ9Yufx0LaGqu2ROPKE0Ui6S536M2m1Y5Gka0Q==	c421d18d-e5e0-4257-8f64-97e9472315a3	2022-09-17 22:39:30.643815+03	2023-03-17 22:39:30.643815+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
052eb151-e460-431e-93b5-68609eb7e7cf	52quqtfwkU/PG6en1B1KOzNm56d3CTonoxxzVmnAAaDOnrmvvpxqxiENhZWz+Oo9/5lOWMNOUfDscuqkEMXIag==	346bee8e-9d34-41ca-8c34-b3cb9ccc4515	2022-09-17 22:54:53.644282+03	2023-03-17 22:54:53.644282+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8d7f4052-5eea-42f6-ae94-733d3350b4c3	3Mo0//dUxZYzV/GpU4LTjEwnFhSwFYjWLha7R35MO1DlGIh1sVovYaxH3PmTAqjwARFaGUFjJ/EUwPEtc+EMrA==	5d9f0b4a-4b8f-48cc-a5ba-8ab826278fda	2022-09-17 23:10:16.6673+03	2023-03-17 23:10:16.6673+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
abf564ee-fea5-4e24-97c5-440ebf91d994	kzNQYjZr/2I0eKFXkq30HhF2uvqEu+o2eHcq87l7CFfZWvLuRqwk0gtPHQT3IV3jPQm0qe++usJGpU/Q0Vs1fg==	00107887-5ba8-4073-815f-bae0a113f251	2022-09-17 23:25:39.663221+03	2023-03-17 23:25:39.663221+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
03e3df7d-1758-4f9c-a65e-48baf3d8834c	Bm+XfK+vJZWNL0kKejRH6duHfu9zddUBLrQVxJ91tDwfng8sDoaFdEX3186HPKzLKctJneQl7bQ4owQ/Jsl+3w==	344f179f-e599-417f-8391-8f72130782a2	2022-09-17 23:41:02.691225+03	2023-03-17 23:41:02.691225+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ba08b292-a612-4211-ba5c-f16a163de387	s088wk2ALkgbSizkPbBly7+yjA57iA/HzRVWAhuoMhlhvRx00CJXRRj0TUYzjusyLYU1WYgLMZnlx7dTdA+lcg==	bbcf8c18-abc2-48bb-bf9e-ba16a211f88f	2022-09-17 23:56:25.761633+03	2023-03-17 23:56:25.761634+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1157d13e-9f23-4220-a3be-702c99efaeac	XIepZh8+jD3I7Quf6mUQ+Z9IIOREYA9FpUNrZIprzKVwxx6BjTFJT61o6Jdi9OZ1UjVl5fMHXKuI/H/WutSa7Q==	e88c3298-1aa5-4389-bd3b-d1dc1335da0c	2022-09-18 00:11:48.554225+03	2023-03-18 00:11:48.554225+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fe226615-6cc4-4768-a229-683ddb0cc086	OsoH7arFzOV+6B3+NIavozmEPGJEsiTOZ3j7gt+WsDOl0LW2C1rjpbMwjFbgXwVp+HeecaQo8qgt1E0ilvFp7A==	aeae6021-5751-4a12-8c25-47b67db7a35f	2022-09-18 00:27:12.023108+03	2023-03-18 00:27:12.023108+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
db855a4e-2e5e-4235-ab97-209fb513e3b8	D5s13Wl54U/q8iR3xKxYx0qsLv6jHo7gOpqGW1FuCCOodY0DFOoZFKpOxM4ONAbjHfVTLzlvc5KhDC+kCBHfoQ==	cf5933db-7316-45be-8274-105d26a714c7	2022-09-18 00:42:35.654487+03	2023-03-18 00:42:35.654487+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
dcecdec6-860e-4daa-8873-cf5fcb2a8165	xgPUJUphQfVJuO0kpbj5St9SM9b7886AFSqmQvEJrBBHHzJKMaqd6VsM6ZbuUAzJt8zFNHdbzthTutzptFu/mg==	9d67276d-2a88-4149-b4d3-f49ed8e4b807	2022-09-18 00:57:58.651432+03	2023-03-18 00:57:58.651432+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cf957085-f838-4ba2-8a21-1ecb89f339f9	8cnIPL/Xo5IrYrJi3PZXu6M/VOY0Q0R7SUiu5koY4Q3zhF+9ZdkqMojPx27j0ISXnSHwPn/sCpPfoZMRu8PVzg==	1fe2386b-3082-45d7-bf41-01d3b5ffc116	2022-09-18 01:13:21.585+03	2023-03-18 01:13:21.585001+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ec4eab1e-32a6-428c-a3f2-d3a45dd72f09	ZMbjwr33WF3ndx1kUzyMozPi9gWr5LazStqsxIqIU4NcXpj8B2mjv8ICVNKhcbZ5DUFG1VZebQ+FwShqETMbYQ==	5ce65fb6-f854-410c-9667-958bcfab8f3b	2022-09-18 01:28:44.597635+03	2023-03-18 01:28:44.597635+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2865e353-785c-4c81-b6e3-282c4403dd76	EL5h9Uf6RkBrSTDADBHF579u6KIogpGpcGIzzew09ul58/NcYz4N/FXZF23c573sIzA5MO+9YgkHhAGFakss3A==	783fdfcf-d8e9-4c18-85ab-38d1ce58eb73	2022-09-14 14:49:19.163977+03	2023-03-14 14:49:19.163999+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f1a9b0ee-0c21-4935-84f3-91dcb74c946b	K64t6B8H2onG8bM/hYZxNw5uWD7C0Ob+dUmG3eHkPRYH81OD2SbS091Y9js6R0MbvHNq4ddXndRpIWQyRj888A==	8d481adf-7490-47c6-a868-78dcd551e6d3	2022-09-18 01:44:07.636088+03	2023-03-18 01:44:07.636088+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
250cdbbd-716c-432c-bbf4-0f9ae317ba9e	hsl3rNuEcYD75IeczXqiKuSyJcfbqsCEhZFCKEE92BAQXOj90vNTA+o0Lgco/ap0HS9YsA3BmIHmL2Ctah6pHA==	df230a8b-39a1-41a1-a4ff-190a6e9a631d	2022-09-18 18:33:01.812201+03	2023-03-18 18:33:01.812226+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
58017500-5dc2-4cd9-b2e0-71c7fc726d9c	658TqHqQvzofJ/6o04CIcR0EeFilzEKnQuKVFpWOU3c1jFlfQZJGPfi0txmTscZQ9OsKMVWdcrXPbsgOnwg1dg==	9933c9ba-36e7-4f68-ab6f-d6018d6826f3	2022-09-18 18:47:02.46639+03	2023-03-18 18:47:02.46639+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d058871e-36b8-4f1c-9cd0-e935da232fd8	ExPJDxt6B1awRm2wDWIQLvMHu16zjqXY3CTGEU2A193BkPnuDoaLrVq2wbLmT6zO/+8kpzsiuUOCYCtjI3RQmw==	86cf1088-9bca-4fb1-9a46-f80cec634aa5	2022-09-18 19:01:03.652644+03	2023-03-18 19:01:03.652647+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3dd8a32d-eb0b-4dca-babe-a1c3a2b3d70a	bzT/Y+1IRaEIrzZ98ggo0P4bxvkVDw946KbIaNDTMG578zEyhw+BRGrIQhIdoLc0msJy/JMa/bmn4t93CNKDgw==	ae25165a-b660-473c-9f08-741c1709e87b	2022-09-18 19:45:13.485933+03	2023-03-18 19:45:13.485954+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
71e7015f-b45b-4a69-9de2-ad14ee12b84e	sx9OJuQ+NR7tWnL9g8LnzC7CJOrir5iI9AwVO+yBx8eqfhbRgYZJXfhFup5OqkcEExpafvq1D4ObwWTmmZpVjQ==	0d7ca24b-b794-442f-b662-97b2b01da80f	2022-09-19 13:37:37.804629+03	2023-03-19 13:37:37.804651+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
750de982-5cba-4648-a930-90e866b21a28	90mmfMfBvWWljqXRrNLVOCLxst5f+I+1c8lTtgNuXjlV1JuBHyd1oWrPI3kRHCQ03/nZMMFPexSpgr1Y8Feg3w==	89ada1d1-4d1a-4b0e-b331-6fb6a93aa6cb	2022-09-21 20:40:59.17283+03	2023-03-21 20:40:59.172856+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0741449f-f67d-42ae-b3e8-9ecbbbe31ae8	4AfmZghJv5ElduG4a2txvGhF05gKXgK7fSKWxPa6qYlH3u12vYBBW/PLHGUEsZaWTbbL4mRcSKZM5PgxUFpaVA==	f22ffbef-b812-4911-a196-4a8410d9fd14	2022-09-21 22:13:10.435402+03	2023-03-21 22:13:10.435424+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0f5d41d9-03ba-445a-8444-0c72e07badd0	0/bAErAGxgZuSWgiq7BBcxlf6q2fSmCJ2G6YwBoWFjVTJ95KtDeR5fi1gcBSgOKKnz4HnhVqglyGGsnRbYOrmA==	09ee33c2-3a2d-4f43-a951-d20ab6d4189f	2022-09-21 22:27:11.624688+03	2023-03-21 22:27:11.624689+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1cce40b1-aa5f-4e6f-a1d5-7b9d1b5ce45c	DaReaNeXSvnWtRGOqzQUFSHBLOJyzJSyeQMsWu7LzizUWz3Rg8dp62S0LPSVx6dusHo1aLupVYdi1Cq5a50pdg==	02c57290-12f2-4292-bded-79ac8d4b1736	2022-09-21 22:41:14.186363+03	2023-03-21 22:41:14.186363+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0ad0e7f0-deac-4c79-b791-557902e77310	YfWsyIKIZNjVnUKlcQJXC0sekfeLXcsUZwKLKg7yzP07gp7T/Kf8pgUJj+IrJ3vB9IVoN1rBzYiBdclHspM2Vw==	1584e6f2-d9fe-4271-940b-02f778e9a8fd	2022-09-21 22:55:15.569601+03	2023-03-21 22:55:15.569601+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d94f52bc-227d-47d3-877a-5504da9667d9	tpSSc5WImR4LzP6pSz9GsZKTQja/H8sQx0RShnxdm50OK9O/aPtke07qlQfLEyUQiot/Ize+tTS/6CalVA00HQ==	2f40c83e-97fe-4980-9aef-7545760d60c2	2022-09-21 22:57:10.306755+03	2023-03-21 22:57:10.306755+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
731ad8fe-7d70-4644-a23d-5cbcfbcc1538	fQBktutjwHgsv98B+iXoMQc/N2lHbd8hP22jpgJkMgJ8bsZgbwvwn4vR1FdD2vhbg/WaImEL9KrjTT7d9Wn7Fw==	49757456-7f2a-4e16-8874-c1d22ea227e5	2022-09-24 19:13:55.727041+03	2023-03-24 19:13:55.727073+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fc2ea1a8-e3be-4a4a-b163-5153b1ba4f44	DPOKRbnuvPQ2on6ceZWqm7b0WHKP8keZY0IwzQ0vLGF/dE5DnC/dE2UsSNQ8a2gxbtEGwUr3p72DM+9XdIli6g==	9d80a50d-3df1-4e80-83d4-6fa543b54826	2022-09-24 19:29:29.790313+03	2023-03-24 19:29:29.790313+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1fd9c809-b4a3-4a65-a5a1-1b323e6ef4a5	jk8EwjYDGRgs0QQrVRaWvxe9BYdpOMJn5K+tXdodwND9euy1nCbFy0wu+lXqcYp/RAY7OyGvYDzMR4PWXpeQ9A==	b08f7ff6-907e-49a6-a268-5f8919cfdb9c	2022-09-24 19:45:03.835373+03	2023-03-24 19:45:03.835374+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
51825b74-9c42-4bb5-8542-ab35ba5d9ad0	8qQbdgli6s4Bt7LIJnuipvuZGqc06X+XakM5o9DawFs5eoHFoBuIGxXkXRrSbIbAiy7oouskxa/VKQPxDzqjiw==	a19981c1-2799-42bf-84e0-48542e3899c2	2022-09-24 20:00:37.844349+03	2023-03-24 20:00:37.844349+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ae352173-3e8b-4dc1-88fc-559c8dc75dc7	1pR5QInu61irldvIR66oqBQT9YgFPCyZAPR13d8FHDY1QlghRLGK3NAkxw6drTvASiTUurJCVtYEM5s+d2Hw/A==	5cc04ac6-fd32-4c97-9ebd-341ccf3e5e6b	2022-09-24 20:16:11.866325+03	2023-03-24 20:16:11.866328+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ac4ee242-cdb2-491d-9f2c-d663f49526aa	CautCFUc8huazDRK7CRYYz1rv+4BW8QxNXn6SfonOU90kEz7OfOWaRD06paW0JJOIjN5jeAutFZWQ/I2jftXDQ==	913fd20e-9c85-47cf-90bf-0c6b3d92db0c	2022-09-24 20:31:45.717101+03	2023-03-24 20:31:45.717101+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9cbe8af5-a6e8-490d-bfba-8e6da381e0f0	7AUsUD//EAZAX7vy9V5S5k8GpDjWoqloP5PQ+6Y4b9OBawNVJX5XxKhDsm6wIbvZnm2gSd7xzxLfPjSBpSSxkA==	d0894208-613a-4a35-bab6-cae400c78e83	2022-09-24 20:47:19.673686+03	2023-03-24 20:47:19.673686+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1848bc59-cd37-4f29-9055-a8ae70d36568	oC4ZnuGTPYFFkJAFtqPvvAUE0HqrSTyJe4q8mhCpK36mf5FYvYXtFT9rtEV+WVjI/DIzMN0bPvz27OOMGW2kRA==	6d67558f-c6d1-4e8d-a751-464b252e40be	2022-09-24 21:02:53.927449+03	2023-03-24 21:02:53.927449+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3efb07ea-be5f-41ac-bc7c-31a378bcf25b	Fm7FirgmEFoFuQNMYcvkMYDWaf8w+/9KzLt+jLpGBbBXMKZzwMfn55IMLYKdi7h37Ctl4G1F0h7393jkEgEzzw==	e2de41cd-4747-46a6-bf8b-5890390351fc	2022-09-24 21:18:28.094931+03	2023-03-24 21:18:28.094931+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5b4e23a9-ed88-4c2c-b987-a42cf5ddb96c	fMbYK1Eg1WZTVnWRCSQSqCnzbVmcSXTW2hphZyJzsCv58JW+O/OCcucq8gwfnvu4W+Q5t/Ujvrq/MzSvsu0deA==	4ef6bff5-1bff-4e07-88ea-583b284d4a12	2022-09-24 21:34:02.889079+03	2023-03-24 21:34:02.88908+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a7c37700-dc7e-4593-946f-2c4d363f40b8	R8lJszRqPC+3T5vqI93dtk/gHq38KHFPZFBaIBJLSddEk8dNulrtTgR0JNLeVsfqCBUQb887GB0gnHCq8WfPCA==	b04a891e-248c-4b0d-9c31-002221048b5c	2022-09-24 21:49:37.077887+03	2023-03-24 21:49:37.077887+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
32d0efb5-e14f-4f21-9df7-9a5103d52fea	oHe3lAYBelsIbVSm/fVKXiTc2rSP0rzZ8TrRtKpuDmEV0tJyXoHt4+ceFQQRGEQwSPCi5Fp+x2uEQksjp7Elxg==	3c98c4b9-4f0c-4d01-a40f-931f2928caf9	2022-09-24 22:05:11.921095+03	2023-03-24 22:05:11.921095+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8ec8c515-39ca-4f78-bcd5-26054ed56d88	7i3tm5X/2Cncc4WoHNOu4wlBdTmJ0AMQvmy/W2NF1XprQO1TG9Hwmns4f+uaTxaaqVx01cZCLyUYZUvJ+15WYg==	1b827fb0-055f-4695-a8c5-184fecc8870b	2022-09-24 22:20:45.754799+03	2023-03-24 22:20:45.7548+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b6fbd17d-3cb0-46d9-9af8-9cc44c6cf08d	7RZlfe+uQiSHOoE1U1qj5reHo6popvC7yEzj4E1Kw1Bq7Pu0Kf4z1krdlhQ6hAMFLWvB7dC+gi7V7Vr0I+UEUg==	3a555aa2-4ea9-4082-a831-5cbac565f1e1	2022-09-25 22:09:18.099722+03	2023-03-25 22:09:18.099743+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
01037c56-7889-4cf2-9da1-165fb685341a	i3t+CrgyxDm8LtJjn4/kGImVONp6Hs/Gk74F/jTTjmu3vTqT4u/12u7Gy5jGIF9n7JSeHTdO6Yzqlj9F3PapPQ==	1b92c6c8-3062-4107-afdb-ac5fd9659193	2022-09-25 22:24:54.359948+03	2023-03-25 22:24:54.35995+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
09f5f66c-b372-4e5c-a116-0262abd45732	oLeNop3E5SfeIy6LZUOdSZOJ5W+q/Aqo/KyvJMOIigkasgPzYprjQUh1WKsbWO/+wOugs4gkrqicEXcrt1JndQ==	27198e76-91a8-4cdd-8fb2-9ffbbe10706c	2022-09-25 22:40:30.32981+03	2023-03-25 22:40:30.32981+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
cea5bb55-7924-4d9f-8d4c-3f8353303c1d	z1Fbo+At2RfMvHTB4Ggof1MVvCpSLS/q97+r95L7EjpP6wRCgmFk9uIuqy4EFSZZ8KRAZsR0UsAnszmtJ1zF3w==	ecec7cb1-cea3-42f4-b326-b075024ed4b0	2022-09-25 22:56:06.115569+03	2023-03-25 22:56:06.115569+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5facd061-f5a9-4bcd-9885-c1f6a8f79cf9	eVfz6Q4r5PFAqb5bkqPNKe8YxNcc2zGgxA92lUN1YM9bpZCCfqzJgOZKBUxR60k7HeEu6xIZM1bS1nffMaJePg==	d8a9f848-4800-44a8-a9b4-a3bf2d92ca3b	2022-09-25 23:11:42.179153+03	2023-03-25 23:11:42.179153+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
dc256639-7075-4a01-a58e-9aa3a6dae3ae	X/NxV9Tp/yiUtPgY5KAmnNvD+zHECO7PdgXCwKbsPFeovpIZ+fnPpYcH5uE5A1KQ4o2LhYD9LzIj4zuzw0faUA==	19a1bc09-4203-4832-8905-b35eb40ab8c3	2022-09-25 23:27:18.213361+03	2023-03-25 23:27:18.213361+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6c3add2a-ef7d-4245-a935-b2386bae90a9	LdZRZV5ss3C2YlYeZH2LkCJr6mnkHeKvgQRcslnLkUbItUWEtUISxuArVrMFFCX7q3FbHusDi44owlh8ixuFFA==	bcbc1a06-eada-4aa4-bbb1-60c2ae3b1d95	2022-09-25 23:42:54.099881+03	2023-03-25 23:42:54.099881+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4a4e2ce0-1102-4857-b6c4-60fbb2bd09cc	Z9GFbsl1FglVcnbDEneqe3iSHZgq7GxYnqoCLRUoEDulbhNFM+5x14J3nwEhODdRZ7YMvImbanhJF3C0gWDpaQ==	58dd5539-f373-4ff1-9288-5a789edb179a	2022-09-25 23:58:30.032308+03	2023-03-25 23:58:30.032308+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
12116d5e-cf57-41ed-8ecd-7c0e999fb8a0	2NVYcdLn75CCkYGkGc1BMB6pM/+YlmvUQhVXKmQrCHBktKZhKDuaEHIPuB739QJ2lxaGD244pCWrJAB/beQ/lg==	44b98a02-310c-423a-a7f9-14bc7fead521	2022-10-02 11:56:16.617171+03	2023-04-02 11:56:16.61721+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
3e863e2c-fd27-4da7-9878-5cf7e63ba255	Bz1I3MucxC1GJpppAPltbqY4jz03FC1BwlQtuP6TyTgwfaY2CQnDLkEe8Y30YF+VyrfyWRVToDU8qEO14E+wwA==	a9923e63-17d3-4647-94f8-63e77c252266	2022-10-02 12:10:17.929256+03	2023-04-02 12:10:17.929257+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
e7f42311-6592-45c6-afbb-83996d182223	fOwtfZ5dLk+dWL3FSS5J0/etASNsK1pGpskaLVYZ8PHFrq8rC2E1bqbTlHX+ZSJywHkigFlO52ZRRJbMp+00OQ==	14319779-b4e9-4082-a198-552d861d5406	2022-10-02 12:24:18.830683+03	2023-04-02 12:24:18.830683+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
3482f5c1-d7ac-416e-9a53-200563009532	zaPGmoEEPstbg6zyZrmrweoxrwjAPbOORUQs9nRQNXERiMdteiKzpufxl/cdtcshXw8LvDma4XMbt23S2Zhc7A==	a26b9c06-251c-4423-94f3-d7a782ca7c32	2022-10-02 12:38:19.900687+03	2023-04-02 12:38:19.900687+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
c1e1d2c9-d9cb-4f9a-b649-dd6367972b12	AoMFtUusRtFyQUCyyrVEM0miscyqvKSnsBCVjPI5g8cPTjhPwPTOjXbx9aUKJIOetsTvK9uuNl9ZMkk/3MN5Ow==	f8df3970-e464-4f6d-8a05-db5c3056c891	2022-10-02 12:52:21.379538+03	2023-04-02 12:52:21.37954+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
bbf78ced-084b-464b-9b8d-6c6ec82eef59	NSFVBmKLmmXS1Wq/EAEwvuuqQauzrGbXy0U6+bLWtSLwD+rVloCMkYgGYyIiChwUTK9mO9TRLLz9DVnVKpYpKA==	ae0a79bc-a92f-4c14-bb35-b614880d88c2	2022-10-02 13:06:23.296554+03	2023-04-02 13:06:23.296554+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
8ed5b617-0f63-43ba-9434-33179c704610	NY3FuWtNtz++qSrQnRpaAV9b5V/gbMUCNq2Bwecc9XN3SaVihZhEqNsRLs6j3h/MAiOR3W5lgwW+KQ/ASn2oHQ==	5f53c1dd-607f-45c6-8c6a-02d05cfe4ea7	2022-10-02 13:20:24.954311+03	2023-04-02 13:20:24.954311+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
02c42b42-6516-4d10-b5be-9ced94a6272d	zqH9nC1D8YxvSJBkC91ChVbHH82ZRKwzGXZH7fFC/lpJp0AKjgNkrjYvd8c9L6jMMi6puEB8ggFIIrTcl6L5sw==	d6e76356-0639-4f0c-8601-3850d82e5844	2022-10-04 22:14:05.400499+03	2023-04-04 22:14:05.400521+03	f	e9e8509e-eff5-407e-b8f5-451e20fc158a
cf7696c2-f22d-46c8-9d6e-0595ae9951fe	MldE3PVMIdG1LdDAAAVemXW0xzdlIYfWLxyy929WTtBS0fwZ2q1GWedpSNYxEGArUIQhaVsyjRIFm3x64PfbIQ==	fea44ea7-5e9d-422e-9e00-b5d0395f4520	2022-10-06 13:19:54.076347+03	2023-04-06 13:19:54.076408+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e121a18f-c98d-42e2-9f70-32775af8013e	dMHIcOlVe1rAeHpca7cjQVIZLOJ8n4t9FFLO+Ys8HAuTXifD3ExPo7JRsmiPH8cViVsFTl8AsFaErVRJp7xT+w==	5e1a0803-f5fa-46f4-87f2-6493546e1aed	2022-10-20 17:27:02.752654+03	2023-04-20 17:27:02.75271+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2df2e4e0-8875-43e9-a5de-edcaf465fd7e	xzOpdgT6O+9VuIgwlObpmXOQEPsXYORBu9+K2WGfQlixVPPby/aBf5CsNBdXpLybmaDVnPNRRMZwZOOoeMgo/g==	e4c036be-bfb5-4a39-a42b-008931ff1c58	2022-10-20 17:45:02.668223+03	2023-04-20 17:45:02.668223+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
cf9bbc2b-7a8c-4ec3-8620-7578876febbb	he4ZOM408deVIyALteqc1Gh8Al2lqjEDH9Xv8GSN35Sb3QWCNR0XDNIvbbuNc4zStxjLdc79ql3mf5uDpC+2mw==	24881499-6a55-47e4-9c5f-c6c60c54e0d7	2022-10-20 17:59:04.472751+03	2023-04-20 17:59:04.472751+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
26784a5d-ce04-4311-9936-a8fc1802d6b9	jgJB2IdTUO+76L45Ng7oKMYElGB1c6SQIXm/+pOfjdI10cwlQ1883G67NufQvAE2ucA1izlbllkireIEnqxt7w==	b5d078bb-bd04-409a-8730-1d017e4bd991	2022-10-20 18:13:05.37265+03	2023-04-20 18:13:05.37265+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
3d161aed-0657-46d5-9d25-fdb819481777	Kw/PP5e/fI4ZskyQL/eMwudyG8h28mHs2DjzygGokiI4sdQegdpw3gpT8oxx7zUztRNrJENmAE9sg4wvWtUTMQ==	907e4426-6019-412e-898a-e266e196c307	2022-10-20 17:41:02.684647+03	2023-04-20 17:41:02.684647+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
46efa096-4eb9-44dc-8333-c160a18ad031	Ma3brHp5I8vf4Ivo5uvd//ywxTXPJ+EMAtQ6O75oApCnq6A7ZM32yqMK8eoo/RpjAHeQFhVfqcz9d2rvlwwYNg==	a67d0f02-8d54-4fab-8267-f477ed4ce43a	2022-10-20 18:29:45.748767+03	2023-04-20 18:29:45.748767+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
7c615191-5507-427b-b37e-aaf9362fb9fe	0wQ+TqQPTqg788Rv4VyRcxpBWTC4KD0XpQQItZfPyl6GOwfdq5XavDSzYlGaWkCyjiqAjGus2ztyTmdcOJ/MJg==	1a52d4b6-365d-40c7-800c-499065146aaf	2022-10-20 18:27:11.392876+03	2023-04-20 18:27:11.392876+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0c38800e-99b2-4c7e-a35b-9bcd9d7ea1f8	P239OEJ9c/Ir9L5tuo81t3BC1agb+1pbhwKJpKY7RfLc/qOFexsXO04jtCRx/43FUSTb1kW9BQXWHgWaZ03X6Q==	88bf3924-d3ca-4fda-8008-a69b9407071d	2022-10-20 18:34:45.73162+03	2023-04-20 18:34:45.73162+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
8a8705d7-c43f-4261-a61e-d0669716a3a7	ZEGY2FSnzAk3YFq4I5lSiNfw3WMuS7OyJIOPqC172BFrhMFbwsmWOpvEEQy6OmNZagdEc9/VZ0GsAljReu7zfw==	c5ffd188-3773-49c0-904d-7131184d76f6	2022-10-20 18:41:13.036155+03	2023-04-20 18:41:13.036155+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ac4047c7-da17-4af4-a35e-a181dc5b7598	tta+cGbC1ogyHQpc+rhXNrUNV1ee5S81Wjg4XmhqclXmyDd7Q1IC8A+UMfq9zpjXYJ7D1YRLoQjJrjFnSXz3Qw==	cc5dee55-42b4-49b7-b320-1f05515c4b7b	2022-10-20 18:48:46.99436+03	2023-04-20 18:48:46.99436+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d62e336d-ecec-4886-9312-8a40a924bb8d	kpaxhOEcd2P5srYz0a+mTbQ0SEqcIVkBfakub3DYDkbMlaSJR+vktLqTg5Xx1wcavZMfoX7SMUvyd580KxgUYA==	0f896de1-5f86-4952-afaf-42bcf344d556	2022-10-20 18:55:15.040238+03	2023-04-20 18:55:15.040239+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0bca4159-ef1f-464c-a9a4-12b561f27bd4	00zPLLm/ZEZejuY9GKjjtSYVcanIPWV+cC6o317DrH4aWoHhMnVX5xk+t/qCFHMp23/MgHqDoszmNcu1SRMUUQ==	9a0dabc4-64ef-44bf-8ce7-8421b939429f	2022-10-20 19:02:47.999312+03	2023-04-20 19:02:47.999313+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
e7c1525e-2ed9-4ce7-a4b0-c50b7f6f96c4	0lRdxUvr8tsfq1opI/NhY/gl6gXqLbHQQrQpZ7HsGIeQC3ayzwbhaAtzaspa4TWzxC6N8dkz1nmSRaESc6zZ4A==	4bef099e-aa1d-4015-90a1-8d5c40fddd21	2022-10-20 19:09:17.102754+03	2023-04-20 19:09:17.102754+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4c19ee3e-bb54-4f79-aa7b-bdd9abc3cd9f	t59ayL8aU12Ur0E6J6pmltCYPTqX+pHKOAMWQP0PZY0C4vwEPcYQOVJcF5rVomjFzU8zpLI0MvRPVgMtPbJ0Tw==	1828374e-03e7-414e-a356-fe36ceb1a5d2	2022-10-20 19:16:49.463791+03	2023-04-20 19:16:49.463791+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d213abbc-3b91-4302-9ca6-2495bb252342	9zRearip7nuPloguNshu7QSN6m8xllnHqgyenN2DynJwxVBIxHcLp5mmVBfgqt3UeWN26x0exRag1dA4XFndeQ==	eab9567c-ef38-468d-8ae6-f35c65bf82a5	2022-10-20 19:23:19.046599+03	2023-04-20 19:23:19.046599+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f2f83cd2-30d2-4d52-b66a-4410e754f3ec	ayOdqF4fI1EO8r+nXKQRS5AYNCN6UCieYcU3hHBxxMl0G0/fIceDW5wsZwclOl52MQRTN/c0FWyNFV74aLdk3Q==	f8ff864e-5d42-4cfb-8dad-b758c8c178a2	2022-10-20 19:30:53.065974+03	2023-04-20 19:30:53.065974+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
51bf5062-52c6-46f9-90d6-140b1b63fc31	FugNjSMUjjUa65WnnaQxSIzHnlzOOuTVxedyOTQFV3H81zDZGVs8zQ6fm8YKdRkkVsOUY2l2d1AQ9e4l+sO/vg==	3ef68271-f9cc-4dce-91ee-804667e9404e	2022-10-20 19:37:21.19829+03	2023-04-20 19:37:21.198291+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ca482a5b-7ec5-476f-9f2b-d58eb0c944c7	uTGdlbFmju4iOBd+NNeAh4voAEzmT7o48xL8o9AHY4LRZxpVi5YwP3bqMphq4tnvq/B22xNSRAIff8ikOGV5Wg==	5bd5a94b-a941-4e0f-a809-962c1bec7c18	2022-10-20 19:44:55.089069+03	2023-04-20 19:44:55.089069+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
c4dbe787-2378-4ccc-8338-9ef2083372b1	U4rg69r6ku2YA8iniy/Zr7ksqyL66MkNuwZMeVUymIQG2gF5XfurKgRaLxroEFPW+hFHyquoLuhVjuksBg1xBg==	c82810fc-73d0-4d3a-9d1d-fdc06206afcf	2022-10-20 19:51:23.081075+03	2023-04-20 19:51:23.081076+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1f647ac1-1030-4806-834a-ba4a82049dc0	hcSG7ookmnxxWGZQQuE3pNWFcRHqHE5rWcP2iiLzGpBNxBscGdOSLv0mCMn/FTxa4qN5F4eHw7LAnCa/rb52Sg==	0626f6f0-5f77-4879-a78a-f970caf3393f	2022-10-20 19:58:57.014012+03	2023-04-20 19:58:57.014012+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
ca7a5424-ee57-4264-918e-e5f0e09d42b2	IhEoD1/d054ush5zHydPU2vVqFVKRGvAzjdB1U+/TA7JFyjMwZtoKKXk6O7XgZfp1CNbvFquXJ9ZbH4EokHDdg==	e3fdad7b-9880-4b7f-8b89-603205475979	2022-10-20 20:05:25.10115+03	2023-04-20 20:05:25.10115+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
03fc6f5d-b8f3-46f4-8144-53bb2abd7fb0	9ck40pI3CHGlGyRF5YK/FU6+FcYhHQjkwfP6008vZNRGdvN/Sp1NsSMrvabzvmO4AnXReCEuwh+dZczmlpITSQ==	9dd2f1fc-f7f3-414a-967b-ccd334e0cf0a	2022-10-20 20:12:59.077735+03	2023-04-20 20:12:59.077736+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
381a00f6-7e7b-4a03-ad95-9e421545071b	Bo234uBdVIa9Q3fYcmqYT9Uj5EHQuCAfREDZrALGB2583lMvTNNhK4E852pgEzlA072fgXdy8W8yr4UpUvMMlg==	48c56de2-7b53-4ee4-935c-1982d48f3cdc	2022-10-20 20:19:27.000436+03	2023-04-20 20:19:27.000436+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
43980d31-ffa3-4f16-a1ef-e50428649c9b	e4Eo4yLbnq8q/0H3Fz1iwMjRYV0JpbAzhEHbJqKaIurbXaRxLO4e+O7L0Ti9Q7ynEl+zU1LZ3iZ/1u/mXFRSnA==	c65c3bd5-8930-40fa-8da0-5d21b3566c2b	2022-10-20 20:27:01.142077+03	2023-04-20 20:27:01.142077+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
c5e28eae-3ee8-429c-94ec-21716669eeb3	JJUXn/g1CyNFVqHDz8VrBm7HDcSZgDZO9Bw4mZKlQw8wmvjnMfw9QU4Tu7TYqgBcXtUXBlZU+TnBOjE3PVcnng==	b79c58ec-80ac-4ef0-a441-a1b6cdd24424	2022-10-20 20:33:29.047464+03	2023-04-20 20:33:29.047464+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ea7e6119-e984-4bab-ab6b-c71800678ca2	FIj1GJi+ztmHjBBQANFCvDUMgOvITsXz1GNhZ/fESSFX/MW8HRr2TfzUVXpLLo0OwiWmMKYyrs5xBtbOA79dRA==	0c57080f-a6d1-44a6-a5e5-acadc02c3203	2022-10-20 20:41:02.990677+03	2023-04-20 20:41:02.990677+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
d2f3ef12-ab7c-4447-80f1-eb43e2ee5aeb	hwboBeR0xcw7IpFP/bmpw7d7IYXbZuvxIbnDKB8Sd575nOpxLUolvEs0ATdPBzdISmXWnhSoEzmk0AUh+NcJqw==	0c8db7cd-5d27-4194-ae16-4ca3a46584a5	2022-10-20 20:47:30.995959+03	2023-04-20 20:47:30.995959+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4954df9a-3c64-4346-a584-f1f5c116a4e5	ZCTnN8gm6jQy4SFYmk0MJCcl321GJEDqW5L2iBL8T1tx3QRjuUdvnzkXHnVblW68gZFSo7l3GswD/LX1nU+Lmg==	43fe1680-1ad3-4136-a878-1b200a23bed6	2022-10-20 20:55:04.007509+03	2023-04-20 20:55:04.007509+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
23ca2274-0acb-4e90-bd19-4479ac96fc8a	3PgNd6dF6YUYiI9Gx6yYbjfpIvH8DfyeiluNsduRSXpqgmREWFxtvXjE83CsUa87H2AFlyDq0HvS7QiNa/zEjg==	88933200-2694-4e5c-b27f-91019ba98f0b	2022-10-20 21:01:32.024036+03	2023-04-20 21:01:32.024036+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b06df002-b7be-4846-809c-b5df4d20d090	xU4KlenY+piiHpXVJvsNcLuE0VuyrARStianGqT/djzJbQ5ubFlIfmfKIAH7R+97f2uwtTW0Xs0gSut+cyp7jg==	3fad1071-683b-4bc3-9571-ec70198bf4cf	2022-10-20 21:09:05.936433+03	2023-04-20 21:09:05.936433+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
37d981ef-2a53-455a-91be-7035987f0fec	qzgx5EPvR28rcsC6oSXnFYX9hiKK6ZXUVwKpJeaLE8jmOvgpbW4PPjZysOYVk/FFUE9aGDBSIPn/x9+OfnZq8A==	9444570a-de48-4ff8-859e-0f99e70567f2	2022-10-20 21:15:34.009326+03	2023-04-20 21:15:34.009326+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3af8df5d-e815-4486-8eba-bb102991cf53	6mj0wRxueJWilPDjVIgf6rTR1Gt8tY3BzNV7UQLxGVgapr7gclZ4NiDlzCFxxOdtr2CGfUEnuGehG/O4F1dNdw==	576858e2-af29-4fdf-b684-f2180426d7fa	2022-10-20 21:23:07.003552+03	2023-04-20 21:23:07.003552+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
8514b82c-533d-4c4d-ae03-c68a248277ca	QdD+n4S7XYEdQxI/AC6cTPkCkXqlOjgoibGfq7rBuyFVaApt1e1fmIJkxj6pRifJiqBO6kajg2tLXa2MCl8UrQ==	1e929674-6760-4a01-a610-071116dea352	2022-10-20 21:37:08.949412+03	2023-04-20 21:37:08.949412+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
f5075156-f7e9-4cc3-9ff2-a6ac969bc88d	MpUuwdHAMnu+3mv6xTqt4/yy3DFvKWsEuK0hTyVEASmSGCef31iGNOQUqBxxmJQRLyRBbNAI5j2owwWPn9Znlg==	e2f62d33-aaa5-44a6-a18a-191d666be37f	2022-10-20 21:29:36.113375+03	2023-04-20 21:29:36.113375+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8e754ffe-8972-46e8-b181-b4760757ed6b	TgcmjZepYLm3g9kxvx4rXMSQ0sRiLbahN70mLSsEExFM28KwQ69ECdBhGW5nnOCDZjLwKdDm5JhAnV+PewfCvg==	80d2641c-fadc-4669-a619-1d24a1fef5e7	2022-10-21 00:17:11.673474+03	2023-04-21 00:17:11.673475+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
b2952dcc-cef9-4e81-915b-d421b396bfe4	dM4pGHYROdAQDu4kf6oHR4zxCg8B/FEay4dbSlfpkG5CGbnsmCJi288Cm1MJ+tnuXiobcehlNVxgHAW9q6YUiA==	3bbdcd81-a3fc-4825-a710-63a9928a3077	2022-10-26 11:37:58.256109+03	2023-04-26 11:37:58.25613+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
9383cb1d-3704-447f-b66d-e4f69ab60b42	6kIovhSMP9lTs+3K9q0r0rgiVIVTfKN6x5GmRjmgi79+F+rrf3E3MAb5K0ndF3OxlJ+E8aF7sYNbU/wugVVEtQ==	4ce12772-1bb6-4002-ab32-658b8ef2420b	2022-10-26 11:48:15.385068+03	2023-04-26 11:48:15.38507+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
202dd1ff-f4f0-495b-a6c9-ef91e2e08930	G7fB/VwTVaatb+1/4Wi717BJxsnaBGVtNtepD+SR3oZ06Fqi/uWFm+NvqGet26kxRZBh+cXxBprHIastEE+p/w==	2ab02b39-7637-4e90-a0c4-8aa01f3431ed	2022-10-26 12:02:17.235567+03	2023-04-26 12:02:17.235567+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6e979fd3-68fc-4f5e-90a1-abeab1066903	ZkqQ3X+X6omxBLu+m4OHxQvZoL2Kmk299VvVmwU+DDzC7o8mk2daVInm6eP590Lh1vSjtW+rn2oAqTLEDJzi+g==	78e24259-c511-4227-b3f5-673a02cd16e0	2022-10-26 12:16:19.035638+03	2023-04-26 12:16:19.035638+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
abfe038c-f6c5-4426-92a6-819d47cb832f	GxNG+7VEqM4TkwKOlQSP7ivI+roK2cxd937YgWS2UcibkXvnqgN/QR0vfjjFe0KccerhRbi5uvaFQAD8Ws9FDw==	5b9bccc7-89d0-47aa-b6e7-0ecf60afb36d	2022-10-26 12:30:21.029632+03	2023-04-26 12:30:21.029632+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
db294cb8-7ad1-41af-b4bb-5544b1105ff3	d/Rqgcfm74sJDkHPqiUOc1Ug8iUsf9bKRlY4lJbvlI6TKYBAacl/6fSG3OIscydWbqkdnYS9FsF8tCbpw0DzZQ==	ba79e614-85f8-44eb-a138-b67fc4df7f0a	2022-10-26 12:44:23.012266+03	2023-04-26 12:44:23.012266+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c036fa90-4ec7-4ec9-a14d-f168e812d663	yGtwZSmLe+hC9IwhRoAtQ3nM1dC5XylPbMahX0WZMXoEH0rYp0xDX3CztQnFDLrmzbhnu8l2A30edU64+KCP2g==	20b529d5-f72a-4a27-9aae-68ce12e3a5d7	2022-10-26 12:58:25.021998+03	2023-04-26 12:58:25.021998+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
99675f7e-c9a5-4042-ac61-6c3f98fe0228	dlHH1x601MH+4snSxwe/bqW8llI4VLwaUF/37sks9IxYa3UhjXGr/hLUIb8jV5E/ZUvrilNSRaxfP0MIJWWgsA==	d770055c-eeb6-44ec-8800-474d0bc02154	2022-10-26 13:12:27.028738+03	2023-04-26 13:12:27.028739+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8d693a4d-89ef-407e-b71d-92352c8ee522	GQjV9C/pi1MlGHTSgus04KBSsbEjH3k9GT/yLCeKGWjqLCHKNinvc1P7ZmZw4tKXhb7cdrZIPnFcqPKtmh6UDg==	1e4c53d6-5a3d-480c-a0de-bf86caa1dbf9	2022-10-26 13:26:29.060424+03	2023-04-26 13:26:29.060426+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
349e9043-7cd4-4857-ad63-9edb6e17b2ae	7eiqVgxESARt/aKPS8+hYZC9Gtay3vzcuz/INeGkjEWFNCU7yfLZO/TA98r0PHXVYGGkuOLeFzSgFex6kfgrhQ==	5722df9f-6f92-4237-9814-8d48739aa9c0	2022-10-26 13:40:31.082162+03	2023-04-26 13:40:31.082163+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0d14d602-cd04-436d-a7ae-fb3021624a05	cE5SAEtymyYYe7j1UwwYJph3qGt7jxjDrD9K9ThU/NxiU4JoQuM26yFMVnRiIsTu6KTDEwTqucO05QYLIud2JA==	9131e3c2-e13c-4159-ba61-26851fcc376d	2022-10-26 13:54:33.168307+03	2023-04-26 13:54:33.168307+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c4c31d2b-93d5-4173-b3a7-a816c003669b	dWiqXtT9gz1xLVMGq1KS1G41AkGILi8IlxywFuLBDTPZq6VYF8NTVfJ35pFbdfVpRIAHjLtUMbDIbP1IplhxMw==	1e91c20c-c6ed-4fd1-bff7-4960d47d145f	2022-10-26 14:08:35.086559+03	2023-04-26 14:08:35.086559+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
718c6b22-8ba2-486a-a798-591110a90212	qxKYrXhG8wlqgcvwp90aC2LGNLDJXrBbNbHKjb8uF+EBEbn7qLHBT9lo96I6hEpBvLs2unkP4Zhu4kxvn1ZAtA==	9d91720f-5d23-4457-8c1d-d9a347a3c994	2022-10-26 14:22:37.246927+03	2023-04-26 14:22:37.246927+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ed9221e1-def9-4c2b-867c-2e1519b1edd2	0CUINaZ64SnLPzqo31rq2AGi9RrpAB7XAAcdlWohK5Ej9KLsEY5N+eYbell9SbJFvt+e636+pW6zyoY9tY7/Dg==	5a89c761-b294-4faa-85cf-377657fb11d5	2022-10-26 14:36:39.08291+03	2023-04-26 14:36:39.082911+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0a4cc8da-8629-4837-a5d7-ba97d70f7239	30cPj1ao32GSs2xmPscBOzOwAs3Eb8mlSEp143OHRgd5DoctwRo9kNHC9jV/DkMsEa6vl/OpFu4k2ypOReQgrA==	f8cd766e-0f5f-4d8a-8fc5-5e991cb74f02	2022-10-26 14:50:41.070503+03	2023-04-26 14:50:41.070503+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d84de2d6-06a7-4841-9993-e637464d0b6b	tYta5a1GIxobklrQNszYRwDu3rDo2ba/hHO4mSE5UYH4NGOf28gUaMHX1rdmgLnNXWRKSZ8QyEQsBSWnEQ6fPg==	f4e16f65-d8b0-4bbf-a4fe-f78706409505	2022-10-26 15:04:43.162758+03	2023-04-26 15:04:43.162758+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
954fc3e3-a766-44ce-8c65-ed484326c05d	TyQaffOYfOP/qwTMvoQU+vW0tJIWVBQdwW4JmKDJHJx7QlrhwA82/Nd0hrui1vB1n+5pNy20X9FpjujeSZv3qg==	21fbe553-8588-4a68-9ca3-dc80d1566bb1	2022-10-26 15:18:45.100898+03	2023-04-26 15:18:45.100898+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a914aadf-d393-457c-ac06-31e1f44d11bb	YAnKce9AHpguUBdmlLwhf2FxDrX92/b9X5PpiY7Rj8zM03SPqA9L3tMEQ8vZC8UIBAN+35yaz6Yj2aeWaZk8nA==	f1b4612b-3cea-4db7-8311-79fda6d297ee	2022-10-26 15:32:47.253644+03	2023-04-26 15:32:47.253644+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
53c67561-6b82-4e87-83fd-d119934b1333	IygQw1xp6iflsqWOzTFoZO3F/9nqX6YxYW8NKxJPicsTM/gMX+W6vgYOHrCwCad/GEoaYssUnDsa5+kMyCyg0g==	4fd22c1e-2891-4c8d-a243-270b2c1d4c1a	2022-10-26 15:46:49.132116+03	2023-04-26 15:46:49.132116+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
51dc1eb8-43b2-4a6e-901e-fc2e4760b562	7novNpDKVE394x2J7KSFwibVf4xkGgo95aXZ/Y8KIxEZvz0eac3/xGlmUFuiLkVJBeFPgf8K7ANXIwOUkHjmeA==	18285483-fbb4-45db-835d-c68c11fda564	2022-10-26 16:00:51.160347+03	2023-04-26 16:00:51.160347+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b93b0c77-b25d-4407-8edb-578c38bccb4d	U3ro6kboodRhqeJA/3myJO+ClB01QNezqbjck9Ghe6B1GXF0WEbTgOOvnfJ/UggE8hzqai6I9oRbozLpJqOz7A==	94d11646-f190-43fe-85df-d5e5212d4f46	2022-10-26 16:14:53.163853+03	2023-04-26 16:14:53.163853+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8147e116-576d-44f5-98bb-b0078862bb6e	YI/LwKFNuxZqALTXn1YZGNh0mrMCNDl6CS10Cjx0gmlBGCpvUq0irBkzAVm4NbB/l1wG2B0DhvMbV+CXgomzyQ==	f88f9ffb-0bed-419b-8fdb-6abbd8e0a656	2022-10-26 16:28:55.152624+03	2023-04-26 16:28:55.152624+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
74619d4c-7807-4e13-bbfd-7b2c9c0eae13	1VIb+uqNVEhIe0UiD/nZ7HVwevVHvLjDGPc/EP/iCLbDlzj+L+fHqEK5VI+dTNz4Zkq3UPmPaaoSGXBNm1yfUA==	7e41208e-22ef-438a-a8ab-7f6418c01471	2022-10-26 16:42:57.20628+03	2023-04-26 16:42:57.20628+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
398004a0-0f74-4283-935e-918dd4766ce4	E9aqOcTitEdYlZjICB5rLjFBE+0KSPbZx9R3GJiCEscJrb0EuEWZHYOkEaAa/ZGrLfkv+dPtP6ExljLHeUT0RA==	3408b737-1cde-4d1a-aeff-86a42621e56a	2022-10-26 16:56:59.311579+03	2023-04-26 16:56:59.311579+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2b8dae93-5e04-470f-89fc-a3e08fa468bc	k16mkLmtj4EFnKEIrDTXgbfSQqNbCIOYjmBelQVs1QTfGpMjjpfGTMyyGrSljZos9YOG6INdzZC9QGFiXlKn4g==	0d033d98-c597-4812-9c89-f923b74354ec	2022-10-26 17:11:01.202533+03	2023-04-26 17:11:01.202533+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
0c0d620e-7323-437a-b36d-f6b7b2e93d4f	onftx4cBEU+3E8HzHg89AIF8u2vIZ281hu2w7uwQW0GTLK23cpA1OyhPrvOdfGHU4RaCsajD4QIVu9pL0HnFuw==	ef8b6467-25f2-446e-979f-55e5164e4841	2022-10-26 11:52:00.275867+03	2023-04-26 11:52:00.275867+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2b48364e-d48c-48dd-b68e-73f3515bf786	aNesR3rBsjTpyjCCJOrvJqkJUyJGtFMQ4bVdo4jXBjSHj1IOPDix11s3kBWnXuke6IiBOGrEIOlEL4gY9QpNAg==	a5945329-7c4c-477d-bdf1-97ff549425e0	2022-10-26 17:25:03.124812+03	2023-04-26 17:25:03.124812+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a0383ffb-9a22-4be7-ae06-b2c9c66ef901	r0FovFpJ4FIildAoutJUN6//V/OtCe4BFmLFIAMSt3tIuWTY6W24VMuzlco0/g2AB3iBWgo+nzi6/Y6UUZG5tA==	a8cbae8b-4a16-419b-8c9e-a42867bcdd60	2022-10-26 17:39:05.245265+03	2023-04-26 17:39:05.245265+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2f9ae372-163d-4f12-9739-df8bd6586e8b	/wCXuGeg+AtYodrE6Y7fLuscFtBoYqne+uCnGSlUYH4fJCfats7Ikb+DzDum3pzptw8xvGqLcYLjrxamRcdRuQ==	343703b3-d7b3-4a44-b020-7818e0fe4d50	2022-10-31 04:02:06.028209+03	2023-04-30 04:02:06.028239+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b2988ba0-0bbf-40fe-8ce4-96b4860ff736	IS0BqiCwGeRwYbvuu/ely9dkFdiirE/Ucy4CdATYx8h4E3PK7ELRY0tRMDbbHNMxwyLLuGpDRrTjzMJ9rWayxw==	e926bdd1-020a-4b2c-87ec-ac1fc599a8c2	2022-10-31 04:16:05.002922+03	2023-04-30 04:16:05.002922+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2cecfbed-be62-49c1-bd21-4a45864d155b	KkYXwmiMs0wrFhvwCfLgnIPTWTGiv730ogNqwp50iYMskmr4m4cGBxfxp1IqBL4cSpYnsUdLZFO2WgRd/4VdBw==	19b2d55e-5374-402f-ae3e-47b39667c520	2022-10-31 04:30:05.042779+03	2023-04-30 04:30:05.042779+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
501b770e-0a21-4e5e-a0e6-4ebb39f1e831	BVexjdzVr3cUlBcBEeKNB1blVCEghWGW02lWYzkbqJnCcZNM3FJkUXcAZMOJ/LVR4nTjHBA2XWrnXThUYIilzg==	241fe278-986a-4506-ad77-c6d6f915100d	2022-10-31 04:44:04.718574+03	2023-04-30 04:44:04.718574+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d2c18fef-67bd-4181-adcf-b6bd46726b58	KrEzG8uXThNuLwbf580twb4X4+N+cjHWADZpDSSh/jT7jOVcPKnXeXMy+5FEbdVOy7eEtRxA91OWfN4gwo1s1A==	00c8fb20-5511-4a6b-a8ed-30f20ef57a9e	2022-10-31 06:18:33.591585+03	2023-04-30 06:18:33.591605+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
043d07b8-85c1-482d-96ca-0850816a4297	Io99CVD4+fyUtRkzb5oATmCj5uEJQeS8zhhSewB9PUUeqHZ4G4qQsAywtrPHCtjXUXYwX6XtMVAjXxY80WmUFA==	2afbe8b6-ec95-4ff1-bc0e-2f1509118c36	2022-10-31 13:25:00.10893+03	2023-04-30 13:25:00.108952+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f05757f4-b384-448e-9650-dce3094a8239	ffuXcsbZuLd03bpNO0a13c3shCB/gTFk7mLsdEcPUYOYTetXqQZ6NOucEpa57BLgYNtvGge+f1D0nbq/8AuOtg==	90086319-628f-425b-83dc-8d4ccf1ed482	2022-10-31 13:39:01.318103+03	2023-04-30 13:39:01.318105+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
aa71df0c-6b96-4e6c-bf08-2e8cfad83dcf	24gIfMBvceHx2Dr5WLvLMrNFm1M3Ub+d867vMV6oLX3dz+alc3rJtsQqfyFhW0s2K9WDbcec/L4tNlsF63lJgg==	bc5d2d44-79c8-4c91-a3dd-3e7268b3f9df	2022-11-01 13:12:17.014027+03	2023-05-01 13:12:17.014093+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e837d1eb-1a8e-4bb0-b00f-19ea20547162	S7RJaH4f0tslCfTrCRJfE8FDH8FrgFwqAn5kv/0sfcejD/j5nIV6pyd/mKjXqci2cIXo5A0jdM3+NT+/Fty5aw==	1aa1efb2-191b-4688-b4bf-751cff04b67a	2022-11-01 13:14:06.758558+03	2023-05-01 13:14:06.758558+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
80492186-b01e-40f3-bb46-1ce6b5277b2a	Rql76UJElQ+XVFjAjv6vF83gpbZXlyE7o/Ancj9xTkA/aCn6haj79Dd/1b92Fii6vtgR2wrsTYPdaLrfFzrBdA==	bc26a923-eedf-48f7-bd70-8b9bb62d77df	2022-11-01 13:16:04.59+03	2023-05-01 13:16:04.59+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
f3df021d-71e3-451e-be8f-f20e41fb6af4	eFOLQiG9Au4p4OdJw1D1sMNLalYJ3CeaBrIBJkCJvHT93T2hMb6zKJTDhKNPXnymKlFm72cGJUb2PtXS1Btdiw==	2b968672-7538-411e-a409-fa74d2deec9c	2022-11-01 13:22:11.63933+03	2023-05-01 13:22:11.639332+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
c5cc5268-1341-4699-b747-43ef2f35722b	reSWL49Dytg/IDRIqHHrzupwhQkfcCanrYWJ4fAHd5nBv4DTif6OT/RvuZ8at/paywz0k3hp4RUqH/CFX8r7pQ==	be17e1a9-8a06-455a-9034-965fc7a058b7	2022-11-01 13:36:12.731864+03	2023-05-01 13:36:12.731864+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
c1f31401-8a5a-4979-829f-20ee2cb8d656	5SVd35vvMcOBYoQ9a+R/dn2NWweO3ibfjyTqm5v9fV1FEci5+JTxcqsh22FzaAjzZ89q8mJmGvZv1fRubHaeow==	0958a81f-2e2c-441f-b84f-714408e852dd	2022-11-01 13:50:12.749465+03	2023-05-01 13:50:12.749465+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
96d221ed-6c1f-43a9-a670-1c81d78828d2	DmrzvVcMvlt7tCA/m/UOOOyp8+Uy0PFxdybJdz5PCNTHPQm+fDhfplM2RX7wV4n3N1Pt5xoMO4DGaxuMvxK9Mw==	0ceff057-5c0d-4e26-a6c1-09c51616c2ca	2022-11-03 09:29:04.451423+03	2023-05-03 09:29:04.451451+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
4a45859b-7b49-44ff-b00c-b5dfb4b97ccb	UlGhSt9wSJWT4SlHrcj4G2+wLbOrRGUq9T//cd649owaPqicpRw98bOTfBHh+3ZXQ7N3aOPAkp+mWXWnHPlxPQ==	9183ccd3-3f60-4f80-8ebf-db7d294de3b8	2022-11-03 09:29:15.251291+03	2023-05-03 09:29:15.251292+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a2155b83-98b9-45d1-8359-6c781605c53a	GhwdPjc0Tch/wyyYb1oY59bAkXiXqcYNlgbjSz/rOGK8lXiyC8dcbHT8W7e9f3bCcoAs+Oyk9FOwFbLMafg9Qg==	c6c6eac1-89a5-4dac-9079-2590caa4b12f	2022-11-03 09:32:43.349632+03	2023-05-03 09:32:43.349633+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
c83af918-c183-456e-96c5-9b84abd4de0d	tGc61gihcnVVTWxkETZRgihg/ZX9ECc4ZNcsUjyR4poK81UeEgkmo1UZ3bNvQytlCkVLidKgMhrOFGtn54qY3w==	a84ae1f1-e0d3-494f-ad36-473599d315f4	2022-11-03 09:33:32.009093+03	2023-05-03 09:33:32.009093+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a61a2997-0b4e-449e-b1e1-a3fda926d435	RAufcSKI4ymwKiWvn++RmWIV0DJVK8oH/5r+Sozfap7SohLcv1N2m7nLsBLTKD/I57wgK1zf382ntu2xdSCFSA==	56654d22-5e94-47cb-87fc-60a4feb0172e	2022-11-03 09:34:08.543731+03	2023-05-03 09:34:08.543733+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
2844a02b-2dec-477f-b422-3707611e6ef2	dao7k7wdTh0V96EW4rx/8WpcoSpdqKHBRhoLCtf/3XXU946rySC9PXy85A43+cVzSTQd8+Ds/5/vmBGAh8rmaQ==	67b6e62f-6397-4530-91b5-681da71f28b4	2022-11-03 10:50:37.014822+03	2023-05-03 10:50:37.014843+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
4f8f0da5-27e5-4cb0-bddb-b275d734b847	b16SN4WqCQ+f0Zp41YBVn/0yJZApZlAw6/QKzZUDFPBiy+Cox9/bcY9HANbFhGoai65NO5KJq9086mPNbIvu4w==	bb7aad86-159b-4fa3-85da-cf96adbf9ff2	2022-11-03 11:04:38.198153+03	2023-05-03 11:04:38.198153+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
194a499d-ec68-4060-b575-98bc1e85eeb7	GQEwOLNe0kkpOFGmj1aoqiT+jC3/2Ec98pIyfnG3GJ2qffhl4bh9yC/E2EtoXdf/3RhmBk4uQKWi42FSQHER6g==	64f836e8-227d-4716-8c4d-a81acccede9c	2022-11-03 11:18:40.711413+03	2023-05-03 11:18:40.711413+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
d8936c7c-2a72-47cc-b7b4-53bea09c0c35	iweKfmc/l7ZC4fKtCtIvFSZn+P4peh2ThBEi3eQ+JqrDxN1oRnHrOMSAvguAG7P+5tepZMtz+2ForhoY1SSB9g==	63056fc6-b181-4b1d-b886-bb146e4d7441	2022-11-03 11:32:41.661858+03	2023-05-03 11:32:41.661858+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
744894dd-5c31-4d73-a0ce-f12c0ab71ac1	lIyQZdVk+uD+FGpTvu2B5vgoTv2XBRDrjd34/265E14p8mQjE8DZv+PR71Q6UVTAlFmslGiyhBMLut0pocqYyA==	5bffa0ab-a64f-449f-98da-65f5a5d443b4	2022-11-03 11:46:43.279928+03	2023-05-03 11:46:43.27993+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
53a5a569-c059-443d-a421-de3d05a7dd77	Wx4/QZ7sQMTE7WY8Z9XztcEpTpQ6enNuJ5dL5k4MifnI7TG+EmQ3gbVtMQkdK6Lg9NBBm0T6TUiz3PpPulL4wg==	dfdd048e-3d5c-4dc4-be24-ce297b3c2979	2022-11-11 15:50:37.961663+03	2023-05-11 15:50:37.961692+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
66561cf7-a183-4723-8a4d-82b8122daf35	D7q+2w3BAql5We3ii65U4PQx1x/ojsXAhgZV0AVdVdpkvOXE+NcWova9ypYqcow5FTR50Aca2p/rcUimuE5Hmg==	5ffb3c85-86fe-4010-9950-0e9e7818075d	2022-10-26 17:53:07.356561+03	2023-04-26 17:53:07.356561+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c60b8263-7606-4412-97ce-4586c3671616	FSnvwfrsCJ0fk68cgyX/4GG6JeTtKfWAkx44ZLqzoGaYgPYe+TnoshuS/0dwk5RDzJKs7gM+OwZoDHIrKi97lw==	10b0e03d-c73f-4663-a802-71ee778ad3ad	2022-11-12 13:29:22.764564+03	2023-05-12 13:29:22.764589+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
12d66969-9726-4de7-b510-418458101e79	8TbWXM2JrSjIbs3ouvRUgSXwVJEjcAY5xRzR71Vp0imeXjDSlj5Gv8VN9IaDpd/AT7d9jtE7UM8hfFkI+Y2uVw==	62a2fe4c-ee44-4a80-9fc1-bbc06d91b68f	2022-11-12 15:59:06.644613+03	2023-05-12 15:59:06.644634+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
c39302ea-27b4-4ce2-aa93-821b6f481893	G5g4dYnuydtNEuHKmQUjYqKbIJppXW2PdjNeJjihDsLpJV21gqfTy0dy1A4m744rdP51eXKRAt4+pmT5iJDuBQ==	487f0eb9-149f-4394-92a8-76cb34393857	2022-11-12 16:13:07.917374+03	2023-05-12 16:13:07.917374+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5db502c6-a52c-4b8d-9377-5f24b222e465	d/VdSov8C/WsM0IVSf4ep0xak3RZmbP0PHkexwUhcXYFwLFmOYv3Zm5zFvi61frBchBQBNU0ESdYh6whSN7TdQ==	393d1e10-0a8a-468b-9210-4d3a0af18d10	2022-11-12 16:51:37.498408+03	2023-05-12 16:51:37.498409+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7ed63e42-48ac-4f30-a9b4-ee6536e39e54	ivSyXtdZy3J9FsLhVlf6MMMLpiVmIA86JxA4mdCUm+JqPpoz6ruwEAPFZeVq67W2k+vZEzdBTrGVZnpPHW3aVQ==	4055d1ed-75dc-4f99-8d8d-8ad94c117750	2022-11-12 17:05:38.892437+03	2023-05-12 17:05:38.892439+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
77dc6856-00df-4b23-955c-6f1bf5f242df	JtCtRDOOHV9zplKGH9f9jsdIXieRBBhbqljXjQI9MxOSsyJ4OX23IIxLAFtCvPbOrDCsmWe7E/LSITuY/wVjYA==	95088022-0423-45e9-a94c-dd34ee374871	2022-11-12 17:19:39.864183+03	2023-05-12 17:19:39.864184+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bde58a6a-e569-4f5e-91f2-a6d848209e95	p5X6VKCqfDnTkmVZyBprtR8E2gHWHGu8Tuwpn5Pc1sJkzChXuXWUBrf2FFhY8UB4Cav70zYsmjgT7EKWCczrTw==	d39241e6-cf00-4f31-8742-1d97e526a1a7	2022-11-11 15:50:58.15988+03	2023-05-11 15:50:58.15988+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
ddcd960e-6ec1-4ea2-a2ef-2da44b604337	L1fQ+HHuG3Y48fQE6fne8vy/oJ5am4/W2bcc29We1FgGuh3dTlkG9XxZT9dNRDPXYKS1SFTzW0FZxFi0RFJg3w==	661dfda4-2af7-4429-bb83-a8de9ecee3f5	2022-11-12 17:33:41.111728+03	2023-05-12 17:33:41.111728+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
41cd5032-e241-4f66-95e0-2a4cd03e8308	+7rTBCpnFQZXwmjdNEGR441FbgfX6ZbF4JqDRmgwpEUY77GoZ9BNDj/Mn5j1L03Kjm4gs5NgLr7ppxV/f19jlQ==	c833ebf1-dccb-41d4-a96d-d86a1d064e0f	2022-11-12 17:47:42.943874+03	2023-05-12 17:47:42.943874+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
fde17ede-0111-466c-9917-abbcd0077718	5YvoakkxqJPFZ+2e6j7XK4ROrGgZiZGxQdTtQaf1BPjYkly/7V9gDkFYWZ6YXfJ/GONiJ6wEKA9m8LWXagvG9g==	425bf2e9-2378-4d89-bc0c-03b53af3ce0d	2022-11-12 18:01:43.897896+03	2023-05-12 18:01:43.897896+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
66a76340-896e-4e5f-b6ac-ac5718a64c70	KJ69R4dw/1v6epVDlicadmAw2e7WcL54LQoAeqpqWAuYmH5CuMgSlfuKNVft/OHBGuPZoaQlclvlL2/1Qm/i4w==	b326aa79-8f51-4cc7-bd0f-0e0af7334649	2022-11-12 18:15:45.050314+03	2023-05-12 18:15:45.050314+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
82651bdf-c37f-4394-8323-83957fa08fd1	ah9kFrzKgYkAdv4D+8gw8dBxg6qy33UGBetQncegNnylIKCwe2xo8dVrQUzw+JsC6QWD0wD48kdSrGDFImOl+w==	88cc2af6-cf73-430e-8e2d-f5fc2187bba1	2022-11-12 18:29:46.963538+03	2023-05-12 18:29:46.963538+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
8dd7cef9-4531-4076-af40-919fc59d5cdc	KSBiTiF6ItMZJDTwzOJ8nlMolfOR2uxN0ziEbzOmbJG1TOxpVz8v4NBhQ+nslvvh/mzOcL6P52unxucxDzwZlw==	27c550a8-b199-42cb-9470-66e261803bed	2022-11-14 13:16:08.222475+03	2023-05-14 13:16:08.222496+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
4d0e2b0a-e97c-43c6-b80e-82cc016a145d	nV4KOBn6Wv9dQcyu4+A80u7/NkdADAhz87ojWUS9LX+6AkOKthtSok6l21GLhQQsNjpkDE1wQpcAKSbu7bQ4sg==	07702604-6acf-4e96-865d-91000f940772	2022-11-14 13:16:40.945421+03	2023-05-14 13:16:40.945421+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
7ad03244-33ec-4a7d-979f-e64434fab2c7	2trGGwl7FcJ5EZEBx9K/TA8U7aE6ysItTklanpw/bMuKydp4MTomYqbGJ3vJOigKIUXAba5+YDieILmwJOUwUw==	33613905-e91a-4c34-8830-da3bf2685b87	2022-11-14 13:16:42.488251+03	2023-05-14 13:16:42.488251+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
be62f250-59ad-40c1-9e0e-9fc678d8e2ea	/Bp8fJfWZAyd3ZzOYWTX3Y3S4KW6LeQQpWjY7AbmjeBOpnfNZG1IWWNl1e18ikszwf9L1Auny5F67HvXdoTmMA==	f56a0e2b-7c35-4bce-aeff-864faa0fbda6	2022-11-14 13:16:49.990661+03	2023-05-14 13:16:49.990661+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
5fcdc3cc-4bfc-4fcc-b97b-bf156a4dcdd2	yOW8ffbfufnSKFCNBRpieyXOH98g/OIV1uEkC3B3EjL5l0D7IDQuPJDPR0r71fNVYnCZo48Z+I2vLvWnQjAnHg==	5462760a-920d-4513-a6f3-82231b788821	2022-11-14 13:16:54.657203+03	2023-05-14 13:16:54.657203+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
b63bb563-5cce-4904-bdae-4deca3d53423	t75wzGeoAKBt83t4ieQ/Feb4UlY6jSBy0P4eI5PZA1wzmx9ML82MekcyFAjeP5wFFen4pPipOKehm99js/G91A==	fe15944e-e477-481e-8144-c45cd80e4084	2022-11-14 13:17:11.479709+03	2023-05-14 13:17:11.47971+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
952476d7-3dca-4632-b567-a941a3ae876f	XHwFGBQ2p41gopmaxY61F4r6K7UdR0yigyMMgwr9B3dQNWjiqd/NTJXajTJZs6Xq4+YOZ9WDw2CZMj+6D3fOVA==	060dfb02-f7ca-46ff-bf5e-4ce8224eb58e	2022-11-14 13:22:07.592975+03	2023-05-14 13:22:07.592975+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
54a25142-1d99-446e-9246-ea84b6e8dcb8	VMe18sTv8xAQgycLV+m0SBsnC/qJjRXGA1loA7JQ0DT5RM1HxxRF3TTSe/B7Ms0RqEmvbhwHWYaauHVJkBsrbA==	72aab4b9-77c9-467c-a48e-48ea4e6007e3	2022-11-14 13:35:55.318327+03	2023-05-14 13:35:55.318327+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
e3657b4b-7b0e-4d03-a8d1-97f32a7ef97f	xXUBYQkyrbn2X+/pCIZDMaIXOe9oZMKin33juLw8lL+biEuXPk0pkW6+jbubyX04yGdxERxhB6dlhG0G2BQRHw==	691d63b2-d907-4a90-a59d-7a2ee8486511	2022-11-14 13:36:25.652218+03	2023-05-14 13:36:25.652219+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
289d526b-6efc-4a3a-8403-240bede6eed6	pked1K7EUz4mQhmbaV3bDsnCoQNu3d/KuBVhCZwsPx9+vIdnlc2McU8Z8GLLTxZiKkVHE0VeN8pomab7UpZA4Q==	cfbe38a6-d44d-4341-b992-15cc0e0fa6ee	2022-11-14 13:50:25.335372+03	2023-05-14 13:50:25.335373+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
1a93693c-35bd-496c-bc5b-282b49359d5e	+uYEmCvkSYFynwfsa1OO5rBNrgsh9ZljgMCa3MZyn1G5JSwF9uUaXjUDnhpba6o1WPIHv1F4Z3KIcRJJpfbFwQ==	754b622a-fd19-431f-84b1-7fa22dcda073	2022-11-14 17:50:31.345987+03	2023-05-14 17:50:31.346016+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
76a6887e-a395-4aba-ac69-1be16e66bc75	7W9f3iy/ZqxXP3OGNU8onK07fekbCLBchIPl+fjCPrumm2CB1aJTxn3z9gYtKKp50laB9//K99ZfZWExEB8Zeg==	15d40445-297b-458a-a4d6-5ae19a6e7bfb	2022-11-14 17:50:40.932841+03	2023-05-14 17:50:40.932841+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f04622f6-293d-4e64-8d3c-c7aa8d958b51	1h8AS1Y/5BoUI5xsqL01TJ5sBcGczhu5Cdb21TQZ9Rh9aLfWbgv+BRCErBIEibS/uRtYnibQ8V/R2yEAu3Sc+g==	8d709676-bfe4-4592-a52c-0511a30ad99c	2022-11-14 17:50:45.854911+03	2023-05-14 17:50:45.854912+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
70e47609-35b2-469c-862a-0cd2c85739af	MxbE9rYQ6jYWpNTh1vvxn8BrxS+qoU6SF61ij4FhJ0zTj493k14GNwK7JCWixalJC5BAmo/BcPQvIfBV7a9jGQ==	130b2b74-c34d-4f37-b952-6322d0d6170a	2022-11-14 18:04:47.060634+03	2023-05-14 18:04:47.060634+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
71140939-23b4-4728-939e-b5451addedaa	M79I6B1Lta1XKTRIaFTUBk8CyMjeGtXsOB2XA1ygW3OTCxgc7xev6c1oyCdt6P4Ohsn3GgLnqz84fQqzcaNbbA==	d2241dec-6077-4b88-8bad-1ebe78247c4a	2022-11-14 14:06:04.777203+03	2023-05-14 14:06:04.777204+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
b29c5a87-7029-4f26-9944-33047690689c	RMXQgu5Cehuwg1eq3od7RMf5gXv+WZPqICoj/1mfFjgK2ILwjG5ZQeqKBkxKJ5oTeC7xs6C9rXL7PvMm5sLtpA==	4fadb4e4-c6a1-454b-8a37-0ac59094e91c	2022-11-16 07:37:35.933633+03	2023-05-16 07:37:35.933668+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
c2d79994-e73a-4288-8f4f-c9b21fbd166c	gmhWUKCL2nO10xmI1Ep/nCVbN4u8YbtJCJEiSGL2O0oMdR5e1nU94A2XShk+gkwBOBaXUuApq/qlNFiajVhGbw==	b377e563-3815-44f8-a347-c5155ab9ff2d	2022-11-16 07:51:37.147653+03	2023-05-16 07:51:37.147654+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
f5d4c8ae-0083-408c-8c36-d2d8fce99031	VidE+SkxMDufBUYNxf1cceGAfEMNY1KqjQYEhUy/WeiRhILa4ipVKf2jGBPaIJW6h6D7FLkSWOZR6B0JOQY5nw==	41de15b8-e8e8-40bd-ac1e-5b8e631b3d74	2022-11-16 08:05:39.320917+03	2023-05-16 08:05:39.320917+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
5565a321-688c-4372-a42b-32bc8c9aeec1	m5zh4sW85dv8dPQElTL8KGSU19LiD8wOZ0tuVkKmgvxn6ePDwxwkGLpvx14rnYycxOIiPCOPJd4K/cv1GKdJPA==	5e6a737d-244a-418e-8a60-517ef241856c	2022-11-16 08:19:41.277733+03	2023-05-16 08:19:41.277733+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
44ad68c3-2d85-4451-9758-13b54c3ece4a	8lWZ9s60EXPWidMi+vyJdYAxfJG2FF2Okf9seYq+ThwuLdoFA9Luq+Bw76bq5yKKMWn58UKjRZnJ+Ke3NnsPfQ==	05ec0f97-1762-4ab8-8f21-f82e9a390a10	2022-11-16 08:33:43.205884+03	2023-05-16 08:33:43.205886+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
549412ed-5f52-46cd-bfd7-c56ba7202284	P/UFS3DmTirZq21mhrZg9+PxX/wBRWn+7aDDtS758yrmDfBhcYUCUjd7MVX+GwIOB8vL0z3yhkHyH8C0Y3lCdg==	097970c0-69dc-4b28-83d9-beb5119b70cb	2022-11-14 18:18:48.928343+03	2023-05-14 18:18:48.928343+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
57aceae2-1624-4835-85c4-de28fa344478	PHfhsAqHKgPgkh8WeY6ukw4+eL0DEqGJIFls2VUIOJJvl7rU8kdQrVyDC4AdeaGJS/Fqi9LkXmMItZ9MK7xN7Q==	ea40b587-45b7-432b-86a0-f074533516e3	2022-11-16 08:47:45.130009+03	2023-05-16 08:47:45.130009+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
0e1ec8a4-4824-4308-9750-cb31b3d4d006	W6qNXGa5ZEKZsMzI76kyF5SzJrLz7i6SBK2lhYqw1e8n7yv3vtc4k0qQeFqv+t9szAGp81hoHINnYi7R8lKbOw==	0988f2e5-d274-4dae-a6cc-018c6b5e1320	2022-11-21 20:36:25.481926+03	2023-05-21 20:36:25.481948+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
943502e8-0140-41c3-a8a5-e3ad732e0b0a	dUmvUc/S72P3TUj/tAmKC+TybYRxwPEcETKvyhjKJFSZ1icE+o/SKeIFiMEWAodTSX0jpdMk3RxIK03Br9DVbQ==	6611db55-4ded-457d-8158-53d8ae53eb0a	2022-11-21 20:37:03.053068+03	2023-05-21 20:37:03.053068+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
38cbd2a1-7d30-4474-9554-e1591b1ddb81	FzLqdrjkw5OOiASsfnyjTOz7wFsFK6qw3Al10wSII/uMPlXDH+onTnnama8B3g6OGihP9ivbWbSgvwmHzbaUtA==	b8109573-d4a3-407c-b2e3-fd4b88c73ad1	2022-11-21 20:37:20.842249+03	2023-05-21 20:37:20.84225+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
2bd6750d-80cb-4e38-9d2d-cf913c852003	qaxqazdTDBqjrqSBT/Mz6Nt6jZCYC7CMnbVQaPGoDJrJhdIQEKlT9uRFmW2iKQasStH+SNt5ivYL+OH6xCoKCw==	5c8f58be-0472-40cc-90ef-4a0b71aa3221	2022-11-21 20:37:42.653542+03	2023-05-21 20:37:42.653542+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ed1ee8b5-cee6-4c08-89f3-240520f1213a	J1LnbVymEiK/TXIT8lU6Fk+CbxxdCIFadV2BO2QtUHExFvPFlcHVAxsCSbci27HQ78iHF84Z0HkBwYv4cRzTDQ==	d685d58e-b937-4c2b-a5ff-407e17522dc8	2022-11-21 20:51:43.254831+03	2023-05-21 20:51:43.254831+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
f256f8bc-9881-40c3-a5b6-acd42c4da825	t58LnJnP45v1aqTLZcQHtFDZvQ8FAluX72crFWgsL70U3XUyVmuw7Mpj669KxU8dyE33Y4t7EUgh1qgxnC8cQg==	3adeb067-0952-464d-8e2a-e271e3033f8c	2022-11-23 12:46:20.976561+03	2023-05-23 12:46:20.976587+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
d19b8f57-1c6e-43c3-aab1-172d7d2bf455	5V6sZnWjJWJ73/lUe0nt6pMQ5baws6kUNnv4cFjw9yc1pJMIrsMun8Rs+E+peyDhYwkzsMsYnBPmvGAdeYCCNg==	fb395a38-adc1-4627-bd55-f33e1e8c4836	2022-11-21 18:49:01.42986+03	2023-05-21 18:49:01.429881+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
52f30983-ad35-4ad1-aee9-f02dc2736021	SBisTGWM/3lLAuGV4ClttdhpcqZa9F2pCO68bI74hNGEaJB3qwVbkILHzXOkoD/PEM5xvCC9pU55DvECJcvzlw==	a0b15e89-5c5c-43d3-a68c-5e1c24d0cd6f	2022-11-23 12:50:00.292608+03	2023-05-23 12:50:00.292608+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
760bcabb-cc8a-45ac-9982-1dfe941aa690	MqM0YOBmjq/0k/6IUW887+dpJH6OFcJ22URSdzabjzPnqj0zKt1iMv00PVtI9hqlKXN9OD6KIIrSlHtPRAF94Q==	c46bcaec-0fa4-41bf-b9a9-84fc0226a0c5	2022-11-23 12:52:28.33129+03	2023-05-23 12:52:28.331291+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
3226b20b-7eac-427a-acd3-7ad5bf479825	eVaj7J8MHJQIboslSnPvJ+4LRHv1qaHfHHjyq4TeurUGcJjX7QhVoDkxmhNjcV3rY5eNXb9ZcG+/7JjOSZlKPw==	8df5652e-7d7b-4c46-981c-7be52bedaffa	2022-11-23 12:59:48.265902+03	2023-05-23 12:59:48.265902+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
50efeaa7-03a2-4977-b535-0a9295ba6f87	YN2vNP3z0eTRgWH20tpdV+wNsWE3k8duFfUG0d4TflUgGFNh2pH7dAtIj+Hv3aY/Dqmc5KvTVilMtyYGhO902w==	08cc1a58-25bb-42dc-840b-d3a0134d3604	2022-11-23 13:00:41.023297+03	2023-05-23 13:00:41.023297+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
68a1e108-2611-416d-a69b-044d76588857	fi86oyg0D+q9I5PEFzErGnmLf5RsRRaz4anIbBmJJnjlOp3xzugIbQQwXV8NsnsYchhMs5/YuG7Mx8WJcw14tw==	7b98df22-ac59-424a-8ea6-3f99648a781c	2022-11-23 13:03:16.71418+03	2023-05-23 13:03:16.71418+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
a17a6785-1d13-472b-857d-e4a3bacef14e	ntwn2xaUY4LLPS+KgAm2jf6orF7t6ZmZ4iQIhPl1VwBjKQVEToUdy2HEUTZ1S5h0ukQENzamyUQMm3URUM0zeA==	ba806848-99a8-4a1a-8d6c-0a10af2a4b17	2022-11-23 14:28:15.099244+03	2023-05-23 14:28:15.099275+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
20606d7b-88d2-470d-85a1-c7cdf526a199	4wCoddG3WUbEh36uXuwQBEpy3wY/asTwRBrXeXo4IGz9shOPz/beSDrnQQ9HrOLhGqeOVSvGeviyt16AzoCvCA==	4e71679b-0801-4031-92c3-35dcf6100f3c	2022-11-23 14:42:15.996545+03	2023-05-23 14:42:15.996546+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
264ccec7-4f04-42a5-9f3d-e0178ae6b2bb	4Mdz9xAPCQgwTL1oG3+Bcso2E5s38dZFQb0paWNTKGrNZi4DRU0PBhRjQvAOldILY+dzioQZZm3+WQc9olphoA==	262da74f-add8-4b63-a9be-9955be859d3e	2022-11-23 14:56:16.430051+03	2023-05-23 14:56:16.430051+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
5ebf5b17-ae2a-423c-98e8-18b769befd0d	ShkPhwkxpEBpN/BJ8tDuHNEKxd6UOg+huQyqXi1NS6KQBtldztdlAej81KMtgF8nGv1LVB8A3MLZQkA5odFpJw==	4def3b2f-cdfb-4188-95b9-44924dce8384	2022-11-23 14:59:28.073745+03	2023-05-23 14:59:28.073748+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
861d53e5-946f-4fa8-bd2c-75c4d9658639	1tfOEDOhmwyu+LGD6krRWYW+t7PoGYiJcFq8dHH6KKyMm2NxUmA2pQ0z4vDCBnJmlgtxVcuYNO3uvPEfR7QbMA==	8e58c1a0-9117-401c-8086-558ad80c7474	2022-11-23 15:13:28.759581+03	2023-05-23 15:13:28.759581+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
96b1d885-bd6f-47ae-94fe-359a3165eb60	W5pjNi5axYW5SIxq4vedqv6ba0YslixDuEwhGRbTsi0ix3IRVReZ6GZ1IKejfBKPqp5coY4A/rzCacuEaPPJLA==	eaaa59a2-0a41-4a93-bd8c-903e4ef9d0e4	2022-11-23 15:27:28.820814+03	2023-05-23 15:27:28.820815+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
2797a346-6a9c-42e2-b53e-981a59a7c3a2	7Li6+Yjsfu5gvPItzMcqCHLNaWdLRJzY9jnNb338jnZXmxa7fqOXkhd64VH5oi65dzAiaOOg0pFt+VNcE3LIoQ==	f2a01c6a-bc62-4537-b06a-10777ccf4084	2022-11-23 15:41:28.786607+03	2023-05-23 15:41:28.786607+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
6b84c93b-8c7a-47bd-8170-4bbe3bc94893	IWplU8mYof/8tjBnCYtdZtBDCUpRxgbfh0LEKFpUSkPcW+ArKTQsZV23VwFxYn4rKVLR1ByBYRLQMIF5HG23/w==	c5a66d23-558f-4990-b847-0271ff2a7a21	2022-11-23 15:45:22.008756+03	2023-05-23 15:45:22.008756+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
625e05f7-e61b-47fe-b0e1-3d7b5ee2880f	pR5HKWuDT8uDz8LKKlFeraBGrL2CCg/9SyhXpN1Lt6jMJp+ehK4bvdzZWtaowzr3hldfa17OKLa2SvEoRmKbgA==	ea63a38a-a770-4e39-a0ae-0d2ac096c0b1	2022-11-23 15:48:43.498688+03	2023-05-23 15:48:43.498688+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
a1d25366-00fe-4ad8-97f5-3ed52dd84d63	gL47Xx/kR2EfgX1vbMO8xQUwwnF/lpP9zN9fhQYQF45alrYmNhKZKyMkoqq7BIUABswXo+0waEn+0iuV0MSzsw==	92bba907-4623-4602-a678-b617b1eec10b	2022-11-24 21:02:35.334666+03	2023-05-24 21:02:35.334743+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
7ea74529-1c26-437b-8ab4-53e11470767e	Su/qtOgmkp5Qyf7itebtco9pjV2EZpgiUqi9HrKbCQEVYUFoyAN0pQqIDZ3ZQNvCSh1rLxeb5KVgPFJ8LY1mZw==	22f6384e-72fc-4bd5-9071-ddc30bf6a223	2022-11-24 21:06:00.527179+03	2023-05-24 21:06:00.527179+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
1d22f989-d3e4-460e-84e6-17ffa880108d	m19Vg9vNh+fhC7+ScCyclVB8nLzYj+el4NQd0ZPn9X+LnZIS34pubQzbahkLJTpBM9sbx9gsAXCpVmp/d4yGMw==	ac82bc23-35be-455c-832c-09d0f1185630	2022-11-24 21:11:57.378135+03	2023-05-24 21:11:57.378137+03	t	e9e8509e-eff5-407e-b8f5-451e20fc158a
d12a25fc-80fb-47c8-b095-0ea63520b1c0	d7QewLcJso/lsVz6Bjpk0f5z4YPpP9pMpdCvsAUNGT/g+YjNJZiL6Tvaux/5lwOJemb2/nM92kN078OZT4Ui0w==	f14aa2bc-589e-44d9-b8c7-121ee222c825	2022-11-24 21:13:06.807591+03	2023-05-24 21:13:06.807591+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
95e68da2-82bb-4d08-bb0b-fb2317284eff	yBzj5B0FpGPOSeOu6QjWeyA27MSQD8l4wJ2SwHL5ZbkS167kJS3bfSt85maf4uX90uxIPJ0XSBhxEEIhXZV51g==	09b1c3f9-c1ba-49d0-be72-1444a56bc2c0	2022-11-24 21:27:06.121056+03	2023-05-24 21:27:06.121056+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b3f9374e-d91c-4ea2-9e15-3f89003d6bdd	+vnaSX1HOznn7YZSLbqF+wL7kVIqHvw97Gq4MPrWI3TLOlB7uBO/InXs2VGa6aq05hJKZTPrz2HxSa801FjNsw==	20fb8d73-5747-4aa2-99be-4ca6aa17aa66	2022-11-24 21:41:06.107607+03	2023-05-24 21:41:06.107607+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
1457707e-061a-44d7-804d-9bbc508e3dca	ocCy/FE4J62GrXcd8Fu7krfP/evIieVBLga9Mv6QdxdVPYONdTPBF7Pe+XMWSZ2QbpVOQcKJiuWOSTasljoCWg==	02bdb1fd-15b0-44ef-bf87-1bc06d156bce	2022-11-24 21:55:06.675059+03	2023-05-24 21:55:06.675059+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
941abfb9-5bba-428e-b1f3-a7e4ed7c0d78	aMuIcJ+I5VHgz4rDx3VYHjrrsVLNHOjhpwaICFihoTh/1EIJTYdfjhfGhSOJ4qJzEWLmY+mPP+BtzqdSp3cFxg==	d2e446da-5ae8-41cd-ae4a-4f7491197ee2	2022-11-24 22:09:08.150721+03	2023-05-24 22:09:08.150721+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
5a75e631-aa3a-4ffc-ab6c-e981e96e0fad	i2QyJfT1sBIuf2XlIvwmqgbolrMw29caW9MMhD0R3pp96All2rSS0IL3fM/Glf9/4XmfEUz8Z5p7KR0AKdINBw==	862ccac7-8def-4d36-9e1d-19597f284c4b	2022-11-24 22:23:09.946468+03	2023-05-24 22:23:09.946468+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
8361f6fd-0bb1-4f7d-9c00-10af9351ca92	wBwLLT+GgLEWJnls5I7Eq0FXRklxM7RjLBHRioqT89CDAGLQ+EOmtTFOQb7Jpi/+4gXei4XUR6FROpzUdGPw6g==	f654f02f-d5c8-48eb-b764-9e2edcb513e8	2022-11-24 22:37:10.723353+03	2023-05-24 22:37:10.723353+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
435795a8-e106-4827-abce-a22b46592144	/uLd/XrOnLBZXMpzGKySK/S2nENpdj2ZvMlNn/s9rt3VsPkM0hhgKmU1qCYT3mGniFwhxnyjhnP9TWgiQoVgjw==	696718c5-db68-4080-8c4a-79584017f2dc	2022-11-24 22:51:11.853061+03	2023-05-24 22:51:11.853061+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
e0ee8829-06b2-4f3f-90c2-e2a41b78fc58	PvhoRqnShmKZRIif1iL27GnGeyJwA1jCjCKltDd/ed83JojMfSeFSWwwa9RVv5Pj+UkVPtPzrzx+wU6BJRWyrw==	f6bf1b89-5902-4590-99be-fd9382200b0d	2022-11-25 14:03:51.61627+03	2023-05-25 14:03:51.616301+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
466e2d42-be67-4fd3-9341-840402bc14c7	X40WhGpDi0DEoIWFGdhDCHEO16jKYrtmWsHXhILKdAY8laxVgdK0zzKPOv0rWz/1ZESaFW8I5xV6c7MPSOK3Rg==	89f15714-8ff6-48aa-82a8-1555b2591c06	2022-11-25 14:05:16.919625+03	2023-05-25 14:05:16.919627+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b2fd06db-c3b3-46c4-8732-1f5614c3caa2	d8jf0TkRIZPbYlUZ8tPARliSAwtZpcyxoSSwLyEsKLmytJzI+RtcFbDra97IJYat08/kJ77Ui4dILWVN1w4u5g==	43bf00ad-fa22-4450-9c59-da4bc71fcbff	2022-11-25 14:29:39.00322+03	2023-05-25 14:29:39.00322+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
bc6ce227-5743-45d4-8276-6f4ba377cc2b	MR1ae5hbbMPI8MnjwShpL5Xu2rCn9y9ySy+azOT6J920mcIkpt9eDEyr3OlGhp+SwfbFNCypSNS3e3imRmjU+g==	7aa91e8c-3f75-4f58-a013-24c8c54542b9	2022-11-25 14:30:22.946213+03	2023-05-25 14:30:22.946213+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
ea78e726-b10d-4a4c-8644-6878f409d0ef	h4glvbdx1RCffpNaRZlvIwTSbbuQBNHO5IkXIzbjFDypSsmUeyjcP8g8zfh+KgMgtC4CD8kGcNkQP75mcQkdug==	fc9d68ff-0ba9-4443-bf71-d4825fe5e938	2022-11-25 14:31:04.207576+03	2023-05-25 14:31:04.207576+03	t	d6cb07a0-30d1-4e56-a42f-98420f438775
09bf39f5-7d9c-4e41-a045-cc15aa731c6f	ud8aNwCABLtZO8zGanKoQIKdVH329MDIgspOzIXJ/AsaGQe79B/zdT0cgx0C1Y3o2Wqpb3KYqVIovVyUSkSmLA==	5878fb46-4151-4224-a49c-e9d7ead87200	2022-11-25 14:31:51.765665+03	2023-05-25 14:31:51.765665+03	f	d6cb07a0-30d1-4e56-a42f-98420f438775
5f9fd853-d749-4971-8f41-a2fd5be33915	7zr+1sHU71pyBKWALTaS3a83VZryzzge73Y3CMZ8/NHzAJHItzNYvtjbWDKVWlrvR4hKyGz5r6QblPRh1r9XGw==	9cb3b20f-90f6-41c1-b65e-87eef64fc3be	2022-11-25 14:19:17.015703+03	2023-05-25 14:19:17.015703+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
ea126795-f413-4a8c-bcf2-07d10df6d166	nMoeBsStytKExZUQ8Oc1B9z8flotiZ3txD3n5H7bh52krxiJpy5/AiOnHnUx5cqqKLqsrNVw4hyIBeEz5WTRYA==	df461ab2-af0e-47a5-8a95-1ffc889180d2	2022-11-25 14:33:17.783459+03	2023-05-25 14:33:17.783459+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
649be58d-ccf3-4e00-a7ef-e0e73a8c8e17	qF0cvnY0vKeS0n3eGCxZcikZVF8EYjZG3CxEis7urAgWRUtpIzYPOiDfjsI+V3kXZJcauwdwlLF9gvhX4C5HRQ==	fe0c18ca-918f-40ff-a069-158fbdbcede8	2022-11-25 14:47:17.962655+03	2023-05-25 14:47:17.962656+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
b280a416-d86c-49bd-a206-fd9de4a74eb8	vbv55+xEjifMlfFpjVT7j/BufziRD/Ce58lyU8jeQnQTiW++ggsBKmbMVbdDIC5zzlWB0jvqPzjbSrNUI5X0gw==	04495a65-ba4c-461f-98d6-4370fbf91af0	2022-11-25 15:01:18.08096+03	2023-05-25 15:01:18.080961+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
056b3c78-fb44-4160-95af-404e6a39915f	3GzddP3M2U29sHAGNxby1R95JNUs/GkfdwXZR5lDNQvUzH7UHlK8+nz9+tBvc3za++ys8q4Ach5xl8fTxt+zrw==	ea5c62c5-0081-4232-98e9-e103fd00320f	2022-11-25 15:15:18.972267+03	2023-05-25 15:15:18.972267+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
3266f72f-0cfa-4619-8bda-fc05a738eb7a	Mubc7uQkqbFnKhtOx4LWZ60MNB0NyznFtPvRaA8eql5jJNkEdpsOeA54lGJcdMlPaq9bEV6eFFdVCCEyza8xcA==	7133dbfb-922f-4eb2-bb81-c5642041a444	2022-11-25 15:29:18.80802+03	2023-05-25 15:29:18.80802+03	t	cdb945a3-3614-4ad1-bd22-70c88f203a23
dc24830c-573b-4953-9ebd-a20530ed43e5	4M9BAtmNjIbBAd5GqM4SI23JvKpSTWSQlXw88E/3SZwT/IEOxFmY+tUaWeVI/M9K15+4U3SYdwcG+ztQaAA1MA==	abad8614-3129-47f5-9f92-564db93ac9a7	2022-11-25 15:43:20.148361+03	2023-05-25 15:43:20.148361+03	f	cdb945a3-3614-4ad1-bd22-70c88f203a23
\.


--
-- Data for Name: Reviewers; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Reviewers" ("Id", "Position", "Name", "Surname", "Patronymic") FROM stdin;
1	sdfdsf	sdfdsf	sdfsdf	sfdfsdf
2	вапвапавп	dsgdfg	вапвап	вапвап
3				
4				
5				
6				
7				
8				
10				
11				
12				
14				
15				
16				
9	Должность	Имя	Фамилия	Отчество
13	начальник управления информационных технологий ОАО «Моготекс»	Александр	Степанов	Игоревич
1000				
1001				
1002				
1003				
1004				
1005				
1006				
\.


--
-- Data for Name: RoleClaims; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."RoleClaims" ("Id", "RoleId", "ClaimType", "ClaimValue") FROM stdin;
\.


--
-- Data for Name: Roles; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Roles" ("Id", "Name", "NormalizedName", "ConcurrencyStamp") FROM stdin;
34c976f6-2278-45d0-872f-16700d169415	EducationDepartmentOfficial	EDUCATIONDEPARTMENTOFFICIAL	ae01db31-b822-4149-843a-37e3cf58e3e2
9d6ebccb-c58f-4848-945c-c937cf4c94e5	Teacher	TEACHER	1972d27a-026f-4770-a018-7490b5e0987f
b0eff966-0eec-4355-a86c-e046b99cbfe9	Admin	ADMIN	369e621c-4573-4d82-a973-62c26c16c0a3
c53c0d88-fe08-4d2a-92a3-8a13a4fb6bdf	SimpleUser	SIMPLEUSER	28e1ceac-dce9-474e-95ae-1e4a8fae6b93
c9c3efa4-c81e-43d1-b8db-e087f2f5c412	DepartmentHead	DEPARTMENTHEAD	8b08a628-6180-4487-8878-15cdccf09ee8
\.


--
-- Data for Name: SemesterDistributions; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."SemesterDistributions" ("DisciplineId", "SemesterId", "KnowledgeCheckType") FROM stdin;
4	1	1
5	1	2
5	2	2
5	3	2
5	4	2
5	5	2
5	6	2
6	5	1
7	4	2
8	1	1
8	2	1
9	2	1
9	3	1
10	1	2
11	4	1
12	3	2
13	3	2
14	2	2
15	2	1
16	5	1
17	1	1
18	1	1
18	2	1
19	3	1
19	4	2
20	5	2
20	6	1
21	3	1
21	4	1
22	4	2
22	5	1
23	4	1
24	3	1
25	2	2
26	3	2
27	6	1
28	6	1
29	8	2
30	7	2
31	1	2
32	6	2
32	7	1
33	6	2
34	5	2
34	6	1
35	3	2
36	6	1
37	2	2
38	1	2
39	7	2
40	8	1
41	7	1
42	2	2
43	5	1
44	6	2
45	4	1
46	4	1
47	5	1
48	5	1
49	7	2
49	8	1
50	7	2
50	8	1
51	7	1
52	7	1
53	1	2
53	2	2
53	3	2
53	4	2
54	1	2
55	2	2
56	2	2
57	7	2
\.


--
-- Data for Name: Semesters; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Semesters" ("Id", "Number", "WeeksNumber", "CourseNumber", "CourseProjectEndWeek", "ExamEndWeek") FROM stdin;
1	1	17	1	17	20
2	2	17	1	17	20
3	3	17	2	17	20
4	4	17	2	17	20
5	5	17	3	17	20
6	6	17	3	17	20
7	7	15	4	15	18
8	8	11	4	11	13
\.


--
-- Data for Name: Specialties; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Specialties" ("Id", "Name", "Code", "ProfileName", "Qualification", "LearningForm", "StudyPeriod", "DepartmentId", "FederalStateEducationalStandardId", "FacultyId") FROM stdin;
1	Информатика и вычислительная техника	09.03.01	Автоматизированные системы обработки информации и управления	Бакалавр	Очная	4	1	1	1
2	Программная инженерия	09.03.04	Разработка программно-информационных систем	Бакалавр	Очная	4	1	2	1
\.


--
-- Data for Name: Teachers; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Teachers" ("Id", "AcademicDegreeId", "AcademicRankId", "PositionId", "DepartmentId", "ApplicationUserId") FROM stdin;
1	\N	\N	3	1	5bb45137-e1cf-4af8-9185-9a543fc86313
2	5	1	4	1	d8af18e3-ee73-4eaa-8f8f-190f51311788
3	1	1	4	2	db30fcda-1e20-40d8-8787-9e398cd8f510
4	4	1	4	1	5f190de6-b306-4ed0-85a4-c347045b9f24
5	4	1	4	1	acb7c30e-5427-4ac5-9298-2834f21a0c16
6	1	1	4	2	4c5ebc66-ff64-42a5-9b55-70d3d15025a7
7	\N	\N	3	1	1a5a5997-04b6-4421-a83e-d6af2b25e398
8	\N	\N	3	1	9d3adee7-e04c-4e34-89c0-28f928817387
9	1	1	4	2	668f8915-227b-491e-b447-177645da1d1c
10	\N	\N	3	1	0710b6e3-dada-4f21-82e1-74708941d688
11	\N	\N	3	2	af2f5deb-bcee-40c5-8529-79d20d410724
12	4	1	4	1	cdaccada-b7c5-4e78-a1af-d020b0f4dff5
13	\N	\N	3	2	302bee3d-47c2-46c4-8c6e-4d393d4a31ec
14	\N	\N	3	1	bececd79-8e59-4088-9ee2-3099d1bdfb30
15	\N	\N	3	2	a016ae35-1383-4869-b77c-2aabd4c400e7
16	\N	\N	3	2	a6c06cb0-b472-458b-b4a7-0c7307f79f0b
17	\N	\N	3	2	7b68c947-508f-4a3f-84d7-f5670e7ada73
18	\N	\N	3	2	0a1851d6-ebbd-4e7e-8bc1-b511f327b7cd
19	2	1	5	1	f78dba26-4403-4636-aca5-bad37ae1a305
20	5	1	4	1	a24bf4f4-7300-48d2-bc6d-4645cf6bd5ba
22	4	1	4	1	32d23769-1843-440d-b672-6c45319c726c
23	4	\N	4	1	5e06bd08-29d5-4b30-b53f-6fff4f9b6f94
24	4	1	4	1	f6b7f5b2-b69c-487d-a673-f1ea14786d93
25	4	1	4	1	c1be45a9-6380-44c2-87a1-f3da1fd4d135
26	4	1	3	1	a8054e34-536a-4ac7-81b1-dcd2ca07259f
27	4	1	6	1	ba2c9a0d-5cc7-411a-9628-1b9418c54741
28	4	1	4	1	cdb945a3-3614-4ad1-bd22-70c88f203a23
1000	\N	\N	3	1	83186dc7-0a00-41ee-84cd-701ac5baddbe
\.


--
-- Data for Name: TrainingCourseForms; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."TrainingCourseForms" ("Id", "Name") FROM stdin;
1	С использованием ЭВМ
2	Деловые игры
3	Дискуссии, беседы
4	Мультимедиа
5	Традиционные
6	Расчетные
\.


--
-- Data for Name: UserClaims; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."UserClaims" ("Id", "UserId", "ClaimType", "ClaimValue") FROM stdin;
\.


--
-- Data for Name: UserRoles; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."UserRoles" ("UserId", "RoleId") FROM stdin;
0710b6e3-dada-4f21-82e1-74708941d688	9d6ebccb-c58f-4848-945c-c937cf4c94e5
0a1851d6-ebbd-4e7e-8bc1-b511f327b7cd	9d6ebccb-c58f-4848-945c-c937cf4c94e5
1a5a5997-04b6-4421-a83e-d6af2b25e398	9d6ebccb-c58f-4848-945c-c937cf4c94e5
302bee3d-47c2-46c4-8c6e-4d393d4a31ec	9d6ebccb-c58f-4848-945c-c937cf4c94e5
32d23769-1843-440d-b672-6c45319c726c	9d6ebccb-c58f-4848-945c-c937cf4c94e5
4c5ebc66-ff64-42a5-9b55-70d3d15025a7	9d6ebccb-c58f-4848-945c-c937cf4c94e5
5bb45137-e1cf-4af8-9185-9a543fc86313	9d6ebccb-c58f-4848-945c-c937cf4c94e5
5e06bd08-29d5-4b30-b53f-6fff4f9b6f94	9d6ebccb-c58f-4848-945c-c937cf4c94e5
5f190de6-b306-4ed0-85a4-c347045b9f24	9d6ebccb-c58f-4848-945c-c937cf4c94e5
668f8915-227b-491e-b447-177645da1d1c	9d6ebccb-c58f-4848-945c-c937cf4c94e5
7b68c947-508f-4a3f-84d7-f5670e7ada73	9d6ebccb-c58f-4848-945c-c937cf4c94e5
9d3adee7-e04c-4e34-89c0-28f928817387	9d6ebccb-c58f-4848-945c-c937cf4c94e5
a016ae35-1383-4869-b77c-2aabd4c400e7	9d6ebccb-c58f-4848-945c-c937cf4c94e5
a24bf4f4-7300-48d2-bc6d-4645cf6bd5ba	9d6ebccb-c58f-4848-945c-c937cf4c94e5
a6c06cb0-b472-458b-b4a7-0c7307f79f0b	9d6ebccb-c58f-4848-945c-c937cf4c94e5
a8054e34-536a-4ac7-81b1-dcd2ca07259f	9d6ebccb-c58f-4848-945c-c937cf4c94e5
acb7c30e-5427-4ac5-9298-2834f21a0c16	9d6ebccb-c58f-4848-945c-c937cf4c94e5
af2f5deb-bcee-40c5-8529-79d20d410724	9d6ebccb-c58f-4848-945c-c937cf4c94e5
bececd79-8e59-4088-9ee2-3099d1bdfb30	9d6ebccb-c58f-4848-945c-c937cf4c94e5
c1be45a9-6380-44c2-87a1-f3da1fd4d135	9d6ebccb-c58f-4848-945c-c937cf4c94e5
cdaccada-b7c5-4e78-a1af-d020b0f4dff5	9d6ebccb-c58f-4848-945c-c937cf4c94e5
d8af18e3-ee73-4eaa-8f8f-190f51311788	9d6ebccb-c58f-4848-945c-c937cf4c94e5
db30fcda-1e20-40d8-8787-9e398cd8f510	9d6ebccb-c58f-4848-945c-c937cf4c94e5
f6b7f5b2-b69c-487d-a673-f1ea14786d93	9d6ebccb-c58f-4848-945c-c937cf4c94e5
f78dba26-4403-4636-aca5-bad37ae1a305	9d6ebccb-c58f-4848-945c-c937cf4c94e5
d6cb07a0-30d1-4e56-a42f-98420f438775	b0eff966-0eec-4355-a86c-e046b99cbfe9
cdb945a3-3614-4ad1-bd22-70c88f203a23	9d6ebccb-c58f-4848-945c-c937cf4c94e5
83186dc7-0a00-41ee-84cd-701ac5baddbe	9d6ebccb-c58f-4848-945c-c937cf4c94e5
ba2c9a0d-5cc7-411a-9628-1b9418c54741	c9c3efa4-c81e-43d1-b8db-e087f2f5c412
e9e8509e-eff5-407e-b8f5-451e20fc158a	c9c3efa4-c81e-43d1-b8db-e087f2f5c412
\.


--
-- Data for Name: Users; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Users" ("Id", "UserName", "NormalizedUserName", "Email", "NormalizedEmail", "EmailConfirmed", "PasswordHash", "SecurityStamp", "ConcurrencyStamp", "PhoneNumber", "Surname", "Patronymic", "IsActive", "DepartmentId") FROM stdin;
32d23769-1843-440d-b672-6c45319c726c	Константин	КОНСТАНТИН	Константин_Овсянников_Валерьевич@email.com	КОНСТАНТИН_ОВСЯННИКОВ_ВАЛЕРЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEJNbReeDSpZ3qIj2AMHtG+1TQNeajEphNOqthQIUIH+5CP3sN5c2SEHvafbqHLBy1w==	QQD2QJPW5L2N22ZNMPR2RDZFDMKBICOK	e03faf95-65a0-4ddc-b3c0-89ec1d39e82b	\N	Овсянников	Валерьевич	t	\N
4c5ebc66-ff64-42a5-9b55-70d3d15025a7	Николай	НИКОЛАЙ	Николай_Драгун_Павлович@email.com	НИКОЛАЙ_ДРАГУН_ПАВЛОВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEIKKoftQrfdJONlkoAV+cS7Sa6eEi1AgXO8tdxmu+CcGC+3e11Brk0YiXKi1GvLI3g==	BNKXNXJXJ5PEWHT4XNO2AAKKGMC5ZNSJ	c4b58840-4803-4eb2-96e8-9f5b7c84dc3d	\N	Драгун	Павлович	t	\N
5e06bd08-29d5-4b30-b53f-6fff4f9b6f94	Татьяна	ТАТЬЯНА	Татьяна_Мрочек_Владимировна@email.com	ТАТЬЯНА_МРОЧЕК_ВЛАДИМИРОВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEF9WnPz4AGtrstPTO+6B30D08XevGAKZnLiAd42Q5oBwiBmQiyDeS/06edQVrYtYcQ==	VZ22XLJX3XDRL2CXGSDG4SXKDNEZ75MN	c0609014-5784-440e-93a5-64991e321c3c	\N	Мрочек	Владимировна	t	\N
5f190de6-b306-4ed0-85a4-c347045b9f24	Эдвард	ЭДВАРД	Эдвард_Ясюкович_Игнатьевич@email.com	ЭДВАРД_ЯСЮКОВИЧ_ИГНАТЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEAV+dd7LErasop9bOHk8sDGzzluEcMAUZpqfCg4+UqPnk7U0XdHBfbTR9hpM1ltSbw==	CNNGANCU5H6TH4VMR6RDIODIY5EEE76Y	0fe98a49-87a6-4760-a992-8801c02ef1eb	\N	Ясюкович	Игнатьевич	t	\N
668f8915-227b-491e-b447-177645da1d1c	Анатолий	АНАТОЛИЙ	Анатолий_Барановский_Григорьевич@email.com	АНАТОЛИЙ_БАРАНОВСКИЙ_ГРИГОРЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEOM3pfyNYcZUHp9aG9Y0XFKTOfoFWrWQb1Tw5B/sVJxA+vIHvz0+TuKIwpOC2jpawQ==	D33FCREZB57Z2PMMFMHFGDU73XPWRJGJ	ed069642-e617-45cc-b33f-e96c808243f1	\N	Барановский	Григорьевич	t	\N
7b68c947-508f-4a3f-84d7-f5670e7ada73	Ольга	ОЛЬГА	Ольга_Пичугова_Анатольевна@email.com	ОЛЬГА_ПИЧУГОВА_АНАТОЛЬЕВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAENbIKyCz/0/EfjWT/sEGnBb5XJtm4P2TdTtSzmywU/Npr9Pf97mtscIWwJGST4Aokg==	IO3BN2NVN3QT56YSPTD2PGGEGCODHHPP	cb3c75e0-f803-4cba-8c04-75fc4397839f	\N	Пичугова	Анатольевна	t	\N
9d3adee7-e04c-4e34-89c0-28f928817387	Юлия	ЮЛИЯ	Юлия_Вайнилович_Викторовна@email.com	ЮЛИЯ_ВАЙНИЛОВИЧ_ВИКТОРОВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAELYryf2uGvTWH7ZzCiURo7K+3l8+bgDjgQauSN2GeXdYqHPD83ps0ixRe/xP2hxcvg==	KGNET7IBISHDYELZSUP6WYQIORRWQGJF	3210e7f4-8ab1-4cbb-b7e8-58accc47af05	\N	Вайнилович	Викторовна	t	\N
a016ae35-1383-4869-b77c-2aabd4c400e7	Ольга	ОЛЬГА	Ольга_Чумаченко_Ивановна@email.com	ОЛЬГА_ЧУМАЧЕНКО_ИВАНОВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEDTwGe3H1jGkqTC32qOgFTHsrIgEcd26lEWzCD9InxZpmvC4Yzeu9HiHUOWW2XaqeA==	RXN7XPK2VMICS7WFE6MQSH4FVC37YUHO	b5527ac1-5ca4-40b0-9c00-c76c8bce0c79	\N	Чумаченко	Ивановна	t	\N
a24bf4f4-7300-48d2-bc6d-4645cf6bd5ba	Федор	ФЕДОР	Федор_Трухачёв_Михайлович@email.com	ФЕДОР_ТРУХАЧЁВ_МИХАЙЛОВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEHa/4LDPzrjwZFXo1USzf2kV21EAKRUM19GFfMtsU11N+cTJ/XiXGgzKH9f5ik1Q==	HJIQWU35R4MA33QXX67O6IX35544PBHU	88eb8a45-7275-4ec6-a018-d1e0a5a1ba95	\N	Трухачёв	Михайлович	t	\N
a6c06cb0-b472-458b-b4a7-0c7307f79f0b	Людмила	ЛЮДМИЛА	Людмила_Пушкина_Ивановна@email.com	ЛЮДМИЛА_ПУШКИНА_ИВАНОВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEFrYqEXg2zaszjhF3nFnaZxhsBEC+6A9ug3bALxXAE2WnjR/HYH3Mdc/6bA2MHe/cw==	6J2X2IZYNDAG4WSJYDBXPUC45WVMRKCV	534716b9-bd2b-4107-b335-24b70c010637	\N	Пушкина	Ивановна	t	\N
a8054e34-536a-4ac7-81b1-dcd2ca07259f	Антон	АНТОН	Антон_Мисник_Евгеньевич@email.com	АНТОН_МИСНИК_ЕВГЕНЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEICSV8lh9yNRVa5RZ+lQfduNanBoQ49hw1hHlWxFtT2NVbKJZMdbld/4TXC29d09JQ==	MMAFXJEMCL4YWGTD6NHOWOHB5M7CGX7C	8fb9ef23-796f-4d4b-9bac-026228e2736d	\N	Мисник	Евгеньевич	t	\N
af2f5deb-bcee-40c5-8529-79d20d410724	Ольга	ОЛЬГА	Ольга_Боровикова_Валерьевна@email.com	ОЛЬГА_БОРОВИКОВА_ВАЛЕРЬЕВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEBpE8w5q9oaBcnuxm9t94jgeTl+y0rD9l15baXrwiJstKT61H+MRF+IkZeFUDdvw==	JJAXXFBWTD5ZTN36TSIGQYWF6BLL5DVB	a2f96efa-57a7-45db-898a-3c57bb8c7a48	\N	Боровикова	Валерьевна	t	\N
acb7c30e-5427-4ac5-9298-2834f21a0c16	Константин	КОНСТАНТИН	Константин_Захарченков_Васильевич@email.com	КОНСТАНТИН_ЗАХАРЧЕНКОВ_ВАСИЛЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEHqf+Vyzy+fAAhJx8CL3LZDTqQNw8Mu46IkF1RC1BRjKd6XILhweqGtgcBCeOSHsQg==	UGSKIQABI35SWVF7SRQ766GA3XZGWQAV	dbb39c9a-744c-4c69-be9e-e96a9d4b9735	\N	Захарченков	Васильевич	t	\N
ba2c9a0d-5cc7-411a-9628-1b9418c54741	Виктор	ВИКТОР	Виктор_Кутузов_Владимирович@email.com	ВИКТОР_КУТУЗОВ_ВЛАДИМИРОВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEFc6fvKY6gB8CmJfNEORVQSgs5z1JdEesJEwfdUBS8qXEqjWx7lPK0f3GZd7cAtfZw==	RW74GROJMOGPL6AXVXBFKRXEZGBVAL3X	167d4356-d452-465a-9d75-199b44e11b8d	\N	Кутузов	Владимирович	t	1
e9e8509e-eff5-407e-b8f5-451e20fc158a	Заведующий	ЗАВЕДУЮЩИЙ	head@head.com	HEAD@HEAD.COM	f	AQAAAAEAACcQAAAAEPVFRYgeSOF9fwYuYOZ2wLq+M+NzBi+jvQxSA3FFNpODsgdaekYyfdm4Y4OeRwkq3Q==	T65VSLQ6YEJCFAVGTHRSPOICXBYDWBR7	e8990585-75d5-4ade-867f-e7f759c898e5	\N	Заведующий	Заведующий	t	1
83186dc7-0a00-41ee-84cd-701ac5baddbe	Василий	ВАСИЛИЙ	Василий_Прудников_Михайлович@test.com	ВАСИЛИЙ_ПРУДНИКОВ_МИХАЙЛОВИЧ@TEST.COM	f	AQAAAAEAACcQAAAAEGPOy5+AJLiSjrmEjKY4ApY8tyjzNaAAf1HooPA8Nyj4hiniYdTo5r5PVCfxRRIG6w==	YPIRCTMR6Q2GU45ANQLRO5HOROJC5W6J	1774c683-1be2-415f-97a7-18fd121aa25b	\N	Прудников	Михайлович	t	\N
cdb945a3-3614-4ad1-bd22-70c88f203a23	Тест	ТЕСТ	test@test.com	TEST@TEST.COM	f	AQAAAAEAACcQAAAAEKxNN/mkZTpIwrxXSx3kSgvgRRYXdIGujt803HR/NTFJWvHNoO9YASqE/5k90zd8Pw==	6MPYKKKBWW6VXHVCE6GXKEA5JB3E3HLJ	751cdd1f-d0bd-43d7-9eb4-e93a4c345e40	\N	Тест	Тестович	t	\N
0710b6e3-dada-4f21-82e1-74708941d688	Наталья	НАТАЛЬЯ	Наталья_Выговская_Владимировна@email.com	НАТАЛЬЯ_ВЫГОВСКАЯ_ВЛАДИМИРОВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEDHRLupmcEhNPKCVoBrpwcAP0i7kWwEBDARCNEEw30eBcd1KnF6R2nmCWwE2OBCQ==	UCHIFQUOZ67FJMF7V33UNR7YIUI6352X	ee9cc4d3-c96f-47be-b769-1eeb0d056ef6	\N	Выговская	Владимировна	t	\N
bececd79-8e59-4088-9ee2-3099d1bdfb30	Елена	ЕЛЕНА	Елена_Зайченко_Аркадьевна@email.com	ЕЛЕНА_ЗАЙЧЕНКО_АРКАДЬЕВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEGdzkAVksaKLkSvXgVAykccUx3DZdbCaKw8V4F9LOUoPVm/+lJud7wI81KB8ZNbt6g==	YVNRON7IS2MI3ERVIALEJXP26YSF4HKV	250ddccf-7517-4a5c-8852-eb684a979d73	\N	Зайченко	Аркадьевна	t	\N
c1be45a9-6380-44c2-87a1-f3da1fd4d135	Сергей	СЕРГЕЙ	Сергей_Крутолевич_Константинович@email.com	СЕРГЕЙ_КРУТОЛЕВИЧ_КОНСТАНТИНОВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEJNYAE7KWreR7J/D4+rKlsrV6MOrI0jOXL6ptw2MLik5R3lk2zbBwCiZyphV6qeRwA==	WHSN3MRYML6WSQV4SJ56M46RWO7TVIST	a56d2e60-f944-4d7b-8b95-0a9778c31122	\N	Крутолевич	Константинович	t	\N
cdaccada-b7c5-4e78-a1af-d020b0f4dff5	Николай	НИКОЛАЙ	Николай_Горбатенко_Николаевич@email.com	НИКОЛАЙ_ГОРБАТЕНКО_НИКОЛАЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEA0xy4I/QB1++975osp8GU2VtFhYpwl9/BGcNtkLjidtoQrH15JgpGE2IivJhBbX1A==	GB6OKYUJ2MN52LQHCLYVD6HHEGFWEJKE	392c8044-b44d-4738-8aa4-1b005c61f017	\N	Горбатенко	Николаевич	t	\N
d6cb07a0-30d1-4e56-a42f-98420f438775	Админ	АДМИН	admin@admin.com	ADMIN@ADMIN.COM	f	AQAAAAEAACcQAAAAEEvw7YTtwAY/2ty5XlnxODBDrb9/SdQuatWHjmpt+QWanuGV/yVgpcfiLbS6je0Bkg==	PKV7VXIRDHDZXY3HRGUZYIYWJPMVHPK6	bee7cd2a-1cb6-4002-b36e-e9937a4b723c	\N	Админ	Админович	t	\N
d8af18e3-ee73-4eaa-8f8f-190f51311788	Юрий	ЮРИЙ	Юрий_Столяров_Дмитриевич@email.com	ЮРИЙ_СТОЛЯРОВ_ДМИТРИЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEEibNZKavTqk92Ij3HgSokAxCJyw9v7pdQq7ZkpkNiliomEXPd0DUxdcv4S1zL0/jQ==	LXAZGXZ2VM7KN6A62I2EPM5GAPC4V4L4	64931fbf-6870-4678-b9c2-29598d71be88	\N	Столяров	Дмитриевич	t	\N
db30fcda-1e20-40d8-8787-9e398cd8f510	Дмитрий	ДМИТРИЙ	Дмитрий_Степаненко_Михайлович@email.com	ДМИТРИЙ_СТЕПАНЕНКО_МИХАЙЛОВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEEoJdfGqkxMg3GCXdlc0MUkI6OKwv+IH1ciDNTx96whOlXXUFkdDNtIc8i5mEdWUNA==	CNLAVEMFKO2J5UUEJ2CLTKNFWLJFMUED	75110ec7-ca37-4dc4-8aa5-919db7c82c31	\N	Степаненко	Михайлович	t	\N
f6b7f5b2-b69c-487d-a673-f1ea14786d93	Андрей	АНДРЕЙ	Андрей_Кушнер_Валерьевич@email.com	АНДРЕЙ_КУШНЕР_ВАЛЕРЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAENPdwaocs3S9tSRjLw83xQ5GlU80fmSgqlUnY3B/HkoLb2yDvpFErz2P+JoTrSCinA==	QTHZ32I5UJRUR2XEITTNXAQRJPN5V4NA	e1877f78-b856-438d-aab8-8e08d4280f58	\N	Кушнер	Валерьевич	t	\N
f78dba26-4403-4636-aca5-bad37ae1a305	Александр	АЛЕКСАНДР	Александр_Хомченко_Васильевич@email.com	АЛЕКСАНДР_ХОМЧЕНКО_ВАСИЛЬЕВИЧ@EMAIL.COM	f	AQAAAAEAACcQAAAAEP+bTh0OfoH09aEf4IXJ0eBwZgqdV4Cb5Y+C3Gk4p73h7xf7BrjDpKztCKgJFnZVGQ==	5NXBQ6HFHHQPLQXDGTBEEZQPEDB4FGV3	f4a0e973-9b63-43be-9f94-6c15f4b46de6	\N	Хомченко	Васильевич	t	\N
5bb45137-e1cf-4af8-9185-9a543fc86313	Александра	АЛЕКСАНДРА	Александра_Сидоренко_Сергеевна@email.com	АЛЕКСАНДРА_СИДОРЕНКО_СЕРГЕЕВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEBcalUbCQqwHZ56XnrjTrtADsG9a+oEoZ0KEJN5J3hrizWR7iWvW22Utcin7yvHU+Q==	VQ5WTOPHLOBYGG7YMCQ2VMHPD5EK5C2E	59fd780f-868f-4648-9656-53bf044c62b6	\N	Сидоренко	Сергеевна	t	\N
0a1851d6-ebbd-4e7e-8bc1-b511f327b7cd	Наталья	НАТАЛЬЯ	Наталья_Пекерт_Александровна@email.com	НАТАЛЬЯ_ПЕКЕРТ_АЛЕКСАНДРОВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEPgb9cVRw/ZAIkjcvx1EcYocEXs7Ug7PtDSGGasUVZmmdxIWcxbuIFziFOduh8lMzw==	5JRFBFZ7G644EFET46SR3WQBKG4HCBOV	44c77a99-a487-4287-ae5e-b5f013cd4c8e	\N	Пекерт	Александровна	t	\N
1a5a5997-04b6-4421-a83e-d6af2b25e398	Ольга	ОЛЬГА	Ольга_Сергиенко_Валерьевна@email.com	ОЛЬГА_СЕРГИЕНКО_ВАЛЕРЬЕВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEEpbcc4uPgUuJtYPcgc8OCOZubNwSPzwdJ4/Q/kKaJvHsSMRper/cUr4S1vnufzG5g==	MDCAZ2RF7UBWOV6QY4IOGZ5JQ2KRVS	40ae4e2c-40e7-4919-9e5d-b619e52ecee3	\N	Сергиенко	Валерьевна	t	\N
302bee3d-47c2-46c4-8c6e-4d393d4a31ec	Елена	ЕЛЕНА	Елена_Галкина_Геннадьевна@email.com	ЕЛЕНА_ГАЛКИНА_ГЕННАДЬЕВНА@EMAIL.COM	f	AQAAAAEAACcQAAAAEMihNWRpE6jdNOEENzkv9cqV++/23g3n9bBbxBTj4W3ENytdnIQk2RRzjmDdsTd/ow==	NLLQ3QP54VFAP2DYSMZEG25FSB2IIJFX	7645fa21-043f-4998-b12b-fc42dabfe16e	\N	Галкина	Геннадьевна	t	\N
\.


--
-- Data for Name: Weeks; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."Weeks" ("Id", "Number", "IndependentWorkHours", "TrainingModuleNumber", "SemesterId", "EducationalProgramId") FROM stdin;
1068	10	0	2	4	1003
1069	15	0	2	4	1003
1070	14	0	2	4	1003
1071	13	0	2	4	1003
1072	12	0	2	4	1003
1073	11	0	2	4	1003
1074	9	0	2	4	1003
1075	4	0	1	4	1003
1076	7	0	1	4	1003
1077	6	0	1	4	1003
1078	5	0	1	4	1003
1079	16	0	2	4	1003
1080	3	0	1	4	1003
1081	2	0	1	4	1003
1082	1	0	1	4	1003
1083	8	0	1	4	1003
1084	17	0	2	4	1003
1085	15	0	2	5	1004
1086	14	0	2	5	1004
1087	13	0	2	5	1004
1088	12	0	2	5	1004
1089	11	0	2	5	1004
1090	10	0	2	5	1004
1091	9	0	2	5	1004
1092	1	0	1	5	1004
1093	7	0	1	5	1004
1094	6	0	1	5	1004
1095	5	0	1	5	1004
1096	4	0	1	5	1004
1097	3	0	1	5	1004
1098	2	0	1	5	1004
1099	16	0	2	5	1004
1100	8	0	1	5	1004
1101	17	0	2	5	1004
1102	2	0	1	2	1005
1103	3	0	1	2	1005
1104	4	0	1	2	1005
1105	5	0	1	2	1005
1106	6	0	1	2	1005
1107	7	0	1	2	1005
1108	8	0	1	2	1005
1109	15	0	2	2	1005
1110	10	0	2	2	1005
1111	11	0	2	2	1005
1112	12	0	2	2	1005
1113	13	0	2	2	1005
1114	14	0	2	2	1005
1115	1	0	1	2	1005
1116	9	0	2	2	1005
1117	17	0	2	1	1005
1118	10	0	2	1	1005
1119	15	0	2	1	1005
1121	2	0	1	1	1005
1122	3	0	1	1	1005
1123	4	0	1	1	1005
1124	5	0	1	1	1005
1125	6	0	1	1	1005
1126	16	0	2	1	1005
1127	7	0	1	1	1005
1128	9	0	2	1	1005
1129	16	0	2	2	1005
1130	11	0	2	1	1005
1131	12	0	2	1	1005
1132	13	0	2	1	1005
1133	14	0	2	1	1005
1134	8	0	1	1	1005
1135	17	0	2	2	1005
1120	1	2	1	1	1005
1136	10	0	2	5	1006
1137	15	0	2	5	1006
1138	14	0	2	5	1006
1139	13	0	2	5	1006
1140	12	0	2	5	1006
1141	11	0	2	5	1006
1142	9	0	2	5	1006
1143	3	0	1	5	1006
1144	7	0	1	5	1006
1145	6	0	1	5	1006
1146	5	0	1	5	1006
1147	4	0	1	5	1006
1148	16	0	2	5	1006
1149	2	0	1	5	1006
1150	1	0	1	5	1006
1151	8	0	1	5	1006
1152	17	0	2	5	1006
\.


--
-- Data for Name: __EFMigrationsHistory; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo."__EFMigrationsHistory" ("MigrationId", "ProductVersion") FROM stdin;
20220207204614_InitCreate	5.0.13
20220207224610_UpdateLesson	5.0.13
20220208090146_UpdateKnoladgeControlForm	5.0.13
20220210155946_AddEvaluationToolTable	5.0.13
20220213093707_AddLiteratureTypeInfosTable	5.0.13
20220217162110_AddDepartmentIdIntoDepartmentHead	5.0.13
20220217162358_AddEducationalProgramIdIntoDiscipline	5.0.13
20220217171458_UpdateKey	5.0.13
20220221144339_SomeChangesForCurriculum	5.0.13
20220221145950_AddedSpecialtyIdToCurriculum	5.0.13
20220307205343_AddedSemesterDistribution	5.0.13
20220307205854_AddedInformationBlockContent	5.0.13
20220313160544_AddedShortName	5.0.13
20220322194556_AddAudiences	5.0.13
20220322195002_UpdateAudiences	5.0.13
20220322203740_AddFaculty	5.0.13
20220322204019_AddFKForFaculty	5.0.13
\.


--
-- Data for Name: sysdiagrams; Type: TABLE DATA; Schema: dbo; Owner: -
--

COPY dbo.sysdiagrams (name, principal_id, diagram_id, version, definition) FROM stdin;
\.


--
-- Name: AcademicDegrees_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."AcademicDegrees_Id_seq"', 1000, false);


--
-- Name: AcademicRanks_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."AcademicRanks_Id_seq"', 1000, false);


--
-- Name: AspNetRoleClaims_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."AspNetRoleClaims_Id_seq"', 1, false);


--
-- Name: AspNetUserClaims_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."AspNetUserClaims_Id_seq"', 1000, true);


--
-- Name: Audiences_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Audiences_Id_seq"', 1000, false);


--
-- Name: CompetenceFormationLevels_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."CompetenceFormationLevels_Id_seq"', 1017, true);


--
-- Name: Competences_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Competences_Id_seq"', 2016, true);


--
-- Name: Curriculums_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Curriculums_Id_seq"', 1000, false);


--
-- Name: DepartmentHeads_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."DepartmentHeads_Id_seq"', 1000, false);


--
-- Name: Departments_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Departments_Id_seq"', 1000, false);


--
-- Name: Disciplines_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Disciplines_Id_seq"', 1000, false);


--
-- Name: EducationalPrograms_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."EducationalPrograms_Id_seq"', 1006, true);


--
-- Name: EvaluationToolTypes_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."EvaluationToolTypes_Id_seq"', 1000, false);


--
-- Name: Faculties_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Faculties_Id_seq"', 1000, false);


--
-- Name: FederalStateEducationalStandards_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."FederalStateEducationalStandards_Id_seq"', 1000, false);


--
-- Name: Indicators_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Indicators_Id_seq"', 2031, true);


--
-- Name: InformationBlocks_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."InformationBlocks_Id_seq"', 1000, false);


--
-- Name: InformationTemplates_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."InformationTemplates_Id_seq"', 1000, false);


--
-- Name: Inspectors_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Inspectors_Id_seq"', 1000, false);


--
-- Name: KnowledgeControlForms_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."KnowledgeControlForms_Id_seq"', 1000, true);


--
-- Name: Lessons_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Lessons_Id_seq"', 145, true);


--
-- Name: Literatures_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Literatures_Id_seq"', 1011, true);


--
-- Name: MethodicalRecommendations_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."MethodicalRecommendations_Id_seq"', 1002, true);


--
-- Name: Positions_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Positions_Id_seq"', 1000, false);


--
-- Name: Protocols_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Protocols_Id_seq"', 1000, false);


--
-- Name: Reviewers_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Reviewers_Id_seq"', 1006, true);


--
-- Name: Semesters_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Semesters_Id_seq"', 1000, false);


--
-- Name: Specialties_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Specialties_Id_seq"', 1000, false);


--
-- Name: Teachers_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Teachers_Id_seq"', 1000, true);


--
-- Name: TrainingCourseForms_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."TrainingCourseForms_Id_seq"', 1000, false);


--
-- Name: Weeks_Id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo."Weeks_Id_seq"', 1152, true);


--
-- Name: academicdegrees_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.academicdegrees_id_seq', 1, false);


--
-- Name: academicranks_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.academicranks_id_seq', 1, false);


--
-- Name: aspnetroleclaims_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.aspnetroleclaims_id_seq', 1, false);


--
-- Name: aspnetuserclaims_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.aspnetuserclaims_id_seq', 1, false);


--
-- Name: audiences_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.audiences_id_seq', 1, false);


--
-- Name: competenceformationlevels_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.competenceformationlevels_id_seq', 1, false);


--
-- Name: competences_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.competences_id_seq', 1, false);


--
-- Name: curriculums_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.curriculums_id_seq', 1, false);


--
-- Name: departmentheads_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.departmentheads_id_seq', 1, false);


--
-- Name: departments_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.departments_id_seq', 1, false);


--
-- Name: disciplines_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.disciplines_id_seq', 1, false);


--
-- Name: educationalprograms_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.educationalprograms_id_seq', 1, false);


--
-- Name: evaluationtooltypes_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.evaluationtooltypes_id_seq', 1, false);


--
-- Name: faculties_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.faculties_id_seq', 1, false);


--
-- Name: federalstateeducationalstandards_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.federalstateeducationalstandards_id_seq', 1, false);


--
-- Name: indicators_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.indicators_id_seq', 1, false);


--
-- Name: informationblocks_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.informationblocks_id_seq', 1, false);


--
-- Name: informationtemplates_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.informationtemplates_id_seq', 1, false);


--
-- Name: inspectors_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.inspectors_id_seq', 1, false);


--
-- Name: knowledgecontrolforms_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.knowledgecontrolforms_id_seq', 1, false);


--
-- Name: lessons_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.lessons_id_seq', 1, false);


--
-- Name: literatures_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.literatures_id_seq', 1, false);


--
-- Name: methodicalrecommendations_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.methodicalrecommendations_id_seq', 1, false);


--
-- Name: positions_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.positions_id_seq', 1, false);


--
-- Name: protocols_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.protocols_id_seq', 1, false);


--
-- Name: reviewers_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.reviewers_id_seq', 1, false);


--
-- Name: semesters_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.semesters_id_seq', 1, false);


--
-- Name: specialties_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.specialties_id_seq', 1, false);


--
-- Name: sysdiagrams_diagram_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.sysdiagrams_diagram_id_seq', 1, false);


--
-- Name: teachers_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.teachers_id_seq', 1, false);


--
-- Name: trainingcourseforms_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.trainingcourseforms_id_seq', 1, false);


--
-- Name: weeks_id_seq; Type: SEQUENCE SET; Schema: dbo; Owner: -
--

SELECT pg_catalog.setval('dbo.weeks_id_seq', 1, false);


--
-- Name: EvaluationTools EvaluationTools_pkey; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EvaluationTools"
    ADD CONSTRAINT "EvaluationTools_pkey" PRIMARY KEY ("EducationalProgramId", "EvaluationToolTypeId");


--
-- Name: __EFMigrationsHistory pk___efmigrationshistory; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."__EFMigrationsHistory"
    ADD CONSTRAINT pk___efmigrationshistory PRIMARY KEY ("MigrationId");


--
-- Name: AcademicDegrees pk_academicdegrees; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."AcademicDegrees"
    ADD CONSTRAINT pk_academicdegrees PRIMARY KEY ("Id");


--
-- Name: AcademicRanks pk_academicranks; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."AcademicRanks"
    ADD CONSTRAINT pk_academicranks PRIMARY KEY ("Id");


--
-- Name: RoleClaims pk_aspnetroleclaims; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."RoleClaims"
    ADD CONSTRAINT pk_aspnetroleclaims PRIMARY KEY ("Id");


--
-- Name: Roles pk_aspnetroles; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Roles"
    ADD CONSTRAINT pk_aspnetroles PRIMARY KEY ("Id");


--
-- Name: UserClaims pk_aspnetuserclaims; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."UserClaims"
    ADD CONSTRAINT pk_aspnetuserclaims PRIMARY KEY ("Id");


--
-- Name: UserRoles pk_aspnetuserroles; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."UserRoles"
    ADD CONSTRAINT pk_aspnetuserroles PRIMARY KEY ("UserId", "RoleId");


--
-- Name: Users pk_aspnetusers; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Users"
    ADD CONSTRAINT pk_aspnetusers PRIMARY KEY ("Id");


--
-- Name: AudienceEducationalProgram pk_audienceeducationalprogram; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."AudienceEducationalProgram"
    ADD CONSTRAINT pk_audienceeducationalprogram PRIMARY KEY ("AudiencesId", "EducationalProgramsId");


--
-- Name: Audiences pk_audiences; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Audiences"
    ADD CONSTRAINT pk_audiences PRIMARY KEY ("Id");


--
-- Name: CompetenceFormationLevelEvaluationToolType pk_competenceformationlevelevaluationtooltype; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceFormationLevelEvaluationToolType"
    ADD CONSTRAINT pk_competenceformationlevelevaluationtooltype PRIMARY KEY ("CompetenceFormationLevelsId", "EvaluationToolTypesId");


--
-- Name: CompetenceFormationLevels pk_competenceformationlevels; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceFormationLevels"
    ADD CONSTRAINT pk_competenceformationlevels PRIMARY KEY ("Id");


--
-- Name: CompetenceLesson pk_competencelesson; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceLesson"
    ADD CONSTRAINT pk_competencelesson PRIMARY KEY ("CompetencesId", "LessonsId");


--
-- Name: Competences pk_competences; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Competences"
    ADD CONSTRAINT pk_competences PRIMARY KEY ("Id");


--
-- Name: Curriculums pk_curriculums; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Curriculums"
    ADD CONSTRAINT pk_curriculums PRIMARY KEY ("Id");


--
-- Name: DepartmentHeads pk_departmentheads; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DepartmentHeads"
    ADD CONSTRAINT pk_departmentheads PRIMARY KEY ("Id");


--
-- Name: Departments pk_departments; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT pk_departments PRIMARY KEY ("Id");


--
-- Name: DisciplineIndicator pk_disciplineindicator; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DisciplineIndicator"
    ADD CONSTRAINT pk_disciplineindicator PRIMARY KEY ("DisciplinesId", "IndicatorsId");


--
-- Name: Disciplines pk_disciplines; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Disciplines"
    ADD CONSTRAINT pk_disciplines PRIMARY KEY ("Id");


--
-- Name: DisciplineTeacher pk_disciplineteacher; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DisciplineTeacher"
    ADD CONSTRAINT pk_disciplineteacher PRIMARY KEY ("DisciplinesId", "TeachersId");


--
-- Name: EducationalProgramInspector pk_educationalprograminspector; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramInspector"
    ADD CONSTRAINT pk_educationalprograminspector PRIMARY KEY ("EducationalProgramsId", "InspectorsId");


--
-- Name: EducationalProgramKnowledgeControlForm pk_educationalprogramknowledgecontrolform; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramKnowledgeControlForm"
    ADD CONSTRAINT pk_educationalprogramknowledgecontrolform PRIMARY KEY ("EducationalProgramsId", "KnowledgeControlFormsId");


--
-- Name: EducationalProgramMethodicalRecommendation pk_educationalprogrammethodicalrecommendation; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramMethodicalRecommendation"
    ADD CONSTRAINT pk_educationalprogrammethodicalrecommendation PRIMARY KEY ("EducationalProgramsId", "MethodicalRecommendationsId");


--
-- Name: EducationalProgramProtocol pk_educationalprogramprotocol; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramProtocol"
    ADD CONSTRAINT pk_educationalprogramprotocol PRIMARY KEY ("EducationalProgramsId", "ProtocolsId");


--
-- Name: EducationalPrograms pk_educationalprograms; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalPrograms"
    ADD CONSTRAINT pk_educationalprograms PRIMARY KEY ("Id");


--
-- Name: EducationalProgramTrainingCourseForm pk_educationalprogramtrainingcourseform; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramTrainingCourseForm"
    ADD CONSTRAINT pk_educationalprogramtrainingcourseform PRIMARY KEY ("EducationalProgramsId", "TrainingCourseFormsId");


--
-- Name: EvaluationToolTypes pk_evaluationtooltypes; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EvaluationToolTypes"
    ADD CONSTRAINT pk_evaluationtooltypes PRIMARY KEY ("Id");


--
-- Name: Faculties pk_faculties; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Faculties"
    ADD CONSTRAINT pk_faculties PRIMARY KEY ("Id");


--
-- Name: FederalStateEducationalStandards pk_federalstateeducationalstandards; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."FederalStateEducationalStandards"
    ADD CONSTRAINT pk_federalstateeducationalstandards PRIMARY KEY ("Id");


--
-- Name: Indicators pk_indicators; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Indicators"
    ADD CONSTRAINT pk_indicators PRIMARY KEY ("Id");


--
-- Name: InformationBlockContents pk_informationblockcontents; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."InformationBlockContents"
    ADD CONSTRAINT pk_informationblockcontents PRIMARY KEY ("EducationalProgramId", "InformationBlockId");


--
-- Name: InformationBlocks pk_informationblocks; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."InformationBlocks"
    ADD CONSTRAINT pk_informationblocks PRIMARY KEY ("Id");


--
-- Name: InformationTemplates pk_informationtemplates; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."InformationTemplates"
    ADD CONSTRAINT pk_informationtemplates PRIMARY KEY ("Id");


--
-- Name: Inspectors pk_inspectors; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Inspectors"
    ADD CONSTRAINT pk_inspectors PRIMARY KEY ("Id");


--
-- Name: KnowledgeAssessment pk_knowledgeassessment; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."KnowledgeAssessment"
    ADD CONSTRAINT pk_knowledgeassessment PRIMARY KEY ("KnowledgeControlFormId", "WeekId");


--
-- Name: KnowledgeControlForms pk_knowledgecontrolforms; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."KnowledgeControlForms"
    ADD CONSTRAINT pk_knowledgecontrolforms PRIMARY KEY ("Id");


--
-- Name: Lessons pk_lessons; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Lessons"
    ADD CONSTRAINT pk_lessons PRIMARY KEY ("Id");


--
-- Name: LessonWeek pk_lessonweek; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."LessonWeek"
    ADD CONSTRAINT pk_lessonweek PRIMARY KEY ("LessonsId", "WeeksId");


--
-- Name: Literatures pk_literatures; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Literatures"
    ADD CONSTRAINT pk_literatures PRIMARY KEY ("Id");


--
-- Name: LiteratureTypeInfos pk_literaturetypeinfos; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."LiteratureTypeInfos"
    ADD CONSTRAINT pk_literaturetypeinfos PRIMARY KEY ("EducationalProgramId", "LiteratureId");


--
-- Name: MethodicalRecommendations pk_methodicalrecommendations; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."MethodicalRecommendations"
    ADD CONSTRAINT pk_methodicalrecommendations PRIMARY KEY ("Id");


--
-- Name: Positions pk_positions; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Positions"
    ADD CONSTRAINT pk_positions PRIMARY KEY ("Id");


--
-- Name: Protocols pk_protocols; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Protocols"
    ADD CONSTRAINT pk_protocols PRIMARY KEY ("Id");


--
-- Name: RefreshTokens pk_refreshtokens; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."RefreshTokens"
    ADD CONSTRAINT pk_refreshtokens PRIMARY KEY ("Id");


--
-- Name: Reviewers pk_reviewers; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Reviewers"
    ADD CONSTRAINT pk_reviewers PRIMARY KEY ("Id");


--
-- Name: SemesterDistributions pk_semesterdistributions; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."SemesterDistributions"
    ADD CONSTRAINT pk_semesterdistributions PRIMARY KEY ("DisciplineId", "SemesterId");


--
-- Name: Semesters pk_semesters; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Semesters"
    ADD CONSTRAINT pk_semesters PRIMARY KEY ("Id");


--
-- Name: Specialties pk_specialties; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Specialties"
    ADD CONSTRAINT pk_specialties PRIMARY KEY ("Id");


--
-- Name: Teachers pk_teachers; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Teachers"
    ADD CONSTRAINT pk_teachers PRIMARY KEY ("Id");


--
-- Name: TrainingCourseForms pk_trainingcourseforms; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."TrainingCourseForms"
    ADD CONSTRAINT pk_trainingcourseforms PRIMARY KEY ("Id");


--
-- Name: Weeks pk_weeks; Type: CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Weeks"
    ADD CONSTRAINT pk_weeks PRIMARY KEY ("Id");


--
-- Name: IX_Users_DepartmentId; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX "IX_Users_DepartmentId" ON dbo."Users" USING btree ("DepartmentId");


--
-- Name: idx_emailindex; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_emailindex ON dbo."Users" USING btree ("NormalizedEmail");


--
-- Name: idx_ix_aspnetroleclaims_roleid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_aspnetroleclaims_roleid ON dbo."RoleClaims" USING btree ("RoleId");


--
-- Name: idx_ix_aspnetuserclaims_userid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_aspnetuserclaims_userid ON dbo."UserClaims" USING btree ("UserId");


--
-- Name: idx_ix_aspnetuserroles_roleid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_aspnetuserroles_roleid ON dbo."UserRoles" USING btree ("RoleId");


--
-- Name: idx_ix_audienceeducationalprogram_educationalprogramsid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_audienceeducationalprogram_educationalprogramsid ON dbo."AudienceEducationalProgram" USING btree ("EducationalProgramsId");


--
-- Name: idx_ix_competenceformationlevelevaluationtooltype_evaluationtoo; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_competenceformationlevelevaluationtooltype_evaluationtoo ON dbo."CompetenceFormationLevelEvaluationToolType" USING btree ("EvaluationToolTypesId");


--
-- Name: idx_ix_competenceformationlevels_educationalprogramid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_competenceformationlevels_educationalprogramid ON dbo."CompetenceFormationLevels" USING btree ("EducationalProgramId");


--
-- Name: idx_ix_competenceformationlevels_indicatorid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_competenceformationlevels_indicatorid ON dbo."CompetenceFormationLevels" USING btree ("IndicatorId");


--
-- Name: idx_ix_competencelesson_lessonsid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_competencelesson_lessonsid ON dbo."CompetenceLesson" USING btree ("LessonsId");


--
-- Name: idx_ix_curriculums_specialtyid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_curriculums_specialtyid ON dbo."Curriculums" USING btree ("SpecialtyId");


--
-- Name: idx_ix_departments_departmentheadid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE UNIQUE INDEX idx_ix_departments_departmentheadid ON dbo."Departments" USING btree ("DepartmentHeadId");


--
-- Name: idx_ix_disciplineindicator_indicatorsid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_disciplineindicator_indicatorsid ON dbo."DisciplineIndicator" USING btree ("IndicatorsId");


--
-- Name: idx_ix_disciplines_curriculumid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_disciplines_curriculumid ON dbo."Disciplines" USING btree ("CurriculumId");


--
-- Name: idx_ix_disciplines_departmentid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_disciplines_departmentid ON dbo."Disciplines" USING btree ("DepartmentId");


--
-- Name: idx_ix_disciplineteacher_teachersid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_disciplineteacher_teachersid ON dbo."DisciplineTeacher" USING btree ("TeachersId");


--
-- Name: idx_ix_educationalprograminspector_inspectorsid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_educationalprograminspector_inspectorsid ON dbo."EducationalProgramInspector" USING btree ("InspectorsId");


--
-- Name: idx_ix_educationalprogramknowledgecontrolform_knowledgecontrolf; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_educationalprogramknowledgecontrolform_knowledgecontrolf ON dbo."EducationalProgramKnowledgeControlForm" USING btree ("KnowledgeControlFormsId");


--
-- Name: idx_ix_educationalprogrammethodicalrecommendation_methodicalrec; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_educationalprogrammethodicalrecommendation_methodicalrec ON dbo."EducationalProgramMethodicalRecommendation" USING btree ("MethodicalRecommendationsId");


--
-- Name: idx_ix_educationalprogramprotocol_protocolsid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_educationalprogramprotocol_protocolsid ON dbo."EducationalProgramProtocol" USING btree ("ProtocolsId");


--
-- Name: idx_ix_educationalprograms_disciplineid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE UNIQUE INDEX idx_ix_educationalprograms_disciplineid ON dbo."EducationalPrograms" USING btree ("DisciplineId");


--
-- Name: idx_ix_educationalprograms_reviewerid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE UNIQUE INDEX idx_ix_educationalprograms_reviewerid ON dbo."EducationalPrograms" USING btree ("ReviewerId");


--
-- Name: idx_ix_educationalprogramtrainingcourseform_trainingcourseforms; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_educationalprogramtrainingcourseform_trainingcourseforms ON dbo."EducationalProgramTrainingCourseForm" USING btree ("TrainingCourseFormsId");


--
-- Name: idx_ix_indicators_competenceid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_indicators_competenceid ON dbo."Indicators" USING btree ("CompetenceId");


--
-- Name: idx_ix_informationblockcontents_informationblockid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_informationblockcontents_informationblockid ON dbo."InformationBlockContents" USING btree ("InformationBlockId");


--
-- Name: idx_ix_informationtemplates_informationblockid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_informationtemplates_informationblockid ON dbo."InformationTemplates" USING btree ("InformationBlockId");


--
-- Name: idx_ix_knowledgeassessment_knowledgecontrolformid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_knowledgeassessment_knowledgecontrolformid ON dbo."KnowledgeAssessment" USING btree ("KnowledgeControlFormId");


--
-- Name: idx_ix_lessons_educationalprogramid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_lessons_educationalprogramid ON dbo."Lessons" USING btree ("EducationalProgramId");


--
-- Name: idx_ix_lessons_trainingcourseformid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_lessons_trainingcourseformid ON dbo."Lessons" USING btree ("TrainingCourseFormId");


--
-- Name: idx_ix_lessonweek_weeksid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_lessonweek_weeksid ON dbo."LessonWeek" USING btree ("WeeksId");


--
-- Name: idx_ix_literaturetypeinfos_educationalprogramid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_literaturetypeinfos_educationalprogramid ON dbo."LiteratureTypeInfos" USING btree ("EducationalProgramId");


--
-- Name: idx_ix_refreshtokens_userid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_refreshtokens_userid ON dbo."RefreshTokens" USING btree ("UserId");


--
-- Name: idx_ix_semesterdistributions_semesterid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_semesterdistributions_semesterid ON dbo."SemesterDistributions" USING btree ("SemesterId");


--
-- Name: idx_ix_specialties_departmentid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_specialties_departmentid ON dbo."Specialties" USING btree ("DepartmentId");


--
-- Name: idx_ix_specialties_facultyid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_specialties_facultyid ON dbo."Specialties" USING btree ("FacultyId");


--
-- Name: idx_ix_specialties_federalstateeducationalstandardid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_specialties_federalstateeducationalstandardid ON dbo."Specialties" USING btree ("FederalStateEducationalStandardId");


--
-- Name: idx_ix_teachers_academicdegreeid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_teachers_academicdegreeid ON dbo."Teachers" USING btree ("AcademicDegreeId");


--
-- Name: idx_ix_teachers_academicrankid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_teachers_academicrankid ON dbo."Teachers" USING btree ("AcademicRankId");


--
-- Name: idx_ix_teachers_departmentid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_teachers_departmentid ON dbo."Teachers" USING btree ("DepartmentId");


--
-- Name: idx_ix_teachers_positionid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_teachers_positionid ON dbo."Teachers" USING btree ("PositionId");


--
-- Name: idx_ix_weeks_educationalprogramid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_weeks_educationalprogramid ON dbo."Weeks" USING btree ("EducationalProgramId");


--
-- Name: idx_ix_weeks_semesterid; Type: INDEX; Schema: dbo; Owner: -
--

CREATE INDEX idx_ix_weeks_semesterid ON dbo."Weeks" USING btree ("SemesterId");


--
-- Name: idx_rolenameindex; Type: INDEX; Schema: dbo; Owner: -
--

CREATE UNIQUE INDEX idx_rolenameindex ON dbo."Roles" USING btree ("NormalizedName") WHERE ("NormalizedName" IS NOT NULL);


--
-- Name: Users FK_Users_Departments_DepartmentId; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Users"
    ADD CONSTRAINT "FK_Users_Departments_DepartmentId" FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("Id");


--
-- Name: RoleClaims fk_aspnetroleclaims_aspnetroles_roleid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."RoleClaims"
    ADD CONSTRAINT fk_aspnetroleclaims_aspnetroles_roleid FOREIGN KEY ("RoleId") REFERENCES dbo."Roles"("Id") ON DELETE CASCADE;


--
-- Name: UserClaims fk_aspnetuserclaims_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."UserClaims"
    ADD CONSTRAINT fk_aspnetuserclaims_aspnetusers_userid FOREIGN KEY ("UserId") REFERENCES dbo."Users"("Id") ON DELETE CASCADE;


--
-- Name: UserRoles fk_aspnetuserroles_aspnetroles_roleid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."UserRoles"
    ADD CONSTRAINT fk_aspnetuserroles_aspnetroles_roleid FOREIGN KEY ("RoleId") REFERENCES dbo."Roles"("Id") ON DELETE CASCADE;


--
-- Name: UserRoles fk_aspnetuserroles_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."UserRoles"
    ADD CONSTRAINT fk_aspnetuserroles_aspnetusers_userid FOREIGN KEY ("UserId") REFERENCES dbo."Users"("Id") ON DELETE CASCADE;


--
-- Name: AudienceEducationalProgram fk_audienceeducationalprogram_audiences_audiencesid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."AudienceEducationalProgram"
    ADD CONSTRAINT fk_audienceeducationalprogram_audiences_audiencesid FOREIGN KEY ("AudiencesId") REFERENCES dbo."Audiences"("Id") ON DELETE CASCADE;


--
-- Name: AudienceEducationalProgram fk_audienceeducationalprogram_educationalprograms_educationalpr; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."AudienceEducationalProgram"
    ADD CONSTRAINT fk_audienceeducationalprogram_educationalprograms_educationalpr FOREIGN KEY ("EducationalProgramsId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: CompetenceFormationLevelEvaluationToolType fk_competenceformationlevelevaluationtooltype_competenceformati; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceFormationLevelEvaluationToolType"
    ADD CONSTRAINT fk_competenceformationlevelevaluationtooltype_competenceformati FOREIGN KEY ("CompetenceFormationLevelsId") REFERENCES dbo."CompetenceFormationLevels"("Id") ON DELETE CASCADE;


--
-- Name: CompetenceFormationLevelEvaluationToolType fk_competenceformationlevelevaluationtooltype_evaluationtooltyp; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceFormationLevelEvaluationToolType"
    ADD CONSTRAINT fk_competenceformationlevelevaluationtooltype_evaluationtooltyp FOREIGN KEY ("EvaluationToolTypesId") REFERENCES dbo."EvaluationToolTypes"("Id") ON DELETE CASCADE;


--
-- Name: CompetenceFormationLevels fk_competenceformationlevels_educationalprograms_educationalpro; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceFormationLevels"
    ADD CONSTRAINT fk_competenceformationlevels_educationalprograms_educationalpro FOREIGN KEY ("EducationalProgramId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: CompetenceFormationLevels fk_competenceformationlevels_indicators_indicatorid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceFormationLevels"
    ADD CONSTRAINT fk_competenceformationlevels_indicators_indicatorid FOREIGN KEY ("IndicatorId") REFERENCES dbo."Indicators"("Id") ON DELETE CASCADE;


--
-- Name: CompetenceLesson fk_competencelesson_competences_competencesid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceLesson"
    ADD CONSTRAINT fk_competencelesson_competences_competencesid FOREIGN KEY ("CompetencesId") REFERENCES dbo."Competences"("Id") ON DELETE CASCADE;


--
-- Name: CompetenceLesson fk_competencelesson_lessons_lessonsid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."CompetenceLesson"
    ADD CONSTRAINT fk_competencelesson_lessons_lessonsid FOREIGN KEY ("LessonsId") REFERENCES dbo."Lessons"("Id") ON DELETE CASCADE;


--
-- Name: Curriculums fk_curriculums_specialties_specialtyid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Curriculums"
    ADD CONSTRAINT fk_curriculums_specialties_specialtyid FOREIGN KEY ("SpecialtyId") REFERENCES dbo."Specialties"("Id") ON DELETE CASCADE;


--
-- Name: Departments fk_departments_departmentheads_departmentheadid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Departments"
    ADD CONSTRAINT fk_departments_departmentheads_departmentheadid FOREIGN KEY ("DepartmentHeadId") REFERENCES dbo."DepartmentHeads"("Id") ON DELETE CASCADE;


--
-- Name: DisciplineIndicator fk_disciplineindicator_disciplines_disciplinesid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DisciplineIndicator"
    ADD CONSTRAINT fk_disciplineindicator_disciplines_disciplinesid FOREIGN KEY ("DisciplinesId") REFERENCES dbo."Disciplines"("Id") ON DELETE CASCADE;


--
-- Name: DisciplineIndicator fk_disciplineindicator_indicators_indicatorsid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DisciplineIndicator"
    ADD CONSTRAINT fk_disciplineindicator_indicators_indicatorsid FOREIGN KEY ("IndicatorsId") REFERENCES dbo."Indicators"("Id") ON DELETE CASCADE;


--
-- Name: Disciplines fk_disciplines_curriculums_curriculumid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Disciplines"
    ADD CONSTRAINT fk_disciplines_curriculums_curriculumid FOREIGN KEY ("CurriculumId") REFERENCES dbo."Curriculums"("Id") ON DELETE CASCADE;


--
-- Name: Disciplines fk_disciplines_departments_departmentid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Disciplines"
    ADD CONSTRAINT fk_disciplines_departments_departmentid FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("Id");


--
-- Name: DisciplineTeacher fk_disciplineteacher_disciplines_disciplinesid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DisciplineTeacher"
    ADD CONSTRAINT fk_disciplineteacher_disciplines_disciplinesid FOREIGN KEY ("DisciplinesId") REFERENCES dbo."Disciplines"("Id") ON DELETE CASCADE;


--
-- Name: DisciplineTeacher fk_disciplineteacher_teachers_teachersid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."DisciplineTeacher"
    ADD CONSTRAINT fk_disciplineteacher_teachers_teachersid FOREIGN KEY ("TeachersId") REFERENCES dbo."Teachers"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramInspector fk_educationalprograminspector_educationalprograms_educationalp; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramInspector"
    ADD CONSTRAINT fk_educationalprograminspector_educationalprograms_educationalp FOREIGN KEY ("EducationalProgramsId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramInspector fk_educationalprograminspector_inspectors_inspectorsid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramInspector"
    ADD CONSTRAINT fk_educationalprograminspector_inspectors_inspectorsid FOREIGN KEY ("InspectorsId") REFERENCES dbo."Inspectors"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramKnowledgeControlForm fk_educationalprogramknowledgecontrolform_educationalprograms_e; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramKnowledgeControlForm"
    ADD CONSTRAINT fk_educationalprogramknowledgecontrolform_educationalprograms_e FOREIGN KEY ("EducationalProgramsId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramKnowledgeControlForm fk_educationalprogramknowledgecontrolform_knowledgecontrolforms; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramKnowledgeControlForm"
    ADD CONSTRAINT fk_educationalprogramknowledgecontrolform_knowledgecontrolforms FOREIGN KEY ("KnowledgeControlFormsId") REFERENCES dbo."KnowledgeControlForms"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramMethodicalRecommendation fk_educationalprogrammethodicalrecommendation_educationalprogra; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramMethodicalRecommendation"
    ADD CONSTRAINT fk_educationalprogrammethodicalrecommendation_educationalprogra FOREIGN KEY ("EducationalProgramsId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramMethodicalRecommendation fk_educationalprogrammethodicalrecommendation_methodicalrecomme; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramMethodicalRecommendation"
    ADD CONSTRAINT fk_educationalprogrammethodicalrecommendation_methodicalrecomme FOREIGN KEY ("MethodicalRecommendationsId") REFERENCES dbo."MethodicalRecommendations"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramProtocol fk_educationalprogramprotocol_educationalprograms_educationalpr; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramProtocol"
    ADD CONSTRAINT fk_educationalprogramprotocol_educationalprograms_educationalpr FOREIGN KEY ("EducationalProgramsId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramProtocol fk_educationalprogramprotocol_protocols_protocolsid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramProtocol"
    ADD CONSTRAINT fk_educationalprogramprotocol_protocols_protocolsid FOREIGN KEY ("ProtocolsId") REFERENCES dbo."Protocols"("Id") ON DELETE CASCADE;


--
-- Name: EducationalPrograms fk_educationalprograms_disciplines_disciplineid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalPrograms"
    ADD CONSTRAINT fk_educationalprograms_disciplines_disciplineid FOREIGN KEY ("DisciplineId") REFERENCES dbo."Disciplines"("Id") ON DELETE CASCADE;


--
-- Name: EducationalPrograms fk_educationalprograms_reviewers_reviewerid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalPrograms"
    ADD CONSTRAINT fk_educationalprograms_reviewers_reviewerid FOREIGN KEY ("ReviewerId") REFERENCES dbo."Reviewers"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramTrainingCourseForm fk_educationalprogramtrainingcourseform_educationalprograms_edu; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramTrainingCourseForm"
    ADD CONSTRAINT fk_educationalprogramtrainingcourseform_educationalprograms_edu FOREIGN KEY ("EducationalProgramsId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: EducationalProgramTrainingCourseForm fk_educationalprogramtrainingcourseform_trainingcourseforms_tra; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EducationalProgramTrainingCourseForm"
    ADD CONSTRAINT fk_educationalprogramtrainingcourseform_trainingcourseforms_tra FOREIGN KEY ("TrainingCourseFormsId") REFERENCES dbo."TrainingCourseForms"("Id") ON DELETE CASCADE;


--
-- Name: EvaluationTools fk_evaluationtools_educationalprograms_educationalprogramid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EvaluationTools"
    ADD CONSTRAINT fk_evaluationtools_educationalprograms_educationalprogramid FOREIGN KEY ("EducationalProgramId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: EvaluationTools fk_evaluationtools_evaluationtooltypes_evaluationtooltypeid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."EvaluationTools"
    ADD CONSTRAINT fk_evaluationtools_evaluationtooltypes_evaluationtooltypeid FOREIGN KEY ("EvaluationToolTypeId") REFERENCES dbo."EvaluationToolTypes"("Id") ON DELETE CASCADE;


--
-- Name: Indicators fk_indicators_competences_competenceid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Indicators"
    ADD CONSTRAINT fk_indicators_competences_competenceid FOREIGN KEY ("CompetenceId") REFERENCES dbo."Competences"("Id") ON DELETE CASCADE;


--
-- Name: InformationBlockContents fk_informationblockcontents_educationalprograms_educationalprog; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."InformationBlockContents"
    ADD CONSTRAINT fk_informationblockcontents_educationalprograms_educationalprog FOREIGN KEY ("EducationalProgramId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: InformationBlockContents fk_informationblockcontents_informationblocks_informationblocki; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."InformationBlockContents"
    ADD CONSTRAINT fk_informationblockcontents_informationblocks_informationblocki FOREIGN KEY ("InformationBlockId") REFERENCES dbo."InformationBlocks"("Id") ON DELETE CASCADE;


--
-- Name: InformationTemplates fk_informationtemplates_informationblocks_informationblockid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."InformationTemplates"
    ADD CONSTRAINT fk_informationtemplates_informationblocks_informationblockid FOREIGN KEY ("InformationBlockId") REFERENCES dbo."InformationBlocks"("Id") ON DELETE CASCADE;


--
-- Name: KnowledgeAssessment fk_knowledgeassessment_knowledgecontrolforms_knowledgecontrolfo; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."KnowledgeAssessment"
    ADD CONSTRAINT fk_knowledgeassessment_knowledgecontrolforms_knowledgecontrolfo FOREIGN KEY ("KnowledgeControlFormId") REFERENCES dbo."KnowledgeControlForms"("Id") ON DELETE CASCADE;


--
-- Name: KnowledgeAssessment fk_knowledgeassessment_weeks_weekid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."KnowledgeAssessment"
    ADD CONSTRAINT fk_knowledgeassessment_weeks_weekid FOREIGN KEY ("WeekId") REFERENCES dbo."Weeks"("Id") ON DELETE CASCADE;


--
-- Name: Lessons fk_lessons_educationalprograms_educationalprogramid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Lessons"
    ADD CONSTRAINT fk_lessons_educationalprograms_educationalprogramid FOREIGN KEY ("EducationalProgramId") REFERENCES dbo."EducationalPrograms"("Id");


--
-- Name: Lessons fk_lessons_trainingcourseforms_trainingcourseformid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Lessons"
    ADD CONSTRAINT fk_lessons_trainingcourseforms_trainingcourseformid FOREIGN KEY ("TrainingCourseFormId") REFERENCES dbo."TrainingCourseForms"("Id") ON DELETE CASCADE;


--
-- Name: LessonWeek fk_lessonweek_lessons_lessonsid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."LessonWeek"
    ADD CONSTRAINT fk_lessonweek_lessons_lessonsid FOREIGN KEY ("LessonsId") REFERENCES dbo."Lessons"("Id") ON DELETE CASCADE;


--
-- Name: LessonWeek fk_lessonweek_weeks_weeksid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."LessonWeek"
    ADD CONSTRAINT fk_lessonweek_weeks_weeksid FOREIGN KEY ("WeeksId") REFERENCES dbo."Weeks"("Id") ON DELETE CASCADE;


--
-- Name: LiteratureTypeInfos fk_literaturetypeinfos_educationalprograms_educationalprogramid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."LiteratureTypeInfos"
    ADD CONSTRAINT fk_literaturetypeinfos_educationalprograms_educationalprogramid FOREIGN KEY ("EducationalProgramId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: LiteratureTypeInfos fk_literaturetypeinfos_literatures_literatureid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."LiteratureTypeInfos"
    ADD CONSTRAINT fk_literaturetypeinfos_literatures_literatureid FOREIGN KEY ("LiteratureId") REFERENCES dbo."Literatures"("Id") ON DELETE CASCADE;


--
-- Name: RefreshTokens fk_refreshtokens_aspnetusers_userid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."RefreshTokens"
    ADD CONSTRAINT fk_refreshtokens_aspnetusers_userid FOREIGN KEY ("UserId") REFERENCES dbo."Users"("Id") ON DELETE CASCADE;


--
-- Name: SemesterDistributions fk_semesterdistributions_disciplines_disciplineid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."SemesterDistributions"
    ADD CONSTRAINT fk_semesterdistributions_disciplines_disciplineid FOREIGN KEY ("DisciplineId") REFERENCES dbo."Disciplines"("Id") ON DELETE CASCADE;


--
-- Name: SemesterDistributions fk_semesterdistributions_semesters_semesterid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."SemesterDistributions"
    ADD CONSTRAINT fk_semesterdistributions_semesters_semesterid FOREIGN KEY ("SemesterId") REFERENCES dbo."Semesters"("Id") ON DELETE CASCADE;


--
-- Name: Specialties fk_specialties_departments_departmentid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Specialties"
    ADD CONSTRAINT fk_specialties_departments_departmentid FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("Id") ON DELETE CASCADE;


--
-- Name: Specialties fk_specialties_faculties_facultyid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Specialties"
    ADD CONSTRAINT fk_specialties_faculties_facultyid FOREIGN KEY ("FacultyId") REFERENCES dbo."Faculties"("Id") ON DELETE CASCADE;


--
-- Name: Specialties fk_specialties_federalstateeducationalstandards_federalstateedu; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Specialties"
    ADD CONSTRAINT fk_specialties_federalstateeducationalstandards_federalstateedu FOREIGN KEY ("FederalStateEducationalStandardId") REFERENCES dbo."FederalStateEducationalStandards"("Id") ON DELETE CASCADE;


--
-- Name: Teachers fk_teachers_academicdegrees_academicdegreeid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Teachers"
    ADD CONSTRAINT fk_teachers_academicdegrees_academicdegreeid FOREIGN KEY ("AcademicDegreeId") REFERENCES dbo."AcademicDegrees"("Id") ON DELETE CASCADE;


--
-- Name: Teachers fk_teachers_academicranks_academicrankid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Teachers"
    ADD CONSTRAINT fk_teachers_academicranks_academicrankid FOREIGN KEY ("AcademicRankId") REFERENCES dbo."AcademicRanks"("Id") ON DELETE CASCADE;


--
-- Name: Teachers fk_teachers_applicationuser_applicationuserid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Teachers"
    ADD CONSTRAINT fk_teachers_applicationuser_applicationuserid FOREIGN KEY ("ApplicationUserId") REFERENCES dbo."Users"("Id") ON DELETE CASCADE;


--
-- Name: Teachers fk_teachers_departments_departmentid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Teachers"
    ADD CONSTRAINT fk_teachers_departments_departmentid FOREIGN KEY ("DepartmentId") REFERENCES dbo."Departments"("Id");


--
-- Name: Teachers fk_teachers_positions_positionid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Teachers"
    ADD CONSTRAINT fk_teachers_positions_positionid FOREIGN KEY ("PositionId") REFERENCES dbo."Positions"("Id") ON DELETE CASCADE;


--
-- Name: Weeks fk_weeks_educationalprograms_educationalprogramid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Weeks"
    ADD CONSTRAINT fk_weeks_educationalprograms_educationalprogramid FOREIGN KEY ("EducationalProgramId") REFERENCES dbo."EducationalPrograms"("Id") ON DELETE CASCADE;


--
-- Name: Weeks fk_weeks_semesters_semesterid; Type: FK CONSTRAINT; Schema: dbo; Owner: -
--

ALTER TABLE ONLY dbo."Weeks"
    ADD CONSTRAINT fk_weeks_semesters_semesterid FOREIGN KEY ("SemesterId") REFERENCES dbo."Semesters"("Id") ON DELETE CASCADE;


--
-- PostgreSQL database dump complete
--

