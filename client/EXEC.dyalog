EXEC expr;⎕TRAP;r
DEBUG←1
:If DEBUG
    ⎕TRAP←(777 'C' '→ERROR')(0 'E' 'HandleDebug')
:Else
    ⎕TRAP←0 'C' '→ERROR'
:EndIf

r←⍎expr
⎕←r
⎕←'Process successful. Sending results to server...'

status←(success+1)⊃'ERROR' 'FINISHED'
##.Utils.Check ic.Send commandName('WORKER' ((expr r) status))

→0
ERROR:
  ⎕←'Notify server of error'