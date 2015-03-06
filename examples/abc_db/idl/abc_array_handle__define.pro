; Class to evaluate the array "lazily"

; construct:
; -----------------------------------------------------------------------------

function abc_array_handle::init, conn, table_name, col_name, row_id
    compile_opt idl2

    ; assign
    if n_params() ne 4 then message, '[error] incorrect number of args to init: ', n_params()
    self.conn       = conn
    self.table_name = table_name
    self.col_name   = col_name
    self.row_id     = row_id
    
    ; check boundary conditions:
    if not abc_is_valid_connection(self.conn) then begin
        message, '[error] : conn is not valid'
    endif
    
    return, 1
end

pro abc_array_handle__define
    compile_opt idl2

    void = {abc_array_handle                    $
        , conn       : obj_new('IDLdbDatabase') $
        , row_id     : -9999LL                  $
        , table_name : ''                       $
        , col_name   : ''                       $
        , value      : ptr_new()                $
;         , ndim       : -9999S                   $
;         , dim1       : -9999S                   $
;         , dim2       : -9999S                   $
;         , dim3       : -9999S                   $
;         , dim4       : -9999S                   $
;         , dtype      : -9999S                   $ 
    }
    return
end

; destroy:
; -----------------------------------------------------------------------------

pro abc_array_handle::cleanup
    compile_opt idl2

    ptr_free, self.value
    return
end

; methods: 
; -----------------------------------------------------------------------------

function abc_array_handle::is_loaded
    compile_opt idl2

    return, (self.value ne !null)
end

pro abc_array_handle::load
    compile_opt idl2

    ; build query
    sql = string(format='(%"select '        +$
                 '  t.%s.ndim as ndim '     +$
                 ', t.%s.dim1 as dim1 '     +$
                 ', t.%s.dim2 as dim2 '     +$
                 ', t.%s.dim3 as dim3 '     +$
                 ', t.%s.dim4 as dim4 '     +$
                 ', t.%s.dtype as dtype '   +$
                 ', t.%s.value as value '   +$
                 'from %s t where t.id=%d")',$
                 self.col_name  ,$
                 self.col_name  ,$
                 self.col_name  ,$
                 self.col_name  ,$
                 self.col_name  ,$
                 self.col_name  ,$
                 self.col_name  ,$
                 self.table_name,$
                 self.row_id     $
                 )

    ; get the record
    rs = obj_new('IDLdbRecordSet', self.conn, n_buffers=1, sql=sql)
    if rs->MoveCursor(/FIRST) ne 0 then begin 
        record = rs->GetRecord()
    endif

    ; reconstruct the array
    ndim      = uint(record.ndim)
    dim1      = uint(record.dim1)
    dim2      = uint(record.dim2)
    dim3      = uint(record.dim3)
    dim4      = uint(record.dim4)
    dtype     = string(record.dtype)
    idl_dtype = abc_get_idl_dtype(dtype)
    blob_ptr  = ptr_new(*record.value, /no_copy)
    case ndim of
        1L : self.value = ptr_new(fix(*(blob_ptr), 0, dim1                  , type=idl_dtype))
        2L : self.value = ptr_new(fix(*(blob_ptr), 0, dim1, dim2            , type=idl_dtype))
        3L : self.value = ptr_new(fix(*(blob_ptr), 0, dim1, dim2, dim3      , type=idl_dtype))
        4L : self.value = ptr_new(fix(*(blob_ptr), 0, dim1, dim2, dim3, dim4, type=idl_dtype))
    endcase

    ; cleanup
    ptr_free, record.value
    obj_destroy, rs
end

pro abc_array_handle::clear
    compile_opt idl2

    ptr_free, self.value
    return
end
        
function abc_array_handle::get
    compile_opt idl2
    
    ; only read from the DB if the value
    ; is not already loaded
    if (~self.is_loaded()) then begin
        self.load
    end
    return, *(self.value)
end
