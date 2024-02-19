# How to use!

1. Extract the `vib_telemetry` into your server resources folder (wherever you'd like) and make sure
it's enabled in the server.cfg
2. Open up main_commands.lua - if you'd like to create an item of some kind and open this menu on item press
rather than a command, use the client event which is called in this command. You'll find yourself re-opening
the menu a few times, so I'd advise this if you get sick of using the command (`/telemetry`)
3. Fire up your server and login.
4. Open the menu (either with the `/telemetry` command or whichever means you have provided) 
5. If the "Create Database Tables" button is visible, clicking this should ensure your database is up to date.
(Reach out to support if it is still there after clicking it).
6. Create some groups, add some vehicles and run some tests! Check out our video for more information on how
use this resource.

---

### Database Queries

If you want to make your DB tables manually for some reason, here are the queries to do so:

```sql
CREATE TABLE IF NOT EXISTS telemetry_groups (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    citizen_id VARCHAR(20) NOT NULL,
    name VARCHAR (256) NOT NULL,
    vehicle_names TEXT NOT NULL DEFAULT '',
    is_deleted BIT NOT NULL DEFAULT 0,

    PRIMARY KEY (id)
)
```

```sql
CREATE TABLE IF NOT EXISTS telemetry_speed_tests (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    citizen_id VARCHAR(20) NOT NULL,
    group_id INT NOT NULL DEFAULT -1,
    category_name VARCHAR(250) NOT NULL DEFAULT "",
    results_json TEXT NOT NULL DEFAULT '',
    was_cancelled BIT NOT NULL DEFAULT 0,
    is_deleted BIT NOT NULL DEFAULT 0,

    time_created DATETIME NOT NULL DEFAULT NOW(),

    PRIMARY KEY (id)
)
```

> Note: You shouldn't need to do this; if you can't use oxmysql then this addon currently won't work.

---

> A link to our [VIDEO](https://www.youtube.com/) for more information

> A link to our [DISCORD](https://discord.gg/KfWbcazTz8) for support

> A link to [FONT AWESOME](https://fontawesome.com/search?o=r&m=free) for free icons