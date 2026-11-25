Extension { #name : #LeAddSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmChangeKind [
	^ 'added snippet'
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry new
		snippet: self snippet;
		yourself
]

{ #category : #'*Gt4LlmCore' }
LeAddSnippetChange >> gtLlmNewSource [
	^ self snippet contentAsString
]
