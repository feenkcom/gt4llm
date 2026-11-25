Extension { #name : #RBRefactoryChange }

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"Add the methods and classes affected by this change to aChangeTargets (a GtLRefactoringChangeTargets).
	By default a change affects no code entity that is reported."

	
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmChangeKind [
	"Return a short label of the kind of this change, used to describe refactoring previews to an LLM"

	^ 'other'
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmChangeTarget [
	"Return the name of the method, variable, class or package affected by this change"

	^ self changeString asString
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmMatchesCodeChangeResult: aCodeChangeResult [
	"Return true if aCodeChangeResult (a GtLCodeChangeResult) describes the method or class that I change"

	^ false
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmNewChangeEntry [
	"Return the entry that lists me in the groups of changes of a refactoring report"

	^ GtLRefactoringOtherChangeEntry new
		target: self gtLlmChangeTarget asString;
		yourself
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmNewSource [
	"Return the code or text introduced by this change, or nil if the change does not carry any"

	^ nil
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmPreviewChanges [
	"Return the refactoring changes (GtLRefactoringChange) that describe me in a refactoring preview"

	^ {GtLRefactoringChange fromChange: self}
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmTargetOfSnippet: aSnippet [
	"Name a changed Lepiter snippet by its uid and page"

	^ String
		streamContents: [ :aStream | 
			aStream
				nextPutAll: 'snippet ';
				nextPutAll: aSnippet uid uidString.
			aSnippet page
				ifNotNil: [ :aPage | 
					aStream
						nextPutAll: ' in page ';
						nextPutAll: aPage title asString ] ]
]
