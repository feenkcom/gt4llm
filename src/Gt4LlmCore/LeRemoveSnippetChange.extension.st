Extension { #name : #LeRemoveSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmChangeKind [
	^ 'removed snippet'
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeRemoveSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry new
		snippet: self snippet;
		yourself
]
