Extension { #name : #LeRemoveSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	"The descendants of the snippet are removed with it"

	aChangeTargets addRemovedSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmChangeDescription [
	"My changeString is only my class name"

	^ 'Remove snippet in '
		, (self snippet page
				ifNil: [ 'no page' ]
				ifNotNil: [ :aPage | aPage gtDisplayString ])
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmChangeKind [
	^ 'removed snippet'
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmChangedSnippet [
	^ self snippet
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry fromSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmViewChangeTarget [
	"The current content of the snippet, which the change removes"

	^ self
		gtLlmViewTargetOfSnippet: self snippet
		content: self snippet gtLlmSnippetContent contentString
		inPage: self snippet page
]
