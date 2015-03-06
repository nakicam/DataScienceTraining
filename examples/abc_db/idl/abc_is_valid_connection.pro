; -----------------------------------------------------------------------------
;
; function: abc_isvalid_db_object
; Author: Ryan Kelley
; Description: Returns a boolean if a argument is a valid and connected 
;              object of type IDLdbDatabase
; 
; -----------------------------------------------------------------------------

function abc_is_valid_connection, db_obj
    compile_opt idl2

    ; check arguments 
	if (n_params() ne 1) then message, '[error] db_obj parameter undefined'

    ; test if the object is valid
    if (~obj_valid(db_obj)) then return, 0B

    ; test if the object is correct type
    if (~obj_isa(db_obj, 'IDLdbDatabase')) then return, 0B

    ; test if it has a database connection
	db_obj->GetProperty, is_connected=is_connected
    if (~is_connected) then return, 0B

    ; if we're here, then db_obj is good
	return, 1B

end
