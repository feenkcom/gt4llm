Extension { #name : #RBRefactoryChange }

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"Add the methods and classes affected by this change to aChangeTargets (a GtLRefactoringChangeTargets).
	By default a change affects no code entity that is reported."

	
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmChangeDescription [
	"Return the description of this change in a refactoring preview. It is computed against the current image, as the kind, so it should be asked before the change is applied"

	^ self changeString asString
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
RBRefactoryChange >> gtLlmChangedSnippet [
	"Return the Lepiter snippet I change, add or remove, or nil when I change code"

	^ nil
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

	^ self gtLlmTargetOfSnippet: aSnippet inPage: aSnippet page
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmTargetOfSnippet: aSnippet inPage: aPageOrNil [
	"Name a changed Lepiter snippet by its uid and page. A snippet that is not added yet has no uid: it is a new snippet"

	^ String
		streamContents: [ :aStream | 
			aSnippet uid
				ifNil: [ aStream nextPutAll: 'new snippet' ]
				ifNotNil: [ :anUid | 
					aStream
						nextPutAll: 'snippet ';
						nextPutAll: anUid uidString ].
			aPageOrNil
				ifNotNil: [ :aPage | 
					aStream
						nextPutAll: ' in page ';
						nextPutAll: aPage title asString ] ]
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmViewChangeTarget [
	"Return how the views of a refactoring preview name what I change. By default my gtLlmChangeTarget, the identifier that the LLM JSON gives"

	^ self gtLlmChangeTarget
]

{ #category : #'*Gt4LlmCore' }
RBRefactoryChange >> gtLlmViewTargetOfSnippet: aSnippet content: aString inPage: aPageOrNil [
	"Name a changed snippet in the views as its change result will: its type, the start of its content and its page"

	^ GtLLepiterSnippetWithContent
		viewTargetOfType: (GtLLepiterSnippetWithContent snippetTypeOf: aSnippet)
		content: aString
		pageTitle: (aPageOrNil ifNotNil: [ :aPage | aPage title asString ])
]
