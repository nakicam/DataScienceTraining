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

;PRO CATCH_EXAMPLE
;   ; Define variable A:
;   A = FLTARR(10)
;
;   ; Establish error handler. When errors occur, the index of the
;   ; error is returned in the variable Error_status:
;   CATCH, Error_status
;
;   ;This statement begins the error handler:
;   IF Error_status NE 0 THEN BEGIN
;      PRINT, 'Error index: ', Error_status
;      PRINT, 'Error message: ', !ERROR_STATE.MSG
;
;      ; Handle the error by extending A:
;      A=FLTARR(12)
;      CATCH, /CANCEL
;   ENDIF
;
;   ; Cause an error:
;   A[11]=12
;
;   ; Even though an error occurs in the line above, program
;   ; execution continues to this point because the event handler
;   ; extended the definition of A so that the statement can be 
;   ; re-executed.
;   HELP, A
;END

;conn = odb.connect(user, pswd, sid)
;sql = """select t.name, d.*
;from teams t, array_data d
;where t.pic1_id=d.id
;and t.name='team2'
;"""
;
;cursor = conn.cursor()
;cursor.execute(sql)
;records = cursor.fetchall()
;print(records)

pro abc_test_blob
    ; connect to db
    db = obj_new('IDLdbDatabase')
    db->Connect, DATASOURCE='ABC', USER_ID='abc', PASSWORD='abc'
    
    tic
    sql = 'select t.name, d.*' +$
          ' from teams t, array_data d' +$
          ' where t.pic1_id=d.id' +$
          ' and t.name=''team2''
    print, 'query: ', sql
    
    ; get the record
    rs = obj_new('IDLdbRecordSet', db, n_buffers=1, sql=sql)
    result = rs->MoveCursor(/FIRST)
    if result ne 0 then $
        record = rs->GetRecord() & $
        help, record
 
    id       = record.id
    std      = record.std
    avg      = record.avg
    ndim     = record.ndim
    dim1     = record.dim1
    dim2     = record.dim2
    dim3     = record.dim3
    dim4     = record.dim4
    dtype    = record.dtype
    blob_ptr = ptr_new(*record.value, /no_copy)
    
    ; reconstruct the record
    rgb   = dim3
    xsize = dim2
    ysize = dim1  
    blob_image = fix(*blob_ptr, 0, rgb, xsize, ysize, type=1)
    toc
          
    ; plot it
    help, blob_image
    window, 1, xsize=xsize, ysize=ysize
    TVSCL, blob_image, true=1, /order
    
    ; clean up
    obj_destroy, rs
    obj_destroy, db
end

pro abc_test_blob_object
    ; connect to db
    db = obj_new('IDLdbDatabase')
    db->Connect, DATASOURCE='ABC', USER_ID='abc', PASSWORD='abc'

    tic
    sql =   'select'+$
            '    t.a.ndim as ndim'+$
            '  , t.a.dim1 as dim1'+$
            '  , t.a.dim2 as dim2'+$
            '  , t.a.dim3 as dim3'+$
            '  , t.a.value as value'+$
            '  , t.a.dtype as dtype'+$
            ' from test_blob t'
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
    dim4     = record.dim4
    dtype    = record.dtype
    blob_ptr = ptr_new(*record.value, /no_copy)

    ; reconstruct the record
    rgb   = dim3
    xsize = dim2
    ysize = dim1
    blob_image = fix(*blob_ptr, 0, rgb, xsize, ysize, type=1)
    toc

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