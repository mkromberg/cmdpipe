 r←ProcessFifo (ic fifoCommand content)
 (Q message)←content
 ⎕←'INCOMING FIFO MESSAGE: ',message

 ic.Respond fifoCommand 'SUCCESS'
 TODO←TODO,⊂content
 ⎕←TODO
 r←0
