Extension { #name : #RBRefactoryClassChange }

{ #category : #'*Gt4LlmCore' }
RBRefactoryClassChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"A class level change affects the (instance side) class it changes"

	aChangeTargets addClassNamed: self changeClassName
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryClassChange >> gtLlmChangeKind [
	^ 'changed class'
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryClassChange >> gtLlmChangeTarget [
	^ self displayClassName asString
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryClassChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	^ aCodeChangeResult isClassChangeResult
		and: [ aCodeChangeResult targetClassName asString = self changeClassName asString ]
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryClassChange >> gtLlmMatchesMethodChangeResult: aCodeChangeResult selector: aSelector [
	"Return true if aCodeChangeResult describes the method named aSelector of the class I change"

	| aReference |
	aCodeChangeResult isMethodChangeResult ifFalse: [ ^ false ].
	aReference := aCodeChangeResult targetMethodReference.
	^ aReference methodClassName asString = self changeClassName asString
		and: [ aReference isClassSide = self isMeta
				and: [ aReference methodName asString = aSelector asString ] ]
]
