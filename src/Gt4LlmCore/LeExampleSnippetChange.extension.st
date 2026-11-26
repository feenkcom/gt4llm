Extension { #name : #LeExampleSnippetChange }

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmChangeKind [
	^ 'modified snippet'
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmChangeTarget [
	^ self gtLlmTargetOfSnippet: self snippet
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmNewChangeEntry [
	^ GtLRefactoringSnippetChangeEntry new
		snippet: self snippet;
		yourself
]

{ #category : #'*Gt4LlmCore' }
LeExampleSnippetChange >> gtLlmNewSource [
	"The annotation of the example snippet once the change is applied, in the form of contentAsString"

	^ '{{gtExample:' , (self snippet asAnnotationStringWithChanges: self updates)
		, '}}'
]
