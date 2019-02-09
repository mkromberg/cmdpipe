 r←processFifo message
 ⎕←'INCOMING FIFO MESSAGE: 'message
 TODO←TODO,⊂message
 ⎕←TODO
 r←0
