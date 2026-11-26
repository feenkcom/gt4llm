Extension { #name : #RBAddMethodChange }

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	aChangeTargets
		addMethodNamed: self selector
		inClassNamed: self changeClassName
		isMeta: self isMeta
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmChangeDescription [
	"RB describes every compiled method as added, see changeString; describe a method that the class already defines as modified, consistent with the kind"

	^ (self gtLlmIsModification
		ifTrue: [ 'Modify <1s>>>#<2s>' ]
		ifFalse: [ 'Add <1s>>>#<2s>' ])
		expandMacrosWith: self displayClassName
		with: self selector
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmChangeKind [
	"The kind is computed against the current image, so it should be asked before the change is applied"

	^ self gtLlmIsModification
		ifTrue: [ 'modified method' ]
		ifFalse: [ 'added method' ]
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmChangeTarget [
	^ self displayClassName asString , '>>#' , self selector
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmIsModification [
	"Return whether the class already defines the method, so that compiling it modifies the method. Overriding a method that the class only gets from a trait adds a method. Computed against the current image, so it should be asked before the change is applied"

	^ self changeClass
		ifNotNil: [ :aClass | aClass includesLocalSelector: self selector ]
		ifNil: [ false ]
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	^ self
		gtLlmMatchesMethodChangeResult: aCodeChangeResult
		selector: self selector
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringMethodChangeEntry new
		methodClassName: self changeClassName asString;
		methodName: self selector asString;
		classSide: self isMeta = true;
		yourself
]

{ #category : #'*Gt4LlmCore' }
RBAddMethodChange >> gtLlmNewSource [
	^ self source asString
]
