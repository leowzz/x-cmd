function use_ui_truefalse(status, text, level){
    print "___X_CMD_UI_TF_LEVEL=" level " x ui tf " status " " text";"
}
function handle(_kp, key, level,      i, l, n, id){
    _kp = _kp kp(key)
    l = O[ _kp L]
    for (i=1; i<=l; ++i){
        n = juq( O[ _kp kp(i, "name")] )
        id = ( id=O[ _kp kp(i, "id") ] ) ? " (JOB_ID " id ")" : ""
        use_ui_truefalse( O[ _kp kp(i, "conclusion") ], jqu( n id ), level )
        handle( _kp S jqu(i), "steps", level+1 )
    }
}
END{
    print sprintf( "printf \"%s %s\\\\n\";", juq(O[ kp(1, "jobs", 1, "head_branch")]), juq(O[ kp(1, "jobs", 1, "workflow_name") ] ))
    handle(kp(1), "jobs", level)
}