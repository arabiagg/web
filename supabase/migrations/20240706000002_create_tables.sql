CREATE TABLE IF NOT EXISTS "public"."matches" (
    "date_played" timestamp with time zone,
    "home_participant_id" "uuid",
    "away_participant_id" "uuid",
    "home_score" integer,
    "away_score" integer,
    "tournament_phase_id" "uuid",
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "info" "jsonb",
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "public"."players" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "user_id" "uuid",
    "team_id" "uuid",
    "display_name" "text" DEFAULT ''::"text" NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "public"."teams" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "display_name" "text" DEFAULT ''::"text" NOT NULL,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "public"."tournament_participants" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "name" "text" NOT NULL,
    "result_min" integer,
    "result_max" integer,
    "tournament_id" "uuid" NOT NULL,
    "player_id" "uuid",
    "seed" integer,
    "elo" integer,
    PRIMARY KEY ("id")
);

CREATE TABLE IF NOT EXISTS "public"."tournament_phases" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "tournament_id" "uuid" NOT NULL,
    "next_phase_id" "uuid",
    "type" "public"."phase_type" NOT NULL,
    PRIMARY KEY ("id"),
    UNIQUE ("tournament_id", "name")
);

CREATE TABLE IF NOT EXISTS "public"."tournaments" (
    "id" "uuid" DEFAULT "gen_random_uuid"() NOT NULL,
    "created_at" timestamp with time zone DEFAULT "now"() NOT NULL,
    "name" "text" NOT NULL,
    "description" "text",
    "slug" "text" NOT NULL,
    "start_date" timestamp with time zone,
    "end_date" timestamp with time zone,
    "tier" "public"."tournament_tier" DEFAULT 'COMMUNITY' NOT NULL,
    "info" "jsonb",
    PRIMARY KEY ("id"),
    UNIQUE ("slug")
);

CREATE TABLE IF NOT EXISTS "public"."tournament_admins" (
    "tournament_id" "uuid" NOT NULL,
    "user_id" "uuid" NOT NULL,
    UNIQUE ("tournament_id", "user_id"),
    PRIMARY KEY ("tournament_id", "user_id")
);

ALTER TABLE ONLY "public"."players"
    ADD CONSTRAINT "player_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "public"."teams"("id"),
    ADD CONSTRAINT "player_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");
;

ALTER TABLE ONLY "public"."matches"
    ADD CONSTRAINT "matches_away_participant_id_fkey" FOREIGN KEY ("away_participant_id") REFERENCES "public"."tournament_participants"("id"),
    ADD CONSTRAINT "matches_home_participant_id_fkey" FOREIGN KEY ("home_participant_id") REFERENCES "public"."tournament_participants"("id"),
    ADD CONSTRAINT "matches_tournament_phase_id_fkey" FOREIGN KEY ("tournament_phase_id") REFERENCES "public"."tournament_phases"("id");

ALTER TABLE ONLY "public"."tournament_participants"
    ADD CONSTRAINT "tournament_participants_player_id_fkey" FOREIGN KEY ("player_id") REFERENCES "public"."players"("id"),
    ADD CONSTRAINT "tournament_participants_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournaments"("id");

ALTER TABLE ONLY "public"."tournament_phases"
    ADD CONSTRAINT "tournament_phases_next_phase_id_fkey" FOREIGN KEY ("next_phase_id") REFERENCES "public"."tournament_phases"("id"),
    ADD CONSTRAINT "tournament_phases_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournaments"("id");

ALTER TABLE ONLY "public"."tournament_admins"
    ADD CONSTRAINT "tournament_admins_tournament_id_fkey" FOREIGN KEY ("tournament_id") REFERENCES "public"."tournaments"("id"),
    ADD CONSTRAINT "tournament_admins_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "auth"."users"("id");


