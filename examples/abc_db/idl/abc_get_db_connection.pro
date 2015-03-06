function abc_get_db_connection
    compile_opt idl2

    conn = obj_new('IDLdbDatabase')
    conn->Connect, DATASOURCE='ABC', USER_ID='abc', PASSWORD='abc'
    is_connected = abc_is_valid_connection(conn)
    if is_connected then begin
        return, conn
    endif else begin
        message, '[error] db_obj parameter undefined'
    endelse
end