; Class to hold the metadata and row index to array_data

; construct:
; -----------------------------------------------------------------------------

function abc_ArrayHandle::init, conn, array_id
    ; assign
    if n_elements(conn)     ne 0 then self.conn    = conn
    if n_elements(array_id) ne 0 then self.array_id = array_id
    
    ; check boundary conditions:
    if not abc_is_valid_connection(self.conn) then begin
        message, '[error] : conn is not valid'
    endif
    
    return, 1
end

pro abc_ArrayHandle__define
    void = {abc_ArrayHandle              $
        , conn : obj_new('IDLdbDatabase')$
        , array_id : -9999L              $
        , value : obj_new()              $
        }
    return
end


;
;
;
;
;class ArrayHandle(object):
;
;def __init__(self, conn, array_id):
;self.conn = conn
;self.array_id = array_id
;self.value = None
;
;def IsLoaded(self):
;return (self.value != None)
;
;def Load(self):
;# load the data
;try:
;sql = """
;select
;d.ndim
;, d.dim1
;, d.dim2
;, d.dim3
;, d.dim4
;, d.dtype
;, d.value
;from array_data d where d.id=%d
;""" % self.array_id
;cursor = self.conn.cursor()
;cursor.execute(sql)
;record = cursor.fetchone()
;
;# reconstruct array
;ndim   = record[0]
;dim1   = record[1]
;dim2   = record[2]
;dim3   = record[3]
;dim4   = record[4]
;dtype  = GetDataType(record[5])
;blob   = record[6]
;value  = np.array(array.array('B', blob.read()), dtype=dtype)
;if   ndim == 1: value = value.reshape((dim1,))
;elif ndim == 2: value = value.reshape((dim1,dim2))
;elif ndim == 3: value = value.reshape((dim1,dim2,dim3))
;elif ndim == 4: value = value.reshape((dim1,dim2,dim3,dim4))
;self.value = value
;
;# TODO: think about this part..
;except odb.DatabaseError, exc:
;print(exc)
;except:
;print('some other error')
;finally:
;cursor.close()
;
;def Clear(self):
;self.value = None
;
;def Get(self):
;if not self.IsLoaded():
;self.Load()
;return self.value
;
;h = ArrayHandle(conn, 1)
;print(h.value)
;h.Load()
;print(h.IsLoaded())
;print(h.value.shape)
;h.Clear()
;print(h.IsLoaded())
;print(h.value)
;print(h.Get().shape)
;print(h.IsLoaded())