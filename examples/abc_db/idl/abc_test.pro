pro abc_test_connection

    ; connect to db
    db = obj_new('IDLdbDatabase')
    db->Connect, DATASOURCE='ABC', USER_ID='abc', PASSWORD='abc'
    
    db->GetProperty, is_connected=status
    if status then begin
        print, 'database connected'
    endif else begin
        print, 'database NOT connected'
    endelse
    
    ; clean up
    obj_destroy, db
end

pro abc_test_blob
    ; connect to db
    db = obj_new('IDLdbDatabase')
    db->Connect, DATASOURCE='ABC', USER_ID='abc', PASSWORD='abc'

    sql =   'select'+$
            '    t.pic1.ndim  as ndim'+$
            '  , t.pic1.dim1  as dim1'+$
            '  , t.pic1.dim2  as dim2'+$
            '  , t.pic1.dim3  as dim3'+$
            '  , t.pic1.value as value'+$
            '  , t.pic1.dtype as dtype'+$
            ' from teams t'
    print, 'query: ', sql

    ; get the record
    rs = obj_new('IDLdbRecordSet', db, n_buffers=1, sql=sql)
    result = rs->MoveCursor(/FIRST)
    if result ne 0 then $
        record = rs->GetRecord() & $
        help, record

    ndim     = record.ndim
    dim1     = record.dim1
    dim2     = record.dim2
    dim3     = record.dim3
    dtype    = record.dtype
    blob_ptr = ptr_new(*record.value, /no_copy)

    ; reconstruct the record
    rgb   = dim3
    xsize = dim2
    ysize = dim1
    blob_image = fix(*blob_ptr, 0, rgb, xsize, ysize, type=1)

    ; plot it
    help, blob_image
    window, 1, xsize=xsize, ysize=ysize
    TVSCL, blob_image, true=1, /order

    ; clean up
    obj_destroy, rs
    obj_destroy, db
end

pro abc_test
    print, format='(%"\n[abc_test_connection]")'
    abc_test_connection
    
    print, format='(%"\n[abc_test_blob]")'
    abc_test_blob
    toc
    
    print, format='(%"\n[abc_test] create a connection to test UI")'
    db = obj_new('IDLdbDatabase')
    db->Connect, DATASOURCE='ABC', USER_ID='abc', PASSWORD='abc'
    if abc_is_valid_connection(db) then begin
        print, 'database connected'
    endif else begin
        print, 'database NOT connected'
    endelse
    
    
    
    obj_destroy, db
    print, format='(%"\n[abc_test] check that all objects are cleaned up...")'
    help, /heap
end