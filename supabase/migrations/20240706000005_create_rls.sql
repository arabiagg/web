--
-- Matches
--
CREATE POLICY "All can view" ON "public"."matches"
    FOR SELECT USING (true);
CREATE POLICY "Tournament owner can insert" ON "public"."matches"
    FOR INSERT WITH CHECK ("public".is_phase_admin(tournament_phase_id));
CREATE POLICY "Match tournament admin can update" ON "public"."matches"
    FOR UPDATE USING ("public".is_phase_admin(tournament_phase_id));
ALTER TABLE "public"."matches" ENABLE ROW LEVEL SECURITY;


--
-- Players
--
CREATE POLICY "Enable read access for all users" ON "public"."players" FOR SELECT USING (true);
ALTER TABLE "public"."players" ENABLE ROW LEVEL SECURITY;


--
-- Teams
--
ALTER TABLE "public"."teams" ENABLE ROW LEVEL SECURITY;


--
-- Participants
--
CREATE POLICY "Enable read access for all users" ON "public"."tournament_participants" FOR SELECT USING (true);
ALTER TABLE "public"."tournament_participants" ENABLE ROW LEVEL SECURITY;


--
-- Tournament phases
--
CREATE POLICY "Enable read access for all users" ON "public"."tournament_phases" FOR SELECT USING (true);
ALTER TABLE "public"."tournament_phases" ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Tournament admin can create" ON "public"."tournament_phases"
    FOR INSERT WITH CHECK ("public".is_tournament_admin(tournament_id));
CREATE POLICY "Tournament admin can update" ON "public"."tournament_phases"
    FOR UPDATE USING ("public".is_tournament_admin(tournament_id));

--
-- Tournaments
--
CREATE POLICY "All can view" ON "public"."tournaments" FOR SELECT USING (true);
CREATE POLICY "Authorized can create" ON "public"."tournaments"
    FOR INSERT WITH CHECK("public".authorize('tournament.create'));
CREATE POLICY "Authorized owner can update" ON "public"."tournaments"
    FOR UPDATE USING ("public".authorize('tournament.update') AND "public".is_tournament_admin("id"));
ALTER TABLE "public"."tournaments" ENABLE ROW LEVEL SECURITY;


--
-- User roles
--
CREATE POLICY "Allow auth admin to read user roles" ON "public"."user_roles" FOR SELECT TO "supabase_auth_admin" USING (true);
ALTER TABLE "public"."user_roles" ENABLE ROW LEVEL SECURITY;


--
-- Role permissions
--
ALTER TABLE "public"."role_permissions" ENABLE ROW LEVEL SECURITY;


--
-- Tournament admins
--
ALTER TABLE "public"."tournament_admins" ENABLE ROW LEVEL SECURITY;



--
-- Schema/function/table permission grants
--

GRANT USAGE ON SCHEMA "public" TO "postgres";
GRANT USAGE ON SCHEMA "public" TO "anon";
GRANT USAGE ON SCHEMA "public" TO "authenticated";
GRANT USAGE ON SCHEMA "public" TO "service_role";

GRANT ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") TO "service_role";
GRANT ALL ON FUNCTION "public"."custom_access_token_hook"("event" "jsonb") TO "supabase_auth_admin";

GRANT ALL ON TABLE "public"."matches" TO "anon";
GRANT ALL ON TABLE "public"."matches" TO "authenticated";
GRANT ALL ON TABLE "public"."matches" TO "service_role";

GRANT ALL ON TABLE "public"."players" TO "anon";
GRANT ALL ON TABLE "public"."players" TO "authenticated";
GRANT ALL ON TABLE "public"."players" TO "service_role";

GRANT ALL ON TABLE "public"."teams" TO "anon";
GRANT ALL ON TABLE "public"."teams" TO "authenticated";
GRANT ALL ON TABLE "public"."teams" TO "service_role";

GRANT ALL ON TABLE "public"."tournament_participants" TO "anon";
GRANT ALL ON TABLE "public"."tournament_participants" TO "authenticated";
GRANT ALL ON TABLE "public"."tournament_participants" TO "service_role";

GRANT ALL ON TABLE "public"."tournament_phases" TO "anon";
GRANT ALL ON TABLE "public"."tournament_phases" TO "authenticated";
GRANT ALL ON TABLE "public"."tournament_phases" TO "service_role";

GRANT ALL ON TABLE "public"."tournaments" TO "anon";
GRANT ALL ON TABLE "public"."tournaments" TO "authenticated";
GRANT ALL ON TABLE "public"."tournaments" TO "service_role";

GRANT ALL ON TABLE "public"."user_roles" TO "service_role";
GRANT ALL ON TABLE "public"."user_roles" TO "supabase_auth_admin";

GRANT ALL ON SEQUENCE "public"."user_roles_id_seq" TO "anon";
GRANT ALL ON SEQUENCE "public"."user_roles_id_seq" TO "authenticated";
GRANT ALL ON SEQUENCE "public"."user_roles_id_seq" TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON SEQUENCES  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON FUNCTIONS  TO "service_role";

ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "postgres";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "anon";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "authenticated";
ALTER DEFAULT PRIVILEGES FOR ROLE "postgres" IN SCHEMA "public" GRANT ALL ON TABLES  TO "service_role";
