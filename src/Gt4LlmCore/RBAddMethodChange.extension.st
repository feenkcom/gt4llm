Extension { #name : #RBAddMethodChange }

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	aChangeTargets
		addMethodNamed: self selector
		inClassNamed: self changeClassName
		isMeta: self isMeta
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmChangeKind [
	"The kind is computed against the current image, so it should be asked before the change is applied"

	^ (self changeClass
		ifNotNil: [ :aClass | aClass includesSelector: self selector ]
		ifNil: [ false ]) ifTrue: [ 'modified method' ] ifFalse: [ 'added method' ]
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmChangeTarget [
	^ self displayClassName asString , '>>#' , self selector
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	^ self
		gtLlmMatchesMethodChangeResult: aCodeChangeResult
		selector: self selector
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmNewSource [
	^ self source asString
]
