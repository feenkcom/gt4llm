Extension { #name : #LeSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	aChangeTargets addSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmChangeKind [
	^ 'modified snippet'
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmChangedSnippet [
	^ self snippet
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry fromSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmNewSource [
	^ self newSource
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmViewChangeTarget [
	"The new content of the snippet"

	^ self
		gtLlmViewTargetOfSnippet: self snippet
		content: self gtLlmNewSource
		inPage: self snippet page
]
