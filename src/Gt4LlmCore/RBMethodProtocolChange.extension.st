Extension { #name : #RBMethodProtocolChange }

{ #category : #'*Gt4LlmCore' }
RBMethodProtocolChange >> gtLlmChangeKind [
	^ 'changed method protocol'
]

{ #category : #'*Gt4LlmCore' }
RBMethodProtocolChange >> gtLlmNewSource [
	"Only the protocol of the method changes, not its source"

	^ nil
]
