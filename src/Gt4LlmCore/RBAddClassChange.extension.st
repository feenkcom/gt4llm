Extension { #name : #RBAddClassChange }

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmChangeKind [
	"The kind is computed against the current image, so it should be asked before the change is applied"

	^ self changeClass isNil ifTrue: [ 'added class' ] ifFalse: [ 'changed class' ]
]

{ #category : #'*Gt4LlmCore' }
RBAddClassChange >> gtLlmNewSource [
	^ self definition asString
]
