Extension { #name : #RBRemoveClassChange }

{ #category : #'*Gt4LlmCore' }
RBRemoveClassChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"A removed class affects its subclasses and all their methods"

	aChangeTargets addRemovedClassNamed: self changeClassName
]

{ #category : #'*Gt4LlmCore' }
RBRemoveClassChange >> gtLlmChangeKind [
	^ 'removed class'
]
