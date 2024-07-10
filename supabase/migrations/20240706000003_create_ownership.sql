-- Functions

CREATE OR REPLACE FUNCTION "public"."is_tournament_admin"("in_tournament_id" "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
AS $$ DECLARE
    is_admin BOOLEAN;
BEGIN
    IF auth.jwt() ->> 'user_role' = 'admin' THEN
        RETURN True; -- Admins owns all
    END IF;

    SELECT EXISTS (
        SELECT 1
        FROM tournament_admins
        WHERE user_id = auth.uid()
          AND tournament_id = in_tournament_id
    ) INTO is_admin;

    RETURN is_admin;
END;$$;

CREATE OR REPLACE FUNCTION "public"."is_phase_admin"(in_phase_id "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
AS $$ DECLARE
    is_admin BOOLEAN;
BEGIN
    IF auth.jwt() ->> 'user_role' = 'admin' THEN
        RETURN True; -- Admins owns all
    END IF;

    SELECT EXISTS (
        SELECT 1
        FROM tournament_phases
        INNER JOIN tournament_admins ON tournament_phases.tournament_id = tournament_admins.tournament_id
        WHERE tournament_admins.user_id = auth.uid()
        AND tournament_phases.id = in_phase_id
    ) INTO is_admin;

    RETURN is_admin;
END;$$;

CREATE OR REPLACE FUNCTION "public"."is_match_player"(in_match_id "uuid") RETURNS boolean
    LANGUAGE "plpgsql"
AS $$ DECLARE
    is_player BOOLEAN;
BEGIN
    SELECT EXISTS (
        SELECT 1
        FROM matches
        INNER JOIN tournament_participants
            ON tournament_participants.id IN (matches.home_participant_id, matches.away_participant_id)
        INNER JOIN players
            ON players.id = tournament_participants.player_id
        WHERE players.user_id = auth.uid()
    ) INTO is_player;

    RETURN is_player;
END;$$;


-- Triggers

--
-- Set creating user as admin of tournament
create function default_admin()
    returns trigger
    language plpgsql
as $$
begin
    insert into tournament_admins(tournament_id, user_id)
    values (new.id, auth.uid());
    return new;
end;
$$;

create trigger "default_admin"
    after update on "tournament_admins"
    for each row execute function default_admin();

