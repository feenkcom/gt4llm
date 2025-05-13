Extension { #name : #GtLlmAssistantActionExample }

{ #category : #'*Gt4Llm-Gemstone' }
GtLlmAssistantActionExample >> assert: aBoolean description: aString [
  | str | 
  aBoolean == true  ifFalse: [
    str := aString .
    str _isExecBlock ifTrue:[ str := aString value ].
    self logFailure: str.
    ^ GtGemStoneAssertionFailure signal: str
  ]
]
