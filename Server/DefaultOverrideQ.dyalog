r←message DefaultOverrideQ Q
⍝ add comments
:If (Q ≡ '') ∨ Q≡⍬
  r←DEFAULT
:Else
  r←Q
:EndIf