 r←AddNewQ newQS
 ⎕←'TESTING NEW QS: 'newQS
 :If (⊂'WORKER') ∊ newQS
     ∘∘∘

 :EndIf
 eqs←⊆,newQS
 QS,←new←⊆(~eqs∊QS)/eqs

 matpend ←{⍵ (,⍤1) ((≢new) ⍴ 0)}

 isNew←0<≢new
 :If isNew ∧ QvsWORKERS≢⍬
     QvsWORKERS ← matpend QvsWORKERS
 :EndIf

 :If isNew ∧ QvsTASKS≢⍬
     QvsTASKS ← matpend QvsTASKS
 :EndIf
 r←0
