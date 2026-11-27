Extension { #name : #LeAddSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	aChangeTargets addSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmChangeDescription [
	"My changeString is only my class name"

	^ 'Add snippet in '
		, (self gtLlmPageOfParent
				ifNil: [ 'no page' ]
				ifNotNil: [ :aPage | aPage gtDisplayString ])
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmChangeKind [
	^ 'added snippet'
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmChangeTarget [
	"The snippet is not added yet: it is named by the page of its parent"

	^ self gtLlmTargetOfSnippet: self snippet inPage: self gtLlmPageOfParent
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmChangedSnippet [
	^ self snippet
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmNewChangeEntry [
	"The snippet is not added yet: it has no uid, and its page is the one of its parent"

	^ GtLRefactoringSnippetChangeEntry
		fromSnippet: self snippet
		inPage: self gtLlmPageOfParent
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmNewSource [
	^ self snippet contentAsString
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmPageOfParent [
	self parent ifNil: [ ^ nil ].
	^ self parent isSnippet ifTrue: [ self parent page ] ifFalse: [ self parent ]
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmViewChangeTarget [
	"The content of the new snippet, in the page of its parent"

	^ self
		gtLlmViewTargetOfSnippet: self snippet
		content: self gtLlmNewSource
		inPage: self gtLlmPageOfParent
]
