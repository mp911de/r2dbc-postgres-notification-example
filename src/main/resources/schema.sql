CREATE OR REPLACE FUNCTION notify_event() RETURNS TRIGGER AS
$$
DECLARE
    payload JSON;
BEGIN
    payload = row_to_json(NEW);
    PERFORM pg_notify('login_event_notification', payload::text);
    RETURN NULL;
END;
$$ LANGUAGE plpgsql;;

CREATE TABLE IF NOT EXISTS login_event
(
    id         serial PRIMARY KEY,
    username   varchar(255),
    login_time timestamp
);;

DROP TRIGGER IF EXISTS notify_login_event ON login_event;;

CREATE TRIGGER notify_login_event
    AFTER INSERT OR UPDATE OR DELETE
    ON login_event
    FOR EACH ROW
EXECUTE PROCEDURE notify_event();;
