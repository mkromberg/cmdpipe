r←AddNewQ newQS
 eqs←⊆newQS
 QS,←new←⊆(~eqs∊QS)/eqs
 
 isNew←0<≢new
 :If isNew ∧ Q_WORKERS_TABLE≢⍬
   Q_WORKERS_TABLE(,⍤1)←((≢new)⍴0)
 :EndIf

 :If isNew ∧ Q_TODO_TABLE≢⍬
   Q_TODO_TABLE(,⍤1)←((≢new)⍴0)
 :EndIf
r←0