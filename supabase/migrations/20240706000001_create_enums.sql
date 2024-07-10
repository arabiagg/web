


CREATE TYPE "public"."phase_type" AS ENUM (
    'MAIN_EVENT',
    'GROUP_STAGE',
    'QUALIFIERS'
);


CREATE TYPE "public"."tournament_tier" AS ENUM (
    'S',
    'A',
    'B',
    'C',
    'COMMUNITY'
);


CREATE TYPE "public"."signup_method" AS ENUM (
    'OPEN_REGISTRATION',
    'INVITE_ONLY'
)
