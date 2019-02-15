 r←ProcessFifo (ic fifoCommand message)
 ⎕←'INCOMING FIFO MESSAGE: 'message

 ic.Respond fifoCommand 'SUCCESS'
 TODO←TODO,⊂message
 ⎕←TODO
 r←0
