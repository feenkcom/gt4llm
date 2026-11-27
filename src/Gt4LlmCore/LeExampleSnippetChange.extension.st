Extension { #name : #LeExampleSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmAddChangeTargetsTo: aChangeTargets [
	aChangeTargets addSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmChangeKind [
	^ 'modified snippet'
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmChangedSnippet [
	^ self snippet
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry fromSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmNewSource [
	"The annotation of the example snippet once the change is applied, in the form of contentAsString"

	^ '{{gtExample:' , (self snippet asAnnotationStringWithChanges: self updates)
		, '}}'
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmViewChangeTarget [
	"The annotation of the example snippet once the change is applied"

	^ self
		gtLlmViewTargetOfSnippet: self snippet
		content: self gtLlmNewSource
		inPage: self snippet page
]
