Extension { #name : #RBRemoveMethodChange }

{ #category : #'*Gt4LlmCore' }
RBRemoveMethodChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	aChangeTargets
		addMethodNamed: self selector
		inClassNamed: self changeClassName
		isMeta: self isMeta
]

{ #category : #'*Gt4LlmCore' }
RBRemoveMethodChange >> gtLlmChangeKind [
	^ 'removed method'
]

{ #category : #'*Gt4LlmCore' }
RBRemoveMethodChange >> gtLlmChangeTarget [
	^ self displayClassName asString , '>>#' , self selector
]

{ #category : #'*Gt4LlmCore' }
RBRemoveMethodChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	^ self
		gtLlmMatchesMethodChangeResult: aCodeChangeResult
		selector: self selector
]
