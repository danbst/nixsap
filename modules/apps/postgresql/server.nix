{ lib, ... }:
let

  inherit (lib) mkOption mkOptionType mkIf types isInt isString
                all length splitString stringToCharacters filter;
  inherit (types) either enum attrsOf nullOr listOf str path lines int bool;
  inherit (builtins) toString match;

  default = d: t: mkOption { type = t; default = d; };
  mandatory = t: mkOption { type = t; };
  optional = t: mkOption { type = nullOr t; default = null; };

  isFloat = x: match "^[0-9]+(\\.[0-9]+)?$" (toString x) != null;

  float = mkOptionType {
    name = "positive float";
    check = isFloat;
  };

in {
  options = {
    DateStyle = optional str;
    IntervalStyle = optional (enum [ "sql_standard" "postgres_verbose" "iso_8601" ]);
    TimeZone = optional str;
    application_name = optional str;
    archive_command = optional path;
    archive_mode = optional bool;
    archive_timeout = optional int;
    array_nulls = optional bool;
    authentication_timeout = optional int;
    autovacuum = optional bool;
    autovacuum_analyze_scale_factor = optional float;
    autovacuum_analyze_threshold = optional int;
    autovacuum_freeze_max_age = optional int;
    autovacuum_max_workers = optional int;
    autovacuum_multixact_freeze_max_age = optional int;
    autovacuum_naptime = optional int;
    autovacuum_vacuum_cost_delay = optional int;
    autovacuum_vacuum_cost_limit = optional int;
    autovacuum_vacuum_scale_factor = optional float;
    autovacuum_vacuum_threshold = optional int;
    autovacuum_work_mem = optional int;
    backslash_quote = optional (enum [ "on" "off" "safe_encoding" ]);
    bgwriter_delay = optional int;
    bgwriter_lru_maxpages = optional int;
    bgwriter_lru_multiplier = optional int;
    bytea_output = optional (enum [ "hex" "escape" ]);
    check_function_bodies = optional bool;
    checkpoint_completion_target = optional float;
    checkpoint_segments = optional int;
    checkpoint_timeout = optional int;
    checkpoint_warning = optional int;
    client_encoding = optional str;
    client_min_messages = optional (enum [ "DEBUG5" "DEBUG4" "DEBUG3" "DEBUG2" "DEBUG1" "LOG" "NOTICE" "WARNING" "ERROR" "FATAL" "PANIC" ]);
    commit_delay = optional int;
    commit_siblings = optional int;
    constraint_exclusion = optional (enum [ "on" "partition" "off" ]);
    cpu_index_tuple_cost = optional float;
    cpu_operator_cost = optional float;
    cpu_tuple_cost = optional float;
    cursor_tuple_fraction = optional float;
    data_directory = mandatory path;
    deadlock_timeout = optional int;
    debug_pretty_print = optional bool;
    debug_print_parse = optional bool;
    debug_print_plan = optional bool;
    debug_print_rewritten = optional bool;
    default_statistics_target = optional int;
    default_tablespace = optional str;
    default_text_search_config = optional str;
    default_transaction_deferrable = optional bool;
    default_transaction_isolation = optional (enum [ "read uncommitted" "read committed" "repeatable read" "serializable" ]);
    default_transaction_read_only = optional bool;
    default_with_oids = optional bool;
    dynamic_shared_memory_type = optional (enum [ "posix" "sysv" "mmap" "none" ]);
    effective_cache_size = optional int;
    effective_io_concurrency = optional int;
    enable_bitmapscan = optional bool;
    enable_hashagg = optional bool;
    enable_hashjoin = optional bool;
    enable_indexonlyscan = optional bool;
    enable_indexscan = optional bool;
    enable_material = optional bool;
    enable_mergejoin = optional bool;
    enable_nestloop = optional bool;
    enable_seqscan = optional bool;
    enable_sort = optional bool;
    enable_tidscan = optional bool;
    escape_string_warning = optional bool;
    exit_on_error = optional bool;
    extra_float_digits = optional int;
    from_collapse_limit = optional int;
    fsync = optional bool;
    full_page_writes = optional bool;
    geqo = optional bool;
    geqo_effort = optional int;
    geqo_generations = optional int;
    geqo_pool_size = optional int;
    geqo_seed = optional float;
    geqo_selection_bias = optional float;
    geqo_threshold = optional int;
    hba_file = default "" lines;
    hot_standby = optional bool;
    hot_standby_feedback = optional bool;
    huge_pages = optional (enum [ "on" "off" "try" ]);
    ident_file = default "" lines;
    join_collapse_limit = optional int;
    lc_messages = optional str;
    lc_monetary = optional str;
    lc_numeric = optional str;
    lc_time = optional str;
    listen_addresses = optional (either (listOf str) str);
    lo_compat_privileges = optional bool;
    lock_timeout = optional int;
    log_autovacuum_min_duration = optional int;
    log_checkpoints = optional bool;
    log_connections = optional bool;
    log_destination = optional (enum [ "stderr" "csvlog" "syslog" ]);
    log_directory  = optional path;
    log_disconnections = optional bool;
    log_duration = optional bool;
    log_error_verbosity = optional (enum [ "TERSE" "DEFAULT" "VERBOSE" ]);
    log_executor_stats = optional bool;
    log_filename  = optional str;
    log_hostname = optional bool;
    log_line_prefix = optional str;
    log_lock_waits = optional bool;
    log_min_duration_statement = optional int;
    log_min_error_statement = optional (enum [ "DEBUG5" "DEBUG4" "DEBUG3" "DEBUG2" "DEBUG1" "LOG" "NOTICE" "WARNING" "ERROR" "FATAL" "PANIC" ]);
    log_min_messages = optional (enum [ "DEBUG5" "DEBUG4" "DEBUG3" "DEBUG2" "DEBUG1" "LOG" "NOTICE" "WARNING" "ERROR" "FATAL" "PANIC" ]);
    log_parser_stats = optional bool;
    log_planner_stats = optional bool;
    log_rotation_age = optional int;
    log_rotation_size = optional int;
    log_statement = optional (enum [ "none" "ddl" "mod" "all" ]);
    log_statement_stats = optional bool;
    log_temp_files = optional int;
    log_timezone = optional str;
    log_truncate_on_rotation = optional bool;
    logging_collector = optional bool;
    maintenance_work_mem = optional int;
    max_connections = optional int;
    max_files_per_process = optional int;
    max_locks_per_transaction = optional int;
    max_pred_locks_per_transaction = optional int;
    max_prepared_transactions = optional int;
    max_replication_slots = optional int;
    max_stack_depth = optional int;
    max_standby_archive_delay = optional int;
    max_standby_streaming_delay = optional int;
    max_wal_senders = optional int;
    max_worker_processes = optional int;
    password_encryption = optional bool;
    port = default 5432 int;
    quote_all_identifiers = optional bool;
    random_page_cost = optional float;
    restart_after_crash = optional bool;
    search_path = optional (either (listOf str) str);
    seq_page_cost = optional float;
    session_replication_role = optional (enum [ "origin" "replica" "local" ]);
    shared_buffers = optional int;
    sql_inheritance = optional bool;
    ssl = optional bool;
    ssl_ca_file = optional path;
    ssl_cert_file = optional path;
    ssl_ciphers = optional str;
    ssl_crl_file = optional path;
    ssl_ecdh_curve = optional str;
    ssl_key_file = optional path;
    ssl_prefer_server_ciphers = optional bool;
    ssl_renegotiation_limit = optional int;
    standard_conforming_strings = optional bool;
    statement_timeout = optional int;
    stats_temp_directory = optional path;
    superuser_reserved_connections = optional int;
    synchronize_seqscans = optional bool;
    synchronous_commit = optional (enum [ "on" "remote_write" "local" "off" ]);
    synchronous_standby_names = optional (either (listOf str) str);
    syslog_ident = optional str;
    tcp_keepalives_count = optional int;
    tcp_keepalives_idle = optional int;
    tcp_keepalives_interval = optional int;
    temp_buffers = optional int;
    temp_file_limit = optional int;
    temp_tablespaces = optional str;
    timezone_abbreviations = optional str;
    track_activities = optional bool;
    track_activity_query_size = optional int;
    track_counts = optional bool;
    track_functions = optional (enum [ "none" "pl" "all" ]);
    track_io_timing = optional bool;
    transform_null_equals = optional bool;
    update_process_title = optional bool;
    vacuum_cost_delay = optional int;
    vacuum_cost_limit = optional int;
    vacuum_cost_page_dirty = optional int;
    vacuum_cost_page_hit = optional int;
    vacuum_cost_page_miss = optional int;
    vacuum_defer_cleanup_age = optional int;
    vacuum_freeze_min_age = optional int;
    vacuum_freeze_table_age = optional int;
    vacuum_multixact_freeze_min_age = optional int;
    vacuum_multixact_freeze_table_age = optional int;
    wal_buffers = optional int;
    wal_keep_segments = optional int;
    wal_level = optional (enum [ "minimal" "archive" "hot_standby" "logical" ]);
    wal_log_hints = optional bool;
    wal_receiver_status_interval = optional int;
    wal_receiver_timeout = optional int;
    wal_sender_timeout = optional int;
    wal_sync_method = optional (enum [ "open_datasync" "fdatasync" "fsync" "fsync_writethrough" "open_sync" ]);
    wal_writer_delay = optional int;
    work_mem = optional int;
    xmlbinary = optional (enum [ "base64" "hex" ]);
    xmloption = optional (enum [ "DOCUMENT" "CONTENT" ]);
  };
}
