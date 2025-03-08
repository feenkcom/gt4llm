Extension { #name : 'GtLlmChatExamples' }

{ #category : '*Gt4Llm-Gemstone' }
GtLlmChatExamples >> assert: aBoolean [
	self
		assert: aBoolean
		description: 'assert is not true'
]

{ #category : '*Gt4Llm-Gemstone' }
GtLlmChatExamples >> assert: aBoolean description: aString [
  | str | 
  aBoolean == true  ifFalse: [
    str := aString .
    str _isExecBlock ifTrue:[ str := aString value ].
    self logFailure: str.
    ^ GtGemStoneAssertionFailure signal: str
  ]
]

{ #category : '*Gt4Llm-Gemstone' }
GtLlmChatExamples >> assert: actual equals: expected [
	self
		assert: actual = expected
		description: actual printString , ' is not equal to ' , expected printString
]
