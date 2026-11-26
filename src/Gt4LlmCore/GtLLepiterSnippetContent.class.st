"
I am the content of a Lepiter snippet, copied when a snapshot ({{gtClass:GtLLepiterSnippetWithContent}}) is taken. I hold strings only, never an object of the snippet.

`contentString` is the text that is diffed; {{gtMethod:GtLLepiterSnippetContent>>#diffElementFrom:to:}} shows the diff of two content strings, split and styled as I am. {{gtMethod:GtLLepiterSnippetContent class>>#fromSnippet:}} asks the snippet for its kind of content (`gtLlmSnippetContent`):
- {{gtClass:GtLLepiterSnippetStringContent}} for textual snippets, and for example snippets, as their annotation;
- {{gtClass:GtLLepiterSnippetPropertiesContent}} for the others.
"
Class {
	#name : #GtLLepiterSnippetContent,
	#superclass : #Object,
	#category : #'Gt4LlmCore-Magritte Objects'
}

{ #category : #'instance creation' }
GtLLepiterSnippetContent class >> fromSnippet: aSnippet [
	"Copy the content of aSnippet. The snippet chooses its kind of content: a string for a textual snippet, its specific properties for the others"

	^ aSnippet gtLlmSnippetContent
]

{ #category : #comparing }
GtLLepiterSnippetContent >> = anObject [
	self == anObject ifTrue: [ ^ true ].
	^ self class = anObject class
		and: [ self contentString = anObject contentString ]
]

{ #category : #accessing }
GtLLepiterSnippetContent >> contentString [
	"Return the text that is shown and diffed"

	^ self subclassResponsibility
]

{ #category : #diff }
GtLLepiterSnippetContent >> diffElementFrom: anOldString to: aNewString [
	"Return a diff element of two strings, split and styled as my content"

	| aStencil |
	aStencil := GtDiffElementWithLabelStencil new
			fromLabelText: 'Old content:';
			toLabelText: 'New content:';
			change: (GtDiffBuilder
					computeDifferencesFrom: anOldString
					to: aNewString
					using: self diffSplitter);
			yourself.
	self diffStyler ifNotNil: [ :aStyler | aStencil styler: aStyler ].
	^ aStencil asElement
]

{ #category : #diff }
GtLLepiterSnippetContent >> diffSplitter [
	^ GtLineDiffSplitter new
]

{ #category : #diff }
GtLLepiterSnippetContent >> diffStyler [
	"Return the styler of the diff, or nil for plain text"

	^ nil
]

{ #category : #views }
GtLLepiterSnippetContent >> gtContentFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Content';
		priority: 5;
		text: [ self contentString ]
]

{ #category : #comparing }
GtLLepiterSnippetContent >> hash [
	^ self class hash bitXor: self contentString hash
]

{ #category : #printing }
GtLLepiterSnippetContent >> printOn: aStream [
	super printOn: aStream.
	aStream
		parenthesize: [ aStream nextPutAll: (self contentString truncateTo: 60) ]
]
