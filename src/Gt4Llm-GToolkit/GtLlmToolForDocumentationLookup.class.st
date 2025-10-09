Class {
	#name : #GtLlmToolForDocumentationLookup,
	#superclass : #GtLlmAbstractFunctionTool,
	#category : #'Gt4Llm-GToolkit'
}

{ #category : #accessing }
GtLlmToolForDocumentationLookup class >> leJsonV4Name [
	^ #gtLlmToolForDocumentationLookup
]

{ #category : #accessing }
GtLlmToolForDocumentationLookup >> acceptVisitor: aVisitor [
	^ aVisitor visitGtLlmToolForDocumentationLookup: self
]

{ #category : #accessing }
GtLlmToolForDocumentationLookup >> description [
	^ 'Looks up a documentation page by name and returns its content in Markdown format. `pageName` may be a substring. If multiple pages are found, only the first one will be returned.'
]

{ #category : #accessing }
GtLlmToolForDocumentationLookup >> name [
	^ 'lookupDocumentationPage'
]

{ #category : #accessing }
GtLlmToolForDocumentationLookup >> parameters [
	^ #('pageName')
]

{ #category : #accessing }
GtLlmToolForDocumentationLookup >> privatePerformToolCall: aToolCall [
	| arguments pageName pages |
	arguments := aToolCall arguments ifNil: [ Dictionary new ].
	pageName := arguments at: 'pageName' ifAbsent: [ ^ 'Page name not provided' ].
	pages := (LeDatabase gtBook asyncPagesForWord: pageName) toArray wait.
	pages ifEmpty: [ ^ 'No page found' ].
	^ pages first asMarkdownPage
]
