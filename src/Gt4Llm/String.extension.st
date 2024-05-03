Extension { #name : #String }

{ #category : #'*Gt4Llm' }
String >> asInstruction [
	^ GtLlmInstructionString new string: self
]
