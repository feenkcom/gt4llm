Extension { #name : #RBMethodProtocolChange }

{ #category : #'*Gt4LlmCore' }
RBMethodProtocolChange >> gtLlmChangeDescription [
	"A protocol change moves the method, it does not add or modify it"

	^ self changeString asString
]

{ #category : #'*Gt4LlmCore' }
RBMethodProtocolChange >> gtLlmChangeKind [
	^ 'changed method protocol'
]

{ #category : #'*Gt4LlmCore' }
RBMethodProtocolChange >> gtLlmNewSource [
	"Only the protocol of the method changes, not its source"

	^ nil
]
