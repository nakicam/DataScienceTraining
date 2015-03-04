pro abc_unit_test
    
    
    ; test get_datatype
;    catch, error
;    if (error ne 0) then begin
;        catch, /cancel
;        ;print, 'ABC_GET_DATATYPE_TEST [error] : ', !error_state.msg
;        return
;    endif
    tests = []
    tests = [tests, {name:'abc_get_datatype', result:abc_test_get_datatype()}]
    
    ; results of unit test
    foreach test, tests do begin
        result_str = test.result ? 'passed' : 'false'
        print, format='(%"ABC_UNIT_TEST : %s %s")', test.name, result_str
    endforeach
    
end