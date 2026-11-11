Extension { #name : #RBCompositeRefactoryChange }

{ #category : #'*Gt4LlmCore' }
RBCompositeRefactoryChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	self changes do: [ :each | each gtLlmAddChangeTargetsTo: aChangeTargets ]
]
