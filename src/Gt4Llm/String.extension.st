Extension { #name : #String }

{ #category : #'*Gt4Llm' }
String >> asInstruction [
	^ GtLlmInstructionString new string: self
]

{ #category : #'*Gt4Llm' }
String >> formatCount [
	"Count the number of arguments #format: would expect."

	| stream counter |
	counter := Set new.
	stream := self readStream.
	[ stream atEnd ]
		whileFalse: [ | currentChar |
			(currentChar := stream next) == ${
				ifTrue: [ | expression |
					expression := stream upTo: $}.
					counter add: expression ]
				ifFalse: [ currentChar == $\
						ifTrue: [ stream atEnd ifFalse: [ stream next ] ] ] ].

	^ counter size
]
