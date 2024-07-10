INSERT INTO players(display_name, id)
VALUES
    ('Hera', 'ba98b8f6-96b1-4998-b844-23a002416301'),
    ('TheViper', '962421d0-429f-47e9-8497-d79c5def966a'),
    ('Liereyy', 'f7081ebe-6c69-48d0-acec-434e7b70e9ba'),
    ('TaToH', '7beb0856-3f6f-4bcf-a597-8fe2dd62967f'),
    ('Yo', '1afa7d5f-c9e8-4a94-9f9b-e2cea2c0dbc9'),
    ('DauT', '048a31a6-7adb-44ee-aa85-df5057c18d18'),
    ('JorDan', 'cd2d8038-62a8-4d95-abdb-bf712919480e'),
    ('MbL', '0c1bdcb4-f649-42f3-aacc-e55f8b7ea29c'),
    ('Villese', '77898470-7696-45f7-8114-1d94ccb5fe51'),
    ('ACCM', '6fc7a7f6-9064-4168-a6fe-a0c5e910914c'),
    ('Vinchester', 'd97749eb-4175-4fb3-8b02-27d9cc8942f0'),
    ('Nicov', 'a7f777d9-cc84-4bcc-ade3-9e547f64d93d'),
    ('Dogao', 'e444be26-e851-42d9-87f7-b431b2de50a7'),
    ('Capoch', 'bb1baad0-d10a-44de-8268-a17bcc9bcc73'),
    ('vivi', '841c5e4b-93ff-448f-a0d2-63387711438f'),
    ('Chris', '5e70ab40-aed4-41a8-99e7-b4d354c42cd3'),
    ('Sitaux', '89f4a759-81db-4490-a167-09bf4be91a2c'),
    ('Slam', '173b6262-e1e8-49a7-a5e7-895272d788c3'),
    ('Sebastian', '6019d959-17b5-4ab3-abd6-edfcfb207c68')
;


INSERT INTO tournaments(name, slug, id, description)
VALUES
    ('Warlords III', 'warlords_iii', '8ae676e3-2eef-4e06-904b-2e1484e46b6e', 'A tournament hosted by Memb.')
;

INSERT INTO tournament_phases(id, name, tournament_id, type)
VALUES
    ('a7bddeaa-ca55-46c0-863a-b9a83650daee', 'Main event', '8ae676e3-2eef-4e06-904b-2e1484e46b6e', 'MAIN_EVENT')
;

INSERT INTO tournament_participants(id, name, player_id, tournament_id)
VALUES
    ('2ef34755-48c4-4570-ae51-95b00bc262f2', 'Hera', 'ba98b8f6-96b1-4998-b844-23a002416301', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('e451745a-927b-41db-acf8-4d6a82299d11', 'TheViper', '962421d0-429f-47e9-8497-d79c5def966a', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('d99339c5-7fc0-4dfd-bc66-04230bcb73ce', 'Liereyy', 'f7081ebe-6c69-48d0-acec-434e7b70e9ba', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('a89b0d39-8e75-497b-be59-b501e0cdbc68', 'TaToH', '7beb0856-3f6f-4bcf-a597-8fe2dd62967f', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('d885d8f9-2f19-444d-a203-a8d2188c8c0b', 'Yo', '1afa7d5f-c9e8-4a94-9f9b-e2cea2c0dbc9', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('4e4aa2ac-7788-465d-aa68-cc2a32cf14ea', 'DauT', '048a31a6-7adb-44ee-aa85-df5057c18d18', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('d99cb2ec-caa6-4a04-bde0-295eb7d89e67', 'JorDan', 'cd2d8038-62a8-4d95-abdb-bf712919480e', '8ae676e3-2eef-4e06-904b-2e1484e46b6e'),
    ('022d86e6-f246-480b-8485-f033fd1ed15b', 'MbL', '0c1bdcb4-f649-42f3-aacc-e55f8b7ea29c', '8ae676e3-2eef-4e06-904b-2e1484e46b6e')
;

INSERT INTO matches(id, home_participant_id, away_participant_id, home_score, away_score, tournament_phase_id)
VALUES
    ('dffcf3c7-fa1f-40df-bc6f-c59e268fddd0', '2ef34755-48c4-4570-ae51-95b00bc262f2', '022d86e6-f246-480b-8485-f033fd1ed15b', 3, 1, 'a7bddeaa-ca55-46c0-863a-b9a83650daee'),
    ('27c9077b-2d3f-49d5-b919-da2a5b8b2629', 'e451745a-927b-41db-acf8-4d6a82299d11', 'd99cb2ec-caa6-4a04-bde0-295eb7d89e67', 3, 2, 'a7bddeaa-ca55-46c0-863a-b9a83650daee'),
    ('3701918d-7d7d-493a-abd5-ccb1d4db3044', 'd99339c5-7fc0-4dfd-bc66-04230bcb73ce', '4e4aa2ac-7788-465d-aa68-cc2a32cf14ea', 3, 0, 'a7bddeaa-ca55-46c0-863a-b9a83650daee'),
    ('748accf6-cdbf-44aa-8b9c-7e6f37954381', 'a89b0d39-8e75-497b-be59-b501e0cdbc68', 'd885d8f9-2f19-444d-a203-a8d2188c8c0b', 3, 2, 'a7bddeaa-ca55-46c0-863a-b9a83650daee'),
    ('a22c3c0b-7808-4daa-adba-95842fdd52a1', '2ef34755-48c4-4570-ae51-95b00bc262f2', 'a89b0d39-8e75-497b-be59-b501e0cdbc68', 3, 1, 'a7bddeaa-ca55-46c0-863a-b9a83650daee'),
    ('3f16992c-92ad-4d30-b446-db1bb3889632', 'e451745a-927b-41db-acf8-4d6a82299d11', 'd99339c5-7fc0-4dfd-bc66-04230bcb73ce', 3, 0, 'a7bddeaa-ca55-46c0-863a-b9a83650daee'),
    ('9d236392-ef1b-49c7-8eaf-8d7aef7e3572', '2ef34755-48c4-4570-ae51-95b00bc262f2', 'e451745a-927b-41db-acf8-4d6a82299d11', 2, 3, 'a7bddeaa-ca55-46c0-863a-b9a83650daee')
;
