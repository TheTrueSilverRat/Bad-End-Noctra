#ifdef TESTSERVER
	#define WHITELISTFILE	"[global.config.directory]/roguetown/wl_test.txt"
#else
	#define WHITELISTFILE	"[global.config.directory]/roguetown/wl_mat.txt"
#endif

GLOBAL_LIST_EMPTY(whitelist)
GLOBAL_PROTECT(whitelist)

/proc/load_whitelist()
	GLOB.whitelist = list()
	for(var/line in world.file2list(WHITELISTFILE))
		if(!line)
			continue
		if(findtextEx(line,"#",1,2))
			continue
		GLOB.whitelist += ckey(line)
/*
/proc/check_whitelist(ckey)
	if(!GLOB.whitelist || !GLOB.whitelist.len)
		load_whitelist()
#ifdef TESTSERVER
	var/plevel = check_patreon_lvl(ckey)
	var/tlevel = check_twitch_lvl(ckey)
	if(plevel >= 3 || tlevel >= 1)
		return TRUE
#endif
	return (ckey in GLOB.whitelist)*/

// HSECTOR EDIT START
/proc/check_whitelist(key)
	if(!SSdbcore.Connect())
		log_world("Failed to connect to database in check_whitelist(). Disabling whitelist for current round.")
		log_game("Failed to connect to database in check_whitelist(). Disabling whitelist for current round.")
		CONFIG_SET(flag/usewhitelist, FALSE)
		return TRUE

	var/datum/DBQuery/query_get_whitelist = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("whitelist")]
		WHERE ckey = :ckey
	"}, list("ckey" = key)
	)

	if(!query_get_whitelist.Execute())
		log_sql("Whitelist check for ckey [key] failed to execute. Rejecting")
		message_admins("Whitelist check for ckey [key] failed to execute. Rejecting")
		qdel(query_get_whitelist)
		return FALSE

	var/allow = query_get_whitelist.NextRow()

	qdel(query_get_whitelist)

	return allow

/client/proc/whitelist_add()
	set category = "Server"
	set name = "Whitelist - Add"
	if(!check_rights(R_ADMIN))
		return
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("SQL is not enabled."))
		return

	var/input_ckey = input("Add which ckey to the whitelist?", "Whitelist Add") as text|null
	if(!input_ckey)
		return
	var/target_ckey = ckey(input_ckey)
	if(!target_ckey)
		to_chat(src, span_warning("Invalid ckey."))
		return
	if(!SSdbcore.Connect())
		to_chat(src, span_warning("Database connection failed; whitelist not updated."))
		return

	var/datum/DBQuery/query_check = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("whitelist")]
		WHERE ckey = :ckey
	"}, list("ckey" = target_ckey))
	if(!query_check.Execute())
		log_sql("Whitelist check for ckey [target_ckey] failed to execute.")
		to_chat(src, span_warning("Whitelist check failed; see SQL logs."))
		qdel(query_check)
		return

	var/exists = query_check.NextRow()
	qdel(query_check)
	if(exists)
		to_chat(src, span_notice("[target_ckey] is already whitelisted."))
		return

	var/datum/DBQuery/query_add = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("whitelist")] (ckey)
		VALUES (:ckey)
	"}, list("ckey" = target_ckey))
	if(!query_add.Execute())
		log_sql("Whitelist insert for ckey [target_ckey] failed to execute.")
		to_chat(src, span_warning("Whitelist insert failed; see SQL logs."))
		qdel(query_add)
		return
	qdel(query_add)

	var/client/C = GLOB.directory[target_ckey]
	if(C)
		C.whitelisted = 2

	log_admin("[key_name(usr)] added [target_ckey] to whitelist.")
	message_admins(span_adminnotice("[key_name_admin(usr)] added [target_ckey] to whitelist."))
	to_chat(src, span_notice("[target_ckey] added to whitelist."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Whitelist Add")

/client/proc/whitelist_remove()
	set category = "Server"
	set name = "Whitelist - Remove"
	if(!check_rights(R_ADMIN))
		return
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("SQL is not enabled."))
		return

	var/input_ckey = input("Remove which ckey from the whitelist?", "Whitelist Remove") as text|null
	if(!input_ckey)
		return
	var/target_ckey = ckey(input_ckey)
	if(!target_ckey)
		to_chat(src, span_warning("Invalid ckey."))
		return
	if(!SSdbcore.Connect())
		to_chat(src, span_warning("Database connection failed; whitelist not updated."))
		return

	var/datum/DBQuery/query_check = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("whitelist")]
		WHERE ckey = :ckey
	"}, list("ckey" = target_ckey))
	if(!query_check.Execute())
		log_sql("Whitelist check for ckey [target_ckey] failed to execute.")
		to_chat(src, span_warning("Whitelist check failed; see SQL logs."))
		qdel(query_check)
		return

	var/exists = query_check.NextRow()
	qdel(query_check)
	if(!exists)
		to_chat(src, span_notice("[target_ckey] is not whitelisted."))
		return

	var/datum/DBQuery/query_remove = SSdbcore.NewQuery({"
		DELETE FROM [format_table_name("whitelist")]
		WHERE ckey = :ckey
	"}, list("ckey" = target_ckey))
	if(!query_remove.Execute())
		log_sql("Whitelist delete for ckey [target_ckey] failed to execute.")
		to_chat(src, span_warning("Whitelist delete failed; see SQL logs."))
		qdel(query_remove)
		return
	qdel(query_remove)

	var/client/C = GLOB.directory[target_ckey]
	if(C)
		C.whitelisted = 2

	log_admin("[key_name(usr)] removed [target_ckey] from whitelist.")
	message_admins(span_adminnotice("[key_name_admin(usr)] removed [target_ckey] from whitelist."))
	to_chat(src, span_notice("[target_ckey] removed from whitelist."))
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Whitelist Remove")

/client/proc/whitelist_check()
	set category = "Server"
	set name = "Whitelist - Check"
	if(!check_rights(R_ADMIN))
		return
	if(!CONFIG_GET(flag/sql_enabled))
		to_chat(src, span_warning("SQL is not enabled."))
		return

	var/input_ckey = input("Check which ckey?", "Whitelist Check") as text|null
	if(!input_ckey)
		return
	var/target_ckey = ckey(input_ckey)
	if(!target_ckey)
		to_chat(src, span_warning("Invalid ckey."))
		return
	if(!SSdbcore.Connect())
		to_chat(src, span_warning("Database connection failed; check failed."))
		return

	var/datum/DBQuery/query_check = SSdbcore.NewQuery({"
		SELECT id FROM [format_table_name("whitelist")]
		WHERE ckey = :ckey
	"}, list("ckey" = target_ckey))
	if(!query_check.Execute())
		log_sql("Whitelist check for ckey [target_ckey] failed to execute.")
		to_chat(src, span_warning("Whitelist check failed; see SQL logs."))
		qdel(query_check)
		return

	var/exists = query_check.NextRow()
	qdel(query_check)
	if(exists)
		to_chat(src, span_notice("[target_ckey] is whitelisted."))
	else
		to_chat(src, span_warning("[target_ckey] is not whitelisted."))

#undef WHITELISTFILE
