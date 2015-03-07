; Class to hold the metadata and row index to array_data

; construct:
; -----------------------------------------------------------------------------

function abc_array_info::init, conn, table_name, col_name, row_id
    compile_opt idl2

    ; assign
    if n_params() ne 4 then message, '[error] incorrect number of args to init'
    self.conn       = conn
    self.table_name = table_name
    self.col_name   = col_name
    self.row_id     = row_id

    ; check boundary conditions:
    if not abc_is_valid_connection(self.conn) then begin
        message, '[error] : conn is not valid'
    endif
    
    ; query 
    sql = string(format='(%"select t.%s.std as std, t.%s.avg as avg, t.%s.dtype as dtype from %s t where t.id=%d")',$
                     self.col_name  ,$
                     self.col_name  ,$
                     self.col_name  ,$
                     self.table_name,$
                     self.row_id     $
                 )

    ; get the record
    rs = obj_new('IDLdbRecordSet', conn, n_buffers=1, sql=sql)
    if rs->MoveCursor(/FIRST) ne 0 then begin 
        record = rs->GetRecord()
    endif

    ; reconstruct the array
    self.array = obj_new('abc_array_handle', conn, table_name, col_name, row_id)
    self.std   = record.std
    self.avg   = record.avg
    self.dtype = record.dtype
    
    ; cleanup
    obj_destroy, rs

    return, 1
end

pro abc_array_info__define
    compile_opt idl2

    void = {abc_array_info                      $
        , conn       : obj_new('IDLdbDatabase') $
        , row_id     : -9999L                   $
        , table_name : ''                       $
        , col_name   : ''                       $
        , avg        : -9999.9D                 $
        , std        : -9999.9D                 $
        , dtype      : ''                       $
        , array      : obj_new()                $
    }
    return
end

; destroy:
; -----------------------------------------------------------------------------

pro abc_array_info::cleanup
    compile_opt idl2

    obj_destroy, self.array
    return
end

; methods: 
; -----------------------------------------------------------------------------

function abc_array_info::is_loaded
    compile_opt idl2

    return, (self.array->is_loaded())
end

pro abc_array_info::load
    compile_opt idl2

    self.load
end

pro abc_array_info::clear
    compile_opt idl2

;    obj_destroy, self.array
    return
end
        
function abc_array_info::get
    compile_opt idl2
    
    return, self.array->get()
end

function abc_array_info::avg
    return, self.avg
end

function abc_array_info::std
    return, self.std
end

function abc_array_info::dtype
    return, self.dtype
end

function abc_array_info::shape
    compile_opt idl2

    if not self->is_loaded() then begin
        return, [] 
    endif
    return, size(self.array, /dimensions)
end

function abc_array_info::to_string
    compile_opt idl2
    
    if not self->is_loaded() then begin
        shape_str = '(not loaded)' 
    endif else begin
        shape = self->shape()
        ndim = n_elements(shape)
        dim1 = shape[0]
        dim2 = shape[1]
        dim3 = shape[2]
        dim4 = shape[3]
        case ndim of
            1L : shape_str = string(dim1 , format='%("(%d)")'            ) 
            2L : shape_str = string(dim1, dim2 , format='%("(%d, %d)")'        ) 
            3L : shape_str = string(dim1, dim2, dim3 , format='%("(%d, %d)")'        ) 
            4L : shape_str = string(dim1, dim2, dim3, dim4 , format='%("(%d, %d, %d, %d)")') 
        endcase
    endelse
        
    str = string(self.avg, self.std, self.dtype, shape_str,                    $
            format='(%"ArrayInfo{avg: %1.4f, std: %1.4f, dtype: %10s, shape: %13s}")')


    return, str
end

function abc_array_info::_overloadPrint
    compile_opt idl2
    return, self->to_string()
end

function abc_array_info::_overloadimpliedprint, varname
    compile_opt idl2
    return, self->abc_array_info::_overloadprint()
end

; tests: 
; -----------------------------------------------------------------------------

function abc_array_info_test, conn
    a = obj_new('abc_array_info', conn, "teams", "pic1", 2)
    print, a

    a->load
    print, a

    a->clear
    print, a
    
;     ; plot it
;     help, blob_image
;     window, 1, xsize=xsize, ysize=ysize
;     TVSCL, blob_image, true=1, /order

    ; clean up
    obj_destroy, a
end
