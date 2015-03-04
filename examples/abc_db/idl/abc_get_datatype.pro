function abc_get_datatype, dtype
    compile_opt idl2

    ; check arguments
    if (n_elements(dtype) eq 0L) then begin
        message, '[abc_get_datatype] dtype parameter not found'
    endif

    ; inital bogus value < 0
    idl_type = -9999L

    ; check each type explicitly -- from numpy
    if (dtype eq 'uint8'     ) then idl_type = 1L
    if (dtype eq 'uint16'    ) then idl_type = 12L
    if (dtype eq 'uint32'    ) then idl_type = 13L
    if (dtype eq 'uint64'    ) then idl_type = 15L
    if (dtype eq 'int8'      ) then idl_type = 1L
    if (dtype eq 'int16'     ) then idl_type = 2L
    if (dtype eq 'int32'     ) then idl_type = 3L
    if (dtype eq 'int64'     ) then idl_type = 14L
    if (dtype eq 'float32'   ) then idl_type = 4L
    if (dtype eq 'float64'   ) then idl_type = 5L
    if (dtype eq 'complex64' ) then idl_type = 6L
    if (dtype eq 'complex128') then idl_type = 9L
    if (dtype eq 'string'    ) then idl_type = 7L

    ; check that a valid type was found
    if (idl_type lt 0L) then begin
        message, '[error] : no conversion found for dtype "' + dtype + '"'
    endif

    ; return valid type
    return, idl_type
end

; test 
function abc_test_get_datatype
    compile_opt idl2
    
;    catch, error
;    if (error ne 0) then begin
;        catch, /cancel
;        ;print, 'ABC_GET_DATATYPE_TEST [error] : ', !error_state.msg
;        return, result
;    endif
       
    dtypes = [                             $
        {name:'uint8'     , value:1L     }, $
        {name:'uint16'    , value:12L    }, $
        {name:'uint32'    , value:13L    }, $
        {name:'uint64'    , value:15L    }, $
        {name:'int8'      , value:1L     }, $
        {name:'int16'     , value:2L     }, $
        {name:'int32'     , value:3L     }, $
        {name:'int64'     , value:14L    }, $
        {name:'float32'   , value:4L     }, $
        {name:'float64'   , value:5L     }, $
        {name:'complex64' , value:6L     }, $
        {name:'complex128', value:9L     }, $
        {name:'string'    , value:7L     }  $
;        {name:'bogus'     , value:-9999L } $
    ]
        
    result = 1B
    foreach dtype, dtypes do begin
        result = result and (abc_get_datatype(dtype.name) eq dtype.value)
    endforeach
    
    return, result
end
