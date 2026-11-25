Extension { #name : #LeSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmChangeKind [
	^ 'modified snippet'
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry new
		snippet: self snippet;
		yourself
]

{ #category : #'*Gt4LlmCore' }
LeSnippetChange >> gtLlmNewSource [
	^ self newSource
]
